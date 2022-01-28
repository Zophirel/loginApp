import 'package:flutter/material.dart';

void main() => runApp(const MyLogin());

class MyLogin extends StatelessWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: StatefulLogin(),
      ),
    );
  }
}

class StatefulLogin extends StatefulWidget {
  const StatefulLogin({Key? key}) : super(key: key);

  @override
  State<StatefulLogin> createState() => _StatefulLoginState();
}

class _StatefulLoginState extends State<StatefulLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  ElevatedButton formSubmitBtn() {
    return ElevatedButton(
        onPressed: () {
          // Validate will return true if the form is valid, or false if
          // the form is invalid.
          if (_formKey.currentState!.validate()) {
            print(emailCtrl.text);
            print(passCtrl.text);
          }
        },
        child: const Icon(Icons.arrow_forward_sharp),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(50, 50),
          shape: const CircleBorder(),
        ));
  }

  TextFormField formLoginInput(String type, TextEditingController ctrl) {
    Icon inputIcon = const Icon(Icons.person, color: Colors.blue);
    String ph = "E-mail";
    String errMsg = "Inserire una mail valida";
    bool isItPass = false;

    if (type == "password") {
      inputIcon = const Icon(Icons.lock, color: Colors.blue);
      ph = "Password";
      errMsg = "Inserire una password valida";
      isItPass = true;
    }

    return TextFormField(
      controller: ctrl,
      obscureText: isItPass,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(5.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(5.5),
        ),
        prefixIcon: inputIcon,
        hintText: ph,
        hintStyle: const TextStyle(color: Colors.blue),
        filled: true,
        fillColor: Colors.blue[50],
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return errMsg;
        }
        return null;
      },
    );
  }

  Column formElements() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: const [
            Text(
              "Login",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(height: 20),
        formLoginInput("email", emailCtrl),
        const SizedBox(height: 20),
        formLoginInput("password", passCtrl),
        const SizedBox(height: 20),
        formSubmitBtn(),
      ],
    );
  }

  Container formCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      height: 320,
      width: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: formElements(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(key: _formKey, child: Center(child: formCard()));
  }
}
