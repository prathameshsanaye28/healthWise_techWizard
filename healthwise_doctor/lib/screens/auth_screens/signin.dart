import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:healthwise/resources/auth_methods.dart';
import 'package:healthwise/screens/networking_screen.dart';
import 'package:healthwise/widgets/text_field_input.dart';
import 'package:healthwise/widgets/utils.dart';
import 'package:image_picker/image_picker.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _jurisdictionController = TextEditingController();
  final TextEditingController _yearsExperienceController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  List<String> _technicalSkills = [];
  List<String> _regulatoryExpertise = [];
  List<String> _financialStandards = [];
  List<String> _industryFocus = [];
  final TextEditingController _skillController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _jurisdictionController.dispose();
    _yearsExperienceController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  void addSkill(List<String> list, String value) {
    setState(() {
      if (value.isNotEmpty && !list.contains(value)) {
        list.add(value);
      }
    });
    _skillController.clear();
  }

  void removeSkill(List<String> list, int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      name: _userNameController.text,
      phone: _phoneNumberController.text,
      region: _jurisdictionController.text,
      role: "Professional",
      file: _image!,
      yearsExperience: int.tryParse(_yearsExperienceController.text) ?? 0,
      certifications: _technicalSkills,
      specializations: _regulatoryExpertise,
      conditions: _financialStandards,
      procedures: _industryFocus,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => NetworkingScreen()),
      );
    }
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text('Sign In', style: TextStyle(color: Colors.black, fontSize: 35)),
                const SizedBox(height: 20),

                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                              'https://i.pinimg.com/originals/65/25/a0/6525a08f1df98a2e3a545fe2ace4be47.jpg',
                            ),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                TextFieldInput(
                  hintText: 'Enter your Username',
                  textEditingController: _userNameController,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  hintText: 'Enter your Full Name',
                  textEditingController: _fullNameController,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  hintText: 'Enter your Contact Number',
                  textEditingController: _phoneNumberController,
                  textInputType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  hintText: 'Enter your Email',
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  hintText: 'Enter your Password',
                  textEditingController: _passwordController,
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  hintText: 'Enter your Jurisdiction',
                  textEditingController: _jurisdictionController,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  hintText: 'Enter Years of Experience',
                  textEditingController: _yearsExperienceController,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                buildSkillInput('Cerifications', _technicalSkills),
                buildSkillInput('Specializations', _regulatoryExpertise),
                buildSkillInput('Conditions Treated', _financialStandards),
                buildSkillInput('Procedures Mastered', _industryFocus),

                const SizedBox(height: 24),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    child: !_isLoading
                        ? const Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white),
                          )
                        : const CircularProgressIndicator(color: Colors.white),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSkillInput(String label, List<String> skillList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Wrap(
          children: skillList
              .asMap()
              .entries
              .map((entry) => Chip(
                    label: Text(entry.value),
                    onDeleted: () => removeSkill(skillList, entry.key),
                  ))
              .toList(),
        ),
        Row(
          children: [
            Expanded(
              child: TextFieldInput(
                hintText: 'Add a skill',
                textEditingController: _skillController,
                textInputType: TextInputType.text,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => addSkill(skillList, _skillController.text),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
