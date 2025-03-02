import 'dart:convert';

class Patient {
  int id;
  String name;
  Map<String, String> vitalSigns;
  List<Task> tasks;

  Patient({this.id, this.name, this.vitalSigns, this.tasks});

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      vitalSigns: map['vitalSigns'] != null ? json.decode(map['vitalSigns']) : {},
      tasks: map['tasks'] != null ? List<Task>.from(
        json.decode(map['tasks']).map((x) => Task.fromMap(x)),
      ) : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'vitalSigns': json.encode(vitalSigns),
      'tasks': json.encode(tasks.map((x) => x.toMap()).toList()),
    };
  }
}

class Task {
  String description;
  String status;

  Task({this.description, this.status});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      description: map['description'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'status': status,
    };
  }
}
