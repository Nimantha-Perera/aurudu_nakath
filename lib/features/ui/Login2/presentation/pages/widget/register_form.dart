import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the TextEditingControllers when the widget is removed from the widget tree
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            _buildWelcomeText(isDarkMode),
            SizedBox(height: 40),
            _buildTextField(
                'පරිශීලක නාමය', Icons.person, _usernameController, isDarkMode),
            SizedBox(height: 20),
            _buildTextField(
                'විද්‍යුත් තැපෑල', Icons.email, _emailController, isDarkMode,
                keyboardType: TextInputType.emailAddress),
            SizedBox(height: 20),
            _buildTextField(
                'ජංගම දුරකථන අංකය', Icons.phone, _mobileController, isDarkMode,
                keyboardType: TextInputType.phone),
            SizedBox(height: 20),
            _buildPasswordField('මුරපදය', _passwordController, isDarkMode),
            SizedBox(height: 20),
            _buildPasswordField(
                'මුරපදය තහවුරු කරන්න', _confirmPasswordController, isDarkMode,
                isConfirmPassword: true),
            SizedBox(height: 40),
            _buildRegisterButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeText(bool isDarkMode) {
    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          'ඔබ යොදන රහස්‍ය අංකය කුමන හෝ ස්තානයක ලියා හෝ තබා ගන්න.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, IconData icon,
      TextEditingController controller, bool isDarkMode,
      {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, icon, isDarkMode),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'කරුණාකර ඔබගේ $label ඇතුළත් කරන්න';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, bool isDarkMode,
      {bool isConfirmPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText:
          isConfirmPassword ? _obscureConfirmPassword : _obscurePassword,
      decoration: _inputDecoration(label, Icons.lock, isDarkMode).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            isConfirmPassword
                ? (_obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off)
                : (_obscurePassword ? Icons.visibility : Icons.visibility_off),
            color: isDarkMode ? Colors.white70 : Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              if (isConfirmPassword) {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              } else {
                _obscurePassword = !_obscurePassword;
              }
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'කරුණාකර ඔබගේ $label ඇතුළත් කරන්න';
        }
        if (isConfirmPassword && value != _passwordController.text) {
          return 'මුරපද නොගැලපේ';
        }
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(
      String label, IconData icon, bool isDarkMode) {
    return InputDecoration(
      labelText: label,
      labelStyle:
          TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey[700]),
      prefixIcon:
          Icon(icon, color: isDarkMode ? Colors.white70 : Colors.grey[600]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleRegister(context),
        child: Text(
          'ලියාපදිංචි වන්න',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 102, 102, 102)),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 3,
        ),
      ),
    );
  }

  Future<void> _handleRegister(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    try {
      // Check if username already exists in Firestore
      final usernameQuery = await FirebaseFirestore.instance
          .collection('normle_users')
          .where('username', isEqualTo: _usernameController.text.trim())
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        _showErrorDialog(context, 'දෝෂයක් සිදුවී ඇත',
            'පරිශීලක නාමය දැනටමත් කෙනෙකු භාවිතා කරයි.'); // Username already exists
        return;
      }

      // Authentication process in a separate try-catch
      try {
        // Create the user with Firebase Authentication
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());
        final User? user = userCredential.user;

        // Store user details in Firestore
        await FirebaseFirestore.instance
            .collection('normle_users')
            .doc(user!.uid)
            .set({
          'displayName': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'mobile': _mobileController.text.trim(),
          'reg_date': DateTime.now().toString(),
          'uid': user.uid,
        });

        // Save data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', user.email ?? '');
        await prefs.setString('displayName', _usernameController.text.trim());
        await prefs.setString('userId', user.uid);

        // Clear fields after successful registration
        _usernameController.clear();
        _emailController.clear();
        _mobileController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();

        // Show success message
        _showErrorDialog(context, 'ලියාපදිංචිය සාර්ථකයි', 'ඔබ ලියාපදිංචි විය.');
      } on FirebaseAuthException catch (e) {
        // Handle authentication-specific errors
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage =
                'මෙම විද්‍යුත් තැපෑල සම්පූර්ණයෙන්ම වෙන පරිශීලකයෙකු පවත්වාගෙන යනු ලබයි.';
            break;
          case 'weak-password':
            errorMessage = 'මුරපදය දුර්වලයි. (Weak password)';
            break;
          case 'invalid-email':
            errorMessage =
                'වලංගු විද්‍යුත් තැපෑලක් ඇතුළත් කරන්න. (Please enter a valid email address.)';
            break;
          default:
            errorMessage =
                'ලියාපදිංචි කිරීමේ දෝෂයක් සිදුවී ඇත. (Registration error)';
            break;
        }
        _showErrorDialog(context, 'දෝෂයක් සිදුවී ඇත', errorMessage);
        return; // Exit method on error
      } catch (e) {
        // Handle other authentication errors
        _showErrorDialog(context, 'දෝෂයක් සිදුවී ඇත',
            'Firebase සත්‍යාපන දෝෂයක් සිදුවී ඇත.');
        return;
      }

    } catch (e) {
      // Handle other registration errors
      _showErrorDialog(context, 'දෝෂයක් සිදුවී ඇත',
          'ලියාපදිංචි කිරීමේ දෝෂයක් සිදුවී ඇත. (Registration error)');
    }
  }
}


// Function to show an alert dialog
  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('හරි'), // "OK" in Sinhala
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('ඉවත් වන්න'),
            ),
          ],
        );
      },
    );
  }
}
