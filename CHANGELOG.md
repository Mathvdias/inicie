# CHANGELOG

## 1.0.0 - 2025-09-15

### Added
- Initial task management application with CRUD operations.
- MVVM architecture with `ChangeNotifier` and `get_it`.
- Local data persistence using `shared_preferences`.
- Custom icon package (`eva_icons_flutter`).
- Basic unit tests for `TaskViewModel`.
- Basic widget tests for `TaskListPage`.
- Responsive layout abstraction.
- Reminder feature with local notifications for Android and iOS.
- Permissions handling for notifications.
- Internationalization (i18n) support with English and Portuguese translations.
- Accessibility (a11y) enhancements using `Semantics`.
- Performance optimizations:
    - JSON parsing offloaded to Isolates (`compute`).
    - Minimized rebuilds with `const` constructors and `ObjectKey` for list items.
    - Reduced overdraw with `RepaintBoundary` for list items.
- Lazy loading (infinite scrolling) for task list.
- "Delete All Tasks" feature.
- Performance benchmark test for scrolling.

### Changed
- Updated `pubspec.yaml` with new dependencies and corrected versions.
- Modified Android and iOS native configurations for notifications.
- Refactored `TaskRepository` for pagination.
- Updated `TaskViewModel` to support lazy loading and notification integration.
- Updated UI widgets (`TaskListPage`, `AddEditTaskDialog`, `TaskListItem`) for new features and i18n/a11y.
- Refactored test files to accommodate new features and improve reliability.

### Fixed
- Resolved Gradle build errors related to `flutter_native_timezone_updated_gradle` by replacing it with `flutter_timezone`.
- Fixed various compilation and runtime errors in tests.
- Corrected `intl` package version conflicts.
