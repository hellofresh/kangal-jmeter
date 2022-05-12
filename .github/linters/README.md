# Super-Linter configuration files

These are repository-specific linter configs used by GitHub [super-linter][super-linter].

Default configs are loaded in the following order:

- HF-specific defaults that can be found at [jetstream-ci-scripts repository][jetstream-ci-scripts-linters]
- super-linter defaults that can be found at [super-linter repository][super-linter-templates]

If you want to override any of them - put your own into this dir and linting action will use it.

<!-- @formatter:off -->
[super-linter]: https://github.com/github/super-linter
[jetstream-ci-scripts-linters]: https://github.com/hellofresh/jetstream-ci-scripts/tree/master/actions/linter-configs/linters
[super-linter-templates]: https://github.com/github/super-linter/tree/main/TEMPLATES
