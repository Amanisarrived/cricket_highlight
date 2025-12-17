import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/categoryprovider.dart';
import '../../widgets/categoriescard.dart';


class CatScreen extends StatelessWidget {
  const CatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryProvider()..fetchCategories(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Categories"),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Consumer<CategoryProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final categories = provider.categories;
            debugPrint('Categories fetched: ${provider.categories.length}');

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  title: category.name,
                  imageUrl: category.thumbnail,
                  onTap: () {
                    debugPrint("${category.name} tapped");
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
