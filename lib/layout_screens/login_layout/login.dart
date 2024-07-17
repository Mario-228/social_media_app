import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cache/cache.dart';
import 'package:social_app/cubit/social_login_cubit/login_cubit.dart';
import 'package:social_app/cubit/social_login_cubit/login_state.dart';
import 'package:social_app/layout_screens/register_layout/register.dart';
import 'package:social_app/layout_screens/social_layout/social_layout.dart';

import '../../reusable_components/reusable_widgets.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    var form = GlobalKey<FormState>();
    TextEditingController email = TextEditingController();
    TextEditingController pass = TextEditingController();
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is LoginFailedState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
          if (state is LoginSuccessfulState) {
            CacheHelper.saveData(
              "uId",state.uId
            ).then((value) {
              navigateAndFinish(context,const SocialLayout());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Form(
                key: form,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "LOGIN",
                          style: TextStyle(
                              fontSize: 40.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          "login now to communicate with friends",
                          style: TextStyle(fontSize: 20.0, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          type: TextInputType.text,
                          controller: email,
                          prefixIconData: Icons.email,
                          validatorFunction: (value) {
                            if (value!.isEmpty) {
                              return "Email must not be empty";
                            } else {
                              return null;
                            }
                          },
                          label: "Email",
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          type: TextInputType.visiblePassword,
                          controller: pass,
                          isShown: SocialLoginCubit.get(context).isShown,
                          prefixIconData: Icons.password,
                          suffixIconData:
                              SocialLoginCubit.get(context).passwordIcon,
                          validatorFunction: (value) {
                            if (value!.isEmpty) {
                              return "Password must not be empty";
                            } else {
                              return null;
                            }
                          },
                          label: "Password",
                          onPressed:
                              SocialLoginCubit.get(context).changeVisibility,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => MaterialButton(
                            onPressed: () {
                              if (form.currentState!.validate()) {
                                SocialLoginCubit.get(context)
                                    .login(email.text, pass.text);
                              }
                            },
                            color: Colors.blue[400],
                            minWidth: double.infinity,
                            height: 50.0,
                            child: const Text(
                              "LOGIN",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't Have An Account?",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            ),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, const Register());
                                },
                                child: const Text("REGISTER NOW.",
                                    style: TextStyle(fontSize: 18.0))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
