// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get accepted => 'Aanvaard';

  @override
  String get accessToken => 'Toegangstoken';

  @override
  String get account => 'Account';

  @override
  String get actions => 'Acties';

  @override
  String get activate => 'Activeren';

  @override
  String get active => 'Actief';

  @override
  String activeSince(String date) {
    return 'Actief sinds $date. Wijzigingen gebeuren via een nieuwe revisie.';
  }

  @override
  String get addComponent => 'Component toevoegen';

  @override
  String get addComponentBySerial =>
      'Component toevoegen op serienummer (in stock)';

  @override
  String get addNote => 'Notitie toevoegen';

  @override
  String get addNoteHint => 'Interne opmerking toevoegen';

  @override
  String get addPhone => 'Telefoonnummer toevoegen';

  @override
  String get addPhoto => 'Foto toevoegen';

  @override
  String get addProduct => 'Product toevoegen';

  @override
  String get addRebate => 'Korting toevoegen';

  @override
  String get addTask => 'Taak toevoegen';

  @override
  String addedBy(String date, String name) {
    return 'toegevoegd $date door $name';
  }

  @override
  String get addressForm => 'Aanspreekvorm';

  @override
  String get addressFormal => 'Formeel (u)';

  @override
  String get addressInformal => 'Informeel (je)';

  @override
  String get agreed => 'Afgesproken';

  @override
  String get all => 'Alle';

  @override
  String get allProducts => 'Alle producten';

  @override
  String get allStatuses => 'Alle statussen';

  @override
  String get always => 'altijd';

  @override
  String andMore(int count) {
    return '… en nog $count';
  }

  @override
  String get announceRepair => 'Herstelling aankondigen';

  @override
  String get announcedNotReceived => 'Aangekondigd, nog niet ontvangen';

  @override
  String answerFallback(String ticketLanguage, String usedLanguage) {
    return 'Nog geen tekst in het $ticketLanguage: de tekst in het $usedLanguage werd gebruikt. Vertaal voor verzending.';
  }

  @override
  String get appLanguage => 'Taal';

  @override
  String get appTitle => 'traydcraft';

  @override
  String get apply => 'Toepassen';

  @override
  String get assignTo => 'Toewijzen aan';

  @override
  String get automatic => 'Automatisch';

  @override
  String get backIntoWork => 'Terug in behandeling';

  @override
  String get billOfMaterials => 'Stuklijst';

  @override
  String get bomActive => 'actief';

  @override
  String get bomObsolete => 'vervallen';

  @override
  String get bomRev => 'Stuklijstrev.';

  @override
  String get bomRevision => 'Stuklijstrevisie';

  @override
  String get builtInto => 'Ingebouwd in';

  @override
  String get bulkKeepsQuotes =>
      'Offertes vóór deze datum blijven de huidige prijzen gebruiken';

  @override
  String get bulkPriceChange => 'Prijzen in bulk wijzigen';

  @override
  String get byStage => 'volgens fase';

  @override
  String get callIncoming => 'Inkomend gesprek';

  @override
  String get callLogged => 'Gesprek geregistreerd';

  @override
  String get callMinutes => 'Duur (minuten)';

  @override
  String get callOutgoing => 'Uitgaand gesprek';

  @override
  String get callSummary => 'Wat werd er besproken';

  @override
  String callWith(String name) {
    return 'Gesprek met $name';
  }

  @override
  String get canStillKeep => 'Je kunt de afgesproken prijzen nog behouden.';

  @override
  String get cancel => 'Annuleren';

  @override
  String get cancelJob => 'Opdracht annuleren';

  @override
  String get cancelRepair => 'Herstelling annuleren';

  @override
  String get cancelled => 'geannuleerd';

  @override
  String get category => 'Categorie';

  @override
  String get categoryComplaint => 'klacht';

  @override
  String get categoryLead => 'lead (nieuwe vraag)';

  @override
  String get categoryOrderConfirmation => 'orderbevestiging';

  @override
  String get categoryOther => 'andere';

  @override
  String get categoryProductionQuestion => 'vraag van productie';

  @override
  String get categoryQuestion => 'vraag';

  @override
  String get categoryQuoteChange => 'offerte aanpassen';

  @override
  String get categoryService => 'service / herstelling';

  @override
  String get cc => 'Cc';

  @override
  String get change => 'Wijziging';

  @override
  String get chooseCustomerAndLine =>
      'Kies een klant en voeg minstens één geldige lijn toe.';

  @override
  String get choosePhoto => 'Kies uit galerij';

  @override
  String get chooseRebateTarget =>
      'Kies een product of familie en geef een percentage in.';

  @override
  String get chooseZonePrice => 'Kies een zone en geef een prijs in.';

  @override
  String get city => 'Gemeente';

  @override
  String get close => 'Sluiten';

  @override
  String get code => 'Code';

  @override
  String get codeNameVatRequired => 'Code, naam en btw-tarief zijn verplicht.';

  @override
  String get completeJob => 'Opdracht afronden';

  @override
  String get completionNotes => 'Wat werd gedaan (en wat nog openstaat)';

  @override
  String get component => 'Component';

  @override
  String get componentHistory => 'Historiek componenten';

  @override
  String componentSince(String product, String date) {
    return '$product · sinds $date';
  }

  @override
  String get componentsAsBuilt => 'Componenten (zoals gebouwd)';

  @override
  String get confirm => 'bevestigen';

  @override
  String get confirmed => 'bevestigd';

  @override
  String conflictsOnDate(int count) {
    return '$count hebben al een prijs op deze datum';
  }

  @override
  String get contactName => 'Naam contactpersoon';

  @override
  String get contactPerson => 'Contactpersoon';

  @override
  String get contacts => 'Contactpersonen';

  @override
  String get convertHelp =>
      'Wil de klant nog iets wijzigen? Maak eerst een nieuwe revisie van de offerte, koppel die hier en zet ze dan om.';

  @override
  String get convertToOrder => 'Omzetten naar order';

  @override
  String countOf(int count, int total) {
    return '$count van $total';
  }

  @override
  String get country => 'Land';

  @override
  String get create => 'Aanmaken';

  @override
  String get createLead => 'Lead aanmaken';

  @override
  String get createRepair => 'Herstelling aanmaken';

  @override
  String get current => 'Huidig';

  @override
  String get customer => 'Klant';

  @override
  String get customerLanguage => 'Taal klant';

  @override
  String customerMainNumber(String name) {
    return 'Hoofdnummer van $name';
  }

  @override
  String customerNamed(String name) {
    return 'Klant: $name';
  }

  @override
  String get customerOptional => 'Klant (optioneel)';

  @override
  String get customerReference => 'Referentie klant';

  @override
  String get customers => 'Klanten';

  @override
  String get date => 'Datum';

  @override
  String get deliveryFailed => 'niet verzonden';

  @override
  String get deliveryQueued => 'wacht op verzending';

  @override
  String get deliverySent => 'verzonden';

  @override
  String get department => 'Afdeling';

  @override
  String get departmentCode => 'Code';

  @override
  String get departmentMembers => 'Collega\'s in deze afdeling';

  @override
  String get departments => 'Afdelingen';

  @override
  String get departmentsHelp =>
      'Herstellingen worden naar deze afdelingen doorgestuurd. Enkel collega\'s van een afdeling kunnen haar herstellingen behandelen.';

  @override
  String get description => 'Omschrijving';

  @override
  String get devModeHelp => 'De server moet draaien met AUTH_MODE=dev';

  @override
  String get developmentUser => 'Ontwikkelgebruiker';

  @override
  String get deviceLanguage => 'Taal van het toestel';

  @override
  String get difference => 'Verschil';

  @override
  String get draftSaved => 'Concept opgeslagen';

  @override
  String get edit => 'Bewerken';

  @override
  String get editContact => 'Contactpersoon bewerken';

  @override
  String get editDepartment => 'Afdeling bewerken';

  @override
  String get editJob => 'Opdracht bewerken';

  @override
  String get email => 'E-mail';

  @override
  String get emailAddresses => 'E-mailadressen (het eerste is het hoofdadres)';

  @override
  String get enterChange => 'Geef de wijziging in, bv. 4,5 voor +4,5 %.';

  @override
  String enterValidNumbersLine(int line) {
    return 'Lijn $line: geef geldige getallen in.';
  }

  @override
  String get expectedClose => 'Verwachte afsluiting';

  @override
  String expectedCloseDate(String date) {
    return 'Verwachte afsluiting $date';
  }

  @override
  String get expectedValue => 'Verwachte waarde';

  @override
  String get expectedValueEur => 'Verwachte waarde (€)';

  @override
  String get expectedValueOptional => 'Verwachte waarde (optioneel)';

  @override
  String get explode => 'Uitsplitsen';

  @override
  String get families => 'Families';

  @override
  String get family => 'Familie';

  @override
  String familyNamed(String code) {
    return 'Familie $code';
  }

  @override
  String get faultDescription => 'Wat is er mis';

  @override
  String get firstName => 'Voornaam';

  @override
  String get from => 'Vanaf';

  @override
  String get fromYou => 'U';

  @override
  String generalRebateInfo(String percent) {
    return 'Algemene korting op alle producten: $percent % (nettoproducten krijgen nooit korting).';
  }

  @override
  String get generalRebatePercent => 'Algemene korting %';

  @override
  String greetingPreview(String greeting) {
    return 'Aanspreking: $greeting';
  }

  @override
  String get helpdesk => 'Helpdesk';

  @override
  String get history => 'Geschiedenis';

  @override
  String get inactive => 'inactief';

  @override
  String get inactiveContact => 'Niet meer actief (vertrokken)';

  @override
  String indicativeLine(String description) {
    return '$description (indicatief, te bevestigen)';
  }

  @override
  String indicativeToConfirm(int count) {
    return '$count indicatieve prijs/prijzen te bevestigen voor de offerte verzonden kan worden: geef de afgesproken prijs in het veld lijstprijs in.';
  }

  @override
  String get insertPreparedAnswer => 'Standaardantwoord invoegen';

  @override
  String get instructions => 'Instructies';

  @override
  String get internalNote => 'Interne notitie';

  @override
  String internalQuestionHelp(String language) {
    return 'Interne vraag. Stel de vraag aan de klant in het $language via een antwoord, en zet het antwoord daarna als interne notitie voor je collega.';
  }

  @override
  String get internalTicket => 'Intern ticket';

  @override
  String get internalTicketHelp =>
      'Een vraag tussen collega\'s; er wordt niets naar de klant gestuurd.';

  @override
  String get jobCancelled => 'Geannuleerd';

  @override
  String get jobCompleted => 'Afgewerkt';

  @override
  String get jobInProgress => 'Bezig';

  @override
  String get jobKindInspection => 'Inspectie';

  @override
  String get jobKindInstallation => 'Installatie';

  @override
  String get jobKindMaintenance => 'Onderhoud';

  @override
  String get jobKindOther => 'Andere';

  @override
  String get jobKindRepair => 'Herstelling';

  @override
  String get jobName => 'Titel';

  @override
  String get jobPlanned => 'Gepland';

  @override
  String get jobTitle => 'Functie';

  @override
  String get jobs => 'Opdrachten';

  @override
  String get keepAgreedPrices => 'Afgesproken prijzen behouden';

  @override
  String get language => 'Taal';

  @override
  String languageSameAsCustomer(String language) {
    return 'Zelfde als het bedrijf ($language)';
  }

  @override
  String get lastName => 'Achternaam';

  @override
  String get leadCreated => 'Lead aangemaakt';

  @override
  String get lineDiscount => 'Lijnkorting';

  @override
  String get listPrice => 'Lijstprijs';

  @override
  String get loadMore => 'Meer laden';

  @override
  String get logCall => 'Gesprek registreren';

  @override
  String get logWork => 'Werk registreren';

  @override
  String get loginLinkInvalid =>
      'Deze aanmeldlink is verlopen of al gebruikt. Vraag een nieuwe aan.';

  @override
  String get loginLinkSent =>
      'Als dit adres het portaal mag gebruiken, is er een aanmeldlink onderweg. Controleer uw inbox.';

  @override
  String get lookUp => 'Opzoeken';

  @override
  String get lost => 'Verloren';

  @override
  String get lostReason => 'Reden verlies';

  @override
  String get markAsLost => 'Markeren als verloren';

  @override
  String get markAsSent => 'Markeren als verzonden';

  @override
  String get markCompleted => 'Markeer als afgewerkt';

  @override
  String get markReceived => 'Markeer als ontvangen';

  @override
  String get markShipped => 'Markeer als teruggestuurd';

  @override
  String get markWaitingCustomer => 'Wacht op klant';

  @override
  String get markWaitingParts => 'Wacht op onderdelen';

  @override
  String get materialRequirements => 'Materiaalbehoefte (actieve revisie)';

  @override
  String get message => 'Bericht';

  @override
  String get messageSent => 'Bericht verzonden';

  @override
  String minutesShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get myJobs => 'Mijn opdrachten';

  @override
  String get myProfile => 'Mijn gegevens';

  @override
  String get myRepairs => 'Mijn herstellingen';

  @override
  String get myTickets => 'Mijn tickets';

  @override
  String get name => 'Naam';

  @override
  String get navigate => 'Navigeer';

  @override
  String get netPrice => 'Nettoprijs';

  @override
  String get newAnswer => 'Nieuw antwoord';

  @override
  String get newContact => 'Nieuwe contactpersoon';

  @override
  String get newCustomer => 'Nieuwe klant';

  @override
  String get newDepartment => 'Nieuwe afdeling';

  @override
  String get newFamily => 'Nieuwe familie';

  @override
  String get newItem => 'Nieuw';

  @override
  String get newJob => 'Nieuwe opdracht';

  @override
  String get newLabel => 'Nieuw';

  @override
  String get newOpportunity => 'Nieuwe opportuniteit';

  @override
  String get newPrice => 'Nieuwe prijs';

  @override
  String newPricesValidFrom(String date) {
    return 'Nieuwe prijzen geldig vanaf $date';
  }

  @override
  String get newProduct => 'Nieuw product';

  @override
  String get newQuotation => 'Nieuwe offerte';

  @override
  String get newRepair => 'Nieuwe herstelling';

  @override
  String get newRevision => 'Nieuwe revisie';

  @override
  String newRevisionOf(String number) {
    return 'Nieuwe revisie van $number';
  }

  @override
  String get newTicket => 'Nieuw ticket';

  @override
  String get noAccess =>
      'Uw account heeft nog geen toegang tot een onderdeel. Vraag het aan een beheerder.';

  @override
  String get noActiveBom => 'Geen actieve stuklijst.';

  @override
  String get noBom => 'Nog geen stuklijst.';

  @override
  String get noContactLinked => 'Geen contactpersoon gekoppeld';

  @override
  String get noContacts => 'Nog geen contactpersonen.';

  @override
  String get noCustomerLinked => 'Geen klant gekoppeld';

  @override
  String get noExpectedClose => 'Geen verwachte afsluitdatum';

  @override
  String get noJobsAssigned => 'Geen opdrachten aan u toegewezen.';

  @override
  String get noLines => 'Nog geen lijnen.';

  @override
  String get noPhotos => 'Nog geen foto\'s.';

  @override
  String get noPrices => 'Nog geen prijzen.';

  @override
  String get noQuotations => 'Nog geen offertes.';

  @override
  String get noRebates => 'Geen product- of familiekortingen.';

  @override
  String get noRepairs => 'Geen herstellingen.';

  @override
  String get noRepairsYet => 'U hebt nog geen herstellingen.';

  @override
  String get noSerialComponents => 'Geen componenten met serienummer.';

  @override
  String get noTechnicians => 'Niemand toegewezen';

  @override
  String get noTicketsYet => 'U hebt nog geen tickets.';

  @override
  String get nobodyFound => 'Niemand gevonden met dit nummer.';

  @override
  String get none => 'Geen';

  @override
  String get notClosed => 'Niet afgesloten';

  @override
  String get notRouted => 'Nog niet doorgestuurd';

  @override
  String get notScheduled => 'Niet gepland';

  @override
  String get noteAdded => 'Notitie toegevoegd';

  @override
  String get notes => 'Opmerkingen';

  @override
  String get number => 'Nummer';

  @override
  String get numberRequired => 'Getal';

  @override
  String get obsoleteRevision => 'Vervallen revisie (alleen lezen).';

  @override
  String get oidcAccessToken => 'OIDC-toegangstoken';

  @override
  String get ok => 'OK';

  @override
  String get onSiteContact => 'Contactpersoon ter plaatse';

  @override
  String get openEnded => 'open';

  @override
  String get openJobsOnly => 'Enkel actieve';

  @override
  String get openOnly => 'Enkel open';

  @override
  String get openOpportunity => 'Opportuniteit openen';

  @override
  String openRepairsCount(String count) {
    return '$count open';
  }

  @override
  String get opportunities => 'Opportuniteiten';

  @override
  String get opportunity => 'Opportuniteit';

  @override
  String get opportunityOptional => 'Opportuniteit (optioneel)';

  @override
  String get order => 'Order';

  @override
  String get orderCreated => 'Order aangemaakt';

  @override
  String get orders => 'Orders';

  @override
  String get owner => 'Verantwoordelijke';

  @override
  String get paymentDays => 'Betalingstermijn (dagen)';

  @override
  String get pdf => 'PDF';

  @override
  String get personTitle => 'Aanspreektitel';

  @override
  String get phone => 'Telefoon';

  @override
  String get phoneCall => 'Telefoongesprek';

  @override
  String get phoneDirect => 'Rechtstreeks';

  @override
  String get phoneHint => 'Met landcode, bv. +32 475 12 34 56';

  @override
  String get phoneMobile => 'Gsm';

  @override
  String get phoneNumber => 'Telefoonnummer';

  @override
  String get phoneNumbers => 'Telefoonnummers';

  @override
  String get phoneOther => 'Andere';

  @override
  String get phoneWork => 'Werk';

  @override
  String photoBy(String name) {
    return 'door $name';
  }

  @override
  String get photos => 'Foto\'s';

  @override
  String get photosAdded => 'Foto\'s toegevoegd';

  @override
  String get placeholdersHelp =>
      'Plaatshouders (klik om in te voegen in de huidige taal):';

  @override
  String get portalAccess => 'Toegang tot het klantenportaal';

  @override
  String get portalScope => 'Ziet in het portaal';

  @override
  String get portalScopeCustomer => 'Alle tickets van het bedrijf';

  @override
  String get portalScopeOwn => 'Enkel eigen tickets';

  @override
  String get portalSignInIntro =>
      'Geef uw e-mailadres op. U ontvangt een link om aan te melden, een wachtwoord is niet nodig.';

  @override
  String get portalTitle => 'Klantenportaal';

  @override
  String get postalCode => 'Postcode';

  @override
  String get preparedAnswers => 'Standaardantwoorden';

  @override
  String get preparedAnswersHelp =>
      'Herbruikbare antwoorden op terugkerende vragen, één tekst per taal. Plaatshouders zoals «quotation.number» worden ingevuld voor het ticket; de tekst kan nog aangepast worden voor verzending.';

  @override
  String get preview => 'Voorbeeld';

  @override
  String priceListOf(String date) {
    return 'Prijslijst van $date';
  }

  @override
  String get priceListValidOn => 'Prijslijst geldig op';

  @override
  String get priceZone => 'Prijszone';

  @override
  String pricedOnPriceListOf(String date) {
    return 'Geprijsd volgens de prijslijst van $date';
  }

  @override
  String get prices => 'Prijzen';

  @override
  String pricesCreated(int count, String date) {
    return '$count prijzen aangemaakt, geldig vanaf $date';
  }

  @override
  String pricesWillChange(int count) {
    return '$count prijzen wijzigen';
  }

  @override
  String get pricing => 'Prijszetting';

  @override
  String get pricingIndicative => 'indicatief';

  @override
  String get pricingIndicativeHelp => 'Indicatief (per offerte bevestigen)';

  @override
  String get pricingList => 'lijstprijs';

  @override
  String get pricingListHelp => 'Lijstprijs (kortingen van toepassing)';

  @override
  String get pricingNet => 'netto';

  @override
  String get pricingNetHelp => 'Nettoprijs (nooit korting)';

  @override
  String get priority => 'Prioriteit';

  @override
  String get priorityHigh => 'hoog';

  @override
  String get priorityLow => 'laag';

  @override
  String get priorityNormal => 'normaal';

  @override
  String get priorityUrgent => 'dringend';

  @override
  String get probability => 'Kans';

  @override
  String get probabilityPercent => 'Kans %';

  @override
  String get probabilityShort => 'Kans';

  @override
  String get product => 'Product';

  @override
  String productCount(int count) {
    return '$count producten';
  }

  @override
  String get productDescription => 'Product';

  @override
  String get productFamilies => 'Productfamilies';

  @override
  String get productFamily => 'Productfamilie';

  @override
  String get productRebates => 'Productkortingen';

  @override
  String get productTypeConfigurable => 'configureerbaar';

  @override
  String get productTypeManufactured => 'eigen productie';

  @override
  String get productTypePurchased => 'aangekocht';

  @override
  String get productTypeService => 'dienst';

  @override
  String get products => 'Producten';

  @override
  String get profileHelp =>
      'Kies de taal en hoe wij u aanspreken in onze e-mails en in dit portaal.';

  @override
  String get quantity => 'Aantal';

  @override
  String get question => 'Vraag';

  @override
  String get questionToSales => 'Vraag aan verkoop';

  @override
  String questionToSalesHelp(String salesperson) {
    return '$salesperson krijgt deze vraag en stelt ze aan de klant in diens taal.';
  }

  @override
  String get quotation => 'Offerte';

  @override
  String get quotations => 'Offertes';

  @override
  String raisedBy(String name) {
    return 'Aangemaakt door $name';
  }

  @override
  String get reason => 'Reden';

  @override
  String get rebate => 'Korting';

  @override
  String rebateFor(String target, String percent) {
    return '$target: $percent %';
  }

  @override
  String get rebatePercent => 'Korting %';

  @override
  String get rebateSourceFamily => 'familie';

  @override
  String get rebateSourceGeneral => 'algemeen';

  @override
  String get rebateSourceProduct => 'product';

  @override
  String rebatesOf(String customer) {
    return 'Kortingen · $customer';
  }

  @override
  String registerProduct(String product) {
    return '$product registreren';
  }

  @override
  String get registerUnit => 'Exemplaar registreren';

  @override
  String get registered => 'Geregistreerd';

  @override
  String get rejected => 'Geweigerd';

  @override
  String get remove => 'Verwijderen';

  @override
  String get removeAndScrap => 'Verwijderen en afdanken';

  @override
  String get removeBackToStock => 'Verwijderen, terug naar stock';

  @override
  String removedBy(String date, String name) {
    return 'verwijderd $date door $name';
  }

  @override
  String get reopenJob => 'Opdracht heropenen';

  @override
  String get repairAnnouncedByTicket =>
      'De klant kondigde het aan (het product is nog niet toegekomen)';

  @override
  String get repairAnnouncedOk =>
      'Herstelling aangekondigd. Schrijf het nummer op het pakket en stuur het product naar ons op.';

  @override
  String get repairPhotosHelp =>
      'Foto\'s van het product en het defect helpen ons enorm.';

  @override
  String get repairPortalAnnounced => 'Aangekondigd, nog niet ontvangen';

  @override
  String get repairPortalInRepair => 'In herstelling';

  @override
  String get repairPortalReady => 'Hersteld, klaar voor verzending';

  @override
  String get repairPortalWaitingCustomer => 'Wacht op uw antwoord';

  @override
  String get repairStatusAnnounced => 'Aangekondigd';

  @override
  String get repairStatusCancelled => 'Geannuleerd';

  @override
  String get repairStatusCompleted => 'Afgewerkt';

  @override
  String get repairStatusInProgress => 'In behandeling';

  @override
  String get repairStatusReceived => 'Ontvangen';

  @override
  String get repairStatusRouted => 'In wachtrij van afdeling';

  @override
  String get repairStatusShipped => 'Teruggestuurd';

  @override
  String get repairStatusWaitingCustomer => 'Wacht op klant';

  @override
  String get repairStatusWaitingParts => 'Wacht op onderdelen';

  @override
  String get repairs => 'Herstellingen';

  @override
  String get replyQueued => 'Antwoord klaar voor verzending';

  @override
  String get replyToCustomer => 'Antwoord aan klant';

  @override
  String repricingFailed(String error) {
    return 'De prijzen van vandaag konden niet berekend worden: $error';
  }

  @override
  String get required => 'Verplicht';

  @override
  String get retry => 'Opnieuw';

  @override
  String get revisionActivated => 'Revisie geactiveerd';

  @override
  String revisionItem(int revision, String status, int lines) {
    return 'Revisie $revision · $status · $lines lijnen';
  }

  @override
  String get revisionNotes => 'Revisienotities';

  @override
  String revisionPriceLists(String agreed, String current) {
    return 'Afgesproken prijzen: prijslijst van $agreed. Huidige prijzen: prijslijst van $current.';
  }

  @override
  String get roleInvoicing => 'Facturatie';

  @override
  String get roleManagement => 'Directie';

  @override
  String get roleOther => 'Andere';

  @override
  String get rolePurchasing => 'Aankoop';

  @override
  String get roleQuality => 'Kwaliteit';

  @override
  String get roleSalesContact => 'Commercieel contact';

  @override
  String get roleTechnical => 'Technicus';

  @override
  String get roles => 'Rollen';

  @override
  String get roundTo => 'Afronden op';

  @override
  String get routeNote => 'Opmerking voor de afdeling';

  @override
  String get routeRepair => 'Doorsturen naar afdeling';

  @override
  String get salesperson => 'Verkoper';

  @override
  String get save => 'Opslaan';

  @override
  String get saveChanges => 'Wijzigingen opslaan';

  @override
  String get saveDraft => 'Concept opslaan';

  @override
  String get saved => 'Opgeslagen';

  @override
  String savedNumber(String number) {
    return '$number opgeslagen';
  }

  @override
  String get scheduledEnd => 'Einde';

  @override
  String get scheduledStart => 'Start';

  @override
  String get scrapPercent => 'Uitval %';

  @override
  String get search => 'Zoeken';

  @override
  String get send => 'Verzenden';

  @override
  String get sendBackToTriage => 'Terug naar triage';

  @override
  String get sendLoginLink => 'Verstuur aanmeldlink';

  @override
  String get serial => 'serienummer';

  @override
  String get serialBuiltIn => 'ingebouwd';

  @override
  String get serialDelivered => 'geleverd';

  @override
  String get serialInStock => 'in stock';

  @override
  String get serialInstalled => 'geïnstalleerd';

  @override
  String get serialNumber => 'Serienummer';

  @override
  String get serialNumbers => 'Serienummers';

  @override
  String get serialNumbersHelp =>
      'Elk exemplaar krijgt een eigen serienummer en historiek';

  @override
  String get serialScrapped => 'afgedankt';

  @override
  String get server => 'Server';

  @override
  String get showInactive => 'Toon inactieve';

  @override
  String get signIn => 'Aanmelden';

  @override
  String get signOut => 'Afmelden';

  @override
  String signedInAs(String name) {
    return 'Aangemeld als $name';
  }

  @override
  String get signingIn => 'Aanmelden…';

  @override
  String get singleProduct => 'Eén product';

  @override
  String get siteAddress => 'Waar naartoe';

  @override
  String get siteName => 'Naam van de locatie';

  @override
  String skippedWithoutPrice(int count) {
    return '$count product/zone-combinaties hebben geen prijs en worden overgeslagen';
  }

  @override
  String get stage => 'Fase';

  @override
  String get stageLead => 'lead';

  @override
  String get stageLost => 'verloren';

  @override
  String get stageNegotiation => 'onderhandeling';

  @override
  String get stageProposal => 'voorstel';

  @override
  String get stageQualified => 'gekwalificeerd';

  @override
  String get stageWon => 'gewonnen';

  @override
  String get startJob => 'Start opdracht';

  @override
  String get startWork => 'Start werk';

  @override
  String get status => 'Status';

  @override
  String get statusAccepted => 'aanvaard';

  @override
  String get statusAfterwards => 'Status daarna';

  @override
  String get statusDraft => 'concept';

  @override
  String get statusRejected => 'geweigerd';

  @override
  String get statusSent => 'verzonden';

  @override
  String get statusSuperseded => 'vervangen';

  @override
  String get street => 'Straat';

  @override
  String get streetAddress => 'Straat en nummer';

  @override
  String structureRevision(int revision) {
    return 'Structuur (revisie $revision)';
  }

  @override
  String get subassembly => 'subassemblage';

  @override
  String get subject => 'Onderwerp';

  @override
  String get subjectOptional => 'Onderwerp (optioneel)';

  @override
  String suggested(String value) {
    return 'Voorstel: $value';
  }

  @override
  String get takePhoto => 'Foto nemen';

  @override
  String get tasks => 'Taken';

  @override
  String tasksProgress(String done, String total) {
    return '$done van $total klaar';
  }

  @override
  String get technicians => 'Technici';

  @override
  String get text => 'Tekst';

  @override
  String get ticketClosed => 'Gesloten';

  @override
  String get ticketDetails => 'Ticketgegevens';

  @override
  String get ticketInProgress => 'In behandeling';

  @override
  String get ticketOpened => 'Ticket aangemaakt';

  @override
  String get ticketStatusClosed => 'afgesloten';

  @override
  String get ticketStatusNew => 'nieuw';

  @override
  String get ticketStatusOpen => 'open';

  @override
  String get ticketStatusPendingCustomer => 'wacht op klant';

  @override
  String get ticketStatusPendingInternal => 'wacht op collega';

  @override
  String get ticketWaitingForYou => 'Wacht op uw antwoord';

  @override
  String timeTotals(String work, String travel) {
    return 'Werk $work · Verplaatsing $travel';
  }

  @override
  String get title => 'Titel';

  @override
  String get titleCustomerValueRequired =>
      'Titel, klant en een geldige waarde zijn verplicht.';

  @override
  String get titleMr => 'Dhr.';

  @override
  String get titleMs => 'Mevr.';

  @override
  String get titleNone => 'Niet opgegeven';

  @override
  String get to => 'Aan';

  @override
  String get total => 'Totaal';

  @override
  String totalChange(String from, String to, String difference) {
    return 'Totaal excl. btw: $from → $to ($difference)';
  }

  @override
  String get totalExclVat => 'Totaal excl. btw';

  @override
  String get totalInclVat => 'Totaal incl. btw';

  @override
  String get totalsToBuyOrMake => 'Totalen aan te kopen of te maken';

  @override
  String get tracking => 'Tracering';

  @override
  String get twoLetters => '2 letters';

  @override
  String get type => 'Type';

  @override
  String get unassigned => 'Niet toegewezen';

  @override
  String get unchanged => 'Ongewijzigd';

  @override
  String get unit => 'Eenheid';

  @override
  String get unitPrice => 'Eenheidsprijs';

  @override
  String get unitPriceExclVat => 'Eenheidsprijs (excl. btw)';

  @override
  String get unknownCaller => 'Onbekende beller';

  @override
  String get until => 'Tot';

  @override
  String get updateToCurrentPrices => 'Bijwerken naar huidige prijzen';

  @override
  String get updated => 'Bijgewerkt';

  @override
  String get uploadingPhotos => 'Uploaden…';

  @override
  String get useAnotherPriceListDate => 'Andere prijslijstdatum gebruiken';

  @override
  String get validFrom => 'Geldig vanaf';

  @override
  String validFromDate(String date) {
    return 'Geldig vanaf $date';
  }

  @override
  String validUntil(String date) {
    return 'geldig tot $date';
  }

  @override
  String get value => 'Waarde';

  @override
  String get vat => 'Btw';

  @override
  String get vatNumber => 'Btw-nummer';

  @override
  String vatOn(String rate, String base) {
    return 'Btw $rate % op $base';
  }

  @override
  String get vatPercent => 'Btw %';

  @override
  String get viaPortal => 'Via het klantenportaal';

  @override
  String get warranty => 'Garantie';

  @override
  String get warrantyIn => 'Onder garantie';

  @override
  String get warrantyOut => 'Buiten garantie';

  @override
  String get warrantyUnknown => 'Onbekend';

  @override
  String weighted(String amount) {
    return 'gewogen $amount';
  }

  @override
  String get whatWasAsked => 'Wat werd er gevraagd?';

  @override
  String get whoIsCalling => 'Wie belt er?';

  @override
  String get won => 'Gewonnen';

  @override
  String get workFrom => 'Van';

  @override
  String get workKindTravel => 'Verplaatsing';

  @override
  String get workKindWork => 'Werk';

  @override
  String get workLogs => 'Geregistreerde tijd';

  @override
  String get workUntil => 'Tot';

  @override
  String writeIn(String language) {
    return 'Schrijf in het $language';
  }

  @override
  String get yourMessage => 'Uw bericht';

  @override
  String get yourReference => 'Uw referentie (RMA of bestelling)';

  @override
  String get zone => 'Zone';

  @override
  String zoneAndRebate(String zone, String percent) {
    return 'Zone $zone · algemene korting $percent %';
  }

  @override
  String get zonesNoneAll => 'Zones (geen selectie = alle)';
}
