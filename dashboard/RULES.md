# Code Rules

## No null assertion operator (`!`)

Never use the Dart null assertion operator (`!`) to force-unwrap a nullable value.

**Instead:**
- Capture nullable fields/map values in a local variable and let Dart promote it via a null check or pattern:
  ```dart
  // Bad
  if (service == null) return [];
  return service!.results;

  // Good
  final svc = service;
  if (svc == null) return [];
  return svc.results;
  ```
- Use null-aware operators (`?.`, `??`, `??=`) where appropriate.
- Use Dart 3 pattern matching for cleaner conditional access:
  ```dart
  // Bad
  if (result.temperature != null)
    Text(result.temperature!.toStringAsFixed(1));

  // Good
  if (result.temperature case final temp?)
    Text(temp.toStringAsFixed(1));
  ```
- For `DropdownButton.onChanged` callbacks that receive `T?`, use `if (v != null)` instead of `v!`.
- For map lookups with known keys (e.g. `_controllers['key']!`), capture the value via `??=` assignment:
  ```dart
  final ctrl = _controllers['key'] ??= TextEditingController();
  ```

**To find violations**, use:
```bash
grep -rn '\w!' lib/ --include="*.dart" | grep -v '!='
```
This targets identifier-followed-by-`!` while filtering out `!=`.
