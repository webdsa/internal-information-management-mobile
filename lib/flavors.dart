enum Flavor {
  dev,
  hom,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'DSA - Informações Dev';
      case Flavor.hom:
        return 'DSA - Informações Hom';
      case Flavor.prod:
        return 'DSA - Informações';
      default:
        return 'title';
    }
  }

  static String get env {
    switch (appFlavor) {
      case Flavor.dev:
        return 'dev';

      case Flavor.hom:
        return 'hom';

      case Flavor.prod:
        return 'prod';

      default:
        return 'title';
    }
  }

  static String get apiUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return "http://10.0.2.2:5171";
      case Flavor.hom:
        return "https://f176-187-75-79-100.ngrok-free.app";
      default:
        return "";
    }
  }
}
