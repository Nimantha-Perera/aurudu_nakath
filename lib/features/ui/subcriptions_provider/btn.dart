import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:aurudu_nakath/features/ui/subcriptions_provider/subcription_privider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PurchaseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);

    subscriptionProvider.onPurchaseSuccess = () {
      // Show the success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Purchase Successful'),
          content: Text('You have successfully subscribed to Hela GPT Pro!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushNamed(context, AppRoutes.malimawa);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    };

    subscriptionProvider.onPurchaseError = () {
      // Show the error dialog or handle error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Purchase Failed'),
          content: Text('There was an error with your purchase. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    };

    return ElevatedButton(
      onPressed: () => subscriptionProvider.buySubscription(),
      child: Text('Subscribe to Hela GPT Pro'),
    );
  }
}
