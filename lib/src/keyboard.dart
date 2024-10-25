part of virtual_keyboard_multi_language;

/// The default keyboard height. Can we overriden by passing
///  `height` argument to `VirtualKeyboard` widget.
const double _virtualKeyboardDefaultHeight = 300;

const int _virtualKeyboardBackspaceEventPerioud = 250;

enum VirtualKeyboardReturnKeyType {
  NewLine,
  Go,
  HideKeyboard,
}

/// Virtual Keyboard widget.
class VirtualKeyboard extends StatefulWidget {
  /// Keyboard Type: Should be inited in creation time.
  final VirtualKeyboardType type;

  /// Callback for Key press event. Called with pressed `Key` object.
  final Function? onKeyPress;

  /// Virtual keyboard height. Default is 300
  final double height;

  /// Virtual keyboard height. Default is full screen width
  final double? width;

  /// Color for key texts and icons.
  final Color textColor;

  /// Font size for keyboard keys.
  final double fontSize;

  /// the custom layout for multi or single language
  final VirtualKeyboardLayoutKeys? customLayoutKeys;

  /// the text controller go get the output and send the default input
  final TextEditingController? textController;

  /// The builder function will be called for each Key object.
  final Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;

  /// Set to true if you want only to show Caps letters.
  final bool alwaysCaps;

  /// inverse the layout to fix the issues with right to left languages.
  final bool reverseLayout;

  /// used for multi-languages with default layouts, the default is English only
  /// will be ignored if customLayoutKeys is not null
  final List<VirtualKeyboardDefaultLayouts>? defaultLayouts;

  final VirtualKeyboardDefaultLayouts defaultLanguage;

  final Function(String)? onSubmitted;

  final VirtualKeyboardReturnKeyType returnKeyType;

  final CustomKeyboardController customKeyboardController;

  /// Callback for text change event.
  final Function(String)? onChange;

  VirtualKeyboard(
      {Key? key,
      required this.type,
      this.onKeyPress,
      this.builder,
      this.width,
      this.defaultLayouts,
      this.customLayoutKeys,
      this.textController,
      this.reverseLayout = false,
      this.height = _virtualKeyboardDefaultHeight,
      this.textColor = Colors.black,
      this.fontSize = 14,
      this.alwaysCaps = false,
      this.defaultLanguage = VirtualKeyboardDefaultLayouts.English,
      this.onSubmitted,
      required this.customKeyboardController,
      this.onChange,
      this.returnKeyType = VirtualKeyboardReturnKeyType.NewLine})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VirtualKeyboardState();
  }
}

/// Holds the state for Virtual Keyboard class.
class _VirtualKeyboardState extends State<VirtualKeyboard> {
  late VirtualKeyboardType type;
  Function? onKeyPress;
  late TextEditingController textController;
  // The builder function will be called for each Key object.
  Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;
  late double height;
  double? width;
  late Color textColor;
  late double fontSize;
  late bool alwaysCaps;
  late bool reverseLayout;
  late Function(String)? onSubmitted;
  late VirtualKeyboardLayoutKeys customLayoutKeys;
  // Text Style for keys.
  late TextStyle textStyle;

  // True if shift is enabled.
  bool isShiftEnabled = false;

  void _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      _textUpdateWithCursor(
          inputText: (isShiftEnabled ? key.capsText : key.text) ?? '');
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          _backSpaceUpdateWithCursor();
          break;
        case VirtualKeyboardKeyAction.Return:
          if (widget.returnKeyType == VirtualKeyboardReturnKeyType.NewLine) {
            _textUpdateWithCursor(inputText: "\n");
          } else if (widget.returnKeyType == VirtualKeyboardReturnKeyType.Go) {
            onSubmitted?.call(textController.text);
            widget.customKeyboardController.unfocus();
          } else if (widget.returnKeyType ==
              VirtualKeyboardReturnKeyType.HideKeyboard) {
            widget.customKeyboardController.unfocus();
          }
          break;
        case VirtualKeyboardKeyAction.Space:
          _textUpdateWithCursor(inputText: key.text ?? '');
          break;
        case VirtualKeyboardKeyAction.Shift:
          break;
        default:
      }
    }

    onKeyPress?.call(key);
  }

  void _backSpaceUpdateWithCursor() {
    var cursorPos = textController.selection.base.offset;
    if (cursorPos == 0) return;
    if (textController.text.length == 0) return;
    textController.text =
        textController.text.replaceRange(cursorPos - 1, cursorPos, '');
    textController.selection =
        TextSelection.fromPosition(TextPosition(offset: cursorPos - 1));
    widget.onChange?.call(textController.text);
  }

  void _textUpdateWithCursor({required String inputText}) {
    var cursorPos = textController.selection.base.offset;
    String textAfterCursor = textController.text.substring(cursorPos);

    String textBeforeCursor = textController.text.substring(0, cursorPos);
    textController.text = textBeforeCursor + inputText + textAfterCursor;

    textController.selection =
        TextSelection.fromPosition(TextPosition(offset: cursorPos + 1));

    widget.onChange?.call(textController.text);
  }

  @override
  dispose() {
    if (widget.textController == null) // dispose if created locally only
      textController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VirtualKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      type = widget.type;
      builder = widget.builder;
      onKeyPress = widget.onKeyPress;
      onSubmitted = widget.onSubmitted;
      height = widget.height;
      width = widget.width;
      textColor = widget.textColor;
      fontSize = widget.fontSize;
      alwaysCaps = widget.alwaysCaps;
      reverseLayout = widget.reverseLayout;
      textController = widget.textController ?? textController;
      customLayoutKeys = widget.customLayoutKeys ?? customLayoutKeys;
      // Init the Text Style for keys.
      customLayoutKeys.changeLanguage(widget.defaultLanguage);
      textStyle = TextStyle(
        fontSize: fontSize,
        color: textColor,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    textController = widget.textController ?? TextEditingController();
    width = widget.width;
    type = widget.type;
    customLayoutKeys = widget.customLayoutKeys ??
        VirtualKeyboardDefaultLayoutKeys(
            widget.defaultLayouts ?? [VirtualKeyboardDefaultLayouts.English]);
    builder = widget.builder;
    onKeyPress = widget.onKeyPress;
    onSubmitted = widget.onSubmitted;
    height = widget.height;
    textColor = widget.textColor;
    fontSize = widget.fontSize;
    alwaysCaps = widget.alwaysCaps;
    reverseLayout = widget.reverseLayout;
    // Init the Text Style for keys.
    textStyle = TextStyle(
      fontSize: fontSize,
      color: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return type == VirtualKeyboardType.Numeric ? _numeric() : _alphanumeric();
  }

  Widget _alphanumeric() {
    return Container(
      height: height + (customLayoutKeys.activeLayout.length * 2),
      width: width ?? MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _rows(),
      ),
    );
  }

  Widget _numeric() {
    return Container(
      height: height + (customLayoutKeys.activeLayout.length * 2),
      width: width ?? MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _rows(),
      ),
    );
  }

  /// Returns the rows for keyboard.
  List<Widget> _rows() {
    // Get the keyboard Rows
    List<List<VirtualKeyboardKey>> keyboardRows =
        type == VirtualKeyboardType.Numeric
            ? _getKeyboardRowsNumeric()
            : _getKeyboardRows(customLayoutKeys);

    // Generate keyboard row.
    List<Widget> rows = List.generate(keyboardRows.length, (int rowNum) {
      var items = List.generate(keyboardRows[rowNum].length, (int keyNum) {
        // Get the VirtualKeyboardKey object.
        VirtualKeyboardKey virtualKeyboardKey = keyboardRows[rowNum][keyNum];

        Widget keyWidget;

        // Check if builder is specified.
        // Call builder function if specified or use default
        //  Key widgets if not.
        if (builder == null) {
          // Check the key type.
          switch (virtualKeyboardKey.keyType) {
            case VirtualKeyboardKeyType.String:
              // Draw String key.
              keyWidget = _keyboardDefaultKey(virtualKeyboardKey);
              break;
            case VirtualKeyboardKeyType.Action:
              // Draw action key.
              keyWidget = _keyboardDefaultActionKey(virtualKeyboardKey);
              break;
          }
        } else {
          // Call the builder function, so the user can specify custom UI for keys.
          keyWidget = builder!(context, virtualKeyboardKey);

          // if (keyWidget == null) {
          //   throw 'builder function must return Widget';
          // }
        }

        return keyWidget;
      });

      if (this.reverseLayout) items = items.reversed.toList();
      return Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          // Generate keboard keys
          children: items,
        ),
      );
    });

    return rows;
  }

  // True if long press is enabled.
  bool longPress = false;

  /// Creates default UI element for keyboard Key.
  Widget _keyboardDefaultKey(VirtualKeyboardKey key) {
    return Expanded(
        child: InkWell(
      onTap: () {
        _onKeyPress(key);
      },
      child: Container(
        margin: EdgeInsets.all(1.0),
        height: height / customLayoutKeys.activeLayout.length,
        decoration: BoxDecoration(color: Colors.white12),
        child: Center(
            child: Text(
          alwaysCaps
              ? key.capsText ?? ''
              : (isShiftEnabled ? key.capsText : key.text) ?? '',
          style: textStyle,
        )),
      ),
    ));
  }

  /// Creates default UI element for keyboard Action Key.
  Widget _keyboardDefaultActionKey(VirtualKeyboardKey key) {
    // Holds the action key widget.
    Widget? actionKey;

    // Switch the action type to build action Key widget.
    switch (key.action ?? VirtualKeyboardKeyAction.SwithLanguage) {
      case VirtualKeyboardKeyAction.Backspace:
        actionKey = GestureDetector(
            onLongPress: () {
              longPress = true;
              // Start sending backspace key events while longPress is true
              Timer.periodic(
                  Duration(milliseconds: _virtualKeyboardBackspaceEventPerioud),
                  (timer) {
                if (longPress) {
                  _onKeyPress(key);
                } else {
                  // Cancel timer.
                  timer.cancel();
                }
              });
            },
            onLongPressUp: () {
              // Cancel event loop
              longPress = false;
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Icon(
                Icons.backspace,
                color: textColor,
              ),
            ));
        break;
      case VirtualKeyboardKeyAction.Shift:
        actionKey = Icon(Icons.arrow_upward, color: textColor);
        break;
      case VirtualKeyboardKeyAction.Space:
        actionKey = actionKey = Icon(Icons.space_bar, color: textColor);
        break;
      case VirtualKeyboardKeyAction.Return:
        actionKey = Icon(
          Icons.keyboard_return,
          color: textColor,
        );
        break;
      case VirtualKeyboardKeyAction.SwithLanguage:
        actionKey = GestureDetector(
            onTap: () {
              setState(() {
                customLayoutKeys.switchLanguage();
              });
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.language,
                    color: textColor,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    customLayoutKeys.getLanguageCode.toUpperCase(),
                    style: TextStyle(color: textColor, fontSize: fontSize),
                  )
                ],
              ),
            ));
        break;
    }

    var wdgt = InkWell(
      onTap: () {
        if (key.action == VirtualKeyboardKeyAction.Shift) {
          if (!alwaysCaps) {
            setState(() {
              isShiftEnabled = !isShiftEnabled;
            });
          }
        }

        _onKeyPress(key);
        widget.onChange?.call(textController.text);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.white12),
        margin: EdgeInsets.all(1.0),
        height: height / customLayoutKeys.activeLayout.length,
        child: actionKey,
      ),
    );

    if (key.action == VirtualKeyboardKeyAction.Space)
      return SizedBox(
          width: (width ?? MediaQuery.of(context).size.width) / 2, child: wdgt);
    else
      return Expanded(child: wdgt);
  }
}
