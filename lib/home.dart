/// Home page widget

import 'package:flutter/cupertino.dart';
import 'package:get_fit/alerts/alert.dart';
import 'package:get_fit/helper/local_storage.dart';
import 'package:get_fit/helper/stats.dart';
import 'package:get_fit/text/bottom_home_text.dart';

import 'camera/image_preview.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  // Path of image taken by user
  final String imagePath;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _skipped = "";
  String _donated = "";
  String _owed = "";

  /// Load skipped, donated, and owed stats from storage
  loadStats() {
    getFromStorage('skipped').then((skipped) {
      setState(() {
        _skipped = skipped ?? "0";
      });
    });
    getFromStorage('donated').then((donated) {
      setState(() {
        _donated = donated ?? "0.00";
      });
    });
    getFromStorage('owed').then((owed) {
      setState(() {
        _owed = owed ?? "0.00";
      });
    });
  }

  onDonatePressed() async {
    await showAlert2Actions(
        context, "Confirm Donation", "\nDid you donate \$$_owed?", "Yes",
        () async {
      Navigator.pop(context);
      showAlert2Actions(
          context,
          "DON'T LIE TO ME",
          "\nDid you REALLY donate \$$_owed?",
          "I swear",
          () async {
            Navigator.pop(context);
            await payPayment();
            await loadStats();
          },
          "My bad",
          () async {
            await increaseOwed();
            await loadStats();
          });
    }, "No", () => {});
  }

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image user took
        ImagePreview(imagePath: widget.imagePath),
        // Stats
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(
              "Days skipped: $_skipped days",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Amount Donated: \$$_donated",
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            "Amount Owed: \$$_owed",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // Donation button
        _owed != "0.00" && _owed != ""
            ? Padding(
                padding: const EdgeInsets.only(top: 40),
                child: CupertinoButton(
                  color: CupertinoColors.white,
                  child: const Text(
                    "I Donated",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    await onDonatePressed();
                  },
                ),
              )
            : const SizedBox.shrink(),
        BottomHomeText(isSkipped: widget.imagePath == ""),
      ],
    );
  }
}
