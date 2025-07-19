class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "L'email est requis.";
    }
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!regex.hasMatch(value)) {
      return "Format d'email invalide.";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Le mot de passe est requis.";
    }
    if (value.length < 6) {
      return "Le mot de passe doit comporter au moins 6 caractères.";
    }
    return null;
  }

  static String? validateField(String? value, {String fieldName = "Ce champ"}) {
    if (value == null || value.isEmpty) {
      return "$fieldName est requis.";
    }
    return null;
  }
}
