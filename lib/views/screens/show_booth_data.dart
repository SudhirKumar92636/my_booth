
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller.dart';

class VoterSearchScreen extends StatelessWidget {
  final VoterController voterController = Get.put(VoterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Voter Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
               () {
                return SizedBox(
                  width: double.infinity, // ✅ Fix Overflow
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Select Booth",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: voterController.selectbooth,
                    icon: const Icon(Icons.arrow_drop_down),
                    isExpanded: true, // ✅ Prevent Overflow
                    items: voterController.booths.map<DropdownMenuItem<int>>((booth) {
                      return DropdownMenuItem<int>(
                        value: booth['partno'],
                        child: Text(
                          booth['booth'] ?? "",
                          overflow: TextOverflow.ellipsis, // ✅ Long text will be trimmed
                        ),
                      );
                    }).toList(),
                    onChanged: (boothId) {
                      voterController.selectbooth = boothId!;
                      voterController.fetchVotersByBooth(boothId);
                    },
                  ),
                );
              }
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: voterController.textEditingController,
              decoration: InputDecoration(
                hintText: "Search by Name, Card ID, Phone...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (query) => voterController.searchVoters(query),
            ),

          ),

        //  Search Results or Voter List
          Expanded(
            child: Obx(() {
              var list = voterController.searchResults.isEmpty
                  ? voterController.voters
                  : voterController.searchResults.value;

              return ListView.builder(
                controller: voterController.scrollController,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var voter = list[index];
                  return Card(
                    child: ListTile(
                      title: Text(voter['name']),
                      subtitle: Text("Booth: ${voter['partno']} | Serial: ${voter['id']}"),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Card ID: ${voter['vno']}"),
                          Text("Age: ${voter['age']} | Gender: ${voter['sex']}"),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
