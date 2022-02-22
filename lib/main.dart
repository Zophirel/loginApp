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
  late AnimationController _loginToPassCtrl;
  late AnimationController _loginToSignUpCtrl;
  late final Animation<Offset> _positionTransition;

  double _containerHeight = 364;
  double _formElementsOpct = 1;
  int _animationStep = 0;
  bool _isSigningIn = true;
  bool _isSigningUp = false;
  bool _isRecoveringPass = false;

  @override
  void initState() {
    _loginToPassCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _isSigningIn = !_isSigningIn;
          _isRecoveringPass = !_isRecoveringPass;
          _animationStep = 1;
          loginToRecoverPassAnim();
        }
      });

    _loginToSignUpCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _isSigningIn = !_isSigningIn;
          _isSigningUp = !_isSigningUp;
          _animationStep = 1;
          loginToSignUpAnim();
        }
      });

    _positionTransition = _loginToPassCtrl
        .drive(CurveTween(curve: Curves.easeInOut))
        .drive(Tween<Offset>(
            begin: const Offset(0.0, 0.0), end: const Offset(0.0, 0.1)));

    super.initState();
  }

  @override
  void dispose() {
    _loginToSignUpCtrl.dispose();
    _loginToPassCtrl.dispose();
    super.dispose();
  }

  SlideTransition animationWrapper(Widget child) {
    return SlideTransition(
        position: _positionTransition,
        child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _formElementsOpct,
            child: SizedBox(child: child)));
  }

  void loginToSignUpAnim() {
    setState(() {
      if (_animationStep == 0) {
        _loginToSignUpCtrl.forward();
        _formElementsOpct = 0;
        if (_isSigningIn) {
          _containerHeight = 406;
        } else {
          Future.delayed(const Duration(milliseconds: 300), () {
            _containerHeight = 364;
          });
        }
      } else {
        _loginToSignUpCtrl.reverse();
        _formElementsOpct = 1;
        _animationStep = 0;
      }
    });
  }

  void loginToRecoverPassAnim() {
    setState(() {
      if (_animationStep == 0) {
        _loginToPassCtrl.forward();
        _formElementsOpct = 0;
        if (_isSigningIn) {
          Future.delayed(const Duration(milliseconds: 300), () {
            _containerHeight = 278;
          });
        } else {
          _containerHeight = 364;
        }
      } else {
        _loginToPassCtrl.reverse();
        _formElementsOpct = 1;
        _animationStep = 0;
      }
    });
  }

  List<Widget> initForgotPass() {
    return [
      animationWrapper(header("Let us recover your password")),
      formWhiteSpace(20),
      animationWrapper(formInput("email")),
      formWhiteSpace(10),
      animationWrapper(
        SizedBox(
          width: 300,
          child: InkWell(
            onTap: () {
              loginToRecoverPassAnim();
            },
            child: const Text(
              "Have you remembered?",
              textAlign: TextAlign.right,
              style: TextStyle(color: Color(0xFF1E88E5)),
            ),
          ),
        ),
      ),
      formWhiteSpace(15),
      animationWrapper(submitBtn("Send reset email")),
    ];
  }

  List<Widget> initLoginForm() {
    return [
      animationWrapper(header("Welcome back")),
      formWhiteSpace(20),
      animationWrapper(formInput("email")),
      formWhiteSpace(10),
      animationWrapper(formInput("password")),
      formWhiteSpace(5),
      animationWrapper(
        SizedBox(
            width: 300,
            child: InkWell(
              onTap: () {
                loginToRecoverPassAnim();
              },
              child: const Text(
                "Recover password",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 15, color: Color(0xFF1E88E5)),
              ),
            )),
      ),
      formWhiteSpace(25),
      animationWrapper(submitBtn("Log in")),
      formWhiteSpace(25),
      animationWrapper(
        Row(
          children: [
            const SizedBox(width: 45),
            const Text(
              "Don't have an account yet?",
            ),
            const SizedBox(width: 5),
            InkWell(
              onTap: () {
                loginToSignUpAnim();
              },
              child: const Text(
                "Sign up",
                style: TextStyle(color: Color(0xFF1E88E5)),
              ),
            ),
          ],
        ),
      )
    ];
  }

  List<Widget> initSignUpForm() {
    return [
      animationWrapper(header("Welcome")),
      formWhiteSpace(20),
      animationWrapper(formInput("email")),
      formWhiteSpace(10),
      animationWrapper(formInput("password")),
      formWhiteSpace(10),
      animationWrapper(formInput("repeat password")),
      formWhiteSpace(25),
      animationWrapper(submitBtn("Sign Up")),
      formWhiteSpace(25),
      animationWrapper(
        Row(
          children: [
            const SizedBox(width: 45),
            const Text(
              "Already have an account?",
            ),
            const SizedBox(width: 5),
            InkWell(
              onTap: () {
                loginToSignUpAnim();
              },
              child: const Text(
                "Sign in",
                style: TextStyle(color: Color(0xFF1E88E5)),
              ),
            ),
          ],
        ),
      )
    ];
  }

  List<Widget> formFields = [];

  @override
  Widget build(BuildContext context) {
    print(
        "login: $_isSigningIn, recover: $_isRecoveringPass, signup: $_isSigningUp");
    if (_isSigningIn) {
      formFields = initLoginForm();
    } else if (_isRecoveringPass) {
      formFields = initForgotPass();
    } else if (_isSigningUp) {
      formFields = initSignUpForm();
    }

    Column col = Column(children: formFields);

    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: Center(
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _containerHeight,
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: col),
      ),
    );
  }
}
