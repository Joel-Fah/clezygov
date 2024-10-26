import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/profile.dart';
import '../utils/constants.dart';
import '../views/screens/home/home.dart';
import '../views/screens/onboarding.dart';
import '../views/widgets/notification_snackbar.dart';

class AuthController extends GetxController {
  RxBool _isLoginFormDisplay = true.obs;
  User? _currentUser;
  Profile? _userProfile;
  final GetStorage storage = GetStorage();


  RxBool get isLogin => _isLoginFormDisplay;

  User? get user => _currentUser;

  Profile? get userProfile => _userProfile;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _currentUser = user;  // Update currentUser when auth state changes

      if (_currentUser != null) {
        debugPrint("User signed in: ${_currentUser!.email}");
      } else {
        debugPrint("User signed out");
      }

      update();
    });

    // Check if user is already signed in
    if (isUserSignedIn()) {
      // Get the current user
      _currentUser = FirebaseAuth.instance.currentUser;
    }
  }

  void toggleFormDisplay() {
    _isLoginFormDisplay.value = !_isLoginFormDisplay.value;
    update();
  }

  // Sign in a user with email and password
  void signInWithEmailAndPassword(BuildContext context, {
    required String email,
    required String password,
  }) async {
    showLoadingDialog(context);

    try {
      // Try signing in with email and password
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
            (value) {
          // Dismiss loading dialog
          context.pop();

          // Update the current user
          _currentUser = value.user;

          // Get the user profile
          FirebaseFirestore.instance
              .collection('profile')
              .doc(_currentUser!.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              debugPrint('Profile exists');
              _userProfile = Profile.fromJson(documentSnapshot.data() as Map<String, dynamic>);
            } else {
              debugPrint('Profile does not exist');
            }
          });

          // Save user data to GetStorage
          storage.write('user', _currentUser?.uid);

          // Show a success snackbar
          showNotificationSnackBar(
            context: context,
            icon: successIcon,
            message: 'Welcome back, ${value.user!.displayName}!',
            backgroundColor: successColor,
          );

          // Go to the home page
          context.go(HomePage.routeName);
        },
      );

      // return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Dismiss loading dialog
      context.pop();

      // Handle specific Firebase Authentication errors
      if (e.code == 'network-request-failed') {
        debugPrint('No internet connection.');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'Check you internet connection and try again.',
          backgroundColor: dangerColor,
        );
      } else if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'No user found for that email.',
          backgroundColor: dangerColor,
        );
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'Wrong password provided for that user.',
          backgroundColor: dangerColor,
        );
      } else if (e.code == 'invalid-email') {
        debugPrint('The email address is not valid.');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'The email address is not valid.',
          backgroundColor: dangerColor,
        );
      } else if (e.code == 'user-disabled') {
        debugPrint('This user has been disabled.');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'This user has been disabled.',
          backgroundColor: dangerColor,
        );
      } else {
        debugPrint('Something went wrong: ${e.message}');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'Something went wrong: ${e.message}',
          backgroundColor: dangerColor,
        );
      }
    } catch (e) {
      // Catch any other exceptions
      debugPrint('Error signing in: $e');
      showNotificationSnackBar(
        context: context,
        icon: dangerIcon,
        message: 'An unknown error occurred.',
        backgroundColor: dangerColor,
      );
    }
  }

  // Sign up a user with email and password
  void signUpWithEmailAndPassword(BuildContext context, {
    required String email,
    required String password,
  }) async {
    showLoadingDialog(context);

    try {
      // Try signing up with email and password
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
            (value) async {
          // Dismiss loading dialog
          context.pop();

          // Update the current user
          _currentUser = value.user;

          // Create a profile for the new user
          Profile profile = Profile(
            uid: _currentUser!.uid,
            role: 'user', // Default role
          );

          _userProfile = profile;

          // create a new profile document in Firestore
          await FirebaseFirestore.instance
              .collection('profile')
              .doc(_currentUser!.uid)
              .set(profile.toJson());

          // Save user data to GetStorage
          storage.write('user', _currentUser?.uid);

          // Show a success snackbar
          showNotificationSnackBar(
            context: context,
            icon: successIcon,
            message: 'Signed up as\n${value.user!.email}!',
            backgroundColor: successColor,
          );

          // Go to the home page
          context.go(HomePage.routeName);
        },
      );

      // Return the User object if successful
      // return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Dismiss loading dialog
      context.pop();

      // Handle specific Firebase Authentication errors
      if (e.code == 'network-request-failed') {
        debugPrint('No internet connection.');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'Check you internet connection and try again.',
          backgroundColor: dangerColor,
        );
      } else if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'The password provided is too weak.',
          backgroundColor: dangerColor,
        );
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'The account already exists for that email.',
          backgroundColor: dangerColor,
        );
      } else if (e.code == 'invalid-email') {
        debugPrint('The email address is not valid.');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'The email address is not valid.',
          backgroundColor: dangerColor,
        );
      } else {
        debugPrint('Something went wrong: ${e.message}');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'Something went wrong: ${e.message}',
          backgroundColor: dangerColor,
        );
      }
    } catch (e) {
      // Catch any other exceptions
      debugPrint('Error signing up: $e');
      showNotificationSnackBar(
        context: context,
        icon: dangerIcon,
        message: 'An unknown error occurred.',
        backgroundColor: dangerColor,
      );
    }
  }

  // Sign in a user with Google
  void signInWithGoogle(BuildContext context) async {
    showLoadingDialog(context);

    try {
      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // If the user cancels the sign-in process, dismiss the loading dialog
        context.pop();
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google user credential
      await FirebaseAuth.instance.signInWithCredential(credential).then(
            (value) {
          // Dismiss loading dialog
          context.pop();

          // Update the current user
          _currentUser = value.user;

          // Check if profile exists in Firestore. If not, create a new profile
          FirebaseFirestore.instance
              .collection('profile')
              .doc(_currentUser!.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              _userProfile = Profile.fromJson(documentSnapshot.data() as Map<String, dynamic>);
              debugPrint('Profile exists');
            } else {
              debugPrint('Profile does not exist');
              Profile profile = Profile(
                uid: _currentUser!.uid,
                role: 'user',
              );

              _userProfile = profile;

              // create a new profile document in Firestore
              FirebaseFirestore.instance
                  .collection('profile')
                  .doc(_currentUser!.uid)
                  .set(profile.toJson());
            }
          });

          // Save user data to GetStorage
          storage.write('user', _currentUser?.uid);

          // Show a success snackbar
          showNotificationSnackBar(
            context: context,
            icon: successIcon,
            message: 'Welcome back, ${value.user!.displayName}!',
            backgroundColor: successColor,
          );

          // Go to the home page
          context.go(HomePage.routeName);
        },
      );
    } on FirebaseAuthException catch (e) {
      // Dismiss loading dialog
      context.pop();

      // Handle specific Firebase Authentication errors
      if (e.code == 'account-exists-with-different-credential') {
        debugPrint('Account exists with different credentials.');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'Account exists with different credentials.',
          backgroundColor: dangerColor,
        );
      } else if (e.code == 'invalid-credential') {
        debugPrint('Invalid credentials.');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'Invalid credentials.',
          backgroundColor: dangerColor,
        );
      } else {
        debugPrint('Something went wrong: ${e.message}');
        showNotificationSnackBar(
          context: context,
          icon: dangerIcon,
          message: 'Something went wrong: ${e.message}',
          backgroundColor: dangerColor,
        );
      }
    } catch (e) {
      // Dismiss loading dialog
      context.pop();

      // Catch any other exceptions
      debugPrint('Error signing in: $e');
      showNotificationSnackBar(
        context: context,
        icon: dangerIcon,
        message: 'An unknown error occurred.',
        backgroundColor: dangerColor,
      );
    }
  }

  // Sign out the current user
  void signOut(BuildContext context) async {
    showLoadingDialog(context);

    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut().then(
            (value) {
          // Dismiss loading dialog
          context.pop();

          // Update the current user to null
          _currentUser = null;

          // Update the user profile to null
          _userProfile = null;

          // Remove user data from GetStorage
          storage.remove('user');

          // Show a success snackbar
          showNotificationSnackBar(
            context: context,
            icon: successIcon,
            message: 'You have successfully signed out.',
            backgroundColor: successColor,
          );

          // Navigate to the login page
          context.go(OnboardPage.routeName);
        },
      );
    } catch (e) {
      // Dismiss loading dialog
      context.pop();

      // Handle any errors during sign out
      debugPrint('Error signing out: $e');
      showNotificationSnackBar(
        context: context,
        icon: dangerIcon,
        message: 'An error occurred while signing out.',
        backgroundColor: dangerColor,
      );
    }
  }

  // Sign out of Google
  void googleSignOut(BuildContext context) async {
    showLoadingDialog(context);

    // Try to sign out google user
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      debugPrint('Error signing out Google user: $e');
    }
  }

  // Check if user is signed in
  bool isUserSignedIn() {
    return storage.read('user') != null;
  }
}