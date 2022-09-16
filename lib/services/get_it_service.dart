import 'package:turtle_messenger/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

GetIt getItInstanceConst = GetIt.instance;

class GetItService {
  static void setupLocator() {
    getItInstanceConst.registerLazySingleton(() => NavigationService());
  }
}
