import 'package:turtle_messenger/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

// ignore: non_constant_identifier_names
GetIt get_it_instance_const = GetIt.instance;

class GetItService {
  static void setupLocator() {
    get_it_instance_const.registerLazySingleton(() => NavigationService());
  }
}
