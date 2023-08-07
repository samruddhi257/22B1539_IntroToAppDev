import 'package:flutter/material.dart';
import 'package:budget_tracker/screens/authenticate/signin.dart';
import 'package:budget_tracker/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showsignin=true;
  toggleview(){
    setState(() {
      showsignin= !showsignin;
    });
  }
  @override
  Widget build(BuildContext context) {
   if (showsignin){
     return signin(toggleview:toggleview);
   }else {
     return Register(toggleview:toggleview);
   }
  }
}
