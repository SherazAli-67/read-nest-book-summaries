import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required TextEditingController textController,
    required String hintText,
    required String titleText,
    this.isPassword = false,
    this.readOnly = false,
    TextInputType? textInputType
  }) : _textController = textController,_hintText = hintText, _titleText = titleText, _textInputType = textInputType;

  final TextEditingController _textController;
  final String _hintText;
  final String _titleText;
  
  final bool isPassword;
  final bool readOnly;
  final TextInputType? _textInputType;
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget._titleText, style: AppTextStyles.regularTextStyle,),
        const SizedBox(height: 5,),

        TextField(
          controller: widget._textController,
          readOnly: widget.readOnly,
          obscureText: widget.isPassword && hidePassword,
          keyboardType: widget._textInputType,
          decoration: InputDecoration(
              hintText: widget.isPassword ? '● ● ● ● ● ● ● ● ● ● ●' : widget._hintText,
              hintStyle: AppTextStyles.regularTextStyle.copyWith(fontSize: 12, color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[200]!)
              ),
              suffixIcon: widget.isPassword ? IconButton(
                  onPressed: () => setState(() => hidePassword = !hidePassword),
                  icon: hidePassword
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off)) : null,
              focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey[200]!)

          ),
              fillColor: AppColors.textFieldFillColor,
              filled: true
          ),
        ),
      ],
    );
  }
}