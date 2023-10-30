part of virtual_keyboard_multi_language;

/// Virtual Keyboard key
class VirtualKeyboardKey {
  String? text;
  String? capsText;
  final VirtualKeyboardKeyType keyType;
  final VirtualKeyboardKeyAction? action;

  VirtualKeyboardKey({
    this.text,
    this.capsText,
    required this.keyType,
    this.action,
  }) {
    if (this.text == null && this.action != null) {
      if (action == VirtualKeyboardKeyAction.Space) {
        this.text = ' ';
      } else {
        this.text = (action == VirtualKeyboardKeyAction.Return ? '\n' : '');
      }
    }
    if (this.capsText == null && this.action != null) {
      if (action == VirtualKeyboardKeyAction.Space) {
        this.capsText = ' ';
      } else {
        this.capsText = (action == VirtualKeyboardKeyAction.Return ? '\n' : '');
      }
    }
  }
}
