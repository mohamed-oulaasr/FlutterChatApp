// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app/layout/home_layout.dart';
import 'package:flutter_social_app/modules/login/cubit/cubit.dart';
import 'package:flutter_social_app/modules/login/cubit/states.dart';
import 'package:flutter_social_app/modules/register/register_screen.dart';
import 'package:flutter_social_app/shared/components/components.dart';
import 'package:flutter_social_app/shared/components/constants.dart';
import 'package:flutter_social_app/shared/network/local/cache_helper.dart';


class LoginScreen extends StatelessWidget
{
  var formKey = GlobalKey<FormState>();
  var emailController    = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state)
        {
          if(state is LoginErrorState)
          {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }
          if(state is LoginSuccessState)
          {
            CacheHelper.saveData(
                key: 'uId',
                value: state.uId,
            ).then((value)
            {
              uId = state.uId;
              navigateAndFinish(
                context,
                HomeLayout(),
              );
            });
          }
        },
        builder: (context, state)
        {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Login now to communicate with friends',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'please enter your email address';
                            }

                            return null;
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          isPassword: LoginCubit.get(context)!.isPassword,
                          suffix: LoginCubit.get(context)!.suffix,
                          suffixPressed: ()
                          {
                            LoginCubit.get(context)!.changePasswordVisibility();
                          },
                          onSubmit: (String? value)
                          {
                            if(formKey.currentState!.validate())
                            {
                              LoginCubit.get(context)!.userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'password is too short';
                            }

                            return null;
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => defaultButton(
                            function: ()
                            {
                              if(formKey.currentState!.validate())
                              {
                                LoginCubit.get(context)!.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: 'login',
                            isUpperCase: true,
                          ),
                          fallback: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          [
                            Text(
                              'Dont\'t have an account ?',
                            ),
                            defaultTextButton(
                              function: ()
                              {
                                navigateTo(
                                  context,
                                  RegisterScreen(),
                                );
                              },
                              text: 'Register',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
