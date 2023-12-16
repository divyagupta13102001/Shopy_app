// ignore_for_file: avoid_print,unused_import, unused_field

import 'dart:math';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/my_exceptions.dart';
import '../providers/auth.dart';

enum AuthMode { signUp, logIn }

// ignore: use_key_in_widget_constructors
class AuthScreen extends StatelessWidget {
  static const String routeName = '/auth_screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            // ignore: sized_box_for_whitespace
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 94,
                      ),
                      // transform: Matrix4.rotationZ(-8 * pi / 180)
                      //   ..translate(-10, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: const Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.logIn;

  // ignore: prefer_final_fields
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  // ANIMATION WORKS
  //////********************************//////
  AnimationController? _controller;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;

  //////********************************//////

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1.0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );
    // _heightAnimation?.addListener(() {
    //   setState(() {});
    // });
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeIn),
    );
    super.initState();
  }

  @override
  void dispose() {
    // _heightAnimation?.removeListener(() {
    //   setState(() {});
    // });
    _controller?.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (
          ctx,
        ) {
          return AlertDialog(
            title: const Text(
              'An Error Occurred',
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          );
        });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    final auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    try {
      if (_authMode == AuthMode.logIn) {
        await auth.logIn(
          _authData['email'] as String,
          _authData['password'] as String,
        );
      } else {
        await auth.signUp(
          _authData['email'] as String,
          _authData['password'] as String,
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      final err = error.toString();

      if (err.contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (err.contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (err.contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (err.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a User with that email';
      } else if (err.contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      final errorMessage =
          'Could not Authenticate you pls try again later ${error.toString()}';
      print(error);
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.logIn) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.logIn;
      });
      _controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.signUp ? 340 : 280,
        // height: _heightAnimation?.value.height,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.signUp ? 340 : 280,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.toString().isEmpty ||
                        !value.toString().contains('@')) {
                      return 'invalid Email Address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value.toString();
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.toString().isEmpty ||
                        value.toString().length < 5) {
                      return 'Password Length is too short';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value.toString();
                  },
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.signUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.signUp ? 120 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.signUp,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                        ),
                        obscureText: true,
                        validator: _authMode == AuthMode.signUp
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Password does not match';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child:
                        Text(_authMode == AuthMode.logIn ? 'Login' : 'Sign up'),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _authMode == AuthMode.logIn
                        ? 'Sign Up Instead'
                        : 'Login Instead',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
