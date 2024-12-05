import 'package:flutter/material.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/views/tempLandingPage.dart';

class Sidebar_analyse extends StatelessWidget {
  const Sidebar_analyse({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Center(
          ),
        ),
        // Sidebar
        Container(
          width: MediaQuery.of(context).size.width * 0.15,
          color: Colors.black,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.15,
                color: Colors.black,
                child: Center(
                  child: IconButton(icon: const Icon(Icons.send_to_mobile_sharp ),
                   onPressed: () {},)
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    IconButton(icon: const Icon(
                      Icons.build_circle_outlined ),
                      onPressed: () {},),
                    IconButton(icon: const Icon(
                      Icons.zoom_in ),
                      onPressed: () {},),
                    IconButton(icon: const Icon(
                      Icons.zoom_out ),
                      onPressed: () {},),
                      
                  ],
                ),
              ),
            ],
          ),
        ),
        // Main Content
        
      ],
    );
  }
}