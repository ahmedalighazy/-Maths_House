import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/cubit/student/student_cubit.dart';
import 'package:maths_house/cubit/student/student_state.dart';
import 'dart:io';
import 'dart:convert';

import '../widgets/custom_text.dart';

class AddStudentScreen extends StatefulWidget {
  final VoidCallback? onStudentAdded;

  const AddStudentScreen({super.key, this.onStudentAdded});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController parentEmailController = TextEditingController();
  final TextEditingController parentPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();
  bool _isFormEnabled = true;

  // Dropdown values
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Load available categories and courses when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentCubit>().getStudent();
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    nickNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    gradeController.dispose();
    parentEmailController.dispose();
    parentPhoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _pickImage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ImageSourceBottomSheet(
        onImageSourceSelected: (source) {
          Navigator.pop(context);
          _getImage(source);
        },
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });

        // Convert to base64
        List<int> imageBytes = await _selectedImage!.readAsBytes();
        _base64Image = base64Encode(imageBytes);
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _addStudent() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isFormEnabled = false;
      });

      context.read<StudentCubit>().addStudent(
        fName: firstNameController.text.trim(),
        lName: lastNameController.text.trim(),
        nickName: nickNameController.text.trim().isEmpty ? 'N/A' : nickNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
        parentPhone: parentPhoneController.text.trim(),
        parentEmail: parentEmailController.text.trim(),
        grade: gradeController.text.trim(),
        categoryName: _selectedCategory, // Use category name instead of ID
        imageBase64: _base64Image,
      );
    }
  }

  void _clearForm() {
    setState(() {
      firstNameController.clear();
      lastNameController.clear();
      nickNameController.clear();
      emailController.clear();
      phoneController.clear();
      gradeController.clear();
      parentEmailController.clear();
      parentPhoneController.clear();
      passwordController.clear();
      _selectedImage = null;
      _base64Image = null;
      _selectedCategory = null;
      _isFormEnabled = true;
    });
  }

  void _enableForm() {
    setState(() {
      _isFormEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: BlocListener<StudentCubit, StudentStates>(
        listener: (context, state) {
          if (state is StudentAddSuccessState) {
            _showSnackBar(state.message, Colors.green);
            _clearForm();

            if (widget.onStudentAdded != null) {
              widget.onStudentAdded!();
            }
          } else if (state is StudentErrorState) {
            _showSnackBar(state.error, Colors.red);
            _enableForm();
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            CustomAppBar(
              title: 'Add New Student',
              icon: Icons.person_add,
              onClosePressed: () => Navigator.pop(context),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image Section
                      ProfileImagePicker(
                        selectedImage: _selectedImage,
                        onTap: _isFormEnabled ? _pickImage : () {},
                      ),
                      const SizedBox(height: 24),

                      // Personal Information Section
                      _buildSectionHeader('Personal Information'),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: firstNameController,
                        label: 'First Name',
                        icon: Icons.person,
                        enabled: _isFormEnabled,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name';
                          }
                          if (value.trim().length < 2) {
                            return 'First name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: lastNameController,
                        label: 'Last Name',
                        icon: Icons.person,
                        enabled: _isFormEnabled,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          }
                          if (value.trim().length < 2) {
                            return 'Last name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: nickNameController,
                        label: 'Nickname',
                        icon: Icons.person_outline,
                        enabled: _isFormEnabled,
                        helperText: 'Optional',
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty && value.trim().length < 2) {
                            return 'Nickname must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: emailController,
                        label: 'Email Address',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        enabled: _isFormEnabled,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email address';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        enabled: _isFormEnabled,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (value.trim().length < 8) {
                            return 'Phone number must be at least 8 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomPasswordField(
                        controller: passwordController,
                        label: 'Password',
                        enabled: _isFormEnabled,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.trim().length < 3) {
                            return 'Password must be at least 3 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Academic Information Section
                      _buildSectionHeader('Academic Information'),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: gradeController,
                        label: 'Grade Level',
                        icon: Icons.school,
                        keyboardType: TextInputType.number,
                        enabled: _isFormEnabled,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter grade level';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      BlocBuilder<StudentCubit, StudentStates>(
                        builder: (context, state) {
                          final cubit = context.read<StudentCubit>();
                          final categories = cubit.availableCategoryNames;

                          return CustomDropdownField<String>(
                            value: _selectedCategory,
                            label: 'Category',

                            icon: Icons.category,
                            items: categories,
                            enabled: _isFormEnabled && categories.isNotEmpty,
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),


                      const SizedBox(height: 24),

                      // Parent Information Section
                      _buildSectionHeader('Parent Information'),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: parentEmailController,
                        label: 'Parent Email Address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        enabled: _isFormEnabled,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter parent email address';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value.trim())) {
                            return 'Please enter a valid parent email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: parentPhoneController,
                        label: 'Parent Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        enabled: _isFormEnabled,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter parent phone number';
                          }
                          if (value.trim().length < 8) {
                            return 'Parent phone number must be at least 8 digits';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            BlocBuilder<StudentCubit, StudentStates>(
              builder: (context, state) {
                bool isLoading = state is StudentLoadingState;

                return CustomActionButtons(
                  onCancel: () => Navigator.pop(context),
                  onAdd: _addStudent,
                  isLoading: isLoading,
                  addButtonText: 'Add Student',
                  cancelButtonText: 'Cancel',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

// Custom Dropdown Field Widget
class CustomDropdownField<T> extends StatelessWidget {
  final T? value;
  final String label;
  final IconData icon;
  final List<T> items;
  final bool enabled;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final String? helperText;

  const CustomDropdownField({
    Key? key,
    this.value,
    required this.label,
    required this.icon,
    required this.items,
    this.enabled = true,
    this.onChanged,
    this.validator,
    this.helperText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color:  AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color:  AppColors.primary),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
    );
  }
}