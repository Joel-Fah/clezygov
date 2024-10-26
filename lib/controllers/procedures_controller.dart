import 'package:clezigov/models/procedures/procedures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProceduresController extends GetxController {
  List<Procedure> _procedures = [];
  bool _isLoading = false;
  RxString _errorMessage = ''.obs;

  List<Procedure> get allProcedures => _procedures;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    fetchProcedures();
  }

  // procedures collection
  final proceduresCollection = FirebaseFirestore.instance.collection('procedures');

  // fetch procedure based on id
  Procedure getProcedureById(String id) {
    return _procedures.firstWhere((p) => p.id == id);
  }

  // fetch procedures from firestore and populate the _procedures list
  Future<void> fetchProcedures() async {
    try {
      QuerySnapshot querySnapshot = await proceduresCollection.get();
      _procedures = querySnapshot.docs
          .map((doc) => Procedure.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching procedures: $e');
    }
  }
}