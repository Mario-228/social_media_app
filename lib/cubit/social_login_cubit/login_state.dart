abstract class SocialLoginStates {}

class SocialInitialState extends SocialLoginStates {}

class SocialChangePasswordState extends SocialLoginStates {}

class LoginLoadingState extends SocialLoginStates {}

class LoginSuccessfulState extends SocialLoginStates {
  final String uId;
  LoginSuccessfulState(this.uId);
}

class LoginFailedState extends SocialLoginStates {
  final String error;

  LoginFailedState(this.error);
}
