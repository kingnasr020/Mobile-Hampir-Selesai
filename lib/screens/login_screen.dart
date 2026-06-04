import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../services/database_helper.dart';
import '../services/session_manager.dart';

import 'register_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController
      _usernameController =
      TextEditingController();

  final TextEditingController
      _passwordController =
      TextEditingController();

  final DatabaseHelper _dbHelper =
      DatabaseHelper();

  final LocalAuthentication auth =
      LocalAuthentication();

  bool _isLoading = false;

  void _showErrorDialog(
    String title,
    String message,
  ) {

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {

    String username =
        _usernameController.text.trim();

    String password =
        _passwordController.text.trim();

    if (username.isEmpty ||
        password.isEmpty) {

      _showErrorDialog(
        "Login Gagal",
        "Username dan Password wajib diisi",
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

      bool success =
          await _dbHelper.loginUser(
        username,
        password,
      );

      if (!success) {

        setState(() {
          _isLoading = false;
        });

        _showErrorDialog(
          "Login Gagal",
          "Username atau Password salah",
        );

        return;
      }

      Map<String, dynamic>? user =
          await _dbHelper
              .getUserByUsername(
        username,
      );

      if (user == null) {

        setState(() {
          _isLoading = false;
        });

        _showErrorDialog(
          "Error",
          "Data user tidak ditemukan",
        );

        return;
      }

      await SessionManager.saveSession(
        username: username,
        name: user['name'],
        nim: user['nim'],
      );

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Selamat datang ${user['name']}",
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const DashboardScreen(),
        ),
      );

    } catch (e) {

      setState(() {
        _isLoading = false;
      });

      _showErrorDialog(
        "System Error",
        e.toString(),
      );
    }
  }

  Future<void> _handleBiometric()
      async {

    try {

      bool canCheck =
          await auth.canCheckBiometrics;

      bool supported =
          await auth.isDeviceSupported();

      if (!(canCheck || supported)) {

        _showErrorDialog(
          "Biometrik",
          "Perangkat tidak mendukung biometrik",
        );

        return;
      }

      bool authenticated =
          await auth.authenticate(
        localizedReason:
            "Login menggunakan biometrik",
      );

      if (!authenticated) return;

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const DashboardScreen(),
        ),
      );

    } catch (e) {

      _showErrorDialog(
        "Biometrik Error",
        e.toString(),
      );
    }
  }

  Widget buildInput(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscure = false,
  }) {

    return TextField(
      controller: controller,
      obscureText: obscure,

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(icon),

        border:
            const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(24),

          child: Column(
            children: [

              const Icon(
                Icons.diamond,
                size: 100,
                color: Colors.blue,
              ),

              const SizedBox(
                height: 20,
              ),

              const Text(
                "EsportsPulse",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              buildInput(
                _usernameController,
                "Username",
                Icons.person,
              ),

              const SizedBox(
                height: 15,
              ),

              buildInput(
                _passwordController,
                "Password",
                Icons.lock,
                obscure: true,
              ),

              const SizedBox(
                height: 25,
              ),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : _handleLogin,

                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color:
                              Colors.white,
                        )
                      : const Text(
                          "LOGIN",
                        ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              SizedBox(
                width: double.infinity,
                height: 55,

                child:
                    ElevatedButton.icon(
                  icon: const Icon(
                    Icons.fingerprint,
                  ),

                  label: const Text(
                    "LOGIN BIOMETRIK",
                  ),

                  onPressed:
                      _handleBiometric,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              TextButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Belum punya akun? Daftar",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}