import 'package:kale/bootstrap.dart';
import 'package:kale/core/config/app_config.dart';

/// Default entry point — uses app config environment.

void main() async {
  await bootstrap(const AppConfig());
}
