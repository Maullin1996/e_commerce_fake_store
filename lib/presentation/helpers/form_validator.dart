String? formValidator(input) {
  if (input.isEmpty || input == null) {
    return 'Empty filed';
  }
  if (input.length <= 4) {
    return 'User or password to short';
  }
  return null;
}
