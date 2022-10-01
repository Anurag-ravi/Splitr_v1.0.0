// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:splitr/models/expense.dart';
import 'package:splitr/models/pay.dart';
import 'package:splitr/models/trip.dart';
import 'package:splitr/models/user.dart';
import 'package:splitr/utilities/boxes.dart';
import 'package:splitr/utilities/calculate.dart';
import 'package:uuid/uuid.dart';

class ExpenseUpdate extends StatefulWidget {
  const ExpenseUpdate({Key? key, required this.expense}) : super(key: key);
  final Expense expense;
  @override
  State<ExpenseUpdate> createState() => _ExpenseUpdateState();
}

class _ExpenseUpdateState extends State<ExpenseUpdate> {
  String name = "";
  double amount = 0.0;
  DateTime dt = DateTime.now();
  int num = 0,num2=0;
  List<User> users = [];
  List<bool> bySelect = [];
  List<bool> toSelect = [];
  TextEditingController dateinput = TextEditingController(); 
  List<TextEditingController> contr = [];
  List<TextEditingController> contr2 = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<User> list = Boxes.getUsers().values.toList().cast<User>();
    setState(() {
      name = widget.expense.name;
      amount = widget.expense.amount;
      dt = widget.expense.date;
      dateinput.text = DateFormat.yMd().format(widget.expense.date);
      users = list.where((element) => element.tripid == widget.expense.tripid).toList();
      bySelect = List.filled(users.length, false);
      toSelect = List.filled(users.length, true);
      contr = List.generate(users.length, (index) => TextEditingController());
      contr2 = List.generate(users.length, (index) => TextEditingController());
      for(int i=0;i<users.length;i++){
        for(var by in widget.expense.by){
          if(by.uuid == users[i].uuid){
            bySelect[i] = true;
            num++;
            contr[i].text = by.amount.toString();
          }
        }
        for(var to in widget.expense.to){
          if(to.uuid == users[i].uuid){
            toSelect[i] = true;
            num2++;
            contr2[i].text = to.amount.toString();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Expense"),
        actions: [
          IconButton(
            onPressed: () {
            double spent=0,paid=0;
            for(int i=0;i<users.length;i++){
              if(bySelect[i]){ paid+=double.parse(contr[i].text);}
              if(toSelect[i]){ spent+=double.parse(contr2[i].text);}
            }
            if(name == "" || amount == 0.0 || paid == 0.0 || spent == 0.0){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all the fields")));
            }
            else if((amount-spent).abs() <= 0.01 && (amount-paid).abs() <= 0.01 && amount >= 0.0){
              List<Pay> by = [],to = [];
              for(int i=0;i<users.length;i++){
                if(bySelect[i]){ by.add(Pay(uuid: users[i].uuid,amount: double.parse(contr[i].text),isBy:true,expenseid: widget.expense.uuid));}
                if(toSelect[i]){ to.add(Pay(uuid: users[i].uuid,amount: double.parse(contr2[i].text),isBy: false,expenseid: widget.expense.uuid));}
              }
              widget.expense.name = name;
              widget.expense.amount = amount;
              widget.expense.date = dt;
              widget.expense.by = by;
              widget.expense.to = to;
              widget.expense.save();
              calculateForUser(widget.expense.tripid);
              Navigator.pop(context);
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
          TextFormField(
            decoration: InputDecoration(hintText: "Enter Expense Name"),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
            initialValue: widget.expense.name,
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            decoration: InputDecoration(hintText: "Enter Amount"),
            onChanged: (value) {
              setState(() {
                amount = double.parse(value);
                for (int i=0;i<contr.length;i++) {
                  contr[i].text = (amount/num).toStringAsFixed(2);
                  contr2[i].text = (amount/num2).toStringAsFixed(2);
                }
              });
            },
            initialValue: widget.expense.amount.toString(),
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
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
                              if(bySelect[index]) {
                                num--;
                              } else {
                                num++;
                              }
                              setState(() {
                                bySelect[index] = value!;
                                for (int i=0;i<contr.length;i++) {
                                  contr[i].text = (amount/num).toStringAsFixed(2);
                                }
                              });
                            }),
                      ),
                      Expanded(child: Text(users[index].name),flex: 5,),
                      Expanded(
                        flex: 3,
                        child: bySelect[index] ? TextFormField(
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
                                num2--;
                              } else {
                                num2++;
                              }
                              setState(() {
                                toSelect[index] = value!;
                                for (int i=0;i<contr.length;i++) {
                                  contr2[i].text = (amount/num2).toStringAsFixed(2);
                                }
                              });
                            }),
                      ),
                      Expanded(child: Text(users[index].name),flex: 5,),
                      Expanded(
                        flex: 3,
                        child: toSelect[index] ? TextFormField(
                          controller: contr2[index],
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red)
                    ),
                    child: Text("Delete"),
                    onPressed: () {
                      showDialog(
                        context: context, 
                        builder: (context) => AlertDialog(
                          title: Text("Delete Expense"),
                          content: Text("Are you sure you want to delete this expense - ${widget.expense.name}?"),
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
                                var tripid = widget.expense.tripid;
                                Boxes.getExpenses().delete(widget.expense.uuid);
                                calculateForUser(tripid);
                                Navigator.of(context).pop();
                              }, 
                              child: Text("Delete")
                            ),
                          ],
                        )
                        );
                    },
                  ),
                ),
              )
        ]),
      ),
    );
  }
}
