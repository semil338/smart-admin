import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin/model/category.dart';
import 'package:smart_admin/services/database.dart';
import 'package:smart_admin/widgets/widgets.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({
    Key? key,
    required this.label,
    required this.path,
    this.category,
  }) : super(key: key);
  final String label;
  final String path;
  final Category? category;

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();

  bool autoValidate = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.category != null) {
      nameController.text = widget.category!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(widget.label),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildForm(context),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode:
          autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 19),
          nameTextField(),
          const SizedBox(height: 30),
          saveButton(),
        ],
      ),
    );
  }

  SignInButton saveButton() {
    return SignInButton(
      text: "Save Data",
      onPressed: () => addData(),
      color: fontColor,
      fontSize: 1.5,
    );
  }

  Widget nameTextField() {
    return buildTextField(
      editingComplete: () {},
      inputAction: TextInputAction.next,
      focusNode: nameFocusNode,
      controller: nameController,
      validate: validateName2,
      inputType: TextInputType.name,
      hintText: "Name",
      icon: Icons.device_hub,
    );
  }

  Future<void> addData() async {
    final database = Provider.of<Database>(context, listen: false);

    try {
      if (formKey.currentState!.validate()) {
        final device = await database.getDevices(widget.path).first;
        final List<String>? allNames =
            device?.map((device) => device.name).toList();
        if (widget.category != null) {
          allNames!.remove(nameController.text);
        }
        if (allNames != null && allNames.contains(nameController.text)) {
          showAlertDialog(
            context,
            title: "Name already used",
            content: "Please choose a different job name",
          );
        } else {
          final id = widget.category?.id ?? documentIdFromCurrentDate();
          final category = Category(
            id: id,
            name: nameController.text,
          );
          await database.addCategory(category, widget.path);
          Navigator.pop(context);
        }
      } else {
        setState(() {
          autoValidate = true;
        });
      }
    } on FirebaseException catch (e) {
      showAlertDialog(
        context,
        title: "Operation Failed",
        content: e.toString(),
      );
    }
  }
}
