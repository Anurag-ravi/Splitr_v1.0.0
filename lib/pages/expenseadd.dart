// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:splitr/models/expense.dart';
import 'package:splitr/models/pay.dart';
import 'package:splitr/models/trip.dart';
import 'package:splitr/models/user.dart';
import 'package:splitr/utilities/boxes.dart';
import 'package:uuid/uuid.dart';

class ExpenseAdd extends StatefulWidget {
  const ExpenseAdd({Key? key, required this.trip}) : super(key: key);
  final Trip trip;
  @override
  State<ExpenseAdd> createState() => _ExpenseAddState();
}

class _ExpenseAddState extends State<ExpenseAdd> {
  String name = "";
  double amount = 0.0;
  DateTime dt = DateTime.now();
  int num = 0;
  List<User> users = [];
  List<bool> bySelect = [];
  List<bool> toSelect = [];
  List<double> byAmount = [];
  List<double> toAmount = [];
  TextEditingController dateinput = TextEditingController(); 
  List<TextEditingController> contr = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<User> list = Boxes.getUsers().values.toList().cast<User>();
    setState(() {
      users = list.where((element) => element.tripid == widget.trip.uuid).toList();
      bySelect = List.filled(users.length, false);
      toSelect = List.filled(users.length, true);
      byAmount = List.filled(users.length, 0.0);
      toAmount = List.filled(users.length, 0.0);
      contr = List.generate(users.length, (index) => TextEditingController());
      num = users.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense"),
        actions: [
          IconButton(onPressed: () {
            double spent=0,paid=0;
            for(int i=0;i<users.length;i++){
              if(bySelect[i]){ paid+=byAmount[i];}
              if(toSelect[i]){ spent+=toAmount[i];}
            }
            if((amount-spent).abs() <= 0.01 && (amount-paid).abs() <= 0.01){
              var box = Boxes.getExpenses();
              var uuid = Uuid().v1();
              List<Pay> by = [],to = [];
              for(int i=0;i<users.length;i++){
                if(bySelect[i]){ by.add(Pay(uuid: users[i].uuid,amount: byAmount[i],isBy:true,expenseid: uuid));}
                if(toSelect[i]){ to.add(Pay(uuid: users[i].uuid,amount: toAmount[i],isBy: false,expenseid: uuid));}
              }
              box.put(uuid, Expense(
                uuid: uuid,
                name: name,
                amount: amount,
                date: dt,
                tripid: widget.trip.uuid,
                by: by,
                to: to,
              ));
            } else {
              showDialog(
                context: context, 
                builder: (builder){
                  return AlertDialog(
                    title: Text("Wrong balance"),
                    content: Text("Please check the amount and numbers you have entered, it's inconsistent"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        }, 
                        child: Text("OK")
                      ),
                    ],
                  );
                });
            }
            // print();
          }, icon: Icon(Icons.check_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          TextField(
            decoration: InputDecoration(hintText: "Enter Expense Name"),
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
            decoration: InputDecoration(hintText: "Enter Amount"),
            onChanged: (value) {
              setState(() {
                amount = double.parse(value);
                toAmount = List.generate(toAmount.length, (index) => double.parse((amount/num).toStringAsFixed(2)));
                for (int i=0;i<contr.length;i++) {
                  contr[i].text = toAmount[i].toStringAsFixed(2);
                }
              });
            },
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: dateinput, //editing controller of this TextField
            decoration: InputDecoration( 
                icon: Icon(Icons.calendar_today), //icon of text field
                labelText: "Enter Date" //label text of field
            ),
            readOnly: true,  //set it true, so that user will not able to edit text
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context, 
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101)
              );
              
              if(pickedDate != null ){
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); 
                  setState(() {
                      dateinput.text = formattedDate; 
                      dt = pickedDate;
                  });
              }
            },
          ),
          SizedBox(
            height: 30,
          ),
          Text("By", style: TextStyle(fontSize: 20)),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              itemCount: users.length,
              physics: ClampingScrollPhysics(), 
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Checkbox(
                            value: bySelect[index],
                            onChanged: (value) {
                              setState(() {
                                bySelect[index] = value!;
                              });
                            }),
                      ),
                      Expanded(child: Text(users[index].name),flex: 5,),
                      Expanded(
                        flex: 3,
                        child: bySelect[index] ? TextField(
                          onChanged: (value) {
                            setState(() {
                              byAmount[index] = double.parse((double.parse(value)).toStringAsFixed(2));
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            hintText: "Amount",
                          ),
                          keyboardType: TextInputType.number,
                        ) : Container(),
                      ),
                    ],
                  ),
                );
              }),
          SizedBox(
            height: 30,
          ),
          Text("To", style: TextStyle(fontSize: 20)),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              itemCount: users.length,
              physics: ClampingScrollPhysics(), 
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Checkbox(
                            value: toSelect[index],
                            onChanged: (value) {
                              if(toSelect[index]) {
                                num--;
                              } else {
                                num++;
                              }
                              setState(() {
                                toSelect[index] = value!;
                                toAmount = List.generate(toAmount.length, (index) => double.parse((amount/num).toStringAsFixed(2)));
                                for (int i=0;i<contr.length;i++) {
                                  contr[i].text = toAmount[i].toStringAsFixed(2);
                                }
                              });
                            }),
                      ),
                      Expanded(child: Text(users[index].name),flex: 5,),
                      Expanded(
                        flex: 3,
                        child: toSelect[index] ? TextFormField(
                          onChanged: (value) {
                            setState(() {
                              toAmount[index] = double.parse((double.parse(value)).toStringAsFixed(2));
                            });
                          },
                          controller: contr[index],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            hintText: "Amount",
                            
                          ),
                          keyboardType: TextInputType.number,
                        ) : Container(),
                      ),
                    ],
                  ),
                );
              }),
        ]),
      ),
    );
  }
}
