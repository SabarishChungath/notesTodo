// ignore_for_file: unnecessary_this

class Note {
  final String id;
  final String note;
  final int reviewCount;
  final DateTime timeStamp;
  final int
      reviewDuration; //Time in mins after the notes review needs to be reminded

  Note({
    required this.id,
    required this.note,
    required this.timeStamp,
    this.reviewCount = 0,
    this.reviewDuration = 5,
  });

  Note copyWith(
      {String? note,
      DateTime? timeStamp,
      int? reviewCount,
      int? reviewDuration}) {
    return Note(
      id: this.id,
      note: note ?? this.note,
      timeStamp: timeStamp ?? this.timeStamp,
      reviewCount: reviewCount ?? this.reviewCount,
      reviewDuration: reviewDuration ?? this.reviewDuration,
    );
  }
}
