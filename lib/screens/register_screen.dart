import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final TextEditingController
      _fullNameController =
      TextEditingController();

  final TextEditingController
      _nimController =
      TextEditingController();

  final TextEditingController
      _usernameController =
      TextEditingController();

  final TextEditingController
      _passwordController =
      TextEditingController();

  final DatabaseHelper _dbHelper =
      DatabaseHelper();

  bool isLoading = false;

  Future<void> _handleRegister() async {

    String name =
        _fullNameController.text.trim();

    String nim =
        _nimController.text.trim();

    String username =
        _usernameController.text.trim();

    String password =
        _passwordController.text.trim();

    if (name.isEmpty ||
        nim.isEmpty ||
        username.isEmpty ||
        password.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Semua field wajib diisi",
          ),
        ),
      );

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      await _dbHelper.registerUser(
        username,
        password,
        name,
        nim,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            "Registrasi Berhasil",
          ),
          content: const Text(
            "Silakan login menggunakan akun yang baru dibuat.",
          ),
          actions: [
            TextButton(
              onPressed: () {

                Navigator.pop(context);

                Navigator.pop(context);
              },
              child: const Text(
                "OK",
              ),
            ),
          ],
        ),
      );

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Gagal Register : $e",
          ),
        ),
      );
    }
  }

  Widget buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscure = false,
  }) {

    return TextField(
      controller: controller,
      obscureText: obscure,

      style: const TextStyle(
        color: Colors.white,
      ),

      decoration: InputDecoration(
        labelText: label,

        labelStyle: const TextStyle(
          color: Colors.white70,
        ),

        prefixIcon: Icon(
          icon,
          color: Colors.blueAccent,
        ),

        filled: true,
        fillColor: const Color(
          0xFF161B22,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFF0D1117),

      appBar: AppBar(
        title: const Text(
          "Daftar Akun",
        ),

        backgroundColor:
            Colors.transparent,

        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(24),

        child: Column(
          children: [

            const Icon(
              Icons.person_add,
              size: 90,
              color: Colors.blueAccent,
            ),

            const SizedBox(
              height: 25,
            ),

            buildTextField(
              _fullNameController,
              "Nama Lengkap",
              Icons.person,
            ),

            const SizedBox(
              height: 15,
            ),

            buildTextField(
              _nimController,
              "NIM",
              Icons.badge,
            ),

            const SizedBox(
              height: 15,
            ),

            buildTextField(
              _usernameController,
              "Username",
              Icons.alternate_email,
            ),

            const SizedBox(
              height: 15,
            ),

            buildTextField(
              _passwordController,
              "Password",
              Icons.lock,
              obscure: true,
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : _handleRegister,

                child: isLoading
                    ? const CircularProgressIndicator(
                        color:
                            Colors.white,
                      )
                    : const Text(
                        "DAFTAR",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}