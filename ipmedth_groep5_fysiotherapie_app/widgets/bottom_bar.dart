import 'package:flutter/material.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/views/tempLandingPage.dart';

class Bottom_bar extends StatelessWidget {
  const Bottom_bar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.15,
      child: BottomAppBar(
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.7, // Adjust the width as needed
                  child: Slider(
                    value: 0.5,
                    onChanged: (double value) {},
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.speed),
                  onPressed: () {},
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.skip_previous ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}