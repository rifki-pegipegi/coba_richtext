import 'package:coba_richtext/helper/highlight_text.dart';
import 'package:coba_richtext/repository/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Center(child: ListPostView()),
              SearchView(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchView extends ConsumerWidget {
  const SearchView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Search Title",
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          ref.read(searchTextProvider.notifier).state = value;
        },
      ),
    );
  }
}

class ListPostView extends ConsumerWidget {
  const ListPostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(getPostListProvider);
    return repo.when(
      data: (data) {
        final search = ref.watch(searchTextProvider);
        final filteredData =
            data.where((element) => element.title.contains(search)).toList();
        return ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: highlightText(
                    searchText: search,
                    text: filteredData[index].title,
                  ),
                ),
              ),
              subtitle: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  children: highlightText(
                    searchText: search,
                    text: filteredData[index].body,
                  ),
                ),
              ),
            );
          },
          itemCount: filteredData.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        );
      },
      error: (_, __) => const SizedBox.shrink(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
