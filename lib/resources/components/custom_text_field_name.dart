// import 'package:flutter/material.dart';
// import '../colors/colors.dart';
//
//
// class CustomTextFieldName extends StatelessWidget {
//   const CustomTextFieldName({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     this.validator,
//   });
//
//   final TextEditingController controller;
//   final String hintText;
//   final String? Function(String?)? validator;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0.8),
//       child: TextFormField(
//         controller: controller,
//         style: TextStyle(color: AppColor.blackColor),
//         textCapitalization: TextCapitalization.words, // Name case
//         keyboardType: TextInputType.name,
//         decoration: InputDecoration(
//             hintText: hintText,
//             hintStyle: TextStyle(color: AppColor.blackColor),
//             border:  OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.blue,width: 3)
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             )
//         ),
//         validator: validator,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CustomTextFieldName extends StatelessWidget {
  const CustomTextFieldName({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.8),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: TextStyle(color: theme.colorScheme.onSurface),
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
           // borderSide: BorderSide(color: theme.dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
