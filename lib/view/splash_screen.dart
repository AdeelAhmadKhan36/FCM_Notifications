import 'dart:ui';

import 'package:fcm_notification_app/view/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fcm_notification_app/utils/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Declaring the animation controller
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initializing the animation controller with a duration of 7 seconds
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 7));
    // Listen for animation status changes
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigate to MovieListView when animation completes
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomeScreen()));
      }
    });
    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    // Dispose of the animation controller
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'Assets/Images/image notification.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              // Handle errors loading the image
              Utils().toastMessage('Unable to load image');
              // Display text if image fails to load
              return const Center(child: Text('Image not found'));
            },
          ),
          BackdropFilter(
            // Apply a blur effect
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              // Overlay with a semi-transparent black color
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return ClipOval(
                      // Clip the avatar into a circular shape
                      clipper: CircleClipper(_animationController.value),
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.white,
                        backgroundImage: const AssetImage('Assets/Images/icon+not.png'),
                        onBackgroundImageError: (error, stackTrace) {
                          // Handled errors loading the avatar image
                          Utils().toastMessage('Unable to load image');
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome to',
                      style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Opacity(
                          // Animate opacity based on controller value
                          opacity: _animationController.value,
                          child: AnimatedTextKit(
                            animatedTexts: [
                              WavyAnimatedText(
                                'FCM Notifications App', // Animated text
                                textStyle: const TextStyle(color: Colors.white, fontSize: 30),
                              ),
                            ],
                            // Repeat the animation indefinitely
                            repeatForever: true,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 130.0),
                const SpinKitWave(
                  color: Colors.white,
                  size: 40,
                  duration: Duration(seconds: 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Rect> {
  // Progress of the animation
  final double progress;
  // Constructor to initialize progress
  CircleClipper(this.progress);

  @override
  Rect getClip(Size size) {
    // Center of the clipping circle
    final center = Offset(size.width / 2, size.height / 2);
    // Radius of the clipping circle based on progress
    final radius = size.width * 0.5 * progress;
    // Create a circular clipping rectangle
    final rect = Rect.fromCircle(center: center, radius: radius);
    return rect;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
