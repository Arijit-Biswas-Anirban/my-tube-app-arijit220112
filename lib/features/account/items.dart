import 'package:flutter/material.dart';
import 'package:mytube/cores/widgets/image_item.dart';
import 'package:mytube/features/channel/my_channel/pages/channel_settings.dart';

class Items extends StatelessWidget {
  const Items({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 35,
            child: ImageItem(
              imageName: "your-channel.png",
              itemClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyChannelSettings()),
                );
              },
              itemText: "Your Channel",
              haveColor: false,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 34,
            child: ImageItem(
              imageName: "your-channel.png",
              itemClicked: () {},
              itemText: "Turn on Incognito",
              haveColor: false,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 34,
            child: ImageItem(
              imageName: "add-account.png",
              itemClicked: () {},
              itemText: "Add Account",
              haveColor: false,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 6, bottom: 6),
            child: Divider(
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(
            height: 35,
            child: ImageItem(
              imageName: "purchases.png",
              itemClicked: () {},
              itemText: "Purchases and Membership",
              haveColor: false,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 31,
            child: ImageItem(
              imageName: "time-watched.png",
              itemClicked: () {},
              itemText: "Time watched",
              haveColor: false,
            ),
          ),
          const SizedBox(height: 7),
          SizedBox(
            height: 31,
            child: ImageItem(
              imageName: "your-data.png",
              itemClicked: () {},
              itemText: "Your data in Youtube",
              haveColor: false,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 6, bottom: 6),
            child: Divider(
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(
            height: 33,
            child: ImageItem(
              imageName: "settings.png",
              itemClicked: () {},
              itemText: "Settings",
              haveColor: false,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 35,
            child: ImageItem(
              imageName: "help.png",
              itemClicked: () {},
              itemText: "Help & feedback",
              haveColor: false,
            ),
          ),
        ],
      ),
    );
  }
}
