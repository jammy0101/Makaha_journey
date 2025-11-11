// import 'package:flutter/material.dart';
// import '../../../../resources/colors/colors.dart';
//
// class DuaCard extends StatelessWidget {
//   final String imagePath;
//   final String title;
//   final VoidCallback onTap;
//
//   const DuaCard({
//     super.key,
//     required this.imagePath,
//     required this.title,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: isDark ? AppColor.surfaceDark : AppColor.whiteColor,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             ClipRRect(
//               borderRadius:
//               const BorderRadius.vertical(top: Radius.circular(12)),
//               child: Image.asset(
//                 imagePath,
//                 width: double.infinity,
//                 height: 180,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: isDark
//                     ? AppColor.surfaceDark
//                     : AppColor.whiteCream,
//                 borderRadius:
//                 const BorderRadius.vertical(bottom: Radius.circular(12)),
//               ),
//               child: Center(
//                 child: Text(
//                   title,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color:
//                     isDark ? AppColor.whiteColor : AppColor.deepCharcoal,
//                     fontFamily: 'NotoNastaliqUrdu',
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../../../resources/colors/colors.dart';

class DuaCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const DuaCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? AppColor.surfaceDark : AppColor.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColor.deepCharcoal.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.55),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Title
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColor.deepCharcoal.withOpacity(0.85)
                      : Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'NotoNastaliqUrdu',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color:
                    isDark ? AppColor.gold : AppColor.deepCharcoal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
