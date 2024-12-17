import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sound_mind/core/extensions/context_extensions.dart';
import 'package:sound_mind/core/extensions/widget_extensions.dart';
import 'package:sound_mind/core/gen/assets.gen.dart';
import 'package:sound_mind/core/routes/routes.dart';
import 'package:sound_mind/core/widgets/custom_text_button.dart';
import 'package:sound_mind/features/Authentication/data/models/User_model.dart';
import 'package:sound_mind/features/Authentication/presentation/blocs/Authentication_bloc.dart';
import 'package:sound_mind/features/setting/presentation/widgets/are_you_sure.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  toggleBiometrics() {
    var box = Hive.box('userBox');

    bool enableBiometrics = box.get("EB", defaultValue: true);

    enableBiometrics = !enableBiometrics;

    box.put('EB', enableBiometrics);
  }

  late bool enableBiometrics;
  var box = Hive.box('userBox');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    enableBiometrics = box.get("EB", defaultValue: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
        centerTitle: false,
        leading: BackButton(
          color: context.colors.black,
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              UserModel userModel = (state as UserAccount).user;
              return Column(
                children: [
                  SizedBox(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Personal details",
                          style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: context.primaryColor),
                        ),
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              context.goNamed(Routes.personal_detailsName);
                            },
                            icon: Icon(Icons.chevron_right_rounded)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: const Text("Name"),
                        subtitle: Text(
                            "${userModel.firstName} ${userModel.lastName}"),
                      ),
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: const Text("Email"),
                        subtitle: Text("${userModel.email} "),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text("Phone number"),
                        subtitle: Text("${userModel.phoneNumber}"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notification and Security",
                  style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: context.primaryColor),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Change PIN"),
            onTap: () {
              context.goNamed(Routes.change_pinName);
            },
            trailing: Icon(Icons.chevron_right_rounded),
          ),
          ListTile(
            leading: Icon(Icons.fingerprint),
            title: const Text("Enable Biometrics"),
            trailing: IconButton(
                onPressed: () {
                  toggleBiometrics();
                  setState(() {});
                },
                icon: Icon(
                  box.get("EB", defaultValue: true) == true
                      ? Icons.toggle_on
                      : Icons.toggle_off,
                ),
                color: box.get("EB", defaultValue: true) == true
                    ? context.colors.green
                    : context.colors.borderGrey),
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text("Change Password"),
            trailing: IconButton(
              onPressed: () {
                context.goNamed(Routes.change_passwordName);
              },
              icon: const Icon(
                Icons.chevron_right,
              ),
            ),
          ),
          ListTile(
            leading: Assets.application.assets.images.logoPurple
                .image(height: 32, width: 32),
            title: const Text("About"),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.chevron_right,
              ),
            ),
          ),
        ],
      ).withSafeArea().withCustomPadding().withScrollView(),
      bottomNavigationBar: Container(
        height: 150,
        child: CustomTextButton(
          label: "Log out",
          onPressed: () {
            showLogoutConfirmationDialog(context);
          },
          textStyle: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.red,
            fontSize: 16,
          ),
        ).toCenter(),
      ),
    );
  }
}
