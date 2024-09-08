import 'package:flutter/material.dart';
import 'package:mytube/cores/widgets/flat_button.dart';

class ShortVideoDetailsPage extends StatefulWidget {
  const ShortVideoDetailsPage({super.key});

  @override
  State<ShortVideoDetailsPage> createState() => _ShortVideoDetailsPageState();
}

class _ShortVideoDetailsPageState extends State<ShortVideoDetailsPage> {
  final captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Video Details",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: captionController,
                  decoration: const InputDecoration(
                    hintText: "Write a caption",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: FlatButton(
                    text: "Publish",
                    onPressed: () {},
                    colour: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
