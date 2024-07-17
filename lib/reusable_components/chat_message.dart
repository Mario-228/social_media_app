import 'package:flutter/material.dart';
import 'package:social_app/social_models/message_model.dart';

class BuildSenderMessage extends StatelessWidget {
  final MessageModel model;
  const BuildSenderMessage({
    super.key, required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10.0),
            topStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
          ),
        ),
        child:  Text(model.text!),
      ),
    );
  }
}

class BuildReceiverMessage extends StatelessWidget {
  final MessageModel model;
  const BuildReceiverMessage({
    super.key, required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
            ),
            color: Colors.grey[300]),
        child: Text(model.text!),
      ),
    );
  }
}