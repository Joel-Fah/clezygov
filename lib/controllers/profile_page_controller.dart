import 'package:clezigov/models/profile.dart';
import 'package:clezigov/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clezigov/views/screens/home/procedure_details.dart';
import 'package:go_router/go_router.dart';

class ProfilePageController extends GetxController {
  Profile? _profile;

  Profile? get profile => _profile;

  final _profileCollection = FirebaseFirestore.instance.collection('profile');


  String _selectedRoute = ProcedureDetailsPage.routeName;

  String get selectedRoute => _selectedRoute;

  void setSelectedRoute(String route) {
    _selectedRoute = route;
    update();
  }

  bool isRouteSelected(String route) {
    return _selectedRoute == route;
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<Profile?> fetchProfile({required String userId}) async {
    try {
      final doc = await _profileCollection.doc(userId).get();
      if (doc.exists) {
        _profile = Profile.fromJson(doc.data() as Map<String, dynamic>);
        return _profile!;
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  // Profile Information Methods
  void updateProfileInfo(BuildContext context, Profile newProfile) async {
    showLoadingDialog(context);

    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        debugPrint('No user is currently signed in');
        return;
      }

      await FirebaseFirestore.instance
          .collection('profile')
          .doc(currentUser.uid)
          .update(newProfile.toJson())
          .then((value) {
        context.pop();

        _profile = newProfile;
        update();
      });

      debugPrint('Profile updated successfully');
    } catch (e) {
      debugPrint('Error updating profile: $e');
      // You might want to show an error message to the user here
      rethrow; // Rethrow the error so it can be handled by the calling function
    }
  }
}



