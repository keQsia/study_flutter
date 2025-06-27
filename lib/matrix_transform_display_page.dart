import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' as vector;

class MatrixTransformDisplayPage extends StatelessWidget {
  const MatrixTransformDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matrix4 变换演示',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MatrixPlayground(),
    );
  }
}

class MatrixPlayground extends StatefulWidget {
  const MatrixPlayground({super.key});

  @override
  State<MatrixPlayground> createState() => _MatrixPlaygroundState();
}

class _MatrixPlaygroundState extends State<MatrixPlayground> {
  double translateX = 0.0;
  double translateY = 0.0;
  double rotateX = 0.0;
  double rotateY = 0.0;
  double rotateZ = 0.0;
  double scale = 1.0;
  double scaleX = 1.0;
  double scaleY = 1.0;
  double perspective = 0.001;

  @override
  Widget build(BuildContext context) {
    // 创建变换矩阵
    final matrix = Matrix4.identity()
      ..translate(translateX, translateY)
      ..rotateX(rotateX)
      ..rotateY(rotateY)
      ..rotateZ(rotateZ)
      ..scale(scale)
      ..setDiagonal(vector.Vector4(scaleX, scaleY, 1.0, 1.0))
      ..setEntry(3, 2, perspective);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrix4 变换演示'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                translateX = 0.0;
                translateY = 0.0;
                rotateX = 0.0;
                rotateY = 0.0;
                rotateZ = 0.0;
                scale = 1.0;
                scaleX = 1.0;
                scaleY = 1.0;
                perspective = 0.001;
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Transform(
                transform: matrix,
                alignment: Alignment.center,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.transform, size: 60, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'Matrix4',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSlider('X轴平移: ${translateX.toStringAsFixed(1)}',
                        translateX, -200, 200, (value) {
                          setState(() => translateX = value);
                        }),
                    _buildSlider('Y轴平移: ${translateY.toStringAsFixed(1)}',
                        translateY, -200, 200, (value) {
                          setState(() => translateY = value);
                        }),
                    _buildSlider('X轴旋转: ${rotateX.toStringAsFixed(2)}',
                        rotateX, -math.pi, math.pi, (value) {
                          setState(() => rotateX = value);
                        }),
                    _buildSlider('Y轴旋转: ${rotateY.toStringAsFixed(2)}',
                        rotateY, -math.pi, math.pi, (value) {
                          setState(() => rotateY = value);
                        }),
                    _buildSlider('Z轴旋转: ${rotateZ.toStringAsFixed(2)}',
                        rotateZ, -math.pi, math.pi, (value) {
                          setState(() => rotateZ = value);
                        }),
                    _buildSlider('缩放: ${scale.toStringAsFixed(2)}',
                        scale, 0.1, 3.0, (value) {
                          setState(() => scale = value);
                        }),
                    _buildSlider('缩放X: ${scaleX.toStringAsFixed(2)}',
                        scale, 0.1, 3.0, (value) {
                          setState(() => scaleX = value);
                        }),
                    _buildSlider('缩放Y: ${scaleY.toStringAsFixed(2)}',
                        scale, 0.1, 3.0, (value) {
                          setState(() => scaleY = value);
                        }),
                    _buildSlider('透视: ${perspective.toStringAsFixed(4)}',
                        perspective, 0.0001, 0.01, (value) {
                          setState(() => perspective = value);
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}