# Contributing

Thank you so much for contributing to PopupDialog! We have put together a few things that are important for us and are hoprefully helpful for you.

## Adding new features

We try to keep this project as simple and easy to use as possible. That is why we also try to stick to adding only functionality that a broader group of people can benefit from. Consequently, not all feature ideas might make it to the library. A good place to discuss new features, improvements and enhancements is the GitHub issue tracker.

## Breaking changes
Gernerally speaking, try not to introduce breaking changes for small updates. On the other hand, do not fear to introduce them where it makes sense either. Please be aware, however, that breaking changes are released as major versions, so it might be necessary to be a bit more patient until all features for a major release are gathered.

## Style
PopupDialog uses Swiftlint to enforce best practices and warns you about violations early in the process. PopupDialog should build with zero warnings.

## Testing
*  Before doing a PR please ensure changes did not break any existing tests.
*  Updating existing unit tests / writing unit tests for new functionality is mandatory.
*  PopupDialog uses FBSnapshot test cases to ensure there are no user interface regressions. If your changes affect the appearance of PopupDialog, make sure to run Snapshot test cases in record mode first. The devices and OS versions required for reference images can be found in the .travis.yml file.
* If applicable, add UI tests for UI related PopupDialog features.

## Documentation
When adding or changing functionality, please help us with updating the docs, that is README and CHANGELOG, to reflect the latest updates.

### Thank you! Happy contributing :)
