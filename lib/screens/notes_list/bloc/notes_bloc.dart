// ignore_for_file: unnecessary_this

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/models/note.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial()) {
    on<InitNotes>((event, emit) {
      this.initNotes(event, emit);
    });

    on<SaveNotes>((event, emit) {
      this.saveNotes(event, emit);
    });

    on<RemindForReview>((event, emit) async {
      await this.remindForReview(event, emit);
    });

    on<ChangeInterval>((event, emit) {
      this.changeInterval(event, emit);
    });
  }

  void initNotes(InitNotes event, Emitter<NotesState> emit) {
    emit(const NotesFinal(intervals: [5, 10, 15], notes: []));
  }

  void changeInterval(ChangeInterval event, Emitter<NotesState> emit) {
    if (state is NotesFinal) {
      var prevState = state as NotesFinal;
      emit(prevState.copyWith(selectedInterval: event.interval));
    }
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
    await Future.delayed(Duration(minutes: event.note.reviewDuration), () {
      if (state is NotesFinal) {
        var prevState = state as NotesFinal;
        List<Note> notes = List<Note>.from(prevState.notes);
        int index = notes.indexWhere((element) => element.id == event.note.id);
        if (index != -1) {
          var updatedNote =
              event.note.copyWith(reviewCount: event.note.reviewCount + 1);
          notes[index] = updatedNote;
          emit(prevState.copyWith(notes: notes));
          add(RemindForReview(note: updatedNote));
        } else {
          emit(NotesFinal(notes: [event.note]));
        }
      } else {
        emit(NotesFinal(notes: [event.note]));
      }
    });
  }
}
