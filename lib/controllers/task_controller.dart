import 'package:get/get.dart';

class TaskController extends GetxController {
  final _checkedTasks = List.filled(6, false).obs;

  List<bool> get checkedTasks => _checkedTasks;

  void toggleTask(int index) {
    _checkedTasks[index] = !_checkedTasks[index];
    update();
  }

  int get completedTasksCount => _checkedTasks.where((task) => task).length;

  double get completionPercentage {
    final totalTasks = _checkedTasks.length;
    if (totalTasks == 0) return 0.0;
    return (completedTasksCount / totalTasks) * 100;
  }
}
