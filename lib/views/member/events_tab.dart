import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Event {
  final String title;
  final DateTime date;
  final String time;
  final String location;
  final String description;
  final String imageUrl;

  Event({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.imageUrl,
  });
}

class EventsTab extends StatefulWidget {
  const EventsTab({Key? key}) : super(key: key);

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  final List<Event> _events = [
    Event(
      title: "Monthly Club Meeting",
      date: DateTime(2024, 5, 15),
      time: "2:00 PM",
      location: "Main Conference Hall",
      description: "Monthly meeting to discuss club activities and upcoming events.",
      imageUrl: "assets/gallery/event1.jpg",
    ),
    Event(
      title: "Annual Conference",
      date: DateTime(2024, 5, 20),
      time: "9:00 AM",
      location: "Grand Ballroom",
      description: "Annual conference featuring guest speakers and workshops.",
      imageUrl: "assets/gallery/event2.jpg",
    ),
    Event(
      title: "Member Social Gathering",
      date: DateTime(2024, 5, 25),
      time: "6:00 PM",
      location: "Club Lounge",
      description: "Casual gathering for members to network and socialize.",
      imageUrl: "assets/gallery/event3.jpg",
    ),
  ];

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Event> get _filteredEvents {
    if (_searchQuery.isEmpty) {
      return _events;
    }
    return _events.where((event) {
      final query = _searchQuery.toLowerCase();
      return event.title.toLowerCase().contains(query) ||
          event.description.toLowerCase().contains(query) ||
          event.location.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSearchBar(),
          const SizedBox(height: 24),
          _buildUpcomingEvents(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
            "Events",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search events...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _buildUpcomingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upcoming Events",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ..._filteredEvents.map((event) => Column(
          children: [
            _buildEventCard(event),
            const SizedBox(height: 16),
          ],
        )).toList(),
      ],
    );
  }

  Widget _buildEventCard(Event event) {
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
            event.title,
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
              Text(
                DateFormat('MMMM d, y').format(event.date),
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                event.time,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                event.location,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
} 