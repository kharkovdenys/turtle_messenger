import 'package:flutter/material.dart';
import 'package:turtle_messenger/routes/routes_path.dart';
import 'package:turtle_messenger/services/get_it_service.dart';
import 'package:turtle_messenger/services/navigation_service.dart';
import 'package:turtle_messenger/services/size_config.dart';
import 'package:turtle_messenger/services/validations.dart';
import 'package:turtle_messenger/stores/auth.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:turtle_messenger/views/widgets/login_text_field.dart';
import 'package:turtle_messenger/views/widgets/primary_button.dart';
import 'package:turtle_messenger/views/widgets/secondary_button.dart';

class ConfirmScreen extends StatefulWidget {
  final String username;
  final String email;
  final String password;

  const ConfirmScreen({
    Key? key,
    required this.username,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  TextEditingController otpCtrl = TextEditingController();

  final NavigationService _navigationService =
      getItInstanceConst<NavigationService>();

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
                "Enter OTP",
                style: TextStyle(
                  fontSize: 36.toFont,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )),
              SizedBox(height: 10.toHeight),
              Column(
                children: [
                  SizedBox(height: 45.toHeight),
                  CustomLoginTextField(
                    hintTextL: "Enter OTP Send to your Email",
                    ctrl: otpCtrl,
                    validation: Validations.validateOTP,
                    maxLength: 6,
                    type: TextInputType.number,
                  ),
                  SizedBox(height: 24.toHeight),
                  PrimaryButton(
                    text: "Continue",
                    onPress: () async {
                      try {
                        if (widget.email != "" && widget.password != "") {
                          bool isVerified = await AuthStore().confirm(
                            username: widget.username,
                            email: widget.email,
                            otp: otpCtrl.text,
                            password: widget.password,
                          );
                          if (isVerified) {
                            _navigationService.popAllAndReplace(RoutePath.home);
                          }
                        } else {
                          bool isVerified = await AuthStore().confirmSignedIn(
                            username: widget.username,
                            otp: otpCtrl.text,
                          );
                          if (isVerified) {
                            _navigationService
                                .popAllAndReplace(RoutePath.login);
                          }
                        }
                      } catch (_) {}
                    },
                  )
                ],
              ),
              SizedBox(height: 40.toHeight),
              SecondaryButton(
                text: "Sign In",
                onPress: () {
                  _navigationService.popAllAndReplace(RoutePath.login);
                },
              ),
              SizedBox(height: 20.toHeight),
              GestureDetector(
                  onTap: () async {
                    await AuthStore().resend(username: widget.username);
                  },
                  child: Center(
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        fontSize: 16.toFont,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
