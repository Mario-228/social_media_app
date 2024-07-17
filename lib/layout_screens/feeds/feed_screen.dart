import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_cubit/social_cubit.dart';
import 'package:social_app/cubit/social_cubit/social_states.dart';
import 'package:social_app/reusable_components/build_post.dart';
import 'package:social_app/social_models/post_model.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getLikeState();
        SocialCubit.get(context).getPosts();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            List<PostModel> posts = SocialCubit.get(context).posts;
            return Scaffold(
              body: ConditionalBuilder(
                condition: (state is! SocialGetPostsLoadingState) &&
                    (SocialCubit.get(context).user != null),
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator()),
                builder: (context) => ConditionalBuilder(
                  condition: SocialCubit.get(context).posts.isNotEmpty,
                  fallback: (context) => Center(
                      child: CircleAvatar(
                    radius: (MediaQuery.of(context).size.width * 0.2),
                    child: const Text("No Data"),
                  )),
                  builder: (context) => SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 5.0,
                          margin: EdgeInsets.all(10.0),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Image(
                                image: NetworkImage(
                                  "https://img.freepik.com/free-photo/satisfied-student-posing-against-pink-wall_273609-20219.jpg?t=st=1718964594~exp=1718968194~hmac=1684f296fac30c1beae0da11f0a152676af3617917f4274f69d6ec864819986d&w=996",
                                ),
                                fit: BoxFit.cover,
                                height: 200.0,
                                width: double.infinity,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Communicate With Friends"),
                              )
                            ],
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return BuildPost(
                            item: posts[index],
                            user: SocialCubit.get(context).user!,
                            postId: SocialCubit.get(context).postsId[index],
                            likesNumber:
                                SocialCubit.get(context).likesNumber[index],
                            index: index,
                            isLiked:true
                          );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 5.0,
                          ),
                          itemCount: posts.length,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }
}
