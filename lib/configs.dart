import 'package:country_picker/country_picker.dart';

const APP_NAME = 'Rinzin';
const DEFAULT_LANGUAGE = 'en';

const DOMAIN_URL = "https://admin.rinzindivinebeauty.com.au";

const BASE_URL = '$DOMAIN_URL/api/';
const appStoreAppBaseURL = '';

const APP_PLAY_STORE_URL = '';
const APP_APPSTORE_URL = '';

const TERMS_CONDITION_URL = 'https://iqonic.design/terms-of-use';
const PRIVACY_POLICY_URL = 'https://iqonic.design/privacy-policy';
const INQUIRY_SUPPORT_EMAIL = 'info@rinzindivinebeauty.com.au';
const DASHBOARD_AUTO_SLIDER_SECOND = 5;

/// You can add help line number here for contact. It's demo number
const HELP_LINE_NUMBER = '+61450676021';
const STRIPE_CURRENCY_CODE = "AUD";

Country defaultCountry() {
  return Country(
    phoneCode: '61',
    countryCode: 'AU',
    e164Sc: 61,
    geographic: true,
    level: 1,
    name: 'Australia',
    example: '23456789',
    displayName: 'Australia (AU) [+61]',
    displayNameNoCountryCode: 'Australia (AU)',
    e164Key: '61-AU-0',
    fullExampleWithPlusSign: '+61912345679',
  );
}

