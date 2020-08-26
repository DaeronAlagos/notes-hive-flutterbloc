import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_hive/bloc/note_bloc.dart';

import '../widgets.dart';
import 'edit_note.dart';
import 'new_note.dart';

class NotesScreen extends StatelessWidget {
  final Color black = Color(0xFF1e2022);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
          padding: EdgeInsets.all(10),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return NewNote();
              }));
            },
            child: Icon(Icons.add),
          )),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0xFF49565e),
            title: Text(
              'Your Notes',
              style: TextStyle(color: Colors.white),
            ),
            expandedHeight: 250,
            floating: false,
            pinned: true,
            flexibleSpace: Container(),
          ),
          SliverPadding(padding: EdgeInsets.all(10)),
          BlocBuilder<NoteBloc, NoteState>(
            builder: (context, state) {
              if (state is NoteInitial) {
                return SliverList(
                    delegate: SliverChildListDelegate([Container()]));
              }
              if (state is YourNotesState) {
                return NoteGrid(state: state);
              }
              if (state is NotesLoading) {
                return SliverList(
                    delegate:
                        SliverChildListDelegate([Center(child: Container())]));
              } else {
                return SliverList(
                    delegate: SliverChildListDelegate([Container()]));
              }
            },
          ),
        ],
      ),
    );
  }
}

class NoteGrid extends StatelessWidget {
  const NoteGrid({Key key, this.state}) : super(key: key);
  final YourNotesState state;
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        final note = state.notes[index];
        return InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return EditNote(
                note: note,
                index: index,
              );
            }));
          },
          onLongPress: () {
            showDialog(
                context: context, child: AlertDialogRefactor(index: index));
          },
          child: NoteCard(
            title: note.title,
            content: note.content,
          ),
        );
      }, childCount: state.notes.length),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    );
  }
}

class AlertDialogRefactor extends StatelessWidget {
  const AlertDialogRefactor({Key key, this.index}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete?',
        style: TextStyle(color: Color(0xFF49565e)),
      ),
      actions: [
        FlatButton(
            child: Text(
              'YES',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              BlocProvider.of<NoteBloc>(context)
                  .add(NoteDeleteEvent(index: index));
              Navigator.pop(context);
            }),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'CANCEL',
              style: TextStyle(color: Color(0xFF49565e)),
            ))
      ],
    );
  }
}