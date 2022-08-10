// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, unnecessary_this, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobs_in_oz/pages/profilePass/new_password_controller.dart';
import 'package:jobs_in_oz/pages/signOut/seeker_signout_controller.dart';
import 'package:jobs_in_oz/utils/colors.dart';
import 'package:jobs_in_oz/utils/constants.dart';
import 'package:jobs_in_oz/utils/images.dart';
import 'package:jobs_in_oz/utils/text_style.dart';
import 'package:jobs_in_oz/utils/widgets.dart';

import '../../utils/dialog_helper.dart';

class PasswordProfile extends StatefulWidget {
  const PasswordProfile({Key? key}) : super(key: key);

  @override
  _PasswordProfileState createState() => _PasswordProfileState();
}

class _PasswordProfileState extends State<PasswordProfile> {

  final NewPasswordController passController = Get.put(NewPasswordController(), permanent: true);
  TextEditingController oldPassForgotController = TextEditingController(text: "");
  TextEditingController newpASSController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
   final signOUTSeeker = Get.put(SignOutSeekerController());

  final String atLeastOneUpperCase = "(?=.*[A-Z])";
  final String atLeastOneNumeric = "(.*[0-9].*)";
 // final String withOutSpecialCharacters = "[^A-Za-z0-9]+";
  final String withOutSameNumberRepeatMoreThanThree = "([0-9])\\1\\1\\1";
  final String withOutSameAlphabetsRepeatMoreThanThree = "([a-zA-Z])\\1\\1\\1";


  passwordProfile() async {
    if(await InternetConnectionChecker().hasConnection)
{
  String oldpASSSeeker = oldPassForgotController.text;
  String newPassSeeker = newpASSController.text;
  final form = _formKey.currentState;
  if (form!.validate()) {
    form.save();
    GetStorage().write("old_pass", oldPassForgotController.text);
    GetStorage().write("new_pass", newpASSController.text);
    if (oldpASSSeeker.length < 3) {
      Get.snackbar("warning".tr, "enter_email".tr, colorText: Colors.white,backgroundColor: onboardingmaskColor );
    }
    else if(newPassSeeker.length < 3){
      Get.snackbar("warning".tr, "enter_pass".tr, colorText: Colors.white,backgroundColor: onboardingmaskColor );
    }
    else {
      var jsonData = {
        "old_password": oldPassForgotController.text,
        "new_password": newpASSController.text,
      };
      passController.passwordSeekerProfile(jsonData, showMyAlertDialog);
    }
  }
}else{
      print("no internet connection ");
      Get.snackbar("warning".tr, "Please check your internet connection!", colorText: Colors.white,backgroundColor: onboardingmaskColor);

    }

  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      } ,
                      child: SvgPicture.asset(crossClose, color: onboardingmaskColor, height: 30,)),
                ),
                Padding(padding: EdgeInsets.only(bottom: 6),
                    child: headingForm("pass_heading".tr, FontWeight.w700, onboardingmaskColor, 20))

              ],
            ),
            automaticallyImplyLeading: false,
          ),
          body: Obx((){
            return SingleChildScrollView(
              child: Container(
                height: Get.height,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: headingForm("enter_pass_sub_heading".tr, FontWeight.w400, onboardingmaskColor, 14),),
                        SizedBox(height: 32),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: TextFormField(
                                        cursorColor: basicAppColor,
                                        controller: oldPassForgotController,
                                        style: TextStyles.appTextStyle(fontSize: textSizeSMedium),
                                        obscureText: passController.showPassValue.value,
                                        validator: (val) {
                                          if (val!.length < 3) {
                                            return ("Password length too short");
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(24, 18, 0, 18),
                                            hintText: "Enter Old Password",
                                            hintStyle: TextStyles.appTextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: grey_Input_dark ),
                                            filled: true,
                                            fillColor: grey_Input,
                                            prefixIcon: Container(
                                                margin: EdgeInsets.only(left: 22.33, top: 22, bottom: 22, right: 0),
                                                child: SvgPicture.asset(lockPassword, width: 13.33, height: 16,)
                                            ),
                                            suffixIcon: IconButton(
                                                onPressed:() {
                                                  passController.isShowPass(!passController.showPassValue.value);
                                                },
                                                icon:passController.showPassValue.value == false ? SvgPicture.asset(eyeIcon, height: 20, color: purple_sign_in,):Icon(Icons.visibility_off,color: purple_sign_in)

                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: const BorderSide(color:  Colors.transparent, width: 1.0 ,),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: const BorderSide(color:  Colors.transparent, width: 1.0 ,),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide:const BorderSide(color:  Colors.transparent, width: 1.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: const BorderSide(color:  Colors.transparent, width: 1.0),
                                            )
                                        )
                                    )
                                ),
                                SizedBox(height: 20),
                                Container(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: TextFormField(
                                        cursorColor: basicAppColor,
                                        controller: newpASSController,
                                        style: TextStyles.appTextStyle(fontSize: textSizeSMedium),
                                        obscureText: passController.showValue.value,
                                        validator: (val) {
                                          if (val!.length < 10 || val.length > 32
                                              || !RegExp(atLeastOneUpperCase).hasMatch(val)
                                              || !RegExp(atLeastOneNumeric).hasMatch(val)
                                              // || RegExp(withOutSpecialCharacters).hasMatch(val)
                                              || RegExp(withOutSameAlphabetsRepeatMoreThanThree,).hasMatch(val)
                                              || RegExp(withOutSameNumberRepeatMoreThanThree,).hasMatch(val)
                                              || isASequence(val)
                                          ){
                                            if(val.length < 10 || val.length > 32){

                                              print("good error -1");
                                              return ("Please add minimum 10 to 32 characters");
                                            }else if( !RegExp(atLeastOneUpperCase).hasMatch(val)){

                                              print("good error 0");
                                              return ("Please add at-least one UpperCase character");
                                            }else if(!RegExp(atLeastOneNumeric).hasMatch(val)){

                                              print("good error 1");
                                              return ("Please add at-least one digit");
                                            }/*else if(RegExp(withOutSpecialCharacters).hasMatch(val)){

                                              print("good error 2");
                                              return ("Please remove any special character");
                                            }*/else if(RegExp(withOutSameAlphabetsRepeatMoreThanThree,).hasMatch(val)){

                                              print("good error 3");
                                              return ("Please do not add one character consecutively three times");
                                            }else if(RegExp(withOutSameNumberRepeatMoreThanThree,).hasMatch(val)){
                                              print("good error 4");
                                              return ("Please do not add one digit consecutively three times");
                                            }else if(isASequence(val)){
                                              print("good error 5");
                                              return ("Please do not add four consecutive digits or characters");
                                            }
                                            print("good error final ");
                                            return ("condition not fulfilled ");
                                          }else{
                                            print("good");
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(24, 18, 0, 18),
                                            hintText: "Enter New Password",
                                            hintStyle: TextStyles.appTextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: grey_Input_dark ),
                                            filled: true,
                                            fillColor: grey_Input,
                                            prefixIcon: Container(
                                                margin: EdgeInsets.only(left: 22.33, top: 22, bottom: 22, right: 0),
                                                child: SvgPicture.asset(lockPassword, width: 13.33, height: 16,)
                                            ),
                                            suffixIcon: IconButton(
                                                onPressed:() {
                                                  passController.isSPass(!passController.showValue.value);
                                                },
                                                icon:passController.showValue.value == false ? SvgPicture.asset(eyeIcon, height: 20, color: purple_sign_in,):Icon(Icons.visibility_off,color: purple_sign_in)

                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: const BorderSide(color:  Colors.transparent, width: 1.0 ,),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: const BorderSide(color:  Colors.transparent, width: 1.0 ,),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide:const BorderSide(color:  Colors.transparent, width: 1.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6),
                                              borderSide: const BorderSide(color:  Colors.transparent, width: 1.0),
                                            )
                                        )
                                    )
                                )
                              ],
                            )
                        ),
                      ],
                    ),
                    Positioned(
                        bottom: 150,
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 20),
                            child: shadowButton_('change_pass'.tr, this.passwordProfile, Get.width-40, basicBtnColr ))

                    )
                  ],
                ),
              ),
            );
          })
      ),
    );
  }

  showMyAlertDialog(bool value){
    DialogHelper().showCustomDialog(context, "you_have_been_logged_out".tr, "ok".tr, Icons.info_outline_rounded,
        'Important Information', "You need to sign in with your new password",
            (bool valuee) {
              signOUTSeeker.removeData();
          // GetStorage().remove("myUser");
          // GetStorage().remove("access_token");
          // GetStorage().remove("profile_image");
        });
  }
  bool checkSequence(x,y,i) => x+i == y;

  bool isNumeric(stringChar) =>  ((num.tryParse(stringChar)) != null);

  bool isASequence(String inputValue){
    bool isASequence = false;
    if(inputValue.isNotEmpty){
      for(int i = 0; i < inputValue.length - 3; i++){
        if(isNumeric(inputValue[i])){
          if(isNumeric(inputValue[i + 1]) && isNumeric(inputValue[i + 3])){
            if(checkSequence(int.parse(inputValue[i]), int.parse(inputValue[i+1]), 1) &&
                checkSequence(int.parse(inputValue[i]), int.parse(inputValue[i+2]), 2) &&
                checkSequence(int.parse(inputValue[i]), int.parse(inputValue[i+3]), 3) ){
              isASequence = true;
              break;
            }
          }
        }else {
          if(!isNumeric(inputValue[i + 1]) && !isNumeric(inputValue[i + 3])){
            if(checkSequence(inputValue.codeUnitAt(i), inputValue.codeUnitAt(i+1), 1) &&
                checkSequence(inputValue.codeUnitAt(i), inputValue.codeUnitAt(i+2), 2) &&
                checkSequence(inputValue.codeUnitAt(i), inputValue.codeUnitAt(i+3), 3) ){
              isASequence = true;
              break;
            }
          }
        }
      }
    }
    return isASequence;
  }

}





