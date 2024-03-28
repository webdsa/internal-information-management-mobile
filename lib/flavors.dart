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
        return 'G.I. DSA Dev';
      case Flavor.hom:
        return 'G.I. DSA hom';
      case Flavor.prod:
        return 'G.I. DSA Prod';
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
}
