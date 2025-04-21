import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'members_tab.dart';
import 'announcements_tab.dart';
import 'events_tab.dart';
import 'tasks_tab.dart';
import 'admin_dashboard.dart';
import '../onboardingscreen.dart';

class HomeTab extends StatefulWidget {
  final Function(int) onNavigate;
  final List<Task> tasks;
  final bool isMember;

  const HomeTab({
    Key? key,
    required this.onNavigate,
    required this.tasks,
    this.isMember = false,
  }) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // Form controllers for member dialog
  final _memberNameController = TextEditingController();
  final _memberEmailController = TextEditingController();
  final _memberPhoneController = TextEditingController();
  final _memberRoleController = TextEditingController();

  // Form controllers for announcement dialog
  final _announcementTitleController = TextEditingController();
  final _announcementContentController = TextEditingController();

  // Form controllers for event dialog
  final _eventTitleController = TextEditingController();
  final _eventLocationController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _eventTimeController = TextEditingController();
  final _eventDescriptionController = TextEditingController();

  // Form controllers for task dialog
  final _taskTitleController = TextEditingController();
  final _taskAssigneeController = TextEditingController();
  final _taskDueDateController = TextEditingController();
  final _taskDescriptionController = TextEditingController();

  // Add state variables for profile information
  String _userName = 'Admin User';
  String _userEmail = 'admin@abeho.org';
  String _userPhone = '+250 123 456 789';

  // Add state variable for password
  final String _currentPassword = 'admin123'; // This would normally be stored securely

  @override
  void dispose() {
    _memberNameController.dispose();
    _memberEmailController.dispose();
    _memberPhoneController.dispose();
    _memberRoleController.dispose();
    _announcementTitleController.dispose();
    _announcementContentController.dispose();
    _eventTitleController.dispose();
    _eventLocationController.dispose();
    _eventDateController.dispose();
    _eventTimeController.dispose();
    _eventDescriptionController.dispose();
    _taskTitleController.dispose();
    _taskAssigneeController.dispose();
    _taskDueDateController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(),
          const SizedBox(height: 24),
          _buildStatsGrid(),
          if (!widget.isMember) ...[
            const SizedBox(height: 24),
            _buildQuickActions(),
          ],
          const SizedBox(height: 24),
          _buildUpcomingEvents(),
          const SizedBox(height: 24),
          _buildRecentAnnouncements(),
          const SizedBox(height: 24),
          _buildTaskSummary(),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.isMember ? "Welcome back, Member!" : "Welcome back, Admin!",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: const AssetImage('assets/profile.png'),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _showProfileDialog,
                child: const SizedBox(
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileForm() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    final phoneController = TextEditingController(text: _userPhone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userName = nameController.text;
                _userEmail = emailController.text;
                _userPhone = phoneController.text;
              });
              Navigator.pop(context); // Close edit form
              Navigator.pop(context); // Close profile dialog
              // Reopen profile dialog with updated information
              _showProfileDialog();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordForm() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool _obscureCurrentPassword = true;
    bool _obscureNewPassword = true;
    bool _obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Change Password',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: _obscureCurrentPassword,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrentPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate current password
                if (currentPasswordController.text != _currentPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Current password is incorrect'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Validate new password
                if (newPasswordController.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('New password must be at least 6 characters long'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Validate password match
                if (newPasswordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('New passwords do not match'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Update password
                // TODO: Implement actual password update logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 600,
          height: 800,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/profile.png'),
              ),
              const SizedBox(height: 16),
              Text(
                _userName,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _userEmail,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                _userPhone,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Edit Profile'),
                onTap: () {
                  _showEditProfileForm();
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Change Password'),
                onTap: () {
                  _showChangePasswordForm();
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () {
                  // TODO: Implement settings
                },
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OnBoardingScreen()),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildStatCard(
          icon: Icons.people,
          title: "Total Members",
          value: "150",
          color: Colors.blue,
        ),
        _buildStatCard(
          icon: Icons.event,
          title: "Upcoming Events",
          value: "5",
          color: Colors.green,
        ),
        _buildStatCard(
          icon: Icons.task,
          title: "Pending Tasks",
          value: "12",
          color: Colors.orange,
        ),
        _buildStatCard(
          icon: Icons.attach_money,
          title: "Current Balance",
          value: "\$2,500",
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuickActionButton(
              icon: Icons.person_add,
              label: "Add Member",
              onTap: () => _showAddMemberDialog(),
            ),
            _buildQuickActionButton(
              icon: Icons.announcement,
              label: "Announcement",
              onTap: () => _showAddAnnouncementDialog(),
            ),
            _buildQuickActionButton(
              icon: Icons.event,
              label: "Create Event",
              onTap: () => _showCreateEventDialog(),
            ),
            _buildQuickActionButton(
              icon: Icons.task,
              label: "Assign Task",
              onTap: () => _showAssignTaskDialog(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _navigateToTab(int index) {
    widget.onNavigate(index);
  }

  void _showAddMemberDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final joinDateController = TextEditingController(text: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    MemberRole selectedRole = MemberRole.member;
    MemberStatus selectedStatus = MemberStatus.active;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Add Member",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MemberRole>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: "Role",
                border: OutlineInputBorder(),
              ),
              items: MemberRole.values.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedRole = value;
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MemberStatus>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              items: MemberStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedStatus = value;
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: joinDateController,
              decoration: const InputDecoration(
                labelText: "Join Date",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  joinDateController.text = "${date.day}/${date.month}/${date.year}";
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                // TODO: Add member to the list
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showAddAnnouncementDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "New Announcement",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                // TODO: Add announcement to the list
                Navigator.pop(context);
              }
            },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }

  void _showCreateEventDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    EventStatus selectedStatus = EventStatus.upcoming;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Create Event",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: "Date",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  dateController.text = "${date.day}/${date.month}/${date.year}";
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: "Time",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  timeController.text = time.format(context);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<EventStatus>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              items: EventStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedStatus = value;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  locationController.text.isNotEmpty &&
                  dateController.text.isNotEmpty &&
                  timeController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                // TODO: Add event to the list
                Navigator.pop(context);
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  void _showAssignTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final assignedToController = TextEditingController();
    final dueDateController = TextEditingController();
    TaskStatus selectedStatus = TaskStatus.pending;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Assign Task",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: assignedToController,
              decoration: const InputDecoration(
                labelText: "Assigned To",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dueDateController,
              decoration: const InputDecoration(
                labelText: "Due Date",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  dueDateController.text = "${date.day}/${date.month}/${date.year}";
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskStatus>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              items: TaskStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedStatus = value;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  assignedToController.text.isNotEmpty &&
                  dueDateController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                // TODO: Add task to the list
                Navigator.pop(context);
              }
            },
            child: const Text("Assign"),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Upcoming Events",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => _navigateToTab(4),
              child: const Text("View All"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildEventCard(
          title: "Monthly Meeting",
          date: "May 15, 2024",
          time: "2:00 PM",
        ),
        const SizedBox(height: 8),
        _buildEventCard(
          title: "Annual Conference",
          date: "May 20, 2024",
          time: "9:00 AM",
        ),
      ],
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(date, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(time, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAnnouncements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Announcements",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => _navigateToTab(1),
              child: const Text("View All"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildAnnouncementCard(
          title: "Club Meeting Rescheduled",
          date: "May 10, 2024",
        ),
        const SizedBox(height: 8),
        _buildAnnouncementCard(
          title: "New Member Orientation",
          date: "May 8, 2024",
        ),
      ],
    );
  }

  Widget _buildAnnouncementCard({
    required String title,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(date, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskSummary() {
    // Calculate task statistics
    final totalTasks = widget.tasks.length;
    final completedTasks = widget.tasks.where((task) => task.status == TaskStatus.completed).length;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Task Summary",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => _navigateToTab(2),
              child: const Text("View All"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 0.7 ? Colors.green : 
            progress >= 0.4 ? Colors.orange : Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "$totalTasks Tasks | $completedTasks Completed",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        if (totalTasks > 0) ...[
          const SizedBox(height: 8),
          Text(
            "${totalTasks - completedTasks} Pending",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }
} 