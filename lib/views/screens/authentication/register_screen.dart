import 'package:flutter/material.dart';
import 'package:turtle_messenger/views/widgets/login_text_field.dart';
import 'package:turtle_messenger/views/widgets/primary_button.dart';
import 'package:turtle_messenger/views/widgets/secondary_button.dart';
import 'package:turtle_messenger/routes/routes_path.dart';
import 'package:turtle_messenger/services/get_it_service.dart';
import 'package:turtle_messenger/services/navigation_service.dart';
import 'package:turtle_messenger/services/validations.dart';
import 'package:turtle_messenger/stores/auth.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:turtle_messenger/services/size_config.dart';
import 'package:turtle_messenger/views/widgets/snackbars.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final NavigationService _navigationService =
      get_it_instance_const<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
          child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                    "Sing up",
                    style: TextStyle(
                      fontSize: 36.toFont,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    )
                  )),
                  SizedBox(height: 20.toHeight),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 45.toHeight),
                        CustomLoginTextField(
                          hintTextL: "Username",
                          ctrl: usernameCtrl,
                          autofill: AutofillHints.newUsername,
                          validation: Validations.validateFullName,
                          type: TextInputType.text,
                        ),
                        SizedBox(height: 12.toHeight),
                        CustomLoginTextField(
                          hintTextL: "Email",
                          ctrl: emailCtrl,
                          autofill: AutofillHints.email,
                          validation: Validations.validateEmail,
                          type: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 12.toHeight),
                        CustomLoginTextField(
                          hintTextL: "Password",
                          ctrl: passwordCtrl,
                          validation: Validations.valdiatePassword,
                          autofill: AutofillHints.password,
                          obscureText: true,
                          type: TextInputType.text,
                        ),
                        SizedBox(height: 24.toHeight),
                        PrimaryButton(
                          text: "Register",
                          onPress: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (!formKey.currentState!.validate()) return;
                            bool isSignupComplete = await AuthStore().register(
                              name: usernameCtrl.text,
                              email: emailCtrl.text,
                              password: passwordCtrl.text,
                            );
                            if (isSignupComplete) {
                              _navigationService.navigateTo(
                                RoutePath.confirm,
                                arguments: {
                                  "username": usernameCtrl.text,
                                  "email": emailCtrl.text,
                                  "password": passwordCtrl.text,
                                },
                              );
                            } else {
                              showErrorSnackBar(context, "Error register");
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 40.toHeight),
                  SecondaryButton(
                    text: "Sign In",
                    onPress: () {
                      _navigationService.popAllAndReplace(RoutePath.login);
                    },
                  )
                ],
          ),
        ),
      ),
    );
  }
}
