import 'package:flutter/material.dart';

class PremiumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              "FitMentor",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Go Premium",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Upgrade to Premium for Expert Health Support!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Get direct access to certified doctors and nutritionists for personalized health advice. Enjoy consultations, tailored meal plans, and professional guidance on managing your health, all at your fingertips!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            Spacer(),
            PremiumOption(
              title: "12 Months",
              oldPrice: "US\$110.78",
              newPrice: "US\$70.78",
              perMonth: "US\$5",
              save: "SAVE 20%",
              isBestValue: true,
            ),
            SizedBox(height: 10),
            PremiumOption(
              title: "1 Month",
              oldPrice: null,
              newPrice: "US\$5.56",
              perMonth: "Build monthly",
              save: null,
              isBestValue: false,
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Add your action here
              },
              child: Text(
                "Continue",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class PremiumOption extends StatelessWidget {
  final String title;
  final String? oldPrice;
  final String newPrice;
  final String perMonth;
  final String? save;
  final bool isBestValue;

  const PremiumOption({
    required this.title,
    this.oldPrice,
    required this.newPrice,
    required this.perMonth,
    this.save,
    required this.isBestValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBestValue ? Colors.orange : Colors.grey[300]!,
          width: isBestValue ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBestValue)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "BEST VALUE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          if (oldPrice != null)
            Text(
              oldPrice!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          SizedBox(height: 4),
          Text(
            newPrice,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(
            perMonth,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          if (save != null)
            SizedBox(height: 8),
          if (save != null)
            Text(
              save!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
