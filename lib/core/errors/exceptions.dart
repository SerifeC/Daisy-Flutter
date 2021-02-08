class Exceptions {
  static String show(String errorCode) {
    switch (errorCode) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "This e-mail address is already in use, please use a different e-mail.";

      case 'ERROR_USER_NOT_FOUND':
        return "This user is not available in the system. Please create user first";

      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return "The e-mail address in your Facebook account has been previously registered in the system via gmail or email method. Please login with this e-mail address.";

      default:
        return "Something went wrong";
    }
  }
}