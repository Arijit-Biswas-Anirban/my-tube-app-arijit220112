import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytube/cores/widgets/flat_button.dart';
import 'package:mytube/features/auth/repository/user_data_service.dart';

final formKey = GlobalKey<FormState>();

class UsernamePage extends ConsumerStatefulWidget {
  final String displayName;
  final String profilepic;
  final String email;
  const UsernamePage(
      {required this.displayName,
      required this.profilepic,
      required this.email});

  @override
  ConsumerState<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends ConsumerState<UsernamePage> {
  final TextEditingController usernameController = TextEditingController();
  bool isValidate = true;
  void validateUsername() async {
    final usersMap = await FirebaseFirestore.instance.collection("user").get();
    final users = usersMap.docs.map((user) => user).toList();
    String? targatedUsername;
    for (var user in users) {
      if (usernameController.text == user.data()["username"]) {
        targatedUsername = user.data()["username"];
        isValidate = false;
        setState(() {});
      }
      if (usernameController.text != targatedUsername) {
        isValidate = true;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 27,
                horizontal: 14,
              ),
              child: Text(
                "Enter the username",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Form(
                child: TextFormField(
                  onChanged: (username) {
                    validateUsername();
                  },
                  autovalidateMode: AutovalidateMode.always,
                  validator: (username) {
                    return isValidate ? null : "This username is already taken";
                  },
                  key: formKey,
                  controller: usernameController,
                  decoration: InputDecoration(
                    suffixIcon: isValidate
                        ? const Icon(Icons.verified_user_rounded)
                        : const Icon(Icons.cancel),
                    suffixIconColor: isValidate ? Colors.green : Colors.red,
                    hintText: "Insert username",
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0, left: 7, right: 7),
              child: FlatButton(
                text: "Continue",
                onPressed: () async {
                  // adding user data in database
                  isValidate
                      ? await ref
                          .read(userDataServiceProvider)
                          .addUserDataToFirestore(
                              displayName: widget.displayName,
                              username: usernameController.text,
                              email: widget.email,
                              description: "",
                              profilePic: widget.profilepic)
                      : null;
                },
                colour: isValidate ? Colors.green : Colors.green.shade100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
