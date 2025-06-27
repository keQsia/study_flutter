import 'package:flutter/material.dart';
import 'package:study_flutter/slide_card_page.dart';
import 'dart:math' as math;

import 'matrix_transform_display_page.dart';

void main() => runApp(const MatrixApp());

class MatrixApp extends StatelessWidget {
  const MatrixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matrix4探索',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const WelcomePage(),
      routes: {
        '/matrix_transform': (context) => const MatrixTransformDisplayPage(),
        '/slide_card': (context) => const SlideCardPage(),
      },
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showButtons = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.forward().then((_) {
        setState(() => _showButtons = true);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToDemo(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.transform, size: 80, color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        "Matrix4探索",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Matrix4变换效果演示demo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedOpacity(
                      opacity: _showButtons ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: _buildTriangleButton(
                        direction: TriangleDirection.left,
                        onPressed: () => _navigateToDemo('/slide_card'),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _showButtons ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: _buildTriangleButton(
                        direction: TriangleDirection.right,
                        onPressed: () => _navigateToDemo('/matrix_transform'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTriangleButton({
    required TriangleDirection direction,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: direction == TriangleDirection.right
                ? Colors.amber
                : Colors.deepPurple[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomPaint(
              size: const Size(40, 40),
              painter: TrianglePainter(direction: direction),
            ),
          ),
        ),
      ),
    );
  }
}

enum TriangleDirection { left, right }

class TrianglePainter extends CustomPainter {
  final TriangleDirection direction;

  TrianglePainter({required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    if (direction == TriangleDirection.right) {
      path.moveTo(size.width * 0.2, size.height * 0.2);
      path.lineTo(size.width * 0.2, size.height * 0.8);
      path.lineTo(size.width * 0.8, size.height * 0.5);
    } else {
      path.moveTo(size.width * 0.8, size.height * 0.2);
      path.lineTo(size.width * 0.8, size.height * 0.8);
      path.lineTo(size.width * 0.2, size.height * 0.5);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MatrixDemoPage extends StatelessWidget {
  const MatrixDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('矩阵变换演示'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              transform: Matrix4.identity()
                ..rotateZ(math.pi / 6)
                ..scale(1.5),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 3,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "矩阵变换演示页面",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "这里可以展示各种Matrix4变换效果，包括旋转、缩放、倾斜、透视等。",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "开始探索",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}