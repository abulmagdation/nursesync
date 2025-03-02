import 'package:flutter/material.dart';
import 'package:nursesync/models/patient.dart';
import 'package:nursesync/database/database_helper.dart';

class PatientDetailsScreen extends StatefulWidget {
  final Patient patient;
  PatientDetailsScreen({this.patient});

  @override
  _PatientDetailsScreenState createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  TextEditingController bpController = TextEditingController();
  TextEditingController hrController = TextEditingController();
  TextEditingController tempController = TextEditingController();
  TextEditingController o2Controller = TextEditingController();
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.patient.vitalSigns != null) {
      bpController.text = widget.patient.vitalSigns['Blood Pressure'] ?? '';
      hrController.text = widget.patient.vitalSigns['Heart Rate'] ?? '';
      tempController.text = widget.patient.vitalSigns['Temperature'] ?? '';
      o2Controller.text = widget.patient.vitalSigns['Oxygen Saturation'] ?? '';
    }
  }

  void _saveVitals() {
    Map<String, String> newVitalSigns = {
      'Blood Pressure': bpController.text,
      'Heart Rate': hrController.text,
      'Temperature': tempController.text,
      'Oxygen Saturation': o2Controller.text,
    };
    widget.patient.vitalSigns = newVitalSigns;
    DatabaseHelper().updatePatient(widget.patient);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vitals Saved')),
    );
  }

  void _addTask() {
    String taskDescription = taskController.text;
    if (taskDescription.isNotEmpty) {
      Task newTask = Task(description: taskDescription, status: 'Pending');
      widget.patient.tasks.add(newTask);
      DatabaseHelper().updatePatient(widget.patient);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task Added')),
      );
      taskController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vital Signs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: bpController,
              decoration: InputDecoration(labelText: 'Blood Pressure (e.g., 120/80 mmHg)'),
            ),
            TextFormField(
              controller: hrController,
              decoration: InputDecoration(labelText: 'Heart Rate (bpm)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: tempController,
              decoration: InputDecoration(labelText: 'Temperature (°C)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextFormField(
              controller: o2Controller,
              decoration: InputDecoration(labelText: 'Oxygen Saturation (%)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Save Vitals'),
              onPressed: _saveVitals,
            ),
            SizedBox(height: 20),
            Text('Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: taskController,
              decoration: InputDecoration(labelText: 'Add Task'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Add Task'),
              onPressed: _addTask,
            ),
            SizedBox(height: 10),
            if (widget.patient.tasks.isNotEmpty)
              Column(
                children: widget.patient.tasks.map((task) {
                  return ListTile(
                    title: Text(task.description),
                    trailing: Text(task.status),
                    onTap: () {
                      setState(() {
                        task.status = (task.status == 'Pending') ? 'Completed' : 'Pending';
                      });
                      DatabaseHelper().updatePatient(widget.patient);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task Status Updated')),
                      );
                    },
                  );
                }).toList(),
              )
            else
              Text('No tasks added yet.'),
          ],
        ),
      ),
    );
  }
}
