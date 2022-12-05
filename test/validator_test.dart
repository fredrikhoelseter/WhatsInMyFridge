import 'package:flutter_test/flutter_test.dart';
import 'package:whats_in_my_fridge/utilities/validator.dart';

void main() {

  ///Test suite for validator on register/signup

  ///test for valid name, should not return error message
  test('non empty name', () {
    expect(Validator.validateName( name: 'Eirik'), null);
  });

  ///test for not valid name, should return "name can't be empty"
  test('empty name', () {
    expect(Validator.validateName(name: ''), "Name can't be empty");
  });

  ///test for valid password, should not return error message
  test('valid password', () {
    expect(Validator.validatePassword(password: 'passord123'), null);
  });

  ///test for invalid password, should return error message
  test('invalid password', () {
    expect(Validator.validatePassword(password: 'pas12'), 'Enter a password with length at least 6');
  });

  ///test for valid email, should not return error message
  test('valid email', () {
    expect(Validator.validateEmail(email: 'eirikndahle@gmail.comm'), null);
  });

  ///test for invalid email, should return error message
  test('invalid email', () {
    expect(Validator.validateEmail(email: 'eirik.no'), 'Enter a correct email');
  });

}