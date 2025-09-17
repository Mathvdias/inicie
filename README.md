# Inicie Tasks App

This is a sophisticated task management application built with Flutter, demonstrating modern architectural patterns, performance optimizations, internationalization, accessibility, and robust testing practices.

## Features

-   **Task Management (CRUD):** Create, View, Edit, and Delete tasks.
-   **Reminders & Notifications:** Set reminders for tasks with local notifications for Android and iOS.
-   **Data Persistence:** Tasks are persisted locally using `shared_preferences`.
-   **Lazy Loading:** Efficiently loads tasks as the user scrolls, supporting large datasets.
-   **Internationalization (i18n):** Supports multiple languages (English and Portuguese).
-   **Accessibility (a11y):** Enhanced with semantic labels for screen readers (VoiceOver/TalkBack).
-   **Performance Optimizations:**
    -   **CPU:** Minimized rebuilds using `const` constructors, efficient state management, and `ObjectKey` for list items. Heavy JSON parsing is offloaded to Isolates.
    -   **GPU:** Reduced overdraw with `RepaintBoundary` for list items.
-   **Clean Data:** Option to delete all tasks.

## Architecture

The application follows the **MVVM (Model-View-ViewModel)** architectural pattern, ensuring a clear separation of concerns, testability, and maintainability.

-   **Model:** Data structures (`Task`) and business logic.
-   **View:** UI components (Widgets).
-   **ViewModel:** Manages UI state and logic, interacting with the repository. Uses `ChangeNotifier` for state management.
-   **Repository Pattern:** Abstracts data sources, providing a clean API for the ViewModel.
-   **Dependency Injection:** Utilizes `get_it` for managing dependencies.

## Getting Started

### Prerequisites

-   Flutter SDK (latest stable version recommended)
-   Android Studio / VS Code with Flutter and Dart plugins

### Installation

1.  Clone the repository:
    ```bash
    git clone [repository_url]
    cd inicie
    ```
2.  Get Flutter packages:
    ```bash
    flutter pub get
    ```
3.  Run the application:
    ```bash
    flutter run
    ```

## Testing

The project includes comprehensive tests:

-   **Unit Tests:** For ViewModel and Repository logic.
-   **Widget Tests:** For UI components and interactions.
-   **Performance Tests:** A benchmark test for scrolling performance.

To run all tests:

```bash
flutter test
```

To generate a test coverage report:

```bash
flutter test --coverage
```

## Localization

To add new languages or update existing translations:

1.  Edit the `.arb` files in `lib/l10n/`.
2.  Run `flutter gen-l10n` (or `flutter pub get` which triggers it) to regenerate the localization code.

## Contributing

Feel free to fork the repository and contribute!