import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// MyApp is the main entry point of the application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyItemList(),
    );
  }
}

// MyItemList is the main screen of the application and is a StatefulWidget.
class MyItemList extends StatefulWidget {
  @override
  _MyItemListState createState() => _MyItemListState();
}

// _MyItemListState manages the state of MyItemList.
class _MyItemListState extends State<MyItemList> {
  List<Item> items = []; // List to store items
  Set<ItemStatus> activeFilters = {}; // Set to store active filters

  @override
  void initState() {
    super.initState();

    // Example items are added to the list during initialization.
    items.add(Item("Item 1", "Description of Item 1", ItemStatus.approved));
    items.add(Item("Item 2", "Description of Item 2", ItemStatus.approved));
    items.add(Item("Item 3", "Description of Item 3", ItemStatus.pending));
    items.add(Item("Item 4", "Description of Item 4", ItemStatus.rejected));
  }

  // Function to change the status of an item at a given index.
  void changeItemStatus(int index, ItemStatus newStatus) {
    setState(() {
      items[index].status = newStatus;
    });
  }

  // Function to toggle the active status of a filter.
  void toggleFilter(ItemStatus filter) {
    setState(() {
      if (activeFilters.contains(filter)) {
        activeFilters.remove(filter); // Remove filter if it's active
      } else {
        activeFilters.add(filter); // Add filter if it's not active
      }
    });
  }

  // Function to filter items based on active filters.
  List<Item> getFilteredItems() {
    if (activeFilters.isEmpty) {
      return items; // Return all items if no filters are active.
    } else {
      // Filter items based on the active filters.
      return items.where((item) => activeFilters.contains(item.status)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Item> filteredItems = getFilteredItems(); // Get filtered items

    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // FilterButton widgets for "Pending," "Approved," and "Rejected" filters.
              FilterButton(
                label: 'Pending',
                filter: ItemStatus.pending,
                isActive: activeFilters.contains(ItemStatus.pending),
                onPressed: toggleFilter,
              ),
              FilterButton(
                label: 'Approved',
                filter: ItemStatus.approved,
                isActive: activeFilters.contains(ItemStatus.approved),
                onPressed: toggleFilter,
              ),
              FilterButton(
                label: 'Rejected',
                filter: ItemStatus.rejected,
                isActive: activeFilters.contains(ItemStatus.rejected),
                onPressed: toggleFilter,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// FilterButton is a custom widget representing a filter button.
class FilterButton extends StatelessWidget {
  final String label;
  final ItemStatus filter;
  final bool isActive;
  final Function(ItemStatus) onPressed;

  FilterButton({
    required this.label,
    required this.filter,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed(filter); // Calls the toggleFilter function when pressed with the filter.
      },
      style: ElevatedButton.styleFrom(
        primary: isActive
            ? _getColorForFilter(filter) // Get the color based on the filter
            : null,
      ),
      child: Text(label),
    );
  }

  // Function to determine the color for each filter.
  Color _getColorForFilter(ItemStatus filter) {
    switch (filter) {
      case ItemStatus.pending:
        return Colors.orange; // Change this to the desired color for "Pending."
      case ItemStatus.approved:
        return Colors.orange; // Change this to the desired color for "Approved."
      case ItemStatus.rejected:
        return Colors.orange; // Change this to the desired color for "Rejected."
      default:
        return Colors.blue; // Default color if the filter is not recognized.
    }
  }
}

// Custom data structure to represent an item.
class Item {
  final String name;
  final String description;
  ItemStatus status;

  Item(this.name, this.description, this.status);
}

// Enum to represent item statuses: "all," "pending," "approved," "rejected."
enum ItemStatus {
  all,
  pending,
  approved,
  rejected,
}
