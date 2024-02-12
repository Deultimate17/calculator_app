import 'package:flutter/material.dart';
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
    String finalResult = '';

    final TextEditingController _textController = TextEditingController();

   int index = -1;
   late String currentOperator = '';
   int cursorPosition = 0;




   @override
  void dispose() {
    // TODO: implement dispose
     _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children:[
            Padding(
              padding: const EdgeInsets.only(top: 20.0,),
              child: Container(
                alignment: Alignment.topRight,
                height: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        cursorColor: Colors.red,
                        showCursor: true,
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none
                        ),
                       controller: _textController,
                      )
                    ),
                    const SizedBox(height: 36.0,),
                    Text(finalResult,
                      style: const TextStyle(
                          fontSize: 26.0,

                      ),),
                  ],
                )
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
        child: Center(child: Text(calculate.numbers,
          style: const TextStyle(
              fontSize: 20.0
          ),)),
            onTap: () {
         setState(() {
           if (calculate.numbers != 'C'
           && !isOperator(calculate.numbers)
               && calculate.numbers != '='
               && calculate.numbers != 'DEL'
           && calculate.numbers != '()'
           ) {
             index++;
             assemble.add(calculate.numbers);
             display += assemble[index];
           } else if (isOperator(calculate.numbers)) {
              index++;
             assemble.add(calculate.numbers);
             display += assemble[index];

             if (finalResult != '') {
               assemble =[finalResult];
               display = finalResult;
               finalResult = '';
               assemble.add(calculate.numbers);
               display += assemble[index];


             }

           }  else if (calculate.numbers == '=') {
             equalTo();

           } else if (calculate.numbers == 'C') {
             allClear();
            } else if ( calculate.numbers == "()" && getCursorPosition(_textController) == 0) {
             index++;
             assemble.add('(');
             display += assemble[index];
           } else if (calculate.numbers == "()" && getCursorPosition(_textController) != 0){
             bracket();
           }

           else if (calculate.numbers == 'DEL') {
             delete();
           }


           _textController.text = display;


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
          expression = expression.replaceAll('x', '*');


     while (expression.contains('(')) {
       final startBracketIndex = expression.lastIndexOf('(');
       final endBracketIndex = expression.indexOf(')', startBracketIndex);

       if (endBracketIndex == -1) {
         return double.nan;
       }

       final innerExpression = expression.substring(startBracketIndex + 1, endBracketIndex);
       final innerResult = _performOperation(innerExpression);

       if (innerResult.isNaN) {
         return double.nan;
       }

       expression = expression.replaceRange(startBracketIndex, endBracketIndex + 1, innerResult.toString());
     }

     final parts = expression.split(RegExp(r'(\+|\-|\*|\/|\%)'));
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
         case '*':
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

   void delete() {
     assemble.removeAt(assemble.length - 1);
     index--;
     display = assemble.join('');

   }

   void bracket() {
     if (assemble.last == 'x' || assemble.last == '/' || assemble.last == '+' || assemble.last == '-' || assemble.last == '%' ) {
       index++;
       assemble.add('(');
       display += assemble[index];
     } else {
       index++;
       assemble.add(')');
       display += assemble[index];

     }
   }

   void allClear(){
     display = '';
     finalResult = '';
     assemble = [];
     index = -1;
   }

   void equalTo() {
     final expression = assemble.join('');
     final result = evaluateExpression(expression);
     if (result != null) {
       assemble = [result.toString()];
       finalResult = result.toString();
       index = 0;
     }
     else {
       display = 'Invalid format';
       assemble = [];
       index = -1;
     }
   }

   bool isOperator(String value) {
    return value == '+' ||
        value  == '-' ||
        value == 'x' ||
        value == '/' ||
     value == '%';
   }

   int getCursorPosition(TextEditingController controller) {
     // Get the current cursor position
     final int cursorPosition = controller.selection.baseOffset;
     return cursorPosition;
   }

}
