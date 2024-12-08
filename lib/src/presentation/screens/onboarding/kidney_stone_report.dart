//kidney_stone_report.dart
import 'package:flutter/material.dart';

class KidneyStoneReportScreen extends StatefulWidget {
  final VoidCallback onSkip;
  final VoidCallback onBack;
  final Function(String reportPath) onSubmit;

  const KidneyStoneReportScreen({
    Key? key,
    required this.onSkip,
    required this.onBack,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _KidneyStoneReportScreenState createState() => _KidneyStoneReportScreenState();
}

class _KidneyStoneReportScreenState extends State<KidneyStoneReportScreen> {
  String? _selectedFilePath;

  void _showFileUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Choose how you want to upload your report:'),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Simulate camera/gallery selection
                  Navigator.of(context).pop();
                  _showSelectionConfirmation('Camera/Gallery');
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera/Gallery'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Simulate file selection
                  Navigator.of(context).pop();
                  _showSelectionConfirmation('Files');
                },
                icon: const Icon(Icons.file_upload),
                label: const Text('Files'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSelectionConfirmation(String source) {
    setState(() {
      // Simulate file path selection
      _selectedFilePath = 'mock_report_path_from_$source.pdf';
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Upload'),
          content: Text('File selected from $source:\n$_selectedFilePath'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                setState(() {
                  _selectedFilePath = null;
                });
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Upload'),
              onPressed: () {
                Navigator.of(context).pop();
                if (_selectedFilePath != null) {
                  // Call onSubmit with the selected file path
                  widget.onSubmit(_selectedFilePath!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Report uploaded from $source'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Do you have a kidney stone report?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.file_upload,
                      size: 60,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Upload your report below:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _showFileUploadDialog,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload Report'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        minimumSize: const Size(200, 50),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: widget.onSkip,
                child: const Text(
                  'No, Skip',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}