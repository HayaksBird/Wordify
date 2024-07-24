import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';

class WordifyOverlayEntry extends StatelessWidget {
  final List<DoAction> inputs;
  final Offset position;
  final OverlayEntry overlayEntry;
  final VoidCallback? onOverlayClosed;


  const WordifyOverlayEntry({
    super.key,
    required this.inputs,
    required this.position,
    required this.overlayEntry,
    this.onOverlayClosed,
  });


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final overlayHeight = 4.0 + (inputs.length * 48.0); //Approximation
    //Height from the cursor to the end
    final availableHeight = screenHeight - position.dy;
    // Adjust the vertical position if necessary
    final adjustedPositionDy = availableHeight < overlayHeight
        ? position.dy - (overlayHeight - availableHeight)
        : position.dy - 4;


    return GestureDetector(
      onTap: () {
        overlayEntry.remove();
        onOverlayClosed?.call();
      },
      onSecondaryTap: () {
        overlayEntry.remove();
        onOverlayClosed?.call();
      },
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          Positioned(
            left: position.dx,
            top: adjustedPositionDy,
            child: ClipRRect( //Overlay frame
              borderRadius: BorderRadius.circular(10),
              child: Container( //Overlay frame color
                color: AppColors.overlay,
                child: Material(
                  type: MaterialType.transparency, // Ensure the material itself doesn't interfere
                  child: IntrinsicWidth(
                    child: Container( //Vertical space between overlay elements and the frame
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: inputs.map((input) {
                          return Container( //Overlay entry
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: HoverHighlight(
                                onTap: () {
                                  overlayEntry.remove();
                                  input.action();
                                  onOverlayClosed?.call();
                                },
                                child: _row(input)
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  ///Overlay entry widget
  Widget _row(DoAction input) {
    return Row(
      children: [                  
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(
            input.icon,
            color: input.color,
            size: 22
          ),
        ),
    
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              input.title,
              style: TextStyle(
                color: input.color,
                fontSize: 14
              )
            )
          ),
        ),
    
        const SizedBox(width: 16.0)
      ]
    );
  }
}



///Highlight the hovered text with.
class HoverHighlight extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const HoverHighlight({
    required this.child,
    required this.onTap,
    super.key,
  });

  @override
  State<HoverHighlight> createState() => _HoverHighlightState();
}

class _HoverHighlightState extends State<HoverHighlight> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHovered = true;
      }),
      onExit: (_) => setState(() {
        _isHovered = false;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          color: _isHovered ? AppColors.overlayHovered : Colors.transparent, // Change color on hover
          child: widget.child,
        ),
      ),
    );
  }
}



///
class DoAction {
  final String title;
  final Function action;
  final IconData icon;
  final Color color;

  const DoAction({
    required this.title,
    required this.action,
    required this.icon,
    required this.color
  });
}