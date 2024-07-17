import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_cubit/social_cubit.dart';
import 'package:social_app/cubit/social_cubit/social_states.dart';
import 'package:social_app/social_models/post_model.dart';
import 'package:social_app/social_models/user_model.dart';

class BuildPost extends StatelessWidget {
  final PostModel item;
  final UserModel user;
  final String postId;
  final int likesNumber;
  final int index;
  final bool? isLiked;
  const BuildPost({
    super.key,
    required this.item,
    required this.user,
    required this.postId,
    required this.likesNumber,
    this.isLiked,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state) {},
      builder:(context, state) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5.0,
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(item.image!),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(item.name!),
                            const SizedBox(
                              width: 5.0,
                            ),
                            const Icon(
                              Icons.check_circle,
                              size: 16.0,
                            )
                          ],
                        ),
                        Text(item.dateTime!,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_horiz,
                        size: 16.0,
                      ))
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Divider(),
              ),
              Text(
                item.text!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsetsDirectional.only(end: 6.0),
                        height: 25.0,
                        child: MaterialButton(
                          minWidth: 1.0,
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          child: Text(
                            "#SoftWare",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (item.postImage != "")
                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    image: DecorationImage(
                      image: NetworkImage(
                        item.postImage!,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (isLiked == null) {
                             SocialCubit.get(context).likePost(postId);
                          } else if (isLiked == true) {
                            SocialCubit.get(context).disLikePost(postId, index);
                          } else {
                            SocialCubit.get(context).likePost(postId);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              Icon(
                                (isLiked == null || isLiked == false)
                                    ? Icons.favorite_border
                                    : Icons.favorite,
                                color: Colors.red,
                                size: 16.0,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text("$likesNumber"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.comment,
                                color: Colors.amber,
                                size: 16.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text("0 comments"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Divider(),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18.0,
                            backgroundImage: NetworkImage(user.image!),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          Text("Write a comment ...",
                              style: Theme.of(context).textTheme.bodySmall)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                    onTap: () {
                      SocialCubit.get(context).likePost(postId);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                          size: 16.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text("Like"),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
