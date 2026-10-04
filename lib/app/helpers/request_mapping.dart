import 'dart:convert';

abstract class RequestMapping {
late Map<String, dynamic> data;

RequestMapping.empty() : data = {};

RequestMapping(String dataRequest) {
  data = jsonDecode(dataRequest);
  map();
} 

void map();
}