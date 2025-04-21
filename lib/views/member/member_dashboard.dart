import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/task.dart';
import 'home_tab.dart';
import 'announcements_tab.dart';
import 'events_tab.dart';
import 'tasks_tab.dart';
import 'gallery_tab.dart';

class MemberDashboard extends StatefulWidget {
  const MemberDashboard({Key? key}) : super(key: key);

  @override
  State<MemberDashboard> createState() => _MemberDashboardState();
}

class _MemberDashboardState extends State<MemberDashboard> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const Center(child: CircularProgressIndicator()),
  ];
  final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    setState(() {
      _pages.clear();
      _pages.addAll([
        HomeTab(
          onNavigate: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tasks: _tasks,
        ),
        const AnnouncementsTab(),
        const TasksTab(),
        const EventsTab(),
        const GalleryTab(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.jpg',
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Text(
              'Abeho Organisation',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black),
      ),
      body: _pages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
} 