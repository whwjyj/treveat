import 'package:intl/intl.dart';

String getToday(){
  String Today="";
  DateTime now= DateTime.now();
  DateFormat formatter = DateFormat('yyy-MM-dd HH:mm:ss');
  Today = formatter.format(now);
  return Today;
}