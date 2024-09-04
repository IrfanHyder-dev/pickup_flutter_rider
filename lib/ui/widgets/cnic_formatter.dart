import 'package:flutter/services.dart';

class CNICNumberFormatter extends TextInputFormatter {
  final List<int> dashPositions;

  CNICNumberFormatter({required this.dashPositions});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    String formattedText = '';

    // Remove any existing dashes and non-digit characters from the input
    text = text.replaceAll(RegExp(r'[^\d]'), '');

    int totalDigits = text.length;
    int currentIndex = 0;

    for (var dashPosition in dashPositions) {
      if (currentIndex >= totalDigits) break;

      if (dashPosition <= totalDigits) {
        formattedText += text.substring(currentIndex, dashPosition) + '-';
        currentIndex = dashPosition;
      }
    }

    if (currentIndex < totalDigits) {
      int remainingDigits = totalDigits - currentIndex;
      formattedText += text.substring(currentIndex, currentIndex + remainingDigits);
    }

    // Restrict user from typing beyond 13 digits
    if (formattedText.length >= 15) {
      return oldValue;
    }

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}



// class CNICNumberFormatter extends TextInputFormatter {
//   final List<int>? dashPositions;
//
//   CNICNumberFormatter({ this.dashPositions =const [5,12]});
//
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     String text = newValue.text;
//     String formattedText = '';
//
//     // Remove any existing dashes and non-digit characters from the input
//     text = text.replaceAll(RegExp(r'[^\d]'), '');
//
//     int totalDigits = text.length;
//     int currentIndex = 0;
//
//     if(totalDigits <= 13){
//       for (var dashPosition in dashPositions!) {
//         if (currentIndex >= totalDigits) break;
//
//         if (dashPosition <= totalDigits) {
//           formattedText += text.substring(currentIndex, dashPosition) + '-';
//           currentIndex = dashPosition;
//         }
//       }
//
//       if (currentIndex < totalDigits) {
//         formattedText += text.substring(
//             currentIndex, currentIndex + (13 - formattedText.length));
//       }
//
//       // Restrict user from typing beyond 13 digits
//       // if (formattedText.length >= 15) {
//       //   return oldValue;
//       // }
//     }else{
//       return oldValue;
//     }
//
//     return newValue.copyWith(
//       text: formattedText,
//       selection: TextSelection.collapsed(offset: formattedText.length),
//     );
//   }
// }