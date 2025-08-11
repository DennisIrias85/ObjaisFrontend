import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/profile_model.dart';
import '../../repositories/profile_repository.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class FollowProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String fullName;
  final String email;
  final String address;
  final String gender;
  final String dateOfBirth;
  final String description;

  const UpdateProfile({
    required this.fullName,
    required this.email,
    required this.address,
    required this.gender,
    required this.dateOfBirth,
    required this.description,
  });

  @override
  List<Object> get props =>
      [fullName, email, address, gender, dateOfBirth, description];
}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  final bool isFollowing;

  const ProfileLoaded({
    required this.profile,
    this.isFollowing = false,
  });

  @override
  List<Object> get props => [profile, isFollowing];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

// Models
class Profile {
  final User user;
  Profile({required this.user});
}

class User {
  final String fullname;
  final String email;

  User({required this.fullname, required this.email});
}

// Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<FollowProfile>(_onFollowProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final profile = await profileRepository.getProfile();
      print(profile);
      print("profile");
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onFollowProfile(
    FollowProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        await profileRepository.followProfile();
        emit(ProfileLoaded(
          profile: currentState.profile,
          isFollowing: !currentState.isFollowing,
        ));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await profileRepository.updateProfile(
        fullName: event.fullName,
        email: event.email,
        address: event.address,
        gender: event.gender,
        dateOfBirth: event.dateOfBirth,
        description: event.description,
      );
      add(LoadProfile()); // Reload profile after update
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
