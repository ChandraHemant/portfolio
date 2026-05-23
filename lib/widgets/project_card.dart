import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio_app/widgets/mouse_tilt.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final List<String> technologies;
  final String url;
  final String? year;
  final String? color;
  final String? icon;

  const ProjectCard({
    Key? key,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.technologies,
    required this.url,
    this.year,
    this.color,
    this.icon,
  }) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.025).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(widget.url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch ${widget.url}');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Parse color hex from project or fallback to primary
    Color projectColor = theme.primaryColor;
    if (widget.color != null) {
      try {
        projectColor = Color(int.parse('0xFF${widget.color}'));
      } catch (_) {}
    }

    final cardBgColor = isDark 
        ? theme.colorScheme.surface.withOpacity(0.4) 
        : theme.colorScheme.surface;
    
    final borderCol = _hovered 
        ? projectColor.withOpacity(0.5) 
        : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08));

    return MouseTilt(
      maxTiltX: 6,
      maxTiltY: 6,
      depth: 10,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _hovered = true);
          _ctrl.forward();
        },
        onExit: (_) {
          setState(() => _hovered = false);
          _ctrl.reverse();
        },
        child: ScaleTransition(
          scale: _scaleAnim,
          child: GestureDetector(
            onTap: _launchUrl,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderCol, width: 1.5),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: projectColor.withOpacity(0.12),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                          spreadRadius: 1,
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Gradient header band
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [projectColor, projectColor.withOpacity(0.3)],
                          ),
                        ),
                      ),
                    ),
                    
                    // Card Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          // Icon/Emoji + Year Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.icon ?? '🚀',
                                style: const TextStyle(fontSize: 32),
                              ),
                              if (widget.year != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: projectColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: projectColor.withOpacity(0.2), width: 1),
                                  ),
                                  child: Text(
                                    widget.year!,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: projectColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Project Title
                          Text(
                            widget.title,
                            style: GoogleFonts.plusJakartaSans(
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          
                          // Project Description
                          Text(
                            widget.description,
                            style: GoogleFonts.inter(
                              color: isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Technologies list
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: widget.technologies.take(3).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06),
                                  ),
                                ),
                                child: Text(
                                  tag.trim(),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
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
            ),
          ),
        ),
      ),
    );
  }
}
