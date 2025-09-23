class GestureHandler {
  final void Function(String reason) onLose;

  GestureHandler({required this.onLose});

  void onTap() => onLose("You tapped.");
  void onDoubleTap() => onLose("You double tapped.");
  void onLongPress() => onLose("You pressed too long.");
  void onPanStart() => onLose("You started to move.");
  void onPanUpdate() => onLose("You moved.");
  void onVerticalDragStart() => onLose("Vertical drag detected.");
  void onHorizontalDragStart() => onLose("Horizontal drag detected.");
  void onScaleStart() => onLose("You pinched or rotated.");
  void onSecondaryTap() => onLose("Secondary tap (two fingers).");
  void onTertiaryTap() => onLose("Tertiary tap (three fingers).");
}
