part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class SaveNotes extends NotesEvent {
  final Note note;

  const SaveNotes({required this.note});
}

class RemindForReview extends NotesEvent {
  final Note note;

  const RemindForReview({required this.note});
}
