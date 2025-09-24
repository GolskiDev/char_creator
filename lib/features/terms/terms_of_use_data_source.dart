import 'terms_of_use_details.dart';

abstract class TermsOfUseDataSource {
  /// If [after] is provided, only emit terms with effectiveDate > [after].
  Stream<List<TermsOfUseDetails>> getTermsOfUseDetailsStream({DateTime? after});
}
