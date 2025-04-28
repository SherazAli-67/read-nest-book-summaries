import 'dart:math';
import 'package:flutter/material.dart';

class RotatingBooksScreen extends StatefulWidget {
  const RotatingBooksScreen({super.key});

  @override
  RotatingBooksScreenState createState() => RotatingBooksScreenState();
}

class RotatingBooksScreenState extends State<RotatingBooksScreen> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _buttonController;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();

    Future.delayed(Duration(seconds: 3), () {
      _rotationController.stop();
      setState(() {
        _showButton = true;
      });
      _buttonController.forward();
    });

    _buttonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Widget _buildRotatingCard(double angle, double radius, String label) {
    final double rad = angle * pi / 180;

    return Transform(
      transform: Matrix4.identity()
        ..translate(radius * cos(rad), radius * sin(rad)),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 75,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),

            color: Colors.deepPurpleAccent,
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double radius = 150.0; // distance from center

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [

          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children:
                  List.generate(5, (index){
                    return Container(
                      height:  100 * (index+1),
                      width:  100 * (index+1),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[200]!)
                      ),
                    );
                  }),
                ),
                Text(
                  'Escape into \nworld of words',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    double rotationAngle = _rotationController.value * 360;

                    return Stack(
                      children: List.generate(6, (index) {
                        double angle = (350 / 6) * index + rotationAngle;
                        return _buildRotatingCard(angle, radius, 'Book ${index + 1}');
                      }),
                    );
                  },
                ),
              ],
            ),
          ),

          if (_showButton)
            Positioned(
              bottom: 45,
              left: 25,
              right: 25,
              child: FadeTransition(
                  opacity: _buttonController,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to next screen
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: Text("Let's Get Started", style: TextStyle(fontSize: 18, color: Colors.white)),
                  )
              ),
            ),
        ],
      ),
    );
  }
}