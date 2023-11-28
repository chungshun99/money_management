import 'package:flutter/material.dart';

class ProgressDialog extends StatefulWidget {
  const ProgressDialog({Key? key}) : super(key: key);

  @override
  State<ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Center(
      child: Stack(
        children: const <Widget> [
          CircularProgressIndicator(
            //value: controller.value,
            color: Colors.lightGreenAccent,
            semanticsLabel: 'Circular progress indicator',
            strokeWidth: 4,
          ),
        ],
      ),
    );
  }
}
