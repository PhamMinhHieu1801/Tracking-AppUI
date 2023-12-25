import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onTap;
  final bool? readOnly;
  final String? errorText;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatter;
  final bool? enable;
  final FocusNode? focusNode;
  final TextStyle? textStyle;
  final bool? isCenter;
  final Function(String?)? onSubmitted;
  final bool? autoFocus;
  final Color? borderColor;
  final String? iconUrl;
  final VoidCallback? onIconTap;
  final EdgeInsets? contentPadding;
  final String? hintText;
  final String? labelText;

  const CommonTextField({
    Key? key,
    required this.controller,
    this.onTap,
    this.readOnly,
    this.textInputType,
    this.errorText,
    this.inputFormatter,
    this.enable,
    this.focusNode,
    this.textStyle,
    this.isCenter = false,
    this.onSubmitted,
    this.autoFocus,
    this.borderColor,
    this.iconUrl,
    this.onIconTap,
    this.contentPadding,
    this.hintText,
    this.labelText,
  }) : super(key: key);

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(
              height: 48,
              child: TextField(
                expands: true,
                minLines: null,
                maxLines: null,

                autofocus: widget.autoFocus ?? false,
                onSubmitted: widget.onSubmitted,
                focusNode: widget.focusNode,
                enabled: widget.enable ?? true,
                keyboardType: widget.textInputType ?? TextInputType.text,
                readOnly: widget.readOnly ?? false,
                controller: widget.controller,
                inputFormatters: widget.inputFormatter,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  labelText: widget.labelText,
                  filled: true,
                  hintText: widget.hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: widget.borderColor ?? Colors.black,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: widget.borderColor ?? Colors.black,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: widget.borderColor ?? Colors.black,
                      width: 1,
                    ),
                  ),
                  contentPadding: widget.contentPadding ??
                      const EdgeInsets.only(
                        left: 8,
                        top: 12,
                        bottom: 12,
                      ),
                  isDense: true,
                ),
                textAlign: widget.isCenter ?? false
                    ? TextAlign.center
                    : TextAlign.left,
                style: widget.textStyle ?? const TextStyle(fontSize: 14),
                onTap: widget.onTap,
              ),
            ),
          ],
        ),
        if (widget.errorText == null) Container() else SizedBox(height: 2),
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
