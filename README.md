# Inicie Tasks App

This is a sophisticated task management application built with Flutter, demonstrating modern architectural patterns, performance optimizations, internationalization, accessibility, and robust testing practices.

## Features

-   **Task Management:**
    -   **Creation:** Easily create new tasks with a title, optional description, and reminder.
    -   **Viewing:** View a list of tasks with lazy loading for efficient scrolling.
    -   **Editing:** Modify existing tasks, including their title, description, and reminder settings.
    -   **Deletion:** Delete individual tasks.
    -   **Bulk Deletion:** Option to delete all tasks at once.
-   **Reminders & Notifications:**
    -   Set specific date and time reminders for tasks.
    -   Receive local notifications on Android and iOS when a reminder is due.
    -   Notifications are scheduled and managed even when the app is closed or in the background.
    -   Ability to cancel notifications by removing the reminder from a task.
-   **Data Persistence:** Tasks are persisted locally using `shared_preferences`, ensuring your data is saved across app sessions.
-   **Internationalization (i18n):**
    -   Supports multiple languages, currently English and Portuguese.
    -   Users can switch between supported languages within the app.
-   **Accessibility (a11y):** Enhanced with semantic labels for screen readers (VoiceOver/TalkBack) to improve usability for all users.
-   **Performance Optimizations:**
    -   **CPU Efficiency:**
        -   Minimized widget rebuilds through the extensive use of `const` constructors.
        -   Efficient state management with `ChangeNotifier`.
        -   Optimized list rendering using `ObjectKey` for `TaskListItem` to prevent unnecessary rebuilds.
        -   Heavy JSON parsing operations are offloaded to separate Isolates (`compute`) to prevent UI freezes.
    -   **GPU Performance (Reduced Overdraw):**
        -   Utilizes `RepaintBoundary` for list items to reduce GPU overdraw, leading to smoother scrolling and better rendering performance.
-   **Responsive Design:** Adapts the UI layout to provide an optimal viewing experience across various screen sizes (mobile, tablet, desktop).

## Architecture

The application follows the **MVVM (Model-View-ViewModel)** architectural pattern, ensuring a clear separation of concerns, testability, and maintainability.

-   **Model:** Data structures (`Task`) and business logic.
-   **View:** UI components (Widgets).
-   **ViewModel:** Manages UI state and logic, interacting with the repository. Uses `ChangeNotifier` for state management.
-   **Repository Pattern:** Abstracts data sources, providing a clean API for the ViewModel.
-   **Dependency Injection:** Utilizes `get_it` for managing dependencies.

**Note on Use Cases:**
For simplicity and given the current scope of the application, explicit use case (interactor) layers have been omitted. The ViewModel directly interacts with the Repository. As the application grows in complexity and business logic, a dedicated use case layer can be introduced to encapsulate specific business rules and orchestrate interactions between multiple repositories.

## Getting Started

### Prerequisites

-   Flutter SDK (latest stable version recommended)
-   Android Studio / VS Code with Flutter and Dart plugins

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/your-username/inicie.git # Replace with your repository URL
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

After running tests with coverage, you can view the detailed report by opening `coverage/html/index.html` in your web browser.

**Current Test Coverage:** 75.4% of lines hit.

To get the coverage percentage, you can use a tool like `lcov` or manually inspect the `lcov.info` file. For a quick percentage, you can use:

```bash
genthtml coverage/lcov.info -o coverage/html && open coverage/html/index.html
# Look for "lines hit" percentage in the generated report.
```

## Screenshots

<!-- Add your application screenshots here. Use a table for a grid layout. -->
<table>
  <tr>
    <td>
      <img src="path/to/your/screenshot1.png" width="100%" alt="Screenshot 1">
    </td>
    <td>
      <img src="path/to/your/screenshot2.png" width="100%" alt="Screenshot 2">
    </td>
  </tr>
  <tr>
    <td>
      <img src="path/to/your/screenshot3.png" width="100%" alt="Screenshot 3">
    </td>
    <td>
      <img src="path/to/your/screenshot4.png" width="100%" alt="Screenshot 4">
    </td>
  </tr>
  <!-- Add more rows and images as needed -->
</table>

## Localization

To add new languages or update existing translations:

1.  Edit the `.arb` files in `lib/l10n/`.
2.  Run `flutter gen-l10n` (or `flutter pub get` which triggers it) to regenerate the localization code.

## Contributing

Feel free to fork the repository and contribute!
