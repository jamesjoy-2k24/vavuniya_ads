import 'package:flutter/material.dart';

class WelcomeScreenFeature extends StatelessWidget {
  const WelcomeScreenFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(50),
        children: [
          _buildFeatureItem(Icons.post_add, "Post Your Ads",
              "Easily create and manage ads to showcase your products and services."),
          _buildFeatureItem(Icons.search, "Browse and Search",
              "Find the best products and services quickly and easily."),
          _buildFeatureItem(Icons.person, "Personalized Experience",
              "Get recommendations based on your interests and needs."),
          _buildFeatureItem(Icons.lock, "Secure Transactions",
              "Your safety and privacy are our top priorities."),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 35, color: Colors.black),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
