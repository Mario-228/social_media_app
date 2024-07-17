import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_cubit/social_cubit.dart';
import 'package:social_app/cubit/social_cubit/social_states.dart';
import 'package:social_app/reusable_components/chat_message.dart';
import 'package:social_app/social_models/user_model.dart';

class ChatScreenDetails extends StatelessWidget {
  final UserModel model;
  const ChatScreenDetails({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessages(model.uId!);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          GlobalKey<FormState> formKey = GlobalKey<FormState>();
          TextEditingController message = TextEditingController();
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(model.image!),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(model.name!),
                ],
              ),
            ),
            body: ConditionalBuilder(
              condition: SocialCubit.get(context).messages.isNotEmpty,
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
              builder: (context) => Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (SocialCubit.get(context)
                                      .messages[index]
                                      .senderId ==
                                  FirebaseAuth.instance.currentUser!.uid) {
                                return BuildSenderMessage(
                                  model:
                                      SocialCubit.get(context).messages[index],
                                );
                              } else {
                                return BuildReceiverMessage(
                                  model:
                                      SocialCubit.get(context).messages[index],
                                );
                              }
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10.0),
                            itemCount:
                                SocialCubit.get(context).messages.length),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: message,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "message must not be empty";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  hintText: "Write Your Message Here...",
                                  border: InputBorder.none),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  SocialCubit.get(context).sendMessage(
                                      model.uId!,
                                      message.text,
                                      DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString());
                                  message.text = "";
                                }
                              },
                              icon: const Icon(Icons.send))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
