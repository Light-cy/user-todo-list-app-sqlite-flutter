import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_database/models/user.dart';
import 'package:user_database/services/user_provider.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key, this.isupdate = false, this.user, this.index});
  final bool isupdate;
  final User? user;
  final int? index;

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isupdate && widget.user != null) {
      _nameController.text = widget.user!.name!;
      _emailController.text = widget.user!.email!;
      _ageController.text = widget.user!.age!;
      _phoneController.text = widget.user!.phoneNo!.toString();
      _addressController.text = widget.user!.address!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isupdate ? 'Update User' : 'Add User')),
      body: Stack(
        children: [
          Form(
            key: _formKey,

            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTextField("Name", _nameController),
                      const SizedBox(height: 10),
                      _buildTextField(
                        "Email",
                        _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        "Age",
                        _ageController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        "Phone",
                        _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 10),
                      _buildTextField("Address", _addressController),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });

      User u = User(
        name: _nameController.text,
        email: _emailController.text,
        age: _ageController.text,
        phoneNo: _phoneController.text,
        address: _addressController.text,
      );
      await Future.delayed(const Duration(seconds: 2));
      try {
        if (widget.isupdate) {
          if (mounted) {
            context.read<UserProvider>().updateUser(u, widget.index!);
          }
        } else {
          if (mounted) {
            context.read<UserProvider>().addUser(u);
          }
        }
        if (mounted) Navigator.of(context).pop(true); // Pop with a result
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Title(
            color: Colors.grey,
            child: Text('Please Add all the fields'),
          ),
          showCloseIcon: true,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildTextField(
    String labell,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter $labell";
        }
        if (labell == "Email" && !value.contains("@gmail.com")) {
          return "Please enter a valid email";
        }
        if (labell == "Age" && int.tryParse(value) == null) {
          return "Please enter a valid age";
        }
        if (labell == "Phone" && int.tryParse(value) == null) {
          return "Please enter a valid phone number";
        }
        if (labell == "Phone" && value.length != 11) {
          return "Please enter 11 digit phone number";
        }

        return null;
      },

      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: '$labell*',
        hintText:
            labell == "Phone" ? "Enter 11 digit $labell" : "Enter $labell",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
