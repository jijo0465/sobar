import 'package:flutter/widgets.dart';

class ExpensePage extends StatefulWidget{
  const ExpensePage();
  @override
  State<StatefulWidget> createState() {
    return _ExpensePage();
  }
}

class _ExpensePage extends State<ExpensePage>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Expense Page"),
    );
  }

}