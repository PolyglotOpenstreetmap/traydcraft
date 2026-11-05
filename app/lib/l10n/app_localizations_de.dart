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
  String get addNote => 'Notiz hinzufügen';

  @override
  String get addProduct => 'Produkt hinzufügen';

  @override
  String get addRebate => 'Rabatt hinzufügen';

  @override
  String addedBy(String date, String name) {
    return 'hinzugefügt am $date von $name';
  }

  @override
  String get agreed => 'Vereinbart';

  @override
  String get all => 'Alle';

  @override
  String get allProducts => 'Alle Produkte';

  @override
  String get allStatuses => 'Alle Status';

  @override
  String get always => 'immer';

  @override
  String andMore(int count) {
    return '… und $count weitere';
  }

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
  String get automatic => 'Automatisch';

  @override
  String get billOfMaterials => 'Stückliste';

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
  String get canStillKeep =>
      'Die vereinbarten Preise können beibehalten werden.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get cancelled => 'storniert';

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
  String get chooseCustomerAndLine =>
      'Kunden wählen und mindestens eine gültige Position hinzufügen.';

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
  String get confirmed => 'bestätigt';

  @override
  String conflictsOnDate(int count) {
    return '$count haben an diesem Datum bereits einen Preis';
  }

  @override
  String get contactName => 'Name des Ansprechpartners';

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
  String get current => 'Aktuell';

  @override
  String get customer => 'Kunde';

  @override
  String get customerLanguage => 'Kundensprache';

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
  String get deliveryFailed => 'nicht gesendet';

  @override
  String get deliveryQueued => 'wartet auf Versand';

  @override
  String get deliverySent => 'gesendet';

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
  String get draftSaved => 'Entwurf gespeichert';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get email => 'E-Mail';

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
  String get from => 'Ab';

  @override
  String generalRebateInfo(String percent) {
    return 'Allgemeiner Rabatt auf alle Produkte: $percent % (Nettopreisprodukte werden nie rabattiert).';
  }

  @override
  String get generalRebatePercent => 'Allgemeiner Rabatt %';

  @override
  String get helpdesk => 'Kundendienst';

  @override
  String get inactive => 'inaktiv';

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
  String get keepAgreedPrices => 'Vereinbarte Preise beibehalten';

  @override
  String get language => 'Sprache';

  @override
  String get leadCreated => 'Lead angelegt';

  @override
  String get lineDiscount => 'Zeilenrabatt';

  @override
  String get listPrice => 'Listenpreis';

  @override
  String get loadMore => 'Mehr laden';

  @override
  String get lost => 'Verloren';

  @override
  String get lostReason => 'Verlustgrund';

  @override
  String get markAsLost => 'Als verloren markieren';

  @override
  String get markAsSent => 'Als versendet markieren';

  @override
  String get materialRequirements => 'Materialbedarf (aktive Revision)';

  @override
  String get message => 'Nachricht';

  @override
  String get myTickets => 'Meine Tickets';

  @override
  String get name => 'Name';

  @override
  String get netPrice => 'Nettopreis';

  @override
  String get newAnswer => 'Neuer Textbaustein';

  @override
  String get newCustomer => 'Neuer Kunde';

  @override
  String get newFamily => 'Neue Familie';

  @override
  String get newItem => 'Neu';

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
  String get newProduct => 'Neues Produkt';

  @override
  String get newQuotation => 'Neues Angebot';

  @override
  String get newRevision => 'Neue Revision';

  @override
  String newRevisionOf(String number) {
    return 'Neue Revision von $number';
  }

  @override
  String get newTicket => 'Neues Ticket';

  @override
  String get noActiveBom => 'Keine aktive Stückliste.';

  @override
  String get noBom => 'Noch keine Stückliste.';

  @override
  String get noCustomerLinked => 'Kein Kunde verknüpft';

  @override
  String get noExpectedClose => 'Kein voraussichtliches Abschlussdatum';

  @override
  String get noLines => 'Noch keine Positionen.';

  @override
  String get noPrices => 'Noch keine Preise.';

  @override
  String get noQuotations => 'Noch keine Angebote.';

  @override
  String get noRebates => 'Keine Produkt- oder Familienrabatte.';

  @override
  String get noSerialComponents => 'Keine Komponenten mit Seriennummer.';

  @override
  String get none => 'Keine';

  @override
  String get notClosed => 'Nicht geschlossen';

  @override
  String get noteAdded => 'Notiz hinzugefügt';

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
  String get openEnded => 'offen';

  @override
  String get openOnly => 'Nur offene';

  @override
  String get openOpportunity => 'Verkaufschance öffnen';

  @override
  String get opportunities => 'Verkaufschancen';

  @override
  String get opportunity => 'Verkaufschance';

  @override
  String get opportunityOptional => 'Verkaufschance (optional)';

  @override
  String get order => 'Auftrag';

  @override
  String get orderCreated => 'Auftrag angelegt';

  @override
  String get orders => 'Aufträge';

  @override
  String get owner => 'Verantwortlich';

  @override
  String get paymentDays => 'Zahlungsziel (Tage)';

  @override
  String get pdf => 'PDF';

  @override
  String get phone => 'Telefon';

  @override
  String get placeholdersHelp =>
      'Platzhalter (klicken zum Einfügen in der aktuellen Sprache):';

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
  String get priorityHigh => 'hoch';

  @override
  String get priorityLow => 'niedrig';

  @override
  String get priorityNormal => 'normal';

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
  String get reason => 'Grund';

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
  String removedBy(String date, String name) {
    return 'entfernt am $date von $name';
  }

  @override
  String get replyQueued => 'Antwort zum Versand bereit';

  @override
  String get replyToCustomer => 'Antwort an Kunden';

  @override
  String repricingFailed(String error) {
    return 'Die heutigen Preise konnten nicht berechnet werden: $error';
  }

  @override
  String get required => 'Pflichtfeld';

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
  String revisionPriceLists(String agreed, String current) {
    return 'Vereinbarte Preise: Preisliste vom $agreed. Aktuelle Preise: Preisliste vom $current.';
  }

  @override
  String get roundTo => 'Runden auf';

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
  String get scrapPercent => 'Ausschuss %';

  @override
  String get search => 'Suchen';

  @override
  String get send => 'Senden';

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
  String get signIn => 'Anmelden';

  @override
  String get signOut => 'Abmelden';

  @override
  String get singleProduct => 'Einzelnes Produkt';

  @override
  String skippedWithoutPrice(int count) {
    return '$count Produkt/Zonen-Kombinationen haben keinen Preis und werden übersprungen';
  }

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
  String get text => 'Text';

  @override
  String get ticketDetails => 'Ticketdetails';

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
  String get title => 'Titel';

  @override
  String get titleCustomerValueRequired =>
      'Titel, Kunde und ein gültiger Wert sind erforderlich.';

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
  String get until => 'Bis';

  @override
  String get updateToCurrentPrices => 'Auf aktuelle Preise aktualisieren';

  @override
  String get updated => 'Aktualisiert';

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
  String weighted(String amount) {
    return 'gewichtet $amount';
  }

  @override
  String get whatWasAsked => 'Was wurde gefragt?';

  @override
  String get won => 'Gewonnen';

  @override
  String writeIn(String language) {
    return 'Auf $language schreiben';
  }

  @override
  String get zone => 'Zone';

  @override
  String zoneAndRebate(String zone, String percent) {
    return 'Zone $zone · allgemeiner Rabatt $percent %';
  }

  @override
  String get zonesNoneAll => 'Zonen (keine Auswahl = alle)';
}
