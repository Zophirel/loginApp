import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

double spaceForAnimation(TextEditingController email,
    [TextEditingController? pw, TextEditingController? pw2]) {
  bool p1 = (pw == null) ? false : true;
  bool p2 = (pw2 == null) ? false : true;

  double space = 0;
  if (!EmailValidator.validate(email.text)) {
    space += 9;
  }
  if (p1) {
    if (!validatePass(pw.text)) {
      if (p2 == true) {
        return space += 9 * 2;
      } else {
        return space += 9;
      }
    }
  }
  return space;
}

Text header(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
  );
}

SizedBox formWhiteSpace(double h) {
  return SizedBox(
    height: h,
  );
}

bool validatePass(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

InputDecoration emailDecoration() {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(5.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(5.5),
    ),
    prefixIcon: const Icon(
      Icons.email,
      color: Colors.blue,
    ),
    hintText: "email",
    hintStyle: const TextStyle(color: Colors.blue),
    filled: true,
    fillColor: Colors.blue[50],
  );
}

TextFormField emailInput(TextEditingController txtCtrl) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    controller: txtCtrl,
    decoration: emailDecoration(),
    validator: (String? value) {
      if (EmailValidator.validate(value!)) {
        return null;
      } else {
        return "invalid email";
      }
    },
  );
}

InputDecoration passwordDecoration() {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(5.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(5.5),
    ),
    prefixIcon: const Icon(
      Icons.password,
      color: Colors.blue,
    ),
    suffixIcon:
        IconButton(onPressed: () {}, icon: const Icon(Icons.visibility)),
    hintText: "password",
    hintStyle: const TextStyle(color: Colors.blue),
    filled: true,
    fillColor: Colors.blue[50],
  );
}

TextFormField passwordInput(
    {TextEditingController? currPass, TextEditingController? passToCheck}) {
  return TextFormField(
    controller: currPass,
    decoration: passwordDecoration(),
    validator: (String? value) {
      if (validatePass(value!)) {
        if (passToCheck != null) {
          if (passToCheck.text == value) {
            return null;
          } else {
            return "passwords do not match";
          }
        } else {
          return null;
        }
      } else {
        return "invalid password";
      }
    },
  );
}

Row forgotText(String text, Function inputanim, double whitespace) {
  return Row(
    children: [
      InkWell(
        child: const Text(
          "forgot password?",
        ),
        onTap: () {
          inputanim();
        },
      ),
      formWhiteSpace(whitespace),
    ],
  );
}

ElevatedButton submitBtn(String btnText, {IconData? btnIcon}) {
  return ElevatedButton(
      onPressed: () {},
      child: Text(btnText),
      style: ElevatedButton.styleFrom(minimumSize: const Size(310, 40)));
}
