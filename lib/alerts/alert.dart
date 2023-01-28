import 'package:flutter/cupertino.dart';

/// Shows alert with 1 action
showAlert1Action(BuildContext context, String title, String body,
    String actionText, Function()? onActionClicked) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            onActionClicked != null ? onActionClicked() : null;

            Navigator.pop(context);
          },
          child: Text(actionText),
        ),
      ],
    ),
  );
}

/// Shows alert with 2 actions
showAlert2Actions(
    BuildContext context,
    String title,
    String body,
    String positiveText,
    Function()? onPositiveClicked,
    String negativeText,
    Function()? onNegativeClicked) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            onNegativeClicked != null ? onNegativeClicked() : null;
            Navigator.pop(context);
          },
          child: Text(negativeText),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            onPositiveClicked != null ? onPositiveClicked() : null;
          },
          child: Text(positiveText),
        ),
      ],
    ),
  );
}
