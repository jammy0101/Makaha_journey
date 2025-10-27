class StepItem {
  final int order;
  final String title;
  final String? subtitle;
  final String? extraNote;

  StepItem({
    required this.order,
    required this.title,
    this.subtitle,
    this.extraNote,
  });
}
