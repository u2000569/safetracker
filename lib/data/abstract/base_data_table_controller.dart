import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/logging/logger.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/loader.dart';


abstract class SBaseController<T> extends GetxController{
  RxBool isLoading = true.obs; // Observables for managing loading state
  RxInt sortColumnIndex = 1.obs; // Observable for tracking the index of the column for sorting
  RxBool sortAscending = true.obs; // Observable for tracking the sorting order (ascending or descending)
  RxList<T> allItems = <T>[].obs; // Observable list to store all items
  RxList<T> filteredItems = <T>[].obs; // Observable list to store filtered items
  RxList<bool> selectedRows = <bool>[].obs; // Observable list to store selected rows
  final searchTextController = TextEditingController(); // Controller for handling search text input

  @override
  void onInit(){
    fetchData(); // Initialize data fetching when the controller is initialized
    super.onInit();
  }

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<List<T>> fetchItems();

  /// Abstract method to be implemented by subclasses for deleting an item.
  Future<void> deleteItem(T item);

  /// Abstract method to be implemented by subclasses for checking if an item contains the search query.
  bool containsSearchQuery(T item, String query);

  /// Common method for fetching data.
  Future<void> fetchData() async {
    try {
      isLoading.value = true; // Set loading state to true
      // List<T> fetchedItems = [];
      // if (allItems.isEmpty) {
      //   fetchedItems = await fetchItems(); // Fetch items (to be implemented in subclasses)
      // }

      List<T> fetchedItems = await fetchItems(); // Always fetch items

      allItems.assignAll(fetchedItems); // Assign fetched items to the allItems list
      filteredItems.assignAll(allItems); // Initially, set filtered items to all items
      selectedRows.assignAll(List.generate(allItems.length, (index) => false)); // Initialize selected rows
    } catch (e) {
      // Log or handle the error here for easier debugging
      print('Error fetching data: $e');
      SLoaders.errorSnackBar(title: 'Fetch Error', message: e.toString());
    } finally {
      isLoading.value = false; // Set loading state to false, regardless of success or failure
      update();
    }
  }

  /// Common method for searching based on a query
  void searchQuery(String query) {
    filteredItems.assignAll(
      allItems.where((item) => containsSearchQuery(item, query)),
    );

    // Notify listeners about the change
    update();
  }

  /// Common method for sorting items by a property
  void sortByProperty(int sortColumnIndex, bool ascending, Function(T) property) {
    sortAscending.value = ascending;
    filteredItems.sort((a, b) {
      if (ascending) {
        return property(a).compareTo(property(b));
      } else {
        return property(b).compareTo(property(a));
      }
    });
    this.sortColumnIndex.value = sortColumnIndex;

    update();
  }

  /// Method for adding an item to the lists.
  void addItemToLists(T item) {
    allItems.add(item);
    filteredItems.add(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false)); // Initialize selected rows
    allItems.refresh(); // Refresh the UI to reflect the changes
  }

  /// Method for updating an item in the lists.
  void updateItemFromLists(T item) {
    final itemIndex = allItems.indexWhere((i) => i == item);
    final filteredItemIndex = filteredItems.indexWhere((i) => i == item);

    if (itemIndex != -1) allItems[itemIndex] = item;
    if (filteredItemIndex != -1) filteredItems[itemIndex] = item;

    allItems.refresh(); // Refresh the UI to reflect the changes
  }

  /// Method for removing an item from the lists.
  void removeItemFromLists(T item) {
    allItems.remove(item);
    filteredItems.remove(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false)); // Initialize selected rows

    update(); // Trigger UI update
  }

  /// Common method for confirming deletion and performing the deletion.
  Future<void> confirmAndDeleteItem(T item) async {
    try {
      // Cast the item to the expected type, e.g., UserModel or TeacherModel
    final userItem = item as dynamic; // Replace 'dynamic' with your actual model type if possible
    SLoggerHelper.debug('User Item: $userItem');
    SLoggerHelper.debug('User Item: ${userItem.email}');
    SLoggerHelper.debug('User Item: ${userItem.fullName}');

    

    // Safely access email and fullName, with fallbacks
    final emailOrFallback = userItem.email?.isNotEmpty == true
        ? userItem.email
        : userItem.fullName?.isNotEmpty == true
            ? userItem.fullName
            : 'Unknown User';

      // Show a confirmation dialog
      Get.defaultDialog(
        title: 'Delete Account',
        content: Text('Are you sure you want to delete this account? \n $emailOrFallback'),
        confirm: SizedBox(
          width: 60,
          child: ElevatedButton(
            onPressed: () async => await deleteOnConfirm(item),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: SSizes.buttonHeight / 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SSizes.buttonRadius * 5)),
            ),
            child: const Text('Confirm'),
          ),
        ),
        cancel: SizedBox(
          width: 80,
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: SSizes.buttonHeight / 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SSizes.buttonRadius * 5)),
            ),
            child: const Text('Cancel'),
          ),
        ),
      );
    } catch (e) {
      // Handle error (to be implemented in subclasses)
      SLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Method to be implemented by subclasses for handling confirmation before deleting an item.
  Future<void> deleteOnConfirm(T item) async {
    try {
      // Remove the Confirmation Dialog
      SFullScreenLoader.stopLoading();

      // Start the loader
      SFullScreenLoader.popUpCircular();

      // Delete Firestore Data
      await deleteItem(item);

      removeItemFromLists(item);

      update();

      SFullScreenLoader.stopLoading();
      SLoaders.successSnackBar(title: 'Item Deleted', message: 'Your Item has been Deleted');
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

}