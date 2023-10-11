import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_admin/model/rooms.dart';
import 'package:smart_admin/services/database.dart';
import 'package:smart_admin/widgets/widgets.dart';

class EditRoom extends StatefulWidget {
  const EditRoom({
    Key? key,
    required this.label,
    this.room,
    required this.path,
    required this.fileSelected,
  }) : super(key: key);
  final String label;
  final String path;
  final Room? room;
  final bool fileSelected;

  @override
  _EditRoomState createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  bool autoValidate = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode urlFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool? isSelected;
  bool isLoading = false;
  File? file;

  @override
  void initState() {
    if (widget.room != null) {
      nameController.text = widget.room!.name;
      urlController.text = widget.room!.iconLink;
    }
    isSelected = widget.fileSelected;

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    urlController.dispose();
    nameFocusNode.dispose();
    urlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: fontColor),
        title: Text(widget.label, style: const TextStyle(color: fontColor)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Stack(
            children: [
              Opacity(
                opacity: isLoading ? 0.4 : 1,
                child: AbsorbPointer(
                  absorbing: isLoading,
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
              ),
              Opacity(
                opacity: isLoading ? 1.0 : 0,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: fontColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: formKey,
      // ignore: deprecated_member_use
      autovalidateMode:
          autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 19),
          nameTextField(),
          const SizedBox(height: 20),
          urlTextField(),
          const SizedBox(height: 30),
          selectButton(),
          const SizedBox(height: 30),
          iconImage(),
          const SizedBox(height: 30),
          saveButton(),
        ],
      ),
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

  SignInButton saveButton() {
    return SignInButton(
      text: "Save Data",
      onPressed: () => addData(),
      color: fontColor,
      fontSize: 1.5,
    );
  }

  TextFormField urlTextField() {
    return TextFormField(
      readOnly: true,
      focusNode: urlFocusNode,
      controller: urlController,
      validator: (value) => file == null ? hasValidUrl(value) : null,
      decoration: const InputDecoration(
        hintText: "Icon Url",
        prefixIcon: Icon(
          Icons.image,
          color: fontColor,
        ),
        enabledBorder: enabledBorder,
        focusedBorder: focusBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    );
  }

  SizedBox iconImage() {
    return SizedBox(
      height: 250,
      width: 250,
      child: FittedBox(
        child: Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: file == null
                  ? NetworkImage(urlController.text)
                  : FileImage(
                      File(file!.path),
                    ) as ImageProvider,
            ),
          ),
        ),
      ),
    );
  }

  Widget selectButton() {
    return SignInButton(
      text: "Select an image",
      onPressed: selectFile,
      color: bgColor,
      fontSize: 1.5,
      textColor: fontColor,
    );
  }

  _upload() async {
    String path = p.basename(file!.path);
    var imageFile = FirebaseStorage.instance.ref().child("icons").child(path);
    UploadTask task = imageFile.putFile(file!);
    TaskSnapshot snapshot = await task;
    urlController.text = await snapshot.ref.getDownloadURL();
  }

  Future<void> addData() async {
    final database = Provider.of<Database>(context, listen: false);

    try {
      if (formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        if (isSelected!) {
          await _upload();
        }

        final device = await database.getDevices(widget.path).first;
        final List<String>? allNames =
            device?.map((device) => device.name).toList();
        if (widget.room != null) {
          allNames!.remove(nameController.text);
        }
        if (allNames != null && allNames.contains(nameController.text)) {
          showAlertDialog(
            context,
            title: "Name already used",
            content: "Please choose a different job name",
          );
          setState(() {
            isLoading = false;
          });
        } else {
          final id = widget.room?.id ?? uuid();
          final room = Room(
            id: id,
            name: nameController.text,
            iconLink: urlController.text,
          );
          await database.addRoom(room, widget.path);
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
      isSelected = true;
    });
  }
}
