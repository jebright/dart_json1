import 'package:dart_json1/json_mapper.dart';
import 'package:dart_json1/student.dart';
import 'package:test/test.dart';

void main() {

  String json =
      '{"name":"John Smith","email":"john@example.com","dob":"2000-02-14T00:00:00.000"}';

  String jsonArray = 
  '{"students":[{"name":"John Smith","email":"john@example.com","dob":"2000-02-14T00:00:00.000"},{"name":"Jane Blythe","email":"jane@example.com","dob":"1999-03-01T00:00:00.000"}]}';

  String jsonArrayWithCourses = 
'''{
	"students": [{
		"name": "John Smith",
		"email": "john@example.com",
		"dob": "2000-02-14T00:00:00.000",
		"courses": [{
				"id": 1,
				"name": "Dart Fundamentals",
				"instructor": "Joe"
			},
			{
				"id": 2,
				"name": "Intro to Flutter",
				"instructor": "Joe"
			}
		]
	}, {
		"name": "Jane Blythe",
		"email": "jane@example.com",
		"dob": "1999-03-01T00:00:00.000",
		"courses": [{
				"id": 1,
				"name": "Getting Started with TensorFlow",
				"instructor": "Joe"
			}
		]
	}]
}''';

  test('Decode Json', () {
    Student s = StudentJsonMapper.fromJson(json);
    assert(s != null);
    expect(s.name, "John Smith");
    expect(s.email, "john@example.com");
    expect(s.dob, new DateTime(2000, 2, 14));
  });

  test('Encode Student', () {
    Student s = new Student(
        "John Smith", "john@example.com", new DateTime(2000, 2, 14));
    var jsonString = StudentJsonMapper.toJson(s);
    expect(json, jsonString);
  });

  test('Encode Students List', () {
    Student s = new Student(
        "John Smith", "john@example.com", new DateTime(2000, 2, 14));

    Student s2 = new Student("Jane Blythe", "jane@example.com", new DateTime(1999,3,1));
    List<Student> list = new List<Student>();
    list.add(s);
    list.add(s2);  

    var jsonString = StudentJsonMapper.listToJson(list);
    expect(jsonArray, jsonString);
  });

  test('Decode JsonArray', () {
    List<Student> list = StudentJsonMapper.fromJsonArray(jsonArray);
    assert(list != null);
    expect(2, list.length);
    expect("John Smith", list[0].name);
    expect("Jane Blythe", list[1].name);
  });

  test('Decode jsonArrayWithCourses', () {
    List<Student> list = StudentJsonMapper.fromJsonArray(jsonArrayWithCourses);
    assert(list != null);
    expect(2, list.length);
    expect(2, list.firstWhere((x) => x.name == "John Smith").courses.length);
    expect(1, list.firstWhere((x) => x.name == "Jane Blythe").courses.length);
  });

  // test('Unwrap Json', () {
  //   StudentJsonMapper.unwrap(jsonArrayWithCourses);
  // });

}
