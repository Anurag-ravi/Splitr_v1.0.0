import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:splitr/models/expense.dart';
import 'package:splitr/models/trip.dart';
import 'package:splitr/pages/expenseupdate.dart';
import 'package:splitr/utilities/boxes.dart';

class ExpenseComponent extends StatefulWidget {
  const ExpenseComponent({ Key? key, required this.trip }) : super(key: key);
  final Trip trip;
  @override
  State<ExpenseComponent> createState() => _ExpenseComponentState();
}

class _ExpenseComponentState extends State<ExpenseComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ValueListenableBuilder<Box<Expense>>(
          valueListenable: Boxes.getExpenses().listenable(),
          builder: (context, box, child) {
            List<Expense> expenses = box.values.toList().cast<Expense>();
            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                var expense = expenses[index];
                return expense.tripid == widget.trip.uuid ? InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>ExpenseUpdate(expense: expense)));
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
                        Text(expense.name),
                        Text(expense.amount.toString()),
                      ],
                    ),
                  ),
                ) : Container();
              }
              );
          },
        ),
      ),
    );
  }
}