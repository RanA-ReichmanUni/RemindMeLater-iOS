/// App-level configuration constants.
///
/// To force existing users to re-agree to updated terms:
///   1. Update your Terms/Privacy Policy documents
///   2. Bump [kTermsVersion] by 1
///   3. Publish the new app version
///
/// Users who last agreed on an older terms version will be shown
/// the terms screen again with no Cancel option.
const int kTermsVersion = 2;
