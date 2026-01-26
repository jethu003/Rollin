import 'package:flutter/material.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
         leading: IconButton(
    icon: const Icon(
      Icons.arrow_back_ios_new, 
      color: AppColours.shineWhite,
      size: 22, 
    ),
    onPressed: (){
      Navigator.pop(context);
    },
        ),
        title: const Text('About Us'),
        backgroundColor: AppColours.shineBlack,
      ),
      body: Column(
        children: [
          // HEADER
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
                    Icons.local_movies_rounded,
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
                        'RollIn Movies',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your seamless movie booking experience',
                        style: theme.textTheme.bodyMedium,
                      ),
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
                  // WHO WE ARE
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
                            'Who we are',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'RollIn Theatre is a modern movie booking platform designed to make discovering movies and booking seats simple, fast, and reliable. We focus on clean design, secure payments, and a smooth user experience.',
                            style: TextStyle(height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // OUR MISSION
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      title: const Text('Our mission'),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                '• Simplify movie ticket booking\n'
                                '• Deliver a reliable and secure platform\n'
                                '• Enhance the theatre-going experience',
                                style: TextStyle(height: 1.4),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // WHY ROLLIN
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      title: const Text('Why RollIn Movies'),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text('• Easy seat selection'),
                              SizedBox(height: 6),
                              Text('• Secure and fast payments'),
                              SizedBox(height: 6),
                              Text('• Real-time booking confirmations'),
                              SizedBox(height: 6),
                              Text('• Simple and intuitive interface'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // TECHNOLOGY
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      title: const Text('Technology & security'),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                'RollIn Movies is built using modern technologies like Flutter and Firebase. '
                                'We ensure secure authentication, encrypted data storage, and reliable infrastructure.',
                                style: TextStyle(height: 1.4),
                              ),
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
                      '© RollIn Movies • Built for movie lovers',
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
