import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget {
  ErrorDialog({Key? key, required this.errorText}) : super(key: key);

  String errorText;

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: contentBox(context),
    );
  }

  /*contentBox(context) {
    return Center(
      child: Stack(
        children: <Widget> [
          Container(
            color: Colors.green,
            //child: const Text(""),
          ),
        ],
      ),
    );
  }*/

  contentBox(context) {
    return Stack(
      children: <Widget> [
        Container(
          padding: const EdgeInsets.only(left: 20, top: 130, right: 20, bottom: 20),
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.height / 2,
          //color: Colors.green,
          /*decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15))
          ),*/
          child: Column(
            children: <Widget> [
              Text(widget.errorText, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
              //SizedBox(height: 15),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))
                  ),
                ],
              )

            ],
          ),
        ),
        /*const Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: Image(
                width: 60,
                height: 60,
                image: AssetImage('assets/errorIcon.png'),
            ),
        ),*/
        const Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: Icon(Icons.error, color: Colors.red, size: 85)
        ),
      ],
    );


    /*return Stack(
      children: <Widget> [
        Container(
          padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.height / 2,
          //color: Colors.green,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: const Text("123"),
        ),
        const Positioned(
            left: 20,
            right: 20,
            child: Icon(Icons.error, color: Colors.red, size: 85)
        ),
      ],
    );*/
  }

}
