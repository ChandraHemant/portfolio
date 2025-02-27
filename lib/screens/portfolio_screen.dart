import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:portfolio_app/config/responsive.dart';
import 'package:portfolio_app/models/portfolio_data.dart';
import 'package:universal_html/html.dart' as html;

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final Map<String, dynamic> data = PortfolioData.data;
  bool isGeneratingResume = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.05),
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Responsive.responsiveLayout(
              mobile: _buildMobileLayout(theme),
              tablet: _buildTabletLayout(theme),
              desktop: _buildDesktopLayout(theme),
            ),
          ),
        ),
      ),
      floatingActionButton: Responsive.isMobile(context)
          ? FloatingActionButton.extended(
              onPressed: isGeneratingResume ? null : _generateResume,
              icon: isGeneratingResume
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download),
              label: Text(
                isGeneratingResume ? 'Generating...' : 'Resume PDF',
              ),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            )
          : null,
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return Column(
      children: [
        _buildProfileSection(theme),
        const SizedBox(height: 16),
        _buildResumePreview(theme),
        const SizedBox(height: 16),
        _buildProjectsSection(theme, true),
      ],
    );
  }

  Widget _buildTabletLayout(ThemeData theme) {
    return Column(
      children: [
        _buildProfileSection(theme),
        const SizedBox(height: 24),
        _buildResumePreview(theme),
        const SizedBox(height: 24),
        _buildProjectsSection(theme, false),
      ],
    );
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _buildProfileSection(theme),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 7,
              child: _buildResumePreview(theme),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildProjectsSection(theme, false),
      ],
    );
  }

  Widget _buildProjectsSection(ThemeData theme, bool isMobile) {
    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'PROJECTS',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    fontSize: isMobile ? 18 : null,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        width: 1),
                  ),
                  child: Text(
                    '${(data['projects'] as List).length} Projects',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Project Grid or List
            isMobile
                ? _buildMobileProjectsList(theme)
                : _buildProjectsGrid(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileProjectsList(ThemeData theme) {
    return Column(
      children: (data['projects'] as List).map<Widget>((project) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(11),
                      topRight: Radius.circular(11),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['title'],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project['description'],
                        style: theme.textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: (project['technologies'] as List)
                            .map<Widget>((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tech,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProjectsGrid(ThemeData theme) {
    int crossAxisCount = Responsive.isDesktop(context)
        ? 3
        : (Responsive.isTablet(context) ? 2 : 1);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: (data['projects'] as List).length,
      itemBuilder: (context, index) {
        final project = (data['projects'] as List)[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(11),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['title'],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          project['description'],
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: (project['technologies'] as List)
                            .map<Widget>((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tech,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: Responsive.isMobile(context) ? 40 : 60,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  data['name'].toString().substring(0, 1),
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 30 : 40,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                data['name'],
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                data['title'],
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildContactItem(
              theme,
              Icons.email_outlined,
              data['email'],
            ),
            _buildContactItem(
              theme,
              Icons.phone_outlined,
              data['phone'],
            ),
            _buildContactItem(
              theme,
              Icons.location_on_outlined,
              data['location'],
            ),
            const SizedBox(height: 24),
            Text(
              'SOCIAL PROFILES',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            _buildSocialProfiles(theme),
            const SizedBox(height: 24),
            Text(
              'SKILLS',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            _buildSkillsList(theme),
            const SizedBox(height: 16),
            Text(
              'LANGUAGES',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            _buildLanguagesList(theme),
            if (!Responsive.isMobile(context)) ...[
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: isGeneratingResume ? null : _generateResume,
                  icon: isGeneratingResume
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: Text(
                    isGeneratingResume
                        ? 'Generating...'
                        : 'Download ATS Resume',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSocialProfiles(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: (data['socials'] as List).map<Widget>((social) {
        IconData icon;
        switch (social['icon']) {
          case 'linkedin':
            icon = Icons.telegram;
            break;
          case 'web':
            icon = Icons.language;
            break;
          case 'flutter':
            icon = Icons.flutter_dash;
            break;
          case 'php':
            icon = Icons.code;
            break;
          default:
            icon = Icons.link;
        }
        return Tooltip(
          message: social['name'],
          child: InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkillsList(ThemeData theme) {
    return Column(
      children: (data['skills'] as List).map<Widget>((skill) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    skill['name'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${(skill['level'] * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: skill['level'],
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLanguagesList(ThemeData theme) {
    return Column(
      children: (data['languages'] as List).map<Widget>((language) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                language['name'],
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                language['proficiency'],
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContactItem(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumePreview(ThemeData theme) {
    final isSmallScreen = Responsive.isMobile(context);

    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'RESUME PREVIEW',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    fontSize: isSmallScreen ? 18 : null,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green, width: 1),
                  ),
                  child: const Text(
                    'ATS Friendly',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (!isSmallScreen)
              Text(
                'This preview shows how your resume will appear when downloaded.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            const SizedBox(height: 24),

            // Header - Responsive for smaller screens
            if (isSmallScreen)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'],
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['title'],
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['email'],
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    data['phone'],
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    data['location'],
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'],
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['title'],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          data['email'],
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          data['phone'],
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          data['location'],
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Divider(color: theme.colorScheme.primary),
            const SizedBox(height: 16),

            // Summary
            Text(
              'PROFESSIONAL SUMMARY',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data['about'],
              style: theme.textTheme.bodyMedium,
              maxLines: isSmallScreen ? 4 : null,
              overflow:
                  isSmallScreen ? TextOverflow.ellipsis : TextOverflow.visible,
            ),
            const SizedBox(height: 24),

            // Experience
            Text(
              'PROFESSIONAL EXPERIENCE',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),

            // If mobile, limit the number of experiences shown
            ...((data['experiences'] as List).take(isSmallScreen ? 1 : 4))
                .map<Widget>((exp) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            exp['position'],
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          exp['duration'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      exp['company'],
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exp['description'],
                      style: theme.textTheme.bodyMedium,
                      maxLines: isSmallScreen ? 3 : null,
                      overflow: isSmallScreen
                          ? TextOverflow.ellipsis
                          : TextOverflow.visible,
                    ),
                  ],
                ),
              );
            }).toList(),

            if ((data['experiences'] as List).length > (isSmallScreen ? 1 : 4))
              Text(
                '+ ${(data['experiences'] as List).length - (isSmallScreen ? 1 : 4)} more experiences',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),

            const SizedBox(height: 16),

            // Skills - more compact on mobile
            Text(
              'SKILLS',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (isSmallScreen
                      ? (data['skills'] as List).take(6)
                      : data['skills'] as List)
                  .map<Widget>((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    skill['name'],
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                );
              }).toList(),
            ),

            if (isSmallScreen && (data['skills'] as List).length > 6)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '+ ${(data['skills'] as List).length - 6} more skills',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Education - limit for mobile
            Text(
              'EDUCATION',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            ...((data['education'] as List).take(isSmallScreen ? 1 : 2))
                .map<Widget>((edu) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            edu['degree'],
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          edu['duration'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      edu['institution'],
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      edu['description'],
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 16),

            // Projects section in preview - just for larger screens
            if (!isSmallScreen) ...[
              Text(
                'SELECTED PROJECTS',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    ((data['projects'] as List).take(3)).map<Widget>((project) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ${project['title']}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            project['description'],
                            style: theme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Packages - only for non-mobile
            if (!isSmallScreen) ...[
              Text(
                'PUBLISHED PACKAGES',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children:
                    ((data['packages'] as List).take(3)).map<Widget>((package) {
                  return Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      package['name'],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // ATS Optimization Indicators - Hide on small screens to save space
            if (!isSmallScreen)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ATS Optimization Features',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildAtsFeature(
                        theme, 'Clean, scannable layout for ATS systems'),
                    _buildAtsFeature(
                        theme, 'Proper section headings and formatting'),
                    _buildAtsFeature(
                        theme, 'Keyword-rich content from your industry'),
                    _buildAtsFeature(
                        theme, 'Professional fonts and minimal styling'),
                    _buildAtsFeature(
                        theme, 'Chronological format with clear dates'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAtsFeature(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _generateResume() async {
    setState(() {
      isGeneratingResume = true;
    });

    try {
      final pdf = await _buildResumePdf();

      // For web platform - use direct browser download instead of relying on printing plugin
      if (kIsWeb) {
        await _downloadPdfForWeb(pdf);
      } else {
        // For mobile/desktop platforms
        final output = await _savePdfToFile(pdf);
        if (output != null && mounted) {
          await OpenFile.open(output.path);
        }
      }
    } catch (e) {
      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to generate PDF: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      print('Error generating PDF: $e');
    } finally {
      if (mounted) {
        setState(() {
          isGeneratingResume = false;
        });
      }
    }
  }

// Web-specific method for direct download without using printing plugin
  Future<void> _downloadPdfForWeb(Uint8List pdfBytes) async {
    // Use dart:html for web-only functionality
    // ignore: avoid_web_libraries_in_flutter

    // Create a Blob from the PDF bytes
    final blob = html.Blob([pdfBytes], 'application/pdf');

    // Create a URL for the Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element with the URL
    final anchor = html.AnchorElement()
      ..href = url
      ..style.display = 'none'
      ..download = '${data['name'].toString().replaceAll(' ', '_')}_Resume.pdf';

    // Add to document body
    html.document.body?.children.add(anchor);

    // Trigger click
    anchor.click();

    // Cleanup
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Future<File?> _savePdfToFile(Uint8List pdfBytes) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
          '${dir.path}/${data['name'].toString().replaceAll(' ', '_')}_Resume.pdf');
      await file.writeAsBytes(pdfBytes);
      return file;
    } catch (e) {
      print('Error saving PDF: $e');
      return null;
    }
  }

  Future<Uint8List> _buildResumePdf() async {
    final pdf = pw.Document();

    // Use standard fonts for better compatibility and ATS readability
    final fontRegular = pw.Font.helvetica();
    final fontBold = pw.Font.helveticaBold();
    final fontItalic = pw.Font.helveticaOblique();

    // ATS-friendly colors
    const primaryColor = PdfColor(0.0, 0.32, 0.61); // Professional blue
    const textColor = PdfColor(0.1, 0.1, 0.1); // Near black
    const secondaryTextColor = PdfColor(0.3, 0.3, 0.3); // Dark gray
    const accentColor = PdfColor(0.95, 0.95, 0.95); // Very light gray for backgrounds
    const borderColor = PdfColor(0.6, 0.8, 0.9); // Light blue for borders
    const lightPrimaryColor = PdfColor(0.8, 0.9, 1.0); // Very light blue

    // Further reduced font sizes to fit all content
    const headerFontSize = 15.0;
    const subHeaderFontSize = 12.0;
    const normalFontSize = 11.0;
    const smallFontSize = 10.0;
    const tinyFontSize = 9.0;

    // Further reduced margins to fit more content
    final pageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
      buildBackground: (pw.Context context) {
        return pw.Container(
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(width: 1, color: primaryColor),
            ),
          ),
        );
      },
    );

    // ATS-friendly section title style
    final sectionTitleStyle = pw.TextStyle(
      font: fontBold,
      fontSize: subHeaderFontSize,
      color: primaryColor,
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        maxPages: 1, // Force single page
        build: (pw.Context context) {
          return [
            // Header with contact info - more compact layout
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 4),
                      pw.Text(
                        data['name'].toUpperCase(),
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: headerFontSize,
                          color: primaryColor,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        data['title'],
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: normalFontSize,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.SizedBox(height: 4),
                      _buildContactLine(data['email'], fontRegular, smallFontSize, secondaryTextColor),
                      _buildContactLine(data['phone'], fontRegular, smallFontSize, secondaryTextColor),
                      _buildContactLine(data['location'], fontRegular, smallFontSize, secondaryTextColor),
                      if ((data['socials'] as List).isNotEmpty)
                        _buildContactLine((data['socials'] as List)[0]['url'], fontRegular, smallFontSize, primaryColor),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Divider(color: primaryColor, thickness: 0.5),
            pw.SizedBox(height: 5),

            // Two column layout for the entire content to maximize space usage
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Left column: Summary, Experience, Skills
                pw.Expanded(
                  flex: 5,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Summary - kept concise
                      pw.Text('PROFESSIONAL SUMMARY', style: sectionTitleStyle),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        data['about'],
                        style: pw.TextStyle(
                          font: fontRegular,
                          fontSize: normalFontSize,
                          color: textColor,
                        ),
                      ),
                      pw.SizedBox(height: 5),

                      // Experience - Optimized for space
                      pw.Text('PROFESSIONAL EXPERIENCE', style: sectionTitleStyle),
                      pw.SizedBox(height: 2),
                      ...List.generate((data['experiences'] as List).length, (index) {
                        final exp = (data['experiences'] as List)[index];
                        return pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 2),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Expanded(
                                    child: pw.Text(
                                      exp['position'],
                                      style: pw.TextStyle(
                                        font: fontBold,
                                        fontSize: normalFontSize,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  pw.Text(
                                    exp['duration'],
                                    style: pw.TextStyle(
                                      font: fontItalic,
                                      fontSize: tinyFontSize,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Text(
                                exp['company'],
                                style: pw.TextStyle(
                                  font: fontBold,
                                  fontSize: smallFontSize,
                                  color: primaryColor,
                                ),
                              ),
                              pw.SizedBox(height: 1),
                              _buildBulletedText(
                                  exp['description'],
                                  fontRegular,
                                  smallFontSize,
                                  textColor
                              ),
                            ],
                          ),
                        );
                      }),

                      // Education - Made more concise
                      pw.SizedBox(height: 8),
                      pw.Text('EDUCATION', style: sectionTitleStyle),
                      pw.SizedBox(height: 3),
                      ...List.generate((data['education'] as List).length, (index) {
                        final edu = (data['education'] as List)[index];
                        return pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 2),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                flex: 6,
                                child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      edu['degree'],
                                      style: pw.TextStyle(
                                        font: fontBold,
                                        fontSize: smallFontSize,
                                        color: textColor,
                                      ),
                                    ),
                                    pw.Text(
                                      edu['institution'],
                                      style: pw.TextStyle(
                                        font: fontRegular,
                                        fontSize: smallFontSize,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              pw.Expanded(
                                flex: 4,
                                child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    pw.Text(
                                      edu['duration'],
                                      style: pw.TextStyle(
                                        font: fontItalic,
                                        fontSize: tinyFontSize,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                    pw.Text(
                                      edu['description'],
                                      style: pw.TextStyle(
                                        font: fontItalic,
                                        fontSize: tinyFontSize,
                                        color: secondaryTextColor,
                                      ),
                                      textAlign: pw.TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      // Skills - Displayed as inline tags to save space
                      pw.SizedBox(height: 8),
                      pw.Text('SKILLS', style: sectionTitleStyle),
                      pw.SizedBox(height: 3),
                      pw.Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: List.generate((data['skills'] as List).length, (index) {
                          final skill = (data['skills'] as List)[index];
                          return pw.Container(
                            decoration: pw.BoxDecoration(
                              color: accentColor,
                              borderRadius: pw.BorderRadius.circular(3),
                              border: pw.Border.all(color: borderColor),
                            ),
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            margin: const pw.EdgeInsets.only(right: 2, bottom: 2),
                            child: pw.Text(
                              skill['name'],
                              style: pw.TextStyle(
                                font: fontRegular,
                                fontSize: smallFontSize,
                                color: textColor,
                              ),
                            ),
                          );
                        }),
                      ),

                      // Languages - Inline layout
                      pw.SizedBox(height: 8),
                      pw.Text('LANGUAGES', style: sectionTitleStyle),
                      pw.SizedBox(height: 3),
                      pw.Row(
                        children: List.generate((data['languages'] as List).length, (index) {
                          final language = (data['languages'] as List)[index];
                          return pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  language['name'],
                                  style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: smallFontSize,
                                    color: textColor,
                                  ),
                                ),
                                pw.Text(
                                  language['proficiency'],
                                  style: pw.TextStyle(
                                    font: fontItalic,
                                    fontSize: tinyFontSize,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(width: 8),

                // Right column: Projects, Packages and Social
                pw.Expanded(
                  flex: 5,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Projects - More condensed
                      pw.Text('PROJECTS', style: sectionTitleStyle),
                      pw.SizedBox(height: 3),
                      ...List.generate((data['projects'] as List).length, (index) {
                        final project = (data['projects'] as List)[index];
                        return pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 4),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                project['title'],
                                style: pw.TextStyle(
                                  font: fontBold,
                                  fontSize: smallFontSize,
                                  color: textColor,
                                ),
                              ),
                              pw.Text(
                                project['description'],
                                style: pw.TextStyle(
                                  font: fontRegular,
                                  fontSize: tinyFontSize,
                                  color: textColor,
                                ),
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                              pw.SizedBox(height: 1),
                              pw.Wrap(
                                spacing: 2,
                                runSpacing: 2,
                                children: List.generate((project['technologies'] as List).length, (i) {
                                  return pw.Container(
                                    decoration: pw.BoxDecoration(
                                      color: accentColor,
                                      borderRadius: pw.BorderRadius.circular(2),
                                    ),
                                    padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 2,
                                      vertical: 1,
                                    ),
                                    child: pw.Text(
                                      project['technologies'][i],
                                      style: pw.TextStyle(
                                        font: fontRegular,
                                        fontSize: tinyFontSize,
                                        color: textColor,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        );
                      }),

                      // Packages - More compact
                      pw.SizedBox(height: 8),
                      pw.Text('PUBLISHED PACKAGES', style: sectionTitleStyle),
                      pw.SizedBox(height: 3),
                      pw.Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: List.generate((data['packages'] as List).length, (index) {
                          final package = (data['packages'] as List)[index];
                          return pw.Container(
                            width: 80,
                            padding: const pw.EdgeInsets.all(2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: borderColor),
                              borderRadius: pw.BorderRadius.circular(3),
                              color: lightPrimaryColor,
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  package['name'],
                                  style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: tinyFontSize,
                                    color: primaryColor,
                                  ),
                                ),
                                pw.Text(
                                  package['platform'],
                                  style: pw.TextStyle(
                                    font: fontItalic,
                                    fontSize: tinyFontSize,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),

                      // Social profiles - Condensed into a table
                      pw.SizedBox(height: 8),
                      pw.Text('SOCIAL PROFILES', style: sectionTitleStyle),
                      pw.SizedBox(height: 3),
                      pw.Table(
                        columnWidths: {
                          0: pw.FlexColumnWidth(1.5),
                          1: pw.FlexColumnWidth(2.5),
                        },
                        children: List.generate((data['socials'] as List).length, (index) {
                          if (index == 0) return pw.TableRow(children: [pw.Container(), pw.Container()]); // Skip first one as it's in header
                          final social = (data['socials'] as List)[index];
                          return pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 2, right: 2),
                                child: pw.Text(
                                  social['name'],
                                  style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: tinyFontSize,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 2),
                                child: pw.Text(
                                  social['url'],
                                  style: pw.TextStyle(
                                    font: fontItalic,
                                    fontSize: tinyFontSize,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Footer
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 5),
              child: pw.Divider(color: primaryColor, thickness: 0.5),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

// Helper function for contact line
  pw.Widget _buildContactLine(String text, pw.Font font, double fontSize, PdfColor color) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        font: font,
        fontSize: fontSize,
        color: color,
      ),
      textAlign: pw.TextAlign.right,
    );
  }

// Helper function for bulleted text - more compact
  pw.Widget _buildBulletedText(String text, pw.Font font, double fontSize, PdfColor color) {
    // Split text into sentences or parts
    final parts = text.split('. ')
        .where((part) => part.trim().isNotEmpty)
        .map((part) => part.trim())
        .toList();

    if (parts.isEmpty) {
      return pw.Container();
    }

    // If it's just one part, don't use bullets
    if (parts.length == 1) {
      return pw.Text(
        parts[0] + (parts[0].endsWith('.') ? '' : '.'),
        style: pw.TextStyle(
          font: font,
          fontSize: fontSize,
          color: color,
        ),
      );
    }

    // For multiple parts, use bullets but more compact layout
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: List.generate(parts.length, (index) {
        if (parts[index].isEmpty) return pw.Container();

        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 1),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '* ',
                style: pw.TextStyle(
                  font: font,
                  fontSize: fontSize,
                  color: color,
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  parts[index] + (parts[index].endsWith('.') ? '' : '.'),
                  style: pw.TextStyle(
                    font: font,
                    fontSize: fontSize,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
