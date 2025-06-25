import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double touchX = 0;
  double touchY = 0;
  double cardWidth = 300;
  double cardHeight = 400;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Transform(
          transform: Matrix4.identity()..rotateX(touchY)..rotateY(touchX),
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                if (details.localPosition.dx < cardWidth * 0.55 &&
                    details.localPosition.dx > cardWidth * 0.3) {
                  touchX = (cardWidth / 2 - details.localPosition.dx) / 100;
                }

                ///x轴限制范围
                if (details.localPosition.dy > cardHeight * 0.4 &&
                    details.localPosition.dy < cardHeight * 0.6) {
                  touchY = (details.localPosition.dy - cardHeight / 2) / 100;
                }
                // touchX = (cardWidth / 2 - details.localPosition.dx) / 180;
                // touchY = (details.localPosition.dy - cardHeight / 2) / 180;
              });
            },
            child: Container(
              width: cardWidth,
              height: cardHeight,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 47, 153, 253),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
