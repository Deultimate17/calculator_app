import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import '../model/calc_model.dart';

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
   String display = '';
   List<String> assemble = [];
   List<String> stack = [];
   bool isAfter = false;

   int index = -1;
   int index1 = -1;
   late double result;
   late double num1;
   late double num2;
   late String currentOperator = '';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children:[
            Container(
              alignment: Alignment.topRight,
              height: 100,
              child: Text(display,
              style: const TextStyle(
                fontSize: 23,

              ),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              child: GridView.builder(
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: Calc.pages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (context, index) {
              return buildNumbers(Calc.pages[index]);
              }),
            ),
                  ]
        ),
      ),
    );
  }

  Widget buildNumbers(Calc calculate) {
    return Container(
      height: 25,
      width: 25,
      margin: const EdgeInsets.all(5.0),
      decoration: const BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.all(Radius.circular(50.0))
      ),
      child: InkWell(
        child: Center(child: Text(calculate.numbers)),
            onTap: () {
         setState(() {
           if (calculate.numbers != 'C'
           && !isOperator(calculate.numbers)
               && calculate.numbers != '='
               && calculate.numbers != '+/-'
           ) {
             index++;
             print(index);
             assemble.add(calculate.numbers);
             display += assemble[index];
             print('you suck man');
           } else if (isOperator(calculate.numbers)) {
             // index1++;
             // stack.add(calculate.numbers);
             // display += stack[index1];
             // print(stack);
             // currentOperator = calculate.numbers;
             index++;
             print(index);
             assemble.add(calculate.numbers);
             display += assemble[index];
           } else if (calculate.numbers == '=') {
             final expression = assemble.join('');
             print(expression);
             final result = evaluateExpression(expression);
             if (result != null) {
               assemble = [result.toString()];
               print(assemble);
               display = result.toString();
               print(display);
               index = 0;
             } else if (calculate.numbers == 'C') {
               display = '';
             }
             else {
               display = 'Error';
               assemble = [];
               index = -1;
             }
           }
           else {
             print('you rock');
           }
         });
    },
      ),
    );
  }


   num? evaluateExpression(String expression) {
     try {
       if (expression.contains('+') || expression.contains('-') || expression.contains('x') || expression.contains('/') || expression.contains('%')) {
         final result = Function.apply(_performOperation, [expression]);
         return result;
       } else {
         return num.parse(expression);
       }
     } catch (e) {
       print('Error during expression evaluation: $e');
       return null;
     }
   }

   static num _performOperation(String expression) {
     final parts = expression.split(RegExp(r'(\+|\-|x|\/|\%)'));
     final operators = expression.split(RegExp(r'[0-9.]')).where((element) => element.isNotEmpty).toList();
     num result = num.parse(parts.first);
     for (int i = 0; i < operators.length; i++) {
       final num nextNumber = num.parse(parts[i + 1]);
       final op = operators[i];
       switch (op) {
         case '+':
           result += nextNumber;
           break;
         case '-':
           result -= nextNumber;
           break;
         case 'x':
           result *= nextNumber;
           break;
         case '/':
           result /= nextNumber;
           break;
         case '%':
           result %= nextNumber;
           break;
       }
     }
     return result;
   }
   bool isOperator(String value) {
    return value == '+' ||
        value  == '-' ||
        value == 'x' ||
        value == '/' ||
     value == '%';
   }

}
