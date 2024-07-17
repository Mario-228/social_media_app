import 'package:flutter/material.dart';

void navigateTo(BuildContext context, Widget screen) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => screen,
    ));

Widget defaultFormField(
        {required TextInputType type,
        TextEditingController? controller,
        bool isShown = false,
        IconData? prefixIconData,
        IconData? suffixIconData,
        String? Function(String?)? validatorFunction,
        required String label,
        void Function()? onPressed}) =>
    TextFormField(
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: isShown,
      decoration: InputDecoration(
          prefixIcon: Icon(prefixIconData),
          suffixIcon:
              IconButton(onPressed: onPressed, icon: Icon(suffixIconData)),
          label: Text(label),
          border: const OutlineInputBorder()),
      validator: validatorFunction,
    );

void navigateAndFinish(BuildContext context, Widget screen) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
      (route) => false,
    );

class DefaultButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final double textSize;
  final double height;
  const DefaultButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textSize = 18,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.primaryContainer,
      minWidth: double.infinity,
      height: height,
      child: Text(
        text,
        style: TextStyle(fontSize: textSize),
      ),
    );
  }
}

class DefaultFormField extends StatelessWidget {
  final String label;
  final IconData? prefixIcon;
  final TextInputType type;
  final IconData? suffixIcon;
  final void Function()? onPressed;
  final TextEditingController controller;
  final bool isPassword;
  final String onError;
  final bool autofocus;
  final String hintText;
  final bool isEnabled;
  final InputBorder border;
  const DefaultFormField(
      {super.key,
      required this.label,
      required this.prefixIcon,
      required this.type,
      this.suffixIcon,
      this.onPressed,
      required this.controller,
      required this.isPassword,
      required this.onError,
      this.autofocus = false,
      this.hintText = "",
      this.isEnabled = true,
      this.border=const OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(15.0)))
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      validator: (value) => value!.isEmpty ? onError : null,
      obscureText: isPassword,
      controller: controller,
      keyboardType: type,
      enabled: isEnabled,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
            const EdgeInsets.all(15.0), //used to set size for the text field
        prefixIcon: Icon(prefixIcon), // the package (icons ax)
        border: border,
        label: Text(label),
        suffixIcon: IconButton(icon: Icon(suffixIcon), onPressed: onPressed),
      ),
    );
  }
}
