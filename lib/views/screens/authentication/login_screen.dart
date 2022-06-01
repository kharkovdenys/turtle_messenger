import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_messenger/views/widgets/login_text_field.dart';
import 'package:turtle_messenger/views/widgets/primary_button.dart';
import 'package:turtle_messenger/routes/routes_path.dart';
import 'package:turtle_messenger/services/get_it_service.dart';
import 'package:turtle_messenger/services/navigation_service.dart';
import 'package:turtle_messenger/services/validations.dart';
import 'package:turtle_messenger/stores/auth.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:turtle_messenger/services/size_config.dart';
import 'package:turtle_messenger/views/widgets/snackbars.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AuthStore _authStore;
  final NavigationService _navigationService =
      get_it_instance_const<NavigationService>();

  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authStore = context.read<AuthStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text(
                "Sign in",
                style: TextStyle(
                  fontSize: 36.toFont,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )),
              SizedBox(height: 60.toHeight),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 45.toHeight),
                    CustomLoginTextField(
                      hintTextL: "Username",
                      ctrl: usernameCtrl,
                      autofill: AutofillHints.username,
                      validation: Validations.validateFullName,
                      type: TextInputType.name,
                    ),
                    SizedBox(height: 24.toHeight),
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
                      text: "Log in",
                      onPress: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (!formKey.currentState!.validate()) return;
                        bool? isSignedIn = await _authStore.login(
                          username: usernameCtrl.text,
                          password: passwordCtrl.text,
                        );
                        if (isSignedIn != null) {
                          isSignedIn
                              ? _navigationService
                                  .popAllAndReplace(RoutePath.home)
                              :  showErrorSnackBar(context, "Error login");
                        } else {
                          AuthStore().resend(username: usernameCtrl.text);
                          _navigationService.navigateTo(
                            RoutePath.confirm,
                            arguments: {
                              "username": usernameCtrl.text,
                              "email": "",
                              "password": "",
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20.toHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 16.toFont,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _navigationService
                                .popAllAndReplace(RoutePath.register);
                          },
                          child: Text(
                            "Register.",
                            style: TextStyle(
                              fontSize: 16.toFont,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.toHeight),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
