import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? ontTap;
  final bool? readOnly;
  final String? errorText;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatter;
  final String? hintText;

  const PasswordTextField({
    Key? key,
    required this.controller,
    this.ontTap,
    this.readOnly,
    this.textInputType,
    this.errorText,
    this.inputFormatter,
    this.hintText,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: TextField(
            obscureText: hide,
            autofillHints: const [AutofillHints.password],
            keyboardType: widget.textInputType ?? TextInputType.text,
            readOnly: widget.readOnly ?? false,
            controller: widget.controller,
            inputFormatters: widget.inputFormatter,
            decoration: InputDecoration(
              fillColor: Colors.white,
              hintText: widget.hintText,
              suffixIcon: GestureDetector(
                onTap: () {
                  hide = !hide;
                  setState(() {});
                },
                child: hide
                    ? const Icon(
                        size: 20,
                        Icons.visibility_off,
                        color: Colors.grey,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: Colors.grey,
                        size: 20,
                      ),
              ),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
              contentPadding: const EdgeInsets.only(left: 8),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
            onTap: widget.ontTap,
          ),
        ),
        // widget.errorText==null?Container():SizedBox(height: 2,),
        if (widget.errorText == null)
          Container()
        else
          Text(
            widget.errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          )
      ],
    );
  }
}
