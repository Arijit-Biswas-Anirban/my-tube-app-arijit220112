import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytube/features/auth/model/user_model.dart';
import 'package:mytube/features/auth/repository/user_data_service.dart';

final currentUserProvider = FutureProvider<UserModel>((ref) async{
  final UserModel user =  await ref.watch(userDataServiceProvider).fetchCurrentUserData();
  return user;
});