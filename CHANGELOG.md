# CHANGELOG

## 1.0.1 - 2025-09-17

### Adicionado
- Implementado o pacote `logger` para melhoria dos logs em toda a aplicação.
- Adicionado um ícone de sino amarelo aos cartões de tarefa recolhidos com lembretes, visível apenas quando não expandido.

### Alterado
- **Modal de Criação de Tarefas:**
    - Altura ajustada para ocupar quase a tela inteira (`initialChildSize: 0.9`, `maxChildSize: 1.0`, `expand: true`).
    - Removido `AnimatedPadding` e `SingleChildScrollView` do conteúdo do modal para um layout mais limpo.
- **Item da Lista de Tarefas (Cartão) UI/UX:**
    - Funcionalidade de deslizar para revelar revertida; ícones de edição/exclusão reintegrados diretamente no cartão.
    - Botões de ação (editar, excluir, expandir/recolher) movidos para uma linha separada na parte inferior do cartão.
    - Exibição de lembrete aprimorada: formato de data alterado para 24 horas (`dd/MM/yyyy HH:mm`), alinhado com a caixa de seleção, e detalhes completos de data/lembrete exibidos apenas quando expandido.
    - Legibilidade e intuitividade geral do cartão aprimoradas através de ajustes de espaçamento e estilo.
- **Sistema de Notificação:**
    - Todas as declarações `print` substituídas por chamadas `logger` para melhor depuração e prontidão para produção.
    - `AndroidManifest.xml` atualizado para incluir o `ScheduledNotificationReceiver` ausente, o atributo `android:exported` corrigido para `false` para `ScheduledNotificationBootReceiver` e o `intent-filter` completo adicionado para eventos de inicialização.
    - `compileSdk` explicitamente definido como 35 em `android/app/build.gradle.kts`.
    - `androidScheduleMode` alterado para `AndroidScheduleMode.exactAllowWhileIdle` em `NotificationService` para maior confiabilidade.
- **Responsividade:**
    - `ResponsiveLayout` reintroduzido para `TaskListPage`, garantindo um layout responsivo de coluna única com uma largura máxima para desktop.

### Corrigido
- Resolvido o problema em que o cartão de tarefa não retornava à posição original após cancelar uma ação `Dismissible`.
- Restaurado o método `cancelNotification` acidentalmente excluído em `NotificationService`.

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
