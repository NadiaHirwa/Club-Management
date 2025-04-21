import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/models.dart';

class FinanceTab extends StatefulWidget {
  final bool isMember;

  const FinanceTab({
    Key? key,
    this.isMember = false,
  }) : super(key: key);

  @override
  State<FinanceTab> createState() => _FinanceTabState();
}

class _FinanceTabState extends State<FinanceTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final List<Transaction> _transactions = [
    Transaction(
      title: "Membership Fees",
      amount: 1500,
      date: "${DateTime.now().subtract(const Duration(days: 5)).day}/${DateTime.now().subtract(const Duration(days: 5)).month}/${DateTime.now().subtract(const Duration(days: 5)).year}",
      type: TransactionType.income,
      category: "Membership",
      description: "Monthly membership fees collection",
    ),
    Transaction(
      title: "Event Expenses",
      amount: 500,
      date: "${DateTime.now().subtract(const Duration(days: 3)).day}/${DateTime.now().subtract(const Duration(days: 3)).month}/${DateTime.now().subtract(const Duration(days: 3)).year}",
      type: TransactionType.expense,
      category: "Events",
      description: "Venue booking and equipment rental",
    ),
    Transaction(
      title: "Donation",
      amount: 1000,
      date: "${DateTime.now().subtract(const Duration(days: 1)).day}/${DateTime.now().subtract(const Duration(days: 1)).month}/${DateTime.now().subtract(const Duration(days: 1)).year}",
      type: TransactionType.income,
      category: "Donations",
      description: "Anonymous donation",
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

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    if (_searchQuery.isEmpty) {
      return transactions;
    }
    final query = _searchQuery.toLowerCase();
    return transactions.where((transaction) {
      return transaction.title.toLowerCase().contains(query) ||
          transaction.description.toLowerCase().contains(query) ||
          transaction.category.toLowerCase().contains(query);
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
              Tab(text: 'Income'),
              Tab(text: 'Expenses'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionList(_filterTransactions(_transactions)),
                _buildTransactionList(_filterTransactions(_transactions.where((t) => t.type == TransactionType.income).toList())),
                _buildTransactionList(_filterTransactions(_transactions.where((t) => t.type == TransactionType.expense).toList())),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isMember ? null : FloatingActionButton(
        onPressed: _showAddTransactionDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    final totalIncome = _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpenses = _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    final balance = totalIncome - totalExpenses;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Finance",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBalanceCard(
                "Balance",
                balance,
                balance >= 0 ? Colors.green : Colors.red,
                Icons.account_balance_wallet,
              ),
              _buildBalanceCard(
                "Income",
                totalIncome,
                Colors.green,
                Icons.arrow_upward,
              ),
              _buildBalanceCard(
                "Expenses",
                totalExpenses,
                Colors.red,
                Icons.arrow_downward,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(String title, double amount, Color color, IconData icon) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
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
          hintText: 'Search transactions...',
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

  Widget _buildTransactionList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No transactions found',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return _buildTransactionCard(transactions[index]);
      },
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
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
                    transaction.title,
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
                      onPressed: () {
                        _showEditTransactionDialog(transaction);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmation(transaction);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.category, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  transaction.category,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  transaction.date,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getTypeColor(transaction.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getTypeColor(transaction.type).withOpacity(0.3),
                ),
              ),
              child: Text(
                "\$${transaction.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  color: _getTypeColor(transaction.type),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              transaction.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return Colors.green;
      case TransactionType.expense:
        return Colors.red;
      case TransactionType.all:
        return Colors.grey;
    }
  }

  void _showAddTransactionDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();
    final dateController = TextEditingController(text: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    TransactionType selectedType = TransactionType.income;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Add Transaction",
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
              controller: amountController,
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: "Date",
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
                  dateController.text = "${date.day}/${date.month}/${date.year}";
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
            DropdownButtonFormField<TransactionType>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: "Type",
                border: OutlineInputBorder(),
              ),
              items: TransactionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedType = value;
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
                  amountController.text.isNotEmpty &&
                  categoryController.text.isNotEmpty &&
                  dateController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                setState(() {
                  _transactions.add(Transaction(
                    title: titleController.text,
                    amount: double.parse(amountController.text),
                    date: dateController.text,
                    type: selectedType,
                    category: categoryController.text,
                    description: descriptionController.text,
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

  void _showEditTransactionDialog(Transaction transaction) {
    final titleController = TextEditingController(text: transaction.title);
    final amountController = TextEditingController(text: transaction.amount.toString());
    final categoryController = TextEditingController(text: transaction.category);
    final descriptionController = TextEditingController(text: transaction.description);
    final dateController = TextEditingController(text: transaction.date);
    TransactionType selectedType = transaction.type;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit Transaction",
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
              controller: amountController,
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: "Date",
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
                  dateController.text = "${date.day}/${date.month}/${date.year}";
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
            DropdownButtonFormField<TransactionType>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: "Type",
                border: OutlineInputBorder(),
              ),
              items: TransactionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedType = value;
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
                  amountController.text.isNotEmpty &&
                  categoryController.text.isNotEmpty &&
                  dateController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                setState(() {
                  final index = _transactions.indexOf(transaction);
                  _transactions[index] = Transaction(
                    title: titleController.text,
                    amount: double.parse(amountController.text),
                    date: dateController.text,
                    type: selectedType,
                    category: categoryController.text,
                    description: descriptionController.text,
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

  void _showDeleteConfirmation(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Transaction"),
        content: const Text("Are you sure you want to delete this transaction?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _transactions.remove(transaction);
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

enum TransactionType {
  income,
  expense,
  all,
} 