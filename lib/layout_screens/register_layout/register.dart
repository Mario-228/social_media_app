import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cache/cache.dart';
import 'package:social_app/cubit/social_register_cubit/register_cubit.dart';
import 'package:social_app/cubit/social_register_cubit/register_states.dart';
import 'package:social_app/layout_screens/social_layout/social_layout.dart';
import 'package:social_app/reusable_components/reusable_widgets.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is CreateUserSuccessfulState) {
            CacheHelper.saveData("uId", state.uId).then((value) {
              navigateAndFinish(context, const SocialLayout());
            });
          }
          // if(state is CreateUserSuccessfulState)
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "REGISTER",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24.0),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          "Register To communicate with friends",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            controller: nameController,
                            validatorFunction: (value) {
                              if (value!.isEmpty) {
                                return "Name Must Not Be Empty";
                              } else {
                                return null;
                              }
                            },
                            type: TextInputType.name,
                            label: "User Name",
                            prefixIconData: (Icons.person)),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          validatorFunction: (value) {
                            if (value!.isEmpty) {
                              return "Email Must Not Be Empty";
                            } else {
                              return null;
                            }
                          },
                          type: TextInputType.emailAddress,
                          label: "Email Address",
                          prefixIconData: (Icons.email),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                            controller: passController,
                            validatorFunction: (value) {
                              if (value!.isEmpty) {
                                return "Password Must Not Be Empty";
                              } else {
                                return null;
                              }
                            },
                            type: TextInputType.visiblePassword,
                            label: "Password",
                            prefixIconData: (Icons.lock_outline),
                            suffixIconData:
                                RegisterCubit.get(context).passwordIcon,
                            onPressed:
                                RegisterCubit.get(context).changeVisibility,
                            isShown: RegisterCubit.get(context).isShawn),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          validatorFunction: (value) {
                            if (value!.isEmpty) {
                              return "Phone Number Must Not Be Empty";
                            } else {
                              return null;
                            }
                          },
                          type: TextInputType.phone,
                          label: "Phone Number",
                          prefixIconData: (Icons.phone),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterUserLoadingState,
                          builder: (context) => MaterialButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                RegisterCubit.get(context).userRegister(
                                  nameController.text,
                                  emailController.text,
                                  passController.text,
                                  phoneController.text,
                                );
                              }
                            },
                            color: Colors.blue[400],
                            minWidth: double.infinity,
                            height: 50.0,
                            child: const Text(
                              "SIGN IN",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
