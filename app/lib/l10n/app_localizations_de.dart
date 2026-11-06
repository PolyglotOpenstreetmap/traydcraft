// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get accepted => 'Angenommen';

  @override
  String get accessToken => 'Zugriffstoken';

  @override
  String get account => 'Konto';

  @override
  String get actions => 'Aktionen';

  @override
  String get activate => 'Aktivieren';

  @override
  String get active => 'Aktiv';

  @override
  String activeSince(String date) {
    return 'Aktiv seit $date. Änderungen erfolgen über eine neue Revision.';
  }

  @override
  String get addComponent => 'Komponente hinzufügen';

  @override
  String get addComponentBySerial =>
      'Komponente per Seriennummer hinzufügen (auf Lager)';

  @override
  String get addMember => 'Mitglied hinzufügen';

  @override
  String get addNote => 'Notiz hinzufügen';

  @override
  String get addNoteHint => 'Interne Notiz hinzufügen';

  @override
  String get addPhone => 'Nummer hinzufügen';

  @override
  String get addPhoto => 'Foto hinzufügen';

  @override
  String get addProduct => 'Produkt hinzufügen';

  @override
  String get addRebate => 'Rabatt hinzufügen';

  @override
  String get addTag => 'Tag hinzufügen';

  @override
  String get addTask => 'Aufgabe hinzufügen';

  @override
  String addedBy(String date, String name) {
    return 'hinzugefügt am $date von $name';
  }

  @override
  String get addressForm => 'Anredeform';

  @override
  String get addressFormal => 'Förmlich (Sie)';

  @override
  String get addressInformal => 'Informell (du)';

  @override
  String get agreed => 'Vereinbart';

  @override
  String get all => 'Alle';

  @override
  String get allProducts => 'Alle Produkte';

  @override
  String get allStatuses => 'Alle Status';

  @override
  String get allTags => 'Alle Tags';

  @override
  String get allTeams => 'Alle Teams';

  @override
  String get always => 'immer';

  @override
  String andMore(int count) {
    return '… und $count weitere';
  }

  @override
  String get announceRepair => 'Reparatur ankündigen';

  @override
  String get announcedNotReceived => 'Angekündigt, noch nicht eingegangen';

  @override
  String answerFallback(String ticketLanguage, String usedLanguage) {
    return 'Noch kein Text auf $ticketLanguage: der Text auf $usedLanguage wurde verwendet. Vor dem Senden übersetzen.';
  }

  @override
  String get appLanguage => 'Sprache';

  @override
  String get appTitle => 'traydcraft';

  @override
  String get apply => 'Anwenden';

  @override
  String get assignTo => 'Zuweisen an';

  @override
  String get attachFile => 'Datei anhängen';

  @override
  String get attachments => 'Anhänge';

  @override
  String get attachmentsHelp => 'Bilder (JPEG, PNG, WebP) und PDF, bis 12 MB';

  @override
  String get automatic => 'Automatisch';

  @override
  String get backIntoWork => 'Zurück in Arbeit';

  @override
  String get backToCurrentRevision => 'Zurück zur aktuellen Revision';

  @override
  String get billOfMaterials => 'Stückliste';

  @override
  String get billable => 'Abrechenbar';

  @override
  String get bomActive => 'aktiv';

  @override
  String get bomObsolete => 'veraltet';

  @override
  String get bomRev => 'Stücklistenrev.';

  @override
  String get bomRevision => 'Stücklistenrevision';

  @override
  String get builtInto => 'Verbaut in';

  @override
  String get bulkKeepsQuotes =>
      'Angebote vor diesem Datum behalten die aktuellen Preise';

  @override
  String get bulkPriceChange => 'Preise gesammelt ändern';

  @override
  String get byStage => 'nach Phase';

  @override
  String get callIncoming => 'Eingehender Anruf';

  @override
  String get callLogged => 'Anruf erfasst';

  @override
  String get callMinutes => 'Dauer (Minuten)';

  @override
  String get callOutgoing => 'Ausgehender Anruf';

  @override
  String get callSummary => 'Gesprächsinhalt';

  @override
  String callWith(String name) {
    return 'Gespräch mit $name';
  }

  @override
  String get canStillKeep =>
      'Die vereinbarten Preise können beibehalten werden.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get cancelJob => 'Einsatz stornieren';

  @override
  String get cancelOrder => 'Auftrag stornieren';

  @override
  String get cancelReasonLabel => 'Stornierungsgrund';

  @override
  String get cancelRepair => 'Reparatur stornieren';

  @override
  String get cancelled => 'storniert';

  @override
  String cancelledReason(String reason) {
    return 'Storniert: $reason';
  }

  @override
  String get cannotConfirmNewer =>
      'Eine neuere Revision dieses Auftrags wird vorbereitet. Sie können sie bestätigen, sobald sie Ihnen zugesandt wurde.';

  @override
  String get cannotConfirmOther =>
      'Dieser Auftrag kann nicht bestätigt werden.';

  @override
  String get category => 'Kategorie';

  @override
  String get categoryComplaint => 'Reklamation';

  @override
  String get categoryLead => 'Lead (neue Anfrage)';

  @override
  String get categoryOrderConfirmation => 'Auftragsbestätigung';

  @override
  String get categoryOther => 'sonstiges';

  @override
  String get categoryProductionQuestion => 'Rückfrage Produktion';

  @override
  String get categoryQuestion => 'Frage';

  @override
  String get categoryQuoteChange => 'Angebotsänderung';

  @override
  String get categoryService => 'Service / Reparatur';

  @override
  String get cc => 'Cc';

  @override
  String get change => 'Änderung';

  @override
  String get changePriority => 'Priorität ändern';

  @override
  String get chooseCustomerAndLine =>
      'Kunden wählen und mindestens eine gültige Position hinzufügen.';

  @override
  String get choosePhoto => 'Aus Galerie wählen';

  @override
  String get chooseRebateTarget =>
      'Produkt oder Familie wählen und Prozentsatz eingeben.';

  @override
  String get chooseZonePrice => 'Zone wählen und Preis eingeben.';

  @override
  String get city => 'Ort';

  @override
  String get close => 'Schließen';

  @override
  String get code => 'Code';

  @override
  String get codeNameVatRequired =>
      'Code, Name und MwSt.-Satz sind Pflichtfelder.';

  @override
  String get completeJob => 'Einsatz abschließen';

  @override
  String get completionNotes => 'Was wurde getan (und was offen bleibt)';

  @override
  String get component => 'Komponente';

  @override
  String get componentHistory => 'Komponentenhistorie';

  @override
  String componentSince(String product, String date) {
    return '$product · seit $date';
  }

  @override
  String get componentsAsBuilt => 'Komponenten (wie gebaut)';

  @override
  String get confirm => 'bestätigen';

  @override
  String get confirmOnBehalf => 'Im Namen des Kunden bestätigen';

  @override
  String get confirmOnBehalfHelp =>
      'Halten Sie fest, dass der Kunde diese Revision bestätigt hat, zum Beispiel telefonisch oder per E-Mail.';

  @override
  String get confirmOrder => 'Auftrag bestätigen';

  @override
  String get confirmOrderHelp =>
      'Mit der Bestätigung akzeptieren Sie diesen Auftrag wie dargestellt.';

  @override
  String get confirmation => 'Bestätigung';

  @override
  String get confirmationDate => 'Bestätigt am';

  @override
  String get confirmed => 'bestätigt';

  @override
  String get confirmedRevision => 'Bestätigte Revision';

  @override
  String get confirmedVia => 'Bestätigt über';

  @override
  String get confirmedViaPortal => 'Kundenportal';

  @override
  String get confirmedViaStaff => 'Mitarbeiter, im Namen des Kunden';

  @override
  String conflictsOnDate(int count) {
    return '$count haben an diesem Datum bereits einen Preis';
  }

  @override
  String get contactName => 'Name des Ansprechpartners';

  @override
  String get contactPerson => 'Ansprechpartner';

  @override
  String get contacts => 'Kontakte';

  @override
  String get convertHelp =>
      'Wünscht der Kunde Änderungen? Erst eine neue Angebotsrevision erstellen, hier verknüpfen und dann umwandeln.';

  @override
  String get convertToOrder => 'In Auftrag umwandeln';

  @override
  String countOf(int count, int total) {
    return '$count von $total';
  }

  @override
  String get country => 'Land';

  @override
  String get create => 'Anlegen';

  @override
  String get createLead => 'Lead anlegen';

  @override
  String get createRepair => 'Reparatur anlegen';

  @override
  String get csatAlready => 'Diese Umfrage wurde bereits beantwortet.';

  @override
  String get csatBad => 'Nicht zufrieden';

  @override
  String get csatComment => 'Kommentar (optional)';

  @override
  String get csatEnabled =>
      'Zufriedenheitsumfrage beim Schließen eines Tickets senden';

  @override
  String get csatExpired => 'Dieser Link ist abgelaufen.';

  @override
  String get csatGood => 'Zufrieden';

  @override
  String get csatNone => 'Noch keine Bewertung';

  @override
  String csatQuestion(String number) {
    return 'Wie zufrieden sind Sie mit der Bearbeitung von Ticket $number?';
  }

  @override
  String get csatThanks => 'Vielen Dank für Ihr Feedback!';

  @override
  String get csatTitle => 'Kundenzufriedenheit';

  @override
  String get current => 'Aktuell';

  @override
  String get customer => 'Kunde';

  @override
  String get customerLanguage => 'Kundensprache';

  @override
  String customerMainNumber(String name) {
    return 'Hauptnummer von $name';
  }

  @override
  String customerNamed(String name) {
    return 'Kunde: $name';
  }

  @override
  String get customerOptional => 'Kunde (optional)';

  @override
  String get customerReference => 'Kundenreferenz';

  @override
  String get customers => 'Kunden';

  @override
  String get date => 'Datum';

  @override
  String get defaultTeam => 'Standardteam für neue Tickets';

  @override
  String get deliveryFailed => 'nicht gesendet';

  @override
  String get deliveryQueued => 'wartet auf Versand';

  @override
  String get deliverySent => 'gesendet';

  @override
  String get department => 'Abteilung';

  @override
  String get departmentCode => 'Kürzel';

  @override
  String get departmentMembers => 'Kollegen dieser Abteilung';

  @override
  String get departments => 'Abteilungen';

  @override
  String get departmentsHelp =>
      'Reparaturen werden an diese Abteilungen weitergeleitet. Nur Kollegen einer Abteilung können deren Reparaturen bearbeiten.';

  @override
  String get description => 'Beschreibung';

  @override
  String get devModeHelp => 'Der Server muss mit AUTH_MODE=dev laufen';

  @override
  String get developmentUser => 'Entwicklungsbenutzer';

  @override
  String get deviceLanguage => 'Gerätesprache';

  @override
  String get difference => 'Differenz';

  @override
  String get dismiss => 'Ablehnen';

  @override
  String get dismissRequest => 'Anfrage ablehnen';

  @override
  String get draftSaved => 'Entwurf gespeichert';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get editContact => 'Kontakt bearbeiten';

  @override
  String get editDepartment => 'Abteilung bearbeiten';

  @override
  String get editJob => 'Einsatz bearbeiten';

  @override
  String get email => 'E-Mail';

  @override
  String get emailAddresses =>
      'E-Mail-Adressen (die erste ist die Hauptadresse)';

  @override
  String get enterChange => 'Änderung eingeben, z. B. 4,5 für +4,5 %.';

  @override
  String enterValidNumbersLine(int line) {
    return 'Position $line: gültige Zahlen eingeben.';
  }

  @override
  String get expectedClose => 'Voraussichtlicher Abschluss';

  @override
  String expectedCloseDate(String date) {
    return 'Voraussichtlicher Abschluss $date';
  }

  @override
  String get expectedValue => 'Erwarteter Wert';

  @override
  String get expectedValueEur => 'Erwarteter Wert (€)';

  @override
  String get expectedValueOptional => 'Erwarteter Wert (optional)';

  @override
  String get explode => 'Auflösen';

  @override
  String get families => 'Familien';

  @override
  String get family => 'Familie';

  @override
  String familyNamed(String code) {
    return 'Familie $code';
  }

  @override
  String get faultDescription => 'Was ist defekt';

  @override
  String get firstName => 'Vorname';

  @override
  String get firstResponseMinutes => 'Erstreaktion (Min.)';

  @override
  String get from => 'Ab';

  @override
  String get fromYou => 'Sie';

  @override
  String generalRebateInfo(String percent) {
    return 'Allgemeiner Rabatt auf alle Produkte: $percent % (Nettopreisprodukte werden nie rabattiert).';
  }

  @override
  String get generalRebatePercent => 'Allgemeiner Rabatt %';

  @override
  String greetingPreview(String greeting) {
    return 'Anrede: $greeting';
  }

  @override
  String get helpdesk => 'Kundendienst';

  @override
  String get helpdeskSettings => 'Helpdesk-Einstellungen';

  @override
  String get history => 'Verlauf';

  @override
  String get inactive => 'inaktiv';

  @override
  String get inactiveContact => 'Nicht mehr aktiv (ausgeschieden)';

  @override
  String indicativeLine(String description) {
    return '$description (unverbindlich, zu bestätigen)';
  }

  @override
  String indicativeToConfirm(int count) {
    return '$count unverbindliche(r) Preis(e) vor dem Versand zu bestätigen: den vereinbarten Preis im Feld Listenpreis eingeben.';
  }

  @override
  String get insertPreparedAnswer => 'Textbaustein einfügen';

  @override
  String get instructions => 'Anweisungen';

  @override
  String get internalNote => 'Interne Notiz';

  @override
  String internalQuestionHelp(String language) {
    return 'Interne Frage. Fragen Sie den Kunden per Antwort auf $language und geben Sie die Antwort danach als interne Notiz an Ihren Kollegen weiter.';
  }

  @override
  String get internalTicket => 'Internes Ticket';

  @override
  String get internalTicketHelp =>
      'Eine Frage unter Kollegen; nichts wird an den Kunden gesendet.';

  @override
  String get jobCancelled => 'Storniert';

  @override
  String get jobCompleted => 'Abgeschlossen';

  @override
  String get jobInProgress => 'In Arbeit';

  @override
  String get jobKindInspection => 'Inspektion';

  @override
  String get jobKindInstallation => 'Installation';

  @override
  String get jobKindMaintenance => 'Wartung';

  @override
  String get jobKindOther => 'Sonstiges';

  @override
  String get jobKindRepair => 'Reparatur';

  @override
  String get jobName => 'Titel';

  @override
  String get jobPlanned => 'Geplant';

  @override
  String get jobTitle => 'Funktion';

  @override
  String get jobs => 'Einsätze';

  @override
  String get keepAgreedPrices => 'Vereinbarte Preise beibehalten';

  @override
  String get language => 'Sprache';

  @override
  String languageSameAsCustomer(String language) {
    return 'Wie das Unternehmen ($language)';
  }

  @override
  String get lastName => 'Nachname';

  @override
  String get leadCreated => 'Lead angelegt';

  @override
  String get lineDiscount => 'Zeilenrabatt';

  @override
  String get listPrice => 'Listenpreis';

  @override
  String get loadMore => 'Mehr laden';

  @override
  String get logCall => 'Anruf erfassen';

  @override
  String get logTime => 'Zeit erfassen';

  @override
  String get logWork => 'Arbeit erfassen';

  @override
  String get loginLinkInvalid =>
      'Dieser Anmeldelink ist abgelaufen oder wurde bereits verwendet. Fordern Sie einen neuen an.';

  @override
  String get loginLinkSent =>
      'Wenn diese Adresse das Portal nutzen darf, ist ein Anmeldelink unterwegs. Prüfen Sie Ihren Posteingang.';

  @override
  String get lookUp => 'Suchen';

  @override
  String get lost => 'Verloren';

  @override
  String get lostReason => 'Verlustgrund';

  @override
  String get markAsLost => 'Als verloren markieren';

  @override
  String get markAsSent => 'Als versendet markieren';

  @override
  String get markCompleted => 'Als abgeschlossen markieren';

  @override
  String get markReceived => 'Als eingegangen markieren';

  @override
  String get markShipped => 'Als zurückgesendet markieren';

  @override
  String get markWaitingCustomer => 'Wartet auf Kunden';

  @override
  String get markWaitingParts => 'Wartet auf Teile';

  @override
  String get materialRequirements => 'Materialbedarf (aktive Revision)';

  @override
  String get mergeAction => 'Zusammenführen';

  @override
  String get mergeHelp =>
      'Alle Nachrichten, Dateien, Tags und Zeiteinträge wandern in das gewählte Ticket desselben Kunden. Dieses Ticket wird geschlossen. Das kann nicht rückgängig gemacht werden.';

  @override
  String get mergeNoCandidates => 'Kein anderes offenes Ticket dieses Kunden.';

  @override
  String get mergeTicket => 'In anderes Ticket zusammenführen…';

  @override
  String mergedInto(String number) {
    return 'Zusammengeführt mit $number';
  }

  @override
  String get message => 'Nachricht';

  @override
  String get messageSent => 'Nachricht gesendet';

  @override
  String get minutes => 'Minuten';

  @override
  String minutesShort(String minutes) {
    return '$minutes Min.';
  }

  @override
  String get myJobs => 'Meine Einsätze';

  @override
  String get myOrders => 'Meine Aufträge';

  @override
  String get myProfile => 'Meine Daten';

  @override
  String get myRepairs => 'Meine Reparaturen';

  @override
  String get myTickets => 'Meine Tickets';

  @override
  String get name => 'Name';

  @override
  String get navigate => 'Navigieren';

  @override
  String get netPrice => 'Nettopreis';

  @override
  String get newAnswer => 'Neuer Textbaustein';

  @override
  String get newContact => 'Neuer Kontakt';

  @override
  String get newCustomer => 'Neuer Kunde';

  @override
  String get newDepartment => 'Neue Abteilung';

  @override
  String get newFamily => 'Neue Familie';

  @override
  String get newItem => 'Neu';

  @override
  String get newJob => 'Neuer Einsatz';

  @override
  String get newLabel => 'Neu';

  @override
  String get newOpportunity => 'Neue Verkaufschance';

  @override
  String get newPrice => 'Neuer Preis';

  @override
  String newPricesValidFrom(String date) {
    return 'Neue Preise gültig ab $date';
  }

  @override
  String get newPriority => 'Neue Priorität';

  @override
  String get newProduct => 'Neues Produkt';

  @override
  String get newQuotation => 'Neues Angebot';

  @override
  String get newRepair => 'Neue Reparatur';

  @override
  String get newRevision => 'Neue Revision';

  @override
  String newRevisionOf(String number) {
    return 'Neue Revision von $number';
  }

  @override
  String get newTeam => 'Neues Team';

  @override
  String get newTicket => 'Neues Ticket';

  @override
  String get noAccess =>
      'Ihr Konto hat noch keinen Zugriff auf einen Bereich. Fragen Sie einen Administrator.';

  @override
  String get noActiveBom => 'Keine aktive Stückliste.';

  @override
  String get noBom => 'Noch keine Stückliste.';

  @override
  String get noContactLinked => 'Kein Ansprechpartner verknüpft';

  @override
  String get noContacts => 'Noch keine Kontakte.';

  @override
  String get noCustomerLinked => 'Kein Kunde verknüpft';

  @override
  String get noExpectedClose => 'Kein voraussichtliches Abschlussdatum';

  @override
  String get noJobsAssigned => 'Ihnen sind keine Einsätze zugewiesen.';

  @override
  String get noLines => 'Noch keine Positionen.';

  @override
  String get noOrdersYet => 'Sie haben noch keine Aufträge.';

  @override
  String get noPermission =>
      'Sie haben keine Berechtigung, diese Einstellungen zu ändern.';

  @override
  String get noPhotos => 'Noch keine Fotos.';

  @override
  String get noPrices => 'Noch keine Preise.';

  @override
  String get noPriorityChanges => 'Noch keine Prioritätsänderungen.';

  @override
  String get noPriorityRequests => 'Keine Anfragen.';

  @override
  String get noQuotations => 'Noch keine Angebote.';

  @override
  String get noRebates => 'Keine Produkt- oder Familienrabatte.';

  @override
  String get noRepairs => 'Keine Reparaturen.';

  @override
  String get noRepairsYet => 'Sie haben noch keine Reparaturen.';

  @override
  String get noSerialComponents => 'Keine Komponenten mit Seriennummer.';

  @override
  String get noTeam => 'Kein Team';

  @override
  String get noTechnicians => 'Niemand zugewiesen';

  @override
  String get noTicketsYet => 'Sie haben noch keine Tickets.';

  @override
  String get noTimeEntries => 'Noch keine Zeit erfasst.';

  @override
  String get nobodyFound => 'Niemand mit dieser Nummer gefunden.';

  @override
  String get none => 'Keine';

  @override
  String get notClosed => 'Nicht geschlossen';

  @override
  String get notRouted => 'Noch nicht weitergeleitet';

  @override
  String get notScheduled => 'Nicht geplant';

  @override
  String get noteAdded => 'Notiz hinzugefügt';

  @override
  String get noteOptional => 'Bemerkung (optional)';

  @override
  String get notes => 'Bemerkungen';

  @override
  String get number => 'Nummer';

  @override
  String get numberRequired => 'Zahl';

  @override
  String get obsoleteRevision => 'Veraltete Revision (nur Lesen).';

  @override
  String get oidcAccessToken => 'OIDC-Zugriffstoken';

  @override
  String get ok => 'OK';

  @override
  String get onSiteContact => 'Ansprechpartner vor Ort';

  @override
  String get openEnded => 'offen';

  @override
  String get openJobsOnly => 'Nur aktive';

  @override
  String get openOnly => 'Nur offene';

  @override
  String get openOpportunity => 'Verkaufschance öffnen';

  @override
  String openPriorityRequests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count offene Prioritätsanfragen',
      one: '1 offene Prioritätsanfrage',
    );
    return '$_temp0';
  }

  @override
  String openRepairsCount(String count) {
    return '$count offen';
  }

  @override
  String get opportunities => 'Verkaufschancen';

  @override
  String get opportunity => 'Verkaufschance';

  @override
  String get opportunityOptional => 'Verkaufschance (optional)';

  @override
  String get order => 'Auftrag';

  @override
  String orderAlreadyConfirmed(String date) {
    return 'Dieser Auftrag wurde am $date bestätigt.';
  }

  @override
  String get orderAwaitingConfirmation => 'wartet auf Ihre Bestätigung';

  @override
  String get orderConfirmationQueued =>
      'Die Auftragsbestätigung wurde zum Versand vorgemerkt.';

  @override
  String get orderConfirmedSnack => 'Auftrag bestätigt.';

  @override
  String get orderConfirmedThanks => 'Vielen Dank, Ihr Auftrag ist bestätigt.';

  @override
  String get orderCreated => 'Auftrag angelegt';

  @override
  String get orderSaved => 'Auftrag gespeichert.';

  @override
  String get orderStatusInPlanning => 'in Planung';

  @override
  String get orderStatusInProduction => 'in Produktion';

  @override
  String get orderStatusPlanned => 'geplant';

  @override
  String get orderStatusReadyForShipping => 'versandbereit';

  @override
  String get orders => 'Aufträge';

  @override
  String get owner => 'Verantwortlich';

  @override
  String get paymentDays => 'Zahlungsziel (Tage)';

  @override
  String get pdf => 'PDF';

  @override
  String get personTitle => 'Anrede';

  @override
  String get phone => 'Telefon';

  @override
  String get phoneCall => 'Telefonanruf';

  @override
  String get phoneDirect => 'Durchwahl';

  @override
  String get phoneHint => 'Mit Ländervorwahl, z. B. +32 475 12 34 56';

  @override
  String get phoneMobile => 'Mobil';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get phoneNumbers => 'Telefonnummern';

  @override
  String get phoneOther => 'Sonstige';

  @override
  String get phoneWork => 'Büro';

  @override
  String photoBy(String name) {
    return 'von $name';
  }

  @override
  String get photos => 'Fotos';

  @override
  String get photosAdded => 'Fotos hinzugefügt';

  @override
  String get placeholdersHelp =>
      'Platzhalter (klicken zum Einfügen in der aktuellen Sprache):';

  @override
  String get portalAccess => 'Zugang zum Kundenportal';

  @override
  String get portalScope => 'Sieht im Portal';

  @override
  String get portalScopeCustomer => 'Alle Tickets des Unternehmens';

  @override
  String get portalScopeOwn => 'Nur eigene Tickets';

  @override
  String get portalSignInIntro =>
      'Geben Sie Ihre E-Mail-Adresse ein. Wir senden Ihnen einen Anmeldelink, ein Passwort ist nicht nötig.';

  @override
  String get portalTitle => 'Kundenportal';

  @override
  String get postalCode => 'PLZ';

  @override
  String get preparedAnswers => 'Textbausteine';

  @override
  String get preparedAnswersHelp =>
      'Wiederverwendbare Antworten auf wiederkehrende Fragen, ein Text pro Sprache. Platzhalter wie «quotation.number» werden für das Ticket ausgefüllt; der Text kann vor dem Senden noch bearbeitet werden.';

  @override
  String get preview => 'Vorschau';

  @override
  String priceListOf(String date) {
    return 'Preisliste vom $date';
  }

  @override
  String get priceListValidOn => 'Preisliste gültig am';

  @override
  String get priceZone => 'Preiszone';

  @override
  String pricedOnPriceListOf(String date) {
    return 'Kalkuliert nach der Preisliste vom $date';
  }

  @override
  String get prices => 'Preise';

  @override
  String pricesCreated(int count, String date) {
    return '$count Preise angelegt, gültig ab $date';
  }

  @override
  String pricesWillChange(int count) {
    return '$count Preise werden geändert';
  }

  @override
  String get pricing => 'Preisbildung';

  @override
  String get pricingIndicative => 'unverbindlich';

  @override
  String get pricingIndicativeHelp => 'Unverbindlich (je Angebot bestätigen)';

  @override
  String get pricingList => 'Listenpreis';

  @override
  String get pricingListHelp => 'Listenpreis (Rabatte gelten)';

  @override
  String get pricingNet => 'netto';

  @override
  String get pricingNetHelp => 'Nettopreis (nie rabattiert)';

  @override
  String get priority => 'Priorität';

  @override
  String priorityChangeLine(String date, String from, String to, String name) {
    return '$date: $from → $to von $name';
  }

  @override
  String get priorityChangedSnack => 'Priorität geändert.';

  @override
  String get priorityExpedite => 'dringend';

  @override
  String get priorityHigh => 'hoch';

  @override
  String get priorityHistory => 'Prioritätsverlauf';

  @override
  String get priorityLow => 'niedrig';

  @override
  String get priorityNormal => 'normal';

  @override
  String get priorityRequestHelp =>
      'Unser Team entscheidet, ob und wie die Priorität geändert wird.';

  @override
  String priorityRequestLine(String name, String priority) {
    return '$name wünscht Priorität: $priority';
  }

  @override
  String get priorityRequestSent => 'Ihre Anfrage wurde gesendet.';

  @override
  String get priorityRequests => 'Prioritätsanfragen des Kunden';

  @override
  String get priorityUrgent => 'dringend';

  @override
  String get probability => 'Wahrscheinlichkeit';

  @override
  String get probabilityPercent => 'Wahrscheinlichkeit %';

  @override
  String get probabilityShort => 'Wahrsch.';

  @override
  String get product => 'Produkt';

  @override
  String productCount(int count) {
    return '$count Produkte';
  }

  @override
  String get productDescription => 'Produkt';

  @override
  String get productFamilies => 'Produktfamilien';

  @override
  String get productFamily => 'Produktfamilie';

  @override
  String get productRebates => 'Produktrabatte';

  @override
  String get productTypeConfigurable => 'konfigurierbar';

  @override
  String get productTypeManufactured => 'eigengefertigt';

  @override
  String get productTypePurchased => 'zugekauft';

  @override
  String get productTypeService => 'Dienstleistung';

  @override
  String get products => 'Produkte';

  @override
  String get profileHelp =>
      'Wählen Sie die Sprache und die Anrede in unseren E-Mails und in diesem Portal.';

  @override
  String get quantity => 'Menge';

  @override
  String get question => 'Frage';

  @override
  String get questionToSales => 'Frage an den Vertrieb';

  @override
  String questionToSalesHelp(String salesperson) {
    return '$salesperson erhält diese Frage und stellt sie dem Kunden in seiner Sprache.';
  }

  @override
  String get quotation => 'Angebot';

  @override
  String get quotations => 'Angebote';

  @override
  String raisedBy(String name) {
    return 'Erstellt von $name';
  }

  @override
  String get reason => 'Grund';

  @override
  String get reasonRequired => 'Ein Grund ist erforderlich.';

  @override
  String get rebate => 'Rabatt';

  @override
  String rebateFor(String target, String percent) {
    return '$target: $percent %';
  }

  @override
  String get rebatePercent => 'Rabatt %';

  @override
  String get rebateSourceFamily => 'Familie';

  @override
  String get rebateSourceGeneral => 'allgemein';

  @override
  String get rebateSourceProduct => 'Produkt';

  @override
  String rebatesOf(String customer) {
    return 'Rabatte · $customer';
  }

  @override
  String registerProduct(String product) {
    return '$product erfassen';
  }

  @override
  String get registerUnit => 'Einheit erfassen';

  @override
  String get registered => 'Erfasst';

  @override
  String get rejected => 'Abgelehnt';

  @override
  String get remove => 'Entfernen';

  @override
  String get removeAndScrap => 'Entfernen und verschrotten';

  @override
  String get removeBackToStock => 'Entfernen, zurück ins Lager';

  @override
  String get removeLine => 'Zeile entfernen';

  @override
  String removedBy(String date, String name) {
    return 'entfernt am $date von $name';
  }

  @override
  String get reopenJob => 'Einsatz wieder öffnen';

  @override
  String get repairAnnouncedByTicket =>
      'Der Kunde hat sie angekündigt (das Produkt ist noch nicht eingetroffen)';

  @override
  String get repairAnnouncedOk =>
      'Reparatur angekündigt. Schreiben Sie die Nummer auf das Paket und senden Sie uns das Produkt.';

  @override
  String get repairPhotosHelp =>
      'Fotos vom Produkt und vom Defekt helfen uns sehr.';

  @override
  String get repairPortalAnnounced => 'Angekündigt, noch nicht eingegangen';

  @override
  String get repairPortalInRepair => 'In Reparatur';

  @override
  String get repairPortalReady => 'Repariert, versandbereit';

  @override
  String get repairPortalWaitingCustomer => 'Wartet auf Ihre Antwort';

  @override
  String get repairStatusAnnounced => 'Angekündigt';

  @override
  String get repairStatusCancelled => 'Storniert';

  @override
  String get repairStatusCompleted => 'Abgeschlossen';

  @override
  String get repairStatusInProgress => 'In Arbeit';

  @override
  String get repairStatusReceived => 'Eingegangen';

  @override
  String get repairStatusRouted => 'In der Abteilungswarteschlange';

  @override
  String get repairStatusShipped => 'Zurückgesendet';

  @override
  String get repairStatusWaitingCustomer => 'Wartet auf Kunden';

  @override
  String get repairStatusWaitingParts => 'Wartet auf Teile';

  @override
  String get repairs => 'Reparaturen';

  @override
  String get replyQueued => 'Antwort zum Versand bereit';

  @override
  String get replyToCustomer => 'Antwort an Kunden';

  @override
  String repricingFailed(String error) {
    return 'Die heutigen Preise konnten nicht berechnet werden: $error';
  }

  @override
  String get requestDismissedSnack => 'Anfrage abgelehnt.';

  @override
  String get requestLessUrgent => 'Weniger dringend';

  @override
  String get requestMoreUrgent => 'Dringender (eilig)';

  @override
  String get requestPriorityChange => 'Prioritätsänderung anfragen';

  @override
  String get requestStatusApplied => 'angewendet';

  @override
  String get requestStatusDismissed => 'abgelehnt';

  @override
  String get requestStatusOpen => 'offen';

  @override
  String get required => 'Pflichtfeld';

  @override
  String get resolutionMinutes => 'Lösung (Min.)';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get revisionActivated => 'Revision aktiviert';

  @override
  String revisionItem(int revision, String status, int lines) {
    return 'Revision $revision · $status · $lines Positionen';
  }

  @override
  String get revisionNotes => 'Revisionsnotizen';

  @override
  String revisionNumber(int revision) {
    return 'Revision $revision';
  }

  @override
  String revisionPriceLists(String agreed, String current) {
    return 'Vereinbarte Preise: Preisliste vom $agreed. Aktuelle Preise: Preisliste vom $current.';
  }

  @override
  String revisionViewNotice(int revision, int current) {
    return 'Sie sehen Revision $revision (schreibgeschützt). Die aktuelle Revision ist $current.';
  }

  @override
  String get revisions => 'Revisionen';

  @override
  String get roleInvoicing => 'Buchhaltung';

  @override
  String get roleManagement => 'Geschäftsleitung';

  @override
  String get roleOther => 'Sonstige';

  @override
  String get rolePurchasing => 'Einkauf';

  @override
  String get roleQuality => 'Qualität';

  @override
  String get roleSalesContact => 'Vertriebskontakt';

  @override
  String get roleTechnical => 'Techniker';

  @override
  String get roles => 'Rollen';

  @override
  String get roundTo => 'Runden auf';

  @override
  String get routeNote => 'Hinweis für die Abteilung';

  @override
  String get routeRepair => 'An Abteilung weiterleiten';

  @override
  String get salesperson => 'Verkäufer';

  @override
  String get save => 'Speichern';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get saveDraft => 'Entwurf speichern';

  @override
  String get saved => 'Gespeichert';

  @override
  String savedNumber(String number) {
    return '$number gespeichert';
  }

  @override
  String get scheduledEnd => 'Ende';

  @override
  String get scheduledStart => 'Beginn';

  @override
  String get scrapPercent => 'Ausschuss %';

  @override
  String get search => 'Suchen';

  @override
  String get send => 'Senden';

  @override
  String get sendBackToTriage => 'Zurück zur Triage';

  @override
  String get sendLoginLink => 'Anmeldelink senden';

  @override
  String get sendOrderConfirmation => 'Auftragsbestätigung senden';

  @override
  String get sendOrderConfirmationHelp =>
      'Die Auftragsbestätigung wird dem Kunden als PDF per E-Mail geschickt. Die Revision kann danach nicht mehr bearbeitet werden.';

  @override
  String get serial => 'Seriennr.';

  @override
  String get serialBuiltIn => 'verbaut';

  @override
  String get serialDelivered => 'geliefert';

  @override
  String get serialInStock => 'auf Lager';

  @override
  String get serialInstalled => 'installiert';

  @override
  String get serialNumber => 'Seriennummer';

  @override
  String get serialNumbers => 'Seriennummern';

  @override
  String get serialNumbersHelp =>
      'Jede Einheit erhält eine eigene Seriennummer und Historie';

  @override
  String get serialScrapped => 'verschrottet';

  @override
  String get server => 'Server';

  @override
  String get showInactive => 'Inaktive anzeigen';

  @override
  String get signIn => 'Anmelden';

  @override
  String get signOut => 'Abmelden';

  @override
  String signedInAs(String name) {
    return 'Angemeldet als $name';
  }

  @override
  String get signingIn => 'Anmeldung…';

  @override
  String get singleProduct => 'Einzelnes Produkt';

  @override
  String get siteAddress => 'Einsatzort';

  @override
  String get siteName => 'Name des Standorts';

  @override
  String skippedWithoutPrice(int count) {
    return '$count Produkt/Zonen-Kombinationen haben keinen Preis und werden übersprungen';
  }

  @override
  String get sla => 'SLA';

  @override
  String get slaAtRisk => 'Gefährdet';

  @override
  String get slaBreached => 'Überschritten';

  @override
  String slaDue(String date) {
    return 'Fällig $date';
  }

  @override
  String get slaFilterAny => 'Jeder SLA-Status';

  @override
  String get slaFirstResponse => 'Erstreaktion';

  @override
  String slaLeft(String time) {
    return 'noch $time';
  }

  @override
  String get slaMet => 'Eingehalten';

  @override
  String get slaNone => 'Kein SLA';

  @override
  String get slaOnTime => 'Im Plan';

  @override
  String slaOverdue(String time) {
    return '$time überfällig';
  }

  @override
  String get slaPaused => 'Uhr angehalten: wartet auf den Kunden';

  @override
  String get slaPolicies => 'Service-Level (SLA)';

  @override
  String get slaPoliciesHelp =>
      'Reine verstrichene Zeit, Geschäftszeiten werden nicht berücksichtigt. Die Uhr steht, solange ein Ticket auf den Kunden wartet.';

  @override
  String get slaResolution => 'Lösung';

  @override
  String get stage => 'Phase';

  @override
  String get stageLead => 'Lead';

  @override
  String get stageLost => 'verloren';

  @override
  String get stageNegotiation => 'Verhandlung';

  @override
  String get stageProposal => 'Angebot';

  @override
  String get stageQualified => 'qualifiziert';

  @override
  String get stageWon => 'gewonnen';

  @override
  String get startJob => 'Einsatz starten';

  @override
  String get startWork => 'Arbeit beginnen';

  @override
  String get status => 'Status';

  @override
  String get statusAccepted => 'angenommen';

  @override
  String get statusAfterwards => 'Status danach';

  @override
  String get statusDraft => 'Entwurf';

  @override
  String get statusRejected => 'abgelehnt';

  @override
  String get statusSent => 'versendet';

  @override
  String get statusSuperseded => 'ersetzt';

  @override
  String get street => 'Straße';

  @override
  String get streetAddress => 'Straße und Nr.';

  @override
  String structureRevision(int revision) {
    return 'Struktur (Revision $revision)';
  }

  @override
  String get subassembly => 'Baugruppe';

  @override
  String get subject => 'Betreff';

  @override
  String get subjectOptional => 'Betreff (optional)';

  @override
  String suggested(String value) {
    return 'Vorschlag: $value';
  }

  @override
  String get tags => 'Tags';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get tasks => 'Aufgaben';

  @override
  String tasksProgress(String done, String total) {
    return '$done von $total erledigt';
  }

  @override
  String get team => 'Team';

  @override
  String get teamLead => 'Teamleiter';

  @override
  String get teamMembers => 'Mitglieder';

  @override
  String get teamName => 'Teamname';

  @override
  String get teams => 'Teams';

  @override
  String get technicians => 'Techniker';

  @override
  String get text => 'Text';

  @override
  String get ticketClosed => 'Geschlossen';

  @override
  String get ticketDetails => 'Ticketdetails';

  @override
  String get ticketInProgress => 'In Bearbeitung';

  @override
  String get ticketMerged => 'Tickets zusammengeführt';

  @override
  String get ticketOpened => 'Ticket erstellt';

  @override
  String get ticketStatusClosed => 'geschlossen';

  @override
  String get ticketStatusNew => 'neu';

  @override
  String get ticketStatusOpen => 'offen';

  @override
  String get ticketStatusPendingCustomer => 'wartet auf Kunden';

  @override
  String get ticketStatusPendingInternal => 'wartet auf Kollegen';

  @override
  String get ticketWaitingForYou => 'Wartet auf Ihre Antwort';

  @override
  String get timeNote => 'Notiz';

  @override
  String timeTotal(String total, String billable) {
    return 'Gesamt $total, abrechenbar $billable';
  }

  @override
  String timeTotals(String work, String travel) {
    return 'Arbeit $work · Fahrt $travel';
  }

  @override
  String get timeTracking => 'Zeiterfassung';

  @override
  String get title => 'Titel';

  @override
  String get titleCustomerValueRequired =>
      'Titel, Kunde und ein gültiger Wert sind erforderlich.';

  @override
  String get titleMr => 'Herr';

  @override
  String get titleMs => 'Frau';

  @override
  String get titleNone => 'Nicht angegeben';

  @override
  String get to => 'An';

  @override
  String get total => 'Gesamt';

  @override
  String totalChange(String from, String to, String difference) {
    return 'Summe netto: $from → $to ($difference)';
  }

  @override
  String get totalExclVat => 'Summe netto';

  @override
  String get totalInclVat => 'Gesamtbetrag brutto';

  @override
  String get totalsToBuyOrMake => 'Summen zu kaufen oder zu fertigen';

  @override
  String get tracking => 'Rückverfolgung';

  @override
  String get twoLetters => '2 Buchstaben';

  @override
  String get type => 'Typ';

  @override
  String get unassigned => 'Nicht zugewiesen';

  @override
  String get unchanged => 'Unverändert';

  @override
  String get unit => 'Einheit';

  @override
  String get unitPrice => 'Einzelpreis';

  @override
  String get unitPriceExclVat => 'Einzelpreis (netto)';

  @override
  String get unknownCaller => 'Unbekannter Anrufer';

  @override
  String get until => 'Bis';

  @override
  String get updateToCurrentPrices => 'Auf aktuelle Preise aktualisieren';

  @override
  String get updated => 'Aktualisiert';

  @override
  String get uploadingFile => 'Wird hochgeladen…';

  @override
  String get uploadingPhotos => 'Hochladen…';

  @override
  String get useAnotherPriceListDate => 'Anderes Preislistendatum verwenden';

  @override
  String get validFrom => 'Gültig ab';

  @override
  String validFromDate(String date) {
    return 'Gültig ab $date';
  }

  @override
  String validUntil(String date) {
    return 'gültig bis $date';
  }

  @override
  String get value => 'Wert';

  @override
  String get vat => 'MwSt.';

  @override
  String get vatNumber => 'USt-IdNr.';

  @override
  String vatOn(String rate, String base) {
    return 'MwSt. $rate % auf $base';
  }

  @override
  String get vatPercent => 'MwSt. %';

  @override
  String get viaPortal => 'Über das Kundenportal';

  @override
  String get warranty => 'Garantie';

  @override
  String get warrantyIn => 'In Garantie';

  @override
  String get warrantyOut => 'Außerhalb der Garantie';

  @override
  String get warrantyUnknown => 'Unbekannt';

  @override
  String weighted(String amount) {
    return 'gewichtet $amount';
  }

  @override
  String get whatWasAsked => 'Was wurde gefragt?';

  @override
  String get whoIsCalling => 'Wer ruft an?';

  @override
  String get won => 'Gewonnen';

  @override
  String get workFrom => 'Von';

  @override
  String get workKindTravel => 'Fahrt';

  @override
  String get workKindWork => 'Arbeit';

  @override
  String get workLogs => 'Erfasste Zeit';

  @override
  String get workUntil => 'Bis';

  @override
  String writeIn(String language) {
    return 'Auf $language schreiben';
  }

  @override
  String get yourMessage => 'Ihre Nachricht';

  @override
  String get yourReference => 'Ihre Referenz (RMA oder Bestellung)';

  @override
  String get zone => 'Zone';

  @override
  String zoneAndRebate(String zone, String percent) {
    return 'Zone $zone · allgemeiner Rabatt $percent %';
  }

  @override
  String get zonesNoneAll => 'Zonen (keine Auswahl = alle)';

  @override
  String get kbTitle => 'Wissensdatenbank';

  @override
  String get kbNewArticle => 'Neuer Artikel';

  @override
  String get kbSearchHint => 'Artikel suchen';

  @override
  String get kbAllCategories => 'Alle Kategorien';

  @override
  String get kbAllStatuses => 'Alle Status';

  @override
  String get kbAllAudiences => 'Alle Zielgruppen';

  @override
  String get kbManageCategories => 'Kategorien';

  @override
  String get kbStatusPublished => 'Veröffentlicht';

  @override
  String get kbStatusArchived => 'Archiviert';

  @override
  String get kbAudience => 'Zielgruppe';

  @override
  String get kbAudienceInternal => 'Intern (nur Mitarbeiter)';

  @override
  String get kbAudiencePortal => 'Kundenportal';

  @override
  String get kbAudiencePublic => 'Öffentlich';

  @override
  String get kbArticleTitle => 'Titel';

  @override
  String get kbSummary => 'Zusammenfassung';

  @override
  String get kbBody => 'Text (Markdown)';

  @override
  String get kbPreview => 'Vorschau';

  @override
  String get kbWriteTab => 'Schreiben';

  @override
  String get kbMarkdownHelp =>
      'Verwenden Sie # für Überschriften, **fett**, *kursiv*, - für Listen, [Text](https://…) für Links und ![Beschreibung](image:ID) für Bilder.';

  @override
  String get kbTagsLabel => 'Tags (durch Komma getrennt)';

  @override
  String get kbRelated => 'Verwandte Artikel';

  @override
  String get kbAddRelated => 'Verwandten Artikel hinzufügen';

  @override
  String get kbImages => 'Bilder';

  @override
  String get kbUploadImage => 'Bild hochladen';

  @override
  String get kbInsertImage => 'In Text einfügen';

  @override
  String get kbPublish => 'Veröffentlichen';

  @override
  String get kbUnpublish => 'Zurückziehen';

  @override
  String get kbArchive => 'Archivieren';

  @override
  String get kbHistory => 'Versionsverlauf';

  @override
  String kbVersionLine(int version, String name, String date) {
    return 'Version $version · $name · $date';
  }

  @override
  String get kbRestore => 'Diese Version wiederherstellen';

  @override
  String kbRestoredFrom(int version) {
    return 'wiederhergestellt aus Version $version';
  }

  @override
  String kbFeedback(int yes, int no) {
    return '$yes fanden dies hilfreich, $no nicht';
  }

  @override
  String kbViews(int count) {
    return '$count Aufrufe';
  }

  @override
  String get kbNoArticles => 'Keine Artikel gefunden.';

  @override
  String get kbNoCategory => 'Keine Kategorie';

  @override
  String get kbMainCategory => 'Hauptkategorie';

  @override
  String get kbSortOrder => 'Reihenfolge';

  @override
  String get kbNewCategory => 'Neue Kategorie';

  @override
  String get kbCategoryNames => 'Name je Sprache';

  @override
  String get kbDelete => 'Löschen';

  @override
  String get kbSuggestedArticles => 'Vorgeschlagene Artikel';

  @override
  String get kbNoSuggestions => 'Keine passenden Artikel.';

  @override
  String get kbInsertText => 'Text einfügen';

  @override
  String get kbInsertLink => 'Link einfügen';

  @override
  String get kbInsertArticle => 'Artikel einfügen';

  @override
  String get kbNoPortalLink =>
      'Dieser Artikel ist intern: nur der Text kann eingefügt werden.';

  @override
  String get kbHelp => 'Hilfe';

  @override
  String get kbHelpHeading => 'Wie können wir helfen?';

  @override
  String get kbHelpSearch => 'Hilfeartikel durchsuchen';

  @override
  String get kbHelpEmpty =>
      'Keine Artikel gefunden. Sie können stattdessen ein Ticket eröffnen.';

  @override
  String get kbWasHelpful => 'War dieser Artikel hilfreich?';

  @override
  String get kbYes => 'Ja';

  @override
  String get kbNo => 'Nein';

  @override
  String get kbThanks => 'Vielen Dank für Ihr Feedback.';

  @override
  String get kbStillNeedHelp =>
      'Brauchen Sie noch Hilfe? Eröffnen Sie ein Ticket.';

  @override
  String get kbRelatedReading => 'Verwandte Artikel';

  @override
  String get kbDeflectionTitle =>
      'Diese Artikel beantworten Ihre Frage vielleicht schon';

  @override
  String kbShownIn(String language) {
    return 'In Ihrer Sprache nicht verfügbar; angezeigt auf $language.';
  }

  @override
  String kbUpdatedOn(String date) {
    return 'Aktualisiert am $date';
  }
}
