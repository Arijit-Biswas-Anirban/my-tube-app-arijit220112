import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytube/cores/colors.dart';
import 'package:mytube/cores/screens/error_page.dart';
import 'package:mytube/cores/screens/loader.dart';
import 'package:mytube/cores/widgets/image_button.dart';
import 'package:mytube/features/auth/provider/user_provider.dart';
import 'package:mytube/features/channel/my_channel/parts/tab_bar.dart';
import 'package:mytube/features/channel/my_channel/parts/tab_bar_view.dart';
import 'package:mytube/features/channel/my_channel/parts/top_header.dart';

import '../parts/buttons.dart';

class MyChannelScreen extends ConsumerWidget {
  const MyChannelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentUserProvider).when(
          data: (currentUser) => DefaultTabController(
            length: 7,
            child: Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      // Top header of User
                      TopHeader(user: currentUser),

                      const Text("More about this channel"),

                      // Buttons
                      Buttons(),

                      // Tab bar
                      PageTabBar(),

                      // Tab bar view
                      PageTabBarView(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          error: (error, stackTrace) => const ErrorPage(),
          loading: () => const Loader(),
        );
  }
}
