import 'package:flutter/material.dart';
import  'item_details_page.dart'; //  Replace 'your_app_name_here' with the actual name of your app



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyItemList(),
    );
  }
}

class MyItemList extends StatefulWidget {
  @override
  _MyItemListState createState() => _MyItemListState();
}

class _MyItemListState extends State<MyItemList> {
  List<MyItem> items = [];
  Set<ItemStatus> activeFilters = {};

  @override
  void initState() {
    super.initState();

    items.add(MyItem("Item 1", "Description of Item 1", ItemStatus.approved));
    items.add(MyItem("Item 2", "Description of Item 2", ItemStatus.approved));
    items.add(MyItem("Item 3", "Description of Item 3", ItemStatus.pending));
    items.add(MyItem("Item 4", "Description of Item 4", ItemStatus.rejected));
  }

  void _navigateToItemDetails(MyItem item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailsPage(item: item),
      ),
    );

    if (result != null && result == true) {
      setState(() {
        item.status = ItemStatus.approved;
      });
    } else if (result != null && result == false) {
      setState(() {
        item.status = ItemStatus.rejected;
      });
    }
  }

  void changeItemStatus(int index, ItemStatus newStatus) {
    setState(() {
      items[index].status = newStatus;
    });
  }

  void toggleFilter(ItemStatus filter) {
    setState(() {
      if (activeFilters.contains(filter)) {
        activeFilters.remove(filter);
      } else {
        activeFilters.add(filter);
      }
    });
  }

// Function to filter items based on active filters.
  List<MyItem> getFilteredItems() {
    if (activeFilters.isEmpty) {
      return items; // Return all items if no filters are active.
    } else {
      // Filter items based on the active filters.
      return items.where((item) => activeFilters.contains(item.status)).toList();
    }
  }
  @override
  Widget build(BuildContext context) {
    List<MyItem> filteredItems = getFilteredItems();

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
                  onTap: () {
                    _navigateToItemDetails(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
        onPressed(filter);
      },
      style: ElevatedButton.styleFrom(
        primary: isActive ? _getColorForFilter(filter) : null,
      ),
      child: Text(label),
    );
  }

  Color _getColorForFilter(ItemStatus filter) {
    switch (filter) {
      case ItemStatus.pending:
        return Colors.orange;
      case ItemStatus.approved:
        return Colors.orange;
      case ItemStatus.rejected:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}

class MyItem {
  final String name;
  final String description;
  ItemStatus status;

  MyItem(this.name, this.description, this.status);
}

enum ItemStatus {
  all,
  pending,
  approved,
  rejected,
}

class ItemDetailsPage extends StatelessWidget {
  final MyItem item;

  ItemDetailsPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Approve'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Reject'),
                ),
              ],
            ),
            SizedBox(height: 16.0), // Add spacing between buttons and details
            Text('Item Name: ${item.name}'),
            Text('Item Description: ${item.description}'),
            Text('Item Status: ${_getStatusText(item.status)}'),
          ],
        ),
      ),
    );
  }

  String _getStatusText(ItemStatus status) {
    switch (status) {
      case ItemStatus.pending:
        return 'Pending';
      case ItemStatus.approved:
        return 'Approved';
      case ItemStatus.rejected:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }
}
