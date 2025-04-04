import 'package:aplication/controllers/admin.dart';
import 'package:aplication/models/user.dart';
import 'package:aplication/views/register.dart';
import 'package:flutter/material.dart';

class AdminPanelView extends StatefulWidget {
  final String? email;
  AdminPanelView({super.key, this.email});
  @override
  _AdminPanelViewState createState() => _AdminPanelViewState();
}

class _AdminPanelViewState extends State<AdminPanelView> {
  final AdminController _adminController = AdminController();
  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    List<UserModel> users = await _adminController.getUsers();
    setState(() {
      _users = users;
    });
  }

  void _deleteUser(String uid) async {
    await _adminController.deleteUser(uid);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body:
          _users.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(user.username[0].toUpperCase()),
                      ),
                      title: Text(
                        user.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(user.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => RegisterView(
                                        optionPageText: 'Actualizar',
                                        title: 'Actualizar usuario',
                                        bodyText:
                                            'Si te interesa actualizar el usuario',
                                        userModel: user,
                                        currentUserEmail: widget.email,
                                      ),
                                ),
                              );
                              if (result != null && result) {
                                _loadUsers();
                              }
                            },
                          ),
                          Offstage(
                            offstage: user.email == widget.email,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUser(user.uid),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
