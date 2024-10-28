import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalculatorSceen extends StatefulWidget{
  const CalculatorSceen({super.key});

  @override
  State<CalculatorSceen> createState()=>CalculatorSceenstate();
}

class CalculatorSceenstate extends State<CalculatorSceen>{
  @override
  Widget build(BuildContext context) {
      return Scaffold(
          body: SafeArea( //safeare used to start column in suitable place
            child: Column(children: [
              //output
              Text("0")
              
              //buttons
            ],),
          ),
      );
  }
}
