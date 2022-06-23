// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/src/presenters/home_presenter.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> implements HomeViewContract {
  late HomePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
          animation: _presenter.state,
          builder: (context, child) =>
              _presenter.stateManagment(_presenter.state.value)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/note');
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    _presenter = HomePresenter(this);
  }

  @override
  start() {
    final uid = _presenter.getUserUid();

    _presenter.notes = FirebaseFirestore.instance
        .collection('notes')
        .where('user_uid', isEqualTo: uid)
        .orderBy('date', descending: true);

    return StreamBuilder(
        stream: _presenter.notes.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 36,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PopupMenuButton(
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () async {
                                  _presenter.signOut();
                                },
                                value: 0,
                                child: Text(
                                  'home.exit'.tr(),
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  'home.switch-lang'.tr(),
                                ),
                                onTap: () {
                                  Future.delayed(
                                    const Duration(seconds: 0),
                                    () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                Text("home.choose-lang".tr()),
                                            actions: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Column(children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .black),
                                                      ),
                                                      onPressed: () {
                                                        context.setLocale(
                                                            const Locale(
                                                                'pt', 'BR'));
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                          'home.ptBr'.tr(),
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xffaff7ad))),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .black),
                                                      ),
                                                      onPressed: () {
                                                        context.setLocale(
                                                            const Locale(
                                                                'en', 'US'));
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                          'home.enUs'.tr(),
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xffaff7ad))),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ],
                                          );
                                        }),
                                  );
                                },
                              ),
                            ])
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: (streamSnapshot.data!.docs.isNotEmpty)
                        ? ListView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];

                              var date = DateTime.fromMillisecondsSinceEpoch(
                                  documentSnapshot['date'].seconds * 1000);

                              return GestureDetector(
                                onTap: () {
                                  _presenter.titleController.text =
                                      documentSnapshot['title'];
                                  _presenter.contentController.text =
                                      documentSnapshot['content'];
                                  _presenter.setDocId(documentSnapshot.id);
                                  _presenter.state.value = HomeState.update;
                                },
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 24),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          documentSnapshot['title'],
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xffaff7ad)),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          documentSnapshot['content'],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          "${date.day}/${date.month}/${date.year}",
                                          style: const TextStyle(
                                            color: Colors.white60,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            padding: const EdgeInsets.only(top: 24),
                            alignment: Alignment.topCenter,
                            child: Text('home.notesError'.tr(),
                                style: const TextStyle(
                                  fontSize: 24,
                                )),
                          ),
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  loading() {
    return Center(
        child: _presenter.isLoading
            ? const CircularProgressIndicator()
            : Container());
  }

  @override
  isLoadingChange() {
    setState(() {});
  }

  @override
  success() {
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  @override
  error() {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
            ),
            onPressed: () {
              _presenter.state.value = HomeState.start;
            },
            child: Text('login.try-again'.tr(),
                style: const TextStyle(color: Color(0xffaff7ad))),
          ),
        ),
      ),
    );
  }

  @override
  exit() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  updateView([DocumentSnapshot? documentSnapshot]) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    _presenter.state.value = HomeState.start;
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        _presenter.update();
                      },
                      icon: const Icon(Icons.edit),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        _presenter.delete();
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            autofocus: true,
            cursorColor: const Color(0xFFaff7ad),
            style: const TextStyle(
                color: Color(0xffaff7ad),
                fontSize: 24,
                fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              hintText: 'note.title'.tr(),
              border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: const TextStyle(
                fontSize: 24,
                color: Colors.white54,
                fontWeight: FontWeight.normal,
              ),
            ),
            controller: _presenter.titleController,
          ),
          TextField(
            controller: _presenter.contentController,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            cursorColor: Colors.white,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'note.message'.tr(),
                hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.white54,
                    fontWeight: FontWeight.normal)),
          )
        ]),
      ),
    );
  }
}
