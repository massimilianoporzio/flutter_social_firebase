//TIENE DENTRO DI SE LA LOGICA ASSOCIATA ALL'EMAIL (VALIDAZIONE, ecc)
import 'package:built_value/built_value.dart';
import 'package:email_validator/email_validator.dart';
part 'email.g.dart';

abstract class Email implements Built<Email, EmailBuilder> {
  String get value; //il valore che mi rappresenta l'unicità
  //costruttore anonimo
  Email._() {
    if (EmailValidator.validate(value) == false) {
      throw ArgumentError('Invalid email format.');
    }
  }
  //BUILT_VALUE SYNTAX
  factory Email([void Function(EmailBuilder) updates]) = _$Email;
}
