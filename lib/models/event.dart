class Event {
  final String title; // Titre de l'événement
  final DateTime startTime; // Heure de début
  final DateTime endTime;   // Heure de fin
  final String description; // Description optionnelle

  Event({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.description = '',
  });
}
