enum TaskStatus {
  pending,
  inProgress,
  completed,
}

enum TaskPriority {
  low,
  medium,
  high,
}

class Task {
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskStatus status;
  final TaskPriority priority;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.priority,
  });
}