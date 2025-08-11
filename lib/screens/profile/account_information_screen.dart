import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../models/profile_model.dart';
import 'package:my_project/colors.dart';

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({super.key});

  @override
  State<AccountInformationScreen> createState() =>
      _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _dobController;
  late TextEditingController _descriptionController;
  String? _selectedGender = 'male';

  final List<String> _genderOptions = ['male', 'female'];

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _dobController = TextEditingController();
    _descriptionController = TextEditingController();

    // Initialize controllers with current user data
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded) {
      _updateControllersWithProfile(state.profile);
    }
  }

  void _updateControllersWithProfile(ProfileModel profile) {
    _fullNameController.text = profile.user.fullname;
    _emailController.text = profile.user.email;
    // Initialize other fields with empty strings since they're not in the model yet
    _addressController.text = profile.user.address ?? '';
    _selectedGender =
        profile.user.gender != null ? profile.user.gender : 'male';
    _descriptionController.text = profile.user.description ?? '';

    // Format date of birth in YYYY-MM-DD format
    if (profile.user.dateOfBirth != null &&
        profile.user.dateOfBirth!.isNotEmpty) {
      try {
        final date = DateTime.parse(profile.user.dateOfBirth!);
        _dobController.text =
            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      } catch (e) {
        _dobController.text = profile.user.dateOfBirth!;
      }
    } else {
      _dobController.text = '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    TextInputType? keyboardType,
    VoidCallback? onTap,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onTap: onTap,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFFA00D9)),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFFA00D9)),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        items: _genderOptions.map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue;
          });
        },
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Information',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: AppColors.primaryColor,
              ),
            );
            _updateControllersWithProfile(state.profile);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Full Name',
                      controller: _fullNameController,
                    ),
                    _buildGenderDropdown(),
                    _buildTextField(
                      label: 'Date of Birth',
                      controller: _dobController,
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Description',
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                    const Text(
                      'Contact details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const Text(
                      'We only request your country of residence—just enough to better serve you while keeping your privacy intact. Thanks.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    _buildTextField(
                      label: 'Country',
                      controller: _addressController,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(
                              UpdateProfile(
                                fullName: _fullNameController.text,
                                email: _emailController.text,
                                address: _addressController.text,
                                gender: _selectedGender ?? 'Male',
                                dateOfBirth: _dobController.text,
                                description: _descriptionController.text,
                              ),
                            );
                        // TODO: Implement save functionality
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('Something went wrong'),
            );
          },
        ),
      ),
    );
  }
}
