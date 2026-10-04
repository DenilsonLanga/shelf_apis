
import 'package:shelf_apis/app/helpers/request_mapping.dart';

class CreateSupplierViewModel extends RequestMapping {
   late String supplierName;
   late int categoryID;
   late String email;
   late String password;

  CreateSupplierViewModel(super.dataRequest);
   
     @override
     void map() {
      supplierName = data['supplier_name'];
      email = data['email'];
      password = data['password'];
      categoryID = data['category_id'];
     }


}