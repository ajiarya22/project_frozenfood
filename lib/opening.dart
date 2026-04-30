import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF8088B8),
      ),
      home: const Scaffold(
        body: SplashScreenAdmin(),
      ),
    );
  }
}

class SplashScreenAdmin extends StatefulWidget {
  const SplashScreenAdmin({super.key});

  @override
  State<SplashScreenAdmin> createState() => _SplashScreenAdminState();
}

class _SplashScreenAdminState extends State<SplashScreenAdmin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // mulai agak turun
      end: Offset.zero,            // berhenti di posisi normal
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward(); // jalankan animasi
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final logoWidth = screenWidth * 0.6;

        return Stack(
          children: [
            // Background ungu-biru
            Positioned.fill(
              child: Container(
                color: Colors.white,
              ),
            ),

            // Wave putih di bawah
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipPath(
                clipper: _WaveClipper(),
                child: Container(
                  height: screenHeight * 0.58,
                  color: const Color(0xFF8088B8),
                ),
              ),
            ),

            // Logo dengan animasi fade + slide
            Positioned(
              left: 0,
              right: 0,
              bottom: screenHeight * 0.22,
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Image.asset(
                      'assets/logo_frozen_food.png',
                      width: logoWidth,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.28);

    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.08,
      size.width * 0.5, size.height * 0.15,
    );
    path.quadraticBezierTo(
      size.width * 0.78, size.height * 0.23,
      size.width, size.height * 0.10,
    );

    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) => false;
}
