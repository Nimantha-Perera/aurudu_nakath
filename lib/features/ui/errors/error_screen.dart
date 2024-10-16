import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 100),
              child: Lottie.asset(
                'assets/animations/net_error.json',
                height: 400,
                width: 400,
              ),
            ),
            Text("අන්තර්ජාල සම්බන්ධතාවයක් නොමැත"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var connectivityResult =
                    await (Connectivity().checkConnectivity());
                if (connectivityResult != ConnectivityResult.none) {
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.dashboard);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("තවමත් අන්තර්ජාල සම්බන්ධතාවයක් නොමැත"),
                    ),
                  );
                }
              },
              child: Text("නැවුම් කරන්න"),
            ),
          ],
        ),
      ),
    );
  }
}
