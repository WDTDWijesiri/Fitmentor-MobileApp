import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'SignUP.dart'; // Import the SignIn page

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/food.jpg', // Path to the background image
            fit: BoxFit.cover, // Cover the entire screen
            height: double.infinity, // Full height
            width: double.infinity, // Full width
          ),
          // Overlay to darken the background image
          Container(
            color: Colors.black.withOpacity(0.3), // Dark overlay for better text visibility
          ),
          // Centered content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the column vertically
              children: [
                // Logo
                Image.asset(
                  'assets/logo.png', // Path to the logo image
                  height: 200, // Logo height
                  width: 200, // Logo width
                ),
                const SizedBox(height: 20), // Space after the logo
                // Welcome text
                const Text(
                  'Welcome To',
                  style: TextStyle(
                    color: Colors.white, // White text color
                    fontSize: 45, // Font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
                const SizedBox(height: 10), // Space between texts
                // App name
                const Text(
                  'FitMentor',
                  style: TextStyle(
                    color: Colors.white, // White text color
                    fontSize: 45, // Font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
                const SizedBox(height: 30), // Space before button
                // Reduced-width Get Started button
                SizedBox(
                  width: 200, // Set the desired button width here
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to SignIn page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Button background color
                      padding: const EdgeInsets.symmetric(
                        vertical: 15, // Vertical padding
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18, // Font size for button text
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the button content
                      children: [
                        // Button text
                        Text(
                          'Get Started',
                          style: TextStyle(color: Colors.white), // White text color
                        ),
                        // Arrow icon
                        Icon(
                          Icons.arrow_forward, // Arrow icon
                          color: Colors.white, // White icon color
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space before prompt
                // Prompt for existing users with Sign In button in one line
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.white, // White text color
                        fontSize: 16, // Font size
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to SignIn page when "Sign In" is pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignIn()),
                        );
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.orange, // Orange text color for Sign In
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
