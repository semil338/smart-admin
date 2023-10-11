import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin/view/sign_in/sign_in_helpers.dart';
import 'package:smart_admin/view/sign_in/sign_in_model.dart';
import 'package:smart_admin/widgets/widgets.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Consumer<SignInModel>(
        builder: (context, model, _) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Stack(
                children: [
                  bodyImage(context),
                  bodyContent(model, context),
                  showLoading(model),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
