import 'package:flutter/material.dart';
import 'form_widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

void main() async {
  try {
    var url = Uri.http('192.168.1.212:8080', '/helloworld');
    print(url.port);
    var response = await http.get(url);
    print(response.body);
    print('Response status: ${response.statusCode}');
  } catch (_) {
    print(_);
  }
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
      home: const Scaffold(
        backgroundColor: Color(0xFF2196F3),
        body: Center(
          child: LoginPage(title: 'Flutter Demo Home Page'),
        ),
      ),
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

  final int _containerSpeedAnimation = 200;
  static const double _loginContainerHeight = 363;
  static const double _signUpContainerHeight = 410;
  static const double _forgotPassContainerHeight = 278;
  double _containerHeight = _loginContainerHeight;

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
          _containerHeight = _signUpContainerHeight;
        } else {
          Future.delayed(const Duration(milliseconds: 300), () {
            _containerHeight = _loginContainerHeight;
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
            _containerHeight = _forgotPassContainerHeight;
          });
        } else {
          _containerHeight = _loginContainerHeight;
        }
      } else {
        _loginToPassCtrl.reverse();
        _formElementsOpct = 1;
        _animationStep = 0;
      }
    });
  }

  bool _isPasswordWrong = false;
  bool _isSecondPasswordWrong = false;
  bool _isEmailWrong = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass1 = TextEditingController();
  final TextEditingController _pass2 = TextEditingController();

  IconData eyeIcon = Icons.visibility;
  bool _isVisible = true;
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
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            if (eyeIcon == Icons.visibility) {
              eyeIcon = Icons.visibility_off;
              _isVisible = false;
            } else {
              eyeIcon = Icons.visibility;
              _isVisible = true;
            }
          });
        },
        icon: Icon(
          eyeIcon,
          color: Colors.blue,
        ),
      ),
      hintText: "password",
      hintStyle: const TextStyle(color: Colors.blue),
      filled: true,
      fillColor: Colors.blue[50],
    );
  }

  TextFormField passwordInput(TextEditingController pass) {
    return TextFormField(
      obscureText: _isVisible,
      controller: pass,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: passwordDecoration(),
      onChanged: (value) {
        if (validatePass(value)) {
          if (_isPasswordWrong) {
            setState(() {
              _containerHeight -= 17;
              _isPasswordWrong = false;
            });
          }
        } else {
          if (!_isPasswordWrong) {
            setState(() {
              _containerHeight += 17;
              _isPasswordWrong = true;
            });
          }
        }
      },
      validator: (String? value) {
        if (validatePass(value!)) {
          return null;
        } else {
          return "invalid password";
        }
      },
    );
  }

  TextFormField repeatPasswordInput(TextEditingController passToCheck) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: passwordDecoration(),
      onChanged: (value) {
        if (passToCheck.text == value) {
          setState(() {
            if (_isSecondPasswordWrong) {
              _containerHeight -= 17;
            }
            _isSecondPasswordWrong = false;
          });
        } else {
          if (passToCheck.text != value) {}
          setState(() {
            if (!_isSecondPasswordWrong) {
              _containerHeight += 17;
            }
            _isSecondPasswordWrong = true;
          });
        }
      },
      validator: (String? value) {
        if (passToCheck.text == value) {
          return null;
        } else {
          return "passwords are different";
        }
      },
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: emailDecoration(),
      onChanged: (value) {
        if (EmailValidator.validate(value)) {
          setState(() {
            if (_isEmailWrong) {
              _containerHeight -= 17;
              _isEmailWrong = false;
            }
          });
        } else if (!_isEmailWrong) {
          setState(() {
            _containerHeight += 17;
            _isEmailWrong = true;
          });
        }
      },
      validator: (String? value) {
        if (EmailValidator.validate(value!)) {
          return null;
        } else {
          return "invalid email";
        }
      },
    );
  }

  List<Widget> initForgotPass() {
    return [
      animationWrapper(header("Let us recover your password")),
      formWhiteSpace(20),
      animationWrapper(emailInput()),
      formWhiteSpace(10),
      animationWrapper(
        SizedBox(
          width: 300,
          child: InkWell(
            onTap: () {
              if (_loginToPassCtrl.isAnimating ||
                  _loginToSignUpCtrl.isAnimating) {
              } else {
                loginToRecoverPassAnim();
              }
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
      animationWrapper(ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              print(
                  "sign : $_isSigningIn, sign up $_isSigningUp, recover pass: $_isRecoveringPass");
              //pass1.dispose();
              //pass2.dispose();
              //Server code
            }
          },
          child: const Text("Send reset email"),
          style: ElevatedButton.styleFrom(minimumSize: const Size(310, 40))))
    ];
  }

  List<Widget> initLoginForm() {
    return [
      animationWrapper(header("Welcome back")),
      formWhiteSpace(20),
      animationWrapper(emailInput()),
      formWhiteSpace(10),
      animationWrapper(passwordInput(_pass1)),
      formWhiteSpace(5),
      animationWrapper(
        SizedBox(
          width: 300,
          child: InkWell(
            onTap: () {
              if (_loginToPassCtrl.isAnimating ||
                  _loginToSignUpCtrl.isAnimating) {
              } else {
                loginToRecoverPassAnim();
              }
            },
            child: const Text(
              "Recover password",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 15, color: Color(0xFF1E88E5)),
            ),
          ),
        ),
      ),
      formWhiteSpace(25),
      animationWrapper(
        ElevatedButton(
          onPressed: () {
            double space = spaceForAnimation(_email, _pass1);
            if (space > 0) {
              if ((_loginContainerHeight + space) > _containerHeight) {
                setState(
                  () {
                    _containerHeight += space;
                  },
                );
                Future.delayed(
                  Duration(milliseconds: _containerSpeedAnimation),
                  () {
                    if (_formKey.currentState!.validate()) {
                      print(
                          "sign : $_isSigningIn, sign up $_isSigningUp, recover pass: $_isRecoveringPass");
                      //pass1.dispose();
                      //pass2.dispose();
                      //Server code
                    }
                  },
                );
              }
            } else if (_formKey.currentState!.validate()) {
              print(
                  "sign : $_isSigningIn, sign up $_isSigningUp, recover pass: $_isRecoveringPass");

              //pass1.dispose();
              //pass2.dispose();
              //Server code
            }
          },
          child: const Text("Log in"),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(310, 40),
          ),
        ),
      ),
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
                if (_loginToPassCtrl.isAnimating ||
                    _loginToSignUpCtrl.isAnimating) {
                } else {
                  loginToSignUpAnim();
                }
              },
              child: const Text(
                "Sign up",
                style: TextStyle(color: Color(0xFF1E88E5)),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> initSignUpForm() {
    return [
      animationWrapper(header("Welcome")),
      formWhiteSpace(20),
      animationWrapper(emailInput()),
      formWhiteSpace(10),
      animationWrapper(passwordInput(_pass1)),
      formWhiteSpace(10),
      animationWrapper(repeatPasswordInput(_pass1)),
      formWhiteSpace(25),
      animationWrapper(ElevatedButton(
          onPressed: () {
            const double signUpContainerHeight = _signUpContainerHeight;
            double space = spaceForAnimation(_email, _pass1, _pass2);

            if (space > 0) {
              if ((signUpContainerHeight + space) > _containerHeight) {
                setState(
                  () {
                    _containerHeight += space;
                  },
                );
              }
              Future.delayed(
                Duration(milliseconds: _containerSpeedAnimation),
                () {
                  if (_formKey.currentState!.validate()) {
                    print(
                        "sign : $_isSigningIn, sign up $_isSigningUp, recover pass: $_isRecoveringPass");
                  }
                },
              );
            } else if (_formKey.currentState!.validate()) {
              print(
                  "sign : $_isSigningIn, sign up $_isSigningUp, recover pass: $_isRecoveringPass");
            }
          },
          child: const Text("Log in"),
          style: ElevatedButton.styleFrom(minimumSize: const Size(310, 40)))),
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
                if (_loginToPassCtrl.isAnimating ||
                    _loginToSignUpCtrl.isAnimating) {
                } else {
                  loginToSignUpAnim();
                }
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

  final _loginKey = GlobalKey<FormState>();
  final _signupKey = GlobalKey<FormState>();
  final _recoverPassKey = GlobalKey<FormState>();
  late GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    if (_isSigningIn) {
      _formKey = _loginKey;
      formFields = initLoginForm();
    } else if (_isRecoveringPass) {
      _formKey = _recoverPassKey;
      formFields = initForgotPass();
    } else if (_isSigningUp) {
      _formKey = _signupKey;
      formFields = initSignUpForm();
    }

    Column col = Column(children: formFields);

    return AnimatedContainer(
      duration: Duration(milliseconds: _containerSpeedAnimation),
      height: _containerHeight,
      width: 360,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Form(
        key: _formKey,
        child: col,
      ),
    );
  }
}
