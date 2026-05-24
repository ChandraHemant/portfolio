import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_app/config/responsive.dart';
import 'package:portfolio_app/models/portfolio_data.dart';
import 'package:portfolio_app/widgets/social_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  final ScrollController? scrollController;
  const ContactScreen({Key? key, this.scrollController}) : super(key: key);

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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: widget.scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : (isTablet ? 40 : 100),
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Text(
                'Get In Touch',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 32 : 44,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
              
              const SizedBox(height: 10),
              
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms),

              const SizedBox(height: 20),

              Text(
                'Have a project in mind, want to collaborate, or just say hello? Drop a message!',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 14 : 16,
                  height: 1.6,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : Colors.black.withOpacity(0.6),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms),

              const SizedBox(height: 48),

              // Responsive Two-Column Details & Form
              Responsive.responsiveLayout(
                mobile: _buildMobileLayout(context, userData, socials),
                tablet: _buildDesktopLayout(context, userData, socials, isTablet: true),
                desktop: _buildDesktopLayout(context, userData, socials, isTablet: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context, 
    Map<String, dynamic> userData, 
    List<dynamic> socials
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactInfo(context, userData),
        const SizedBox(height: 24),
        _buildSocialsSection(context, socials),
        const SizedBox(height: 32),
        _buildContactForm(context),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context, 
    Map<String, dynamic> userData, 
    List<dynamic> socials, 
    {required bool isTablet}
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Details & Socials
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContactInfo(context, userData),
              const SizedBox(height: 28),
              _buildSocialsSection(context, socials),
            ],
          ),
        ),
        
        SizedBox(width: isTablet ? 32 : 54),
        
        // Right Column: Form
        Expanded(
          flex: 6,
          child: _buildContactForm(context),
        ),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context, Map<String, dynamic> userData) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final infoBg = isDark 
        ? Colors.white.withOpacity(0.04) 
        : Colors.black.withOpacity(0.03);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: infoBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoItem(context, Icons.email_outlined, 'Email Address', userData['email']),
          const SizedBox(height: 18),
          _buildInfoItem(context, Icons.phone_outlined, 'Phone Number', userData['phone']),
          const SizedBox(height: 18),
          _buildInfoItem(context, Icons.location_on_outlined, 'Location', userData['location']),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: theme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialsSection(BuildContext context, List<dynamic> socials) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connect on Social Media',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
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
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms);
  }

  Widget _buildContactForm(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final formBg = isDark 
        ? Colors.white.withOpacity(0.04) 
        : Colors.black.withOpacity(0.03);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: formBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
          width: 1.5,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a Message',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            
            // Name Field
            _buildTextFormField(
              controller: _nameController,
              label: 'Your Name',
              icon: Icons.person_outline_rounded,
              validator: (val) => val == null || val.isEmpty ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),

            // Email Field
            _buildTextFormField(
              controller: _emailController,
              label: 'Your Email',
              icon: Icons.mail_outline_rounded,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please enter your email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Message Field
            _buildTextFormField(
              controller: _messageController,
              label: 'Your Message',
              icon: Icons.chat_bubble_outline_rounded,
              maxLines: 5,
              validator: (val) => val == null || val.isEmpty ? 'Please enter your message' : null,
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSending ? null : _handleSubmit,
                child: _isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 350.ms);
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
        ),
        prefixIcon: Icon(icon, size: 20, color: theme.primaryColor.withOpacity(0.6)),
        filled: true,
        fillColor: isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.4),
      ),
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    final name = _nameController.text;
    final email = _emailController.text;
    final message = _messageController.text;

    // Construct the email body
    final String emailBody = 'Name: $name\nEmail: $email\n\nMessage:\n$message';
    final Uri mailUri = Uri(
      scheme: 'mailto',
      path: 'info@hemantchandra.com',
      query: 'subject=Portfolio Contact from $name&body=${Uri.encodeComponent(emailBody)}',
    );

    // Construct the WhatsApp URL as a fallback
    final String whatsappBody = 'Hello Hemant,\n\nI am contacting you from your portfolio website.\n\nName: $name\nEmail: $email\n\nMessage:\n$message';
    final Uri whatsappUri = Uri.parse('https://wa.me/918839105236?text=${Uri.encodeComponent(whatsappBody)}');

    bool mailLaunched = false;
    try {
      mailLaunched = await launchUrl(mailUri);
    } catch (e) {
      mailLaunched = false;
    }

    setState(() => _isSending = false);

    if (mailLaunched) {
      // If mail client successfully opened, we can't detect if they sent it or cancelled.
      // So we show a snackbar offering WhatsApp just in case they cancelled.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Opening email client... If it didn\'t work or you didn\'t send it, you can use WhatsApp instead.',
              style: GoogleFonts.plusJakartaSans(),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            duration: const Duration(seconds: 10),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Open WhatsApp',
              textColor: Colors.white,
              onPressed: () {
                launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
              },
            ),
          ),
        );
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      }
    } else {
      // If mailto: failed entirely (e.g. no mail app installed), immediately open WhatsApp
      try {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
        if (mounted) {
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open email or WhatsApp. Please contact via phone.')),
          );
        }
      }
    }
  }
}