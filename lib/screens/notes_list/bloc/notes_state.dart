part of 'notes_bloc.dart';

sealed class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

final class NotesInitial extends NotesState {}

class NotesFinal extends NotesState {
  final List<Note> notes;
  final List<int> intervals;
  final int selectedInterval;

  const NotesFinal(
      {required this.notes,
      this.intervals = const [5, 10, 15],
      this.selectedInterval = 5});

  NotesFinal copyWith(
      {List<Note>? notes, List<int>? intervals, int? selectedInterval}) {
    return NotesFinal(
        notes: notes ?? this.notes,
        intervals: intervals ?? this.intervals,
        selectedInterval: selectedInterval ?? this.selectedInterval);
  }

  @override
  List<Object?> get props => [notes, intervals, selectedInterval];
}
