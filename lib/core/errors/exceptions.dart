class Exceptions {
  static String show(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return "This e-mail address is already in use, please use a different e-mail.";

      case 'user-not-found':
        return "This user is not available in the system. Please create user first";

      case 'error_account_exists_with_different_credential':
        return "The e-mail address in your Facebook account has been previously registered in the system via gmail or email method. Please login with this e-mail address.";
      case 'wrong-password':
        return "Wrong Password or E-mail Please Try Again";
      case 'too-many-requests':
        return "Too many Requestmens Error";
      default:
        return "Something went wrong";
    }
  }
}