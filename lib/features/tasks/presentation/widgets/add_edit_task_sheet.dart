import 'package:flutter/material.dart';
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/features/tasks/presentation/viewmodels/i_task_viewmodel.dart';
import 'package:inicie/l10n/app_localizations.dart' show AppLocalizations;
import 'package:intl/intl.dart';

Future<void> showAddEditTaskSheet(
  BuildContext context,
  ITaskViewModel viewModel, {
  Task? task,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.3,
        maxChildSize: 1.0,
        expand: true,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: _AddEditTaskSheetContent(
              viewModel: viewModel,
              task: task,
              scrollController: scrollController,
            ),
          );
        },
      );
    },
  );
}

class _AddEditTaskSheetContent extends StatefulWidget {
  final ITaskViewModel viewModel;
  final Task? task;
  final ScrollController scrollController;

  const _AddEditTaskSheetContent({
    required this.viewModel,
    this.task,
    required this.scrollController,
  });

  @override
  State<_AddEditTaskSheetContent> createState() =>
      _AddEditTaskSheetContentState();
}

class _AddEditTaskSheetContentState extends State<_AddEditTaskSheetContent>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late bool _setReminder;
  DateTime? _reminderDateTime;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title);
    _descriptionController = TextEditingController(text: task?.description);
    _setReminder = task?.reminderDateTime != null;
    _reminderDateTime = task?.reminderDateTime;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final initialDate = _reminderDateTime ?? now.add(const Duration(hours: 1));

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (!mounted || date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (!mounted || time == null) return;

    setState(() {
      _reminderDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final l10n = AppLocalizations.of(context)!;

    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedPadding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? l10n.editTask : l10n.newTask,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: l10n.title,
                      hintText: l10n.titleHint,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.titleEmptyError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: l10n.description,
                      hintText: l10n.descriptionHint,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(l10n.setReminder),
                    value: _setReminder,
                    onChanged: (value) {
                      setState(() {
                        _setReminder = value;
                        if (_setReminder && _reminderDateTime == null) {
                          _pickDateTime();
                        }
                        if (!_setReminder) {
                          _reminderDateTime = null;
                        }
                      });
                    },
                  ),
                  if (_setReminder)
                    ListTile(
                      leading: const Icon(Icons.alarm),
                      title: Text(
                        _reminderDateTime != null
                            ? DateFormat.yMd().add_jm().format(
                                _reminderDateTime!,
                              )
                            : l10n.tapToSetTime,
                      ),
                      onTap: _pickDateTime,
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.cancel),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final reminder = _setReminder
                                ? _reminderDateTime
                                : null;

                            if (isEditing) {
                              final updatedTask = widget.task!.copyWith(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                reminderDateTime: reminder,
                              );
                              widget.viewModel.updateTask(updatedTask);
                            } else {
                              widget.viewModel.addTask(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                reminderDateTime: reminder,
                              );
                            }
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(l10n.save),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
