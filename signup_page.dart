
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger_1/login_page.dart';

void main() {
  runApp(SignUpApp());
}

class SignUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordsMatched = false;
  Color _passwordFieldColor = Colors.purple.withOpacity(0.1);
  Color _confirmPasswordFieldColor = Colors.purple.withOpacity(0.1);

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswords);
    _confirmPasswordController.addListener(_checkPasswords);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswords() {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password.length >= 8 && confirmPassword.length >= 8 && password == confirmPassword) {
        setState(() {
          _isPasswordsMatched = true;
          _passwordFieldColor = Colors.green.withOpacity(0.2);
          _confirmPasswordFieldColor = Colors.green.withOpacity(0.2);
        });
      } else {
        setState(() {
          _isPasswordsMatched = false;
          _passwordFieldColor = Colors.purple.withOpacity(0.1);
          _confirmPasswordFieldColor = Colors.purple.withOpacity(0.1);
        });
      }
    } else {
      setState(() {
        _isPasswordsMatched = false;
        _passwordFieldColor = Colors.purple.withOpacity(0.1);
        _confirmPasswordFieldColor = Colors.purple.withOpacity(0.1);
      });
    }
  }

  Future<void> _signUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Optional: Save additional user data to Firestore or Realtime Database
      // Example: await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      //   'username': _usernameController.text,
      //   'email': _emailController.text,
      // });

      // Navigate to home page or perform additional actions
      print('User signed up: ${userCredential.user!.uid}');
    } catch (e) {
      print('Failed to sign up: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to sign up'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 25.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E2E2E),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.purple.withOpacity(0.1),
                  filled: true,
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.purple.withOpacity(0.1),
                  filled: true,
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: _passwordFieldColor,
                  filled: true,
                  prefixIcon: const Icon(Icons.password),
                ),
                obscureText: true,
                maxLength: 8,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: _confirmPasswordFieldColor,
                  filled: true,
                  prefixIcon: const Icon(Icons.password_outlined),
                ),
                obscureText: true,
                maxLength: 8,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _isPasswordsMatched,
                    onChanged: (bool? value) {},
                  ),
                  SizedBox(width: 8), // Adjust the space between checkboxes
                  Text('Passwords match', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: _isPasswordsMatched ? _signUp : null,
                child: Text('Sign Up', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPasswordsMatched
                      ? Color.fromARGB(255, 187, 7, 242)
                      : Colors.grey,
                  minimumSize: Size(343, 48), // Width and height
                ),
              ),
              SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2E2E2E),
                    ),
                    children: [
                      TextSpan(text: "Already have an account? "),
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                          color: Color(0xFFF58634),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
