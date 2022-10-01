import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'trip.g.dart';

@HiveType(typeId: 0)
class Trip extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
   String name;

  @HiveField(2)
   String currency;

  @HiveField(3,defaultValue: [])
  List<Uint8List> image;

  Trip(
      {required this.uuid,
      required this.name,
      required this.currency,
      this.image = const []});
}

