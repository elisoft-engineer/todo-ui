import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/styles.dart';
import 'package:todo/core/services.dart';
import 'package:todo/components/app_bar.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key, required this.title});
  final String title;

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> signin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await APIService.post('token/', {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      }, auth: false);
      setState(() {
        isLoading = false;
      });
      if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['error']['non_field_errors'].join(', ')),
            backgroundColor: CustomColors.error,
          ),
        );
        return;
      } else if (response.containsKey('app_error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An error occured"),
            backgroundColor: CustomColors.error,
          ),
        );
        return;
      } else if (response.containsKey('Server')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Server is having issues"),
            backgroundColor: CustomColors.error,
          ),
        );
        return;
      } else {
        final String accessToken = response['access'];
        final String refreshToken = response['refresh'];
        final String id = response['id'];
        final String email = response['email'];
        final String firstName = response['first_name'];
        final String lastName = response['last_name'];
        bool isActive = response['is_active'];
        bool isStaff = response['is_staff'];

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('access_token', accessToken);
        prefs.setString('refresh_token', refreshToken);
        prefs.setString('id', id);
        prefs.setString('email', email);
        prefs.setString('first_name', firstName);
        prefs.setString('last_name', lastName);
        prefs.setBool('is_active', isActive);
        prefs.setBool('is_staff', isStaff);

        Navigator.of(context).pushReplacementNamed("todo");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Signed in as $email"),
            backgroundColor: CustomColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: CustomColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: "Sign In"),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                Text(
                  "Sign in to continue",
                  style: CustomTextStyles.h3.copyWith(
                    color: CustomColors.textColor,
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    style: CustomTextStyles.b3.copyWith(
                      color: CustomColors.textColor,
                    ),
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.textColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.textColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.textColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    obscureText: true,
                    style: CustomTextStyles.b3,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.textColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.textColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.textColor),
                      ),
                    ),
                  ),
                ),
                isLoading
                    ? SizedBox(
                      width: 35,
                      height: 35,
                      child: const CircularProgressIndicator(),
                    )
                    : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 35,
                      child: ElevatedButton(
                        onPressed: signin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primaryColor,
                          foregroundColor: CustomColors.background,
                        ),
                        child: Text("Sign In", style: CustomTextStyles.b2),
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
