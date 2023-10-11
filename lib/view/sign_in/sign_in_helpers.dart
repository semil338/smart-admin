import 'package:flutter/material.dart';
import 'package:smart_admin/view/sign_in/sign_in_model.dart';
import 'package:smart_admin/widgets/widgets.dart';

Widget bodyContent(SignInModel model, BuildContext context) {
  return Opacity(
    opacity: model.isLoading ? 0.4 : 1,
    child: AbsorbPointer(
      absorbing: model.isLoading,
      child: Column(
        children: [
          headerBox(context),
          formContainer(context, model),
        ],
      ),
    ),
  );
}

Widget formContainer(BuildContext context, SignInModel model) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.75,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(60),
        )),
    child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: _buildForm(context, model),
    ),
  );
}

Widget headerBox(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.25,
    width: MediaQuery.of(context).size.width,
    child: Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10),
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.6,
          child: bodyImage2(context),
        ),
      ],
    ),
  );
}

Widget _buildForm(BuildContext context, SignInModel model) {
  return Form(
    key: model.formKey,
    autovalidateMode: model.autovalidateMode(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 19),
        showText("Login"),
        const SizedBox(height: 50),
        buildEmailField(model, "Email"),
        const SizedBox(height: 20),
        buildPasswordField(model, context, "Password"),
        const SizedBox(height: 30),
        buildButton(model, context, "Login"),
      ],
    ),
  );
}

Widget bodyImage(BuildContext context) {
  return Opacity(
    opacity: 0.4,
    child: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg-1.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

Widget bodyImage2(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.2,
    width: MediaQuery.of(context).size.width * 0.6,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/2-removebg-preview.png"),
        fit: BoxFit.cover,
      ),
    ),
  );
}
