import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smart_admin/model/devices.dart';
import 'package:smart_admin/services/database.dart';
import 'package:smart_admin/widgets/widgets.dart';

class EditSubCategory extends StatefulWidget {
  const EditSubCategory({
    Key? key,
    required this.label,
    required this.database,
    this.devices,
    required this.path,
    required this.fileSelected,
  }) : super(key: key);
  final String label;
  final String path;
  final Database database;
  final Devices? devices;
  final bool fileSelected;

  @override
  _EditSubCategoryState createState() => _EditSubCategoryState();
}

class _EditSubCategoryState extends State<EditSubCategory> {
  bool autoValidate = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode urlFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool? isSelected;
  bool isLoading = false;
  List<String> type = ["Button", "Display"];
  String? _selectedType;
  File? file;

  @override
  void initState() {
    if (widget.devices != null) {
      nameController.text = widget.devices!.name;
      urlController.text = widget.devices!.iconLink;
      _selectedType = widget.devices!.type;
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
          dropDownList(),
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
      // onEditingComplete: () => model.submit(context),
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
      height: 100,
      width: 100,
      child: FittedBox(
        child: SizedBox(
          height: 100,
          width: 100,
          child: file == null
              ? (urlController.text.isNotEmpty)
                  ? SvgPicture.network(
                      urlController.text,
                      color: kPrimaryColor,
                      fit: BoxFit.cover,
                    )
                  : Container()
              : SvgPicture.file(
                  File(file!.path),
                  color: kPrimaryColor,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget selectButton() {
    return SignInButton(
      text: "Select an icon",
      onPressed: selectFile,
      color: bgColor,
      fontSize: 1.5,
      textColor: fontColor,
    );
  }

  Widget dropDownList() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fontColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: 50,
        child: DropdownButton(
          underline: null,
          iconEnabledColor: Colors.white,
          dropdownColor: fontColor,
          borderRadius: BorderRadius.circular(16),
          hint: const Text(
            'Type',
            style: TextStyle(color: Colors.white),
          ),
          value: _selectedType,
          onChanged: (newValue) {
            setState(() {
              _selectedType = newValue as String?;
            });
          },
          items: type.map((location) {
            return DropdownMenuItem(
              child: Text(
                location,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              value: location,
            );
          }).toList(),
        ),
      ),
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
    try {
      if (formKey.currentState!.validate()) {
        if (_selectedType != null) {
          setState(() {
            isLoading = true;
          });
          if (isSelected!) {
            await _upload();
          }

          final device = await widget.database.getDevices(widget.path).first;
          final List<String>? allNames =
              device?.map((device) => device.name).toList();
          if (widget.devices != null) {
            allNames!.remove(nameController.text);
          }
          if (allNames != null && allNames.contains(nameController.text)) {
            showAlertDialog(
              context,
              title: "Name already used",
              content: "Please choose a different job name",
              defaultActionText: "OK",
            );
            setState(() {
              isLoading = false;
            });
          } else {
            final id = widget.devices?.id ?? documentIdFromCurrentDate();
            final devices = Devices(
              id: id,
              name: nameController.text,
              iconLink: urlController.text,
              type: _selectedType.toString(),
            );
            await widget.database.addDevices(devices, widget.path);
            Navigator.pop(context);
          }
        } else {
          showAlertDialog(
            context,
            title: "Type not Selected",
            content: "Please select a type",
            defaultActionText: "OK",
          );
          setState(() {
            isLoading = false;
          });
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
        defaultActionText: "OK",
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['svg'],
    );
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
      isSelected = true;
    });
  }
}
