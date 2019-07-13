import 'package:dart_json1/course.dart';

class Student {
  final String name;
  final String email;
  final DateTime dob;
  List<Course> courses;

  Student(this.name, this.email, this.dob);
}
