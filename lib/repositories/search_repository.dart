import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/art_data.dart' as art_models;
import '../../models/profile_model.dart' as profile_models;
import '../../models/boat.dart';
import 'package:my_project/config/env.dart';
import '../blocs/collection/collection_bloc.dart';

class SearchResults {
  final List<profile_models.Artwork> artworks;
  final List<profile_models.Collection> collections;
  final List<Boat> boats;

  const SearchResults({
    required this.artworks,
    required this.collections,
    required this.boats,
  });
}

class SearchRepository {
  Future<SearchResults> search(String query) async {
    try {
      // Fetch public artworks
      final artworksResponse =
          await http.get(Uri.parse('${Env.baseUrl}/public/artworks'));

      if (artworksResponse.statusCode != 200) {
        throw Exception('Failed to load artworks');
      }
      final List<dynamic> artworksJson = json.decode(artworksResponse.body);
      print(artworksJson);
      print("artworksJson");
      final List<profile_models.Artwork> artworks = artworksJson
          .map((json) => profile_models.Artwork.fromJson(json))
          .toList();
      print("artworks");
      print(artworks);
      // Fetch public collections
      final collectionsResponse =
          await http.get(Uri.parse('${Env.baseUrl}/public/collections'));
      if (collectionsResponse.statusCode != 200) {
        throw Exception('Failed to load collections');
      }
      final List<dynamic> collectionsJson =
          json.decode(collectionsResponse.body);
      final List<profile_models.Collection> collections = collectionsJson
          .map((json) => profile_models.Collection.fromJson(json))
          .toList();

      // Fetch public boats
      final boatsResponse =
          await http.get(Uri.parse('${Env.baseUrl}/public/boats'));
      print("@@@@");
      if (boatsResponse.statusCode != 200) {
        throw Exception('Failed to load boats');
      }
      final List<dynamic> boatsJson = json.decode(boatsResponse.body);
      print(boatsJson);
      final List<Boat> boats =
          boatsJson.map((json) => Boat.fromJson(json)).toList();
      print(boats[0].imageUrl);

      // Filter results based on search query if provided
      // if (query.isNotEmpty) {
      //   final filteredArtworks = artworks.where((artwork) {
      //     final title = artwork.title;
      //     final ownerUsername = artwork.owner?.username;
      //     return title.toLowerCase().contains(query.toLowerCase()) ||
      //         (ownerUsername?.toLowerCase().contains(query.toLowerCase()) ??
      //             false);
      //   }).toList();

      //   final filteredCollections = collections.where((collection) {
      //     final name = collection.name;
      //     final ownerUsername = collection.owner?.username;
      //     return name.toLowerCase().contains(query.toLowerCase()) ||
      //         (ownerUsername?.toLowerCase().contains(query.toLowerCase()) ??
      //             false);
      //   }).toList();

      //   return SearchResults(
      //     artworks: filteredArtworks
      //         .map((a) => art_models.ArtData(
      //               imageUrl: a.imageUrl,
      //               artName: a.title,
      //               artistName: a.owner?.username ?? 'Unknown Artist',
      //               description: a.description,
      //               price: a.estimation.toString(),
      //               year: '',
      //               category: '',
      //               birthCountry: '',
      //               size: '',
      //               yearBirth: '',
      //               auctionHouseResult: '',
      //               turnoverEvolution: '',
      //               worldRanking: '',
      //             ))
      //         .toList(),
      //     collections: filteredCollections,
      //   );
      // }

      return SearchResults(
        artworks: artworks,
        collections: collections,
        boats: boats,
      );
    } catch (e) {
      throw Exception('Failed to perform search: $e');
    }
  }
}
