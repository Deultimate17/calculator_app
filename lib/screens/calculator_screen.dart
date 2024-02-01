import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/calc_model.dart';

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
   String display = '';
   List<String> assemble = [];

   int index = -1;
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
              height: 100,
              child: Text(display),
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
               && calculate.numbers != '+'
               && calculate.numbers != '/'
               && calculate.numbers != 'x'
               && calculate.numbers != '-'
               && calculate.numbers != '%'
               && calculate.numbers != '='
               && calculate.numbers != '+/-'
           ) {
             index++;
             print(index);
             assemble.add(calculate.numbers);
             display += assemble[index];
             print('you suck man');
           } else if ( calculate.numbers == '+'
           || calculate.numbers == '/'
           || calculate.numbers == 'x'
           || calculate.numbers == '-'
           || calculate.numbers == '%') {
             index++;
             assemble.add(calculate.numbers);
             display += assemble[index];
             currentOperator = calculate.numbers;
           } else if (calculate.numbers == '=') {
             print(assemble);
           }
           else {
             print('you rock');
           }
         });
    },
      ),
    );
  }
}
