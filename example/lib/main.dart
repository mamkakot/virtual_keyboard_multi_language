import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Keyboard Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Virtual Keyboard Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage(Key key, this.title) : super(key: key);
  MyHomePage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Holds the text that user typed.
  String text = '';
  // CustomLayoutKeys _customLayoutKeys;
  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  late TextEditingController _controllerText;

  @override
  void initState() {
    // _customLayoutKeys = CustomLayoutKeys();
    _controllerText = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              _controllerText.text,
              style: TextStyle(color: Colors.red),
            ),
            SwitchListTile(
              title: Text(
                'Keyboard Type = ' +
                    (isNumericMode
                        ? 'VirtualKeyboardType.Numeric'
                        : 'VirtualKeyboardType.Alphanumeric'),
              ),
              value: isNumericMode,
              onChanged: (val) {
                setState(() {
                  isNumericMode = val;
                });
              },
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              color: Color.fromARGB(255, 244, 244, 244),
              child: VirtualKeyboard(
                builder: (context, key) {
                  return KeyBuilder(
                    virtualKey: key,
                    onKeyPress: _onKeyPress,
                  );
                },
                height: 260,
                keyRowsAlignment: MainAxisAlignment.center,
                //width: 500,
                textColor: Colors.white,
                textController: _controllerText,
                defaultLayouts: [
                  VirtualKeyboardDefaultLayouts.Russian,
                  VirtualKeyboardDefaultLayouts.English
                ],
                //reverseLayout :true,
                type: isNumericMode
                    ? VirtualKeyboardType.Numeric
                    : VirtualKeyboardType.Alphanumeric,
                onKeyPress: _onKeyPress,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text + (shiftEnabled ? key.capsText! : key.text!);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.length == 0) return;
          text = text.substring(0, text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          text = text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + key.text!;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        case VirtualKeyboardKeyAction.AllCaps:
          break;
        default:
          break;
      }
    }
    // Update the screen
    setState(() {});
  }
}

class KeyBuilder extends StatelessWidget {
  final VirtualKeyboardKey virtualKey;
  final Function(VirtualKeyboardKey) onKeyPress;

  const KeyBuilder({
    required this.virtualKey,
    super.key,
    required this.onKeyPress,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black;
    double keyWidth = 48;
    Icon actionKey = Icon(Icons.arrow_upward, color: textColor);

    if (virtualKey.keyType == VirtualKeyboardKeyType.Action) {
      keyWidth = 96;
      switch (virtualKey.action) {
        case VirtualKeyboardKeyAction.Shift:
          actionKey = Icon(Icons.arrow_upward, color: textColor);
          break;
        case VirtualKeyboardKeyAction.Space:
          keyWidth = 240;
          actionKey = actionKey = Icon(Icons.space_bar, color: textColor);
          break;
        case VirtualKeyboardKeyAction.Return:
          actionKey = Icon(
            Icons.keyboard_return,
            color: textColor,
          );
          break;
        case VirtualKeyboardKeyAction.SwitchLanguage:
          actionKey = Icon(
            Icons.language,
            color: textColor,
          );
          break;
        case null:
          break;
        case VirtualKeyboardKeyAction.Backspace:
          actionKey = Icon(Icons.backspace);
          break;
        case VirtualKeyboardKeyAction.AllCaps:
          actionKey = Icon(Icons.keyboard_double_arrow_up_sharp);
          break;
      }
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 2.5),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 183, 183, 183)),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.white,
              const Color.fromARGB(255, 224, 224, 224),
            ],
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          onTap: () {
            onKeyPress(virtualKey);
          },
          child: SizedBox(
            width: keyWidth,
            height: 48,
            child: Center(
              child: virtualKey.keyType == VirtualKeyboardKeyType.Action
                  ? actionKey
                  : Text(
                      virtualKey.text!.toUpperCase(),
                      style: GoogleFonts.roboto(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
