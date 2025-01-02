import 'package:flutter/material.dart';

class MyAnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          "My Analysis",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {},
                ),
                Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "~ Your Health Trends at a Glance ~",
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Quick Stats Bar",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildStatBar("Calories Consumed", 10, Colors.blue),
            _buildStatBar("Weight Progress", 50, Colors.green),
            _buildStatBar("Water Intake", 85, Colors.pink),
            SizedBox(height: 20),
            Text(
              "Progress Visualization",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildVisualizationTile("Weight Trend Graph", Icons.show_chart),
            _buildVisualizationTile("Calories Intake Breakdown", Icons.pie_chart),
            _buildVisualizationTile("Water Intake", Icons.local_drink),
            SizedBox(height: 20),
            Text(
              "Insights and New Recommendations",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildInsightTile(
              "Personalized Insights",
              "You're on track to meet your weight goal!",
            ),
            _buildInsightTile(
              "New Recommendations",
              "You're on track to meet your weight goal!You're on track to meet your weight goal!",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar(String title, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: Colors.black)),
            Text("${progress.toInt()}%", style: TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
        SizedBox(height: 5),
        LinearProgressIndicator(
          value: progress / 100,
          color: color,
          backgroundColor: Colors.grey[300],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildVisualizationTile(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightTile(String title, String description) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
