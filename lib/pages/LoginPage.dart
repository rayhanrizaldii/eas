import 'package:eas/main.dart';
import 'package:eas/pages/RegisterPage.dart';
import 'package:eas/services/users/fetchusers.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void _onLoginPressed(usernametext, passwordtext) async {
    // ignore: unnecessary_null_comparison
    if (usernametext != null && passwordtext != null) {
      try {
        final response = await FetchUsers.loginUser(usernametext, passwordtext);
        print(response['message']);

        // Check response for success or failure
        if (response['status'] == 200) {
          // Login successful, navigate to home page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MyDrawer();
              },
            ),
          );
        } else {
          // Login failed, show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Periksa username atau password anda'),
            ),
          );
        }
      } catch (e) {
        // Handle exception, e.g., network error
        print('Exception during login: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect. Please try again later.'),
          ),
        );
      }
    } else {
      print('Username atau password anda kosong.');
    }
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username tidak boleh kosong';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    // Anda dapat menambahkan aturan validasi lainnya di sini
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff7FC7D9),
                Colors.green
              ], // Sesuaikan warna gradasi sesuai keinginan Anda
            ),
          ),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/login-image.png',
                    width: 300,
                  ),
                  Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 250,
                    child: TextFormField(
                      controller: usernameController,
                      validator: validateUsername,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.white70,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 250,
                    child: TextFormField(
                      controller: passwordController,
                      validator: validatePassword,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.white70,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (build) {
                                  return RegisterPage();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _onLoginPressed(
                            usernameController.text, passwordController.text);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (build) {
                              return MyDrawer();
                            },
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
