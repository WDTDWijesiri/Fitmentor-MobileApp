import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WaterScreen extends StatefulWidget {
  @override
  _WaterScreenState createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  int waterIntake = 0; // Initial water intake in ml
  int glassValue = 200; // Value for a single glass (200 ml)
  int totalGoal = 2000; // Example goal: 2000 ml of water intake

  // Track water consumption at specific times of the day
  Map<String, int> timeSlots = {
    '4 AM': 0,
    '8 AM': 0,
    '12 PM': 0,
    '4 PM': 0,
    '8 PM': 0,
    '12 AM': 0,
  };

  void updateWaterIntake(String timeSlot, int value) {
    setState(() {
      // Update water intake for the given time slot
      timeSlots[timeSlot] = (timeSlots[timeSlot] ?? 0) + value;
      waterIntake += value; // Update total water intake
    });
  }

  @override
  Widget build(BuildContext context) {
    // Convert time slots and their corresponding water intake into BarChart data
    List<BarChartGroupData> barGroups = timeSlots.entries.map((entry) {
      return BarChartGroupData(
        x: timeSlots.keys.toList().indexOf(entry.key), // Map time to x-axis
        barRods: [
          BarChartRodData(
            y: (entry.value / glassValue).toDouble(), // Number of glasses consumed
            width: 25,
            colors: [Colors.blue],
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back_ios),
                Column(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.green),
                    Text(
                      'Today',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Text(
                  '$waterIntake ml',
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const Text(
                  'Total Water Intake',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (double value) {
                        // Map x-axis index to time slot
                        List<String> timeLabels = ['4 AM', '8 AM', '12 PM', '4 PM', '8 PM', '12 AM'];
                        return timeLabels[value.toInt()];
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => updateWaterIntake('4 AM', glassValue ~/ 2),
                  child: const Column(
                    children: [
                      Icon(Icons.local_drink, size: 48, color: Colors.blue),
                      Text('1/2 glass'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => updateWaterIntake('8 AM', glassValue),
                  child: Column(
                    children: [
                      Icon(Icons.local_drink, size: 48, color: Colors.blue[700]),
                      const Text('Glass'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => updateWaterIntake('12 PM', glassValue * 2),
                  child: Column(
                    children: [
                      Icon(Icons.local_drink, size: 48, color: Colors.blue[900]),
                      const Text('Bottle'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: WaterScreen()));
