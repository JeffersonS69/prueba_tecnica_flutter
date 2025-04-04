import 'package:aplication/views/register.dart';
import 'package:flutter/material.dart';
import 'package:aplication/controllers/auth.dart';
import 'package:aplication/views/access_log.dart';
import 'package:aplication/views/admin_panel.dart';
import 'package:aplication/views/login.dart';
import 'package:aplication/views/stats_view.dart';

class HomeView extends StatefulWidget {
  final bool isAdmin;
  final String? email;

  const HomeView({super.key, required this.isAdmin, this.email});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthController authController = AuthController();
  int _selectedIndex = 0;

  late final List<Widget> _pages;
  late final List<String> _titles;

  @override
  void initState() {
    super.initState();

    if (widget.isAdmin) {
      _pages = [
        AccessLogView(),
        AdminPanelView(email: widget.email),
        StatsView(),
      ];
      _titles = [
        'Historial de acceso',
        'Panel de administrador',
        'Estadísticas de acceso',
      ];
    } else {
      _pages = [AccessLogView(email: widget.email)];
      _titles = ['Historial de acceso'];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void logout(BuildContext context) async {
    await authController.logout();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Sesión cerrada')));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          if (_selectedIndex == 1 && widget.isAdmin)
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RegisterView(
                              optionPageText: 'Crear',
                              title: 'Crear cuenta',
                              bodyText: 'Crea una nueva cuenta',
                            ),
                      ),
                    );
                  },
                  iconSize: 20,
                ),
              ),
            ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar:
          widget.isAdmin
              ? BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'Historial',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.admin_panel_settings),
                    label: 'Administrador',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart),
                    label: 'Estadísticas',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.blueAccent,
                onTap: _onItemTapped,
              )
              : null,
    );
  }
}
