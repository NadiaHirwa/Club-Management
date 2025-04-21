import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MembersTab extends StatefulWidget {
  const MembersTab({Key? key}) : super(key: key);

  @override
  State<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  final List<Member> _members = [
    Member(
      name: "John Doe",
      email: "john.doe@example.com",
      phone: "+1 234 567 8901",
      joinDate: "January 15, 2024",
      status: MemberStatus.active,
      role: MemberRole.member,
    ),
    Member(
      name: "Jane Smith",
      email: "jane.smith@example.com",
      phone: "+1 234 567 8902",
      joinDate: "February 1, 2024",
      status: MemberStatus.active,
      role: MemberRole.admin,
    ),
    Member(
      name: "Mike Johnson",
      email: "mike.johnson@example.com",
      phone: "+1 234 567 8903",
      joinDate: "March 10, 2024",
      status: MemberStatus.inactive,
      role: MemberRole.member,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Member> _filterMembers(List<Member> members) {
    if (_searchQuery.isEmpty) {
      return members;
    }
    final query = _searchQuery.toLowerCase();
    return members.where((member) {
      return member.name.toLowerCase().contains(query) ||
          member.email.toLowerCase().contains(query) ||
          member.phone.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Active'),
              Tab(text: 'Inactive'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMemberList(_filterMembers(_members)),
                _buildMemberList(_filterMembers(_members.where((m) => m.status == MemberStatus.active).toList())),
                _buildMemberList(_filterMembers(_members.where((m) => m.status == MemberStatus.inactive).toList())),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMemberDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Members",
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search members...',
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
      ),
    );
  }

  Widget _buildMemberList(List<Member> members) {
    if (members.isEmpty) {
      return Center(
        child: Text(
          'No members found',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: members.length,
      itemBuilder: (context, index) {
        return _buildMemberCard(members[index]);
      },
    );
  }

  Widget _buildMemberCard(Member member) {
    final isActive = member.status == MemberStatus.active;
    final color = isActive ? Colors.green : Colors.grey;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    member.name,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditMemberDialog(member),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeleteConfirmation(member),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  member.email,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  member.phone,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  "Joined: ${member.joinDate}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: color.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    member.status.toString().split('.').last,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    member.role.toString().split('.').last,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMemberDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final joinDateController = TextEditingController(text: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    var selectedStatus = MemberStatus.active;
    var selectedRole = MemberRole.member;

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
        content: SingleChildScrollView(
          child: Column(
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
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: joinDateController,
                decoration: const InputDecoration(
                  labelText: "Join Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    joinDateController.text = "${date.day}/${date.month}/${date.year}";
                  }
                },
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setState) => DropdownButtonFormField<MemberStatus>(
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
                      setState(() => selectedStatus = value);
                    }
                  },
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
            ],
          ),
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
                  phoneController.text.isNotEmpty &&
                  joinDateController.text.isNotEmpty) {
                setState(() {
                  _members.add(Member(
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    joinDate: joinDateController.text,
                    status: selectedStatus,
                    role: selectedRole,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showEditMemberDialog(Member member) {
    final nameController = TextEditingController(text: member.name);
    final emailController = TextEditingController(text: member.email);
    final phoneController = TextEditingController(text: member.phone);
    final joinDateController = TextEditingController(text: member.joinDate);
    var selectedStatus = member.status;
    var selectedRole = member.role;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit Member",
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
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: joinDateController,
                decoration: const InputDecoration(
                  labelText: "Join Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    joinDateController.text = "${date.day}/${date.month}/${date.year}";
                  }
                },
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setState) => DropdownButtonFormField<MemberStatus>(
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
                      setState(() => selectedStatus = value);
                    }
                  },
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
            ],
          ),
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
                  phoneController.text.isNotEmpty &&
                  joinDateController.text.isNotEmpty) {
                setState(() {
                  final index = _members.indexOf(member);
                  _members[index] = Member(
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    joinDate: joinDateController.text,
                    status: selectedStatus,
                    role: selectedRole,
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Member member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Member"),
        content: const Text("Are you sure you want to delete this member?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _members.remove(member);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

class Member {
  final String name;
  final String email;
  final String phone;
  final String joinDate;
  final MemberStatus status;
  final MemberRole role;

  Member({
    required this.name,
    required this.email,
    required this.phone,
    required this.joinDate,
    required this.status,
    required this.role,
  });
}

enum MemberStatus {
  active,
  inactive,
}

enum MemberRole {
  admin,
  member,
} 