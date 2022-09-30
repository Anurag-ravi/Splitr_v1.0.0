// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:splitr/components/homecomponent.dart';
import 'package:splitr/models/trip.dart';
import 'package:splitr/utilities/boxes.dart';
import 'package:splitr/utilities/colors.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isEdit = false;
  int currIndex = 1;
  String tripName = "";
  late Trip trip;
  bool hasTrip = false;

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
                        height: deviceWidth*0.2,
                        padding: EdgeInsets.all(10),
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
                                style: TextStyle(fontSize: deviceWidth * 0.07),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.add
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
                                                final trip = Trip(uuid: Uuid().v1(), name: tripName, currency: "INR");
                                                Boxes.getTrips().add(trip);
                                                await Hive.openBox(trip.uuid+"u");
                                                await Hive.openBox(trip.uuid+"e");
                                                await Hive.openBox(trip.uuid+"p");
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
                                      isEdit ? Icons.check_rounded : Icons.edit
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
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currIndex = index;
                          trip = tripp;
                        });
                      },
                      child: Container(
                        color: currIndex==index ? getPrimary(context) : Colors.transparent,
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tripp.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: deviceWidth*0.06),),
                            isEdit ? GestureDetector(
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
      ),
      body: hasTrip ? HomeComponent(trip: trip) : Center(
        child: Text("Create a bill to Split"),
      ),
    );
  }
}