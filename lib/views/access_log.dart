import 'package:aplication/controllers/access_log.dart';
import 'package:aplication/models/access_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccessLogView extends StatefulWidget {
  final String? email;

  const AccessLogView({super.key, this.email});

  @override
  _AccessLogViewState createState() => _AccessLogViewState();
}

class _AccessLogViewState extends State<AccessLogView> {
  final AccessLogController _accessLogController = AccessLogController();
  List<AccessLog> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccessLogs();
  }

  void _loadAccessLogs() async {
    List<AccessLog> logs = await _accessLogController.getAccessLogs(
      widget.email,
    );
    setState(() {
      _logs = logs;
      _isLoading = false;
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    var formattedDate = DateFormat('dd/MM/yyyy').format(timestamp);
    var formattedTime = DateFormat('HH:mm:ss').format(timestamp);

    return "Fecha: $formattedDate\nHora: $formattedTime";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _logs.isEmpty
              ? Center(child: Text("No hay registros disponibles"))
              : ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.blue),
                      title: Text(
                        log.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(_formatTimestamp(log.timestamp)),
                    ),
                  );
                },
              ),
    );
  }
}
