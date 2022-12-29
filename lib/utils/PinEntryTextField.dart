import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PinEntryTextField extends StatefulWidget {
  final String? lastPin;
  final int fields;
  final onSubmit;
  final fieldWidth;
  final fontSize;
  final isTextObscure;
  final showFieldAsBox;

  PinEntryTextField({this.lastPin, this.fields: 6, this.onSubmit, this.fieldWidth: 30.0, this.fontSize: 16.0, this.isTextObscure: false, this.showFieldAsBox: false}) : assert(fields > 0);

  @override
  State createState() {
    return PinEntryTextFieldState();
  }
}

class PinEntryTextFieldState extends State<PinEntryTextField> {
  late List<String?> _pin;
  late List<FocusNode?> _focusNodes;
  late List<TextEditingController?> _textControllers;

  Widget textfields = Container();

  @override
  void initState() {
    super.initState();
    _pin = List<String?>.filled(widget.fields, null, growable: false);
    _focusNodes = List<FocusNode?>.filled(widget.fields, null, growable: false);
    _textControllers = List<TextEditingController?>.filled(widget.fields, null, growable: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (widget.lastPin != null) {
          for (var i = 0; i < widget.lastPin!.length; i++) {
            _pin[i] = widget.lastPin![i];
          }
        }
        textfields = Directionality(textDirection: TextDirection.ltr, child: generateTextFields(context));
      });
    });
  }

  @override
  void dispose() {
    _textControllers.forEach((TextEditingController? t) => t!.dispose());
    super.dispose();
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.fields, (int i) {
      return buildTextField(i, context);
    });

    if (_pin.first != null) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, verticalDirection: VerticalDirection.down, children: textFields);
  }

  void clearTextFields() {
    _textControllers.forEach((TextEditingController? tEditController) => tEditController!.clear());
    _pin.clear();
  }

  Widget buildTextField(int i, BuildContext context) {
    if (_focusNodes[i] == null) {
      _focusNodes[i] = FocusNode();
    }
    if (_textControllers[i] == null) {
      _textControllers[i] = TextEditingController();
      if (widget.lastPin != null) {
        _textControllers[i]!.text = widget.lastPin![i];
      }
    }

    _focusNodes[i]!.addListener(() {
      if (_focusNodes[i]!.hasFocus) {}
    });

    final String lastDigit = _textControllers[i]!.text;
    log("Language" + lastDigit);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: widget.fieldWidth,
        margin: EdgeInsets.only(right: 10.0),
        child: TextField(
          controller: _textControllers[i],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          textDirection: TextDirection.ltr,
          autofocus: true,
          style: primaryTextStyle(color: Theme.of(context).textTheme.subtitle2!.color),
          focusNode: _focusNodes[i],
          obscureText: widget.isTextObscure,
          decoration: InputDecoration(focusColor: Theme.of(context).primaryColor, counterText: "", border: widget.showFieldAsBox ? OutlineInputBorder(borderSide: BorderSide(width: 2.0)) : null),
          onChanged: (String str) {
            setState(() {
              _pin[i] = str;
            });
            if (i + 1 != widget.fields) {
              _focusNodes[i]!.unfocus();
              if (_pin[i] == '') {
                FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
              } else {
                FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
              }
            } else {
              _focusNodes[i]!.unfocus();
              if (_pin[i] == '') {
                FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
              }
            }
            if (_pin.every((String? digit) => digit != null && digit != '')) {
              widget.onSubmit(_pin.join());
            }
          },
          onSubmitted: (String str) {
            if (_pin.every((String? digit) => digit != null && digit != '')) {
              widget.onSubmit(_pin.join());
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return textfields;
  }
}
