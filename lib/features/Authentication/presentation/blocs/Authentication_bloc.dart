import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sound_mind/core/utils/typedef.dart';
import 'package:sound_mind/features/Authentication/data/models/User_model.dart';
import 'package:sound_mind/features/Authentication/domain/usecases/check_user.dart';
import 'package:sound_mind/features/Authentication/domain/usecases/create_account.dart';
import 'package:sound_mind/features/Authentication/domain/usecases/log_out.dart';
import 'package:sound_mind/features/Authentication/domain/usecases/login.dart';
import 'package:sound_mind/features/Authentication/domain/usecases/resend_otp.dart';
import 'package:sound_mind/features/Authentication/domain/usecases/verify_email.dart';

part 'Authentication_event.dart';
part 'Authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final CreateAccount createAccount;
  final VerifyEmail verifyEmail;
  final Login login;
  final LogOutUsecase logOutUsecase;
  final CheckUserUseCase checkUser;
  final ResendVerificationOtp resendVerificationOtp;

  AuthenticationBloc(
      {required this.createAccount,
      required this.verifyEmail,
      required this.logOutUsecase,
      required this.checkUser,
      required this.resendVerificationOtp,
      required this.login})
      : super(AuthenticationInitial()) {
    on<CreateAccountEvent>(_createAccountEventHandler);
    on<LoginEvent>(_loginEventtHandler);
    on<VerifyEmailEvent>(_verifyEmailHandler);
    on<CheckUser>(_checkUser);
    on<UpdateUser>(_updateuser);
    on<ResendOtpEvent>(_resendOtp); // Add this line

    on<LogoutEvent>(_logoutHandler);
  }
  _resendOtp(ResendOtpEvent event, Emitter emit) async {}

  _logoutHandler(LogoutEvent event, Emitter emit) async {
    var result = await logOutUsecase.call();
    emit(AuthenticationInitial());
  }

  _updateuser(UpdateUser event, Emitter emit) async {
    var result = await checkUser.call();

    result.fold((failure) {
      print(failure.message);
    }, (userModel) {
      emit(UserAccount(user: userModel));
    });
  }

  _checkUser(CheckUser event, Emitter emit) async {
    var result = await checkUser.call();

    result.fold((failure) {
      print(failure.message);
      emit(SetUserState());
    }, (userModel) {
      emit(UserAccount(user: userModel));
    });
  }

  _verifyEmailHandler(VerifyEmailEvent event, Emitter emit) async {
    emit(VerifingAccount(verificationData: event.verificationData));
    var result = await verifyEmail.call(VerifyEmailParams(
        otp: event.otp, securityKey: event.verificationData['data']));
    result.fold((failure) {
      print(failure.message);
      emit(VerifyingAccountError(
          message: failure.message, verificationData: event.verificationData));
    }, (user) {
      emit(UserAccount(user: user));
    });
  }

  _createAccountEventHandler(CreateAccountEvent event, Emitter emit) async {
    emit(CreatingAccount());
    var result = await createAccount.call(
      CreateAccountParams(
        email: event.email,
        password: event.password,
        gender: event.gender,
        dob: event.dob,
        confirmPassword: event.confirmPassword,
        depressionScore: event.depressionScore,
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
      ),
    );
    result.fold((failure) {
      emit(CreatingAccountFailure(message: failure.message));
    }, (verificationData) {
      emit(VerifyAccount(verificationData: verificationData));
    });
  }

  _loginEventtHandler(LoginEvent event, Emitter emit) async {
    emit(LoginingAccount());
    var result = await login
        .call(LoginParams(email: event.email, password: event.password));
    result.fold((failure) {
      if (failure.data != null) {
        emit(VerifyAccount(verificationData: failure.data!));
      } else {
        emit(LoginAccoiuntFailure(message: failure.message));
      }
    }, (user) {
      emit(UserAccount(user: user));
    });
  }
}
