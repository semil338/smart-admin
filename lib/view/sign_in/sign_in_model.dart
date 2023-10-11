import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin/services/auth.dart';
import 'package:smart_admin/services/database.dart';
import 'package:smart_admin/widgets/widgets.dart';

enum validateMode { validate, unValidate }

class SignInModel extends ChangeNotifier {
  SignInModel({
    required this.auth,
    this.isLoading = false,
    this.hidePassword = true,
    this.autoValidate = false,
  });

  final AuthBase auth;
  bool isLoading;
  bool autoValidate;
  bool hidePassword;
  bool _disposed = false;
  bool isRegister = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _disposed = true;
    emailController.dispose();
    passController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Icon showIcon() {
    if (hidePassword) {
      return const Icon(Icons.visibility);
    } else {
      return const Icon(Icons.visibility_off);
    }
  }

  AutovalidateMode autovalidateMode() =>
      autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled;

  void submit(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    FocusScope.of(context).requestFocus(FocusNode());

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      debugPrint("Success");
      updateWith(isLoading: true);
      var email = "", password = "";

      try {
        await database.readAdminData().then((element) {
          for (var admin in element!) {
            email = admin.email;
            password = admin.password;
            debugPrint(email);
            debugPrint(password);

            if (emailController.text == email &&
                passController.text == password) {
              updateWith(isRegister: true);
            }
          }
        });
        if (isRegister) {
          debugPrint("Hello");
          await auth.signInWithEmailAndPassword(
              emailController.text, passController.text);
        } else {
          showAlertDialog(
            context,
            title: "Sign in",
            content: "Wrong email/password combination.",
            defaultActionText: "OK",
          );
        }
      } on FirebaseAuthException catch (e) {
        showAlertDialog(
          context,
          title: "Sign in",
          content: getMessageFromErrorCode(e.code),
          defaultActionText: "OK",
        );
        updateWith(isLoading: false);
      } finally {
        updateWith(isLoading: false);
      }
    } else {
      updateWith(autoValidate: true);
    }
  }

  void updateWith({
    String? emailController,
    String? passController,
    bool? isLoading,
    bool? hidePassword,
    bool? autoValidate,
    bool? isRegister,
  }) {
    this.isLoading = isLoading ?? this.isLoading;
    this.hidePassword = hidePassword ?? this.hidePassword;
    this.autoValidate = autoValidate ?? this.autoValidate;
    this.emailController.text = emailController ?? this.emailController.text;
    this.passController.text = passController ?? this.passController.text;
    this.isRegister = isRegister ?? this.isRegister;
    notifyListeners();
  }

  void emailEditingComplete(BuildContext context) {
    FocusScope.of(context).requestFocus(passwordFocusNode);
  }
}
