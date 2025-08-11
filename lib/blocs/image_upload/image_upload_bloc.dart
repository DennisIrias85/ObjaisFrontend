import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/image_upload_service.dart';
import '../../models/visual_match.dart';

part 'image_upload_event.dart';
part 'image_upload_state.dart';

class ImageUploadBloc extends Bloc<ImageUploadEvent, ImageUploadState> {
  final ImageUploadService _imageUploadService;

  ImageUploadBloc(this._imageUploadService) : super(ImageUploadInitial()) {
    on<UploadImageEvent>(_onUploadImage);
  }

  Future<void> _onUploadImage(
    UploadImageEvent event,
    Emitter<ImageUploadState> emit,
  ) async {
    try {
      emit(ImageUploadLoading());
      // await Future.delayed(const Duration(seconds: 1));
      final response = await _imageUploadService.uploadImage(event.imageFile);

      final List<VisualMatch> matches = (response['visualMatches'] as List)
          .map(
            (match) => VisualMatch(
              title: match['title'] ?? '',
              source: match['source'] ?? '',
              link: match['link'] ?? '',
              thumbnail: match['thumbnail'] ?? '',
              image: match['image'] ?? '',
            ),
          )
          .toList();

      // final results = [
      //   {
      //     "title": "NORONHA DA COSTA - galeriadearte.pt",
      //     "link": "https://galeriadearte.pt/artista/noronha-da-costa/",
      //     "source": "galeriadearte.pt",
      //     "thumbnail":
      //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2v81Hn01lnw-i5WBaB4JKYuwZANTmgo1-njiKeuJCnVFZrEs6",
      //     "image":
      //         "https://galeriadearte.pt/wp-content/uploads/2024/10/66f6cfd6b14ff-4-500x433.jpg",
      //   },
      //   {
      //     "title": "Lot - Bruno Dufourmantelle (French, b. 1949)",
      //     "link":
      //         "https://www.nealauction.com/auction-lot/bruno-dufourmantelle-french-b.-1949_E324B1CB9F",
      //     "source": "Neal Auction",
      //     "thumbnail":
      //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSte0PnAv6AyAh3uLV0pdqFZz_QEVJR-IoKF8GyatvRv4awEtRt",
      //     "image":
      //         "https://galeriadearte.pt/wp-content/uploads/2024/10/66f6cfd6b14ff-4-500x433.jpg",
      //   },
      //   {
      //     "title": "Richard Mayhew, Concerto, 2017 | ACA Galleries",
      //     "link":
      //         "https://acagalleries.com/exhibitions/beyond-the-spiral-artworks/artworks-21034-richard-mayhew-concerto-2017/",
      //     "source": "ACA Galleries",
      //     "thumbnail":
      //         "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTM6cbbj9vAnPXbpb0czvqN0-TqxLCsWJTmsJEyxipTrh9wD3we",
      //     "image":
      //         "https://artlogic-res.cloudinary.com/w_1200,c_limit,f_auto,fl_lossy,q_auto/artlogicstorage/acagalleries/images/view/33f6dcf3601da8250bb1490dc98f0af0p/acagalleries-richard-mayhew-concerto-2017.png",
      //   },
      // ];
      // final List<VisualMatch> matches = (results as List)
      //     .map(
      //       (match) => VisualMatch(
      //         title: match['title'] ?? '',
      //         source: match['source'] ?? '',
      //         link: match['link'] ?? '',
      //         thumbnail: match['thumbnail'] ?? '',
      //         image: match['image'] ?? '',
      //       ),
      //     )
      //     .toList();
      emit(ImageUploadSuccess(matches));
    } catch (e) {
      emit(ImageUploadError(e.toString()));
    }
  }
}
