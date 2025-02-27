import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';
import '../config/responsive.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String url;

  const ProjectCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
    required this.url,
  }) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressing = false;
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  // Mouse position for 3D effect
  Offset _mousePosition = Offset(0, 0);
  final double _rotationFactor = 0.008;
  final double _elevationHeight = 18;

  // Animation durations
  final Duration _hoverDuration = const Duration(milliseconds: 400);
  final Duration _particlesDuration = const Duration(milliseconds: 2500);

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: _hoverDuration,
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
        CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl() async {
    setState(() => _isPressing = true);

    final Uri uri = Uri.parse(widget.url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch ${widget.url}');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _isPressing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    // Colors
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final surfaceColor = Theme.of(context).colorScheme.background;
    final textColor = Theme.of(context).textTheme.displayMedium!.color!;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _scaleController.forward();
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _mousePosition = Offset(0, 0);
        });
        _scaleController.reverse();
      },
      onHover: (event) {
        if (isDesktop) {
          // Calculate relative position for the 3D effect
          RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final size = box.size;
            final offset = box.localToGlobal(Offset.zero);

            // Convert global event position to local component coordinates
            final localPosition = event.position - offset;

            // Calculate position relative to center (from -1 to 1)
            setState(() {
              _mousePosition = Offset(
                ((localPosition.dx / size.width) - 0.5) * 2,
                ((localPosition.dy / size.height) - 0.5) * 2,
              );
            });
          }
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge(
            [_scaleController, _shimmerController, _pulseController]),
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            // Advanced 3D transformation based on mouse position
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateX(_isHovered ? -_mousePosition.dy * _rotationFactor : 0)
              ..rotateY(_isHovered ? _mousePosition.dx * _rotationFactor : 0)
              ..translate(
                  0.0, _isPressing ? 5.0 : 0.0, 0.0) // Press down effect
              ..scale(_isPressing ? 0.98 : _scaleAnimation.value),
            child: GestureDetector(
              onTap: _launchUrl,
              onTapDown: (_) => setState(() => _isPressing = true),
              onTapCancel: () => setState(() => _isPressing = false),
              child: Stack(
                children: [
                  // Main card container
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        // Deep layered shadows for depth
                        BoxShadow(
                          color: _isHovered
                              ? primaryColor.withOpacity(0.1)
                              : Colors.black.withOpacity(0.03),
                          blurRadius: 25,
                          offset: Offset(0, 5),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: _isHovered
                              ? primaryColor.withOpacity(0.18)
                              : Colors.black.withOpacity(0.06),
                          blurRadius: _isHovered ? 40 : 15,
                          offset: Offset(0, _isHovered ? _elevationHeight : 10),
                          spreadRadius: _isHovered ? -5 : -2,
                        ),
                        BoxShadow(
                          color: _isHovered
                              ? primaryColor.withOpacity(0.05)
                              : Colors.transparent,
                          blurRadius: 60,
                          offset: Offset(0, _isHovered ? 30 : 0),
                          spreadRadius: -10,
                        ),
                        // Ultra-subtle inner light for 3D feel
                        BoxShadow(
                          color: _isHovered
                              ? Colors.white.withOpacity(0.15)
                              : Colors.transparent,
                          blurRadius: 20,
                          offset: const Offset(0, -8),
                          spreadRadius: -2,
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 0.65, 1.0],
                        colors: [
                          surfaceColor,
                          surfaceColor,
                          _isHovered
                              ? primaryColor.withOpacity(0.08)
                              : surfaceColor,
                        ],
                      ),
                      border: Border.all(
                        color: _isHovered
                            ? primaryColor.withOpacity(0.2)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Project Image with premium treatments
                        Stack(
                          children: [
                            // High-quality image treatment
                            Hero(
                              tag: 'project-${widget.title}',
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: ShaderMask(
                                  shaderCallback: (rect) {
                                    return LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black,
                                        Colors.black,
                                        Colors.black.withOpacity(0.8),
                                      ],
                                      stops: const [0.0, 0.8, 1.0],
                                    ).createShader(rect);
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: Image.asset(
                                    widget.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: primaryColor.withOpacity(0.1),
                                      child: Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 40,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Status indicator with pulse animation
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isHovered
                                      ? secondaryColor
                                      : primaryColor,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (_isHovered
                                              ? secondaryColor
                                              : primaryColor)
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Pulsing ring animation
                            if (_isHovered)
                              Positioned(
                                top: 20,
                                right: 20,
                                child: Container(
                                  width: 14 + (20 * _pulseController.value),
                                  height: 14 + (20 * _pulseController.value),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: secondaryColor.withOpacity(
                                          0.5 - (0.5 * _pulseController.value)),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),

                            // Premium badge
                            Positioned(
                              top: 20,
                              left: 20,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: Offset(0, 2),
                                      )
                                    ]),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Premium',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Ultra-premium image overlay with dynamic glass morphism
                            if (_isHovered)
                              Positioned.fill(
                                child: ClipRRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            primaryColor.withOpacity(0.2),
                                            Colors.black.withOpacity(0.7),
                                          ],
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          // Premium animated particles with dynamic glow
                                          ...List.generate(20, (index) {
                                            final random = math.Random();
                                            final size =
                                                random.nextDouble() * 8 + 3;
                                            final left =
                                                random.nextDouble() * 400;
                                            final top =
                                                random.nextDouble() * 180;
                                            final opacity =
                                                random.nextDouble() * 0.5 + 0.2;
                                            final particleColor = [
                                              primaryColor,
                                              secondaryColor,
                                              Colors.white,
                                            ][random.nextInt(3)];

                                            return Positioned(
                                              left: left,
                                              top: top,
                                              child: Container(
                                                width: size,
                                                height: size,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: particleColor
                                                      .withOpacity(opacity),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: particleColor
                                                          .withOpacity(
                                                              opacity * 0.7),
                                                      blurRadius: 10,
                                                      spreadRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                                .animate(
                                                  onPlay: (controller) =>
                                                      controller.repeat(
                                                          reverse: false),
                                                )
                                                .moveY(
                                                  begin: 0,
                                                  end: -(20 +
                                                      random.nextDouble() * 40),
                                                  duration: Duration(
                                                    milliseconds:
                                                        _particlesDuration
                                                                .inMilliseconds -
                                                            random
                                                                .nextInt(1000),
                                                  ),
                                                  curve: Curves.easeOutQuint,
                                                )
                                                .fadeIn(duration: 300.ms)
                                                .fadeOut(
                                                    begin: 1.0,
                                                    delay: 1500.ms);
                                          }),

                                          // Bottom glass panel
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            height: 60,
                                            child: ClipRRect(
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 5, sigmaY: 5),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.white
                                                            .withOpacity(0.0),
                                                        Colors.white
                                                            .withOpacity(0.1),
                                                      ],
                                                    ),
                                                    border: Border(
                                                      top: BorderSide(
                                                        color: Colors.white
                                                            .withOpacity(0.2),
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      // Stats section
                                                      _buildStatItem(
                                                          Icons
                                                              .visibility_outlined,
                                                          '2.4k'),
                                                      _buildStatItem(
                                                          Icons.favorite_border,
                                                          '480'),
                                                      _buildStatItem(
                                                          Icons.share_outlined,
                                                          '64'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Ultra-premium CTA button
                                          Center(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 36,
                                                      vertical: 18),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    primaryColor,
                                                    secondaryColor
                                                        .withOpacity(0.9),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: primaryColor
                                                        .withOpacity(0.5),
                                                    blurRadius: 25,
                                                    offset: const Offset(0, 8),
                                                    spreadRadius: 0,
                                                  ),
                                                  BoxShadow(
                                                    color: secondaryColor
                                                        .withOpacity(0.5),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 2),
                                                    spreadRadius: -5,
                                                  ),
                                                ],
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.visibility_rounded,
                                                    color: Colors.white,
                                                    size: 22,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  const Text(
                                                    'View Project',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                                .animate()
                                                .scale(
                                                  begin: const Offset(0.8, 0.8),
                                                  end: const Offset(1.0, 1.0),
                                                  duration: 600.ms,
                                                  curve: Curves.elasticOut,
                                                )
                                                .shimmer(
                                                  delay: 800.ms,
                                                  duration: 2200.ms,
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ).animate().fadeIn(duration: 300.ms),
                          ],
                        ),

                        // Project Info with luxury styling
                        Padding(
                          padding: EdgeInsets.all(isDesktop ? 36 : 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title section with badge and premium typography
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Project title with premium typography
                                        Text(
                                          widget.title,
                                          style: TextStyle(
                                            fontSize: isDesktop ? 28 : 24,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                            letterSpacing: -0.5,
                                            height: 1.2,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        // Animated luxury gradient underline
                                        Stack(
                                          children: [
                                            AnimatedContainer(
                                              duration: _hoverDuration,
                                              margin: const EdgeInsets.only(
                                                  top: 12, bottom: 24),
                                              height: 4,
                                              width: _isHovered ? 120 : 60,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    primaryColor,
                                                    secondaryColor,
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                boxShadow: _isHovered
                                                    ? [
                                                        BoxShadow(
                                                          color: primaryColor
                                                              .withOpacity(0.4),
                                                          blurRadius: 10,
                                                          offset: const Offset(
                                                              0, 2),
                                                          spreadRadius: -2,
                                                        ),
                                                      ]
                                                    : null,
                                              ),
                                            ),

                                            // Shimmer effect on the underline
                                            if (_isHovered)
                                              Positioned(
                                                top: 12,
                                                child: Container(
                                                  height: 4,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.white
                                                            .withOpacity(0),
                                                        Colors.white
                                                            .withOpacity(0.5),
                                                        Colors.white
                                                            .withOpacity(0),
                                                      ],
                                                      stops: [0.0, 0.5, 1.0],
                                                      begin: Alignment(
                                                          -1.0 +
                                                              (2.0 *
                                                                  _shimmerController
                                                                      .value),
                                                          0),
                                                      end: Alignment(
                                                          0 +
                                                              (2.0 *
                                                                  _shimmerController
                                                                      .value),
                                                          0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Premium action button
                                  AnimatedContainer(
                                    duration: _hoverDuration,
                                    padding:
                                        EdgeInsets.all(_isHovered ? 14 : 12),
                                    decoration: BoxDecoration(
                                      gradient: _isHovered
                                          ? LinearGradient(
                                              colors: [
                                                primaryColor,
                                                secondaryColor,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                      color: _isHovered
                                          ? null
                                          : primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: _isHovered
                                          ? [
                                              BoxShadow(
                                                color: primaryColor
                                                    .withOpacity(0.3),
                                                blurRadius: 15,
                                                offset: const Offset(0, 5),
                                                spreadRadius: -2,
                                              ),
                                            ]
                                          : null,
                                      border: Border.all(
                                        color: _isHovered
                                            ? Colors.white.withOpacity(0.3)
                                            : primaryColor.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.launch_rounded,
                                      color: _isHovered
                                          ? Colors.white
                                          : primaryColor,
                                      size: 22,
                                    ),
                                  ).animate(target: _isHovered ? 1 : 0).rotate(
                                        begin: 0,
                                        end: 0.125,
                                        duration: 500.ms,
                                        curve: Curves.easeOutBack,
                                      ),
                                ],
                              ),

                              // Description with premium typography
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: _isHovered ? 16 : 0,
                                  vertical: _isHovered ? 16 : 0,
                                ),
                                decoration: BoxDecoration(
                                  color: _isHovered
                                      ? primaryColor.withOpacity(0.03)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: _isHovered
                                      ? Border.all(
                                          color: primaryColor.withOpacity(0.1),
                                          width: 1,
                                        )
                                      : null,
                                ),
                                child: Text(
                                  widget.description,
                                  style: TextStyle(
                                    fontSize: isDesktop ? 16 : 14,
                                    color: textColor.withOpacity(0.8),
                                    height: 1.7,
                                    letterSpacing: 0.2,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Tech label with icon
                              if (_isHovered)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.device_hub_rounded,
                                        size: 18,
                                        color: textColor.withOpacity(0.6),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Technologies',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: textColor.withOpacity(0.7),
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ).animate().fadeIn(duration: 300.ms),
                                ),

                              // Luxury technology chips
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: widget.technologies
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key;
                                  final tech = entry.value;

                                  return AnimatedContainer(
                                    duration: _hoverDuration,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: _isHovered ? 16 : 14,
                                      vertical: _isHovered ? 10 : 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: _isHovered
                                          ? LinearGradient(
                                              colors: [
                                                primaryColor.withOpacity(0.12),
                                                secondaryColor
                                                    .withOpacity(0.12),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                      color: _isHovered
                                          ? null
                                          : primaryColor.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: _isHovered
                                          ? [
                                              BoxShadow(
                                                color: primaryColor
                                                    .withOpacity(0.15),
                                                blurRadius: 10,
                                                offset: const Offset(0, 3),
                                                spreadRadius: -2,
                                              ),
                                            ]
                                          : null,
                                      border: Border.all(
                                        color: _isHovered
                                            ? primaryColor.withOpacity(0.3)
                                            : primaryColor.withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Tech icon
                                        if (_isHovered) ...[
                                          Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: primaryColor
                                                  .withOpacity(0.15),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              _getTechIcon(tech),
                                              size: 14,
                                              color: primaryColor,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                        ],

                                        // Tech name
                                        Text(
                                          tech,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: primaryColor,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                      .animate(target: _isHovered ? 1 : 0)
                                      .moveY(
                                        begin: 0,
                                        end: -8,
                                        delay:
                                            Duration(milliseconds: index * 60),
                                        duration: 500.ms,
                                        curve: Curves.easeOutCubic,
                                      )
                                      .scale(
                                        begin: const Offset(1.0, 1.0),
                                        end: const Offset(1.05, 1.05),
                                        delay:
                                            Duration(milliseconds: index * 60),
                                        duration: 500.ms,
                                      );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Premium card effects
                  if (_isHovered) ...[
                    // Animated shimmer edge highlight for luxury feel
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),
                            border: Border.all(
                              color: Colors.transparent,
                              width: 2,
                            ),
                            gradient: LinearGradient(
                              begin: Alignment(
                                  -2 + 4 * _shimmerController.value,
                                  -2 + 4 * _shimmerController.value),
                              end: Alignment(2 - 4 * _shimmerController.value,
                                  2 - 4 * _shimmerController.value),
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.05),
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.05),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Luxury corner accents
                    ...List.generate(4, (index) {
                      // Calculate positioning for each corner
                      final isTop = index < 2;
                      final isLeft = index.isEven;

                      return Positioned(
                        top: isTop ? 0 : null,
                        bottom: !isTop ? 0 : null,
                        left: isLeft ? 0 : null,
                        right: !isLeft ? 0 : null,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment(
                                isLeft ? -0.5 : 0.5,
                                isTop ? -0.5 : 0.5,
                              ),
                              colors: [
                                primaryColor.withOpacity(0.2),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 1.0],
                              radius: 1.0,
                            ),
                          ),
                        ),
                      );
                    }),

                    // Premium floating dots decoration
                    ...List.generate(3, (index) {
                      final size = 8.0 - (index * 2.0);
                      final offset = 20.0 + (index * 15.0);
                      final opacity = 0.3 - (index * 0.1);

                      return Positioned(
                        bottom: offset,
                        right: offset,
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withOpacity(opacity),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(opacity * 0.5),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper method for stats items
  Widget _buildStatItem(IconData icon, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get tech icons
  IconData _getTechIcon(String tech) {
    switch (tech.toLowerCase()) {
      case 'flutter':
        return Icons.flutter_dash;
      case 'dart':
        return Icons.code;
      case 'firebase':
        return Icons.whatshot;
      case 'react':
        return Icons.sync;
      case 'laravel':
        return Icons.web;
      case 'mysql':
        return Icons.storage;
      case 'php':
        return Icons.php;
      case 'pdf generation':
        return Icons.picture_as_pdf;
      case 'ecommerce':
        return Icons.shopping_cart;
      case 'real-time features':
        return Icons.update;
      default:
        return Icons.code;
    }
  }
}
