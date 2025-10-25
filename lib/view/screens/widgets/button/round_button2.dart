// import 'package:flutter/material.dart';
//
// class RoundButton2 extends StatelessWidget {
//   final double width;
//   final double height;
//   final bool loading;
//   final String? title;
//   final VoidCallback onPress;
//   final Color textColor;
//   final Color buttonColor2;
//   final Widget? child;
//
//   const RoundButton2({
//     super.key,
//     required this.width,
//     required this.height,
//     required this.loading,
//     this.title,
//     required this.onPress,
//     required this.textColor,
//     required this.buttonColor2,
//     this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPress,
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           color: buttonColor2,
//           //shape: BoxShape.circle,
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(
//             color: Colors.grey.shade400, // or any accent color
//             width: 2,
//           ),
//         ),
//         child: loading
//             ? const Center(child: CircularProgressIndicator())
//             : Center(
//           child: child ??
//               Text(
//                 title ?? '',
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   color: textColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../../../resources/colors/colors.dart';

class RoundButton2 extends StatelessWidget {
  final double width;
  final double height;
  final bool loading;
  final String? title;
  final VoidCallback onPress;
  final Color? borderColor;
  final Color? textColor;
  final Widget? child;

  const RoundButton2({
    super.key,
    required this.width,
    required this.height,
    required this.loading,
    this.title,
    required this.onPress,
    this.borderColor,
    this.textColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: loading ? null : onPress,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: borderColor ??
                (isDark ? AppColor.gold : AppColor.emeraldGreen),
            width: 2,
          ),
        ),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Center(
          child: child ??
              Text(
                title ?? '',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: textColor ??
                      (isDark
                          ? AppColor.gold
                          : AppColor.emeraldGreen),
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}
