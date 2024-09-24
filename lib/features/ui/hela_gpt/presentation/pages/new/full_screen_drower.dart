import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aurudu_nakath/features/ui/subcriptions_provider/subcription_privider.dart';
import 'package:url_launcher/url_launcher.dart';

class FullScreenDrawer extends StatelessWidget {
  final VoidCallback onClose;

  const FullScreenDrawer({Key? key, required this.onClose}) : super(key: key);



  Future<void> _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final product = subscriptionProvider.product;
    final isSubscribed = subscriptionProvider.isSubscribed;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  _buildFeatureItem(
                    context,
                    icon: Icons.chat_bubble_outline,
                    title: 'ඇති තරම් chat කරන්න',
                    subtitle:
                        'හෙල GPT Pro ලබාගැනීමෙන් ඔබට හෙළ GPT සමඟ සීමා නොමැතිව chat කරන්න පුලුවන්.',
                  ),
                  _buildFeatureItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'සවිස්තරාත්මක ප්‍රතිචාර',
                    subtitle:
                        'හෙල GPT Pro ලබාගැනීමෙන් ඔබට සවිස්තරාත්මක ප්‍රතිචාර ලබාගත හැකී.',
                  ),
                  _buildFeatureItem(
                    context,
                    icon: Icons.image_rounded,
                    title: 'ජායාරූප සමඟින් ප්‍රශ්න අසන්න',
                    subtitle: 'හෙළ GPT Pro භාවිතයෙන් ඔබට ජායාරූප සමඟින් ප්‍රශ්න අසන්න පුලුවන්.',
                  ),
                  const SizedBox(height: 40),
                  _buildButton(
                    context,
                    'දායකත්වය ප්‍රතිසාධනය කරන්න',
                    onPressed: () async {
                      if (subscriptionProvider.restoredPurchase) {
                        _showRestoreDialog(context);
                      } else {
                        _showErrorDialog(
                            context, "දායකත්වය ප්‍රතිසාධනය කිරීම අසාර්ථක විය.");
                      }
                    },
                    isPrimary: false,
                  ),
                  const SizedBox(height: 16),
                  // Show purchase button only if not subscribed
                  if (!isSubscribed && product != null)
                    _buildButton(
                      context,
                      'රු 650/= (මසකට)',
                      onPressed: () async {
                        subscriptionProvider.buySubscription();
                        subscriptionProvider.onPurchaseSuccess = () {
                          _showSuccessDialog(
                              context, "දායක වීම සාර්ථකයි. ඔබ දැන් මුල් තිරයට ගොස් නැවත ආරම්භ කරන්න.");
                        };
                        subscriptionProvider.onPurchaseError = () {
                          _showErrorDialog(context, "මිලදී ගැනීම අසාර්ථක විය.");
                        };
                      },
                    ),
                  const SizedBox(height: 16),
                  _buildButton(
                    context,
                    'සහය සම්බන්ධ කරගන්න',
                    onPressed: () {
                      // Add your button action here
                      _launchURL('https://wa.link/y3wc48');
                    },
                    isPrimary: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'හෙළ GPT Pro විශේෂාංග',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: const Color.fromARGB(255, 109, 109, 109),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.close,
                color: Color.fromARGB(255, 255, 208, 0)),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.yellow[50],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.yellow[700], size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow[800],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text,
      {required VoidCallback? onPressed, bool isPrimary = true}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: isPrimary ? Colors.white : Colors.yellow[700],
        backgroundColor: isPrimary ? Colors.yellow[700] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        elevation: isPrimary ? 4 : 0,
        shadowColor:
            isPrimary ? Colors.yellow.withOpacity(0.4) : Colors.transparent,
        side:
            isPrimary ? null : BorderSide(color: Colors.yellow[700]!, width: 2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('සාර්ථකයි', style: TextStyle(color: Colors.green[800])),
        content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            child: Text('හරි'),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.dashboard),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('දෝෂයක්', style: TextStyle(color: Colors.red[800])),
        content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            child: Text('හරි'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text('ප්‍රතිසාධනය සාර්ථකයි', style: TextStyle(color: Colors.blue[800])),
        content:
            Text('දායකත්වය ප්‍රතිසාධනය විය.', style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            child: Text('හරි'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
