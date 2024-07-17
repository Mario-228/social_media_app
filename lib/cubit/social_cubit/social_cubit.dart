import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/cubit/social_cubit/social_states.dart';
import 'package:social_app/layout_screens/chats/chats_screen.dart';
import 'package:social_app/layout_screens/feeds/feed_screen.dart';
import 'package:social_app/layout_screens/settings/settings_screen.dart';
import 'package:social_app/layout_screens/users/users_screen.dart';
import 'package:social_app/social_models/message_model.dart';
import 'package:social_app/social_models/post_model.dart';
import 'package:social_app/social_models/user_model.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(BuildContext context) => BlocProvider.of(context);

  UserModel? user;
  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      user = UserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserFailedState(error.toString()));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = const [
    FeedsScreen(),
    ChatsScreen(),
    UsersScreen(),
    SettingsScreen()
  ];
  List<String> titles = const [
    "Home",
    "Chats",
    "Users",
    "Settings",
  ];
  void changeIndex(int index) {
    if (index == 2) {
      emit(SocialAddPostState());
    } else {
      if (index > 2) {
        index--;
      }
      currentIndex = index;
      emit(SocialChangeBottomNavigationState());
    }
  }

  File? profileImage;

  Future<void> getProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      emit(SocialGetImageProfileSuccessState());
    } else {
      emit(SocialGetImageProfileFailedState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =await picker.pickImage(source:ImageSource.gallery);
    if (pickedImage != null) {
      coverImage = File(pickedImage.path);
      emit(SocialGetImageCoverSuccessState());
    } else {
      emit(SocialGetImageCoverFailedState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    if (profileImage == null) {
      return;
    }
    FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadImageProfileSuccessState());
        updateUserData(name: name, phone: phone, bio: bio, image: value);
        profileImage = null;
      }).catchError((error) {
        emit(SocialUploadImageProfileFailedState());
      });
    }).catchError((error) {
      emit(SocialUploadImageProfileFailedState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    if (coverImage == null) {
      return;
    }
    FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(coverImage!.path).pathSegments.last}")
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadImageCoverSuccessState());
        updateUserData(name: name, phone: phone, bio: bio, cover: value);
        coverImage = null;
      }).catchError((error) {
        emit(SocialUploadImageCoverFailedState());
      });
    }).catchError((error) {
      emit(SocialUploadImageCoverFailedState());
    });
  }

  void updateUserData(
      {required String name,
      required String phone,
      required String bio,
      String? image,
      String? cover}) {
    emit(SocialUpdateUserDataLoadingState());
    UserModel model = UserModel(
      email: user!.email,
      isEmailVerified: user!.isEmailVerified,
      uId: user!.uId,
      name: name,
      phone: phone,
      image: image ?? user!.image,
      cover: cover ?? user!.cover,
      bio: bio,
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uId)
        .update(model.toJson())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUpdateUserDataFailedState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      postImage = File(pickedImage.path);
      emit(SocialGetPostImageSuccessState());
    } else {
      emit(SocialGetPostImageFailedState());
    }
  }

  void uploadPost({
    required String dateTime,
    required String text,
  }) {
    if (postImage == null) {
      return;
    }
    FirebaseStorage.instance
        .ref()
        .child("posts/${Uri.file(postImage!.path).pathSegments.last}")
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(dateTime: dateTime, text: text, postImage: value);
        postImage = null;
      }).catchError((error) {
        emit(SocialCreatPostFailedState());
      });
    }).catchError((error) {
      emit(SocialCreatPostFailedState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatPostLoadingState());
    PostModel model = PostModel(
      uId: user!.uId,
      name: user!.name,
      image: user!.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? "",
    );
    FirebaseFirestore.instance
        .collection("posts")
        .add(model.toJson())
        .then((value) {
      emit(SocialCreatPostSuccessState());
    }).catchError((error) {
      emit(SocialCreatPostFailedState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likesNumber = [];
  void getPosts() {
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance.collection("posts").get().then((value) {
      for (var element in value.docs) {
        element.reference
            .collection("likes")
            .where("like", isEqualTo: true)
            .get()
            .then((value) {
          likesNumber.add(value.size);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {});
      }
      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      emit(SocialGetPostsFailedState(error.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(user!.uId)
        .set({"like": true}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostFailedState(error.toString()));
    });
  }

  void disLikePost(String postId, int index) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(user!.uId)
        .set({"like": false}).then((value) {
      likesNumber[index]--;
      emit(SocialDislikePostSuccessState());
    }).catchError((error) {
      emit(SocialDislikePostFailedState(error.toString()));
    });
  }

  List<bool?> likesState = [];
  void getLikeState() {
    for (String element in postsId) {
      FirebaseFirestore.instance
          .collection("posts")
          .doc(element)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        likesState.add(value.data()!["like"]);
      });
      emit(SocialLikePostSuccessState());
    }
  }

  List<UserModel> users = [];

  void getAllUsers() {
    if (users.isEmpty) {
      emit(SocialGetAllUsersLoadingState());
      FirebaseFirestore.instance
          .collection("users")
          .where("uId", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        for (var element in value.docs) {
          users.add(UserModel.fromJson(element.data()));
        }
        emit(SocialGetAllUsersSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUsersFailedState(error.toString()));
      });
    }
  }

  void sendMessage(String receiverId, String text, String time) {
    MessageModel message = MessageModel(
        text: text,
        dateTime: time,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        receiverId: receiverId);

    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .add(message.toJson())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageFailedState());
    });

    FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messages")
        .add(message.toJson())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageFailedState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("dateTime")
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(SocialGetMessagesSuccessState());
    });
  }
}

    // if (profileImageUrl.isNotEmpty && coverImageUrl.isNotEmpty) {
    //   model = UserModel(
    //     email: user!.email,
    //     isEmailVerified: user!.isEmailVerified,
    //     uId: user!.uId,
    //     name: name,
    //     phone: phone,
    //     image: profileImageUrl,
    //     cover: coverImageUrl,
    //     bio: bio,
    //   );
    // } else if (profileImageUrl.isEmpty && coverImageUrl.isNotEmpty) {
    //   model = UserModel(
    //     email: user!.email,
    //     isEmailVerified: user!.isEmailVerified,
    //     uId: user!.uId,
    //     name: name,
    //     phone: phone,
    //     image: user!.image,
    //     cover: coverImageUrl,
    //     bio: bio,
    //   );
    // } else if (profileImageUrl.isNotEmpty && coverImageUrl.isEmpty) {
    //   model = UserModel(
    //     email: user!.email,
    //     isEmailVerified: user!.isEmailVerified,
    //     uId: user!.uId,
    //     name: name,
    //     phone: phone,
    //     image: profileImageUrl,
    //     cover: user!.cover,
    //     bio: bio,
    //   );
    // } else {
    //   model = UserModel(
    //     email: user!.email,
    //     isEmailVerified: user!.isEmailVerified,
    //     uId: user!.uId,
    //     name: name,
    //     phone: phone,
    //     image: user!.image,
    //     cover: user!.cover,
    //     bio: bio,
    //   );
    // }