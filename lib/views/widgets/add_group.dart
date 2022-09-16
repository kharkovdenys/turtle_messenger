import 'package:flutter/material.dart';
import 'package:turtle_messenger/services/size_config.dart';
import 'package:turtle_messenger/stores/chat.dart';
import 'package:turtle_messenger/stores/user.dart';
import 'package:turtle_messenger/theme/colors.dart';
import 'package:turtle_messenger/views/widgets/primary_button.dart';

addGroup(context) {
  TextEditingController nameCtrl = TextEditingController(text: "");
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      builder: (context) {
        return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: 300.toHeight,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                border:
                    Border.all(color: Colors.white.withOpacity(0.1), width: 3),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text("Add group",
                          style: TextStyle(
                            fontSize: 23.toFont,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    SizedBox(height: 24.toHeight),
                    TextFormField(
                      controller: nameCtrl,
                      maxLines: 3,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey[700]!, width: 2.toWidth),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.toWidth),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey[700]!, width: 2.toWidth),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.toWidth),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeColor.primary, width: 2.toWidth),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.toWidth),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey[700]!, width: 2.toWidth),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.toWidth),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 18.toWidth,
                          vertical: 16.toHeight,
                        ),
                        hintText: "This cannot be empty.",
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.toFont,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16.toFont,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 24.toHeight),
                    PrimaryButton(
                      text: "Create",
                      onPress: () async {
                        if (nameCtrl.text == "") return;
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        await ChatStore().addGroupToChatList(nameCtrl.text);
                        await UserStore().fetchCurrentUser();
                        await ChatStore().fetchUserChats();
                      },
                    ),
                  ],
                ),
              ),
            ));
      });
}
