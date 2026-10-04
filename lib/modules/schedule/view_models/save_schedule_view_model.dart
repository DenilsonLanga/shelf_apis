
import 'package:shelf_apis/app/helpers/request_mapping.dart';

class SaveScheduleViewModel extends RequestMapping {
  final int userId;
  late DateTime scheduleDate;
  late String name;
  late String petName;
  late int supplierId;
  late List<int> servicesID;

  SaveScheduleViewModel(super.dataRequest, {required this.userId});
  
  @override
  void map() {
    scheduleDate = DateTime.parse(data['date']);
    name = data['name'];
    petName = data['pet_name'];
    supplierId = data['supplier_id'];
    servicesID = List.castFrom<dynamic,int>(data['services']);
  }
  
}