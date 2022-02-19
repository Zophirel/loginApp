import 'package:flutter/material.dart';

Text header(String text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
  );
}

SizedBox formWhiteSpace(double h) {
  return SizedBox(
    height: h,
  );
}

TextFormField formInput(String type) {
  Widget icon = const Icon(Icons.person, color: Colors.blue);

  if (type == "password") {
    icon = const Icon(Icons.lock, color: Colors.blue);
  }

  return TextFormField(
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(5.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(5.5),
      ),
      prefixIcon: icon,
      hintText: type,
      hintStyle: const TextStyle(color: Colors.blue),
      filled: true,
      fillColor: Colors.blue[50],
    ),
    validator: (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your email';
      }
      return null;
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

ElevatedButton submitBtn(IconData btnIcon) {
  return ElevatedButton(
      onPressed: () {},
      child: Icon(btnIcon),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(50, 50),
        shape: const CircleBorder(),
      ));
}
