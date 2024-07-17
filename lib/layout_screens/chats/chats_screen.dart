import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_cubit/social_cubit.dart';
import 'package:social_app/cubit/social_cubit/social_states.dart';
import 'package:social_app/layout_screens/chat_screen_details/chat_screen_details.dart';
import 'package:social_app/reusable_components/reusable_widgets.dart';
import 'package:social_app/social_models/user_model.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<UserModel> users = SocialCubit.get(context).users;
        return ConditionalBuilder(
          condition: state is! SocialGetAllUsersLoadingState,
          fallback:(context) => const Center(child: CircularProgressIndicator()),
          builder:(context) =>ConditionalBuilder(
            condition: users.isNotEmpty,
            fallback:(context) => Center(
                  child: CircleAvatar(
                radius: (MediaQuery.of(context).size.width * 0.2),
                child: const Text("No Data"),
              )),
            builder:(context) => Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: users.length,
                  separatorBuilder: (context, index) => const Divider(height: 0.0,),
                  itemBuilder: (context, index) => BuildChatItem(item: users[index]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BuildChatItem extends StatelessWidget {
  const BuildChatItem({
    super.key,
    required this.item,
  });

  final UserModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>navigateTo(context,ChatScreenDetails(model: item)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(item.image!),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Text(item.name!)
          ],
        ),
      ),
    );
  }
}
