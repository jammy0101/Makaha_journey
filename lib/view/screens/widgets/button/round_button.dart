// import 'package:flutter/material.dart';
//
// import '../../../../resources/colors/colors.dart';
//
//
// class RoundButton extends StatelessWidget {
//   final bool loading;
//   final String title;
//   final VoidCallback onPress;
//   final double height, width;
//   final Color textColor, roundButton;
//
//   const RoundButton({
//     super.key,
//     this.loading = false,
//     required this.title,
//     required this.onPress,
//     this.width = 60,
//     this.height = 50,
//     required this.roundButton,
//     required this.textColor,
//   });
//
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPress,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Container(
//           height: height,
//           width: width,
//           decoration: BoxDecoration(
//             color: roundButton,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: loading
//               ? const Center(
//               child: CircularProgressIndicator()) : Center(
//             child: Text(
//               title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColor.whiteColor,fontWeight: FontWeight.bold),),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../../../resources/colors/colors.dart';

class RoundButton extends StatelessWidget {
  final bool loading;
  final String title;
  final VoidCallback onPress;
  final double height, width;
  final Color? buttonColor;
  final Color? textColor;

  const RoundButton({
    super.key,
    this.loading = false,
    required this.title,
    required this.onPress,
    this.width = double.infinity,
    this.height = 55,
    this.buttonColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: loading ? null : onPress,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: buttonColor ??
                (isDark ? AppColor.gold.withOpacity(0.9) : AppColor.gold),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppColor.gold.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: loading
              ? const Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
              : Center(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: textColor ??
                    (isDark ? Colors.black : AppColor.whiteColor),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
