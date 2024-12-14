import 'package:flutter/material.dart';

class ManProgressBar extends StatelessWidget {
  final double progress; // Progress percentage (0.0 to 1.0)

  const ManProgressBar({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Silhouette of a man (background)
        Image.asset(
          'assets/images/man.JPG', // Path to the man-shaped image
          color: Colors.grey.withOpacity(0.3), // Background color for the silhouette
        ),
        // Progress fill using ShaderMask
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Colors.blue, Colors.green],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [progress, progress],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Image.asset(
            'assets/images/man.JPG', // Same silhouette for masking
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: ManProgressBar(
          progress: 0.6, // Example: 60% filled
        ),
      ),
    ),
  ));
}