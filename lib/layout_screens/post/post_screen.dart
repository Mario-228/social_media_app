import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_cubit/social_cubit.dart';
import 'package:social_app/cubit/social_cubit/social_states.dart';
import 'package:social_app/social_models/user_model.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController post = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        UserModel user = SocialCubit.get(context).user!;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Create Post"),
            actions: [
              TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (SocialCubit.get(context).postImage == null) {
                        SocialCubit.get(context).createPost(
                            dateTime: DateTime.now().toString(),
                            text: post.text);
                      } else {
                        SocialCubit.get(context).uploadPost(
                            dateTime: DateTime.now().toString(),
                            text: post.text);
                        if (state is SocialCreatPostLoadingState) {
                          SocialCubit.get(context).removePostImage();
                        }
                      }
                      post.text = "";
                    }
                  },
                  child: const Text("Post"))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if (state is SocialCreatPostLoadingState)
                    const LinearProgressIndicator(),
                  if (state is SocialCreatPostLoadingState)
                    const SizedBox(
                      height: 5.0,
                    ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(user.image!),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: Text(user.name!),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: post,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Write Something First";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "What Is On Your Mind ...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (SocialCubit.get(context).postImage != null)
                    Stack(alignment: Alignment.bottomCenter, children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: 150.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                image: DecorationImage(
                                  image: FileImage(
                                      SocialCubit.get(context).postImage!),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 20.0,
                              child: IconButton(
                                  onPressed: () => SocialCubit.get(context)
                                      .removePostImage(),
                                  icon: const Icon(
                                    Icons.close,
                                    size: 18.0,
                                  )),
                            )
                          ],
                        ),
                      )
                    ]),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                              onPressed: () =>
                                  SocialCubit.get(context).getPostImage(),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text("add photo")
                                ],
                              ))),
                      Expanded(
                          child: TextButton(
                              onPressed: () {}, child: const Text("# tags"))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
