import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/Login2/presentation/pages/login_viewmodel.dart';
import 'package:aurudu_nakath/features/ui/Login2/presentation/pages/widget/google_login_btn.dart';

class LoginForm extends StatefulWidget {
  final LoginViewModel2 loginViewModel;

  LoginForm({required this.loginViewModel});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            _buildLogo(),
            SizedBox(height: 40),
            _buildWelcomeText(isDarkMode),
            SizedBox(height: 50),
            _buildEmailField(context, isDarkMode),
            SizedBox(height: 20),
            _buildPasswordField(context, isDarkMode),
            SizedBox(height: 20),
            _buildForgotPasswordButton(primaryColor),
            SizedBox(height: 30),
            _buildLoginButton(context),
            SizedBox(height: 30),
            _buildDividerWithText(context),
            SizedBox(height: 30),
            GoogleLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Hero(
      tag: 'app_logo',
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/icons/katapatha.webp')),
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeText(bool isDarkMode) {
    return Column(
      children: [
        Text(
          'කැටපත',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.grey[800],
          ),
        ),
        SizedBox(height: 10),
        Text(
          'ඔබගේ නිර්මාණශීලීත්වය අගය කිරීම සඳහා',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context, bool isDarkMode) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration(
        'ඊමේල් ලිපිනය',
        Icons.email,
        isDarkMode,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'කරුණාකර ඔබගේ ඊමේල් ලිපිනය ඇතුළත් කරන්න';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(BuildContext context, bool isDarkMode) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: _inputDecoration(
        'රහස්‍ය අංකය',
        Icons.lock,
        isDarkMode,
      ).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: isDarkMode ? Colors.white70 : Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'කරුණාකර ඔබගේ රහස්‍ය අංකය ඇතුළත් කරන්න';
        }
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, bool isDarkMode) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey[700]),
      prefixIcon: Icon(icon, color: isDarkMode ? Colors.white70 : Colors.grey[600]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }

  Widget _buildForgotPasswordButton(Color primaryColor) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => _showForgotPasswordDialog(context),
        child: Center(
          child: Text(
            'රහස්‍ය අංකය අමතක උනාද?',
            style: TextStyle(color: primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.loginViewModel.isLoading ? null : () => _handleLogin(context),
        child: widget.loginViewModel.isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
                'පිවිසෙන්න',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 102, 102, 102)),
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

  Widget _buildDividerWithText(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[400], thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'හෝ',
            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[400], thickness: 1)),
      ],
    );
  }

  void _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await widget.loginViewModel.login(
          // Add login parameters here if needed
        );
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('පිවිසීම අසාර්ථක විය. කරුණාකර ඔබගේ තොරතුරු පරීක්ෂා කර නැවත උත්සාහ කරන්න.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('රහස්‍ය අංකය අමතක වීම'),
        content: Text('රහස්‍ය අංකය නැවත සැකසීමේ ක්‍රියාකාරකම ඉක්මනින් එනු ඇත!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('හරි'),
          ),
        ],
      ),
    );
  }
}