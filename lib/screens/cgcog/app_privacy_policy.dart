import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    'overview': GlobalKey(),
    'information-collection': GlobalKey(),
    'location-data': GlobalKey(),
    'data-usage': GlobalKey(),
    'data-sharing': GlobalKey(),
    'data-retention': GlobalKey(),
    'your-rights': GlobalKey(),
    'security': GlobalKey(),
    'children': GlobalKey(),
    'changes': GlobalKey(),
    'contact': GlobalKey(),
  };

  void _scrollToSection(String sectionKey) {
    final key = _sectionKeys[sectionKey];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Color _getTextColor(ThemeData theme) {
    return theme.brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF333333); // Dark text for light mode
  }

  Color _getSecondaryTextColor(ThemeData theme) {
    return theme.brightness == Brightness.dark
        ? Colors.white70
        : const Color(0xFF495057); // Darker gray for light mode
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Container(
          width: screenWidth > 900 ? 900 : screenWidth,
          constraints: const BoxConstraints(maxWidth: 900),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeader(isMobile),
                _buildContent(isMobile, theme),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
      ),
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: Column(
        children: [
          Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: isMobile ? 28 : 35,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Government Building Survey Mobile Application',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMobile, ThemeData theme) {
    return Container(
      color: theme.brightness == Brightness.dark ? theme.scaffoldBackgroundColor : Colors.white,
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEffectiveDate(theme),
          const SizedBox(height: 32),
          _buildTableOfContents(theme),
          const SizedBox(height: 48),
          _buildOverviewSection(theme),
          const SizedBox(height: 48),
          _buildInformationCollectionSection(theme),
          const SizedBox(height: 48),
          _buildLocationDataSection(theme),
          const SizedBox(height: 48),
          _buildDataUsageSection(theme),
          const SizedBox(height: 48),
          _buildDataSharingSection(theme),
          const SizedBox(height: 48),
          _buildDataRetentionSection(theme),
          const SizedBox(height: 48),
          _buildYourRightsSection(theme),
          const SizedBox(height: 48),
          _buildSecuritySection(theme),
          const SizedBox(height: 48),
          _buildChildrenSection(theme),
          const SizedBox(height: 48),
          _buildChangesSection(theme),
          const SizedBox(height: 48),
          _buildContactSection(theme),
          const SizedBox(height: 32),
          _buildConsentBox(theme),
        ],
      ),
    );
  }

  Widget _buildEffectiveDate(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        border: Border.all(color: const Color(0xFFFFEAA7)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'Effective Date: August 29, 2025 | Last Updated: August 29, 2025',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xFF856404),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableOfContents(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : const Color(0xFFF8F9FA),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: const Border(
          left: BorderSide(width: 4, color: Color(0xFF667EEA)),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Table of Contents',
            style: TextStyle(
              color: Color(0xFF667EEA),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ..._buildTocItems(theme),
        ],
      ),
    );
  }

  List<Widget> _buildTocItems(ThemeData theme) {
    final items = [
      {'title': '1. Overview', 'key': 'overview'},
      {'title': '2. Information We Collect', 'key': 'information-collection'},
      {'title': '3. Location Data Usage', 'key': 'location-data'},
      {'title': '4. How We Use Your Information', 'key': 'data-usage'},
      {'title': '5. Information Sharing', 'key': 'data-sharing'},
      {'title': '6. Data Retention', 'key': 'data-retention'},
      {'title': '7. Your Rights and Choices', 'key': 'your-rights'},
      {'title': '8. Data Security', 'key': 'security'},
      {'title': '9. Children\'s Privacy', 'key': 'children'},
      {'title': '10. Policy Updates', 'key': 'changes'},
      {'title': '11. Contact Information', 'key': 'contact'},
    ];

    return items.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: GestureDetector(
          onTap: () => _scrollToSection(item['key']!),
          child: Text(
            item['title']!,
            style: TextStyle(
              color: _getSecondaryTextColor(theme),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF2C3E50),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 2,
          width: double.infinity,
          color: theme.brightness == Brightness.dark
              ? const Color(0xFF444444)
              : const Color(0xFFE9ECEF),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSubHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          color: _getTextColor(theme),
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHighlightBox(String title, List<String> items, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: theme.brightness == Brightness.dark
            ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2A2A2A),
            const Color(0xFF1E1E1E),
          ],
        )
            : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(width: 4, color: Color(0xFF667EEA)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF667EEA),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ',
                  style: TextStyle(
                    fontSize: 16,
                    color: _getTextColor(theme),
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      height: 1.6,
                      color: _getTextColor(theme),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildBulletList(List<String> items, ThemeData theme) {
    return Column(
      children: items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• ',
              style: TextStyle(
                fontSize: 16,
                color: _getTextColor(theme),
              ),
            ),
            Expanded(
              child: Text(
                item,
                style: TextStyle(
                  height: 1.6,
                  color: _getTextColor(theme),
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildAccordion(List<Map<String, dynamic>> items, ThemeData theme) {
    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFF444444)
                  : const Color(0xFFE9ECEF),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                item['title'],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _getTextColor(theme),
                ),
              ),
              backgroundColor: theme.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFF8F9FA),
              collapsedBackgroundColor: theme.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFF8F9FA),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (item['content'] as List<String>).map((content) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _getTextColor(theme),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  content,
                                  style: TextStyle(
                                    height: 1.6,
                                    color: _getTextColor(theme),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOverviewSection(ThemeData theme) {
    return Container(
      key: _sectionKeys['overview'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('1. Overview', theme),
          Text(
            'This Privacy Policy governs the Government Building Survey mobile application ("App") developed by CHiPS (Chhattisgarh Infotech Promotion Society) as a free government service. This policy explains how we collect, use, protect, and share your personal information when you use our App.',
            style: TextStyle(
              height: 1.6,
              color: _getTextColor(theme),
            ),
          ),
          _buildHighlightBox('Key Points', [
            'This App is provided "AS IS" as a free government service',
            'We collect minimal data necessary for App functionality',
            'Location data is used primarily for survey accuracy',
            'We do not sell your personal information',
          ], theme),
        ],
      ),
    );
  }

  Widget _buildInformationCollectionSection(ThemeData theme) {
    return Container(
      key: _sectionKeys['information-collection'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('2. Information We Collect', theme),
          _buildSubHeader('2.1 Information You Provide', theme),
          Text(
            'When you use our App, we may collect:',
            style: TextStyle(
              height: 1.6,
              color: _getTextColor(theme),
            ),
          ),
          const SizedBox(height: 16),
          _buildBulletList([
            'Contact Information: Email address (chipsgis97@gmail.com for support purposes)',
            'Survey Data: Building information, photographs, and survey responses you submit',
            'User Credentials: Login information if account creation is required',
          ], theme),
          _buildSubHeader('2.2 Automatically Collected Information', theme),
          Text(
            'Our App automatically collects certain technical information:',
            style: TextStyle(
              height: 1.6,
              color: _getTextColor(theme),
            ),
          ),
          const SizedBox(height: 16),
          _buildBulletList([
            'Device Information: IP address, operating system, device model',
            'Usage Analytics: Pages visited, time spent in App, feature usage',
            'Performance Data: Crash reports, error logs (anonymized)',
          ], theme),
        ],
      ),
    );
  }

  Widget _buildLocationDataSection(ThemeData theme) {
    return Container(
      key: _sectionKeys['location-data'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('3. Location Data Usage', theme),
          _buildHighlightBox('Why We Need Your Location', [
            'Location data is essential for accurate building surveys and ensuring data integrity for government planning purposes.',
          ], theme),
          _buildSubHeader('3.1 How We Use Location Data', theme),
          _buildBulletList([
            'Survey Accuracy: Precisely geotagging building locations and survey data',
            'Quality Assurance: Verifying survey data corresponds to actual locations',
            'Service Improvement: Analyzing usage patterns to enhance App functionality',
            'Mapping Services: Providing location-based features and navigation',
          ], theme),
          _buildSubHeader('3.2 Location Data Sharing', theme),
          Text(
            'We may share anonymized, aggregated location data with:',
            style: TextStyle(
              height: 1.6,
              color: _getTextColor(theme),
            ),
          ),
          const SizedBox(height: 16),
          _buildBulletList([
            'Government Agencies: For urban planning and infrastructure development',
            'Research Institutions: For academic research (fully anonymized)',
            'Service Providers: Technical partners who help improve the App',
          ], theme),
        ],
      ),
    );
  }

  Widget _buildDataUsageSection(ThemeData theme) {
    return Container(
      key: _sectionKeys['data-usage'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('4. How We Use Your Information', theme),
          const SizedBox(height: 16),
          _buildAccordion([
            {
              'title': 'Primary Purposes',
              'content': [
                'Processing and storing building survey data',
                'Providing App functionality and features',
                'Ensuring data quality and accuracy',
                'Government reporting and analysis',
              ],
            },
            {
              'title': 'Communication Purposes',
              'content': [
                'Sending important App updates and notifications',
                'Providing technical support',
                'Sharing relevant government announcements',
                'Responding to your inquiries',
              ],
            },
            {
              'title': 'Analytics and Improvement',
              'content': [
                'Analyzing App usage and performance',
                'Identifying and fixing technical issues',
                'Developing new features and improvements',
                'Ensuring security and preventing fraud',
              ],
            },
          ], theme),
        ],
      ),
    );
  }

  Widget _buildDataSharingSection(ThemeData theme) {
    return Container(
      key: _sectionKeys['data-sharing'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('5. Information Sharing', theme),
          Text(
            'We only share your information in the following limited circumstances:',
            style: TextStyle(
              height: 1.6,
              color: _getTextColor(theme),
            ),
          ),
          _buildSubHeader('5.1 Government Agencies', theme),
          Text(
            'Survey data may be shared with relevant government departments for:',
            style: TextStyle(
              height: 1.6,
              color: _getTextColor(theme),
            ),
          ),
          const SizedBox(height: 16),
          _buildBulletList([
            'Urban planning and development projects',
            'Infrastructure planning and maintenance',
            'Policy development and implementation',
            'Emergency response and disaster management',
          ], theme),
          _buildSubHeader('5.2 Legal Requirements', theme),
          Text(
            'We may disclose your information when required by law:',
            style: TextStyle(
              height: 1.6,
              color: _getTextColor(theme),
            ),
          ),
          const SizedBox(height: 16),
          _buildBulletList([
            'Court orders, subpoenas, or similar legal processes',
            'Government requests for national security purposes',
            'Protection of rights, property, or safety',
            'Investigation of fraud or other illegal activities',
          ], theme),
          _buildSubHeader('5.3 Service Providers', theme),
          Text(
            'Trusted third-party service providers who:',
            style: TextStyle(
              height: 1.6,
              color: _getTextColor(theme),
            ),
          ),
          const SizedBox(height: 16),
          _buildBulletList([
            'Assist with technical operations and maintenance',
            'Provide cloud storage and computing services',
            'Help with data analysis and reporting',
            'Are bound by confidentiality agreements',
          ], theme),
        ],
      ),
    );
  }

  Widget _buildDataRetentionSection(ThemeData theme) {
    return Container(
      key: _sectionKeys['data-retention'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('6. Data Retention', theme),
          _buildHighlightBox('Retention Periods', [
            'Survey Data: Retained indefinitely for government records',
            'Personal Information: Retained while you use the App + 3 years',
            'Technical Logs: Retained for 12 months',
            'Location Data: Aggregated data retained indefinitely, precise location data for 2 years',
          ], theme),
          Text.rich(
            TextSpan(
              text: 'You can request deletion of your personal data by contacting us at ',
              style: TextStyle(
                height: 1.6,
                color: _getTextColor(theme),
              ),
              children: [
                TextSpan(
                  text: 'chipsgis97@gmail.com',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getTextColor(theme),
                  ),
                ),
                TextSpan(
                  text: '. Please note that some data may be retained as required by law or for legitimate government purposes.',
                  style: TextStyle(
                    color: _getTextColor(theme),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourRightsSection(ThemeData theme) {
    return Container(
      key: _sectionKeys['your-rights'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('7. Your Rights and Choices', theme),
          _buildSubHeader('7.1 Access and Control', theme),
          _buildBulletList([
            'Access: Request copies of your personal data',
            'Correction: Update or correct inaccurate information',
            'Deletion: Request deletion of your personal data (subject to legal requirements)',
            'Portability: Request your data in a machine-readable format',
          ], theme),
          _buildSubHeader('7.2 Opt-Out Options', theme),
          _buildBulletList([
            'Uninstall: Stop all data collection by uninstalling the App',
            'Location Services: Disable location access in device settings (may limit App functionality)',
            'Communications: Opt out of non-essential communications',
          ], theme),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(ThemeData theme) {
    return Container(
      key: _sectionKeys['security'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('8. Data Security', theme),
          Text(
            'We implement comprehensive security measures to protect your information:',
            style: TextStyle(
              height: 1.6,
              color: _getTextColor(theme),
            ),
          ),
          const SizedBox(height: 16),
          _buildAccordion([
            {
              'title': 'Technical Safeguards',
              'content': [
                'End-to-end encryption for data transmission',
                'Encrypted data storage in secure government servers',
                'Regular security audits and vulnerability assessments',
                'Multi-factor authentication for admin access',
              ],
            },
            {
              'title': 'Administrative Safeguards',
              'content': [
                'Limited access to personal data on need-to-know basis',
                'Regular staff training on data protection',
                'Incident response procedures for data breaches',
                'Regular backup and disaster recovery testing',
              ],
            },
            {
              'title': 'Physical Safeguards',
              'content': [
                'Secure data centers with 24/7 monitoring',
                'Biometric access controls to server rooms',
                'Environmental controls and redundant systems',
                'Secure disposal of hardware and storage media',
              ],
            },
          ], theme),
        ],
      ),
    );
  }

  Widget _buildChildrenSection(ThemeData theme) {
    return Container(
      key: _sectionKeys['children'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('9. Children\'s Privacy', theme),
          _buildHighlightBox('Age Restrictions', [
            'This App is not intended for children under 16 years of age. We do not knowingly collect personal information from children under 16.',
          ], theme),
          Text(
            'If you are a parent or guardian and believe your child has provided personal information through our App:',
            style: TextStyle(
              height: 1.6,
              color: _getTextColor(theme),
            ),
          ),
          const SizedBox(height: 16),
          _buildBulletList([
            'Contact us immediately at chipsgis97@gmail.com',
            'We will promptly delete any such information',
            'We encourage parental supervision of children\'s internet usage',
            'Users aged 16-18 may need parental consent in some jurisdictions',
          ], theme),
        ],
      ),
    );
  }

  Widget _buildChangesSection(ThemeData theme) {
    return Container(
      key: _sectionKeys['changes'],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('10. Policy Updates', theme),
          Text(
            'We may update this Privacy Policy periodically to reflect:',
            style: TextStyle(
              height: 1.6,
              color: _getTextColor(theme),
            ),
          ),
          const SizedBox(height: 16),
          _buildBulletList([
            'Changes in our data practices',
            'New features or services',
            'Legal or regulatory requirements',
            'User feedback and suggestions',
          ], theme),
          const SizedBox(height: 16),
          Text(
            'How we notify you of changes:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              height: 1.6,
              color: _getTextColor(theme),
            ),
          ),
          const SizedBox(height: 16),
          _buildBulletList([
            'In-app notifications for significant changes',
            'Email notifications to registered users',
            'Updates posted on our official website',
            'Version history maintained for transparency',
          ], theme),
          const SizedBox(height: 16),
          Text(
            'Continued use of the App after policy updates constitutes acceptance of the revised terms.',
            style: TextStyle(
              height: 1.6,
              color: _getTextColor(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(ThemeData theme) {
    return Container(
      key: _sectionKeys['contact'],
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? const Color(0xFF2A2A2A)
              : const Color(0xFFE8F5E8),
          border: Border.all(
            color: theme.brightness == Brightness.dark
                ? const Color(0xFF444444)
                : const Color(0xFFC3E6C3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '11. Contact Information',
              style: TextStyle(
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFF67B7DC)
                    : const Color(0xFF2E7D32),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'For questions, concerns, or requests regarding this Privacy Policy or your personal data:',
              style: TextStyle(
                height: 1.6,
                color: _getTextColor(theme),
              ),
            ),
            const SizedBox(height: 24),
            _buildContactGrid(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildContactGrid(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          return Column(
            children: [
              _buildContactCard('General Inquiries', [
                'Email: chipsgis97@gmail.com',
                'Phone: +91 79876 64963',
                'Response Time: Within 72 hours',
              ], theme),
              const SizedBox(height: 16),
              _buildContactCard('Technical Support', [
                'Email: chips.application@gmail.com',
                'Phone: +91 77140 14158',
                'Response Time: Within 48 hours',
              ], theme),
              const SizedBox(height: 16),
              _buildContactCard('Data Protection Concerns', [
                'Email: chipsgis97@gmail.com',
                'Subject Line: "Data Protection Request"',
              ], theme),
              const SizedBox(height: 16),
              _buildContactCard('Organization', [
                'CHiPS',
                'Chhattisgarh Infotech and Biotech Promotion Society',
                'Chief Executive Officer, State Data Center',
                'Civil Lines, Raipur, Chhattisgarh 492001',
                'India',
              ], theme),
            ],
          );
        } else {
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: (constraints.maxWidth - 16) / 2,
                child: _buildContactCard('General Inquiries', [
                  'Email: chipsgis97@gmail.com',
                  'Phone: +91 79876 64963',
                  'Response Time: Within 72 hours',
                ], theme),
              ),
              SizedBox(
                width: (constraints.maxWidth - 16) / 2,
                child: _buildContactCard('Technical Support', [
                  'Email: chips.application@gmail.com',
                  'Phone: +91 77140 14158',
                  'Response Time: Within 48 hours',
                ], theme),
              ),
              SizedBox(
                width: (constraints.maxWidth - 16) / 2,
                child: _buildContactCard('Data Protection Concerns', [
                  'Email: chipsgis97@gmail.com',
                  'Subject Line: "Data Protection Request"',
                ], theme),
              ),
              SizedBox(
                width: (constraints.maxWidth - 16) / 2,
                child: _buildContactCard('Organization', [
                  'CHiPS',
                  'Chhattisgarh Infotech and Biotech Promotion Society',
                  'Chief Executive Officer, State Data Center',
                  'Civil Lines, Raipur, Chhattisgarh 492001',
                  'India',
                ], theme),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildContactCard(String title, List<String> details, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF1A1A1A)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? const Color(0xFF444444)
              : const Color(0xFFC3E6C3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: _getTextColor(theme),
            ),
          ),
          const SizedBox(height: 12),
          ...details.map((detail) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              detail,
              style: TextStyle(
                height: 1.4,
                color: _getSecondaryTextColor(theme),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildConsentBox(ThemeData theme) {
    return _buildHighlightBox('Your Consent', [
      'By downloading, installing, and using the Government Building Survey App, you acknowledge that you have read, understood, and agree to be bound by this Privacy Policy and consent to the processing of your information as described herein.',
    ], theme);
  }

  Widget _buildFooter() {
    return Container(
      color: const Color(0xFF2C3E50),
      padding: const EdgeInsets.all(32),
      child: const Column(
        children: [
          Text(
            '© 2025 CHiPS - Chhattisgarh Infotech Promotion Society. All rights reserved.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'This privacy policy was last updated on August 29, 2025',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}