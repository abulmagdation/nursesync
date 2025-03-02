import 'package:flutter/material.dart';
import 'package:nursesync/models/patient.dart';
import 'package:nursesync/database/database_helper.dart';
import 'package:nursesync/screens/patient_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Patient> patients = [];
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    List<Patient> loadedPatients = await DatabaseHelper().getAllPatients();
    setState(() {
      patients = loadedPatients;
    });
  }

  void _searchPatients(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _addPatient() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        return AlertDialog(
          title: Text('Add Patient'),
          content: TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Patient Name'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  Patient newPatient = Patient(name: nameController.text, vitalSigns: {}, tasks: []);
                  int id = await DatabaseHelper().insertPatient(newPatient);
                  newPatient.id = id;
                  _loadPatients();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Patient> filteredPatients = patients.where((patient) {
      return patient.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('NurseSync - Patient List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Patient',
                border: OutlineInputBorder(),
              ),
              onChanged: _searchPatients,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredPatients[index].name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetailsScreen(patient: filteredPatients[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add Patient',
        onPressed: _addPatient,
      ),
    );
  }
}
