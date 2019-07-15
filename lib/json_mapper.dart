import 'dart:convert';
import 'package:dart_json1/student.dart';
import 'course.dart';

abstract class CourseJsonMapper {
  static Course fromJsonMap(Map<String, dynamic> json) {
    int id = json['id'];
    String name = json['name'];
    String instructor = json['instructor'];
    Course c = new Course(id, name, instructor);
    return c;
  }

  //Useful diagnostic method for running through the JSON to see how decoding works 
  static void unwrap(List<dynamic> dynamicList) {
    print('===========Courses List===========');
    print(dynamicList);
    print('Type: ${dynamicList.runtimeType}'); //List<dynamic> and dynamic is a Map<String, dynamic> representing each student as a Map<String, dynamic>
    print('===========Looping===========');
    dynamicList.forEach((f) {
      print('===========Element');
      print(f);
      print('Type: ${f.runtimeType}'); //_InternalLinkedHashMap<String, dynamic>
      print('===========Element Properties and Values');
      (f as Map<String, dynamic>).forEach((g, h) {
        print('${g}: ${h}'); //prints the property name and value from the json
      });
    });
  }

}

abstract class StudentJsonMapper {
  //Given a JSON string, decode as a Student
  static Student fromJson(String jsonString) {
    Map<String, dynamic> m = jsonDecode(jsonString);
    return StudentJsonMapper.fromJsonMap(m);
  }

  //Given a Map (property names are keys, property values are the values), decode as a Student
  static Student fromJsonMap(Map<String, dynamic> json) {
    String name = json['name'];
    String email = json['email'];
    DateTime dob = DateTime.parse(json['dob']);
    Student s = new Student(name, email, dob);

    //Handle courses if present
    if (json.keys.any((a) => a == 'courses')) {
      List<dynamic> dynamicList = json['courses'];
      List<Course> courses = new List<Course>();
      dynamicList.forEach((f) {
        Course c = CourseJsonMapper.fromJsonMap(f);
        courses.add(c);
      });
      s.courses = courses;
    }

    return s;
  }

  //Given a JSON string representing an array of Students, decode as a List of Student
  static List<Student> fromJsonArray(String jsonString) {
    Map<String, dynamic> decodedMap = jsonDecode(jsonString);
    List<dynamic> dynamicList = decodedMap['students'];
    List<Student> students = new List<Student>();
    dynamicList.forEach((f) {
      Student s = StudentJsonMapper.fromJsonMap(f);
      students.add(s);
    });

    return students;
  }

  //Given a student, encode as Json
  static String toJson(Student s) {
    Map<String, dynamic> map() =>
        {'name': s.name, 'email': s.email, 'dob': s.dob.toIso8601String()};
    String result = jsonEncode(map());
    return result;
  }

  //Given a list of students, encode as Json
  static String listToJson(List<Student> students) {
    List<Map<String, String>> x = students
        .map((f) =>
            {'name': f.name, 'email': f.email, 'dob': f.dob.toIso8601String()})
        .toList();

    Map<String, dynamic> map() => {'students': x};
    String result = jsonEncode(map());
    return result;
  }

  //Useful diagnostic method for running through the JSON to see how decoding works
  static void unwrap(String jsonString) {
    print("**************Unwrapping JSON**************");
    print(jsonString);
    print("*******************************************");
    print("");
    Map<String, dynamic> decodedMap = jsonDecode(jsonString);
    List<dynamic> dynamicList = decodedMap['students'];
    print('Here is what that JSON looks like once it is decoded:');
    print(dynamicList);
    print('Type: ${dynamicList.runtimeType}'); //List<dynamic> and dynamic is a Map<String, dynamic> representing each student as a Map<String, dynamic>
    print('===========Looping===========');
    dynamicList.forEach((f) {
      print('===========Element');
      print(f);
      print('Type: ${f.runtimeType}'); //_InternalLinkedHashMap<String, dynamic>
      print('===========Element Properties and Values');
      (f as Map<String, dynamic>).forEach((g, h) {
        if (g == 'courses') {
          print(g);
          CourseJsonMapper.unwrap(h);
        } else {
          print('${g}: ${h}'); //prints the property name and value from the json
        }
      });
    });
  }
}
