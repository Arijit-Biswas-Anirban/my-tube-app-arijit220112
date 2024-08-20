import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytube/cores/screens/error_page.dart';
import 'package:mytube/cores/screens/loader.dart';
import 'package:mytube/features/auth/provider/user_provider.dart';
import 'package:mytube/features/channel/my_channel/repository/edit_fields.dart';
import 'package:mytube/features/channel/my_channel/widgets/edit_setting_dialog.dart';
import 'package:mytube/features/channel/my_channel/widgets/setting_field_item.dart';

class MyChannelSettings extends ConsumerStatefulWidget {
  const MyChannelSettings({super.key});

  @override
  ConsumerState<MyChannelSettings> createState() => _MyChannelSettingsState();
}

class _MyChannelSettingsState extends ConsumerState<MyChannelSettings> {
  bool isSwitched = false;
  bool isValidate = true;

  Future<void> validateUsername(String username) async {
    final usersMap = await FirebaseFirestore.instance.collection("users").get();
    final users = usersMap.docs.map((user) => user.data()["username"]).toList();

    setState(() {
      isValidate = !users.contains(username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(currentUserProvider).when(
      data: (user) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.asset(
                        "assets/images/my_channel_setting.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 15,
                      top: 115,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey,
                        backgroundImage: CachedNetworkImageProvider(user.profilePic),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: 15,
                      height: 30,
                      child: Image.asset(
                        "assets/icons/camera.png",
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SettingsItem(
                  identifier: "Name",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => SettingsDialog(
                        identifier: "Your New Display Name",
                        onSave: (name) {
                          ref.read(editSettingsProvider).editDisplayName(name);
                        },
                      ),
                    );
                  },
                  value: user.displayName,
                ),
                const SizedBox(height: 14),
                SettingsItem(
                  identifier: "Handle",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => _buildUsernameDialog(context, user.username),
                    );
                  },
                  value: user.username,
                ),
                const SizedBox(height: 14),
                SettingsItem(
                  identifier: "Description",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => SettingsDialog(
                        identifier: "Your New Description",
                        onSave: (description) {
                          ref.read(editSettingsProvider).editDescription(description);
                        },
                      ),
                    );
                  },
                  value: user.description,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Keep all my subscription private "),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    "Changes made on your names and profile pictures are visible only to my tube and not other Google Services",
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      error: (error, stackTrace) => const ErrorPage(),
      loading: () => const Loader(),
    );
  }

  Widget _buildUsernameDialog(BuildContext context, String currentUsername) {
    TextEditingController usernameController = TextEditingController();
    usernameController.text = currentUsername;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text("Your New User Name"),
          content: TextFormField(
            controller: usernameController,
            autovalidateMode: AutovalidateMode.always,
            decoration: InputDecoration(
              errorText: isValidate ? null : "Username already taken",
            ),
            onChanged: (username) async {
              await validateUsername(username);
              setState(() {});
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: isValidate
                  ? () {
                      ref.read(editSettingsProvider).editusername(usernameController.text);
                      Navigator.of(context).pop();
                    }
                  : null,
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
