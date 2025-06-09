import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/components/notifications.dart';
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
        if (mounted) {
          CustomNotifications.showError(
            context,
            response['error']['non_field_errors'].join(', '),
          );
        }
        return;
      } else if (response.containsKey('app_error')) {
        if (mounted) {
          CustomNotifications.showError(
            context,
            response['app_error'].toString(),
          );
        }
        return;
      } else if (response.containsKey('Server')) {
        if (mounted) {
          CustomNotifications.showError(context, "Server is having issues");
        }
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

        if (mounted) {
          Navigator.of(context).pushReplacementNamed("tasks");
          CustomNotifications.showSuccess(context, "Signed in as $email");
        }
      }
    } catch (e) {
      if (mounted) {
        CustomNotifications.showError(context, 'An error occured');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: TopBar(title: "Sign In"),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Text("Sign in to continue", style: CustomTextStyles.h2),
                    SizedBox(
                      height: 45,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        style: CustomTextStyles.b2,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: true,
                        style: CustomTextStyles.b1,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.inversePrimary,
                            ),
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
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                            ),
                            child: Text("Sign In", style: CustomTextStyles.b2),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
