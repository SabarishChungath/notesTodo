class Note {
  final String note;
  final bool showReview;
  final DateTime timeStamp;

  Note({required this.note, required this.timeStamp, this.showReview = false});

  Note copyWith({String? note, DateTime? timeStamp, bool? showReview}) {
    return Note(
      note: note ?? this.note,
      timeStamp: timeStamp ?? this.timeStamp,
      showReview: showReview ?? this.showReview,
    );
  }
}
