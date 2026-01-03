abstract class NavigationEvent {}

class ScrollToSection extends NavigationEvent {
  final int index;
  ScrollToSection(this.index);
}
