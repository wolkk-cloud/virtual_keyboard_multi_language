import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class CustomLayoutKeys extends VirtualKeyboardLayoutKeys {
  @override
  int getLanguagesCount() => 2;

  List<List> getLanguage(int index) {
    switch (index) {
      case 1:
        return _arabicLayout;
      default:
        return defaultEnglishLayout;
    }
  }
}

const List<List> _arabicLayout = [
  // Row 1
  const [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
  ],
  // Row 2
  const [
    'ض',
    'ص',
    'ث',
    'ق',
    'ف',
    'غ',
    'ع',
    'ه',
    'خ',
    'ح',
    'د',
    VirtualKeyboardKeyAction.Backspace
  ],
  // Row 3
  const [
    'ش',
    'س',
    'ي',
    'ب',
    'ل',
    'ا',
    'ت',
    'ن',
    'م',
    'ك',
    'ط',
    VirtualKeyboardKeyAction.Return
  ],
  // Row 4
  const [
    'ذ',
    'ئ',
    'ء',
    'ؤ',
    'ر',
    'لا',
    'ى',
    'ة',
    'و',
    '.',
    'ظ',
    VirtualKeyboardKeyAction.Shift
  ],
  // Row 5
  const [
    VirtualKeyboardKeyAction.SwitchLanguage,
    '@',
    VirtualKeyboardKeyAction.Space,
    '-',
    '_',
  ]
];
