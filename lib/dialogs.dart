import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

mixin DialogHelper {

  Widget _buildBaseDialogBody({required Widget child, required Widget logo}) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          ThemeData theme = Theme.of(context);
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: theme.colorScheme.background,
                      borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0, top: 60),
                    child: SizedBox(
                        width: 400, child: SingleChildScrollView(child: child)),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                child: Center(
                  child: logo,
                ),
              ),
            ],
          );
        }));
  }

  Future<bool?> showBaseConfirmationDialog(
      {required BuildContext context,
      required Widget body,
      String? positive,
      required Widget logo}) {
    return showGeneralDialog<bool?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Barrier",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, anim1, anim2) {
        return Container();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: anim1.value,
            child: _buildBaseDialogBody(
              logo: logo,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  body,
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (positive != null)...[
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48), // NEW
                            ),
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              Navigator.pop(context, true);
                            },
                            child: Text(positive),
                          ),
                        )
                      ]
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> showBaseDialog(
      {required BuildContext context,
        required Widget body,
        required Widget logo}) {
    return showGeneralDialog<dynamic?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Barrier",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, anim1, anim2) {
        return Container();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: anim1.value,
            child: _buildBaseDialogBody(
              logo: logo,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  body,
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  

}

mixin AppLogo {
  Widget buildAppLogo({double width = 100, double height = 100}) {
    return SizedBox(
        width: width,
        height: height,
        child: SvgPicture.asset(("assets/logos/logo1.svg")),
    );
  }
}
