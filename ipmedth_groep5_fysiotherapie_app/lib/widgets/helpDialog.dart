import 'package:flutter/material.dart';

class HelpDialog extends StatefulWidget {
  @override
  _HelpDialogState createState() => _HelpDialogState();
}

class _HelpDialogState extends State<HelpDialog> {
  int _currentPage = 0; // Tracks the current page

  final List<String> _explanations = [
    'Videos opnemen', // Page 1 text
    'Video controls', // Page 2 text
    'Analyse menu', // Page 3 text
  ];

  final List<String> _imagePaths = [
    'assets/images/uitleg1.png', // Vervang met je eigen afbeeldingen
    'assets/images/uitleg2.png',
    'assets/images/uitleg3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: EdgeInsets.all(
          MediaQuery.of(context).size.width * 0.05), // 5% padding
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _explanations[_currentPage], // Dynamische titel
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Image.asset(
                      _imagePaths[_currentPage],
                      fit: BoxFit.contain, // Zorgt dat de afbeelding goed past
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_imagePaths.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentPage == index ? Colors.black : Colors.grey,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _currentPage > 0
                          ? () {
                              setState(() {
                                _currentPage--;
                              });
                            }
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _currentPage < _imagePaths.length - 1
                          ? () {
                              setState(() {
                                _currentPage++;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Positioned Exit Icon in the top-right corner
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ),
        ],
      ),
    );
  }
}
