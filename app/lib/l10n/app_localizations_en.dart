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
  String get addNote => 'Add note';

  @override
  String get addPhone => 'Add phone number';

  @override
  String get addProduct => 'Add product';

  @override
  String get addRebate => 'Add rebate';

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
  String get always => 'always';

  @override
  String andMore(int count) {
    return '… and $count more';
  }

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
  String get automatic => 'Automatic';

  @override
  String get billOfMaterials => 'Bill of materials';

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
  String get cancelled => 'cancelled';

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
  String get chooseCustomerAndLine =>
      'Choose a customer and add at least one valid line.';

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
  String get codeNameVatRequired => 'Code, name and VAT rate are required.';

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
  String get confirmed => 'confirmed';

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
  String countOf(int count, int total) {
    return '$count of $total';
  }

  @override
  String get country => 'Country';

  @override
  String get create => 'Create';

  @override
  String get createLead => 'Create lead';

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
  String get deliveryFailed => 'not sent';

  @override
  String get deliveryQueued => 'waiting to send';

  @override
  String get deliverySent => 'sent';

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
  String get draftSaved => 'Draft saved';

  @override
  String get edit => 'Edit';

  @override
  String get editContact => 'Edit contact';

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
  String get firstName => 'First name';

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
  String get jobTitle => 'Job title';

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
  String get materialRequirements => 'Material requirements (active revision)';

  @override
  String get message => 'Message';

  @override
  String get messageSent => 'Message sent';

  @override
  String minutesShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get myProfile => 'My details';

  @override
  String get myTickets => 'My tickets';

  @override
  String get name => 'Name';

  @override
  String get netPrice => 'Net price';

  @override
  String get newAnswer => 'New answer';

  @override
  String get newContact => 'New contact';

  @override
  String get newCustomer => 'New customer';

  @override
  String get newFamily => 'New family';

  @override
  String get newItem => 'New';

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
  String get newProduct => 'New product';

  @override
  String get newQuotation => 'New quotation';

  @override
  String get newRevision => 'New revision';

  @override
  String newRevisionOf(String number) {
    return 'New revision of $number';
  }

  @override
  String get newTicket => 'New ticket';

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
  String get noLines => 'No lines yet.';

  @override
  String get noPrices => 'No prices yet.';

  @override
  String get noQuotations => 'No quotations yet.';

  @override
  String get noRebates => 'No product or family rebates.';

  @override
  String get noSerialComponents => 'No serialised components.';

  @override
  String get noTicketsYet => 'You have no tickets yet.';

  @override
  String get nobodyFound => 'Nobody found with this number.';

  @override
  String get none => 'None';

  @override
  String get notClosed => 'Not closed';

  @override
  String get noteAdded => 'Note added';

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
  String get openEnded => 'open';

  @override
  String get openOnly => 'Open only';

  @override
  String get openOpportunity => 'Open opportunity';

  @override
  String get opportunities => 'Opportunities';

  @override
  String get opportunity => 'Opportunity';

  @override
  String get opportunityOptional => 'Opportunity (optional)';

  @override
  String get order => 'Order';

  @override
  String get orderCreated => 'Order created';

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
  String get priorityHigh => 'high';

  @override
  String get priorityLow => 'low';

  @override
  String get priorityNormal => 'normal';

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
  String removedBy(String date, String name) {
    return 'removed $date by $name';
  }

  @override
  String get replyQueued => 'Reply queued for sending';

  @override
  String get replyToCustomer => 'Reply to customer';

  @override
  String repricingFailed(String error) {
    return 'Today\'s prices could not be calculated: $error';
  }

  @override
  String get required => 'Required';

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
  String revisionPriceLists(String agreed, String current) {
    return 'Agreed prices: price list of $agreed. Current prices: price list of $current.';
  }

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
  String get scrapPercent => 'Scrap %';

  @override
  String get search => 'Search';

  @override
  String get send => 'Send';

  @override
  String get sendLoginLink => 'Send login link';

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
  String skippedWithoutPrice(int count) {
    return '$count product/zone combinations have no price and are skipped';
  }

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
  String get street => 'Street';

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
  String get text => 'Text';

  @override
  String get ticketClosed => 'Closed';

  @override
  String get ticketDetails => 'Ticket details';

  @override
  String get ticketInProgress => 'In progress';

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
  String writeIn(String language) {
    return 'Write in $language';
  }

  @override
  String get yourMessage => 'Your message';

  @override
  String get zone => 'Zone';

  @override
  String zoneAndRebate(String zone, String percent) {
    return 'Zone $zone · general rebate $percent %';
  }

  @override
  String get zonesNoneAll => 'Zones (none selected = all)';
}
