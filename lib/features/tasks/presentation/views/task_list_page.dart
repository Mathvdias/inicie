import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:inicie/core/di/service_locator.dart';
import 'package:inicie/core/responsive/responsive_layout.dart';
import 'package:inicie/core/services/notification_service.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/task_viewmodel.dart';
import 'package:inicie/features/tasks/presentation/widgets/add_edit_task_sheet.dart';
import 'package:inicie/features/tasks/presentation/widgets/task_list_item.dart';
import 'package:inicie/l10n/app_localizations.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage>
    with SingleTickerProviderStateMixin {
  late final TaskViewModel _viewModel;
  final _scrollController = ScrollController();
  final NotificationService _notificationService = getIt<NotificationService>();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<TaskViewModel>();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadTasks();
    _notificationService.requestPermissions();
    _scrollController.addListener(_onScroll);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    _showErrorSnackBar();
    if (_viewModel.state == ViewState.idle) {
      _animationController.forward();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _viewModel.loadMoreTasks();
    }
  }

  void _showErrorSnackBar() {
    if (_viewModel.state == ViewState.error &&
        _viewModel.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(
              context,
            )!.anErrorOccurred(_viewModel.errorMessage),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _confirmDelete(String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteTask),
        content: Text(AppLocalizations.of(context)!.deleteTaskConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              _viewModel.deleteTask(taskId);
              Navigator.of(context).pop();
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteAllTasks),
        content: Text(AppLocalizations.of(context)!.deleteAllTasksConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              _viewModel.deleteAllTasks();
              Navigator.of(context).pop();
            },
            child: Text(
              AppLocalizations.of(context)!.deleteAll,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            key: const Key('taskOptionsPopupMenuButton'),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'deleteAll',
                child: Text(l10n.deleteAllTasks),
              ),
              PopupMenuItem(
                value: 'selectLanguage',
                child: Text(l10n.selectLanguage),
              ),
            ],
            onSelected: (value) {
              if (value == 'deleteAll') {
                _confirmDeleteAll();
              } else if (value == 'selectLanguage') {
                _showLanguageSelectionDialog(context);
              }
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          if (_viewModel.state == ViewState.loading &&
              _viewModel.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.tasks.isEmpty) {
            return _buildEmptyState(l10n);
          }

          return _buildTaskList(l10n);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditTaskSheet(context, _viewModel),
        tooltip: l10n.newTask,
        child: const Icon(EvaIcons.plus),
      ),
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<Locale>(
              value: Localizations.localeOf(context),
              items: AppLocalizations.supportedLocales.map((Locale locale) {
                final flag = locale.languageCode == 'en' ? '🇺🇸' : '🇧🇷';
                return DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text('$flag ${locale.languageCode.toUpperCase()}'),
                );
              }).toList(),
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  getIt<ValueNotifier<Locale>>().value = newLocale;
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(EvaIcons.inboxOutline, size: 80, color: Colors.white38),
          const SizedBox(height: 16),
          Text(l10n.noTasks, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildTaskList(AppLocalizations l10n) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: RefreshIndicator(
        onRefresh: () => _viewModel.loadTasks(),
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 80),
          itemCount:
              _viewModel.tasks.length + (_viewModel.hasMoreTasks ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _viewModel.tasks.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final task = _viewModel.tasks[index];
            return RepaintBoundary(
              key: ObjectKey(task),
              child: TaskListItem(
                task: task,
                onToggle: () => _viewModel.toggleTaskCompletion(task),
                onEdit: () =>
                    showAddEditTaskSheet(context, _viewModel, task: task),
                onDelete: () => _confirmDelete(task.id),
              ),
            );
          },
        ),
      ),
    );
  }
}


