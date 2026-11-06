import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('nl'),
  ];

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @accessToken.
  ///
  /// In en, this message translates to:
  /// **'Access token'**
  String get accessToken;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @activeSince.
  ///
  /// In en, this message translates to:
  /// **'Active since {date}. Changes go through a new revision.'**
  String activeSince(String date);

  /// No description provided for @addComponent.
  ///
  /// In en, this message translates to:
  /// **'Add component'**
  String get addComponent;

  /// No description provided for @addComponentBySerial.
  ///
  /// In en, this message translates to:
  /// **'Add component by serial number (in stock)'**
  String get addComponentBySerial;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @addPhone.
  ///
  /// In en, this message translates to:
  /// **'Add phone number'**
  String get addPhone;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProduct;

  /// No description provided for @addRebate.
  ///
  /// In en, this message translates to:
  /// **'Add rebate'**
  String get addRebate;

  /// No description provided for @addedBy.
  ///
  /// In en, this message translates to:
  /// **'added {date} by {name}'**
  String addedBy(String date, String name);

  /// No description provided for @addressForm.
  ///
  /// In en, this message translates to:
  /// **'Form of address'**
  String get addressForm;

  /// No description provided for @addressFormal.
  ///
  /// In en, this message translates to:
  /// **'Formal (Dear Mr. Smith)'**
  String get addressFormal;

  /// No description provided for @addressInformal.
  ///
  /// In en, this message translates to:
  /// **'Informal (Hi Sam)'**
  String get addressInformal;

  /// No description provided for @agreed.
  ///
  /// In en, this message translates to:
  /// **'Agreed'**
  String get agreed;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @allProducts.
  ///
  /// In en, this message translates to:
  /// **'All products'**
  String get allProducts;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get allStatuses;

  /// No description provided for @always.
  ///
  /// In en, this message translates to:
  /// **'always'**
  String get always;

  /// No description provided for @andMore.
  ///
  /// In en, this message translates to:
  /// **'… and {count} more'**
  String andMore(int count);

  /// No description provided for @answerFallback.
  ///
  /// In en, this message translates to:
  /// **'No {ticketLanguage} text yet: the {usedLanguage} text was used. Translate it before sending.'**
  String answerFallback(String ticketLanguage, String usedLanguage);

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get appLanguage;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'traydcraft'**
  String get appTitle;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// No description provided for @billOfMaterials.
  ///
  /// In en, this message translates to:
  /// **'Bill of materials'**
  String get billOfMaterials;

  /// No description provided for @bomActive.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get bomActive;

  /// No description provided for @bomObsolete.
  ///
  /// In en, this message translates to:
  /// **'obsolete'**
  String get bomObsolete;

  /// No description provided for @bomRev.
  ///
  /// In en, this message translates to:
  /// **'BOM rev.'**
  String get bomRev;

  /// No description provided for @bomRevision.
  ///
  /// In en, this message translates to:
  /// **'BOM revision'**
  String get bomRevision;

  /// No description provided for @builtInto.
  ///
  /// In en, this message translates to:
  /// **'Built into'**
  String get builtInto;

  /// No description provided for @bulkKeepsQuotes.
  ///
  /// In en, this message translates to:
  /// **'Quotations before this date keep using the current prices'**
  String get bulkKeepsQuotes;

  /// No description provided for @bulkPriceChange.
  ///
  /// In en, this message translates to:
  /// **'Bulk price change'**
  String get bulkPriceChange;

  /// No description provided for @byStage.
  ///
  /// In en, this message translates to:
  /// **'by stage'**
  String get byStage;

  /// No description provided for @callIncoming.
  ///
  /// In en, this message translates to:
  /// **'Incoming call'**
  String get callIncoming;

  /// No description provided for @callLogged.
  ///
  /// In en, this message translates to:
  /// **'Call logged'**
  String get callLogged;

  /// No description provided for @callMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get callMinutes;

  /// No description provided for @callOutgoing.
  ///
  /// In en, this message translates to:
  /// **'Outgoing call'**
  String get callOutgoing;

  /// No description provided for @callSummary.
  ///
  /// In en, this message translates to:
  /// **'What was discussed'**
  String get callSummary;

  /// No description provided for @callWith.
  ///
  /// In en, this message translates to:
  /// **'Call with {name}'**
  String callWith(String name);

  /// No description provided for @canStillKeep.
  ///
  /// In en, this message translates to:
  /// **'You can still keep the agreed prices.'**
  String get canStillKeep;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'cancelled'**
  String get cancelled;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categoryComplaint.
  ///
  /// In en, this message translates to:
  /// **'complaint'**
  String get categoryComplaint;

  /// No description provided for @categoryLead.
  ///
  /// In en, this message translates to:
  /// **'lead (new business)'**
  String get categoryLead;

  /// No description provided for @categoryOrderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'order confirmation'**
  String get categoryOrderConfirmation;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'other'**
  String get categoryOther;

  /// No description provided for @categoryProductionQuestion.
  ///
  /// In en, this message translates to:
  /// **'production question'**
  String get categoryProductionQuestion;

  /// No description provided for @categoryQuestion.
  ///
  /// In en, this message translates to:
  /// **'question'**
  String get categoryQuestion;

  /// No description provided for @categoryQuoteChange.
  ///
  /// In en, this message translates to:
  /// **'quote change'**
  String get categoryQuoteChange;

  /// No description provided for @categoryService.
  ///
  /// In en, this message translates to:
  /// **'service / repair'**
  String get categoryService;

  /// No description provided for @cc.
  ///
  /// In en, this message translates to:
  /// **'Cc'**
  String get cc;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @chooseCustomerAndLine.
  ///
  /// In en, this message translates to:
  /// **'Choose a customer and add at least one valid line.'**
  String get chooseCustomerAndLine;

  /// No description provided for @chooseRebateTarget.
  ///
  /// In en, this message translates to:
  /// **'Choose a product or family and enter a percentage.'**
  String get chooseRebateTarget;

  /// No description provided for @chooseZonePrice.
  ///
  /// In en, this message translates to:
  /// **'Choose a zone and enter a price.'**
  String get chooseZonePrice;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @codeNameVatRequired.
  ///
  /// In en, this message translates to:
  /// **'Code, name and VAT rate are required.'**
  String get codeNameVatRequired;

  /// No description provided for @component.
  ///
  /// In en, this message translates to:
  /// **'Component'**
  String get component;

  /// No description provided for @componentHistory.
  ///
  /// In en, this message translates to:
  /// **'Component history'**
  String get componentHistory;

  /// No description provided for @componentSince.
  ///
  /// In en, this message translates to:
  /// **'{product} · since {date}'**
  String componentSince(String product, String date);

  /// No description provided for @componentsAsBuilt.
  ///
  /// In en, this message translates to:
  /// **'Components (as built)'**
  String get componentsAsBuilt;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'confirm'**
  String get confirm;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'confirmed'**
  String get confirmed;

  /// No description provided for @conflictsOnDate.
  ///
  /// In en, this message translates to:
  /// **'{count} already have a price on this date'**
  String conflictsOnDate(int count);

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact name'**
  String get contactName;

  /// No description provided for @contactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact person'**
  String get contactPerson;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @convertHelp.
  ///
  /// In en, this message translates to:
  /// **'Does the customer want changes? Make a new revision of the quotation first, link it here, then convert.'**
  String get convertHelp;

  /// No description provided for @convertToOrder.
  ///
  /// In en, this message translates to:
  /// **'Convert to order'**
  String get convertToOrder;

  /// No description provided for @countOf.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total}'**
  String countOf(int count, int total);

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createLead.
  ///
  /// In en, this message translates to:
  /// **'Create lead'**
  String get createLead;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @customerLanguage.
  ///
  /// In en, this message translates to:
  /// **'Customer language'**
  String get customerLanguage;

  /// No description provided for @customerMainNumber.
  ///
  /// In en, this message translates to:
  /// **'Main number of {name}'**
  String customerMainNumber(String name);

  /// No description provided for @customerNamed.
  ///
  /// In en, this message translates to:
  /// **'Customer: {name}'**
  String customerNamed(String name);

  /// No description provided for @customerOptional.
  ///
  /// In en, this message translates to:
  /// **'Customer (optional)'**
  String get customerOptional;

  /// No description provided for @customerReference.
  ///
  /// In en, this message translates to:
  /// **'Customer reference'**
  String get customerReference;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @deliveryFailed.
  ///
  /// In en, this message translates to:
  /// **'not sent'**
  String get deliveryFailed;

  /// No description provided for @deliveryQueued.
  ///
  /// In en, this message translates to:
  /// **'waiting to send'**
  String get deliveryQueued;

  /// No description provided for @deliverySent.
  ///
  /// In en, this message translates to:
  /// **'sent'**
  String get deliverySent;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @devModeHelp.
  ///
  /// In en, this message translates to:
  /// **'Server must run with AUTH_MODE=dev'**
  String get devModeHelp;

  /// No description provided for @developmentUser.
  ///
  /// In en, this message translates to:
  /// **'Development user'**
  String get developmentUser;

  /// No description provided for @deviceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get deviceLanguage;

  /// No description provided for @difference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get difference;

  /// No description provided for @draftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved'**
  String get draftSaved;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editContact.
  ///
  /// In en, this message translates to:
  /// **'Edit contact'**
  String get editContact;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @emailAddresses.
  ///
  /// In en, this message translates to:
  /// **'E-mail addresses (the first is primary)'**
  String get emailAddresses;

  /// No description provided for @enterChange.
  ///
  /// In en, this message translates to:
  /// **'Enter the change, e.g. 4.5 for +4.5 %.'**
  String get enterChange;

  /// No description provided for @enterValidNumbersLine.
  ///
  /// In en, this message translates to:
  /// **'Line {line}: enter valid numbers.'**
  String enterValidNumbersLine(int line);

  /// No description provided for @expectedClose.
  ///
  /// In en, this message translates to:
  /// **'Expected close'**
  String get expectedClose;

  /// No description provided for @expectedCloseDate.
  ///
  /// In en, this message translates to:
  /// **'Expected close {date}'**
  String expectedCloseDate(String date);

  /// No description provided for @expectedValue.
  ///
  /// In en, this message translates to:
  /// **'Expected value'**
  String get expectedValue;

  /// No description provided for @expectedValueEur.
  ///
  /// In en, this message translates to:
  /// **'Expected value (€)'**
  String get expectedValueEur;

  /// No description provided for @expectedValueOptional.
  ///
  /// In en, this message translates to:
  /// **'Expected value (optional)'**
  String get expectedValueOptional;

  /// No description provided for @explode.
  ///
  /// In en, this message translates to:
  /// **'Explode'**
  String get explode;

  /// No description provided for @families.
  ///
  /// In en, this message translates to:
  /// **'Families'**
  String get families;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @familyNamed.
  ///
  /// In en, this message translates to:
  /// **'Family {code}'**
  String familyNamed(String code);

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @fromYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get fromYou;

  /// No description provided for @generalRebateInfo.
  ///
  /// In en, this message translates to:
  /// **'General rebate on all products: {percent} % (net-priced products are never discounted).'**
  String generalRebateInfo(String percent);

  /// No description provided for @generalRebatePercent.
  ///
  /// In en, this message translates to:
  /// **'General rebate %'**
  String get generalRebatePercent;

  /// No description provided for @greetingPreview.
  ///
  /// In en, this message translates to:
  /// **'Greeting: {greeting}'**
  String greetingPreview(String greeting);

  /// No description provided for @helpdesk.
  ///
  /// In en, this message translates to:
  /// **'Helpdesk'**
  String get helpdesk;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'inactive'**
  String get inactive;

  /// No description provided for @inactiveContact.
  ///
  /// In en, this message translates to:
  /// **'No longer active (left the company)'**
  String get inactiveContact;

  /// No description provided for @indicativeLine.
  ///
  /// In en, this message translates to:
  /// **'{description} (indicative, to confirm)'**
  String indicativeLine(String description);

  /// No description provided for @indicativeToConfirm.
  ///
  /// In en, this message translates to:
  /// **'{count} indicative price(s) to confirm before the quotation can be sent: enter the agreed price in the list price field.'**
  String indicativeToConfirm(int count);

  /// No description provided for @insertPreparedAnswer.
  ///
  /// In en, this message translates to:
  /// **'Insert prepared answer'**
  String get insertPreparedAnswer;

  /// No description provided for @internalNote.
  ///
  /// In en, this message translates to:
  /// **'Internal note'**
  String get internalNote;

  /// No description provided for @internalQuestionHelp.
  ///
  /// In en, this message translates to:
  /// **'Internal question. Ask the customer in {language} with a reply, then post the answer for your colleague as an internal note.'**
  String internalQuestionHelp(String language);

  /// No description provided for @internalTicket.
  ///
  /// In en, this message translates to:
  /// **'Internal ticket'**
  String get internalTicket;

  /// No description provided for @internalTicketHelp.
  ///
  /// In en, this message translates to:
  /// **'A question between colleagues; nothing is sent to the customer.'**
  String get internalTicketHelp;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job title'**
  String get jobTitle;

  /// No description provided for @keepAgreedPrices.
  ///
  /// In en, this message translates to:
  /// **'Keep agreed prices'**
  String get keepAgreedPrices;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSameAsCustomer.
  ///
  /// In en, this message translates to:
  /// **'Same as company ({language})'**
  String languageSameAsCustomer(String language);

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @leadCreated.
  ///
  /// In en, this message translates to:
  /// **'Lead created'**
  String get leadCreated;

  /// No description provided for @lineDiscount.
  ///
  /// In en, this message translates to:
  /// **'Line disc.'**
  String get lineDiscount;

  /// No description provided for @listPrice.
  ///
  /// In en, this message translates to:
  /// **'List price'**
  String get listPrice;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @logCall.
  ///
  /// In en, this message translates to:
  /// **'Log call'**
  String get logCall;

  /// No description provided for @loginLinkInvalid.
  ///
  /// In en, this message translates to:
  /// **'This login link has expired or was already used. Request a new one.'**
  String get loginLinkInvalid;

  /// No description provided for @loginLinkSent.
  ///
  /// In en, this message translates to:
  /// **'If this address may use the portal, a login link is on its way. Check your inbox.'**
  String get loginLinkSent;

  /// No description provided for @lookUp.
  ///
  /// In en, this message translates to:
  /// **'Look up'**
  String get lookUp;

  /// No description provided for @lost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get lost;

  /// No description provided for @lostReason.
  ///
  /// In en, this message translates to:
  /// **'Lost reason'**
  String get lostReason;

  /// No description provided for @markAsLost.
  ///
  /// In en, this message translates to:
  /// **'Mark as lost'**
  String get markAsLost;

  /// No description provided for @markAsSent.
  ///
  /// In en, this message translates to:
  /// **'Mark as sent'**
  String get markAsSent;

  /// No description provided for @materialRequirements.
  ///
  /// In en, this message translates to:
  /// **'Material requirements (active revision)'**
  String get materialRequirements;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @messageSent.
  ///
  /// In en, this message translates to:
  /// **'Message sent'**
  String get messageSent;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(String minutes);

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My details'**
  String get myProfile;

  /// No description provided for @myTickets.
  ///
  /// In en, this message translates to:
  /// **'My tickets'**
  String get myTickets;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @netPrice.
  ///
  /// In en, this message translates to:
  /// **'Net price'**
  String get netPrice;

  /// No description provided for @newAnswer.
  ///
  /// In en, this message translates to:
  /// **'New answer'**
  String get newAnswer;

  /// No description provided for @newContact.
  ///
  /// In en, this message translates to:
  /// **'New contact'**
  String get newContact;

  /// No description provided for @newCustomer.
  ///
  /// In en, this message translates to:
  /// **'New customer'**
  String get newCustomer;

  /// No description provided for @newFamily.
  ///
  /// In en, this message translates to:
  /// **'New family'**
  String get newFamily;

  /// No description provided for @newItem.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newItem;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @newOpportunity.
  ///
  /// In en, this message translates to:
  /// **'New opportunity'**
  String get newOpportunity;

  /// No description provided for @newPrice.
  ///
  /// In en, this message translates to:
  /// **'New price'**
  String get newPrice;

  /// No description provided for @newPricesValidFrom.
  ///
  /// In en, this message translates to:
  /// **'New prices valid from {date}'**
  String newPricesValidFrom(String date);

  /// No description provided for @newProduct.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get newProduct;

  /// No description provided for @newQuotation.
  ///
  /// In en, this message translates to:
  /// **'New quotation'**
  String get newQuotation;

  /// No description provided for @newRevision.
  ///
  /// In en, this message translates to:
  /// **'New revision'**
  String get newRevision;

  /// No description provided for @newRevisionOf.
  ///
  /// In en, this message translates to:
  /// **'New revision of {number}'**
  String newRevisionOf(String number);

  /// No description provided for @newTicket.
  ///
  /// In en, this message translates to:
  /// **'New ticket'**
  String get newTicket;

  /// No description provided for @noActiveBom.
  ///
  /// In en, this message translates to:
  /// **'No active bill of materials.'**
  String get noActiveBom;

  /// No description provided for @noBom.
  ///
  /// In en, this message translates to:
  /// **'No bill of materials yet.'**
  String get noBom;

  /// No description provided for @noContactLinked.
  ///
  /// In en, this message translates to:
  /// **'No contact person linked'**
  String get noContactLinked;

  /// No description provided for @noContacts.
  ///
  /// In en, this message translates to:
  /// **'No contacts yet.'**
  String get noContacts;

  /// No description provided for @noCustomerLinked.
  ///
  /// In en, this message translates to:
  /// **'No customer linked'**
  String get noCustomerLinked;

  /// No description provided for @noExpectedClose.
  ///
  /// In en, this message translates to:
  /// **'No expected close date'**
  String get noExpectedClose;

  /// No description provided for @noLines.
  ///
  /// In en, this message translates to:
  /// **'No lines yet.'**
  String get noLines;

  /// No description provided for @noPrices.
  ///
  /// In en, this message translates to:
  /// **'No prices yet.'**
  String get noPrices;

  /// No description provided for @noQuotations.
  ///
  /// In en, this message translates to:
  /// **'No quotations yet.'**
  String get noQuotations;

  /// No description provided for @noRebates.
  ///
  /// In en, this message translates to:
  /// **'No product or family rebates.'**
  String get noRebates;

  /// No description provided for @noSerialComponents.
  ///
  /// In en, this message translates to:
  /// **'No serialised components.'**
  String get noSerialComponents;

  /// No description provided for @noTicketsYet.
  ///
  /// In en, this message translates to:
  /// **'You have no tickets yet.'**
  String get noTicketsYet;

  /// No description provided for @nobodyFound.
  ///
  /// In en, this message translates to:
  /// **'Nobody found with this number.'**
  String get nobodyFound;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @notClosed.
  ///
  /// In en, this message translates to:
  /// **'Not closed'**
  String get notClosed;

  /// No description provided for @noteAdded.
  ///
  /// In en, this message translates to:
  /// **'Note added'**
  String get noteAdded;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @numberRequired.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get numberRequired;

  /// No description provided for @obsoleteRevision.
  ///
  /// In en, this message translates to:
  /// **'Obsolete revision (read-only).'**
  String get obsoleteRevision;

  /// No description provided for @oidcAccessToken.
  ///
  /// In en, this message translates to:
  /// **'OIDC access token'**
  String get oidcAccessToken;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @openEnded.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get openEnded;

  /// No description provided for @openOnly.
  ///
  /// In en, this message translates to:
  /// **'Open only'**
  String get openOnly;

  /// No description provided for @openOpportunity.
  ///
  /// In en, this message translates to:
  /// **'Open opportunity'**
  String get openOpportunity;

  /// No description provided for @opportunities.
  ///
  /// In en, this message translates to:
  /// **'Opportunities'**
  String get opportunities;

  /// No description provided for @opportunity.
  ///
  /// In en, this message translates to:
  /// **'Opportunity'**
  String get opportunity;

  /// No description provided for @opportunityOptional.
  ///
  /// In en, this message translates to:
  /// **'Opportunity (optional)'**
  String get opportunityOptional;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @orderCreated.
  ///
  /// In en, this message translates to:
  /// **'Order created'**
  String get orderCreated;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @paymentDays.
  ///
  /// In en, this message translates to:
  /// **'Payment days'**
  String get paymentDays;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @personTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get personTitle;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneCall.
  ///
  /// In en, this message translates to:
  /// **'Phone call'**
  String get phoneCall;

  /// No description provided for @phoneDirect.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get phoneDirect;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'With country code, e.g. +32 475 12 34 56'**
  String get phoneHint;

  /// No description provided for @phoneMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get phoneMobile;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phoneNumbers.
  ///
  /// In en, this message translates to:
  /// **'Phone numbers'**
  String get phoneNumbers;

  /// No description provided for @phoneOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get phoneOther;

  /// No description provided for @phoneWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get phoneWork;

  /// No description provided for @placeholdersHelp.
  ///
  /// In en, this message translates to:
  /// **'Placeholders (click to insert in the current language):'**
  String get placeholdersHelp;

  /// No description provided for @portalAccess.
  ///
  /// In en, this message translates to:
  /// **'Customer portal access'**
  String get portalAccess;

  /// No description provided for @portalScope.
  ///
  /// In en, this message translates to:
  /// **'Sees in the portal'**
  String get portalScope;

  /// No description provided for @portalScopeCustomer.
  ///
  /// In en, this message translates to:
  /// **'All tickets of the company'**
  String get portalScopeCustomer;

  /// No description provided for @portalScopeOwn.
  ///
  /// In en, this message translates to:
  /// **'Own tickets only'**
  String get portalScopeOwn;

  /// No description provided for @portalSignInIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter your e-mail address. We will send you a link to sign in, no password needed.'**
  String get portalSignInIntro;

  /// No description provided for @portalTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer portal'**
  String get portalTitle;

  /// No description provided for @postalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal code'**
  String get postalCode;

  /// No description provided for @preparedAnswers.
  ///
  /// In en, this message translates to:
  /// **'Prepared answers'**
  String get preparedAnswers;

  /// No description provided for @preparedAnswersHelp.
  ///
  /// In en, this message translates to:
  /// **'Reusable answers to recurring questions, one text per language. Placeholders such as «quotation.number» are filled in for the ticket; the text can still be edited before sending.'**
  String get preparedAnswersHelp;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @priceListOf.
  ///
  /// In en, this message translates to:
  /// **'Price list of {date}'**
  String priceListOf(String date);

  /// No description provided for @priceListValidOn.
  ///
  /// In en, this message translates to:
  /// **'Price list valid on'**
  String get priceListValidOn;

  /// No description provided for @priceZone.
  ///
  /// In en, this message translates to:
  /// **'Price zone'**
  String get priceZone;

  /// No description provided for @pricedOnPriceListOf.
  ///
  /// In en, this message translates to:
  /// **'Priced on the price list of {date}'**
  String pricedOnPriceListOf(String date);

  /// No description provided for @prices.
  ///
  /// In en, this message translates to:
  /// **'Prices'**
  String get prices;

  /// No description provided for @pricesCreated.
  ///
  /// In en, this message translates to:
  /// **'{count} prices created, valid from {date}'**
  String pricesCreated(int count, String date);

  /// No description provided for @pricesWillChange.
  ///
  /// In en, this message translates to:
  /// **'{count} prices will change'**
  String pricesWillChange(int count);

  /// No description provided for @pricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing;

  /// No description provided for @pricingIndicative.
  ///
  /// In en, this message translates to:
  /// **'indicative'**
  String get pricingIndicative;

  /// No description provided for @pricingIndicativeHelp.
  ///
  /// In en, this message translates to:
  /// **'Indicative (confirm per quote)'**
  String get pricingIndicativeHelp;

  /// No description provided for @pricingList.
  ///
  /// In en, this message translates to:
  /// **'list price'**
  String get pricingList;

  /// No description provided for @pricingListHelp.
  ///
  /// In en, this message translates to:
  /// **'List price (rebates apply)'**
  String get pricingListHelp;

  /// No description provided for @pricingNet.
  ///
  /// In en, this message translates to:
  /// **'net'**
  String get pricingNet;

  /// No description provided for @pricingNetHelp.
  ///
  /// In en, this message translates to:
  /// **'Net price (never discounted)'**
  String get pricingNetHelp;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get priorityHigh;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'low'**
  String get priorityLow;

  /// No description provided for @priorityNormal.
  ///
  /// In en, this message translates to:
  /// **'normal'**
  String get priorityNormal;

  /// No description provided for @priorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'urgent'**
  String get priorityUrgent;

  /// No description provided for @probability.
  ///
  /// In en, this message translates to:
  /// **'Probability'**
  String get probability;

  /// No description provided for @probabilityPercent.
  ///
  /// In en, this message translates to:
  /// **'Probability %'**
  String get probabilityPercent;

  /// No description provided for @probabilityShort.
  ///
  /// In en, this message translates to:
  /// **'Prob.'**
  String get probabilityShort;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @productCount.
  ///
  /// In en, this message translates to:
  /// **'{count} products'**
  String productCount(int count);

  /// No description provided for @productFamilies.
  ///
  /// In en, this message translates to:
  /// **'Product families'**
  String get productFamilies;

  /// No description provided for @productFamily.
  ///
  /// In en, this message translates to:
  /// **'Product family'**
  String get productFamily;

  /// No description provided for @productRebates.
  ///
  /// In en, this message translates to:
  /// **'Product rebates'**
  String get productRebates;

  /// No description provided for @productTypeConfigurable.
  ///
  /// In en, this message translates to:
  /// **'configurable'**
  String get productTypeConfigurable;

  /// No description provided for @productTypeManufactured.
  ///
  /// In en, this message translates to:
  /// **'manufactured'**
  String get productTypeManufactured;

  /// No description provided for @productTypePurchased.
  ///
  /// In en, this message translates to:
  /// **'purchased'**
  String get productTypePurchased;

  /// No description provided for @productTypeService.
  ///
  /// In en, this message translates to:
  /// **'service'**
  String get productTypeService;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @profileHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose the language and the way we address you in our e-mails and in this portal.'**
  String get profileHelp;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @questionToSales.
  ///
  /// In en, this message translates to:
  /// **'Question to sales'**
  String get questionToSales;

  /// No description provided for @questionToSalesHelp.
  ///
  /// In en, this message translates to:
  /// **'{salesperson} gets this question and asks the customer in their language.'**
  String questionToSalesHelp(String salesperson);

  /// No description provided for @quotation.
  ///
  /// In en, this message translates to:
  /// **'Quotation'**
  String get quotation;

  /// No description provided for @quotations.
  ///
  /// In en, this message translates to:
  /// **'Quotations'**
  String get quotations;

  /// No description provided for @raisedBy.
  ///
  /// In en, this message translates to:
  /// **'Raised by {name}'**
  String raisedBy(String name);

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @rebate.
  ///
  /// In en, this message translates to:
  /// **'Rebate'**
  String get rebate;

  /// No description provided for @rebateFor.
  ///
  /// In en, this message translates to:
  /// **'{target}: {percent} %'**
  String rebateFor(String target, String percent);

  /// No description provided for @rebatePercent.
  ///
  /// In en, this message translates to:
  /// **'Rebate %'**
  String get rebatePercent;

  /// No description provided for @rebateSourceFamily.
  ///
  /// In en, this message translates to:
  /// **'family'**
  String get rebateSourceFamily;

  /// No description provided for @rebateSourceGeneral.
  ///
  /// In en, this message translates to:
  /// **'general'**
  String get rebateSourceGeneral;

  /// No description provided for @rebateSourceProduct.
  ///
  /// In en, this message translates to:
  /// **'product'**
  String get rebateSourceProduct;

  /// No description provided for @rebatesOf.
  ///
  /// In en, this message translates to:
  /// **'Rebates · {customer}'**
  String rebatesOf(String customer);

  /// No description provided for @registerProduct.
  ///
  /// In en, this message translates to:
  /// **'Register {product}'**
  String registerProduct(String product);

  /// No description provided for @registerUnit.
  ///
  /// In en, this message translates to:
  /// **'Register unit'**
  String get registerUnit;

  /// No description provided for @registered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get registered;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removeAndScrap.
  ///
  /// In en, this message translates to:
  /// **'Remove and scrap'**
  String get removeAndScrap;

  /// No description provided for @removeBackToStock.
  ///
  /// In en, this message translates to:
  /// **'Remove, back to stock'**
  String get removeBackToStock;

  /// No description provided for @removedBy.
  ///
  /// In en, this message translates to:
  /// **'removed {date} by {name}'**
  String removedBy(String date, String name);

  /// No description provided for @replyQueued.
  ///
  /// In en, this message translates to:
  /// **'Reply queued for sending'**
  String get replyQueued;

  /// No description provided for @replyToCustomer.
  ///
  /// In en, this message translates to:
  /// **'Reply to customer'**
  String get replyToCustomer;

  /// No description provided for @repricingFailed.
  ///
  /// In en, this message translates to:
  /// **'Today\'s prices could not be calculated: {error}'**
  String repricingFailed(String error);

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @revisionActivated.
  ///
  /// In en, this message translates to:
  /// **'Revision activated'**
  String get revisionActivated;

  /// No description provided for @revisionItem.
  ///
  /// In en, this message translates to:
  /// **'Revision {revision} · {status} · {lines} lines'**
  String revisionItem(int revision, String status, int lines);

  /// No description provided for @revisionNotes.
  ///
  /// In en, this message translates to:
  /// **'Revision notes'**
  String get revisionNotes;

  /// No description provided for @revisionPriceLists.
  ///
  /// In en, this message translates to:
  /// **'Agreed prices: price list of {agreed}. Current prices: price list of {current}.'**
  String revisionPriceLists(String agreed, String current);

  /// No description provided for @roleInvoicing.
  ///
  /// In en, this message translates to:
  /// **'Invoicing'**
  String get roleInvoicing;

  /// No description provided for @roleManagement.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get roleManagement;

  /// No description provided for @roleOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get roleOther;

  /// No description provided for @rolePurchasing.
  ///
  /// In en, this message translates to:
  /// **'Purchasing'**
  String get rolePurchasing;

  /// No description provided for @roleQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get roleQuality;

  /// No description provided for @roleSalesContact.
  ///
  /// In en, this message translates to:
  /// **'Sales contact'**
  String get roleSalesContact;

  /// No description provided for @roleTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get roleTechnical;

  /// No description provided for @roles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @roundTo.
  ///
  /// In en, this message translates to:
  /// **'Round to'**
  String get roundTo;

  /// No description provided for @salesperson.
  ///
  /// In en, this message translates to:
  /// **'Salesperson'**
  String get salesperson;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get saveDraft;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @savedNumber.
  ///
  /// In en, this message translates to:
  /// **'Saved {number}'**
  String savedNumber(String number);

  /// No description provided for @scrapPercent.
  ///
  /// In en, this message translates to:
  /// **'Scrap %'**
  String get scrapPercent;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @sendLoginLink.
  ///
  /// In en, this message translates to:
  /// **'Send login link'**
  String get sendLoginLink;

  /// No description provided for @serial.
  ///
  /// In en, this message translates to:
  /// **'serial'**
  String get serial;

  /// No description provided for @serialBuiltIn.
  ///
  /// In en, this message translates to:
  /// **'built in'**
  String get serialBuiltIn;

  /// No description provided for @serialDelivered.
  ///
  /// In en, this message translates to:
  /// **'delivered'**
  String get serialDelivered;

  /// No description provided for @serialInStock.
  ///
  /// In en, this message translates to:
  /// **'in stock'**
  String get serialInStock;

  /// No description provided for @serialInstalled.
  ///
  /// In en, this message translates to:
  /// **'installed'**
  String get serialInstalled;

  /// No description provided for @serialNumber.
  ///
  /// In en, this message translates to:
  /// **'Serial number'**
  String get serialNumber;

  /// No description provided for @serialNumbers.
  ///
  /// In en, this message translates to:
  /// **'Serial numbers'**
  String get serialNumbers;

  /// No description provided for @serialNumbersHelp.
  ///
  /// In en, this message translates to:
  /// **'Every unit gets its own serial number and history'**
  String get serialNumbersHelp;

  /// No description provided for @serialScrapped.
  ///
  /// In en, this message translates to:
  /// **'scrapped'**
  String get serialScrapped;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @showInactive.
  ///
  /// In en, this message translates to:
  /// **'Show inactive'**
  String get showInactive;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {name}'**
  String signedInAs(String name);

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get signingIn;

  /// No description provided for @singleProduct.
  ///
  /// In en, this message translates to:
  /// **'Single product'**
  String get singleProduct;

  /// No description provided for @skippedWithoutPrice.
  ///
  /// In en, this message translates to:
  /// **'{count} product/zone combinations have no price and are skipped'**
  String skippedWithoutPrice(int count);

  /// No description provided for @stage.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get stage;

  /// No description provided for @stageLead.
  ///
  /// In en, this message translates to:
  /// **'lead'**
  String get stageLead;

  /// No description provided for @stageLost.
  ///
  /// In en, this message translates to:
  /// **'lost'**
  String get stageLost;

  /// No description provided for @stageNegotiation.
  ///
  /// In en, this message translates to:
  /// **'negotiation'**
  String get stageNegotiation;

  /// No description provided for @stageProposal.
  ///
  /// In en, this message translates to:
  /// **'proposal'**
  String get stageProposal;

  /// No description provided for @stageQualified.
  ///
  /// In en, this message translates to:
  /// **'qualified'**
  String get stageQualified;

  /// No description provided for @stageWon.
  ///
  /// In en, this message translates to:
  /// **'won'**
  String get stageWon;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @statusAccepted.
  ///
  /// In en, this message translates to:
  /// **'accepted'**
  String get statusAccepted;

  /// No description provided for @statusAfterwards.
  ///
  /// In en, this message translates to:
  /// **'Status afterwards'**
  String get statusAfterwards;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'draft'**
  String get statusDraft;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'rejected'**
  String get statusRejected;

  /// No description provided for @statusSent.
  ///
  /// In en, this message translates to:
  /// **'sent'**
  String get statusSent;

  /// No description provided for @statusSuperseded.
  ///
  /// In en, this message translates to:
  /// **'superseded'**
  String get statusSuperseded;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @structureRevision.
  ///
  /// In en, this message translates to:
  /// **'Structure (revision {revision})'**
  String structureRevision(int revision);

  /// No description provided for @subassembly.
  ///
  /// In en, this message translates to:
  /// **'subassembly'**
  String get subassembly;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @subjectOptional.
  ///
  /// In en, this message translates to:
  /// **'Subject (optional)'**
  String get subjectOptional;

  /// No description provided for @suggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested: {value}'**
  String suggested(String value);

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @ticketClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get ticketClosed;

  /// No description provided for @ticketDetails.
  ///
  /// In en, this message translates to:
  /// **'Ticket details'**
  String get ticketDetails;

  /// No description provided for @ticketInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get ticketInProgress;

  /// No description provided for @ticketOpened.
  ///
  /// In en, this message translates to:
  /// **'Ticket opened'**
  String get ticketOpened;

  /// No description provided for @ticketStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'closed'**
  String get ticketStatusClosed;

  /// No description provided for @ticketStatusNew.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get ticketStatusNew;

  /// No description provided for @ticketStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get ticketStatusOpen;

  /// No description provided for @ticketStatusPendingCustomer.
  ///
  /// In en, this message translates to:
  /// **'waiting for customer'**
  String get ticketStatusPendingCustomer;

  /// No description provided for @ticketStatusPendingInternal.
  ///
  /// In en, this message translates to:
  /// **'waiting for colleague'**
  String get ticketStatusPendingInternal;

  /// No description provided for @ticketWaitingForYou.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your reply'**
  String get ticketWaitingForYou;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @titleCustomerValueRequired.
  ///
  /// In en, this message translates to:
  /// **'Title, customer and a valid value are required.'**
  String get titleCustomerValueRequired;

  /// No description provided for @titleMr.
  ///
  /// In en, this message translates to:
  /// **'Mr.'**
  String get titleMr;

  /// No description provided for @titleMs.
  ///
  /// In en, this message translates to:
  /// **'Ms.'**
  String get titleMs;

  /// No description provided for @titleNone.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get titleNone;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalChange.
  ///
  /// In en, this message translates to:
  /// **'Total excl. VAT: {from} → {to} ({difference})'**
  String totalChange(String from, String to, String difference);

  /// No description provided for @totalExclVat.
  ///
  /// In en, this message translates to:
  /// **'Total excl. VAT'**
  String get totalExclVat;

  /// No description provided for @totalInclVat.
  ///
  /// In en, this message translates to:
  /// **'Total incl. VAT'**
  String get totalInclVat;

  /// No description provided for @totalsToBuyOrMake.
  ///
  /// In en, this message translates to:
  /// **'Totals to buy or make'**
  String get totalsToBuyOrMake;

  /// No description provided for @tracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get tracking;

  /// No description provided for @twoLetters.
  ///
  /// In en, this message translates to:
  /// **'2 letters'**
  String get twoLetters;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassigned;

  /// No description provided for @unchanged.
  ///
  /// In en, this message translates to:
  /// **'Unchanged'**
  String get unchanged;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get unitPrice;

  /// No description provided for @unitPriceExclVat.
  ///
  /// In en, this message translates to:
  /// **'Unit price (excl. VAT)'**
  String get unitPriceExclVat;

  /// No description provided for @unknownCaller.
  ///
  /// In en, this message translates to:
  /// **'Unknown caller'**
  String get unknownCaller;

  /// No description provided for @until.
  ///
  /// In en, this message translates to:
  /// **'Until'**
  String get until;

  /// No description provided for @updateToCurrentPrices.
  ///
  /// In en, this message translates to:
  /// **'Update to current prices'**
  String get updateToCurrentPrices;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @useAnotherPriceListDate.
  ///
  /// In en, this message translates to:
  /// **'Use another price list date'**
  String get useAnotherPriceListDate;

  /// No description provided for @validFrom.
  ///
  /// In en, this message translates to:
  /// **'Valid from'**
  String get validFrom;

  /// No description provided for @validFromDate.
  ///
  /// In en, this message translates to:
  /// **'Valid from {date}'**
  String validFromDate(String date);

  /// No description provided for @validUntil.
  ///
  /// In en, this message translates to:
  /// **'valid until {date}'**
  String validUntil(String date);

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @vat.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get vat;

  /// No description provided for @vatNumber.
  ///
  /// In en, this message translates to:
  /// **'VAT number'**
  String get vatNumber;

  /// No description provided for @vatOn.
  ///
  /// In en, this message translates to:
  /// **'VAT {rate} % on {base}'**
  String vatOn(String rate, String base);

  /// No description provided for @vatPercent.
  ///
  /// In en, this message translates to:
  /// **'VAT %'**
  String get vatPercent;

  /// No description provided for @viaPortal.
  ///
  /// In en, this message translates to:
  /// **'Via the customer portal'**
  String get viaPortal;

  /// No description provided for @weighted.
  ///
  /// In en, this message translates to:
  /// **'weighted {amount}'**
  String weighted(String amount);

  /// No description provided for @whatWasAsked.
  ///
  /// In en, this message translates to:
  /// **'What was asked?'**
  String get whatWasAsked;

  /// No description provided for @whoIsCalling.
  ///
  /// In en, this message translates to:
  /// **'Who is calling?'**
  String get whoIsCalling;

  /// No description provided for @won.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get won;

  /// No description provided for @writeIn.
  ///
  /// In en, this message translates to:
  /// **'Write in {language}'**
  String writeIn(String language);

  /// No description provided for @yourMessage.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get yourMessage;

  /// No description provided for @zone.
  ///
  /// In en, this message translates to:
  /// **'Zone'**
  String get zone;

  /// No description provided for @zoneAndRebate.
  ///
  /// In en, this message translates to:
  /// **'Zone {zone} · general rebate {percent} %'**
  String zoneAndRebate(String zone, String percent);

  /// No description provided for @zonesNoneAll.
  ///
  /// In en, this message translates to:
  /// **'Zones (none selected = all)'**
  String get zonesNoneAll;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
