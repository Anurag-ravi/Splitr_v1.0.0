// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:splitr/models/expense.dart';
import 'package:splitr/models/payment.dart';
import 'package:splitr/models/trip.dart';
import 'package:splitr/models/user.dart';
import 'package:splitr/utilities/boxes.dart';
import 'package:splitr/utilities/colors.dart';
import 'package:uuid/uuid.dart';

class HomeComponent extends StatefulWidget {
  const HomeComponent({ Key? key, required this.trip }) : super(key: key);
  final Trip trip;
  @override
  State<HomeComponent> createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
  String user = "";

  @override
  void initState() {
    super.initState();
    openBoxes();
  }
  Future<void> openBoxes() async {
    if(Hive.box<User>(widget.trip.uuid+"u").isOpen == false) await Hive.openBox<User>(widget.trip.uuid + "u");
    if(Hive.box<Expense>(widget.trip.uuid+"e").isOpen == false) await Hive.openBox<Expense>(widget.trip.uuid + "e");
    if(Hive.box<Payment>(widget.trip.uuid+"p").isOpen == false) await Hive.openBox<Payment>(widget.trip.uuid + "p");
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ValueListenableBuilder<Box<User>>(
          valueListenable: Boxes.getUsers(widget.trip.uuid).listenable(),
          builder: (context, box, child) {
            List<User> users = box.values.toList().cast<User>();
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                double net = user.paid-user.expense;
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(user.name),
                      Text(net.toString()),
                    ],
                  ),
                );
              }
              );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: getBackground(context),
        onPressed: (){
          showDialog(context: context, 
          builder: (context)=> AlertDialog(
            title: Text('Choose Action'),
            content: Container(
              height: deviceHeight * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(                    
                    onTap: () {
                      
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.money,size: 40,),
                          SizedBox(width: 10,),
                          Text('Add Expense'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.monetization_on_outlined,size: 40,),
                        SizedBox(width: 10,),
                        Text('Add Payment'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context, 
                        builder: (context)=> AlertDialog(
                          title: Text("Add Member"),
                          content: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter Member Name"
                            ),
                            onChanged: (value) {
                              setState(() {
                                user = value;
                              });
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              }, 
                              child: Text("Cancel")
                            ),
                            TextButton(
                              onPressed: () {
                                final userr = User(uuid: Uuid().v1(), name: user);
                                Boxes.getUsers(widget.trip.uuid+'u').add(userr);
                                setState(() {
                                  user="";
                                });
                                Navigator.of(context).pop();
                              }, 
                              child: Text("Add")
                            )
                          ],
                        )
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.person,size: 40,),
                          SizedBox(width: 10,),
                          Text('Add Member'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
        },
        child:  Icon(Icons.add),
      ),
    );
  }
}