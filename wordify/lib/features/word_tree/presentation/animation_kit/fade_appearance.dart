import 'package:flutter/material.dart';

///Add a fade-in & fade-out appearance to a widget that can appear/disappear
///depending on the isVisible param
class FadeAppearance extends StatefulWidget {
  final bool isVisible;
  final Widget child;

  const FadeAppearance({
    super.key,
    required this.isVisible,
    required this.child,
  });

  @override
  State<FadeAppearance> createState() => _FadeAppearanceState();
}

class _FadeAppearanceState extends State<FadeAppearance> with SingleTickerProviderStateMixin {
  //Controls the timing and progress of the animation
  late AnimationController _controller;
  //Defines how the animation values change over time, specifically the opacity for the fade effect
  late Animation<double> _fadeAnimation;
  bool _isAnimationRunning = false;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 170),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    ///Update the _isAnimationRunning based on the animation status.
    ///If the animation has reached the beginning (made a circle) then change
    ///the animation status to false.
    ///If the animation is in progress then change the animation status to true
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _isAnimationRunning = false;
        });
      } else if (status == AnimationStatus.forward) {
        setState(() {
          _isAnimationRunning = true;
        });
      }
    });

    if (widget.isVisible) {
      _controller.forward();
    }
  }


  ///If isVisible param is updated then either fade-in or fade-out
  @override
  void didUpdateWidget(covariant FadeAppearance oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (!_isAnimationRunning) {
      return Container();
    } else {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      );
    }
  }
}