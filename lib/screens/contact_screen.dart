import 'package:flutter/material.dart';
import '../models/portfolio_data.dart';
import '../widgets/animated_section.dart';
import '../widgets/social_button.dart';
import '../config/responsive.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = PortfolioData.data;
    final socials = userData['socials'] as List<dynamic>;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Responsive.responsiveLayout(
      mobile: _buildMobileLayout(context, userData, socials),
      tablet: _buildTabletLayout(context, userData, socials),  // Added tablet layout
      desktop: _buildDesktopLayout(context, userData, socials),
    );
  }

  Widget _buildMobileLayout(BuildContext context, Map<String, dynamic> userData, List<dynamic> socials) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          AnimatedSection(
            id: 'contact-title-mobile',
            child: Text(
              'Get In Touch',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSection(
            id: 'contact-subtitle-mobile',
            duration: const Duration(milliseconds: 1000),
            child: Container(
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 30),
          AnimatedSection(
            id: 'contact-info-mobile',
            duration: const Duration(milliseconds: 1200),
            child: _buildContactInfo(context, userData, isMobile: true),
          ),
          const SizedBox(height: 20),
          AnimatedSection(
            id: 'contact-social-mobile',
            duration: const Duration(milliseconds: 1400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connect With Me',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayMedium!.color,
                  ),
                ),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: socials.map((social) {
                    return SocialButton(
                      name: social['name'],
                      url: social['url'],
                      icon: social['icon'],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          AnimatedSection(
            id: 'contact-form-mobile',
            duration: const Duration(milliseconds: 1600),
            child: _buildContactForm(context),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // New tablet layout implementation
  Widget _buildTabletLayout(BuildContext context, Map<String, dynamic> userData, List<dynamic> socials) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSection(
            id: 'contact-title-tablet',
            child: Text(
              'Get In Touch',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSection(
            id: 'contact-subtitle-tablet',
            duration: const Duration(milliseconds: 1000),
            child: Container(
              height: 4,
              width: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 15),
          AnimatedSection(
            id: 'contact-description-tablet',
            duration: const Duration(milliseconds: 1100),
            child: Text(
              'Feel free to contact me for any work inquiries or collaborations.',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Two-column layout for tablet
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - Contact Form
              Expanded(
                flex: 2,
                child: AnimatedSection(
                  id: 'contact-form-tablet',
                  duration: const Duration(milliseconds: 1300),
                  child: _buildContactForm(context),
                ),
              ),
              const SizedBox(width: 30),
              // Right Column - Contact Info & Social
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSection(
                      id: 'contact-info-tablet',
                      duration: const Duration(milliseconds: 1400),
                      startOffset: 50,
                      child: _buildContactInfo(context, userData, isMobile: false),
                    ),
                    const SizedBox(height: 30),
                    AnimatedSection(
                      id: 'contact-social-tablet',
                      duration: const Duration(milliseconds: 1500),
                      startOffset: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connect With Me',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.displayMedium!.color,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: socials.map((social) {
                              return SocialButton(
                                name: social['name'],
                                url: social['url'],
                                icon: social['icon'],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, Map<String, dynamic> userData, List<dynamic> socials) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSection(
            id: 'contact-title-desktop',
            child: Text(
              'Get In Touch',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          AnimatedSection(
            id: 'contact-subtitle-desktop',
            duration: const Duration(milliseconds: 1000),
            child: Container(
              height: 5,
              width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedSection(
            id: 'contact-description-desktop',
            duration: const Duration(milliseconds: 1100),
            child: Text(
              'Feel free to contact me for any work inquiries or collaborations.',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
          const SizedBox(height: 60),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: AnimatedSection(
                  id: 'contact-form-desktop',
                  duration: const Duration(milliseconds: 1300),
                  child: _buildContactForm(context),
                ),
              ),
              const SizedBox(width: 60),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSection(
                      id: 'contact-info-desktop',
                      duration: const Duration(milliseconds: 1400),
                      startOffset: 100,
                      child: _buildContactInfo(context, userData, isMobile: false),
                    ),
                    const SizedBox(height: 40),
                    AnimatedSection(
                      id: 'contact-social-desktop',
                      duration: const Duration(milliseconds: 1600),
                      startOffset: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connect With Me',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.displayMedium!.color,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 15,
                            runSpacing: 15,
                            children: socials.map((social) {
                              return SocialButton(
                                name: social['name'],
                                url: social['url'],
                                icon: social['icon'],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, Map<String, dynamic> userData, {required bool isMobile}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 30),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.displayMedium!.color,
            ),
          ),
          const SizedBox(height: 20),
          _buildContactItem(
            context,
            icon: Icons.email,
            title: 'Email',
            value: userData['email'],
          ),
          const SizedBox(height: 15),
          _buildContactItem(
            context,
            icon: Icons.phone,
            title: 'Phone',
            value: userData['phone'],
          ),
          const SizedBox(height: 15),
          _buildContactItem(
            context,
            icon: Icons.location_on,
            title: 'Location',
            value: userData['location'],
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send Me a Message',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.displayMedium!.color,
              ),
            ),
            const SizedBox(height: 30),
            _buildTextFormField(
              controller: _nameController,
              label: 'Your Name',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _emailController,
              label: 'Your Email',
              icon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _messageController,
              label: 'Your Message',
              icon: Icons.message,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your message';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSending
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    _handleSubmit();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSending
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Send Message',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      maxLines: maxLines,
      validator: validator,
    );
  }

  void _handleSubmit() {
    setState(() {
      _isSending = true;
    });

    // Simulate form submission
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSending = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Message sent successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Clear form
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      }
    });
  }
}