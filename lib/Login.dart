import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piecloud/HomeScreen.dart';
import 'Register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'forgotPasswordPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true, // Required for DevicePreview
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder, // Apply DevicePreview modifications
      home: LoginPage(prefilledEmail: ''),
    );
  }
}
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required String prefilledEmail}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool _obscureText = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  /// Load saved email & password if "Remember Me" was checked before
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? "";
      _passwordController.text = prefs.getString('password') ?? "";
      rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }


  /// Save email & password if "Remember Me" is checked
  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('email', _emailController.text.trim());
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text;

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save credentials if "Remember Me" is checked
      await _saveCredentials();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided.";
      } else {
        errorMessage = e.message ?? "Login failed.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/profile.png"),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                    Text("Remember Me"),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Login"),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => forgotPasswordPage()),
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}