import 'dart:convert';
import 'dart:developer';

import 'package:coba_richtext/model/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_repository.g.dart';

@riverpod
FutureOr<List<Post>> getPostList(GetPostListRef ref) async {
  final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");

  final response = await http.get(url);

  final res = jsonDecode(response.body) as List;
  final List<Post> listOfPost = res.map((post) => Post.fromJson(post)).toList();

  return listOfPost;
}

final searchTextProvider = StateProvider.autoDispose<String>((ref) {
  return "";
});

@riverpod
FutureOr<List<Post>> getFilteredPost(GetFilteredPostRef ref) {
  final listPost = ref.watch(getPostListProvider) as List<Post>;
  final search = ref.watch(searchTextProvider);

  final result =
      listPost.where((element) => element.title.contains(search)) as List<Post>;
  log(search.toString());
  return search.isEmpty ? listPost : result;
}
