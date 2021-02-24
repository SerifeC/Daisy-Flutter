import 'dart:io';
import 'package:daisy/core/utils/platform_responsive_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class PlatformResponsiveAlertDialog extends PlatformResponsiveWidget {
  final String title;
  final String desciption;
  final String mainButtonText;
  final String cancelButtonText;

  PlatformResponsiveAlertDialog(
      {@required this.title,
        @required this.desciption,
        @required this.mainButtonText,
        this.cancelButtonText});

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
        context: context, builder: (context) => this)
        : await showDialog<bool>(
        context: context,
        builder: (context) => this,
        barrierDismissible: false //user press outside cant canceled.
    );
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(desciption),
      actions: _setdialogButtons(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(desciption),
      actions: _setdialogButtons(context),
    );
  }

  List<Widget> _setdialogButtons(BuildContext context) {
    final allButtons = <Widget>[];

    if (Platform.isIOS) {
      if (cancelButtonText != null) {
        allButtons.add(
          CupertinoDialogAction(
            child: Text(cancelButtonText),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButtons.add(
        CupertinoDialogAction(
          child: Text(mainButtonText),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      if (cancelButtonText != null) {
        allButtons.add(
          FlatButton(
            child: Text(cancelButtonText),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButtons.add(
        FlatButton(
          child: Text("Okay"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    }

    return allButtons;
  }
}