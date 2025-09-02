class AppValidators {
  // Email Validator
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    const emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(value.trim())) {
      return "Enter a valid email address";
    }
    return null;
  }

  // Password Validator
  static String? validatePassword(String? value, {int minLength = 3}) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < minLength) {
      return "Password must be at least $minLength characters long";
    }
    return null;
  }

  // Confirm Password
  static String? validateConfirmPassword(String? value, String? original) {
    if (value == null || value.isEmpty) {
      return "Confirm Password is required";
    }
    if (value != original) {
      return "Passwords do not match";
    }
    return null;
  }

  // Number only
  static String? validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    final regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(value.trim())) {
      return "Enter numbers only";
    }
    return null;
  }

  // Phone Number (Basic)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }
    final regex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!regex.hasMatch(value)) {
      return "Enter a valid phone number";
    }
    return null;
  }

  // Name Validator
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }
    final regex = RegExp(r'^[a-zA-Z ]+$');
    if (!regex.hasMatch(value.trim())) {
      return "Enter alphabets only";
    }
    return null;
  }

  // Generic Required Field
  static String? validateRequired(String? value, {String fieldName = "Field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }
  static String? noValidation(String? value) {
    return null;
  }
}
