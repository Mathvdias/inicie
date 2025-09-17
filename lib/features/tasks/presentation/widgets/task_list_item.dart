import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show CustomSemanticsAction;
import 'package:inicie/features/tasks/data/models/task_model.dart';
import 'package:inicie/l10n/app_localizations.dart' show AppLocalizations;
import 'package:intl/intl.dart';

class TaskListItem extends StatefulWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;
  final bool isSelected;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
    this.isSelected = false,
  });

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      customSemanticsActions: {
        CustomSemanticsAction(label: l10n.editTask): widget.onEdit,
        CustomSemanticsAction(label: l10n.deleteTask): widget.onDelete,
      },
      child: GestureDetector(
        onTap: widget.onTap ?? _toggleExpanded,
        child: RepaintBoundary(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? theme.colorScheme.primary.withAlpha((255 * 0.2).round())
                  : widget.task.isCompleted
                  ? theme.colorScheme.surface.withAlpha((255 * 0.5).round())
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
              border: widget.isSelected
                  ? Border.all(color: theme.colorScheme.primary, width: 2)
                  : null,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  leading: Semantics(
                    label:
                        'Mark as ${widget.task.isCompleted ? 'incomplete' : 'complete'}',
                    child: Checkbox(
                      value: widget.task.isCompleted,
                      onChanged: (_) => widget.onToggle(),
                      activeColor: theme.colorScheme.secondary,
                    ),
                  ),
                  title: Text(
                    widget.task.title,
                    style: TextStyle(
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: widget.task.isCompleted
                          ? Colors.white54
                          : Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, right: 16.0),
                  child: Row(
                    children: [
                      if (widget.task.reminderDateTime != null && !_isExpanded)
                        Icon(EvaIcons.bell, color: Colors.yellow, size: 18),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(EvaIcons.editOutline),
                        tooltip: l10n.editTask,
                        onPressed: widget.onEdit,
                        color: theme.colorScheme.secondary,
                      ),
                      IconButton(
                        icon: const Icon(EvaIcons.trash2Outline),
                        tooltip: l10n.deleteTask,
                        onPressed: widget.onDelete,
                        color: theme.colorScheme.error,
                      ),
                      IconButton(
                        icon: Icon(
                          _isExpanded
                              ? EvaIcons.arrowIosUpwardOutline
                              : EvaIcons.arrowIosDownwardOutline,
                        ),
                        tooltip: _isExpanded ? l10n.collapse : l10n.expand,
                        onPressed: _toggleExpanded,
                        color: theme.colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
                SizeTransition(
                  sizeFactor: _animation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.task.description != null &&
                            widget.task.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              widget.task.description!,
                              style: TextStyle(
                                color: widget.task.isCompleted
                                    ? Colors.white38
                                    : Colors.white70,
                              ),
                            ),
                          ),
                        if (widget.task.reminderDateTime != null)
                          Row(
                            children: [
                              Icon(
                                EvaIcons.bell,
                                color: Colors.yellow,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat(
                                  'dd/MM/yyyy HH:mm',
                                ).format(widget.task.reminderDateTime!),
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
