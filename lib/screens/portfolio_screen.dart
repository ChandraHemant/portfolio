import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_app/config/responsive.dart';
import 'package:portfolio_app/models/portfolio_data.dart';
import 'package:universal_html/html.dart' as html;

class PortfolioScreen extends StatefulWidget {
  final ScrollController? scrollController;
  const PortfolioScreen({Key? key, this.scrollController}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final Map<String, dynamic> data = PortfolioData.data;
  bool isGeneratingResume = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
                'My Resume',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 32 : 44,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
              
              const SizedBox(height: 10),
              
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.primaryColor, theme.colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms),

              const SizedBox(height: 20),

              Text(
                'View a preview of my ATS-compliant resume or download a copy below.',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 14 : 16,
                  height: 1.6,
                  color: isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms),

              const SizedBox(height: 40),

              // Layout Grid
              Responsive.responsiveLayout(
                mobile: _buildMobileLayout(theme),
                tablet: _buildTabletLayout(theme),
                desktop: _buildDesktopLayout(theme),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: null,
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return Column(
      children: [
        _buildProfileSection(theme),
        const SizedBox(height: 24),
        _buildResumePreview(theme),
      ],
    );
  }

  Widget _buildTabletLayout(ThemeData theme) {
    return Column(
      children: [
        _buildProfileSection(theme),
        const SizedBox(height: 24),
        _buildResumePreview(theme),
      ],
    );
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: _buildProfileSection(theme),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 6,
          child: _buildResumePreview(theme),
        ),
      ],
    );
  }

  Widget _buildProfileSection(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 54,
              backgroundColor: theme.primaryColor.withOpacity(0.12),
              child: Text(
                data['name'].toString().substring(0, 1),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              data['name'],
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: isDark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              data['title'],
              style: GoogleFonts.plusJakartaSans(
                color: theme.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 20),
          _buildContactItem(theme, Icons.email_outlined, data['email']),
          _buildContactItem(theme, Icons.phone_outlined, data['phone']),
          _buildContactItem(theme, Icons.location_on_outlined, data['location']),
          
          const SizedBox(height: 32),
          Text(
            'LANGUAGES',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.5,
              color: isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 12),
          _buildLanguagesList(theme),
          
          const SizedBox(height: 32),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isGeneratingResume ? null : () => _generateResume(isFull: false),
                  icon: isGeneratingResume
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.download_rounded),
                  label: const Text('Download Single-Page (ATS)'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isGeneratingResume ? null : () => _generateResume(isFull: true),
                  icon: isGeneratingResume
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.menu_book_rounded),
                  label: const Text('Download Full Resume (Multi-Page)'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: theme.primaryColor.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
  }

  Widget _buildLanguagesList(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: (data['languages'] as List).map<Widget>((lang) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang['name'],
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: isDark ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8),
                ),
              ),
              Text(
                lang['proficiency'],
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                  fontSize: 12,
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
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.primaryColor,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumePreview(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RESUME PREVIEW',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: theme.primaryColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  'ATS Friendly',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Resume Info Title
          Text(
            data['name'].toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data['title'],
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Bio Summary
          _buildPreviewHeader('PROFESSIONAL SUMMARY'),
          const SizedBox(height: 10),
          Text(
            data['about'],
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 28),

          // Experience Preview list (take first 3)
          _buildPreviewHeader('PROFESSIONAL EXPERIENCE'),
          const SizedBox(height: 16),
          ...((data['experiences'] as List).take(3)).map<Widget>((exp) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          exp['position'],
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        exp['duration'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    exp['company'],
                    style: GoogleFonts.plusJakartaSans(
                      color: theme.primaryColor.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    exp['description'],
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.6,
                      color: isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 16),

          // Education Preview
          _buildPreviewHeader('EDUCATION'),
          const SizedBox(height: 16),
          ...((data['education'] as List).take(2)).map<Widget>((edu) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          edu['degree'],
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        edu['duration'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    edu['institution'],
                    style: GoogleFonts.plusJakartaSans(
                      color: theme.primaryColor.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }

  Widget _buildPreviewHeader(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w800,
        fontSize: 12,
        letterSpacing: 1.5,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Future<void> _generateResume({required bool isFull}) async {
    setState(() {
      isGeneratingResume = true;
    });

    try {
      final pdf = await _buildResumePdf(isFull: isFull);
      final suffix = isFull ? 'Full' : 'SinglePage';
      final fileName = '${data['name'].toString().replaceAll(' ', '_')}_Resume_$suffix.pdf';

      if (kIsWeb) {
        await _downloadPdfForWeb(pdf, fileName);
      } else {
        final output = await _savePdfToFile(pdf, fileName);
        if (output != null && mounted) {
          await OpenFile.open(output.path);
        }
      }
    } catch (e) {
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
      debugPrint('Error generating PDF: $e');
    } finally {
      if (mounted) {
        setState(() {
          isGeneratingResume = false;
        });
      }
    }
  }

  Future<void> _downloadPdfForWeb(Uint8List pdfBytes, String fileName) async {
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement()
      ..href = url
      ..style.display = 'none'
      ..download = fileName;

    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Future<File?> _savePdfToFile(Uint8List pdfBytes, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
      return file;
    } catch (e) {
      debugPrint('Error saving PDF: $e');
      return null;
    }
  }

  /// Helper to sanitize text before PDF rendering (applied lazily on data access below).
  /// This method is defined further down. We rely on _s() being available as a closure.

  Future<Uint8List> _buildResumePdf({required bool isFull}) async {
    final pdf = pw.Document();

    final fontRegular = pw.Font.helvetica();
    final fontBold = pw.Font.helveticaBold();
    final fontItalic = pw.Font.helveticaOblique();

    // Pre-sanitize all string data so Helvetica (Latin-1 only) can render it.
    String ss(dynamic v) => _s(v?.toString() ?? '');

    final pName        = ss(data['name']);
    final pTitle       = ss(data['title']);
    final pAbout       = ss(data['about']);
    final pEmail       = ss(data['email']);
    final pPhone       = ss(data['phone']);
    final pLocation    = ss(data['location']);
    final pLinkedIn    = (data['socials'] as List).isNotEmpty
        ? ss((data['socials'] as List)[0]['url'])
        : '';

    final pSkills = (data['skills'] as List)
        .map((s) => ss(s['name']))
        .toList();

    final pExps = (data['experiences'] as List).map((e) => {
      'position' : ss(e['position']),
      'company'  : ss(e['company']),
      'duration' : ss(e['duration']),
      'description': ss(e['description']),
    }).toList();

    final pProjects = (data['projects'] as List).map((p) => {
      'title'       : ss(p['title']),
      'description' : ss(p['description'] ?? p['desc'] ?? ''),
      'technologies': (p['technologies'] as List).map((t) => ss(t)).toList(),
    }).toList();

    final pEdu = (data['education'] as List).map((e) => {
      'degree'     : ss(e['degree']),
      'institution': ss(e['institution']),
      'duration'   : ss(e['duration']),
      'description': ss(e['description']),
    }).toList();

    final pPackages = (data['packages'] as List).map((p) => {
      'name'    : ss(p['name']),
      'platform': ss(p['platform']),
    }).toList();

    final pSocials = (data['socials'] as List).skip(1).map((s) => {
      'name': ss(s['name']),
      'url' : ss(s['url']),
    }).toList();

    final pLanguages = (data['languages'] as List).map((l) => {
      'name'       : ss(l['name']),
      'proficiency': ss(l['proficiency']),
    }).toList();

    const primaryColor = PdfColor(0.0, 0.32, 0.61);
    const textColor = PdfColor(0.1, 0.1, 0.1);
    const secondaryTextColor = PdfColor(0.3, 0.3, 0.3);
    const accentColor = PdfColor(0.95, 0.95, 0.95);
    const borderColor = PdfColor(0.6, 0.8, 0.9);
    const lightPrimaryColor = PdfColor(0.8, 0.9, 1.0);

    const headerFontSize = 15.0;
    const subHeaderFontSize = 12.0;
    const normalFontSize = 11.0;
    const smallFontSize = 10.0;
    const tinyFontSize = 9.0;

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

    final sectionTitleStyle = pw.TextStyle(
      font: fontBold,
      fontSize: subHeaderFontSize,
      color: primaryColor,
    );

    if (isFull) {
      pdf.addPage(
        pw.MultiPage(
          pageTheme: pageTheme,
          build: (pw.Context context) {
            return [
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
                          pName.toUpperCase(),
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: headerFontSize,
                            color: primaryColor,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          pTitle,
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
                        _buildContactLine(pEmail, fontRegular, smallFontSize, secondaryTextColor),
                        _buildContactLine(pPhone, fontRegular, smallFontSize, secondaryTextColor),
                        _buildContactLine(pLocation, fontRegular, smallFontSize, secondaryTextColor),
                        if (pLinkedIn.isNotEmpty)
                          _buildContactLine(pLinkedIn, fontRegular, smallFontSize, primaryColor),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Divider(color: primaryColor, thickness: 0.5),
              pw.SizedBox(height: 8),

              pw.Text('PROFESSIONAL SUMMARY', style: sectionTitleStyle),
              pw.SizedBox(height: 3),
              pw.Text(
                pAbout,
                style: pw.TextStyle(
                  font: fontRegular,
                  fontSize: normalFontSize,
                  color: textColor,
                ),
              ),
              pw.SizedBox(height: 12),

              pw.Text('SKILLS', style: sectionTitleStyle),
              pw.SizedBox(height: 4),
              pw.Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List.generate(pSkills.length, (index) {
                  final skillName = pSkills[index];
                  return pw.Container(
                    decoration: pw.BoxDecoration(
                      color: accentColor,
                      borderRadius: pw.BorderRadius.circular(3),
                      border: pw.Border.all(color: borderColor),
                    ),
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1.5,
                    ),
                    margin: const pw.EdgeInsets.only(right: 2, bottom: 2),
                    child: pw.Text(
                      skillName,
                      style: pw.TextStyle(
                        font: fontRegular,
                        fontSize: smallFontSize,
                        color: textColor,
                      ),
                    ),
                  );
                }),
              ),
              pw.SizedBox(height: 12),

              pw.Text('PROFESSIONAL EXPERIENCE', style: sectionTitleStyle),
              pw.SizedBox(height: 4),
              ...List.generate(pExps.length, (index) {
                final exp = pExps[index];
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                              exp['position']!,
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: normalFontSize,
                                color: textColor,
                              ),
                            ),
                          ),
                          pw.Text(
                            exp['duration']!,
                            style: pw.TextStyle(
                              font: fontItalic,
                              fontSize: tinyFontSize,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      pw.Text(
                        exp['company']!,
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: smallFontSize,
                          color: primaryColor,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      _buildBulletedText(
                          exp['description']!,
                          fontRegular,
                          smallFontSize,
                          textColor
                      ),
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 12),

              pw.Text('PROJECTS', style: sectionTitleStyle),
              pw.SizedBox(height: 4),
              ...List.generate(pProjects.length, (index) {
                final project = pProjects[index];
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '${index + 1}. ${project["title"]}',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: smallFontSize,
                          color: textColor,
                        ),
                      ),
                      pw.SizedBox(height: 1.5),
                      pw.Text(
                        project['description']!.toString(),
                        style: pw.TextStyle(
                          font: fontRegular,
                          fontSize: tinyFontSize,
                          color: textColor,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: List.generate((project['technologies']! as List).length, (i) {
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
                              (project['technologies']! as List)[i],
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
              pw.SizedBox(height: 12),

              pw.Text('EDUCATION', style: sectionTitleStyle),
              pw.SizedBox(height: 4),
              ...List.generate(pEdu.length, (index) {
                final edu = pEdu[index];
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 6,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              edu['degree']!,
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: smallFontSize,
                                color: textColor,
                              ),
                            ),
                            pw.Text(
                              edu['institution']!,
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
                              edu['duration']!,
                              style: pw.TextStyle(
                                font: fontItalic,
                                fontSize: tinyFontSize,
                                color: secondaryTextColor,
                              ),
                            ),
                            pw.Text(
                              edu['description']!,
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
              pw.SizedBox(height: 12),

              pw.Text('PUBLISHED PACKAGES', style: sectionTitleStyle),
              pw.SizedBox(height: 4),
              pw.Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List.generate(pPackages.length, (index) {
                  final package = pPackages[index];
                  return pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: borderColor),
                      borderRadius: pw.BorderRadius.circular(3),
                      color: lightPrimaryColor,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          package['name']!,
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: tinyFontSize,
                            color: primaryColor,
                          ),
                        ),
                        pw.Text(
                          package['platform']!,
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
              pw.SizedBox(height: 12),

              pw.Text('LANGUAGES', style: sectionTitleStyle),
              pw.SizedBox(height: 4),
              pw.Row(
                children: List.generate(pLanguages.length, (index) {
                  final language = pLanguages[index];
                  return pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          language['name']!,
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: smallFontSize,
                            color: textColor,
                          ),
                        ),
                        pw.Text(
                          language['proficiency']!,
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
              pw.SizedBox(height: 12),

              pw.Text('SOCIAL PROFILES', style: sectionTitleStyle),
              pw.SizedBox(height: 4),
              pw.Table(
                columnWidths: const {
                  0: pw.FlexColumnWidth(1.5),
                  1: pw.FlexColumnWidth(2.5),
                },
                children: List.generate(pSocials.length, (index) {
                  final social = pSocials[index];
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 2, right: 2),
                        child: pw.Text(
                          social['name']!,
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
                          social['url']!,
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
            ];
          },
        ),
      );
    } else {
      pdf.addPage(
        pw.MultiPage(
          pageTheme: pageTheme,
          maxPages: 1,
          build: (pw.Context context) {
            return [
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
                          pName.toUpperCase(),
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: headerFontSize,
                            color: primaryColor,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          pTitle,
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
                        _buildContactLine(pEmail, fontRegular, smallFontSize, secondaryTextColor),
                        _buildContactLine(pPhone, fontRegular, smallFontSize, secondaryTextColor),
                        _buildContactLine(pLocation, fontRegular, smallFontSize, secondaryTextColor),
                        if (pLinkedIn.isNotEmpty)
                          _buildContactLine(pLinkedIn, fontRegular, smallFontSize, primaryColor),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Divider(color: primaryColor, thickness: 0.5),
              pw.SizedBox(height: 5),

              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 5,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('PROFESSIONAL SUMMARY', style: sectionTitleStyle),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          pAbout,
                          style: pw.TextStyle(
                            font: fontRegular,
                            fontSize: normalFontSize,
                            color: textColor,
                          ),
                        ),
                        pw.SizedBox(height: 5),

                        pw.Text('PROFESSIONAL EXPERIENCE', style: sectionTitleStyle),
                        pw.SizedBox(height: 2),
                        ...List.generate(pExps.length, (index) {
                          final exp = pExps[index];
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
                                        exp['position']!,
                                        style: pw.TextStyle(
                                          font: fontBold,
                                          fontSize: normalFontSize,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                    pw.Text(
                                      exp['duration']!,
                                      style: pw.TextStyle(
                                        font: fontItalic,
                                        fontSize: tinyFontSize,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Text(
                                  exp['company']!,
                                  style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: smallFontSize,
                                    color: primaryColor,
                                  ),
                                ),
                                pw.SizedBox(height: 1),
                                _buildBulletedText(
                                    exp['description']!,
                                    fontRegular,
                                    smallFontSize,
                                    textColor
                                ),
                              ],
                            ),
                          );
                        }),

                        pw.SizedBox(height: 8),
                        pw.Text('EDUCATION', style: sectionTitleStyle),
                        pw.SizedBox(height: 3),
                        ...List.generate(pEdu.length, (index) {
                          final edu = pEdu[index];
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
                                        edu['degree']!,
                                        style: pw.TextStyle(
                                          font: fontBold,
                                          fontSize: smallFontSize,
                                          color: textColor,
                                        ),
                                      ),
                                      pw.Text(
                                        edu['institution']!,
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
                                        edu['duration']!,
                                        style: pw.TextStyle(
                                          font: fontItalic,
                                          fontSize: tinyFontSize,
                                          color: secondaryTextColor,
                                        ),
                                      ),
                                      pw.Text(
                                        edu['description']!,
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

                      ],
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  
                  pw.Expanded(
                    flex: 5,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('PROJECTS', style: sectionTitleStyle),
                        pw.SizedBox(height: 3),
                        ...List.generate(pProjects.take(6).length, (index) {
                          final project = pProjects[index];
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 4),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  project['title']!.toString(),
                                  style: pw.TextStyle(
                                    font: fontBold,
                                    fontSize: smallFontSize,
                                    color: textColor,
                                  ),
                                ),
                                pw.Text(
                                  project['description']!.toString(),
                                  style: pw.TextStyle(
                                    font: fontRegular,
                                    fontSize: tinyFontSize,
                                    color: textColor,
                                  ),
                                  maxLines: 3,
                                  overflow: pw.TextOverflow.clip,
                                ),
                                pw.SizedBox(height: 1),
                                pw.Wrap(
                                  spacing: 2,
                                  runSpacing: 2,
                                  children: List.generate((project['technologies']! as List).length, (i) {
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
                                        (project['technologies']! as List)[i],
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

                        pw.SizedBox(height: 8),
                        pw.Text('PUBLISHED PACKAGES', style: sectionTitleStyle),
                        pw.SizedBox(height: 3),
                        pw.Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: List.generate((data['packages'] as List).length, (index) {
                            final package = (data['packages'] as List)[index];
                            return pw.Container(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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

                        pw.SizedBox(height: 8),
                        pw.Text('SOCIAL PROFILES', style: sectionTitleStyle),
                        pw.SizedBox(height: 3),
                        pw.Table(
                          columnWidths: const {
                            0: pw.FlexColumnWidth(1.5),
                            1: pw.FlexColumnWidth(2.5),
                          },
                          children: List.generate((data['socials'] as List).length, (index) {
                            if (index == 0) return pw.TableRow(children: [pw.Container(), pw.Container()]);
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
                ],
              ),

              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 5),
                child: pw.Divider(color: primaryColor, thickness: 0.5),
              ),
            ];
          },
        ),
      );
    }

    return pdf.save();
  }

  /// Sanitizes text to only contain characters supported by built-in PDF
  /// Helvetica font (Latin-1 / ISO-8859-1 range). Replaces problematic
  /// Unicode characters with safe ASCII equivalents.
  String _s(String text) {
    return text
        // Smart quotes -> straight quotes
        .replaceAll('\u2018', "'")
        .replaceAll('\u2019', "'")
        .replaceAll('\u201C', '"')
        .replaceAll('\u201D', '"')
        // Dashes
        .replaceAll('\u2013', '-')
        .replaceAll('\u2014', '-')
        // Ampersand HTML entity
        .replaceAll('&amp;', '&')
        // Ellipsis
        .replaceAll('\u2026', '...')
        // Bullet
        .replaceAll('\u2022', '*')
        // Non-breaking space
        .replaceAll('\u00A0', ' ')
        // Remove emoji and other high codepoint Unicode (> U+00FF)
        .replaceAllMapped(
          RegExp(r'[^\x00-\xFF]'),
          (match) => '',
        )
        .trim();
  }

  pw.Widget _buildContactLine(String text, pw.Font font, double fontSize, PdfColor color) {
    return pw.Text(
      _s(text),
      style: pw.TextStyle(
        font: font,
        fontSize: fontSize,
        color: color,
      ),
      textAlign: pw.TextAlign.right,
    );
  }

  pw.Widget _buildBulletedText(String text, pw.Font font, double fontSize, PdfColor color) {
    final sanitized = _s(text);
    final parts = sanitized.split('. ')
        .where((part) => part.trim().isNotEmpty)
        .map((part) => part.trim())
        .toList();

    if (parts.isEmpty) {
      return pw.Container();
    }

    if (parts.length == 1) {
      final t = parts[0];
      return pw.Text(
        t.endsWith('.') ? t : '$t.',
        style: pw.TextStyle(
          font: font,
          fontSize: fontSize,
          color: color,
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: List.generate(parts.length, (index) {
        if (parts[index].isEmpty) return pw.Container();
        final t = parts[index];

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
                  t.endsWith('.') ? t : '$t.',
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
