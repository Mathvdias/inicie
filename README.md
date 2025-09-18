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

## Getting Started

### Prerequisites

-   Flutter SDK (latest stable version recommended)
-   Android Studio / VS Code with Flutter and Dart plugins

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/Mathvdias/inicie.git
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

**Current Test Coverage:** 83.4% of lines hit.

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
      <img src="https://github.com/user-attachments/assets/fdf69369-08db-4447-822d-3c9d9b992cf7" width="100%" alt="Screenshot 1">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/d4d4fd97-5c33-47ca-bb45-ff3b3438fa7f" width="100%" alt="Screenshot 2">
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/0f2a5eb3-b6b6-4be6-8bdb-42c9b102dedf" width="100%" alt="Screenshot 3">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/499f833d-a8a6-4bf4-909b-8b84f7f78368" width="100%" alt="Screenshot 4">
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/7a433b70-8984-42c6-9ed6-754331472589" width="100%" alt="Screenshot 5">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/77a99faa-04f7-48a8-9ffe-68ead76e49e2" width="100%" alt="Screenshot 6">
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/18d21069-d332-4523-900a-774526a3aa1d" width="100%" alt="Screenshot 7">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/0f9aed82-e1f4-4710-9457-4027eb2726d0" width="100%" alt="Screenshot 8">
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/523655fd-c9af-493e-9378-0c537cf912e8" width="100%" alt="Screenshot 9">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/49ff9a30-634a-41b3-ba7d-b53f1996a04f" width="100%" alt="Screenshot 10">
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/77e928c5-4624-4064-9916-768b99108c46" width="100%" alt="Screenshot 11">
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/f559cc67-a340-40a9-9d60-191c09e9403f" width="100%" alt="Screenshot 12">
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
