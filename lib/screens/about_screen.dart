import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_app/config/responsive.dart';
import 'package:portfolio_app/models/portfolio_data.dart';

class AboutScreen extends StatelessWidget {
  final ScrollController? scrollController;
  const AboutScreen({Key? key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = PortfolioData.data;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : (isTablet ? 40 : 100),
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Text(
                'Experience',
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
              
              const SizedBox(height: 40),

              // Experiences Header
              Text(
                'Work Experience',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 24 : 32,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
              
              const SizedBox(height: 30),

              _buildTimeline(context, userData['experiences'], isMobile),

              const SizedBox(height: 50),

              // Education Header
              Text(
                'Education',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 24 : 32,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
              
              const SizedBox(height: 30),

              _buildEducationTimeline(context, userData['education'], isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, List<dynamic> experiences, bool isMobile) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final exp = experiences[index];
        return _ExperienceTimelineItem(
          position: exp['position'],
          company: exp['company'],
          duration: exp['duration'],
          description: exp['description'],
          index: index,
          isLast: index == experiences.length - 1,
          isMobile: isMobile,
        );
      },
    );
  }

  Widget _buildEducationTimeline(BuildContext context, List<dynamic> education, bool isMobile) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: education.length,
      itemBuilder: (context, index) {
        final edu = education[index];
        return _ExperienceTimelineItem(
          position: edu['degree'],
          company: edu['institution'],
          duration: edu['duration'],
          description: edu['description'],
          index: index + 4, // Shift stagger index so that they animate after work experience
          isLast: index == education.length - 1,
          isMobile: isMobile,
        );
      },
    );
  }
}

class _ExperienceTimelineItem extends StatefulWidget {
  final String position;
  final String company;
  final String duration;
  final String description;
  final int index;
  final bool isLast;
  final bool isMobile;

  const _ExperienceTimelineItem({
    Key? key,
    required this.position,
    required this.company,
    required this.duration,
    required this.description,
    required this.index,
    required this.isLast,
    required this.isMobile,
  }) : super(key: key);

  @override
  State<_ExperienceTimelineItem> createState() => _ExperienceTimelineItemState();
}

class _ExperienceTimelineItemState extends State<_ExperienceTimelineItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final cardBg = isDark 
        ? Colors.white.withOpacity(0.03) 
        : Colors.black.withOpacity(0.02);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline bar column
          Column(
            children: [
              // Timeline Dot
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _hovered ? theme.primaryColor : Colors.transparent,
                  border: Border.all(
                    color: _hovered ? theme.primaryColor : theme.dividerColor,
                    width: 3.5,
                  ),
                ),
              ),
              // Timeline Line
              if (!widget.isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: theme.dividerColor.withOpacity(0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 24),
          
          // Experience Details Column
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: MouseRegion(
                onEnter: (_) => setState(() => _hovered = true),
                onExit: (_) => setState(() => _hovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(widget.isMobile ? 18 : 24),
                  decoration: BoxDecoration(
                    color: _hovered 
                        ? theme.primaryColor.withOpacity(0.04) 
                        : cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _hovered
                          ? theme.primaryColor.withOpacity(0.2)
                          : (isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06)),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.position,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: widget.isMobile ? 16 : 19,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.company,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: widget.isMobile ? 14 : 16,
                                    fontWeight: FontWeight.w600,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.duration,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: widget.isMobile ? 10 : 12,
                                fontWeight: FontWeight.w700,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.description,
                        style: GoogleFonts.inter(
                          fontSize: widget.isMobile ? 13 : 15,
                          height: 1.6,
                          color: isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate()
     .fadeIn(duration: 500.ms, delay: Duration(milliseconds: widget.index * 100))
     .slideY(begin: 0.1, end: 0, duration: 500.ms, curve: Curves.easeOutQuad);
  }
}