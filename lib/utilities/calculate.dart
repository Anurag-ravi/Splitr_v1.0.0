import 'package:splitr/models/expense.dart';
import 'package:splitr/models/payment.dart';
import 'package:splitr/models/user.dart';
import 'package:splitr/utilities/boxes.dart';

void calculateForUser(String tripid){
    var users = Boxes.getUsers().values.toList().cast<User>();
    var expenses = Boxes.getExpenses().values.toList().cast<Expense>();
    var payments = Boxes.getPayments().values.toList().cast<Payment>();
    users = users.where((element) => element.tripid == tripid).toList();
    expenses = expenses.where((element) => element.tripid == tripid).toList();
    payments = payments.where((element) => element.tripid == tripid).toList();
    for(var user in users){
      user.expense = 0;
      user.paid = 0;
      for (var element in expenses) {
        for(var paid in element.by){
          if(paid.uuid == user.uuid && paid.expenseid == element.uuid && paid.isBy){
            user.paid += paid.amount;
          }
        }
        for(var paid in element.to){
          if(paid.uuid == user.uuid && paid.expenseid == element.uuid && !paid.isBy){
            user.expense += paid.amount;
          }
        }
      }
      for (var element in payments) {
        if(element.from == user.uuid){
          user.paid += element.amount;
        }
        if(element.to == user.uuid){
          user.expense += element.amount;
        }
      }
      user.save();
    }
}