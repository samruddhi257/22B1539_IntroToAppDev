import 'package:budget_tracker/models/user.dart';
import 'package:budget_tracker/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';
import 'package:budget_tracker/models/user.dart';
import '';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  @override
  Widget build(BuildContext context){
    final user=Provider.of<MyUser?>(context);
    if (user==null){
      return Authenticate();
    }else{
      return BudgetTracker();
    }
  }
}