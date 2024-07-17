abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserFailedState extends SocialStates {
  final String error;

  SocialGetUserFailedState(this.error);
}

class SocialGetUserLoadingState extends SocialStates {}

class SocialChangeBottomNavigationState extends SocialStates {}

class SocialAddPostState extends SocialStates {}

class SocialGetImageProfileSuccessState extends SocialStates {}

class SocialGetImageProfileFailedState extends SocialStates {}

class SocialGetImageCoverSuccessState extends SocialStates {}

class SocialGetImageCoverFailedState extends SocialStates {}

class SocialUploadImageCoverSuccessState extends SocialStates {}

class SocialUploadImageCoverFailedState extends SocialStates {}

class SocialUploadImageProfileSuccessState extends SocialStates {}

class SocialUploadImageProfileFailedState extends SocialStates {}

class SocialUpdateUserDataLoadingState extends SocialStates {}

class SocialUpdateUserDataFailedState extends SocialStates {}

class SocialCreatPostFailedState extends SocialStates {}

class SocialCreatPostLoadingState extends SocialStates {}

class SocialCreatPostSuccessState extends SocialStates {}

class SocialGetPostImageSuccessState extends SocialStates {}

class SocialGetPostImageFailedState extends SocialStates {}

class SocialRemovePostImageState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialGetPostsFailedState extends SocialStates {
  final String error;

  SocialGetPostsFailedState(this.error);
}

class SocialGetPostsLoadingState extends SocialStates {}

class SocialLikePostSuccessState extends SocialStates {}

class SocialLikePostFailedState extends SocialStates {
  final String error;

  SocialLikePostFailedState(this.error);
}

class SocialDislikePostSuccessState extends SocialStates {}

class SocialDislikePostFailedState extends SocialStates {
  final String error;

  SocialDislikePostFailedState(this.error);
}

class SocialGetAllUsersLoadingState extends SocialStates {}

class SocialGetAllUsersSuccessState extends SocialStates {}

class SocialGetAllUsersFailedState extends SocialStates {
  final String error;

  SocialGetAllUsersFailedState(this.error);
}

class SocialGetMessagesSuccessState extends SocialStates {}

class SocialSendMessageFailedState extends SocialStates {}

class SocialSendMessageSuccessState extends SocialStates {}
