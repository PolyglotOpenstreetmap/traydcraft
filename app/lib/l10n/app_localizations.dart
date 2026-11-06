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

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get addMember;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @addNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Add an internal note'**
  String get addNoteHint;

  /// No description provided for @addPhone.
  ///
  /// In en, this message translates to:
  /// **'Add phone number'**
  String get addPhone;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

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

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get addTag;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get addTask;

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

  /// No description provided for @allTags.
  ///
  /// In en, this message translates to:
  /// **'All tags'**
  String get allTags;

  /// No description provided for @allTeams.
  ///
  /// In en, this message translates to:
  /// **'All teams'**
  String get allTeams;

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

  /// No description provided for @announceRepair.
  ///
  /// In en, this message translates to:
  /// **'Announce a repair'**
  String get announceRepair;

  /// No description provided for @announcedNotReceived.
  ///
  /// In en, this message translates to:
  /// **'Announced, not received yet'**
  String get announcedNotReceived;

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

  /// No description provided for @assignTo.
  ///
  /// In en, this message translates to:
  /// **'Assign to'**
  String get assignTo;

  /// No description provided for @attachFile.
  ///
  /// In en, this message translates to:
  /// **'Attach file'**
  String get attachFile;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @attachmentsHelp.
  ///
  /// In en, this message translates to:
  /// **'Images (JPEG, PNG, WebP) and PDF, up to 12 MB'**
  String get attachmentsHelp;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// No description provided for @backIntoWork.
  ///
  /// In en, this message translates to:
  /// **'Back into work'**
  String get backIntoWork;

  /// No description provided for @backToCurrentRevision.
  ///
  /// In en, this message translates to:
  /// **'Back to current revision'**
  String get backToCurrentRevision;

  /// No description provided for @billOfMaterials.
  ///
  /// In en, this message translates to:
  /// **'Bill of materials'**
  String get billOfMaterials;

  /// No description provided for @billable.
  ///
  /// In en, this message translates to:
  /// **'Billable'**
  String get billable;

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

  /// No description provided for @cancelJob.
  ///
  /// In en, this message translates to:
  /// **'Cancel job'**
  String get cancelJob;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get cancelOrder;

  /// No description provided for @cancelReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason for cancelling'**
  String get cancelReasonLabel;

  /// No description provided for @cancelRepair.
  ///
  /// In en, this message translates to:
  /// **'Cancel repair'**
  String get cancelRepair;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'cancelled'**
  String get cancelled;

  /// No description provided for @cancelledReason.
  ///
  /// In en, this message translates to:
  /// **'Cancelled: {reason}'**
  String cancelledReason(String reason);

  /// No description provided for @cannotConfirmNewer.
  ///
  /// In en, this message translates to:
  /// **'A newer revision of this order is being prepared. You can confirm it once it has been sent to you.'**
  String get cannotConfirmNewer;

  /// No description provided for @cannotConfirmOther.
  ///
  /// In en, this message translates to:
  /// **'This order cannot be confirmed.'**
  String get cannotConfirmOther;

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

  /// No description provided for @changePriority.
  ///
  /// In en, this message translates to:
  /// **'Change priority'**
  String get changePriority;

  /// No description provided for @chooseCustomerAndLine.
  ///
  /// In en, this message translates to:
  /// **'Choose a customer and add at least one valid line.'**
  String get chooseCustomerAndLine;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get choosePhoto;

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

  /// No description provided for @completeJob.
  ///
  /// In en, this message translates to:
  /// **'Complete job'**
  String get completeJob;

  /// No description provided for @completionNotes.
  ///
  /// In en, this message translates to:
  /// **'What was done (and anything left open)'**
  String get completionNotes;

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

  /// No description provided for @confirmOnBehalf.
  ///
  /// In en, this message translates to:
  /// **'Confirm on behalf of customer'**
  String get confirmOnBehalf;

  /// No description provided for @confirmOnBehalfHelp.
  ///
  /// In en, this message translates to:
  /// **'Record that the customer has confirmed this revision, for example by phone or e-mail.'**
  String get confirmOnBehalfHelp;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm order'**
  String get confirmOrder;

  /// No description provided for @confirmOrderHelp.
  ///
  /// In en, this message translates to:
  /// **'By confirming you accept this order as shown.'**
  String get confirmOrderHelp;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @confirmationDate.
  ///
  /// In en, this message translates to:
  /// **'Confirmed on'**
  String get confirmationDate;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'confirmed'**
  String get confirmed;

  /// No description provided for @confirmedRevision.
  ///
  /// In en, this message translates to:
  /// **'Confirmed revision'**
  String get confirmedRevision;

  /// No description provided for @confirmedVia.
  ///
  /// In en, this message translates to:
  /// **'Confirmed via'**
  String get confirmedVia;

  /// No description provided for @confirmedViaPortal.
  ///
  /// In en, this message translates to:
  /// **'customer portal'**
  String get confirmedViaPortal;

  /// No description provided for @confirmedViaStaff.
  ///
  /// In en, this message translates to:
  /// **'staff, on behalf of the customer'**
  String get confirmedViaStaff;

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

  /// No description provided for @createRepair.
  ///
  /// In en, this message translates to:
  /// **'Create repair'**
  String get createRepair;

  /// No description provided for @csatAlready.
  ///
  /// In en, this message translates to:
  /// **'This survey was already answered.'**
  String get csatAlready;

  /// No description provided for @csatBad.
  ///
  /// In en, this message translates to:
  /// **'Not satisfied'**
  String get csatBad;

  /// No description provided for @csatComment.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get csatComment;

  /// No description provided for @csatEnabled.
  ///
  /// In en, this message translates to:
  /// **'Send a satisfaction survey when a ticket is closed'**
  String get csatEnabled;

  /// No description provided for @csatExpired.
  ///
  /// In en, this message translates to:
  /// **'This survey link has expired.'**
  String get csatExpired;

  /// No description provided for @csatGood.
  ///
  /// In en, this message translates to:
  /// **'Satisfied'**
  String get csatGood;

  /// No description provided for @csatNone.
  ///
  /// In en, this message translates to:
  /// **'No rating yet'**
  String get csatNone;

  /// No description provided for @csatQuestion.
  ///
  /// In en, this message translates to:
  /// **'How satisfied are you with the handling of ticket {number}?'**
  String csatQuestion(String number);

  /// No description provided for @csatThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get csatThanks;

  /// No description provided for @csatTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer satisfaction'**
  String get csatTitle;

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

  /// No description provided for @defaultTeam.
  ///
  /// In en, this message translates to:
  /// **'Default team for new tickets'**
  String get defaultTeam;

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

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @departmentCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get departmentCode;

  /// No description provided for @departmentMembers.
  ///
  /// In en, this message translates to:
  /// **'Colleagues in this department'**
  String get departmentMembers;

  /// No description provided for @departments.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get departments;

  /// No description provided for @departmentsHelp.
  ///
  /// In en, this message translates to:
  /// **'Repairs are routed to these departments. Only colleagues who belong to a department can work on its repairs.'**
  String get departmentsHelp;

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

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @dismissRequest.
  ///
  /// In en, this message translates to:
  /// **'Dismiss request'**
  String get dismissRequest;

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

  /// No description provided for @editDepartment.
  ///
  /// In en, this message translates to:
  /// **'Edit department'**
  String get editDepartment;

  /// No description provided for @editJob.
  ///
  /// In en, this message translates to:
  /// **'Edit job'**
  String get editJob;

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

  /// No description provided for @faultDescription.
  ///
  /// In en, this message translates to:
  /// **'What is wrong'**
  String get faultDescription;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @firstResponseMinutes.
  ///
  /// In en, this message translates to:
  /// **'First response (min)'**
  String get firstResponseMinutes;

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

  /// No description provided for @helpdeskSettings.
  ///
  /// In en, this message translates to:
  /// **'Helpdesk settings'**
  String get helpdeskSettings;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

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

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

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

  /// No description provided for @jobCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get jobCancelled;

  /// No description provided for @jobCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get jobCompleted;

  /// No description provided for @jobInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get jobInProgress;

  /// No description provided for @jobKindInspection.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get jobKindInspection;

  /// No description provided for @jobKindInstallation.
  ///
  /// In en, this message translates to:
  /// **'Installation'**
  String get jobKindInstallation;

  /// No description provided for @jobKindMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get jobKindMaintenance;

  /// No description provided for @jobKindOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get jobKindOther;

  /// No description provided for @jobKindRepair.
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get jobKindRepair;

  /// No description provided for @jobName.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get jobName;

  /// No description provided for @jobPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get jobPlanned;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job title'**
  String get jobTitle;

  /// No description provided for @jobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get jobs;

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

  /// No description provided for @logTime.
  ///
  /// In en, this message translates to:
  /// **'Log time'**
  String get logTime;

  /// No description provided for @logWork.
  ///
  /// In en, this message translates to:
  /// **'Log work'**
  String get logWork;

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

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as completed'**
  String get markCompleted;

  /// No description provided for @markReceived.
  ///
  /// In en, this message translates to:
  /// **'Mark as received'**
  String get markReceived;

  /// No description provided for @markShipped.
  ///
  /// In en, this message translates to:
  /// **'Mark as shipped back'**
  String get markShipped;

  /// No description provided for @markWaitingCustomer.
  ///
  /// In en, this message translates to:
  /// **'Waiting for customer'**
  String get markWaitingCustomer;

  /// No description provided for @markWaitingParts.
  ///
  /// In en, this message translates to:
  /// **'Waiting for parts'**
  String get markWaitingParts;

  /// No description provided for @materialRequirements.
  ///
  /// In en, this message translates to:
  /// **'Material requirements (active revision)'**
  String get materialRequirements;

  /// No description provided for @mergeAction.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get mergeAction;

  /// No description provided for @mergeHelp.
  ///
  /// In en, this message translates to:
  /// **'All messages, files, tags and time entries move to the chosen ticket of the same customer. This ticket is closed. This cannot be undone.'**
  String get mergeHelp;

  /// No description provided for @mergeNoCandidates.
  ///
  /// In en, this message translates to:
  /// **'No other open ticket of this customer.'**
  String get mergeNoCandidates;

  /// No description provided for @mergeTicket.
  ///
  /// In en, this message translates to:
  /// **'Merge into another ticket…'**
  String get mergeTicket;

  /// No description provided for @mergedInto.
  ///
  /// In en, this message translates to:
  /// **'Merged into {number}'**
  String mergedInto(String number);

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

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(String minutes);

  /// No description provided for @myJobs.
  ///
  /// In en, this message translates to:
  /// **'My jobs'**
  String get myJobs;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get myOrders;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My details'**
  String get myProfile;

  /// No description provided for @myRepairs.
  ///
  /// In en, this message translates to:
  /// **'My repairs'**
  String get myRepairs;

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

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

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

  /// No description provided for @newDepartment.
  ///
  /// In en, this message translates to:
  /// **'New department'**
  String get newDepartment;

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

  /// No description provided for @newJob.
  ///
  /// In en, this message translates to:
  /// **'New job'**
  String get newJob;

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

  /// No description provided for @newPriority.
  ///
  /// In en, this message translates to:
  /// **'New priority'**
  String get newPriority;

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

  /// No description provided for @newRepair.
  ///
  /// In en, this message translates to:
  /// **'New repair'**
  String get newRepair;

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

  /// No description provided for @newTeam.
  ///
  /// In en, this message translates to:
  /// **'New team'**
  String get newTeam;

  /// No description provided for @newTicket.
  ///
  /// In en, this message translates to:
  /// **'New ticket'**
  String get newTicket;

  /// No description provided for @noAccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has no access to any section yet. Ask an administrator.'**
  String get noAccess;

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

  /// No description provided for @noJobsAssigned.
  ///
  /// In en, this message translates to:
  /// **'No jobs assigned to you.'**
  String get noJobsAssigned;

  /// No description provided for @noLines.
  ///
  /// In en, this message translates to:
  /// **'No lines yet.'**
  String get noLines;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'You have no orders yet.'**
  String get noOrdersYet;

  /// No description provided for @noPermission.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to change these settings.'**
  String get noPermission;

  /// No description provided for @noPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos yet.'**
  String get noPhotos;

  /// No description provided for @noPrices.
  ///
  /// In en, this message translates to:
  /// **'No prices yet.'**
  String get noPrices;

  /// No description provided for @noPriorityChanges.
  ///
  /// In en, this message translates to:
  /// **'No priority changes yet.'**
  String get noPriorityChanges;

  /// No description provided for @noPriorityRequests.
  ///
  /// In en, this message translates to:
  /// **'No requests.'**
  String get noPriorityRequests;

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

  /// No description provided for @noRepairs.
  ///
  /// In en, this message translates to:
  /// **'No repairs.'**
  String get noRepairs;

  /// No description provided for @noRepairsYet.
  ///
  /// In en, this message translates to:
  /// **'You have no repairs yet.'**
  String get noRepairsYet;

  /// No description provided for @noSerialComponents.
  ///
  /// In en, this message translates to:
  /// **'No serialised components.'**
  String get noSerialComponents;

  /// No description provided for @noTeam.
  ///
  /// In en, this message translates to:
  /// **'No team'**
  String get noTeam;

  /// No description provided for @noTechnicians.
  ///
  /// In en, this message translates to:
  /// **'Nobody assigned'**
  String get noTechnicians;

  /// No description provided for @noTicketsYet.
  ///
  /// In en, this message translates to:
  /// **'You have no tickets yet.'**
  String get noTicketsYet;

  /// No description provided for @noTimeEntries.
  ///
  /// In en, this message translates to:
  /// **'No time logged yet.'**
  String get noTimeEntries;

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

  /// No description provided for @notRouted.
  ///
  /// In en, this message translates to:
  /// **'Not routed yet'**
  String get notRouted;

  /// No description provided for @notScheduled.
  ///
  /// In en, this message translates to:
  /// **'Not scheduled'**
  String get notScheduled;

  /// No description provided for @noteAdded.
  ///
  /// In en, this message translates to:
  /// **'Note added'**
  String get noteAdded;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

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

  /// No description provided for @onSiteContact.
  ///
  /// In en, this message translates to:
  /// **'Person on site'**
  String get onSiteContact;

  /// No description provided for @openEnded.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get openEnded;

  /// No description provided for @openJobsOnly.
  ///
  /// In en, this message translates to:
  /// **'Active only'**
  String get openJobsOnly;

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

  /// No description provided for @openPriorityRequests.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 open priority request} other{{count} open priority requests}}'**
  String openPriorityRequests(int count);

  /// No description provided for @openRepairsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} open'**
  String openRepairsCount(String count);

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

  /// No description provided for @orderAlreadyConfirmed.
  ///
  /// In en, this message translates to:
  /// **'This order was confirmed on {date}.'**
  String orderAlreadyConfirmed(String date);

  /// No description provided for @orderAwaitingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'awaiting your confirmation'**
  String get orderAwaitingConfirmation;

  /// No description provided for @orderConfirmationQueued.
  ///
  /// In en, this message translates to:
  /// **'Order confirmation queued for sending.'**
  String get orderConfirmationQueued;

  /// No description provided for @orderConfirmedSnack.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed.'**
  String get orderConfirmedSnack;

  /// No description provided for @orderConfirmedThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you, your order is confirmed.'**
  String get orderConfirmedThanks;

  /// No description provided for @orderCreated.
  ///
  /// In en, this message translates to:
  /// **'Order created'**
  String get orderCreated;

  /// No description provided for @orderSaved.
  ///
  /// In en, this message translates to:
  /// **'Order saved.'**
  String get orderSaved;

  /// No description provided for @orderStatusInPlanning.
  ///
  /// In en, this message translates to:
  /// **'in planning'**
  String get orderStatusInPlanning;

  /// No description provided for @orderStatusInProduction.
  ///
  /// In en, this message translates to:
  /// **'in production'**
  String get orderStatusInProduction;

  /// No description provided for @orderStatusPlanned.
  ///
  /// In en, this message translates to:
  /// **'planned'**
  String get orderStatusPlanned;

  /// No description provided for @orderStatusReadyForShipping.
  ///
  /// In en, this message translates to:
  /// **'ready for shipping'**
  String get orderStatusReadyForShipping;

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

  /// No description provided for @photoBy.
  ///
  /// In en, this message translates to:
  /// **'by {name}'**
  String photoBy(String name);

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @photosAdded.
  ///
  /// In en, this message translates to:
  /// **'Photos added'**
  String get photosAdded;

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

  /// No description provided for @priorityChangeLine.
  ///
  /// In en, this message translates to:
  /// **'{date}: {from} → {to} by {name}'**
  String priorityChangeLine(String date, String from, String to, String name);

  /// No description provided for @priorityChangedSnack.
  ///
  /// In en, this message translates to:
  /// **'Priority changed.'**
  String get priorityChangedSnack;

  /// No description provided for @priorityExpedite.
  ///
  /// In en, this message translates to:
  /// **'expedite'**
  String get priorityExpedite;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get priorityHigh;

  /// No description provided for @priorityHistory.
  ///
  /// In en, this message translates to:
  /// **'Priority history'**
  String get priorityHistory;

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

  /// No description provided for @priorityRequestHelp.
  ///
  /// In en, this message translates to:
  /// **'Our team decides whether and how the priority is changed.'**
  String get priorityRequestHelp;

  /// No description provided for @priorityRequestLine.
  ///
  /// In en, this message translates to:
  /// **'{name} asks for priority: {priority}'**
  String priorityRequestLine(String name, String priority);

  /// No description provided for @priorityRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Your request has been sent.'**
  String get priorityRequestSent;

  /// No description provided for @priorityRequests.
  ///
  /// In en, this message translates to:
  /// **'Customer priority requests'**
  String get priorityRequests;

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

  /// No description provided for @productDescription.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productDescription;

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

  /// No description provided for @reasonRequired.
  ///
  /// In en, this message translates to:
  /// **'A reason is required.'**
  String get reasonRequired;

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

  /// No description provided for @removeLine.
  ///
  /// In en, this message translates to:
  /// **'Remove line'**
  String get removeLine;

  /// No description provided for @removedBy.
  ///
  /// In en, this message translates to:
  /// **'removed {date} by {name}'**
  String removedBy(String date, String name);

  /// No description provided for @reopenJob.
  ///
  /// In en, this message translates to:
  /// **'Reopen job'**
  String get reopenJob;

  /// No description provided for @repairAnnouncedByTicket.
  ///
  /// In en, this message translates to:
  /// **'The customer announced it (the product has not arrived yet)'**
  String get repairAnnouncedByTicket;

  /// No description provided for @repairAnnouncedOk.
  ///
  /// In en, this message translates to:
  /// **'Repair announced. Write the number on the parcel and send the product to us.'**
  String get repairAnnouncedOk;

  /// No description provided for @repairPhotosHelp.
  ///
  /// In en, this message translates to:
  /// **'Photos of the product and the fault help us a lot.'**
  String get repairPhotosHelp;

  /// No description provided for @repairPortalAnnounced.
  ///
  /// In en, this message translates to:
  /// **'Announced, not received yet'**
  String get repairPortalAnnounced;

  /// No description provided for @repairPortalInRepair.
  ///
  /// In en, this message translates to:
  /// **'In repair'**
  String get repairPortalInRepair;

  /// No description provided for @repairPortalReady.
  ///
  /// In en, this message translates to:
  /// **'Repaired, ready to ship'**
  String get repairPortalReady;

  /// No description provided for @repairPortalWaitingCustomer.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your answer'**
  String get repairPortalWaitingCustomer;

  /// No description provided for @repairStatusAnnounced.
  ///
  /// In en, this message translates to:
  /// **'Announced'**
  String get repairStatusAnnounced;

  /// No description provided for @repairStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get repairStatusCancelled;

  /// No description provided for @repairStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get repairStatusCompleted;

  /// No description provided for @repairStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get repairStatusInProgress;

  /// No description provided for @repairStatusReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get repairStatusReceived;

  /// No description provided for @repairStatusRouted.
  ///
  /// In en, this message translates to:
  /// **'In department queue'**
  String get repairStatusRouted;

  /// No description provided for @repairStatusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped back'**
  String get repairStatusShipped;

  /// No description provided for @repairStatusWaitingCustomer.
  ///
  /// In en, this message translates to:
  /// **'Waiting for customer'**
  String get repairStatusWaitingCustomer;

  /// No description provided for @repairStatusWaitingParts.
  ///
  /// In en, this message translates to:
  /// **'Waiting for parts'**
  String get repairStatusWaitingParts;

  /// No description provided for @repairs.
  ///
  /// In en, this message translates to:
  /// **'Repairs'**
  String get repairs;

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

  /// No description provided for @requestDismissedSnack.
  ///
  /// In en, this message translates to:
  /// **'Request dismissed.'**
  String get requestDismissedSnack;

  /// No description provided for @requestLessUrgent.
  ///
  /// In en, this message translates to:
  /// **'Less urgent'**
  String get requestLessUrgent;

  /// No description provided for @requestMoreUrgent.
  ///
  /// In en, this message translates to:
  /// **'More urgent (expedite)'**
  String get requestMoreUrgent;

  /// No description provided for @requestPriorityChange.
  ///
  /// In en, this message translates to:
  /// **'Request priority change'**
  String get requestPriorityChange;

  /// No description provided for @requestStatusApplied.
  ///
  /// In en, this message translates to:
  /// **'applied'**
  String get requestStatusApplied;

  /// No description provided for @requestStatusDismissed.
  ///
  /// In en, this message translates to:
  /// **'dismissed'**
  String get requestStatusDismissed;

  /// No description provided for @requestStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get requestStatusOpen;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @resolutionMinutes.
  ///
  /// In en, this message translates to:
  /// **'Resolution (min)'**
  String get resolutionMinutes;

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

  /// No description provided for @revisionNumber.
  ///
  /// In en, this message translates to:
  /// **'Revision {revision}'**
  String revisionNumber(int revision);

  /// No description provided for @revisionPriceLists.
  ///
  /// In en, this message translates to:
  /// **'Agreed prices: price list of {agreed}. Current prices: price list of {current}.'**
  String revisionPriceLists(String agreed, String current);

  /// No description provided for @revisionViewNotice.
  ///
  /// In en, this message translates to:
  /// **'You are viewing revision {revision} (read-only). The current revision is {current}.'**
  String revisionViewNotice(int revision, int current);

  /// No description provided for @revisions.
  ///
  /// In en, this message translates to:
  /// **'Revisions'**
  String get revisions;

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

  /// No description provided for @routeNote.
  ///
  /// In en, this message translates to:
  /// **'Note for the department'**
  String get routeNote;

  /// No description provided for @routeRepair.
  ///
  /// In en, this message translates to:
  /// **'Route to department'**
  String get routeRepair;

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

  /// No description provided for @scheduledEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get scheduledEnd;

  /// No description provided for @scheduledStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get scheduledStart;

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

  /// No description provided for @sendBackToTriage.
  ///
  /// In en, this message translates to:
  /// **'Send back to triage'**
  String get sendBackToTriage;

  /// No description provided for @sendLoginLink.
  ///
  /// In en, this message translates to:
  /// **'Send login link'**
  String get sendLoginLink;

  /// No description provided for @sendOrderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Send order confirmation'**
  String get sendOrderConfirmation;

  /// No description provided for @sendOrderConfirmationHelp.
  ///
  /// In en, this message translates to:
  /// **'The order confirmation is e-mailed to the customer as a PDF. The revision can no longer be edited afterwards.'**
  String get sendOrderConfirmationHelp;

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

  /// No description provided for @siteAddress.
  ///
  /// In en, this message translates to:
  /// **'Where to go'**
  String get siteAddress;

  /// No description provided for @siteName.
  ///
  /// In en, this message translates to:
  /// **'Site name'**
  String get siteName;

  /// No description provided for @skippedWithoutPrice.
  ///
  /// In en, this message translates to:
  /// **'{count} product/zone combinations have no price and are skipped'**
  String skippedWithoutPrice(int count);

  /// No description provided for @sla.
  ///
  /// In en, this message translates to:
  /// **'SLA'**
  String get sla;

  /// No description provided for @slaAtRisk.
  ///
  /// In en, this message translates to:
  /// **'At risk'**
  String get slaAtRisk;

  /// No description provided for @slaBreached.
  ///
  /// In en, this message translates to:
  /// **'Breached'**
  String get slaBreached;

  /// No description provided for @slaDue.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String slaDue(String date);

  /// No description provided for @slaFilterAny.
  ///
  /// In en, this message translates to:
  /// **'Any SLA state'**
  String get slaFilterAny;

  /// No description provided for @slaFirstResponse.
  ///
  /// In en, this message translates to:
  /// **'First response'**
  String get slaFirstResponse;

  /// No description provided for @slaLeft.
  ///
  /// In en, this message translates to:
  /// **'{time} left'**
  String slaLeft(String time);

  /// No description provided for @slaMet.
  ///
  /// In en, this message translates to:
  /// **'Met'**
  String get slaMet;

  /// No description provided for @slaNone.
  ///
  /// In en, this message translates to:
  /// **'No SLA'**
  String get slaNone;

  /// No description provided for @slaOnTime.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get slaOnTime;

  /// No description provided for @slaOverdue.
  ///
  /// In en, this message translates to:
  /// **'{time} overdue'**
  String slaOverdue(String time);

  /// No description provided for @slaPaused.
  ///
  /// In en, this message translates to:
  /// **'Clock stopped: waiting for the customer'**
  String get slaPaused;

  /// No description provided for @slaPolicies.
  ///
  /// In en, this message translates to:
  /// **'Service levels (SLA)'**
  String get slaPolicies;

  /// No description provided for @slaPoliciesHelp.
  ///
  /// In en, this message translates to:
  /// **'Plain elapsed time, business hours are not taken into account. The clock stops while a ticket waits for the customer.'**
  String get slaPoliciesHelp;

  /// No description provided for @slaResolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get slaResolution;

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

  /// No description provided for @startJob.
  ///
  /// In en, this message translates to:
  /// **'Start job'**
  String get startJob;

  /// No description provided for @startWork.
  ///
  /// In en, this message translates to:
  /// **'Start work'**
  String get startWork;

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

  /// No description provided for @streetAddress.
  ///
  /// In en, this message translates to:
  /// **'Street and number'**
  String get streetAddress;

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

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @tasksProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String tasksProgress(String done, String total);

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @teamLead.
  ///
  /// In en, this message translates to:
  /// **'Lead'**
  String get teamLead;

  /// No description provided for @teamMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get teamMembers;

  /// No description provided for @teamName.
  ///
  /// In en, this message translates to:
  /// **'Team name'**
  String get teamName;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @technicians.
  ///
  /// In en, this message translates to:
  /// **'Technicians'**
  String get technicians;

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

  /// No description provided for @ticketMerged.
  ///
  /// In en, this message translates to:
  /// **'Tickets merged'**
  String get ticketMerged;

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

  /// No description provided for @timeNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get timeNote;

  /// No description provided for @timeTotal.
  ///
  /// In en, this message translates to:
  /// **'Total {total}, billable {billable}'**
  String timeTotal(String total, String billable);

  /// No description provided for @timeTotals.
  ///
  /// In en, this message translates to:
  /// **'Work {work} · Travel {travel}'**
  String timeTotals(String work, String travel);

  /// No description provided for @timeTracking.
  ///
  /// In en, this message translates to:
  /// **'Time tracking'**
  String get timeTracking;

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

  /// No description provided for @uploadingFile.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get uploadingFile;

  /// No description provided for @uploadingPhotos.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get uploadingPhotos;

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

  /// No description provided for @warranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get warranty;

  /// No description provided for @warrantyIn.
  ///
  /// In en, this message translates to:
  /// **'In warranty'**
  String get warrantyIn;

  /// No description provided for @warrantyOut.
  ///
  /// In en, this message translates to:
  /// **'Out of warranty'**
  String get warrantyOut;

  /// No description provided for @warrantyUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get warrantyUnknown;

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

  /// No description provided for @workFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get workFrom;

  /// No description provided for @workKindTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get workKindTravel;

  /// No description provided for @workKindWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get workKindWork;

  /// No description provided for @workLogs.
  ///
  /// In en, this message translates to:
  /// **'Time registered'**
  String get workLogs;

  /// No description provided for @workUntil.
  ///
  /// In en, this message translates to:
  /// **'Until'**
  String get workUntil;

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

  /// No description provided for @yourReference.
  ///
  /// In en, this message translates to:
  /// **'Your reference (RMA or order)'**
  String get yourReference;

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

  /// No description provided for @kbTitle.
  ///
  /// In en, this message translates to:
  /// **'Knowledge base'**
  String get kbTitle;

  /// No description provided for @kbNewArticle.
  ///
  /// In en, this message translates to:
  /// **'New article'**
  String get kbNewArticle;

  /// No description provided for @kbSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search articles'**
  String get kbSearchHint;

  /// No description provided for @kbAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get kbAllCategories;

  /// No description provided for @kbAllStatuses.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get kbAllStatuses;

  /// No description provided for @kbAllAudiences.
  ///
  /// In en, this message translates to:
  /// **'All audiences'**
  String get kbAllAudiences;

  /// No description provided for @kbManageCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get kbManageCategories;

  /// No description provided for @kbStatusPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get kbStatusPublished;

  /// No description provided for @kbStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get kbStatusArchived;

  /// No description provided for @kbAudience.
  ///
  /// In en, this message translates to:
  /// **'Audience'**
  String get kbAudience;

  /// No description provided for @kbAudienceInternal.
  ///
  /// In en, this message translates to:
  /// **'Internal (staff only)'**
  String get kbAudienceInternal;

  /// No description provided for @kbAudiencePortal.
  ///
  /// In en, this message translates to:
  /// **'Customer portal'**
  String get kbAudiencePortal;

  /// No description provided for @kbAudiencePublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get kbAudiencePublic;

  /// No description provided for @kbArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get kbArticleTitle;

  /// No description provided for @kbSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get kbSummary;

  /// No description provided for @kbBody.
  ///
  /// In en, this message translates to:
  /// **'Text (Markdown)'**
  String get kbBody;

  /// No description provided for @kbPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get kbPreview;

  /// No description provided for @kbWriteTab.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get kbWriteTab;

  /// No description provided for @kbMarkdownHelp.
  ///
  /// In en, this message translates to:
  /// **'Use # for headings, **bold**, *italic*, - for lists, [text](https://…) for links and ![description](image:ID) for pictures.'**
  String get kbMarkdownHelp;

  /// No description provided for @kbTagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags (comma separated)'**
  String get kbTagsLabel;

  /// No description provided for @kbRelated.
  ///
  /// In en, this message translates to:
  /// **'Related articles'**
  String get kbRelated;

  /// No description provided for @kbAddRelated.
  ///
  /// In en, this message translates to:
  /// **'Add related article'**
  String get kbAddRelated;

  /// No description provided for @kbImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get kbImages;

  /// No description provided for @kbUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get kbUploadImage;

  /// No description provided for @kbInsertImage.
  ///
  /// In en, this message translates to:
  /// **'Insert in text'**
  String get kbInsertImage;

  /// No description provided for @kbPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get kbPublish;

  /// No description provided for @kbUnpublish.
  ///
  /// In en, this message translates to:
  /// **'Unpublish'**
  String get kbUnpublish;

  /// No description provided for @kbArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get kbArchive;

  /// No description provided for @kbHistory.
  ///
  /// In en, this message translates to:
  /// **'Version history'**
  String get kbHistory;

  /// No description provided for @kbVersionLine.
  ///
  /// In en, this message translates to:
  /// **'Version {version} · {name} · {date}'**
  String kbVersionLine(int version, String name, String date);

  /// No description provided for @kbRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore this version'**
  String get kbRestore;

  /// No description provided for @kbRestoredFrom.
  ///
  /// In en, this message translates to:
  /// **'restored from version {version}'**
  String kbRestoredFrom(int version);

  /// No description provided for @kbFeedback.
  ///
  /// In en, this message translates to:
  /// **'{yes} found this helpful, {no} did not'**
  String kbFeedback(int yes, int no);

  /// No description provided for @kbViews.
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String kbViews(int count);

  /// No description provided for @kbNoArticles.
  ///
  /// In en, this message translates to:
  /// **'No articles found.'**
  String get kbNoArticles;

  /// No description provided for @kbNoCategory.
  ///
  /// In en, this message translates to:
  /// **'No category'**
  String get kbNoCategory;

  /// No description provided for @kbMainCategory.
  ///
  /// In en, this message translates to:
  /// **'Main category'**
  String get kbMainCategory;

  /// No description provided for @kbSortOrder.
  ///
  /// In en, this message translates to:
  /// **'Sort order'**
  String get kbSortOrder;

  /// No description provided for @kbNewCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get kbNewCategory;

  /// No description provided for @kbCategoryNames.
  ///
  /// In en, this message translates to:
  /// **'Name per language'**
  String get kbCategoryNames;

  /// No description provided for @kbDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get kbDelete;

  /// No description provided for @kbSuggestedArticles.
  ///
  /// In en, this message translates to:
  /// **'Suggested articles'**
  String get kbSuggestedArticles;

  /// No description provided for @kbNoSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No matching articles.'**
  String get kbNoSuggestions;

  /// No description provided for @kbInsertText.
  ///
  /// In en, this message translates to:
  /// **'Insert text'**
  String get kbInsertText;

  /// No description provided for @kbInsertLink.
  ///
  /// In en, this message translates to:
  /// **'Insert link'**
  String get kbInsertLink;

  /// No description provided for @kbInsertArticle.
  ///
  /// In en, this message translates to:
  /// **'Insert article'**
  String get kbInsertArticle;

  /// No description provided for @kbNoPortalLink.
  ///
  /// In en, this message translates to:
  /// **'This article is internal: only its text can be inserted.'**
  String get kbNoPortalLink;

  /// No description provided for @kbHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get kbHelp;

  /// No description provided for @kbHelpHeading.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get kbHelpHeading;

  /// No description provided for @kbHelpSearch.
  ///
  /// In en, this message translates to:
  /// **'Search the help articles'**
  String get kbHelpSearch;

  /// No description provided for @kbHelpEmpty.
  ///
  /// In en, this message translates to:
  /// **'No articles found. You can open a ticket instead.'**
  String get kbHelpEmpty;

  /// No description provided for @kbWasHelpful.
  ///
  /// In en, this message translates to:
  /// **'Was this article helpful?'**
  String get kbWasHelpful;

  /// No description provided for @kbYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get kbYes;

  /// No description provided for @kbNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get kbNo;

  /// No description provided for @kbThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback.'**
  String get kbThanks;

  /// No description provided for @kbStillNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Still need help? Open a ticket.'**
  String get kbStillNeedHelp;

  /// No description provided for @kbRelatedReading.
  ///
  /// In en, this message translates to:
  /// **'Related articles'**
  String get kbRelatedReading;

  /// No description provided for @kbDeflectionTitle.
  ///
  /// In en, this message translates to:
  /// **'These articles may already answer your question'**
  String get kbDeflectionTitle;

  /// No description provided for @kbShownIn.
  ///
  /// In en, this message translates to:
  /// **'Not available in your language; shown in {language}.'**
  String kbShownIn(String language);

  /// No description provided for @kbUpdatedOn.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String kbUpdatedOn(String date);
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
