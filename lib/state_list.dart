import 'package:flutter/material.dart';
class StateList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _StateList();
      }
    }
    
class _StateList extends State<StateList>{
  List _states =  ["Kerala", "Tamil Nadu", "Karnataka", "Maharastra", "Delhi"];
  List<DropdownMenuItem<String>> _dropDownStates;
  String _currentState;
  @override
  void initState() {
    super.initState();
    _dropDownStates = getDropDownStateItems();
    _currentState="Kerala";
      }
  @override
  Widget build(BuildContext context) {
    return Container(
      
      child:DropdownButton(
      value: _currentState,
      items: _dropDownStates,
      onChanged: changedState,
      ));
  }

  List<DropdownMenuItem<String>> getDropDownStateItems() {
      List<DropdownMenuItem<String>> items = new List();
    for (String state in _states) {
      items.add(new DropdownMenuItem(
          value: state,
          child: new Text(state)
      ));
    }
    return items;
  }

  void changedState(String value) {
  setState(() {
    _currentState=value; 
  });
  }
}