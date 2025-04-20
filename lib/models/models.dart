// Task Model
enum TaskStatus { pending, inProgress, completed }

class Task {
  final String title;
  final String assignedTo;
  final String dueDate;
  final TaskStatus status;
  final String description;

  Task({
    required this.title,
    required this.assignedTo,
    required this.dueDate,
    required this.status,
    required this.description,
  });
}

// Event Model
enum EventStatus { upcoming, completed }

class Event {
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;
  final int attendees;
  final EventStatus status;

  Event({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.attendees,
    required this.status,
  });
}

// Member Model
enum MemberRole { admin, member }
enum MemberStatus { active, inactive }

class Member {
  final String name;
  final String email;
  final String phone;
  final MemberRole role;
  final String joinDate;
  final MemberStatus status;

  Member({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.joinDate,
    required this.status,
  });
}

// Transaction Model
enum TransactionType { income, expense }

class Transaction {
  final String title;
  final double amount;
  final String date;
  final TransactionType type;
  final String category;
  final String description;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    required this.description,
  });
}

// Gallery Model
class GalleryItem {
  final String title;
  final String description;
  final String date;
  final String imageUrl;
  final String category;

  GalleryItem({
    required this.title,
    required this.description,
    required this.date,
    required this.imageUrl,
    required this.category,
  });
} 