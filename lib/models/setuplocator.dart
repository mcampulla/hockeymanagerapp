import 'package:get_it/get_it.dart';

import 'manager.service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(ManagerService());
}