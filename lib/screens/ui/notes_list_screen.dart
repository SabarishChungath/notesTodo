// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/screens/notes_list/bloc/notes_bloc.dart';
import 'package:uuid/uuid.dart';

const reviewDuration = Duration(minutes: 6);

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  late TextEditingController _noteController;
  late NotesBloc notesBloc;

  @override
  void initState() {
    super.initState();

    this._noteController = TextEditingController();
    this.notesBloc = context.read<NotesBloc>();
    this.notesBloc.add(InitNotes());
  }

  @override
  void dispose() {
    super.dispose();
    this._noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Notes',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  this._noteController.clear();
                  showAddNotesDialog(this._noteController, context);
                },
              )
            ],
          ),
          body: SafeArea(
            child: Container(
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
              child: body(state),
            ),
          ),
        );
      },
    );
  }

  showAddNotesDialog(TextEditingController controller, BuildContext context) {
    var state = context.read<NotesBloc>().state;

    if (state is NotesFinal) {
      showModalBottomSheet(
          context: context,
          builder: (_) {
            var bottomPadding = MediaQuery.of(context).viewInsets.bottom;

            return BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                if (state is NotesFinal) {
                  return Container(
                    height: 300,
                    padding:
                        EdgeInsets.fromLTRB(16, 20, 16, 20 + bottomPadding),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                              hintText: 'Enter your note'),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  alignment: WrapAlignment.center,
                                  children: state.intervals.map((interval) {
                                    return GestureDetector(
                                      onTap: () {
                                        this.notesBloc.add(
                                            ChangeInterval(interval: interval));
                                      },
                                      child: ChoiceChip(
                                          selected: state.selectedInterval ==
                                              interval,
                                          label: Text('$interval Mins')),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Text(
                                  'Remind to review notes every ${state.selectedInterval} minutes on creation.',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  if (controller.text.isEmpty) {
                                    return;
                                  }
                                  var uuid = const Uuid();
                                  String notesId = uuid.v1();

                                  this.notesBloc.add(SaveNotes(
                                        note: Note(
                                          id: notesId,
                                          note: controller.text,
                                          reviewDuration: state.selectedInterval,
                                          timeStamp: DateTime.now(),
                                        ),
                                      ));
                                  Navigator.pop(context);
                                },
                                child: const SizedBox(
                                    width: double.infinity,
                                    child:
                                        Center(child: Text('Create note +'))),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }

                return const SizedBox();
              },
            );
          });
    }
  }

  Widget body(NotesState state) {
    if (state is NotesFinal) {
      if (state.notes.isEmpty) {
        return const Center(child: Text('No notes found. Add some notes.'));
      }

      return ListView.separated(
        itemCount: state.notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Text(state.notes[index].note.isEmpty
                    ? 'Empty note'
                    : state.notes[index].note),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 4, 0),
                  child: Icon(Icons.alarm, size: 18),
                ),
                Text('${state.notes[index].reviewDuration} mins')
              ],
            ),
            subtitle: getSubTitle(state, index),
          );
        },
        separatorBuilder: (_, __) {
          return  Divider(height: 1, color: Colors.grey.withOpacity(0.5));
        },
      );
    }

    return const SizedBox();
  }

  Widget getSubTitle(NotesFinal state, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Row(
        children: [
          Text(DateFormat.yMd().add_Hm().format(state.notes[index].timeStamp)),
          const Spacer(),
          if (state.notes[index].reviewCount > 0) ...{
            const Icon(Icons.notifications),
            Padding(
                padding: const EdgeInsets.only(left: 4),
                child:
                    Text('${state.notes[index].reviewCount} pending review')),
          }
        ],
      ),
    );
  }
}
