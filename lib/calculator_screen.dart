import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorSceen extends StatefulWidget{
  const CalculatorSceen({super.key});

  @override
  State<CalculatorSceen> createState()=>CalculatorSceenstate();
}

class CalculatorSceenstate extends State<CalculatorSceen>{
  Widget buildButton(value){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,//clip property adjust the touch of of every button
        shape: OutlineInputBorder(
          borderSide:const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(100),

        ),
        child: InkWell(
          onTap: ()=>onBtnTap(value),
            child: Center(
                child: Text(value,style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,

                ),),
                )
        ),
      ),
    );
  }
  String number1="";//. 0-9
  String operand="";//+ - * /
  String number2="";//. 0-9

  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;//this will give screen size
      return Scaffold(
         body: SafeArea(//adjust the screen
           bottom: false,//safe area are padding left,right,top,bottom automatically ;
           child: Column(
             children: [
               //Output Screen
               outputscreen(),
               //Button part
               Buttonpart(screenSize)
             ],
           ),
         ),
      );
  }
  Expanded outputscreen() {
    return Expanded(
      child: SingleChildScrollView(
        reverse: true,//scrollview bottom to top
        scrollDirection: Axis.vertical,
        child: Container(
          alignment: Alignment.bottomRight,
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "$number1$operand$number2".isEmpty?"0":"$number1$operand$number2",
            style:const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.end,
          ),

        ),
      ),
    );
  }
  Wrap Buttonpart(Size screenSize) {
    return Wrap(
               children: Btn.buttonValues
                   .map(
                     (value) => SizedBox(
                         width:value==Btn.n0
                             ? screenSize.width/2: screenSize.width/4,
                         height: screenSize.width/5,
                         child: buildButton(value),
                     ),
               )
                   .toList(),

             );
  }

  Color getBtnColor(values){
   return [Btn.del,Btn.clr].contains(values)
        ?Colors.blueGrey
        : [
      Btn.per,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divide,
      Btn.calculate,
    ].contains(values)
        ? Colors.orange
        :Colors.black87;
  }
  void onBtnTap(String value){
    if(value==Btn.del){
     delete();
     return;
    }
    if(value==Btn.clr)
      {
        clearAll();
        return;
      }
    if(value==Btn.per)
      {
        convertToPercentage();
        return;
      }
    if(value==Btn.calculate)
      {
        Calculate();
        return;
      }
    appendValue(value);
  }
  //Calculate
  void Calculate(){
    if(number1.isEmpty) return;
    if(operand.isEmpty) return;
    if(number2.isEmpty) return;
    double num1=double.parse(number1);
    double num2=double.parse(number2);
    var result=0.0;
    switch(operand){
      case Btn.add:
        result=num1+num2;
        break;
      case Btn.subtract:
        result=num1-num2;
        break;
      case Btn.multiply:
        result=num1*num2;
        break;
      case Btn.divide:
        result=num1/num2;
        break;
      default:
    }
    setState(() {
      number1="$result";
      if(number1.endsWith(".0")){
        number1=number1.substring(0,number1.length-2);
      }
      operand="";
      number2="";
    });
   }

  //convert output to persent
  void convertToPercentage(){
    if(number1.isNotEmpty && operand.isNotEmpty&& number2.isNotEmpty)
      {
            // calculate before convertion
            Calculate();
      }
    if(operand.isNotEmpty)
      {
        return;
      }
    final number=double.parse(number1);
    setState(() {
      number1="${(number/100)}";
      operand="";
      number2="";
    });
  }
  //clear all output
  void clearAll(){
    setState(() {
      number1="";
      operand="";
      number2="";
    });
  }

  //delete one fron the end
  void delete(){
    if(number2.isNotEmpty){
      //12323=>1232
      number2=number2.substring(0,number2.length-1);
    }
    else if(operand.isNotEmpty){
      operand="";
    }
    else if(number1.isNotEmpty){
      number1=number1.substring(0,number1.length-1);
    }
    setState(() {
    });
  }
  // appends value to the end
  void appendValue(String value) {
    // number1 opernad number2
    // 234       +      5343

    // if is operand and not "."
    if (value != Btn.dot && int.tryParse(value) == null) {
      // operand pressed
      if (operand.isNotEmpty && number2.isNotEmpty) {
        // TODO calculate the equation before assigning new operand
         Calculate();
      }
      operand = value;
    }
    // assign value to number1 variable
    else if (number1.isEmpty || operand.isEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        // ex: number1 = "" | "0"
        value = "0.";
      }
      number1 += value;
    }
    // assign value to number2 variable
    else if (number2.isEmpty || operand.isNotEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        // number1 = "" | "0"
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }
}
