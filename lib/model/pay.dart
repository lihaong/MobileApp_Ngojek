import 'package:hive/hive.dart';
part 'pay.g.dart';

@HiveType(typeId: 9)
class PayModel extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String? totalOrder;

  @HiveField(2)
  String? timeOrder;

  PayModel({required this.username, this.totalOrder, this.timeOrder});
}
