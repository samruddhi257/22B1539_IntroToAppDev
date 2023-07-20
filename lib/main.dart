import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: BudgetTracker(),
  ));
}

class Expense {
  final String category;
  final double amount;

  Expense({required this.category, required this.amount});
}

class BudgetTracker extends StatefulWidget {
  @override
  _BudgetTrackerState createState() {
    return _BudgetTrackerState();
  }
}

class _BudgetTrackerState extends State<BudgetTracker> {
  double totalExpense = 0.0;
  List<Expense> expenses = [];

  void updateTotalExpense() {
    double total = 0.0;
    for (var expense in expenses) {
      total += expense.amount;
    }
    setState(() {
      totalExpense = total;
    });
  }

  @override
  void initState() {
    super.initState();
    expenses = [
      Expense(category: 'Groceries', amount: -300),
      Expense(category: 'Bills', amount: -1000),
      Expense(category: 'Salary', amount: 50000),
    ];
    updateTotalExpense();
  }

  void addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
    updateTotalExpense();
  }

  void removeExpense(Expense expense) {
    setState(() {
      expenses.remove(expense);
    });
    updateTotalExpense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[400],
      appBar: AppBar(
        title: Text(
          'Budget Tracker',
          style: TextStyle(
            color: Colors.purple[650],
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo[400],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRg1w-a0m4bNInPte-_gWlTpJWx5BYj3vDhMw&usqp=CAU'),
                  radius: 50.0,
                ),
              ),
              Divider(
                height: 25.0,
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40.0,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Center(
                child: Text(
                  'Back!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Total Expense: ₹${totalExpense.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ExpenseScreen(
                          expenses: expenses,
                          totalExpense: totalExpense,
                          removeExpense: removeExpense,
                        );
                      },
                    ),
                  );
                },
                child: Text('Go to Expense Screen'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddExpenseDialog(
                addExpense: addExpense,
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ExpenseScreen extends StatelessWidget {
  final double totalExpense;
  final List<Expense> expenses;
  final Function(Expense) removeExpense;

  ExpenseScreen({
    required this.totalExpense,
    required this.expenses,
    required this.removeExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[400],
      appBar: AppBar(
        title: Text(
          'Expense Screen',
          style: TextStyle(
            color: Colors.purple[650],
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo[400],
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Total Expense: ₹${totalExpense.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(expenses[index].category),
                  subtitle: Text('₹${expenses[index].amount.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      removeExpense(expenses[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddExpenseDialog extends StatelessWidget {
  final Function(Expense) addExpense;

  AddExpenseDialog({required this.addExpense});

  @override
  Widget build(BuildContext context) {
    String category = '';
    double amount = 0.0;

    return AlertDialog(
      title: Text('Add Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              category = value;
            },
            decoration: InputDecoration(
              labelText: 'Category',
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              amount = double.tryParse(value) ?? 0.0;
            },
            decoration: InputDecoration(
              labelText: 'Amount',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            addExpense(Expense(category: category, amount: amount));
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

