import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photURL;
  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.photURL,
  });
  //USER EMPTY per uso di debug e/o quando non ho ancora utente authenticato
  static const AuthUser empty =
      AuthUser(id: '', email: '', name: '', photURL: '');

  bool get isEmpty => this == AuthUser.empty; //BUSINESS RULE=>TEST IT!

  @override
  List<Object?> get props => [id, email, name, photURL];

  @override
  bool? get stringify => true;
}
