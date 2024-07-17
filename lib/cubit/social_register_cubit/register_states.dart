abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterChangeVisibility extends RegisterStates {}

class RegisterUserLoadingState extends RegisterStates {}

class RegisterUserSuccessfulState extends RegisterStates {}

class RegisterUserFailedState extends RegisterStates {
  final String error;

  RegisterUserFailedState(this.error);
}

class CreateUserLoadingState extends RegisterStates {}

class CreateUserSuccessfulState extends RegisterStates {
  final String uId;

  CreateUserSuccessfulState(this.uId);
}

class CreateUserFailedState extends RegisterStates {
  final String error;

  CreateUserFailedState(this.error);
}
