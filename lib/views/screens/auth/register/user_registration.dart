import 'package:clezigov/models/occupation.dart';
import 'package:clezigov/utils/routes.dart';
import 'package:clezigov/views/screens/auth/register/account_setup.dart';
import 'package:clezigov/views/widgets/form_fields/gender_selection.dart';
import 'package:clezigov/views/widgets/form_fields/simple_text_field.dart';
import 'package:clezigov/views/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../models/cities.dart';
import '../../../../utils/constants.dart';
import '../../../widgets/form_fields/dropdown_form_field.dart';
import '../../../widgets/form_fields/password_form_field.dart';
import '../../../widgets/tilt_icon.dart';

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({super.key});

  static const String routeName = '/user-registration';

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final _userRegistrationFormKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  final TextEditingController _searchCityController = TextEditingController();
  final TextEditingController _searchOccupationController =
      TextEditingController();

  // Form fields
  String? value, city, occupation;
  Gender? gender;

  // Form validation
  bool isNameFilled = false,
      isCityFilled = false,
      isOccupationFilled = false,
      isGenderFilled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        isNameFilled = _nameController.text.isNotEmpty;
      });
    });

    _cityController.addListener(() {
      setState(() {
        isCityFilled = _cityController.text.isNotEmpty;
      });
    });

    _occupationController.addListener(() {
      setState(() {
        isOccupationFilled = _occupationController.text.isNotEmpty;
      });
    });

    _genderController.addListener(() {
      setState(() {
        isGenderFilled = _genderController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _occupationController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("User registration"),
        ),
        body: Form(
          key: _userRegistrationFormKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: [
              Text(
                "Hey, welcome to you 👋🏽",
                style: AppTextStyles.h2,
              ),
              Gap(8.0),
              Text(
                "We are happy to have you among us. Let’s begin by knowing each other.",
                style: AppTextStyles.body,
              ),
              Gap(8.0),
              Row(
                children: [
                  Icon(
                    HugeIcons.strokeRoundedInformationCircle,
                    color: Theme.of(context).disabledColor,
                    size: 16.0,
                  ),
                  Gap(8.0),
                  Expanded(
                    child: Text(
                      "If you instead want to sign up with your Google account or Apple ID, go back to the previous screen.",
                      style: AppTextStyles.small.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  )
                ],
              ),
              Gap(20.0),
              SimpleTextFormField(
                controller: _nameController,
                hintText: "How should we call you?",
                prefixIcon: Icon(HugeIcons.strokeRoundedUser),
                textCapitalization: TextCapitalization.words,
              ),
              Gap(16.0),
              DefaultDropdownFormField(
                searchController: _searchCityController,
                hintText: 'Residence city',
                prefixIcon: Icon(HugeIcons.strokeRoundedHome12),
                items: cities.map((city) => city.name).toList(),
                searchTitle: 'Select your city',
                onChanged: (String? value) {
                  city = value;
                  // update controller
                  _cityController.text = value!;
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "You must select a residence city";
                  }
                  return null;
                },
              ),
              Gap(16.0),
              DefaultDropdownFormField(
                searchController: _searchOccupationController,
                hintText: 'Occupation',
                prefixIcon: Icon(HugeIcons.strokeRoundedId),
                items:
                    occupations.map((occupation) => occupation.name).toList(),
                searchTitle: 'Select your occupation',
                onChanged: (String? value) {
                  occupation = value;
                  _occupationController.text = value!;
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "You must select an occupation";
                  }
                  return null;
                },
              ),
              Gap(16.0),
              GenderSelectionFormField(
                onChanged: (value) {
                  gender = value;
                  _genderController.text = value!.name;
                },
              ),
              Gap(24.0),
              PrimaryButton.label(
                onPressed: (isNameFilled &&
                        isCityFilled &&
                        isOccupationFilled &&
                        isGenderFilled)
                    ? () {
                        if (_userRegistrationFormKey.currentState!.validate()) {
                          // Save and proceed
                          context.goPush(AccountSetup.routeName);
                        }
                      }
                    : null,
                label: "Save and proceed",
              ),
              Gap(16.0),
              PrimaryButton.label(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    builder: (context) {
                      return QuickRegistrationModal();
                    },
                  );
                },
                label: 'Wanna fill that later?',
                backgroundColor: seedColorPalette.shade50,
                labelColor: seedColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickRegistrationModal extends StatefulWidget {
  const QuickRegistrationModal({super.key});

  @override
  State<QuickRegistrationModal> createState() => _QuickRegistrationModalState();
}

class _QuickRegistrationModalState extends State<QuickRegistrationModal> {
  final _userQuickRegistrationFormKey = GlobalKey<FormState>();

  // Quick registration controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  // Form fields
  String? email, password, confirmPassword;

  // Form validation
  bool isEmailFilled = false,
      isPasswordFilled = false,
      isConfirmPasswordFilled = false;

  @override
  void initState() {
    super.initState();
    // Quick registration
    _emailController.addListener(() {
      setState(() {
        isEmailFilled = _emailController.text.isNotEmpty;
      });
    });

    _passwordController.addListener(() {
      setState(() {
        isPasswordFilled = _passwordController.text.isNotEmpty;
      });
    });

    _confirmPasswordController.addListener(() {
      setState(() {
        isConfirmPasswordFilled = _confirmPasswordController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _userQuickRegistrationFormKey,
          child: ListView(
            shrinkWrap: true,
            padding: allPadding * 1.25,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              TiltIcon(
                icon: HugeIcons.strokeRoundedTimer02,
              ),
              Gap(8.0),
              Text(
                "Well at least, let\'s know your email and set up a password quick.",
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              Gap(4.0),
              Text(
                "Don\'t worry, you can still fill the rest later.",
                style: AppTextStyles.body.copyWith(
                  color: disabledColor,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(24.0),
              SimpleTextFormField(
                controller: _emailController,
                hintText: "Email address",
                prefixIcon: Icon(HugeIcons.strokeRoundedMail02),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email address is required";
                  }

                  if (!RegExp(emailRegex).hasMatch(value)) {
                    return 'Enter a valid email address';
                  }

                  return null;
                },
              ),
              Gap(16.0),
              PasswordTextFormField(
                controller: _passwordController,
                hintText: "Password",
                prefixIcon:
                Icon(HugeIcons.strokeRoundedPinCode),
                onChanged: (value) => password = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
              ),
              Gap(16.0),
              PasswordTextFormField(
                controller: _confirmPasswordController,
                hintText: "Confirm password",
                prefixIcon:
                Icon(HugeIcons.strokeRoundedLockKey),
                onChanged: (value) => confirmPassword = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password is required";
                  }

                  if (value != _passwordController.text) {
                    return "Passwords do not match";
                  }

                  return null;
                },
              ),
              Gap(16.0),
              PrimaryButton.label(
                onPressed: (isEmailFilled &&
                    isPasswordFilled &&
                    isConfirmPasswordFilled)
                    ? () {
                  if (_userQuickRegistrationFormKey
                      .currentState!
                      .validate()) {
                    authController.signUpWithEmailAndPassword(
                      context,
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    );
                  }
                }
                    : null,
                label: "Save and proceed",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

