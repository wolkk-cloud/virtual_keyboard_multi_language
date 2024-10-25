part of virtual_keyboard_multi_language;

abstract class VirtualKeyboardLayoutKeys {
  int activeIndex = 0;

  List<List> get defaultEnglishLayout => _defaultEnglishLayout;
  List<List> get defaultGermanLayout => _defaultGermanLayout;

  List<List> get activeLayout => getLanguage(activeIndex);
  int getLanguagesCount();
  List<List> getLanguage(int index);

  void switchLanguage() {
    if ((activeIndex + 1) == getLanguagesCount())
      activeIndex = 0;
    else
      activeIndex++;
  }

  void changeLanguage(VirtualKeyboardDefaultLayouts layout) {
    if (layout == VirtualKeyboardDefaultLayouts.English)
      activeIndex = 0;
    else if (layout == VirtualKeyboardDefaultLayouts.German) activeIndex = 1;
  }

  String get getLanguageCode;
}

class VirtualKeyboardDefaultLayoutKeys extends VirtualKeyboardLayoutKeys {
  List<VirtualKeyboardDefaultLayouts> defaultLayouts;
  VirtualKeyboardDefaultLayoutKeys(this.defaultLayouts);

  int getLanguagesCount() => defaultLayouts.length;

  List<List> getLanguage(int index) {
    switch (defaultLayouts[index]) {
      case VirtualKeyboardDefaultLayouts.English:
        return _defaultEnglishLayout;
      case VirtualKeyboardDefaultLayouts.German:
        return _defaultGermanLayout;
      default:
        return _defaultEnglishLayout;
    }
  }

  String get getLanguageCode {
    switch (defaultLayouts[activeIndex]) {
      case VirtualKeyboardDefaultLayouts.English:
        return 'en';
      case VirtualKeyboardDefaultLayouts.German:
        return 'de';
      default:
        return 'en';
    }
  }
}

/// Keys for Virtual Keyboard's rows.
const List<List> _defaultEnglishLayout = [
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
    '-',
    '=',
  ],
  // Row 2
  const [
    'q',
    'w',
    'e',
    'r',
    't',
    'y',
    'u',
    'i',
    'o',
    'p',
    VirtualKeyboardKeyAction.Backspace
  ],
  // Row 3
  const [
    'a',
    's',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
    ';',
    '\'',
    VirtualKeyboardKeyAction.Return
  ],
  // Row 4
  const [
    VirtualKeyboardKeyAction.Shift,
    'z',
    'x',
    'c',
    'v',
    'b',
    'n',
    'm',
    ',',
    '.',
    '-',
    VirtualKeyboardKeyAction.Shift
  ],
  // Row 5
  const [
    VirtualKeyboardKeyAction.SwitchLanguage,
    '@',
    VirtualKeyboardKeyAction.Space,
    '&',
    '_',
  ]
];

const List<List> _defaultGermanLayout = [
  // Row 1
  [
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
    'ß',
    '´',
  ],
  // Row 2
  [
    'q',
    'w',
    'e',
    'r',
    't',
    'z', // Z replaces Y in the German layout
    'u',
    'i',
    'o',
    'p',
    'ü',
    '+',
    VirtualKeyboardKeyAction.Backspace
  ],
  // Row 3
  [
    'a',
    's',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
    'ö',
    'ä',
    VirtualKeyboardKeyAction.Return
  ],
  // Row 4
  [
    VirtualKeyboardKeyAction.Shift,
    'y', // Y replaces Z in the German layout
    'x',
    'c',
    'v',
    'b',
    'n',
    'm',
    ',',
    '.',
    '-',
    VirtualKeyboardKeyAction.Shift
  ],
  // Row 5
  [
    VirtualKeyboardKeyAction.SwitchLanguage,
    '@',
    VirtualKeyboardKeyAction.Space,
    '&',
    '_',
  ]
];
