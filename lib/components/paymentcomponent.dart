// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:splitr/models/expense.dart';
import 'package:splitr/models/payment.dart';
import 'package:splitr/models/trip.dart';
import 'package:splitr/pages/paymentupdate.dart';
import 'package:splitr/utilities/boxes.dart';

class PaymentComponent extends StatefulWidget {
  const PaymentComponent({ Key? key, required this.trip }) : super(key: key);
  final Trip trip;
  @override
  State<PaymentComponent> createState() => _PaymentComponentState();
}

class _PaymentComponentState extends State<PaymentComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ValueListenableBuilder<Box<Payment>>(
          valueListenable: Boxes.getPayments().listenable(),
          builder: (context, box, child) {
            List<Payment> payments = box.values.toList().cast<Payment>();
            return ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                var payment = payments[index];
                if(payment.tripid == widget.trip.uuid){
                  String from = "", to = "";
                  from = Boxes.getUsers().get(payment.from)!.name;
                  to = Boxes.getUsers().get(payment.to)!.name;
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentUpdate(payment: payment,)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200]
                      ),
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("From : " + from),
                              Text("To : " + to),
                            ],
                          ),
                          Text(payment.amount.toString()),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();     
                }
              }
              );
          },
        ),
      ),
    );
  }
}