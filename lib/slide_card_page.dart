import 'package:flutter/material.dart';

class SlideCardPage extends StatefulWidget {
  const SlideCardPage({super.key});

  @override
  State<SlideCardPage> createState() =>
      _SlideCardPageState();
}

class _SlideCardPageState extends State<SlideCardPage> {
  double touchX = 0;
  double touchY = 0;
  bool startTransform = false;

  double cardWidth = 300;
  double cardHeight = 400;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("CardPerspectiveDemoPage")),
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.yellowAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(startTransform ? touchY : 0.0)
              ..rotateY(startTransform ? touchX : 0.0),
            alignment: FractionalOffset.center,
            child: GestureDetector(
              onTapUp: (_) => setState(() {
                startTransform = false;
              }),
              onPanCancel: () => setState(() => startTransform = false),
              onPanEnd: (_) => setState(() {
                startTransform = false;
              }),
              onPanUpdate: (details) {
                setState(() => startTransform = true);

                ///y轴限制范围
                if (details.localPosition.dx < cardWidth * 0.55 &&
                    details.localPosition.dx > cardWidth * 0.3) {
                  touchX = (cardWidth / 2 - details.localPosition.dx) / 100;
                }

                ///x轴限制范围
                if (details.localPosition.dy > cardHeight * 0.4 &&
                    details.localPosition.dy < cardHeight * 0.6) {
                  touchY = (details.localPosition.dy - cardHeight / 2) / 100;
                }
              },
              child: Container(
                width: cardWidth,
                height: cardHeight,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                      colors: [Colors.white, Color.fromARGB(255, 47, 153, 253)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 25,
                      spreadRadius: -25,
                      offset: Offset(0, 30),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/gsy_cat.png",
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: const Text(
                        "研发部",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/tuhu_logo.png",
                      width: 200,
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