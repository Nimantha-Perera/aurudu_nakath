// login_register_screen.dart
import 'package:aurudu_nakath/features/ui/Login2/presentation/pages/widget/login_form.dart';
import 'package:aurudu_nakath/features/ui/Login2/presentation/pages/widget/login_form.dart';
import 'package:aurudu_nakath/features/ui/Login2/presentation/pages/widget/register_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_viewmodel.dart';


class LoginRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel2>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          bottom: TabBar(
            labelColor: const Color.fromARGB(255, 255, 255, 255),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color.fromARGB(255, 255, 255, 255),
            tabs: [
              Tab(text: 'පූර්ණය වන්න'),
              Tab(text: 'නව ගිනුමක් සාදන්න'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LoginForm(loginViewModel: loginViewModel),
            RegisterForm(),
          ],
        ),
      ),
    );
  }
}
