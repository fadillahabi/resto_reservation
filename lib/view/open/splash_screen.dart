import 'package:flutter/material.dart';
import 'package:ppkd_flutter/view/open/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _assetsPrecached = false;

  void changePage() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        WelcomeScreen.id,
        (route) => false,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
    changePage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_assetsPrecached) {
      precacheImage(
        const AssetImage('assets/images/background_splash.jpg'),
        context,
      );
      precacheImage(const AssetImage('assets/images/logo2.png'), context);
      _assetsPrecached = true;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox(
            height: size.height,
            width: size.width,
            child: Image.asset(
              'assets/images/background_splash.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Overlay
          Container(color: Colors.black.withOpacity(0.5)),

          // Logo (fade-in)
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                'assets/images/logo2.png',
                width: size.width * 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
