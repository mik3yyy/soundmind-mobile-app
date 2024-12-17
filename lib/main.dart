import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sound_mind/core/routes/routes.dart';
import 'package:sound_mind/core/services/injection_container.dart' as di;
import 'package:sound_mind/core/services/injection_container.dart';
import 'package:sound_mind/core/theme/theme.dart';
import 'package:sound_mind/features/Authentication/presentation/blocs/Authentication_bloc.dart';
import 'package:sound_mind/features/Authentication/presentation/blocs/change_password/change_password_cubit.dart';
import 'package:sound_mind/features/Authentication/presentation/blocs/cubit/resend_otp_cubit.dart';
import 'package:sound_mind/features/Authentication/presentation/blocs/update_user/update_user_cubit.dart';
import 'package:sound_mind/features/Security/presentation/blocs/Security_bloc.dart';
import 'package:sound_mind/features/Security/presentation/blocs/change_pin/change_pin_cubit.dart';
import 'package:sound_mind/features/appointment/domain/usecases/get_pending_appointment.dart';
import 'package:sound_mind/features/appointment/presentation/blocs/appointment_bloc.dart';
import 'package:sound_mind/features/appointment/presentation/blocs/booking/booking_cubit.dart';
import 'package:sound_mind/features/appointment/presentation/blocs/doctor/doctor_cubit.dart';
import 'package:sound_mind/features/appointment/presentation/blocs/doctor_details/doctor_details_cubit.dart';
import 'package:sound_mind/features/appointment/presentation/blocs/get_accepted_appointments/get_accepted_appointments_cubit.dart';
import 'package:sound_mind/features/appointment/presentation/blocs/get_pending_appointments/get_pending_appointments_cubit.dart';
import 'package:sound_mind/features/appointment/presentation/blocs/get_rejected_appointments/get_rejected_appointments_cubit.dart';
import 'package:sound_mind/features/appointment/presentation/blocs/payment/payment_cubit.dart';
import 'package:sound_mind/features/appointment/presentation/blocs/physician_schedule/physician_schedule_cubit.dart';
import 'package:sound_mind/features/appointment/presentation/blocs/upcoming_appointment/upcoming_appointment_cubit.dart';
import 'package:sound_mind/features/chat/presentation/blocs/get_chat_room_messages/get_chat_room_messages_cubit.dart';
import 'package:sound_mind/features/chat/presentation/blocs/get_user_chat_rooms/get_user_chat_rooms_cubit.dart';
import 'package:sound_mind/features/notification/presentation/blocs/notification_bloc.dart';
import 'package:sound_mind/features/setting/presentation/blocs/setting_bloc.dart';
import 'package:sound_mind/features/wallet/presentation/blocs/get_bank_transactions/get_bank_transactions_cubit.dart';
import 'package:sound_mind/features/wallet/presentation/blocs/top_up/topup_wallet_cubit.dart';
import 'package:sound_mind/features/wallet/presentation/blocs/withdraw_to_bank/withdraw_to_bank_cubit.dart';
import 'package:sound_mind/features/wallet/presentation/blocs/get_bank/get_banks_cubit.dart';
import 'package:sound_mind/features/wallet/presentation/blocs/resolve_bank_account/resolve_bank_account_cubit.dart';
import 'package:sound_mind/features/wallet/presentation/blocs/wallet_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(
      fileName: '.env'); // Load environment variables from application folder
  await di.init(); // Initialize dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // l<AuthenticationBloc>(),
        BlocProvider(
          create: (context) => sl<AuthenticationBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<SecurityBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<SettingBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<AppointmentBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<DoctorCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<DoctorDetailsCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              sl<PhysicianScheduleCubit>(), //CreateBookingCubit
        ),
        BlocProvider(
          create: (context) =>
              sl<CreateBookingCubit>(), //UpcomingAppointmentCubit
        ),
        BlocProvider(
          create: (context) =>
              sl<UpcomingAppointmentCubit>(), //UpcomingAppointmentCubit
        ),
        BlocProvider(
          create: (context) => sl<WalletBloc>(), //UpcomingAppointmentCubit
        ),
        BlocProvider(
          create: (context) =>
              sl<WithdrawToBankCubit>(), //UpcomingAppointmentCubit
        ),
        BlocProvider(
          //ResendOtpCubit
          create: (context) => sl<GetBanksCubit>(), //UpcomingAppointmentCubit
        ),
        BlocProvider(
          //ResendOtpCubit
          create: (context) => sl<ResendOtpCubit>(), //UpcomingAppointmentCubit
        ),
        BlocProvider(
          create: (context) => sl<ResolveBankAccountCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<GetBankTransactionsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ChangePasswordCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<UpdateUserCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ChangePinCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ResolveBankAccountCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<TopUpCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<NotificationBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<PaymentCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<GetUserChatRoomsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<GetChatRoomMessagesCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<PendingAppointmentsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<AcceptedAppointmentsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<RejectedAppointmentsCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'sound_mind',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        darkTheme: darkTheme,
        routerConfig: Routes.router,
      ),
    );
  }
}
