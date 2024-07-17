import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_cubit/social_cubit.dart';
import 'package:social_app/cubit/social_cubit/social_states.dart';
import 'package:social_app/reusable_components/reusable_widgets.dart';
import 'package:social_app/social_models/user_model.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();
    TextEditingController bio = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        UserModel userModel = SocialCubit.get(context).user!;
        name.text = userModel.name!;
        phone.text = userModel.phone!;
        bio.text = userModel.bio!;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edit Profile"),
            actions: [
              TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      SocialCubit.get(context).updateUserData(
                          name: name.text, phone: phone.text, bio: bio.text);
                    }
                  },
                  child: const Text("Update"))
            ],
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if (state is SocialUpdateUserDataLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 200.0,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  height: 150.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                    image: DecorationImage(
                                      image: (SocialCubit.get(context)
                                                  .coverImage ==
                                              null)
                                          ? NetworkImage(userModel.cover!)
                                          : FileImage(SocialCubit.get(context)
                                                  .coverImage!)
                                              as ImageProvider<Object>,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 20.0,
                                  child: IconButton(
                                      onPressed: () => SocialCubit.get(context)
                                          .getCoverImage(),
                                      icon: const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 18.0,
                                      )),
                                )
                              ],
                            ),
                          ),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                radius: 64.0,
                                child: CircleAvatar(
                                    radius: 60.0,
                                    // ignore: unnecessary_null_comparison
                                    backgroundImage: (SocialCubit.get(context)
                                                .profileImage ==
                                            null)
                                        ? NetworkImage(
                                            userModel.image!,
                                          )
                                        : FileImage(SocialCubit.get(context)
                                                .profileImage!)
                                            as ImageProvider<Object>?),
                              ),
                              CircleAvatar(
                                radius: 20.0,
                                child: IconButton(
                                    onPressed: () => SocialCubit.get(context)
                                        .getProfileImage(),
                                    icon: const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 18.0,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (SocialCubit.get(context).coverImage != null ||
                        SocialCubit.get(context).profileImage != null)
                      const SizedBox(
                        height: 15.0,
                      ),
                    if (SocialCubit.get(context).coverImage != null ||
                        SocialCubit.get(context).profileImage != null)
                      Row(
                        children: [
                          if (SocialCubit.get(context).profileImage != null)
                            Expanded(
                                child: DefaultButton(
                              text: "Upload Profile",
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  SocialCubit.get(context).uploadProfileImage(
                                      name: name.text,
                                      phone: phone.text,
                                      bio: bio.text);
                                }
                              },
                              height: 30.0,
                            )),
                          if (SocialCubit.get(context).coverImage != null &&
                              SocialCubit.get(context).profileImage != null)
                            const SizedBox(
                              width: 15.0,
                            ),
                          if (SocialCubit.get(context).coverImage != null)
                            Expanded(
                                child: DefaultButton(
                              text: "Upload Cover",
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  SocialCubit.get(context).uploadCoverImage(
                                      name: name.text,
                                      phone: phone.text,
                                      bio: bio.text);
                                }
                              },
                              height: 30.0,
                            )),
                        ],
                      ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    DefaultFormField(
                        label: "Name",
                        prefixIcon: Icons.person_outline,
                        type: TextInputType.name,
                        controller: name,
                        isPassword: false,
                        onError: "Name Must Not Be Empty"),
                    const SizedBox(
                      height: 15.0,
                    ),
                    DefaultFormField(
                        label: "phone",
                        prefixIcon: Icons.call,
                        type: TextInputType.number,
                        controller: phone,
                        isPassword: false,
                        onError: "phone Must Not Be Empty"),
                    const SizedBox(
                      height: 15.0,
                    ),
                    DefaultFormField(
                        label: "bio",
                        prefixIcon: Icons.info_outline,
                        type: TextInputType.name,
                        controller: bio,
                        isPassword: false,
                        onError: "Bio Must Not Be Empty"),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
