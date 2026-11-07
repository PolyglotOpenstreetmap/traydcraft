// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get accepted => 'Accepted';

  @override
  String get accessToken => 'Access token';

  @override
  String get account => 'Account';

  @override
  String get actions => 'Actions';

  @override
  String get activate => 'Activate';

  @override
  String get active => 'Active';

  @override
  String activeSince(String date) {
    return 'Active since $date. Changes go through a new revision.';
  }

  @override
  String get addComponent => 'Add component';

  @override
  String get addComponentBySerial =>
      'Add component by serial number (in stock)';

  @override
  String get addMember => 'Add member';

  @override
  String get addNote => 'Add note';

  @override
  String get addNoteHint => 'Add an internal note';

  @override
  String get addPhone => 'Add phone number';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get addProduct => 'Add product';

  @override
  String get addRebate => 'Add rebate';

  @override
  String get addTag => 'Add tag';

  @override
  String get addTask => 'Add task';

  @override
  String addedBy(String date, String name) {
    return 'added $date by $name';
  }

  @override
  String get addressForm => 'Form of address';

  @override
  String get addressFormal => 'Formal (Dear Mr. Smith)';

  @override
  String get addressInformal => 'Informal (Hi Sam)';

  @override
  String get agreed => 'Agreed';

  @override
  String get all => 'All';

  @override
  String get allProducts => 'All products';

  @override
  String get allStatuses => 'All statuses';

  @override
  String get allTags => 'All tags';

  @override
  String get allTeams => 'All teams';

  @override
  String get always => 'always';

  @override
  String andMore(int count) {
    return '… and $count more';
  }

  @override
  String get announceRepair => 'Announce a repair';

  @override
  String get announcedNotReceived => 'Announced, not received yet';

  @override
  String answerFallback(String ticketLanguage, String usedLanguage) {
    return 'No $ticketLanguage text yet: the $usedLanguage text was used. Translate it before sending.';
  }

  @override
  String get appLanguage => 'Language';

  @override
  String get appTitle => 'traydcraft';

  @override
  String get apply => 'Apply';

  @override
  String get assignTo => 'Assign to';

  @override
  String get attachFile => 'Attach file';

  @override
  String get attachments => 'Attachments';

  @override
  String get attachmentsHelp => 'Images (JPEG, PNG, WebP) and PDF, up to 12 MB';

  @override
  String get automatic => 'Automatic';

  @override
  String get backIntoWork => 'Back into work';

  @override
  String get backToCurrentRevision => 'Back to current revision';

  @override
  String get billOfMaterials => 'Bill of materials';

  @override
  String get billable => 'Billable';

  @override
  String get bomActive => 'active';

  @override
  String get bomObsolete => 'obsolete';

  @override
  String get bomRev => 'BOM rev.';

  @override
  String get bomRevision => 'BOM revision';

  @override
  String get builtInto => 'Built into';

  @override
  String get bulkKeepsQuotes =>
      'Quotations before this date keep using the current prices';

  @override
  String get bulkPriceChange => 'Bulk price change';

  @override
  String get byStage => 'by stage';

  @override
  String get callIncoming => 'Incoming call';

  @override
  String get callLogged => 'Call logged';

  @override
  String get callMinutes => 'Duration (minutes)';

  @override
  String get callOutgoing => 'Outgoing call';

  @override
  String get callSummary => 'What was discussed';

  @override
  String callWith(String name) {
    return 'Call with $name';
  }

  @override
  String get canStillKeep => 'You can still keep the agreed prices.';

  @override
  String get cancel => 'Cancel';

  @override
  String get cancelJob => 'Cancel job';

  @override
  String get cancelOrder => 'Cancel order';

  @override
  String get cancelReasonLabel => 'Reason for cancelling';

  @override
  String get cancelRepair => 'Cancel repair';

  @override
  String get cancelled => 'cancelled';

  @override
  String cancelledReason(String reason) {
    return 'Cancelled: $reason';
  }

  @override
  String get cannotConfirmNewer =>
      'A newer revision of this order is being prepared. You can confirm it once it has been sent to you.';

  @override
  String get cannotConfirmOther => 'This order cannot be confirmed.';

  @override
  String get category => 'Category';

  @override
  String get categoryComplaint => 'complaint';

  @override
  String get categoryLead => 'lead (new business)';

  @override
  String get categoryOrderConfirmation => 'order confirmation';

  @override
  String get categoryOther => 'other';

  @override
  String get categoryProductionQuestion => 'production question';

  @override
  String get categoryQuestion => 'question';

  @override
  String get categoryQuoteChange => 'quote change';

  @override
  String get categoryService => 'service / repair';

  @override
  String get cc => 'Cc';

  @override
  String get change => 'Change';

  @override
  String get changePriority => 'Change priority';

  @override
  String get chooseCustomerAndLine =>
      'Choose a customer and add at least one valid line.';

  @override
  String get choosePhoto => 'Choose from gallery';

  @override
  String get chooseRebateTarget =>
      'Choose a product or family and enter a percentage.';

  @override
  String get chooseZonePrice => 'Choose a zone and enter a price.';

  @override
  String get city => 'City';

  @override
  String get close => 'Close';

  @override
  String get code => 'Code';

  @override
  String get codeNameRequired => 'Code and name are required.';

  @override
  String get codeNameVatRequired => 'Code, name and VAT rate are required.';

  @override
  String get completeJob => 'Complete job';

  @override
  String get completionNotes => 'What was done (and anything left open)';

  @override
  String get component => 'Component';

  @override
  String get componentHistory => 'Component history';

  @override
  String componentSince(String product, String date) {
    return '$product · since $date';
  }

  @override
  String get componentsAsBuilt => 'Components (as built)';

  @override
  String get confirm => 'confirm';

  @override
  String get confirmOnBehalf => 'Confirm on behalf of customer';

  @override
  String get confirmOnBehalfHelp =>
      'Record that the customer has confirmed this revision, for example by phone or e-mail.';

  @override
  String get confirmOrder => 'Confirm order';

  @override
  String get confirmOrderHelp =>
      'By confirming you accept this order as shown.';

  @override
  String get confirmation => 'Confirmation';

  @override
  String get confirmationDate => 'Confirmed on';

  @override
  String get confirmed => 'confirmed';

  @override
  String get confirmedRevision => 'Confirmed revision';

  @override
  String get confirmedVia => 'Confirmed via';

  @override
  String get confirmedViaPortal => 'customer portal';

  @override
  String get confirmedViaStaff => 'staff, on behalf of the customer';

  @override
  String conflictsOnDate(int count) {
    return '$count already have a price on this date';
  }

  @override
  String get contactName => 'Contact name';

  @override
  String get contactPerson => 'Contact person';

  @override
  String get contacts => 'Contacts';

  @override
  String get convertHelp =>
      'Does the customer want changes? Make a new revision of the quotation first, link it here, then convert.';

  @override
  String get convertToOrder => 'Convert to order';

  @override
  String get countAddLine => 'Add stock not listed';

  @override
  String get countCancel => 'Cancel count';

  @override
  String get countCounted => 'Counted';

  @override
  String get countDifference => 'Difference';

  @override
  String get countExpected => 'Expected';

  @override
  String get countInvalidQuantity => 'A counted quantity is not a number.';

  @override
  String countMovedDuring(int count) {
    return '$count line(s) had stock movements during the count; the counted quantity replaced them.';
  }

  @override
  String get countNew => 'New count';

  @override
  String countOf(int count, int total) {
    return '$count of $total';
  }

  @override
  String get countOneProduct => 'Only one product (optional)';

  @override
  String get countOverwriteWarning =>
      'Movements made while you count are overwritten: when the count is posted, the counted quantity becomes the stock.';

  @override
  String get countPost => 'Post count';

  @override
  String get countPostConfirm =>
      'The differences are posted as stock adjustments. Lines without a counted quantity are left alone.';

  @override
  String get countProgress => 'Counted';

  @override
  String get countStart => 'Start count';

  @override
  String get countStatusCounting => 'Counting';

  @override
  String get countStatusPosted => 'Posted';

  @override
  String countStockAtPost(String quantity) {
    return 'Stock when posted: $quantity';
  }

  @override
  String get countWarehouseRequired => 'Choose a warehouse.';

  @override
  String get countWholeWarehouse => 'Whole warehouse';

  @override
  String get countedBy => 'Started by';

  @override
  String get country => 'Country';

  @override
  String get create => 'Create';

  @override
  String get createLead => 'Create lead';

  @override
  String get createRepair => 'Create repair';

  @override
  String get csatAlready => 'This survey was already answered.';

  @override
  String get csatBad => 'Not satisfied';

  @override
  String get csatComment => 'Comment (optional)';

  @override
  String get csatEnabled =>
      'Send a satisfaction survey when a ticket is closed';

  @override
  String get csatExpired => 'This survey link has expired.';

  @override
  String get csatGood => 'Satisfied';

  @override
  String get csatNone => 'No rating yet';

  @override
  String csatQuestion(String number) {
    return 'How satisfied are you with the handling of ticket $number?';
  }

  @override
  String get csatThanks => 'Thank you for your feedback!';

  @override
  String get csatTitle => 'Customer satisfaction';

  @override
  String get current => 'Current';

  @override
  String get customer => 'Customer';

  @override
  String get customerLanguage => 'Customer language';

  @override
  String customerMainNumber(String name) {
    return 'Main number of $name';
  }

  @override
  String customerNamed(String name) {
    return 'Customer: $name';
  }

  @override
  String get customerOptional => 'Customer (optional)';

  @override
  String get customerReference => 'Customer reference';

  @override
  String get customers => 'Customers';

  @override
  String get date => 'Date';

  @override
  String get defaultTeam => 'Default team for new tickets';

  @override
  String get deliveryFailed => 'not sent';

  @override
  String get deliveryQueued => 'waiting to send';

  @override
  String get deliverySent => 'sent';

  @override
  String get department => 'Department';

  @override
  String get departmentCode => 'Code';

  @override
  String get departmentMembers => 'Colleagues in this department';

  @override
  String get departments => 'Departments';

  @override
  String get departmentsHelp =>
      'Repairs are routed to these departments. Only colleagues who belong to a department can work on its repairs.';

  @override
  String get description => 'Description';

  @override
  String get devModeHelp => 'Server must run with AUTH_MODE=dev';

  @override
  String get developmentUser => 'Development user';

  @override
  String get deviceLanguage => 'Device language';

  @override
  String get difference => 'Difference';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get dismissRequest => 'Dismiss request';

  @override
  String get draftSaved => 'Draft saved';

  @override
  String get edit => 'Edit';

  @override
  String get editContact => 'Edit contact';

  @override
  String get editDepartment => 'Edit department';

  @override
  String get editJob => 'Edit job';

  @override
  String get email => 'E-mail';

  @override
  String get emailAddresses => 'E-mail addresses (the first is primary)';

  @override
  String get enterChange => 'Enter the change, e.g. 4.5 for +4.5 %.';

  @override
  String enterValidNumbersLine(int line) {
    return 'Line $line: enter valid numbers.';
  }

  @override
  String get expectedClose => 'Expected close';

  @override
  String expectedCloseDate(String date) {
    return 'Expected close $date';
  }

  @override
  String get expectedValue => 'Expected value';

  @override
  String get expectedValueEur => 'Expected value (€)';

  @override
  String get expectedValueOptional => 'Expected value (optional)';

  @override
  String get explode => 'Explode';

  @override
  String get families => 'Families';

  @override
  String get family => 'Family';

  @override
  String familyNamed(String code) {
    return 'Family $code';
  }

  @override
  String get faultDescription => 'What is wrong';

  @override
  String get firstName => 'First name';

  @override
  String get firstResponseMinutes => 'First response (min)';

  @override
  String get from => 'From';

  @override
  String get fromYou => 'You';

  @override
  String generalRebateInfo(String percent) {
    return 'General rebate on all products: $percent % (net-priced products are never discounted).';
  }

  @override
  String get generalRebatePercent => 'General rebate %';

  @override
  String greetingPreview(String greeting) {
    return 'Greeting: $greeting';
  }

  @override
  String get helpdesk => 'Helpdesk';

  @override
  String get helpdeskSettings => 'Helpdesk settings';

  @override
  String get history => 'History';

  @override
  String get inactive => 'inactive';

  @override
  String get inactiveContact => 'No longer active (left the company)';

  @override
  String indicativeLine(String description) {
    return '$description (indicative, to confirm)';
  }

  @override
  String indicativeToConfirm(int count) {
    return '$count indicative price(s) to confirm before the quotation can be sent: enter the agreed price in the list price field.';
  }

  @override
  String get insertPreparedAnswer => 'Insert prepared answer';

  @override
  String get instructions => 'Instructions';

  @override
  String get internalNote => 'Internal note';

  @override
  String internalQuestionHelp(String language) {
    return 'Internal question. Ask the customer in $language with a reply, then post the answer for your colleague as an internal note.';
  }

  @override
  String get internalTicket => 'Internal ticket';

  @override
  String get internalTicketHelp =>
      'A question between colleagues; nothing is sent to the customer.';

  @override
  String get jobCancelled => 'Cancelled';

  @override
  String get jobCompleted => 'Completed';

  @override
  String get jobInProgress => 'In progress';

  @override
  String get jobKindInspection => 'Inspection';

  @override
  String get jobKindInstallation => 'Installation';

  @override
  String get jobKindMaintenance => 'Maintenance';

  @override
  String get jobKindOther => 'Other';

  @override
  String get jobKindRepair => 'Repair';

  @override
  String get jobName => 'Title';

  @override
  String get jobPlanned => 'Planned';

  @override
  String get jobTitle => 'Job title';

  @override
  String get jobs => 'Jobs';

  @override
  String get keepAgreedPrices => 'Keep agreed prices';

  @override
  String get language => 'Language';

  @override
  String languageSameAsCustomer(String language) {
    return 'Same as company ($language)';
  }

  @override
  String get lastName => 'Last name';

  @override
  String get leadCreated => 'Lead created';

  @override
  String get lineDiscount => 'Line disc.';

  @override
  String get listPrice => 'List price';

  @override
  String get loadMore => 'Load more';

  @override
  String get logCall => 'Log call';

  @override
  String get logTime => 'Log time';

  @override
  String get logWork => 'Log work';

  @override
  String get loginLinkInvalid =>
      'This login link has expired or was already used. Request a new one.';

  @override
  String get loginLinkSent =>
      'If this address may use the portal, a login link is on its way. Check your inbox.';

  @override
  String get lookUp => 'Look up';

  @override
  String get lost => 'Lost';

  @override
  String get lostReason => 'Lost reason';

  @override
  String get markAsLost => 'Mark as lost';

  @override
  String get markAsSent => 'Mark as sent';

  @override
  String get markCompleted => 'Mark as completed';

  @override
  String get markReceived => 'Mark as received';

  @override
  String get markShipped => 'Mark as shipped back';

  @override
  String get markWaitingCustomer => 'Waiting for customer';

  @override
  String get markWaitingParts => 'Waiting for parts';

  @override
  String get materialRequirements => 'Material requirements (active revision)';

  @override
  String get mergeAction => 'Merge';

  @override
  String get mergeHelp =>
      'All messages, files, tags and time entries move to the chosen ticket of the same customer. This ticket is closed. This cannot be undone.';

  @override
  String get mergeNoCandidates => 'No other open ticket of this customer.';

  @override
  String get mergeTicket => 'Merge into another ticket…';

  @override
  String mergedInto(String number) {
    return 'Merged into $number';
  }

  @override
  String get message => 'Message';

  @override
  String get messageSent => 'Message sent';

  @override
  String get minutes => 'Minutes';

  @override
  String minutesShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get myJobs => 'My jobs';

  @override
  String get myOrders => 'My orders';

  @override
  String get myProfile => 'My details';

  @override
  String get myRepairs => 'My repairs';

  @override
  String get myTickets => 'My tickets';

  @override
  String get name => 'Name';

  @override
  String get navigate => 'Navigate';

  @override
  String get netPrice => 'Net price';

  @override
  String get newAnswer => 'New answer';

  @override
  String get newContact => 'New contact';

  @override
  String get newCustomer => 'New customer';

  @override
  String get newDepartment => 'New department';

  @override
  String get newFamily => 'New family';

  @override
  String get newItem => 'New';

  @override
  String get newJob => 'New job';

  @override
  String get newLabel => 'New';

  @override
  String get newOpportunity => 'New opportunity';

  @override
  String get newPrice => 'New price';

  @override
  String newPricesValidFrom(String date) {
    return 'New prices valid from $date';
  }

  @override
  String get newPriority => 'New priority';

  @override
  String get newProduct => 'New product';

  @override
  String get newQuotation => 'New quotation';

  @override
  String get newRepair => 'New repair';

  @override
  String get newRevision => 'New revision';

  @override
  String newRevisionOf(String number) {
    return 'New revision of $number';
  }

  @override
  String get newTeam => 'New team';

  @override
  String get newTicket => 'New ticket';

  @override
  String get noAccess =>
      'Your account has no access to any section yet. Ask an administrator.';

  @override
  String get noActiveBom => 'No active bill of materials.';

  @override
  String get noBom => 'No bill of materials yet.';

  @override
  String get noContactLinked => 'No contact person linked';

  @override
  String get noContacts => 'No contacts yet.';

  @override
  String get noCustomerLinked => 'No customer linked';

  @override
  String get noExpectedClose => 'No expected close date';

  @override
  String get noJobsAssigned => 'No jobs assigned to you.';

  @override
  String get noLines => 'No lines yet.';

  @override
  String get noOrdersYet => 'You have no orders yet.';

  @override
  String get noPermission =>
      'You do not have permission to change these settings.';

  @override
  String get noPhotos => 'No photos yet.';

  @override
  String get noPrices => 'No prices yet.';

  @override
  String get noPriorityChanges => 'No priority changes yet.';

  @override
  String get noPriorityRequests => 'No requests.';

  @override
  String get noQuotations => 'No quotations yet.';

  @override
  String get noRebates => 'No product or family rebates.';

  @override
  String get noRepairs => 'No repairs.';

  @override
  String get noRepairsYet => 'You have no repairs yet.';

  @override
  String get noSerialComponents => 'No serialised components.';

  @override
  String get noTeam => 'No team';

  @override
  String get noTechnicians => 'Nobody assigned';

  @override
  String get noTicketsYet => 'You have no tickets yet.';

  @override
  String get noTimeEntries => 'No time logged yet.';

  @override
  String get nobodyFound => 'Nobody found with this number.';

  @override
  String get none => 'None';

  @override
  String get notClosed => 'Not closed';

  @override
  String get notRouted => 'Not routed yet';

  @override
  String get notScheduled => 'Not scheduled';

  @override
  String get noteAdded => 'Note added';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get notes => 'Notes';

  @override
  String get number => 'Number';

  @override
  String get numberRequired => 'Number';

  @override
  String get obsoleteRevision => 'Obsolete revision (read-only).';

  @override
  String get oidcAccessToken => 'OIDC access token';

  @override
  String get ok => 'OK';

  @override
  String get onSiteContact => 'Person on site';

  @override
  String get openEnded => 'open';

  @override
  String get openJobsOnly => 'Active only';

  @override
  String get openOnly => 'Open only';

  @override
  String get openOpportunity => 'Open opportunity';

  @override
  String openPriorityRequests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count open priority requests',
      one: '1 open priority request',
    );
    return '$_temp0';
  }

  @override
  String openRepairsCount(String count) {
    return '$count open';
  }

  @override
  String get opportunities => 'Opportunities';

  @override
  String get opportunity => 'Opportunity';

  @override
  String get opportunityOptional => 'Opportunity (optional)';

  @override
  String get order => 'Order';

  @override
  String orderAlreadyConfirmed(String date) {
    return 'This order was confirmed on $date.';
  }

  @override
  String get orderAwaitingConfirmation => 'awaiting your confirmation';

  @override
  String get orderConfirmationQueued =>
      'Order confirmation queued for sending.';

  @override
  String get orderConfirmedSnack => 'Order confirmed.';

  @override
  String get orderConfirmedThanks => 'Thank you, your order is confirmed.';

  @override
  String get orderCreated => 'Order created';

  @override
  String get orderSaved => 'Order saved.';

  @override
  String get orderStatusInPlanning => 'in planning';

  @override
  String get orderStatusInProduction => 'in production';

  @override
  String get orderStatusPlanned => 'planned';

  @override
  String get orderStatusReadyForShipping => 'ready for shipping';

  @override
  String get orderStockRelease => 'Release';

  @override
  String get orderStockReserve => 'Reserve';

  @override
  String get orderStockReserveHint =>
      'Stock can be reserved once the customer has confirmed the order.';

  @override
  String orderStockThisLine(String quantity) {
    return '$quantity reserved for this line';
  }

  @override
  String get orderStockTitle => 'Stock availability';

  @override
  String get orders => 'Orders';

  @override
  String get owner => 'Owner';

  @override
  String get paymentDays => 'Payment days';

  @override
  String get pdf => 'PDF';

  @override
  String get personTitle => 'Title';

  @override
  String get phone => 'Phone';

  @override
  String get phoneCall => 'Phone call';

  @override
  String get phoneDirect => 'Direct';

  @override
  String get phoneHint => 'With country code, e.g. +32 475 12 34 56';

  @override
  String get phoneMobile => 'Mobile';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get phoneNumbers => 'Phone numbers';

  @override
  String get phoneOther => 'Other';

  @override
  String get phoneWork => 'Work';

  @override
  String photoBy(String name) {
    return 'by $name';
  }

  @override
  String get photos => 'Photos';

  @override
  String get photosAdded => 'Photos added';

  @override
  String get placeholdersHelp =>
      'Placeholders (click to insert in the current language):';

  @override
  String get portalAccess => 'Customer portal access';

  @override
  String get portalScope => 'Sees in the portal';

  @override
  String get portalScopeCustomer => 'All tickets of the company';

  @override
  String get portalScopeOwn => 'Own tickets only';

  @override
  String get portalSignInIntro =>
      'Enter your e-mail address. We will send you a link to sign in, no password needed.';

  @override
  String get portalTitle => 'Customer portal';

  @override
  String get postalCode => 'Postal code';

  @override
  String get preparedAnswers => 'Prepared answers';

  @override
  String get preparedAnswersHelp =>
      'Reusable answers to recurring questions, one text per language. Placeholders such as «quotation.number» are filled in for the ticket; the text can still be edited before sending.';

  @override
  String get preview => 'Preview';

  @override
  String priceListOf(String date) {
    return 'Price list of $date';
  }

  @override
  String get priceListValidOn => 'Price list valid on';

  @override
  String get priceZone => 'Price zone';

  @override
  String pricedOnPriceListOf(String date) {
    return 'Priced on the price list of $date';
  }

  @override
  String get prices => 'Prices';

  @override
  String pricesCreated(int count, String date) {
    return '$count prices created, valid from $date';
  }

  @override
  String pricesWillChange(int count) {
    return '$count prices will change';
  }

  @override
  String get pricing => 'Pricing';

  @override
  String get pricingIndicative => 'indicative';

  @override
  String get pricingIndicativeHelp => 'Indicative (confirm per quote)';

  @override
  String get pricingList => 'list price';

  @override
  String get pricingListHelp => 'List price (rebates apply)';

  @override
  String get pricingNet => 'net';

  @override
  String get pricingNetHelp => 'Net price (never discounted)';

  @override
  String get priority => 'Priority';

  @override
  String priorityChangeLine(String date, String from, String to, String name) {
    return '$date: $from → $to by $name';
  }

  @override
  String get priorityChangedSnack => 'Priority changed.';

  @override
  String get priorityExpedite => 'expedite';

  @override
  String get priorityHigh => 'high';

  @override
  String get priorityHistory => 'Priority history';

  @override
  String get priorityLow => 'low';

  @override
  String get priorityNormal => 'normal';

  @override
  String get priorityRequestHelp =>
      'Our team decides whether and how the priority is changed.';

  @override
  String priorityRequestLine(String name, String priority) {
    return '$name asks for priority: $priority';
  }

  @override
  String get priorityRequestSent => 'Your request has been sent.';

  @override
  String get priorityRequests => 'Customer priority requests';

  @override
  String get priorityUrgent => 'urgent';

  @override
  String get probability => 'Probability';

  @override
  String get probabilityPercent => 'Probability %';

  @override
  String get probabilityShort => 'Prob.';

  @override
  String get product => 'Product';

  @override
  String productCount(int count) {
    return '$count products';
  }

  @override
  String get productDescription => 'Product';

  @override
  String get productFamilies => 'Product families';

  @override
  String get productFamily => 'Product family';

  @override
  String get productRebates => 'Product rebates';

  @override
  String get productTypeConfigurable => 'configurable';

  @override
  String get productTypeManufactured => 'manufactured';

  @override
  String get productTypePurchased => 'purchased';

  @override
  String get productTypeService => 'service';

  @override
  String get products => 'Products';

  @override
  String get profileHelp =>
      'Choose the language and the way we address you in our e-mails and in this portal.';

  @override
  String get quantity => 'Quantity';

  @override
  String get question => 'Question';

  @override
  String get questionToSales => 'Question to sales';

  @override
  String questionToSalesHelp(String salesperson) {
    return '$salesperson gets this question and asks the customer in their language.';
  }

  @override
  String get quotation => 'Quotation';

  @override
  String get quotations => 'Quotations';

  @override
  String raisedBy(String name) {
    return 'Raised by $name';
  }

  @override
  String get reason => 'Reason';

  @override
  String get reasonRequired => 'A reason is required.';

  @override
  String get rebate => 'Rebate';

  @override
  String rebateFor(String target, String percent) {
    return '$target: $percent %';
  }

  @override
  String get rebatePercent => 'Rebate %';

  @override
  String get rebateSourceFamily => 'family';

  @override
  String get rebateSourceGeneral => 'general';

  @override
  String get rebateSourceProduct => 'product';

  @override
  String rebatesOf(String customer) {
    return 'Rebates · $customer';
  }

  @override
  String registerProduct(String product) {
    return 'Register $product';
  }

  @override
  String get registerUnit => 'Register unit';

  @override
  String get registered => 'Registered';

  @override
  String get rejected => 'Rejected';

  @override
  String get remove => 'Remove';

  @override
  String get removeAndScrap => 'Remove and scrap';

  @override
  String get removeBackToStock => 'Remove, back to stock';

  @override
  String get removeLine => 'Remove line';

  @override
  String removedBy(String date, String name) {
    return 'removed $date by $name';
  }

  @override
  String get reopenJob => 'Reopen job';

  @override
  String get repairAnnouncedByTicket =>
      'The customer announced it (the product has not arrived yet)';

  @override
  String get repairAnnouncedOk =>
      'Repair announced. Write the number on the parcel and send the product to us.';

  @override
  String get repairPhotosHelp =>
      'Photos of the product and the fault help us a lot.';

  @override
  String get repairPortalAnnounced => 'Announced, not received yet';

  @override
  String get repairPortalInRepair => 'In repair';

  @override
  String get repairPortalReady => 'Repaired, ready to ship';

  @override
  String get repairPortalWaitingCustomer => 'Waiting for your answer';

  @override
  String get repairStatusAnnounced => 'Announced';

  @override
  String get repairStatusCancelled => 'Cancelled';

  @override
  String get repairStatusCompleted => 'Completed';

  @override
  String get repairStatusInProgress => 'In progress';

  @override
  String get repairStatusReceived => 'Received';

  @override
  String get repairStatusRouted => 'In department queue';

  @override
  String get repairStatusShipped => 'Shipped back';

  @override
  String get repairStatusWaitingCustomer => 'Waiting for customer';

  @override
  String get repairStatusWaitingParts => 'Waiting for parts';

  @override
  String get repairs => 'Repairs';

  @override
  String get replyQueued => 'Reply queued for sending';

  @override
  String get replyToCustomer => 'Reply to customer';

  @override
  String repricingFailed(String error) {
    return 'Today\'s prices could not be calculated: $error';
  }

  @override
  String get requestDismissedSnack => 'Request dismissed.';

  @override
  String get requestLessUrgent => 'Less urgent';

  @override
  String get requestMoreUrgent => 'More urgent (expedite)';

  @override
  String get requestPriorityChange => 'Request priority change';

  @override
  String get requestStatusApplied => 'applied';

  @override
  String get requestStatusDismissed => 'dismissed';

  @override
  String get requestStatusOpen => 'open';

  @override
  String get required => 'Required';

  @override
  String get resolutionMinutes => 'Resolution (min)';

  @override
  String get retry => 'Retry';

  @override
  String get revisionActivated => 'Revision activated';

  @override
  String revisionItem(int revision, String status, int lines) {
    return 'Revision $revision · $status · $lines lines';
  }

  @override
  String get revisionNotes => 'Revision notes';

  @override
  String revisionNumber(int revision) {
    return 'Revision $revision';
  }

  @override
  String revisionPriceLists(String agreed, String current) {
    return 'Agreed prices: price list of $agreed. Current prices: price list of $current.';
  }

  @override
  String revisionViewNotice(int revision, int current) {
    return 'You are viewing revision $revision (read-only). The current revision is $current.';
  }

  @override
  String get revisions => 'Revisions';

  @override
  String get roleInvoicing => 'Invoicing';

  @override
  String get roleManagement => 'Management';

  @override
  String get roleOther => 'Other';

  @override
  String get rolePurchasing => 'Purchasing';

  @override
  String get roleQuality => 'Quality';

  @override
  String get roleSalesContact => 'Sales contact';

  @override
  String get roleTechnical => 'Technician';

  @override
  String get roles => 'Roles';

  @override
  String get roundTo => 'Round to';

  @override
  String get routeNote => 'Note for the department';

  @override
  String get routeRepair => 'Route to department';

  @override
  String get salesperson => 'Salesperson';

  @override
  String get save => 'Save';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get saveDraft => 'Save draft';

  @override
  String get saved => 'Saved';

  @override
  String savedNumber(String number) {
    return 'Saved $number';
  }

  @override
  String get scheduledEnd => 'End';

  @override
  String get scheduledStart => 'Start';

  @override
  String get scrapPercent => 'Scrap %';

  @override
  String get search => 'Search';

  @override
  String get send => 'Send';

  @override
  String get sendBackToTriage => 'Send back to triage';

  @override
  String get sendLoginLink => 'Send login link';

  @override
  String get sendOrderConfirmation => 'Send order confirmation';

  @override
  String get sendOrderConfirmationHelp =>
      'The order confirmation is e-mailed to the customer as a PDF. The revision can no longer be edited afterwards.';

  @override
  String get serial => 'serial';

  @override
  String get serialBuiltIn => 'built in';

  @override
  String get serialDelivered => 'delivered';

  @override
  String get serialInStock => 'in stock';

  @override
  String get serialInstalled => 'installed';

  @override
  String get serialNumber => 'Serial number';

  @override
  String get serialNumbers => 'Serial numbers';

  @override
  String get serialNumbersHelp =>
      'Every unit gets its own serial number and history';

  @override
  String get serialScrapped => 'scrapped';

  @override
  String get server => 'Server';

  @override
  String get showInactive => 'Show inactive';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String signedInAs(String name) {
    return 'Signed in as $name';
  }

  @override
  String get signingIn => 'Signing in…';

  @override
  String get singleProduct => 'Single product';

  @override
  String get siteAddress => 'Where to go';

  @override
  String get siteName => 'Site name';

  @override
  String skippedWithoutPrice(int count) {
    return '$count product/zone combinations have no price and are skipped';
  }

  @override
  String get sla => 'SLA';

  @override
  String get slaAtRisk => 'At risk';

  @override
  String get slaBreached => 'Breached';

  @override
  String slaDue(String date) {
    return 'Due $date';
  }

  @override
  String get slaFilterAny => 'Any SLA state';

  @override
  String get slaFirstResponse => 'First response';

  @override
  String slaLeft(String time) {
    return '$time left';
  }

  @override
  String get slaMet => 'Met';

  @override
  String get slaNone => 'No SLA';

  @override
  String get slaOnTime => 'On time';

  @override
  String slaOverdue(String time) {
    return '$time overdue';
  }

  @override
  String get slaPaused => 'Clock stopped: waiting for the customer';

  @override
  String get slaPolicies => 'Service levels (SLA)';

  @override
  String get slaPoliciesHelp =>
      'Plain elapsed time, business hours are not taken into account. The clock stops while a ticket waits for the customer.';

  @override
  String get slaResolution => 'Resolution';

  @override
  String get stage => 'Stage';

  @override
  String get stageLead => 'lead';

  @override
  String get stageLost => 'lost';

  @override
  String get stageNegotiation => 'negotiation';

  @override
  String get stageProposal => 'proposal';

  @override
  String get stageQualified => 'qualified';

  @override
  String get stageWon => 'won';

  @override
  String get startJob => 'Start job';

  @override
  String get startWork => 'Start work';

  @override
  String get status => 'Status';

  @override
  String get statusAccepted => 'accepted';

  @override
  String get statusAfterwards => 'Status afterwards';

  @override
  String get statusDraft => 'draft';

  @override
  String get statusRejected => 'rejected';

  @override
  String get statusSent => 'sent';

  @override
  String get statusSuperseded => 'superseded';

  @override
  String get stockAdjust => 'Adjust';

  @override
  String get stockAdjustReason => 'Why is the stock corrected?';

  @override
  String get stockAdjustRequired =>
      'Choose a location, enter a quantity and give a reason.';

  @override
  String get stockAllWarehouses => 'All warehouses';

  @override
  String get stockAssignedTo => 'Assigned to';

  @override
  String get stockAvailable => 'Available';

  @override
  String get stockBarcode => 'Barcode';

  @override
  String get stockBelowReorder => 'Below reorder level';

  @override
  String get stockChangeBy => 'Change by (+/−)';

  @override
  String get stockCounts => 'Stock counts';

  @override
  String stockExpiredQty(String quantity) {
    return '$quantity expired';
  }

  @override
  String get stockExpiry => 'Expiry date';

  @override
  String get stockFrom => 'From';

  @override
  String get stockInVans => 'In vans';

  @override
  String get stockInvalidNumbers =>
      'Cost, reorder levels and lead time must be numbers.';

  @override
  String get stockIssue => 'Issue';

  @override
  String get stockKindVan => 'Service van';

  @override
  String get stockKindWarehouse => 'Warehouse';

  @override
  String get stockLeadTime => 'Lead time (days)';

  @override
  String get stockLocation => 'Location';

  @override
  String get stockLocations => 'Stock by location';

  @override
  String get stockLot => 'Lot';

  @override
  String get stockLotNumber => 'Lot number';

  @override
  String get stockLotTrackingHelp => 'Lots / batches';

  @override
  String get stockMoves => 'Movements';

  @override
  String get stockNewLocation => 'New location';

  @override
  String get stockNewLot => 'New lot';

  @override
  String get stockNewQuantity => 'New quantity';

  @override
  String get stockNewVan => 'New service van';

  @override
  String get stockNewWarehouse => 'New warehouse';

  @override
  String get stockNoMoves => 'No movements yet';

  @override
  String get stockNoWarehouses =>
      'No warehouses yet. An administrator creates them here.';

  @override
  String get stockNote => 'Note';

  @override
  String get stockNothingInStock => 'Nothing in stock';

  @override
  String get stockOnHand => 'On hand';

  @override
  String get stockOnlyInStock => 'Only in stock';

  @override
  String get stockProductQuantityRequired =>
      'Choose a product and enter a quantity.';

  @override
  String get stockReasonConsumption => 'Consumption';

  @override
  String get stockReasonCorrection => 'Correction';

  @override
  String get stockReasonCount => 'Count';

  @override
  String get stockReasonManualReceipt => 'Manual receipt';

  @override
  String get stockReasonProductionOutput => 'Production output';

  @override
  String get stockReasonPurchaseReceipt => 'Purchase receipt';

  @override
  String get stockReasonRepairUse => 'Used in repair';

  @override
  String get stockReasonReturn => 'Customer return';

  @override
  String get stockReasonReversal => 'Reversal';

  @override
  String get stockReasonScrap => 'Scrap';

  @override
  String get stockReasonShipment => 'Shipment';

  @override
  String get stockReasonVanReplenishment => 'Van replenishment';

  @override
  String get stockReceive => 'Receive';

  @override
  String get stockReorderMax => 'Reorder maximum';

  @override
  String get stockReorderMin => 'Reorder minimum';

  @override
  String get stockReservations => 'Reserved for orders';

  @override
  String get stockReserved => 'Reserved';

  @override
  String get stockReverse => 'Reverse';

  @override
  String get stockReverseAnyway => 'Reverse anyway';

  @override
  String get stockReverseTitle => 'Reverse this movement';

  @override
  String get stockReversed => 'reversed';

  @override
  String stockShortBy(String quantity) {
    return 'Short by $quantity';
  }

  @override
  String get stockStandardCost => 'Standard cost';

  @override
  String get stockStateAvailable => 'In stock';

  @override
  String get stockStateNotStocked => 'Not stocked';

  @override
  String get stockStatePartial => 'Partly in stock';

  @override
  String get stockStateReserved => 'Reserved';

  @override
  String get stockStateShort => 'Not in stock';

  @override
  String get stockTitle => 'Stock';

  @override
  String get stockTo => 'To';

  @override
  String get stockTrackingLot => 'lot';

  @override
  String get stockTransfer => 'Transfer';

  @override
  String get stockWarehouse => 'Warehouse';

  @override
  String get stockWarehouses => 'Warehouses';

  @override
  String get street => 'Street';

  @override
  String get streetAddress => 'Street and number';

  @override
  String structureRevision(int revision) {
    return 'Structure (revision $revision)';
  }

  @override
  String get subassembly => 'subassembly';

  @override
  String get subject => 'Subject';

  @override
  String get subjectOptional => 'Subject (optional)';

  @override
  String suggested(String value) {
    return 'Suggested: $value';
  }

  @override
  String get tags => 'Tags';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get tasks => 'Tasks';

  @override
  String tasksProgress(String done, String total) {
    return '$done of $total done';
  }

  @override
  String get team => 'Team';

  @override
  String get teamLead => 'Lead';

  @override
  String get teamMembers => 'Members';

  @override
  String get teamName => 'Team name';

  @override
  String get teams => 'Teams';

  @override
  String get technicians => 'Technicians';

  @override
  String get text => 'Text';

  @override
  String get ticketClosed => 'Closed';

  @override
  String get ticketDetails => 'Ticket details';

  @override
  String get ticketInProgress => 'In progress';

  @override
  String get ticketMerged => 'Tickets merged';

  @override
  String get ticketOpened => 'Ticket opened';

  @override
  String get ticketStatusClosed => 'closed';

  @override
  String get ticketStatusNew => 'new';

  @override
  String get ticketStatusOpen => 'open';

  @override
  String get ticketStatusPendingCustomer => 'waiting for customer';

  @override
  String get ticketStatusPendingInternal => 'waiting for colleague';

  @override
  String get ticketWaitingForYou => 'Waiting for your reply';

  @override
  String get timeNote => 'Note';

  @override
  String timeTotal(String total, String billable) {
    return 'Total $total, billable $billable';
  }

  @override
  String timeTotals(String work, String travel) {
    return 'Work $work · Travel $travel';
  }

  @override
  String get timeTracking => 'Time tracking';

  @override
  String get title => 'Title';

  @override
  String get titleCustomerValueRequired =>
      'Title, customer and a valid value are required.';

  @override
  String get titleMr => 'Mr.';

  @override
  String get titleMs => 'Ms.';

  @override
  String get titleNone => 'Not specified';

  @override
  String get to => 'To';

  @override
  String get total => 'Total';

  @override
  String totalChange(String from, String to, String difference) {
    return 'Total excl. VAT: $from → $to ($difference)';
  }

  @override
  String get totalExclVat => 'Total excl. VAT';

  @override
  String get totalInclVat => 'Total incl. VAT';

  @override
  String get totalsToBuyOrMake => 'Totals to buy or make';

  @override
  String get tracking => 'Tracking';

  @override
  String get twoLetters => '2 letters';

  @override
  String get type => 'Type';

  @override
  String get unassigned => 'Unassigned';

  @override
  String get unchanged => 'Unchanged';

  @override
  String get unit => 'Unit';

  @override
  String get unitPrice => 'Unit price';

  @override
  String get unitPriceExclVat => 'Unit price (excl. VAT)';

  @override
  String get unknownCaller => 'Unknown caller';

  @override
  String get until => 'Until';

  @override
  String get updateToCurrentPrices => 'Update to current prices';

  @override
  String get updated => 'Updated';

  @override
  String get uploadingFile => 'Uploading…';

  @override
  String get uploadingPhotos => 'Uploading…';

  @override
  String get useAnotherPriceListDate => 'Use another price list date';

  @override
  String get validFrom => 'Valid from';

  @override
  String validFromDate(String date) {
    return 'Valid from $date';
  }

  @override
  String validUntil(String date) {
    return 'valid until $date';
  }

  @override
  String get value => 'Value';

  @override
  String get vat => 'VAT';

  @override
  String get vatNumber => 'VAT number';

  @override
  String vatOn(String rate, String base) {
    return 'VAT $rate % on $base';
  }

  @override
  String get vatPercent => 'VAT %';

  @override
  String get viaPortal => 'Via the customer portal';

  @override
  String get warranty => 'Warranty';

  @override
  String get warrantyIn => 'In warranty';

  @override
  String get warrantyOut => 'Out of warranty';

  @override
  String get warrantyUnknown => 'Unknown';

  @override
  String weighted(String amount) {
    return 'weighted $amount';
  }

  @override
  String get whatWasAsked => 'What was asked?';

  @override
  String get whoIsCalling => 'Who is calling?';

  @override
  String get won => 'Won';

  @override
  String get workFrom => 'From';

  @override
  String get workKindTravel => 'Travel';

  @override
  String get workKindWork => 'Work';

  @override
  String get workLogs => 'Time registered';

  @override
  String get workUntil => 'Until';

  @override
  String writeIn(String language) {
    return 'Write in $language';
  }

  @override
  String get yourMessage => 'Your message';

  @override
  String get yourReference => 'Your reference (RMA or order)';

  @override
  String get zone => 'Zone';

  @override
  String zoneAndRebate(String zone, String percent) {
    return 'Zone $zone · general rebate $percent %';
  }

  @override
  String get zonesNoneAll => 'Zones (none selected = all)';

  @override
  String get kbTitle => 'Knowledge base';

  @override
  String get kbNewArticle => 'New article';

  @override
  String get kbSearchHint => 'Search articles';

  @override
  String get kbAllCategories => 'All categories';

  @override
  String get kbAllStatuses => 'All statuses';

  @override
  String get kbAllAudiences => 'All audiences';

  @override
  String get kbManageCategories => 'Categories';

  @override
  String get kbStatusPublished => 'Published';

  @override
  String get kbStatusArchived => 'Archived';

  @override
  String get kbAudience => 'Audience';

  @override
  String get kbAudienceInternal => 'Internal (staff only)';

  @override
  String get kbAudiencePortal => 'Customer portal';

  @override
  String get kbAudiencePublic => 'Public';

  @override
  String get kbArticleTitle => 'Title';

  @override
  String get kbSummary => 'Summary';

  @override
  String get kbBody => 'Text (Markdown)';

  @override
  String get kbPreview => 'Preview';

  @override
  String get kbWriteTab => 'Write';

  @override
  String get kbMarkdownHelp =>
      'Use # for headings, **bold**, *italic*, - for lists, [text](https://…) for links and ![description](image:ID) for pictures.';

  @override
  String get kbTagsLabel => 'Tags (comma separated)';

  @override
  String get kbRelated => 'Related articles';

  @override
  String get kbAddRelated => 'Add related article';

  @override
  String get kbImages => 'Images';

  @override
  String get kbUploadImage => 'Upload image';

  @override
  String get kbInsertImage => 'Insert in text';

  @override
  String get kbPublish => 'Publish';

  @override
  String get kbUnpublish => 'Unpublish';

  @override
  String get kbArchive => 'Archive';

  @override
  String get kbHistory => 'Version history';

  @override
  String kbVersionLine(int version, String name, String date) {
    return 'Version $version · $name · $date';
  }

  @override
  String get kbRestore => 'Restore this version';

  @override
  String kbRestoredFrom(int version) {
    return 'restored from version $version';
  }

  @override
  String kbFeedback(int yes, int no) {
    return '$yes found this helpful, $no did not';
  }

  @override
  String kbViews(int count) {
    return '$count views';
  }

  @override
  String get kbNoArticles => 'No articles found.';

  @override
  String get kbNoCategory => 'No category';

  @override
  String get kbMainCategory => 'Main category';

  @override
  String get kbSortOrder => 'Sort order';

  @override
  String get kbNewCategory => 'New category';

  @override
  String get kbCategoryNames => 'Name per language';

  @override
  String get kbDelete => 'Delete';

  @override
  String get kbSuggestedArticles => 'Suggested articles';

  @override
  String get kbNoSuggestions => 'No matching articles.';

  @override
  String get kbInsertText => 'Insert text';

  @override
  String get kbInsertLink => 'Insert link';

  @override
  String get kbInsertArticle => 'Insert article';

  @override
  String get kbNoPortalLink =>
      'This article is internal: only its text can be inserted.';

  @override
  String get kbHelp => 'Help';

  @override
  String get kbHelpHeading => 'How can we help?';

  @override
  String get kbHelpSearch => 'Search the help articles';

  @override
  String get kbHelpEmpty => 'No articles found. You can open a ticket instead.';

  @override
  String get kbWasHelpful => 'Was this article helpful?';

  @override
  String get kbYes => 'Yes';

  @override
  String get kbNo => 'No';

  @override
  String get kbThanks => 'Thank you for your feedback.';

  @override
  String get kbStillNeedHelp => 'Still need help? Open a ticket.';

  @override
  String get kbRelatedReading => 'Related articles';

  @override
  String get kbDeflectionTitle =>
      'These articles may already answer your question';

  @override
  String kbShownIn(String language) {
    return 'Not available in your language; shown in $language.';
  }

  @override
  String kbUpdatedOn(String date) {
    return 'Updated $date';
  }
}
