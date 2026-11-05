// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get accepted => 'Acceptée';

  @override
  String get accessToken => 'Jeton d\'accès';

  @override
  String get account => 'Compte';

  @override
  String get actions => 'Actions';

  @override
  String get activate => 'Activer';

  @override
  String get active => 'Actif';

  @override
  String activeSince(String date) {
    return 'Active depuis le $date. Les modifications passent par une nouvelle révision.';
  }

  @override
  String get addComponent => 'Ajouter un composant';

  @override
  String get addComponentBySerial =>
      'Ajouter un composant par numéro de série (en stock)';

  @override
  String get addNote => 'Ajouter la note';

  @override
  String get addProduct => 'Ajouter un produit';

  @override
  String get addRebate => 'Ajouter une remise';

  @override
  String addedBy(String date, String name) {
    return 'ajouté le $date par $name';
  }

  @override
  String get agreed => 'Convenu';

  @override
  String get all => 'Tous';

  @override
  String get allProducts => 'Tous les produits';

  @override
  String get allStatuses => 'Tous les statuts';

  @override
  String get always => 'toujours';

  @override
  String andMore(int count) {
    return '… et $count de plus';
  }

  @override
  String answerFallback(String ticketLanguage, String usedLanguage) {
    return 'Pas encore de texte en $ticketLanguage : le texte en $usedLanguage a été utilisé. Traduisez-le avant l\'envoi.';
  }

  @override
  String get appLanguage => 'Langue';

  @override
  String get appTitle => 'traydcraft';

  @override
  String get apply => 'Appliquer';

  @override
  String get automatic => 'Automatique';

  @override
  String get billOfMaterials => 'Nomenclature';

  @override
  String get bomActive => 'active';

  @override
  String get bomObsolete => 'obsolète';

  @override
  String get bomRev => 'Rév. nomencl.';

  @override
  String get bomRevision => 'Révision de nomenclature';

  @override
  String get builtInto => 'Intégré dans';

  @override
  String get bulkKeepsQuotes =>
      'Les offres antérieures à cette date gardent les prix actuels';

  @override
  String get bulkPriceChange => 'Modification de prix groupée';

  @override
  String get byStage => 'selon l\'étape';

  @override
  String get canStillKeep => 'Vous pouvez toujours garder les prix convenus.';

  @override
  String get cancel => 'Annuler';

  @override
  String get cancelled => 'annulée';

  @override
  String get category => 'Catégorie';

  @override
  String get categoryComplaint => 'réclamation';

  @override
  String get categoryLead => 'prospect (nouvelle demande)';

  @override
  String get categoryOrderConfirmation => 'confirmation de commande';

  @override
  String get categoryOther => 'autre';

  @override
  String get categoryProductionQuestion => 'question de la production';

  @override
  String get categoryQuestion => 'question';

  @override
  String get categoryQuoteChange => 'modification d\'offre';

  @override
  String get categoryService => 'service / réparation';

  @override
  String get cc => 'Cc';

  @override
  String get change => 'Modification';

  @override
  String get chooseCustomerAndLine =>
      'Choisissez un client et ajoutez au moins une ligne valide.';

  @override
  String get chooseRebateTarget =>
      'Choisissez un produit ou une famille et saisissez un pourcentage.';

  @override
  String get chooseZonePrice => 'Choisissez une zone et saisissez un prix.';

  @override
  String get city => 'Localité';

  @override
  String get close => 'Fermer';

  @override
  String get code => 'Code';

  @override
  String get codeNameVatRequired =>
      'Le code, le nom et le taux de TVA sont obligatoires.';

  @override
  String get component => 'Composant';

  @override
  String get componentHistory => 'Historique des composants';

  @override
  String componentSince(String product, String date) {
    return '$product · depuis le $date';
  }

  @override
  String get componentsAsBuilt => 'Composants (tels que construits)';

  @override
  String get confirm => 'confirmer';

  @override
  String get confirmed => 'confirmée';

  @override
  String conflictsOnDate(int count) {
    return '$count ont déjà un prix à cette date';
  }

  @override
  String get contactName => 'Nom du contact';

  @override
  String get convertHelp =>
      'Le client souhaite des modifications ? Créez d\'abord une nouvelle révision de l\'offre, liez-la ici, puis convertissez.';

  @override
  String get convertToOrder => 'Convertir en commande';

  @override
  String countOf(int count, int total) {
    return '$count sur $total';
  }

  @override
  String get country => 'Pays';

  @override
  String get create => 'Créer';

  @override
  String get createLead => 'Créer une opportunité';

  @override
  String get current => 'Actuel';

  @override
  String get customer => 'Client';

  @override
  String get customerLanguage => 'Langue du client';

  @override
  String customerNamed(String name) {
    return 'Client : $name';
  }

  @override
  String get customerOptional => 'Client (facultatif)';

  @override
  String get customerReference => 'Référence client';

  @override
  String get customers => 'Clients';

  @override
  String get date => 'Date';

  @override
  String get deliveryFailed => 'non envoyé';

  @override
  String get deliveryQueued => 'en attente d\'envoi';

  @override
  String get deliverySent => 'envoyé';

  @override
  String get description => 'Description';

  @override
  String get devModeHelp => 'Le serveur doit tourner avec AUTH_MODE=dev';

  @override
  String get developmentUser => 'Utilisateur de développement';

  @override
  String get deviceLanguage => 'Langue de l\'appareil';

  @override
  String get difference => 'Différence';

  @override
  String get draftSaved => 'Brouillon enregistré';

  @override
  String get edit => 'Modifier';

  @override
  String get email => 'E-mail';

  @override
  String get enterChange =>
      'Saisissez la modification, p. ex. 4,5 pour +4,5 %.';

  @override
  String enterValidNumbersLine(int line) {
    return 'Ligne $line : saisissez des nombres valides.';
  }

  @override
  String get expectedClose => 'Clôture prévue';

  @override
  String expectedCloseDate(String date) {
    return 'Clôture prévue le $date';
  }

  @override
  String get expectedValue => 'Valeur attendue';

  @override
  String get expectedValueEur => 'Valeur attendue (€)';

  @override
  String get expectedValueOptional => 'Valeur attendue (facultatif)';

  @override
  String get explode => 'Éclater';

  @override
  String get families => 'Familles';

  @override
  String get family => 'Famille';

  @override
  String familyNamed(String code) {
    return 'Famille $code';
  }

  @override
  String get from => 'À partir du';

  @override
  String generalRebateInfo(String percent) {
    return 'Remise générale sur tous les produits : $percent % (les produits à prix net ne sont jamais remisés).';
  }

  @override
  String get generalRebatePercent => 'Remise générale %';

  @override
  String get helpdesk => 'Service client';

  @override
  String get inactive => 'inactif';

  @override
  String indicativeLine(String description) {
    return '$description (indicatif, à confirmer)';
  }

  @override
  String indicativeToConfirm(int count) {
    return '$count prix indicatif(s) à confirmer avant l\'envoi de l\'offre : saisissez le prix convenu dans le champ prix catalogue.';
  }

  @override
  String get insertPreparedAnswer => 'Insérer une réponse type';

  @override
  String get internalNote => 'Note interne';

  @override
  String internalQuestionHelp(String language) {
    return 'Question interne. Posez la question au client en $language par une réponse, puis notez la réponse pour votre collègue en note interne.';
  }

  @override
  String get internalTicket => 'Ticket interne';

  @override
  String get internalTicketHelp =>
      'Une question entre collègues ; rien n\'est envoyé au client.';

  @override
  String get keepAgreedPrices => 'Garder les prix convenus';

  @override
  String get language => 'Langue';

  @override
  String get leadCreated => 'Opportunité créée';

  @override
  String get lineDiscount => 'Remise ligne';

  @override
  String get listPrice => 'Prix catalogue';

  @override
  String get loadMore => 'Charger plus';

  @override
  String get lost => 'Perdue';

  @override
  String get lostReason => 'Motif de perte';

  @override
  String get markAsLost => 'Marquer comme perdue';

  @override
  String get markAsSent => 'Marquer comme envoyée';

  @override
  String get materialRequirements => 'Besoins en matières (révision active)';

  @override
  String get message => 'Message';

  @override
  String get myTickets => 'Mes tickets';

  @override
  String get name => 'Nom';

  @override
  String get netPrice => 'Prix net';

  @override
  String get newAnswer => 'Nouvelle réponse';

  @override
  String get newCustomer => 'Nouveau client';

  @override
  String get newFamily => 'Nouvelle famille';

  @override
  String get newItem => 'Nouveau';

  @override
  String get newLabel => 'Nouveau';

  @override
  String get newOpportunity => 'Nouvelle opportunité';

  @override
  String get newPrice => 'Nouveau prix';

  @override
  String newPricesValidFrom(String date) {
    return 'Nouveaux prix valables à partir du $date';
  }

  @override
  String get newProduct => 'Nouveau produit';

  @override
  String get newQuotation => 'Nouvelle offre';

  @override
  String get newRevision => 'Nouvelle révision';

  @override
  String newRevisionOf(String number) {
    return 'Nouvelle révision de $number';
  }

  @override
  String get newTicket => 'Nouveau ticket';

  @override
  String get noActiveBom => 'Aucune nomenclature active.';

  @override
  String get noBom => 'Pas encore de nomenclature.';

  @override
  String get noCustomerLinked => 'Aucun client lié';

  @override
  String get noExpectedClose => 'Pas de date de clôture prévue';

  @override
  String get noLines => 'Pas encore de lignes.';

  @override
  String get noPrices => 'Pas encore de prix.';

  @override
  String get noQuotations => 'Pas encore d\'offres.';

  @override
  String get noRebates => 'Aucune remise produit ou famille.';

  @override
  String get noSerialComponents => 'Aucun composant sérialisé.';

  @override
  String get none => 'Aucun';

  @override
  String get notClosed => 'Non clôturés';

  @override
  String get noteAdded => 'Note ajoutée';

  @override
  String get notes => 'Remarques';

  @override
  String get number => 'Numéro';

  @override
  String get numberRequired => 'Nombre';

  @override
  String get obsoleteRevision => 'Révision obsolète (lecture seule).';

  @override
  String get oidcAccessToken => 'Jeton d\'accès OIDC';

  @override
  String get ok => 'OK';

  @override
  String get openEnded => 'ouvert';

  @override
  String get openOnly => 'Ouvertes uniquement';

  @override
  String get openOpportunity => 'Ouvrir l\'opportunité';

  @override
  String get opportunities => 'Opportunités';

  @override
  String get opportunity => 'Opportunité';

  @override
  String get opportunityOptional => 'Opportunité (facultatif)';

  @override
  String get order => 'Commande';

  @override
  String get orderCreated => 'Commande créée';

  @override
  String get orders => 'Commandes';

  @override
  String get owner => 'Responsable';

  @override
  String get paymentDays => 'Délai de paiement (jours)';

  @override
  String get pdf => 'PDF';

  @override
  String get phone => 'Téléphone';

  @override
  String get placeholdersHelp =>
      'Variables (cliquer pour insérer dans la langue affichée) :';

  @override
  String get postalCode => 'Code postal';

  @override
  String get preparedAnswers => 'Réponses types';

  @override
  String get preparedAnswersHelp =>
      'Réponses réutilisables aux questions récurrentes, un texte par langue. Les variables comme «quotation.number» sont complétées pour le ticket ; le texte reste modifiable avant l\'envoi.';

  @override
  String get preview => 'Aperçu';

  @override
  String priceListOf(String date) {
    return 'Tarif du $date';
  }

  @override
  String get priceListValidOn => 'Tarif valable le';

  @override
  String get priceZone => 'Zone de prix';

  @override
  String pricedOnPriceListOf(String date) {
    return 'Chiffrée selon le tarif du $date';
  }

  @override
  String get prices => 'Prix';

  @override
  String pricesCreated(int count, String date) {
    return '$count prix créés, valables à partir du $date';
  }

  @override
  String pricesWillChange(int count) {
    return '$count prix vont changer';
  }

  @override
  String get pricing => 'Tarification';

  @override
  String get pricingIndicative => 'indicatif';

  @override
  String get pricingIndicativeHelp => 'Indicatif (à confirmer par offre)';

  @override
  String get pricingList => 'prix catalogue';

  @override
  String get pricingListHelp => 'Prix catalogue (remises applicables)';

  @override
  String get pricingNet => 'net';

  @override
  String get pricingNetHelp => 'Prix net (jamais de remise)';

  @override
  String get priority => 'Priorité';

  @override
  String get priorityHigh => 'haute';

  @override
  String get priorityLow => 'basse';

  @override
  String get priorityNormal => 'normale';

  @override
  String get priorityUrgent => 'urgente';

  @override
  String get probability => 'Probabilité';

  @override
  String get probabilityPercent => 'Probabilité %';

  @override
  String get probabilityShort => 'Prob.';

  @override
  String get product => 'Produit';

  @override
  String productCount(int count) {
    return '$count produits';
  }

  @override
  String get productFamilies => 'Familles de produits';

  @override
  String get productFamily => 'Famille de produits';

  @override
  String get productRebates => 'Remises produits';

  @override
  String get productTypeConfigurable => 'configurable';

  @override
  String get productTypeManufactured => 'fabriqué';

  @override
  String get productTypePurchased => 'acheté';

  @override
  String get productTypeService => 'service';

  @override
  String get products => 'Produits';

  @override
  String get quantity => 'Quantité';

  @override
  String get question => 'Question';

  @override
  String get questionToSales => 'Question au commercial';

  @override
  String questionToSalesHelp(String salesperson) {
    return '$salesperson reçoit cette question et la pose au client dans sa langue.';
  }

  @override
  String get quotation => 'Offre';

  @override
  String get quotations => 'Offres';

  @override
  String get reason => 'Motif';

  @override
  String get rebate => 'Remise';

  @override
  String rebateFor(String target, String percent) {
    return '$target : $percent %';
  }

  @override
  String get rebatePercent => 'Remise %';

  @override
  String get rebateSourceFamily => 'famille';

  @override
  String get rebateSourceGeneral => 'générale';

  @override
  String get rebateSourceProduct => 'produit';

  @override
  String rebatesOf(String customer) {
    return 'Remises · $customer';
  }

  @override
  String registerProduct(String product) {
    return 'Enregistrer $product';
  }

  @override
  String get registerUnit => 'Enregistrer une unité';

  @override
  String get registered => 'Enregistré';

  @override
  String get rejected => 'Refusée';

  @override
  String get remove => 'Supprimer';

  @override
  String get removeAndScrap => 'Retirer et mettre au rebut';

  @override
  String get removeBackToStock => 'Retirer, retour en stock';

  @override
  String removedBy(String date, String name) {
    return 'retiré le $date par $name';
  }

  @override
  String get replyQueued => 'Réponse en file d\'envoi';

  @override
  String get replyToCustomer => 'Répondre au client';

  @override
  String repricingFailed(String error) {
    return 'Les prix du jour n\'ont pas pu être calculés : $error';
  }

  @override
  String get required => 'Obligatoire';

  @override
  String get retry => 'Réessayer';

  @override
  String get revisionActivated => 'Révision activée';

  @override
  String revisionItem(int revision, String status, int lines) {
    return 'Révision $revision · $status · $lines lignes';
  }

  @override
  String get revisionNotes => 'Notes de révision';

  @override
  String revisionPriceLists(String agreed, String current) {
    return 'Prix convenus : tarif du $agreed. Prix actuels : tarif du $current.';
  }

  @override
  String get roundTo => 'Arrondir à';

  @override
  String get salesperson => 'Commercial';

  @override
  String get save => 'Enregistrer';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get saveDraft => 'Enregistrer le brouillon';

  @override
  String get saved => 'Enregistré';

  @override
  String savedNumber(String number) {
    return '$number enregistré';
  }

  @override
  String get scrapPercent => 'Rebut %';

  @override
  String get search => 'Rechercher';

  @override
  String get send => 'Envoyer';

  @override
  String get serial => 'n° de série';

  @override
  String get serialBuiltIn => 'intégré';

  @override
  String get serialDelivered => 'livré';

  @override
  String get serialInStock => 'en stock';

  @override
  String get serialInstalled => 'installé';

  @override
  String get serialNumber => 'Numéro de série';

  @override
  String get serialNumbers => 'Numéros de série';

  @override
  String get serialNumbersHelp =>
      'Chaque unité reçoit son propre numéro de série et historique';

  @override
  String get serialScrapped => 'mis au rebut';

  @override
  String get server => 'Serveur';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get singleProduct => 'Produit unique';

  @override
  String skippedWithoutPrice(int count) {
    return '$count combinaisons produit/zone n\'ont pas de prix et sont ignorées';
  }

  @override
  String get stage => 'Étape';

  @override
  String get stageLead => 'prospect';

  @override
  String get stageLost => 'perdue';

  @override
  String get stageNegotiation => 'négociation';

  @override
  String get stageProposal => 'proposition';

  @override
  String get stageQualified => 'qualifiée';

  @override
  String get stageWon => 'gagnée';

  @override
  String get status => 'Statut';

  @override
  String get statusAccepted => 'acceptée';

  @override
  String get statusAfterwards => 'Statut ensuite';

  @override
  String get statusDraft => 'brouillon';

  @override
  String get statusRejected => 'refusée';

  @override
  String get statusSent => 'envoyée';

  @override
  String get statusSuperseded => 'remplacée';

  @override
  String get street => 'Rue';

  @override
  String structureRevision(int revision) {
    return 'Structure (révision $revision)';
  }

  @override
  String get subassembly => 'sous-ensemble';

  @override
  String get subject => 'Objet';

  @override
  String get subjectOptional => 'Objet (facultatif)';

  @override
  String suggested(String value) {
    return 'Suggestion : $value';
  }

  @override
  String get text => 'Texte';

  @override
  String get ticketDetails => 'Détails du ticket';

  @override
  String get ticketStatusClosed => 'clôturé';

  @override
  String get ticketStatusNew => 'nouveau';

  @override
  String get ticketStatusOpen => 'ouvert';

  @override
  String get ticketStatusPendingCustomer => 'en attente du client';

  @override
  String get ticketStatusPendingInternal => 'en attente d\'un collègue';

  @override
  String get title => 'Titre';

  @override
  String get titleCustomerValueRequired =>
      'Le titre, le client et une valeur valide sont obligatoires.';

  @override
  String get to => 'À';

  @override
  String get total => 'Total';

  @override
  String totalChange(String from, String to, String difference) {
    return 'Total HTVA : $from → $to ($difference)';
  }

  @override
  String get totalExclVat => 'Total HTVA';

  @override
  String get totalInclVat => 'Total TVAC';

  @override
  String get totalsToBuyOrMake => 'Totaux à acheter ou fabriquer';

  @override
  String get tracking => 'Traçabilité';

  @override
  String get twoLetters => '2 lettres';

  @override
  String get type => 'Type';

  @override
  String get unassigned => 'Non attribués';

  @override
  String get unchanged => 'Inchangé';

  @override
  String get unit => 'Unité';

  @override
  String get unitPrice => 'Prix unitaire';

  @override
  String get unitPriceExclVat => 'Prix unitaire (HTVA)';

  @override
  String get until => 'Jusqu\'au';

  @override
  String get updateToCurrentPrices => 'Mettre à jour aux prix actuels';

  @override
  String get updated => 'Mis à jour';

  @override
  String get useAnotherPriceListDate => 'Utiliser une autre date de tarif';

  @override
  String get validFrom => 'Valable à partir du';

  @override
  String validFromDate(String date) {
    return 'Valable à partir du $date';
  }

  @override
  String validUntil(String date) {
    return 'valable jusqu\'au $date';
  }

  @override
  String get value => 'Valeur';

  @override
  String get vat => 'TVA';

  @override
  String get vatNumber => 'Numéro de TVA';

  @override
  String vatOn(String rate, String base) {
    return 'TVA $rate % sur $base';
  }

  @override
  String get vatPercent => 'TVA %';

  @override
  String weighted(String amount) {
    return 'pondéré $amount';
  }

  @override
  String get whatWasAsked => 'Quelle est la demande ?';

  @override
  String get won => 'Gagnée';

  @override
  String writeIn(String language) {
    return 'Rédiger en $language';
  }

  @override
  String get zone => 'Zone';

  @override
  String zoneAndRebate(String zone, String percent) {
    return 'Zone $zone · remise générale $percent %';
  }

  @override
  String get zonesNoneAll => 'Zones (aucune sélection = toutes)';
}
