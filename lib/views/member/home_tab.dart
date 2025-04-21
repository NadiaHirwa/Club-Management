import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/task.dart';
import '../onboardingscreen.dart';
import 'profile_form.dart';
import 'change_password_form.dart';

class HomeTab extends StatefulWidget {
  final Function(int) onNavigate;
  final List<Task> tasks;

  const HomeTab({
    Key? key,
    required this.onNavigate,
    required this.tasks,
  }) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // Add state variables for profile information
  String _userName = 'Member User';
  String _userEmail = 'member@abeho.org';
  String _userPhone = '+250 123 456 789';

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
            "Welcome back, Member!",
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
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => ProfileForm(
                      initialName: _userName,
                      initialEmail: _userEmail,
                      initialPhone: _userPhone,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Change Password'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => const ChangePasswordForm(),
                  );
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
          icon: Icons.event,
          title: "Upcoming Events",
          value: "5",
          color: Colors.green,
        ),
        _buildStatCard(
          icon: Icons.task,
          title: "My Tasks",
          value: "3",
          color: Colors.orange,
        ),
        _buildStatCard(
          icon: Icons.announcement,
          title: "Announcements",
          value: "2",
          color: Colors.blue,
        ),
        _buildStatCard(
          icon: Icons.people,
          title: "Total Members",
          value: "150",
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

  void _navigateToTab(int index) {
    widget.onNavigate(index);
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
              onPressed: () => _navigateToTab(3),
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
              "My Tasks",
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