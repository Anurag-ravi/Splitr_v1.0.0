// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:splitr/models/expense.dart';
import 'package:splitr/models/pay.dart';
import 'package:splitr/models/payment.dart';
import 'package:splitr/models/trip.dart';
import 'package:splitr/models/user.dart';
import 'package:splitr/utilities/boxes.dart';
import 'package:splitr/utilities/calculate.dart';
import 'package:uuid/uuid.dart';

class PaymentAdd extends StatefulWidget {
  const PaymentAdd({Key? key, required this.trip}) : super(key: key);
  final Trip trip;
  @override
  State<PaymentAdd> createState() => _PaymentAddState();
}

class _PaymentAddState extends State<PaymentAdd> {
  double amount = 0.0;
  DateTime dt = DateTime.now();
  String byValue = "",toValue = "";
  List<User> users = [];
  TextEditingController dateinput = TextEditingController(); 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<User> list = Boxes.getUsers().values.toList().cast<User>();
    setState(() {
      users = list.where((element) => element.tripid == widget.trip.uuid).toList();
      byValue = users[0].uuid;
      toValue = users[0].uuid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Payment"),
        actions: [
          IconButton(onPressed: () {
            if(amount == 0.0 || byValue == "" || toValue == ""){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all the fields")));
            }
            else if(byValue == toValue){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select different users")));
            }
            else if(amount >= 0.0){
              var box = Boxes.getPayments();
              var uuid = Uuid().v1();
              Payment pay = Payment(
                uuid: uuid,
                tripid: widget.trip.uuid,
                amount: amount,
                from: byValue,
                to: toValue,
                date: dt
              );
              box.put(uuid, pay);
              calculateForUser(widget.trip.uuid);
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
          TextField(
            decoration: InputDecoration(hintText: "Enter Amount"),
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
          DropdownButton(
              value: byValue,
              icon: const Icon(Icons.keyboard_arrow_down),   
              items: users.map((User item) {
                return DropdownMenuItem(
                  value: item.uuid,
                  child: Text(item.name),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  byValue = newValue!;
                });
              },
            ),
          SizedBox(
            height: 30,
          ),
          Text("To", style: TextStyle(fontSize: 20)),
          SizedBox(
            height: 10,
          ),
          DropdownButton(
              value: toValue,
              icon: const Icon(Icons.keyboard_arrow_down),   
              items: users.map((User item) {
                return DropdownMenuItem(
                  value: item.uuid,
                  child: Text(item.name),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  toValue = newValue!;
                });
              },
            ),
        ]),
      ),
    );
  }
}
