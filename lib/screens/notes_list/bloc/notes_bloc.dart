// ignore_for_file: unnecessary_this

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/models/note.dart';

part 'notes_event.dart';
part 'notes_state.dart';

const reviewDuration = Duration(minutes: 1);

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial()) {
    on<SaveNotes>((event, emit) {
      this.saveNotes(event, emit);
    });

    on<RemindForReview>((event, emit) async {
      await this.remindForReview(event, emit);
    });
  }

  void saveNotes(SaveNotes event, Emitter<NotesState> emit) {
    if (state is NotesFinal) {
      var prevState = state as NotesFinal;
      List<Note> notes = List<Note>.from(prevState.notes);
      notes.add(event.note);
      emit(NotesFinal(notes: notes));
      add(RemindForReview(note: event.note));
    } else {
      emit(NotesFinal(notes: [event.note]));
    }
  }

  Future<void> remindForReview(
      RemindForReview event, Emitter<NotesState> emit) async {
    await Future.delayed(reviewDuration, () {
      if (state is NotesFinal) {
        var prevState = state as NotesFinal;
        List<Note> notes = List<Note>.from(prevState.notes);
        int index = notes.indexWhere((element) => element == event.note);
        if (index != -1) {
          notes[index] = event.note.copyWith(showReview: true);
          emit(NotesFinal(notes: notes));
        } else {
          emit(NotesFinal(notes: [event.note]));
        }
      } else {
        emit(NotesFinal(notes: [event.note]));
      }
    });
  }
}
