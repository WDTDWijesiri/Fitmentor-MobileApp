import 'package:flutter/material.dart';

import 'DashboardScreen.dart';

class HealthScanScreen extends StatefulWidget {
  const HealthScanScreen({Key? key}) : super(key: key);

  @override
  _HealthScanScreenState createState() => _HealthScanScreenState();
}

class _HealthScanScreenState extends State<HealthScanScreen> {
  final Map<String, bool> uploadedReports = {
    "Blood Test Report": false,
    "Blood Pressure": false,
    "Urinalysis": false,
    "ECG": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              "AI Health Scan",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView(
                children: uploadedReports.keys.map((title) {
                  return buildReportTile(title, uploadedReports[title]!, context);
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle submit action
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManProgressBar(progress:0.6),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReportTile(String title, bool isUploaded, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        tileColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        leading: Icon(
          isUploaded ? Icons.check_circle : Icons.upload_file,
          color: isUploaded ? Colors.green : Colors.grey,
        ),
        title: Text(title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FileUploadScreen(
                reportType: title,
                onFileUploaded: () {
                  setState(() {
                    uploadedReports[title] = true;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class FileUploadScreen extends StatelessWidget {
  final String reportType;
  final VoidCallback onFileUploaded;

  const FileUploadScreen({
    Key? key,
    required this.reportType,
    required this.onFileUploaded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload $reportType"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              "AI Health Scan",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text(
                      "Drag & Drop file or ",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const Text(
                      "Browse",
                      style: TextStyle(color: Colors.blue),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Supported formats: JPEG, PNG, PDF",
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                onFileUploaded();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Upload File",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
