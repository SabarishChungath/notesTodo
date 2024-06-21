// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/screens/notes_list/bloc/notes_bloc.dart';

const reviewDuration = Duration(minutes: 6);

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();

    this._noteController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    this._noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (contet) => NotesBloc(),
      child: BlocBuilder<NotesBloc, NotesState>(
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
      ),
    );
  }

  showAddNotesDialog(TextEditingController controller, BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          var bottomPadding = MediaQuery.of(context).viewInsets.bottom;

          return Container(
            height: 200,
            padding: EdgeInsets.fromLTRB(16, 20, 16, 20 + bottomPadding),
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
                  decoration:
                      const InputDecoration(hintText: 'Enter your note'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<NotesBloc>().add(SaveNotes(
                          note: Note(
                            note: controller.text,
                            timeStamp: DateTime.now(),
                          ),
                        ));
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                )
              ],
            ),
          );
        });
  }

  Widget body(NotesState state) {
    if (state is NotesFinal) {
      return ListView.separated(
        itemCount: state.notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(state.notes[index].note),
            subtitle: getSubTitle(state, index),
          );
        },
        separatorBuilder: (_, __) {
          return const Divider(height: 1, color: Colors.black);
        },
      );
    }

    return const Center(child: Text('No notes found. Add some notes.'));
  }

  Widget getSubTitle(NotesFinal state, int index) {
    

    return Row(
      children: [
        Text(state.notes[index].timeStamp.toString()),
        const Spacer(),
        if (state.notes[index].showReview) ...{
          const Icon(Icons.notifications),
          const Padding(padding: EdgeInsets.only(left: 4), child: Text('Review note')),
        }
      ],
    );
  }
}
