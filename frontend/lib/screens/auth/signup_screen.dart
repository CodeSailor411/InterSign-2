import 'package:flutter/material.dart';
import 'package:inter_sign/widgets/auth_info_card.dart';
import 'package:inter_sign/widgets/logo_widget.dart';

import '../../services/auth_service.dart';
import '../../utils/responsive.dart';
import '../../utils/show_toast.dart';
import '../../widgets/form_container.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final auth = AuthService();

  bool passwordsMatch = true;
  bool _isSigningUp = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordsMatch);
    _confirmPasswordController.addListener(_checkPasswordsMatch);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _areFieldsFilled() {
    return _firstNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive button size
    double buttonWidth = screenWidth * 0.8;
    double buttonHeight = screenHeight * 0.07;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SafeArea(
              child: Row(
                children: [
                  /// Left section
                  Expanded(
                    flex: isDesktop
                        ? 6
                        : isTablet
                            ? 5
                            : 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: isDesktop
                              ? screenWidth * 0.45
                              : isTablet
                                  ? screenWidth * 0.4
                                  : screenWidth * 0.35,
                          height: isDesktop
                              ? screenHeight * 0.85
                              : isTablet
                                  ? screenHeight * 0.75
                                  : screenHeight * 0.65,
                          child: Card(
                            color: Theme.of(context).cardColor,
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(4.0), // Rounded corners
                            ),
                            child: Column(
                              children: [
                                /// Logo
                                const LogoWidget(),

                                /// Text
                                Flexible(
                                  child: Text(
                                    "Sign Up",
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                ),

                                /// Form
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 30, right: 30),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      FormContainerWidget(
                                        labelText: "FIRST NAME",
                                        hintText: "John",
                                        isPasswordField: false,
                                        controller: _firstNameController,
                                        onChanged: (value) => setState(() {}),
                                      ),
                                      FormContainerWidget(
                                        labelText: "EMAIL ADDRESS",
                                        hintText: "johndoe@example.com",
                                        isPasswordField: false,
                                        controller: _emailController,
                                        onChanged: (value) => setState(() {}),
                                      ),
                                      FormContainerWidget(
                                        labelText: "PASSWORD",
                                        hintText: "********",
                                        isPasswordField: true,
                                        controller: _passwordController,
                                        onChanged: (value) => setState(() {}),
                                      ),
                                      Visibility(
                                        visible: !passwordsMatch,
                                        child:
                                            const Text("Passwords do no match!",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13)),
                                      ),
                                      FormContainerWidget(
                                        labelText: "CONFIRM PASSWORD",
                                        hintText: "********",
                                        isPasswordField: true,
                                        controller: _confirmPasswordController,
                                        onChanged: (value) => setState(() {}),
                                      ),
                                    ],
                                  ),
                                ),

                                const Spacer(),

                                /// Buttons
                                Center(
                                  child: SizedBox(
                                    width: buttonWidth * 0.48,
                                    height: buttonHeight * 1.2,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_areFieldsFilled()) {
                                            _signUp();
                                          } else {
                                            if (mounted) {
                                              ToastUtil.showErrorToast(context,
                                                  message:
                                                      "Provide name, email and password!");
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _areFieldsFilled()
                                              ? Colors.black
                                              : Colors.grey,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: _isSigningUp
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      "SIGN UP",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Flexible(
                                      child: Text(
                                        "Already have an account?",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                              (route) => false);
                                        },
                                        child: Text(
                                          "LOGIN",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Right section
                  if (!isMobile)
                    Expanded(
                      flex: isDesktop ? 6 : 5,
                      child: const AuthInfoCard(),
                    ),
                ],
              ),
            ),
            if (_isSigningUp)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _checkPasswordsMatch() {
    setState(() {
      passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  Future<void> _signUp() async {
    String firstName = _firstNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _isSigningUp = true;
    });

    bool isAuthenticated =
        await auth.register(name: firstName, email: email, password: password);

    if (mounted) {
      if (isAuthenticated) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
              const LoginScreen(),
            ),
                (route) => false);
      }

      setState(() {
        _isSigningUp = false;
      });

      if (!isAuthenticated) {
        ToastUtil.showErrorToast(context, message: "Error!");
      }
    }
  }
}
