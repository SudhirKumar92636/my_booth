import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'database_helper.dart';

class VoterController extends GetxController {
  var booths = [].obs;
  var voters = [].obs;
  var searchResults = [].obs;
  var selectbooth ;

  RxBool isLoading = false.obs;
  RxInt offset = 0.obs;

  final ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    fetchBooths();
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {

        loadMoreData();
      }
    });
  }



  void loadMoreData() {

    if (!isLoading.value) {
      searchVoters(textEditingController.text);
    }
  }

  void fetchBooths() async {
    var data = await DatabaseHelper().getBoothsData();
    booths.value = data;
  }

  void fetchVotersByBooth(int boothId) async {
    var data = await DatabaseHelper().fetchVotersByBooth(boothId);
    voters.value = data;
  }

  void searchVoters(String query) async {
    var data = await DatabaseHelper().searchVoters(query);
    searchResults.value = data;


  }
}
