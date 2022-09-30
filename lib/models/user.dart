import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double paid;

  @HiveField(3)
  final double expense;

  User(
      {required this.uuid,
      required this.name,
      this.paid = 0,
      this.expense = 0});
}
