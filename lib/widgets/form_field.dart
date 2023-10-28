import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget formField({String? hintText, TextInputType? keyboardType, TextInputAction? textInputAction, FormFieldValidator<String>? validator, ValueChanged<String>? onChanged, VoidCallback? onEditingComplete, ValueChanged<String>? onFieldSubmitted, String? initialValue, GestureTapCallback? onTap, Widget? prefixIcon, BoxConstraints? prefixIconConstraints, bool? obscureText, Widget? suffixIcon, TextStyle? hintStyle, TextStyle? labelStyle, String? label, bool readOnly = false, bool? enabled, bool? isDense, int? maxLines, TextEditingController? controller, TextStyle? style, EdgeInsetsGeometry? contentPadding, InputBorder? border, InputBorder? focusedBorder, InputBorder? enabledBorder, TextAlign textAlign = TextAlign.start, TextAlignVertical? textAlignVertical, List<TextInputFormatter>? inputFormatters, Color? fillColor, InputDecoration? decoration, FormFieldSetter<String>? onSaved}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    label != null
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(label, style: labelStyle ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, fontStyle: FontStyle.normal)),
          )
        : Container(),
    TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: textInputAction ?? TextInputAction.next,
      autocorrect: false,
      readOnly: readOnly,
      initialValue: initialValue,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines ?? 1,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      enabled: enabled,
      onSaved: onSaved,
      onTap: onTap,
      style: style,
      obscureText: obscureText ?? false,
      inputFormatters: inputFormatters,
      decoration: decoration ?? InputDecoration(border: border, fillColor: fillColor, contentPadding: contentPadding, isDense: isDense, filled: fillColor != null, focusedBorder: focusedBorder, enabledBorder: enabledBorder, suffixIcon: suffixIcon, hintText: hintText, hintStyle: hintStyle, labelStyle: labelStyle, prefixIcon: prefixIcon, prefixIconConstraints: prefixIconConstraints),
    )
  ]);
}
