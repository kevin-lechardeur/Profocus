import 'package:hive/hive.dart';

part 'event.g.dart';

@HiveType(typeId: 0)
class Event {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime startTime;

  @HiveField(2)
  DateTime endTime;

  @HiveField(3)
  bool isFinished = false;

  Event({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.isFinished = false,
  });


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Event) return false;
    return startTime == other.startTime && endTime == other.endTime && title == other.title && isFinished == other.isFinished;
  }

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode ^ title.hashCode ^ isFinished.hashCode;
}
