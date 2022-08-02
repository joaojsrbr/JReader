import 'package:A.N.R/app/core/themes/colors.dart';
import 'package:flutter/material.dart';

class ToInfoButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  final Function()? onPressed;

  const ToInfoButton({
    required this.text,
    this.isLoading = false,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(color: CustomColors.primary),
          ),
          const SizedBox(width: 8),
          SizedBox(
            child: isLoading
                ? Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.only(left: 5),
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const RotatedBox(
                    quarterTurns: 90,
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: CustomColors.primary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
