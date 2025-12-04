import 'package:flutter/material.dart';
import 'package:pizza_repository/pizza_repository.dart';

class PizzaSearchDelegate extends SearchDelegate<Pizza?> {
  final List<Pizza> pizzas;

  PizzaSearchDelegate(this.pizzas);

  @override
  String get searchFieldLabel => 'Tìm kiếm pizza...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = pizzas.where((pizza) {
      return pizza.name.toLowerCase().contains(query.toLowerCase()) ||
          pizza.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Không tìm thấy kết quả',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final pizza = results[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              pizza.picture,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.error),
                );
              },
            ),
          ),
          title: Text(
            pizza.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            pizza.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${pizza.price - (pizza.price * (pizza.discount / 100))}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              if (pizza.discount > 0)
                Text(
                  '\$${pizza.price}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
          onTap: () {
            close(context, pizza);
          },
        );
      },
    );
  }
}
