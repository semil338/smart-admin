export 'borders.dart';
export 'show_alert_dialog.dart';
export 'validations.dart';
export 'sign_in_button.dart';
export 'constant.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_admin/widgets/borders.dart';
import 'package:smart_admin/widgets/constant.dart';
import 'package:smart_admin/widgets/sign_in_button.dart';
import 'package:smart_admin/widgets/text_field.dart';
import 'package:smart_admin/widgets/validations.dart';

Opacity showLoading(var model) {
  return Opacity(
    opacity: model.isLoading ? 1.0 : 0,
    child: const Center(
      child: CircularProgressIndicator(
        color: fontColor,
      ),
    ),
  );
}

Container showText(String text) {
  return Container(
    alignment: Alignment.center,
    child: Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: const Color.fromRGBO(55, 59, 94, 1),
        fontFamily: GoogleFonts.bitter().fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

SignInButton buildButton(var model, BuildContext context, String text) {
  return SignInButton(
    text: text,
    onPressed: () => model.submit(context),
    color: fontColor,
    fontSize: 1.5,
  );
}

Widget buildPasswordField(var model, BuildContext context, String hintText) {
  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: TextFormField(
      onEditingComplete: () => model.submit(context),
      focusNode: model.passwordFocusNode,
      controller: model.passController,
      validator: validatePassword,
      obscureText: model.hidePassword,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
          icon: model.showIcon(),
          onPressed: () => model.updateWith(hidePassword: !model.hidePassword),
          color: fontColor,
        ),
        prefixIcon: const Icon(
          Icons.lock,
          color: fontColor,
        ),
        enabledBorder: enabledBorder,
        focusedBorder: focusBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    ),
  );
}

CustomTextField buildEmailField(var model, String hintText) {
  return CustomTextField(
    editingComplete: () => model.emailEditingComplete,
    focusNode: model.emailFocusNode,
    controller: model.emailController,
    hintText: hintText,
  );
}

AppBar appBar(String label) => AppBar(
      iconTheme: const IconThemeData(color: fontColor),
      title: Text(label, style: const TextStyle(color: fontColor)),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.white,
    );

final nothingToShow = Center(
    child: Text(
  "Nothing to show",
  style: TextStyle(color: notActive, fontSize: 25.0),
));
