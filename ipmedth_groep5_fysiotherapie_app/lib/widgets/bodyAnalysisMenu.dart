import 'package:flutter/material.dart';

class BodyAnalysisMenu extends StatefulWidget {
  @override
  _BodyAnalysisMenuState createState() => _BodyAnalysisMenuState();
}

class _BodyAnalysisMenuState extends State<BodyAnalysisMenu>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      isOpen = !isOpen;
      if (isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 30,
          right: 30,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              _buildOption(Icons.color_lens, 0),
              _buildOption(Icons.camera, 1),
              _buildOption(Icons.zoom_in, 2),
              FloatingActionButton(
                onPressed: _toggleMenu,
                child: Icon(Icons.settings),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOption(IconData icon, int index) {
    final double angle = index * 45.0;
    final double rad = angle * (3.1415926535897932 / 180.0);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset.fromDirection(
              rad - 3.1415926535897932, _animation.value * 100),
          child: Transform.scale(
            scale: _animation.value,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {},
              child: Icon(icon),
            ),
          ),
        );
      },
    );
  }
}
