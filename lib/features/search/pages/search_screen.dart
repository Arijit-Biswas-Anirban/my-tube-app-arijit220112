import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytube/cores/widgets/custom_button.dart';
import 'package:mytube/features/auth/model/user_model.dart';
import 'package:mytube/features/content/Long_video/parts/post.dart';
import 'package:mytube/features/search/providers/search_providers.dart';
import 'package:mytube/features/search/widgets/search_channel_tile_widget.dart';
import 'package:mytube/features/upload/long_video/video_model.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  List foundItems = [];

  Future<void> filterList(String keywordSelected) async {
    final usersAsyncValue = ref.watch(allChannelsProvider);
    final videosAsyncValue = ref.watch(allVideosProvider);

    // Check for loading or error states
    if (usersAsyncValue.isLoading || videosAsyncValue.isLoading) {
      return;  // Handle loading state if needed
    }
    if (usersAsyncValue.hasError || videosAsyncValue.hasError) {
      print("Error fetching data");
      return;  // Handle errors
    }

    final List<UserModel> users = usersAsyncValue.value ?? [];
    final List<VideoModel> videos = videosAsyncValue.value ?? [];

    List<dynamic> result = [];
    final foundChannels = users.where((user) {
      return user.displayName.toLowerCase().contains(keywordSelected.toLowerCase());
    }).toList();

    result.addAll(foundChannels);

    final foundVideos = videos.where((video) {
      return video.title.toLowerCase().contains(keywordSelected.toLowerCase());
    }).toList();

    result.addAll(foundVideos);

    setState(() {
      result.shuffle();
      foundItems = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(
                    height: 43,
                    width: 279,
                    child: TextFormField(
                      onChanged: (value) async {
                        await filterList(value);
                      },
                      decoration: InputDecoration(
                        hintText: "Search You Tube...",
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18),
                          ),
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18),
                          ),
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18),
                          ),
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xfff2f2f2),
                        contentPadding: const EdgeInsets.only(
                          left: 13,
                          bottom: 12,
                        ),
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 43,
                    width: 55,
                    child: CustomButton(
                      iconData: Icons.search,
                      onTap: () {},
                      haveColor: true,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: foundItems.length,
                  itemBuilder: (context, index) {
                    final selectedItem = foundItems[index];

                    if (selectedItem is VideoModel) {
                      return Post(video: selectedItem);
                    } else if (selectedItem is UserModel) {
                      return SearchChannelTile(user: selectedItem);
                    } else {
                      return const SizedBox.shrink();  // Return an empty widget if no match
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
