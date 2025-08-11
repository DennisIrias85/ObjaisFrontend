import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/visual_match.dart';
import '../../blocs/google_lens/google_lens_bloc.dart';
import '../../screens/art_detail_screen.dart';
import '../../models/art_data.dart';
import '../../blocs/matches/matches_bloc.dart';
import '../../screens/estimation_selection_screen.dart';
import '../../blocs/art_detail/art_detail_bloc.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/boat/boat.dart';
import '../../models/profile_model.dart';
import '../../blocs/boat/boat_bloc.dart';
import '../../models/boat.dart';
import '../../screens/boat/boat_detail_screen.dart';
import 'package:go_router/go_router.dart';

class VisualMatchesScreen extends StatefulWidget {
  const VisualMatchesScreen({super.key});

  @override
  State<VisualMatchesScreen> createState() => _VisualMatchesScreenState();
}

class _VisualMatchesScreenState extends State<VisualMatchesScreen> {
  String? selectedMatchLink;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GoogleLensBloc()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ArtDetailBloc, ArtDetailState>(
            listener: (context, state) async {
              if (state is ArtDetailLoaded) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArtDetailScreen(),
                  ),
                ).then((_) {
                  context.read<GoogleLensBloc>().add(ResetGoogleLensEvent());
                });
              }
            },
          ),
          BlocListener<BoatBloc, BoatState>(
            listener: (context, state) async {
              if (state is BoatLoaded) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BoatDetailScreen(),
                  ),
                ).then((_) {
                  context.read<GoogleLensBloc>().add(ResetGoogleLensEvent());
                });
              }
            },
          ),
          BlocListener<GoogleLensBloc, GoogleLensState>(
            listener: (context, state) async {
              if (state is GoogleLensSuccess) {
                print('🧠 Incoming state.data from scraping: ${state.data}');

                final prefs = await SharedPreferences.getInstance();
                final selectedItem =
                    prefs.getString('selected_item') ?? 'Artwork';

                if (selectedItem.toLowerCase() == 'boat') {
                  final boatData = Boat.fromJson(state.data);
                  context.read<BoatBloc>().add(SaveBoatEvent(boatData));
                  // ✅ Do NOT navigate here. Wait for BoatLoaded instead.
                } else {
                  final artData = ArtData.fromJson(state.data);
                  context
                      .read<ArtDetailBloc>()
                      .add(SaveArtDetailEvent(artData));

                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ArtDetailScreen()),
                    );
                  }
                }
              }
            },
          ),
        ],
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF410332),
                  Color(0xFF510440),
                  Color(0xFF61054E),
                  Color(0xFF70055C),
                  Color(0xFF800066),
                ],
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 10, left: 10),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logotwo.png',
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [],
                          ),
                        ),
                        BlocBuilder<MatchesBloc, MatchesState>(
                          builder: (context, matchesState) {
                            if (matchesState is MatchesInitial) {
                              return const Expanded(
                                child: Center(
                                  child: Text(
                                      'No matches found. Please try again or upload another image'),
                                ),
                              );
                            } else if (matchesState is MatchesLoaded) {
                              return BlocBuilder<GoogleLensBloc,
                                  GoogleLensState>(
                                builder: (context, state) {
                                  if (state is GoogleLensLoading) {
                                    return const Expanded(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else if (state is GoogleLensError) {
                                    return Expanded(
                                      child: Center(
                                        child: Text(
                                          'Error: ${state.message}',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return Expanded(
                                    child: ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0),
                                      itemCount: matchesState.matches.length,
                                      itemBuilder: (context, index) {
                                        final match =
                                            matchesState.matches[index];
                                        return Card(
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                  top: Radius.circular(12),
                                                ),
                                                child: Image.network(
                                                  match.image,
                                                  height: 200,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      match.title,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Color(0xFF410332),
                                                          foregroundColor:
                                                              Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedMatchLink =
                                                                match.link;
                                                          });

                                                          context
                                                              .read<
                                                                  GoogleLensBloc>()
                                                              .add(
                                                                SearchImageEvent(
                                                                  image: match
                                                                      .image,
                                                                  link: match
                                                                      .link,
                                                                  title: match
                                                                      .title,
                                                                ),
                                                              );
                                                        },
                                                        child: const Text(
                                                            'Select'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Expanded(
                                child: Center(
                                  child: Text('Unexpected state'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
