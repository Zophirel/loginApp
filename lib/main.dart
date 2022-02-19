import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'form_widgets.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<Offset> _positionTransition = _controller
      .drive(CurveTween(curve: Curves.easeInOut))
      .drive(Tween<Offset>(
          begin: const Offset(0.0, 0.0), end: const Offset(0.0, 0.1)));

  double _opct = 1;
  bool _is_signing_in = true;
  bool _rev = false;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //Future.delayed(const Duration(milliseconds: 0), () {
          _is_signing_in = !_is_signing_in;
          _rev = !_rev;
          inputanim();
          //});
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  SlideTransition animationWrapper(Widget elem) {
    return SlideTransition(
        position: _positionTransition,
        child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _opct,
            child: SizedBox(width: 300, child: elem)));
  }

  void inputanim() {
    setState(() {
      if (!_rev) {
        _controller.forward();
        _opct = 0;
      } else {
        _controller.reverse();
        _opct = 1;
        _rev = !_rev;
      }
    });
  }

  List<Widget> initForgotPass() {
    return [
      animationWrapper(header("Let us recover your password")),
      formWhiteSpace(20),
      animationWrapper(formInput("email")),
      formWhiteSpace(10),
      animationWrapper(InkWell(
        child: Text("remember?"),
        onTap: () {
          inputanim();
        },
      )),
      formWhiteSpace(15),
      submitBtn(Icons.arrow_forward)
    ];
  }

  List<Widget> initLoginForm() {
    return [
      animationWrapper(header("Login")),
      formWhiteSpace(20),
      animationWrapper(formInput("email")),
      formWhiteSpace(10),
      animationWrapper(formInput("password")),
      formWhiteSpace(10),
      animationWrapper(InkWell(
        child: const Text("forgot?"),
        onTap: () {
          inputanim();
        },
      )),
      formWhiteSpace(15),
      submitBtn(Icons.arrow_forward)
    ];
  }

  List<Widget> formFields = [];

  @override
  Widget build(BuildContext context) {
    if (_is_signing_in) {
      formFields = initLoginForm();
    } else {
      formFields = initForgotPass();
    }

    Column col = Column(children: formFields);

    return Scaffold(
        backgroundColor: Colors.blue[600],
        body: Center(
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 290,
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: col)));
  }
}
