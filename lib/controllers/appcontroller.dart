import 'user_controller.dart';
import 'calendar_controller.dart';
import '../models/event.dart';
import '../models/user.dart';
import 'package:hive/hive.dart';

class AppController {
  final UserController userController = UserController();
  final CalendarController calendarController = CalendarController();

  AppController() {
    init();
  }

  Future<void> init() async {
    print('zizi');
    await userController.openBox();
    await calendarController.openBox();
  }


  Future<void>toogleEventFinished(Event event) async {
    final eventIndex = calendarController.getEventIndex(event);
    if (eventIndex == null) {
      return ;
    }
    if (!calendarController.isEventFinished(event)) {
      await userController.addActionToUser(calendarController.getEventDate(event));
    } else {
      await userController.deleteActionToUser(calendarController.getEventDate(event));
    }
    await calendarController.toogleEventFinished(event);
  }
}
