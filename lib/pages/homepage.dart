// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:splitr/components/expensecomponent.dart';
import 'package:splitr/components/homecomponent.dart';
import 'package:splitr/components/paymentcomponent.dart';
import 'package:splitr/models/expense.dart';
import 'package:splitr/models/payment.dart';
import 'package:splitr/models/trip.dart';
import 'package:splitr/models/user.dart';
import 'package:splitr/utilities/boxes.dart';
import 'package:splitr/utilities/colors.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin  {
  bool isEdit = false;
  int currIndex = 1;
  String tripName = "";
  late Trip trip;
  bool hasTrip = false;
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var trips = Boxes.getTrips().values.toList().cast<Trip>();
    if(trips.length == 0){
      setState(() {
        hasTrip = false;
        trip = Trip(uuid: Uuid().v1(), name: "Trip 1", currency: "INR");
      });
    } else {
      setState(() {
        hasTrip = true;
        trip = trips[0];
      });
    }
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(
        child: ValueListenableBuilder<Box<Trip>>(
          valueListenable: Boxes.getTrips().listenable(),
          builder: (context, box, _) {
          List<Trip> trips = box.values.toList().cast<Trip>();
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: deviceHeight * 0.95,
                child: ListView.builder(
                  itemCount: trips.length + 1,
                  itemBuilder: (context, index) {
                    if(index == 0){
                      return Container(
                        height: deviceWidth*0.25,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: getPrimary(context),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white,
                              width: 1
                            )
                          )
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Trips",
                                style: TextStyle(fontSize: deviceWidth * 0.09, color: Colors.white),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.add
                                      ,color: Colors.white,
                                      ),
                                    onPressed: () {
                                      showDialog(
                                        context: context, 
                                        builder: (context)=> AlertDialog(
                                          title: Text("Add Trip"),
                                          content: TextField(
                                            decoration: InputDecoration(
                                              hintText: "Enter Trip Name"
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                tripName = value;
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
                                              onPressed: () async {
                                                if(tripName != ""){
                                                  var uuid = Uuid().v1();
                                                  final trip = Trip(uuid: uuid, name: tripName, currency: "INR");
                                                  Boxes.getTrips().put(uuid,trip);
                                                  setState(() {
                                                    hasTrip = true;
                                                    this.trip = trip;
                                                  });
                                                  if(Boxes.getTrips().values.toList().cast<Trip>().length != 1){
                                                    setState(() {
                                                      currIndex = currIndex + 1;
                                                    });
                                                  }
                                                  Navigator.of(context).pop();
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a trip name")));
                                                }
                                              }, 
                                              child: Text("Add")
                                            )
                                          ],
                                        )
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isEdit ? Icons.check_rounded : Icons.edit,
                                      color: Colors.white,
                                      ),
                                    onPressed: () {
                                      setState(() {
                                        isEdit = !isEdit;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          )
                      );
                    }
                    var tripp = trips[index-1];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          currIndex = index;
                          trip = tripp;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: currIndex==index ? Colors.grey[200]: Colors.transparent,
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tripp.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: deviceWidth*0.06),),
                            isEdit ? InkWell(
                              child: Icon(Icons.delete),
                              onTap: () {
                                showDialog(
                                  context: context, 
                                  builder: (context) => AlertDialog(
                                    title: Text("Delete Trip"),
                                    content: Text("Are you sure you want to delete the trip - ${tripp.name}?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }, 
                                        child: Text("Cancel")
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          var expenses = Boxes.getExpenses().values.toList().cast<Expense>();
                                          for(var expense in expenses){
                                            if(expense.tripid == tripp.uuid){
                                              Boxes.getExpenses().delete(expense.uuid);
                                            }
                                          }
                                          var users = Boxes.getUsers().values.toList().cast<User>();
                                          for(var user in users){
                                            if(user.tripid == tripp.uuid){
                                              Boxes.getUsers().delete(user.uuid);
                                            }
                                          }
                                          var payments = Boxes.getPayments().values.toList().cast<Payment>();
                                          for(var payment in payments){
                                            if(payment.tripid == tripp.uuid){
                                              Boxes.getPayments().delete(payment.uuid);
                                            }
                                          }
                                          tripp.delete();
                                          if(trips.length == 1){
                                            setState(() {
                                              hasTrip = false;
                                              currIndex = 1;
                                            });
                                          } else{
                                            if(tripp == trips[0]){
                                              setState(() {
                                                trip = trips[1];
                                                currIndex = 1;
                                              });
                                            } else {
                                              setState(() {
                                                trip = trips[0];
                                                currIndex = 1;
                                              });
                                            }
                                          }
                                        }, 
                                        child: Text("Delete")
                                      ),
                                    ],
                                  )
                                  );
                              },
                              ) : Container(),
                            ],),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("\u00a9 2022, Anurag Ravi, all rights reserved",style: TextStyle(fontSize: 13),),
                ),
              )
            ],
          );
        },)
        ,
      ),
      appBar: AppBar(
        title: Text(hasTrip ? trip.name : "Splitr"),
        bottom: hasTrip ? TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: "Overview",
            ),
            Tab(
              text: "Expenses",
            ),
            Tab(
              text: "Payments",
            ),
          ],
        ) : null,
        actions: [
          PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Text("Edit Trip"),
                    value: "Edit Trip",
                  ),
                ];
              },
              onSelected: (value) {
                if (value == "Edit Trip") {
                  showDialog(
                    context: context, 
                    builder: (context)=> AlertDialog(
                      title: Text("Edit Trip"),
                      content: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Trip Name"
                        ),
                        initialValue: trip.name,
                        onChanged: (value) {
                          setState(() {
                            tripName = value;
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
                          onPressed: () async {
                            if(tripName != ""){
                              trip.name = tripName;
                              trip.save();
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a trip name")));
                            }
                          }, 
                          child: Text("Edit")
                        )
                      ],
                    )
                  );
                }
              },
              elevation: 5.0,
            ),
        ],
      ),
      body: hasTrip ? 
      TabBarView(
        controller: _tabController,
        children: [
          HomeComponent(trip: trip),
          ExpenseComponent(trip: trip),
          PaymentComponent(trip: trip),
        ]
        )
       : Center(
        child: Text("Create a bill to Split"),
      ),
    );
  }
}