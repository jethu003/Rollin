
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final String supportEmail;
  final String lastUpdated;

  const PrivacyPolicyPage({
    super.key,
    this.supportEmail = 'rollinMovies.support@gmail.com',
    this.lastUpdated = 'November 29, 2025',
  });

  Future<void> _launchEmail(String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeFull(
        'subject=Privacy Policy Query - RollIn Movies',
      ),
    );

    if (!await launchUrl(uri)) {
      
      await Clipboard.setData(ClipboardData(text: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
    icon: const Icon(
      Icons.arrow_back_ios_new, // 
      color: AppColours.shineWhite,
      size: 22, // 
    ),
    onPressed: (){
       Navigator.pop(context);
    },
        ),
        title: const Text('Privacy & Policy'),
        backgroundColor: AppColours.shineBlack,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all_outlined),
            tooltip: 'Copy support email',
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: supportEmail),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Support email copied'),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFf7f2e7), Color(0xFFfff8ef)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.privacy_tip_rounded,
                    size: 36,
                    color: Color(0xFFBA8E23),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Privacy & Policy',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'We value your privacy. Short, clear, and professional.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.update, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'Last updated: $lastUpdated',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SUMMARY CARD
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Summary',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'We collect only the information necessary to provide movie booking services — name, contact, and booking details. Your data is stored securely, never sold, and shared only with trusted partners (payment gateways and theatres).',
                            style: TextStyle(height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // SECTION 1
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      title: const Text('What we collect'),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text('• Personal details (name, email, phone)'),
                              SizedBox(height: 6),
                              Text('• Booking details (movie, seats, showtime)'),
                              SizedBox(height: 6),
                              Text('• Device & usage data (app version, crash logs)'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // SECTION 2
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      title: const Text('How we use your data'),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text('- Process bookings and send confirmations'),
                              SizedBox(height: 6),
                              Text('- Improve app performance and UX'),
                              SizedBox(height: 6),
                              Text('- Fraud prevention and customer support'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // SECTION 3
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      title: const Text('Data sharing & security'),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text('- Shared only with payment gateways and theatres'),
                              SizedBox(height: 6),
                              Text('- Payment data is processed by third-parties and not stored'),
                              SizedBox(height: 6),
                              Text('- Stored securely in Firebase with encryption and auth'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // SECTION 4
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      title: const Text('Your rights'),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              const Text('- View and update your profile'),
                              const SizedBox(height: 6),
                              const Text('- Delete your account or request data deletion'),
                              const SizedBox(height: 6),
                              const Text('- Opt out of marketing messages'),
                              const SizedBox(height: 10),

                              // BUTTONS
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFBA8E23),
                                    ),
                                    onPressed: () => _launchEmail(supportEmail),
                                    icon: const Icon(Icons.email_outlined),
                                    label: const Text('Contact Support'),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton.icon(
                                    onPressed: () async {
                                      await Clipboard.setData(
                                        ClipboardData(text: supportEmail),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Support email copied'),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.copy_outlined),
                                    label: const Text('Copy Email'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // FOOTER
                  Center(
                    child: Text(
                      'RollIn Movies • We respect your privacy',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
