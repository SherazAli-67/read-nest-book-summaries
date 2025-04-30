import 'dart:math';
import 'package:flutter/material.dart';
import 'package:read_nest/src/features/onboarding/welcome_onboarding/onboarding_page3.dart';
import 'package:read_nest/src/res/app_colors.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
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

  Widget _buildRotatingCard(double angle, double radius, int index) {
    final double rad = angle * pi / 180;

    return Transform(
      transform: Matrix4.identity()
        ..translate(radius * cos(rad), radius * sin(rad)),
      child: Card(
        child: SizedBox(
          width: 70,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.asset('assets/icons/onboarding$index.png', fit: BoxFit.cover,),
          ),
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
                  List.generate(4, (index){
                    return Container(
                      height:  100 * (index+1),
                      width:  100 * (index+1),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryColor.withOpacity(0.1))
                      ),
                    );
                  }),
                ),
                Text(
                  'ESCAPE INTO \nWORLD OF WORDS',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    double rotationAngle = _rotationController.value * 360;

                    return Stack(
                      children: List.generate(6, (index) {
                        double angle = (360 / 6) * index + rotationAngle;
                        return _buildRotatingCard(angle, radius, index + 1);
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> OnboardingPageHolder()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: Text("LET'S GET STARTED", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600)),
                  )
              ),
            ),
        ],
      ),
    );
  }
}