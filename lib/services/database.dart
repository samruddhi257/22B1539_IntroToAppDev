import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:budget_tracker/screens/home/home.dart';
class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});
  final CollectionReference datacollection=FirebaseFirestore.instance.collection('details');
  Future updateUserData(List <Expense> expenses) async {
    try {
      List<Map<String, dynamic>> expensesData=expenses.map((expense) => {'Category': expense.category,'Price':expense.amount}).toList();
      final DocumentReference userDoc=datacollection.doc(uid);
      await userDoc.set({'expenses':expensesData});
    }catch (e){
      print('error updating user data: $e');
    }
  }

Stream<QuerySnapshot> get details{
  return datacollection.snapshots();
}}