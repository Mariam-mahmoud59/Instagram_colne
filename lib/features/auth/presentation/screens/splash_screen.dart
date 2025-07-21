import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _textAnimationController;
  late AnimationController _loadingAnimationController;
  
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _logoSlideAnimation;
  
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<Offset> _textSlideAnimation;
  
  late Animation<double> _loadingFadeAnimation;
  late Animation<double> _loadingScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Logo Animation Controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Text Animation Controller
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Loading Animation Controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo Animations
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    // Text Animations
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _textScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    // Loading Animations
    _loadingFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeIn,
    ));

    _loadingScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.elasticOut,
    ));

    // Start animations with delays
    _startAnimations();
  }

  void _startAnimations() async {
    // Start logo animation immediately
    _logoAnimationController.forward();
    
    // Start text animation after 500ms
    await Future.delayed(const Duration(milliseconds: 500));
    _textAnimationController.forward();
    
    // Start loading animation after 1200ms
    await Future.delayed(const Duration(milliseconds: 700));
    _loadingAnimationController.forward();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  Widget _buildInstagramLogo() {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return SlideTransition(
          position: _logoSlideAnimation,
          child: FadeTransition(
            opacity: _logoFadeAnimation,
            child: ScaleTransition(
              scale: _logoScaleAnimation,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF405DE6),
                      Color(0xFF5851DB),
                      Color(0xFF833AB4),
                      Color(0xFFC13584),
                      Color(0xFFE1306C),
                      Color(0xFFFD1D1D),
                      Color(0xFFF56040),
                      Color(0xFFF77737),
                      Color(0xFFFCAF45),
                      Color(0xFFFFDC80),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE1306C).withOpacity(0.4),
                      spreadRadius: 0,
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: const Color(0xFF833AB4).withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstagramText() {
    return AnimatedBuilder(
      animation: _textAnimationController,
      builder: (context, child) {
        return SlideTransition(
          position: _textSlideAnimation,
          child: FadeTransition(
            opacity: _textFadeAnimation,
            child: ScaleTransition(
              scale: _textScaleAnimation,
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF405DE6),
                    Color(0xFF833AB4),
                    Color(0xFFE1306C),
                    Color(0xFFF56040),
                    Color(0xFFFCAF45),
                  ],
                ).createShader(bounds),
                child: const Text(
                  'Instagram',
                  style: TextStyle(
                    fontFamily: 'Billabong',
                    fontSize: 64,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return AnimatedBuilder(
      animation: _textAnimationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _textAnimationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          )),
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: _textAnimationController,
              curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
            )),
            child: const Text(
              'Clone',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Color(0xFF8E8E8E),
                letterSpacing: 2.0,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _loadingAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _loadingFadeAnimation,
          child: ScaleTransition(
            scale: _loadingScaleAnimation,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF405DE6),
                    Color(0xFF833AB4),
                    Color(0xFFE1306C),
                    Color(0xFFF56040),
                  ],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPulsingDots() {
    return AnimatedBuilder(
      animation: _loadingAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _loadingFadeAnimation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _loadingAnimationController,
                builder: (context, child) {
                  final delay = index * 0.2;
                  final animation = Tween<double>(
                    begin: 0.4,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: _loadingAnimationController,
                    curve: Interval(
                      delay,
                      0.8 + delay,
                      curve: Curves.easeInOut,
                    ),
                  ));
                  
                  return Transform.scale(
                    scale: animation.value,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0095F6).withOpacity(animation.value),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFAFAFA),
              Colors.white,
              Color(0xFFFAFAFA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Instagram Camera Icon
                    _buildInstagramLogo(),
                    
                    const SizedBox(height: 32),
                    
                    // Instagram Text
                    _buildInstagramText(),
                    
                    const SizedBox(height: 8),
                    
                    // Subtitle
                    _buildSubtitle(),
                    
                    const SizedBox(height: 80),
                    
                    // Loading Indicator
                    _buildLoadingIndicator(),
                    
                    const SizedBox(height: 24),
                    
                    // Pulsing Dots
                    _buildPulsingDots(),
                  ],
                ),
              ),
              
              // Bottom Section
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: AnimatedBuilder(
                  animation: _loadingAnimationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(CurvedAnimation(
                        parent: _loadingAnimationController,
                        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                      )),
                      child: Column(
                        children: [
                          const Text(
                            'from',
                            style: TextStyle(
                              color: Color(0xFF8E8E8E),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF405DE6),
                                Color(0xFFE1306C),
                                Color(0xFFF56040),
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'Meta',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}