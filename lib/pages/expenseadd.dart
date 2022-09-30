// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitr/models/trip.dart';
import 'package:splitr/models/user.dart';
import 'package:splitr/utilities/boxes.dart';

class ExpenseAdd extends StatefulWidget {
  const ExpenseAdd({ Key? key,required this.trip }) : super(key: key);
  final Trip trip;
  @override
  State<ExpenseAdd> createState() => _ExpenseAddState();
}

class _ExpenseAddState extends State<ExpenseAdd> {
  String name = "";
  double amount = 0.0;
  List<User> users = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<User> list = Boxes.getUsers().values.toList().cast<User>();
    setState(() {
      users = list.where((element) => element.tripid == widget.trip.uuid).toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense"),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.check_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children:[
            TextField(
              decoration: InputDecoration(
                hintText: "Enter Expense Name"
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter Amount"
              ),
              onChanged: (value) {
                setState(() {
                  amount = double.parse(value);
                });
              },
               keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 200,
              child: ListView.builder(
                itemCount: users.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
                  return Text(users[index].name);
                }
                ),
            )
          ]
        ),
      ),
    );
  }
}