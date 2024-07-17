import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_cubit/social_cubit.dart';
import 'package:social_app/cubit/social_cubit/social_states.dart';
import 'package:social_app/layout_screens/post/post_screen.dart';
import 'package:social_app/reusable_components/reusable_widgets.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is SocialAddPostState)
        {
          navigateTo(context,const PostScreen());
        }
      },
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.notifications)),
              IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              items: const[
                BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.chat),label: "Chats"),
                BottomNavigationBarItem(icon: Icon(Icons.post_add),label: "Post"),
                BottomNavigationBarItem(icon: Icon(Icons.location_on),label: "Users"),
                BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Settings"),
              ],
              onTap: (value) => cubit.changeIndex(value),
              type:BottomNavigationBarType.fixed,
              currentIndex: (cubit.currentIndex>=2)? cubit.currentIndex+1 : cubit.currentIndex,
              ),
        );
      },
    );
  }
}
