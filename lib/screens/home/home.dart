import 'package:budget_tracker/screens/authenticate/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_tracker/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:budget_tracker/models/user.dart';
import 'package:budget_tracker/services/database.dart';
import 'package:budget_tracker/screens/authenticate/authenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
String getCurrentDateTime() {
  DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
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
  final FirebaseAuth _auth=FirebaseAuth.instance;
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

  void addExpense(Expense expense) async {
    final newCategoryRef = await FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('categories').add({
      'name': name,
      'price': price,
    });
    final newCategory = Category(id: newCategoryRef.id, name: name, price: price);
    setState(() {
      expenses.add(expense);
    });
    updateTotalExpense();
  }

  void removeExpense(Expense expense) async {
    final categoryRef = FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('categories').doc(categoryId);
    final categorySnapshot = await categoryRef.get();
    if (categorySnapshot.exists) {
      final category = Category.fromDocumentSnapshot(categorySnapshot);
      await categoryRef.delete();
      setState(() {
        expenses.remove(expense);
      });
      updateTotalExpense();
    }

    @override
    Widget build(BuildContext context) {
      return StreamProvider<QuerySnapshot?>.value(
          initialData:null,
          value:DatabaseService().details,
          child:Scaffold(
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
                actions: [
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ]
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
                    Center(
                      child: Text(getCurrentDateTime()),
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
          ));
    }
  }
  class Category {
  String id;
  String name;
  double price;

  Category({required this.id, required this.name, required this.price});

  Category.fromDocumentSnapshot(DocumentSnapshot doc)
      : id = doc.id,
  name = doc['name'],
  price = doc['price'];
  }
  class TotalScreen extends StatefulWidget {
  final List<Category> categories;
  final VoidCallback onCategoryChanged;

  TotalScreen({required this.categories, required this.onCategoryChanged});

  @override
  _TotalScreenState createState() => _TotalScreenState();
  }

  class _TotalScreenState extends State<TotalScreen> {
  void addCategory(String name, double price) async {
  final newCategoryRef = await FirebaseFirestore.instance.collection('users').doc(widget.categories.first.id).collection('categories').add({
  'name': name,
  'price': price,
  });
  final newCategory = Category(id: newCategoryRef.id, name: name, price: price);
  setState(() {
  widget.categories.add(newCategory);
  widget.onCategoryChanged();
  });
  }

  void deleteCategory(String categoryId) async {
  final categoryRef = FirebaseFirestore.instance.collection('users').doc(widget.categories.first.id).collection('categories').doc(categoryId);
  final categorySnapshot = await categoryRef.get();
  if (categorySnapshot.exists) {
  final category = Category.fromDocumentSnapshot(categorySnapshot);
  await categoryRef.delete();
  setState(() {
  widget.categories.removeWhere((element) => element.id == categoryId);
  widget.onCategoryChanged();
  });
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
  title: Text(expenses[index].category,
  style: TextStyle(
  color: expenses[index].amount>=0 ? Colors.green:Colors.red
  ),),
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