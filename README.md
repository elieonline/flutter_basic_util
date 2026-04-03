# flutter_basic_util

Small Flutter utilities for formatting, validation, UI spacing, media caching, and common app helpers.

**Pub package name:** `flutter_basic_utils_ultra` (see `pubspec.yaml`). Import the library as:

```dart
import 'package:flutter_basic_utils_ultra/flutter_basic_util.dart';
```

## Requirements

- Dart SDK: `>=3.8.1 <4.0.0`
- Flutter

## Installation

Add the dependency (path, git, or pub—whichever you publish under):

```yaml
dependencies:
  flutter_basic_utils_ultra: ^0.0.4
```

Run `flutter pub get`.

## What’s included

The main barrel file re-exports everything below so one import is enough.

### Extensions

| Area                   | File                         | Highlights                                                                                                                                                                                                       |
| ---------------------- | ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Dates**              | `date_extensions.dart`       | `DateTime?` → formatted strings (`toDateTime`, `toSlashDate`, `toYmd`, `toWeek`, …); helpers `getDayOfMonthSuffix`, `getIsoWeekNumber`.                                                                          |
| **Strings**            | `string_extension.dart`      | `capitalize`, `toTitleCase`, `obscuredMail`, `formatPhoneNumber` (default region `NG`), `toSnakeCase`, `toInitial`, `formatAsCardNumber`, parsing/formatting helpers that bridge to date extensions, `masktext`. |
| **Numbers**            | `data_types_extensions.dart` | `formatAmount`, `formatAmountD` (currency / decimals), `firstWhereOrNull` on `List`; `Utils.isInteger` / `getDecimal`.                                                                                           |
| **Validation strings** | `validation_extension.dart`  | `containsUpper`, `containsLower`, `containsNumber`, `containsSpecialChar`, `containNameChars`, etc.                                                                                                              |
| **Typography**         | `texttheme_extension.dart`   | `BuildContext` getters for fixed `TextStyle`s (display, headings H1–H6, paragraphs, captions).                                                                                                                   |
| **Layout**             | `spacing_extensions.dart`    | `num.sh(cx)` / `num.sw(cx)` (fraction of screen height/width), `sbH` / `sbW` → `SizedBox`.                                                                                                                       |

### Utilities

| Utility                                         | Purpose                                                                                                                                                                                       |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`Debouncer`**                                 | Run a callback after a delay; coalesces rapid calls (`debounce.dart`).                                                                                                                        |
| **`Dimensions`**                                | Named spacing constants: `tiny`, `small`, `medium`, `big`, `large` (`dimensions.dart`).                                                                                                       |
| **`Spacing`**                                   | `SizedBox` presets using `Dimensions` (`spacing.dart`).                                                                                                                                       |
| **`debugLog`**                                  | Logs in debug mode only (`loggers.dart`).                                                                                                                                                     |
| **`Validators`**                                | Form `Validator` functions: required, email, phone (`dlibphonenumber`), username, password rules, amounts, dates, bank-style account number, composable `multiple`, etc. (`validators.dart`). |
| **`NumFormatter`**, **`NoSpaceInputFormatter`** | `TextInputFormatter`s for numeric/thousands and no-spaces (`num_format.dart`).                                                                                                                |
| **`AppLauncher`**                               | WhatsApp, `tel:`, and `mailto:` via `url_launcher` (`launcher.dart`).                                                                                                                         |
| **`MediaCache`**                                | Download/cache images and videos under the temp directory with Dio; clear cache, size, URL helpers (`media_cache.dart`).                                                                      |
| **`PollingService`**                            | Repeated async polls with interval, max duration, max retries, and `onLimitReached` (`polling_service.dart`).                                                                                 |

### Functions / widgets (`functions.dart`)

- `base64ToImage`, `imageFileToBase64`, `compressImage` (uses `flutter_image_compress`)
- `showToast` — `SnackBar` via `ScaffoldMessenger`

## Example snippets

```dart
import 'package:flutter_basic_utils_ultra/flutter_basic_util.dart';

// Date
final label = DateTime.now().toSlashDate; // e.g. dd/MM/yyyy

// Money
final text = (1234.5).formatAmountD(currency: 'NGN');

// Form validator
validator: Validators.multiple([
  Validators.required(),
  Validators.email(),
]),

// Debounced search
final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));
onChanged: (v) => _debouncer.run(() => search(v)),

// Cached image path
final path = await MediaCache.downloadAndCacheImage(imageUrl);
```

## Transitive dependencies

The package pulls in `intl`, `dlibphonenumber`, `flutter_image_compress`, `url_launcher`, `path_provider`, `dio`, and `crypto` for the features above. Ensure platform setup for `url_launcher` and image compression where needed.

## License

MIT — see `LICENSE`.
