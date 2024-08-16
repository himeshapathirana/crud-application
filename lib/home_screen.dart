import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();

  final CollectionReference _users =
      FirebaseFirestore.instance.collection("users");

  void _addUser() {
    _users.add({
      'name': _nameController.text,
      'profession': _professionController.text,
    });
    _nameController.clear();
    _professionController.clear();
  }

  void _deleteUser(String userId) {
    _users.doc(userId).delete();
  }

  void _editUser(DocumentSnapshot user) {
    _nameController.text = user['name'];
    _professionController.text = user['profession'];

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("edit User"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "User Name"),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _professionController,
                  decoration: InputDecoration(labelText: "User profession"),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    _updateUser(user.id);
                    Navigator.pop(context);
                  },
                  child: Text("Update")),
            ],
          );
        });
  }

  void _updateUser(String userId) {
    _users.doc(userId).update({
      'name': _nameController.text,
      'profession': _professionController.text,
    });

    _nameController.clear();
    _professionController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD APPLICATION"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Enter User Name"),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _professionController,
              decoration: InputDecoration(labelText: "Enter User Profession"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _professionController.text.isNotEmpty) {
                  _users.add({
                    'name': _nameController.text,
                    'profession': _professionController.text
                  }).then((value) {
                    // Clear the text fields after successful addition
                    _nameController.clear();
                    _professionController.clear();
                  }).catchError((error) {
                    // Handle errors here
                    print("Failed to add user: $error");
                  });
                } else {
                  // Show some error message or validation feedback
                  print("Fields cannot be empty");
                }
              },
              child: Text("Add user"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder(
                stream: _users.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var user = snapshot.data!.docs[index];
                      return Dismissible(
                        key: Key(user.id),
                        background: Container(
                          color: Color.fromARGB(255, 165, 0, 0),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        onDismissed: (direction) {
                          _deleteUser(user.id);
                        },
                        direction: DismissDirection.endToStart,
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              user['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              user['profession'],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 96, 98, 119)),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                _editUser(user);
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
