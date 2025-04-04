import 'dart:ui';

import 'package:aplication/controllers/admin.dart';
import 'package:aplication/controllers/auth.dart';
import 'package:aplication/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterView extends StatefulWidget {
  final UserModel? userModel;
  final String? title;
  final String? bodyText;
  final String optionPageText;
  final String? currentUserEmail;

  const RegisterView({
    super.key,
    this.userModel,
    this.bodyText,
    required this.optionPageText,
    this.title,
    this.currentUserEmail,
  });

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final AuthController authController = AuthController();
  final AdminController _adminController = AdminController();

  bool _obscurePassword = true;
  bool isAdmin = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.userModel != null) {
      usernameController.text = widget.userModel!.username ?? '';
      isAdmin = widget.userModel!.isAdmin ?? false;
    }
  }

  void register() async {
    setState(() {
      isLoading = true;
    });

    final user = await authController.register(
      emailController.text.trim(),
      passwordController.text.trim(),
      usernameController.text.trim(),
      isAdmin,
    );

    setState(() {
      isLoading = false;
    });

    if (user != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Se ha registrado exitosamente')));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error en el registro")));
    }
  }

  void editUser() async {
    setState(() {
      isLoading = true;
    });

    if (widget.userModel != null) {
      await _adminController.updateUser(
        widget.userModel!.uid,
        isAdmin,
        usernameController.text.trim(),
      );
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuario actualizado exitosamente")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: El usuario no está disponible")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar:
          widget.optionPageText == 'Registrar'
              ? null
              : AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Text(
                widget.title != null ? widget.title! : "Crea tu cuenta",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                widget.bodyText != null
                    ? widget.bodyText!
                    : "Regístrate para continuar",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller: usernameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Nombre de usuario",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese su nombre de usuario.";
                  }
                  return null;
                },
                onEditingComplete: () => _focusNodeEmail.requestFocus(),
              ),
              const SizedBox(height: 10),
              Offstage(
                offstage: widget.optionPageText == 'Actualizar',
                child: TextFormField(
                  controller: emailController,
                  focusNode: _focusNodeEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Correo electrónico",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (String? value) {
                    if ((value == null || value.isEmpty) &&
                        widget.optionPageText != 'Actualizar') {
                      return "Por favor, ingrese su correo electrónico.";
                    }
                    return null;
                  },
                  onEditingComplete: () => _focusNodePassword.requestFocus(),
                ),
              ),
              const SizedBox(height: 10),
              Offstage(
                offstage: widget.optionPageText == 'Actualizar',
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  focusNode: _focusNodePassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: const Icon(Icons.password_outlined),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon:
                          _obscurePassword
                              ? const Icon(Icons.visibility_outlined)
                              : const Icon(Icons.visibility_off_outlined),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (String? value) {
                    if ((value == null || value.isEmpty) &&
                        widget.optionPageText != 'Actualizar') {
                      return "Por favor, ingrese su contraseña.";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("¿Es administrador?"),
                  Checkbox(
                    value: isAdmin,
                    onChanged:
                        widget.currentUserEmail == widget.userModel?.email
                            ? null
                            : (value) {
                              setState(() {
                                isAdmin = value!;
                              });
                            },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                    ),
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                widget.optionPageText == 'Actualizar'
                                    ? editUser()
                                    : register();
                              }
                            },
                    child:
                        isLoading
                            ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                            : Text(
                              widget.optionPageText == 'Actualizar' ||
                                      widget.optionPageText == 'Crear'
                                  ? widget.optionPageText
                                  : "Registrar",
                            ),
                  ),

                  Offstage(
                    offstage:
                        widget.optionPageText == 'Actualizar' ||
                        widget.optionPageText == 'Crear',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿Ya tienes una cuenta?"),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Iniciar sesión"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }
}
