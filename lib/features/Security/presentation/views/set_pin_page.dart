import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:sound_mind/core/extensions/context_extensions.dart';
import 'package:sound_mind/core/extensions/widget_extensions.dart';
import 'package:sound_mind/core/gen/assets.gen.dart';
import 'package:sound_mind/core/services/injection_container.dart';
import 'package:sound_mind/core/widgets/custom_button.dart';
import 'package:sound_mind/features/Security/presentation/blocs/Security_bloc.dart';
import 'package:sound_mind/features/Security/presentation/widgets/succesful_widget.dart';

class SetPinPage extends StatefulWidget {
  const SetPinPage({super.key});

  @override
  State<SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  TextEditingController _pinEditingController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SecurityBloc, SecurityState>(
        listener: (context, state) {
          if (state is AuthenticatedState) {
            showDialog(
                useSafeArea: false,
                context: context,
                builder: (context) => SuccessfulWidget());
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.application.assets.svgs.fi16973516.svg(),
            const Gap(10),
            AutoSizeText(
              "Create a PIN to secure your account",
              style: context.textTheme.displayMedium,
            ),
            AutoSizeText(
              "Create a Two-factor authentication for better security for your accounts, also helps you sign in faster ",
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colors.black,
              ),
            ),
            const Gap(20),
            SizedBox(
              height: 50,
              child: PinInputTextField(
                pinLength: 6,
                decoration: BoxLooseDecoration(
                  strokeColorBuilder: PinListenColorBuilder(
                      context.colors.greyOutline, context.colors.greyOutline),
                  bgColorBuilder: FixedColorBuilder(context.colors.greyOutline),
                  obscureStyle: ObscureStyle(
                    isTextObscure: true!,
                    obscureText: '●',
                  ),
                ),
                controller: _pinEditingController,
                textInputAction: TextInputAction.go,
                enabled: true,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.characters,
                onSubmit: (pin) {
                  debugPrint('submit pin:$pin');
                },
                onChanged: (pin) {
                  setState(() {});
                  debugPrint('onChanged execute. pin:$pin');
                },
                enableInteractiveSelection: false,
              ),
            ),
          ],
        ),
      ).withSafeArea().withCustomPadding(),
      bottomSheet: Container(
        height: 150,
        child: CustomButton(
          label: "Continue",
          enable: _pinEditingController.text.length == 6,
          onPressed: () async {
            context
                .read<SecurityBloc>()
                .add(SetPinEvent(pin: _pinEditingController.text));
          },
        ).toCenter(),
      ),
    );
  }
}
