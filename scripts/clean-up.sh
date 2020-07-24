#!/usr/bin/env bash
set -e

PER_PAGE=100
IMAGE_NAMES=$(echo "${IMAGE_NAMES}" | tr -d '[]'| tr -d '\\"' | tr ',' ' ')

# Get number of all open PR's pages
PAGES=$(curl -I --silent --get "https://${GITHUB_TOKEN}@api.github.com/repos/${GITHUB_REPO}/pulls?state=open&per_page=${PER_PAGE}" | grep  "Link" | grep -Eo "&page=(\\d)+" | grep -Eo "\\d+" | sed -n 2p)
PAGES=$((PAGES + 0))
if [[ ${PAGES} -eq 0 ]]; then
  PAGES=1
fi

# Get all open PR's
OPEN_PRS=""
i=1
while [[ ${i} -le ${PAGES} ]]; do
  p=$(curl --silent --get "https://${GITHUB_TOKEN}@api.github.com/repos/${GITHUB_REPO}/pulls?state=open&per_page=${PER_PAGE}&page=${i}"  | jq -r '.[] | .number' | sed -e 's/^/pr-/')
  i=$(( i + 1 ))
done
OPEN_PRS=${p}
OPEN_PR_COUNT=$(echo "${p}" | wc -l)
OPEN_PR_COUNT=$((OPEN_PR_COUNT + 0))
echo "Found ${OPEN_PR_COUNT} open PR's"

# Requesting DockerHub token
HUB_TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d "{\"username\": \"${DOCKER_USERNAME}\", \"password\": \"${DOCKER_PASSWORD}\"}" https://hub.docker.com/v2/users/login/ | jq -r .token)

for IMAGE_NAME in ${IMAGE_NAMES}; do
  printf "\\nStarting docker images cleanup for %s\\n" "${IMAGE_NAME}"

  # Counting the number of artifacts in DockerHub
  IMAGE_DRAFTS=""
  IMAGE_DRAFTS=$(curl --silent GET -H "Accept: application/json" -H "Authorization: JWT $HUB_TOKEN" https://hub.docker.com/v2/repositories/"${DOCKER_USERNAME}"/"${IMAGE_NAME}"/tags | jq '.count' )
  if [[ "$IMAGE_DRAFTS" -eq 0 ]]; then
      break
  fi
  echo "The number of found images in DockerHub is $IMAGE_DRAFTS"

  NAMES=$(curl --silent GET -H "Accept: application/json" -H "Authorization: JWT $HUB_TOKEN" https://hub.docker.com/v2/repositories/"${DOCKER_USERNAME}"/"${IMAGE_NAME}"/tags | jq -r ' .results[].name')
  echo "The following draft images found: ${NAMES}"

  # Loop over PR drafts and remove PR's releases that aren't open
  for IMAGE_DRAFT in ${NAMES}; do
    if [[ "${IMAGE_DRAFT}" == PR-* ]]; then
      printf "\\nDraft image - %s: " "${IMAGE_DRAFT}"
      for OPEN_PR in ${OPEN_PRS}; do
        if [[ "${IMAGE_DRAFT}" == "${OPEN_PR}" ]]; then
            printf "\\nSkipping image deletion for active PRs\\n"
            continue 2
        fi
       done
    printf "\\nDelete draft image %s: " "${IMAGE_DRAFT}"
    curl --silent -i -X DELETE -H "Accept: application/json" -H "Authorization: JWT $HUB_TOKEN" https://hub.docker.com/v2/repositories/"${DOCKER_USERNAME}"/"${IMAGE_NAME}"/tags/"${IMAGE_DRAFT}"/
    printf "done\\n"
    fi
  done
  printf "Completed!\\n"
done
