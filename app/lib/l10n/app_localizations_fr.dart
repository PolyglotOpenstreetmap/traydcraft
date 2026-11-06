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
  String get addMember => 'Ajouter un membre';

  @override
  String get addNote => 'Ajouter la note';

  @override
  String get addNoteHint => 'Ajouter une note interne';

  @override
  String get addPhone => 'Ajouter un numéro';

  @override
  String get addPhoto => 'Ajouter une photo';

  @override
  String get addProduct => 'Ajouter un produit';

  @override
  String get addRebate => 'Ajouter une remise';

  @override
  String get addTag => 'Ajouter une étiquette';

  @override
  String get addTask => 'Ajouter une tâche';

  @override
  String addedBy(String date, String name) {
    return 'ajouté le $date par $name';
  }

  @override
  String get addressForm => 'Forme d\'adresse';

  @override
  String get addressFormal => 'Formel (vous)';

  @override
  String get addressInformal => 'Informel (tu)';

  @override
  String get agreed => 'Convenu';

  @override
  String get all => 'Tous';

  @override
  String get allProducts => 'Tous les produits';

  @override
  String get allStatuses => 'Tous les statuts';

  @override
  String get allTags => 'Toutes les étiquettes';

  @override
  String get allTeams => 'Toutes les équipes';

  @override
  String get always => 'toujours';

  @override
  String andMore(int count) {
    return '… et $count de plus';
  }

  @override
  String get announceRepair => 'Annoncer une réparation';

  @override
  String get announcedNotReceived => 'Annoncée, pas encore reçue';

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
  String get assignTo => 'Assigner à';

  @override
  String get attachFile => 'Joindre un fichier';

  @override
  String get attachments => 'Pièces jointes';

  @override
  String get attachmentsHelp =>
      'Images (JPEG, PNG, WebP) et PDF, jusqu\'à 12 Mo';

  @override
  String get automatic => 'Automatique';

  @override
  String get backIntoWork => 'Remettre en cours';

  @override
  String get backToCurrentRevision => 'Retour à la révision actuelle';

  @override
  String get billOfMaterials => 'Nomenclature';

  @override
  String get billable => 'Facturable';

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
  String get callIncoming => 'Appel entrant';

  @override
  String get callLogged => 'Appel enregistré';

  @override
  String get callMinutes => 'Durée (minutes)';

  @override
  String get callOutgoing => 'Appel sortant';

  @override
  String get callSummary => 'Sujet de l\'appel';

  @override
  String callWith(String name) {
    return 'Appel avec $name';
  }

  @override
  String get canStillKeep => 'Vous pouvez toujours garder les prix convenus.';

  @override
  String get cancel => 'Annuler';

  @override
  String get cancelJob => 'Annuler';

  @override
  String get cancelOrder => 'Annuler la commande';

  @override
  String get cancelReasonLabel => 'Motif de l\'annulation';

  @override
  String get cancelRepair => 'Annuler la réparation';

  @override
  String get cancelled => 'annulée';

  @override
  String cancelledReason(String reason) {
    return 'Annulée : $reason';
  }

  @override
  String get cannotConfirmNewer =>
      'Une révision plus récente de cette commande est en préparation. Vous pourrez la confirmer dès qu\'elle vous aura été envoyée.';

  @override
  String get cannotConfirmOther => 'Cette commande ne peut pas être confirmée.';

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
  String get changePriority => 'Modifier la priorité';

  @override
  String get chooseCustomerAndLine =>
      'Choisissez un client et ajoutez au moins une ligne valide.';

  @override
  String get choosePhoto => 'Choisir dans la galerie';

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
  String get codeNameRequired => 'Le code et le nom sont obligatoires.';

  @override
  String get codeNameVatRequired =>
      'Le code, le nom et le taux de TVA sont obligatoires.';

  @override
  String get completeJob => 'Terminer';

  @override
  String get completionNotes => 'Ce qui a été fait (et ce qui reste ouvert)';

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
  String get confirmOnBehalf => 'Confirmer au nom du client';

  @override
  String get confirmOnBehalfHelp =>
      'Enregistrez que le client a confirmé cette révision, par exemple par téléphone ou par e-mail.';

  @override
  String get confirmOrder => 'Confirmer la commande';

  @override
  String get confirmOrderHelp =>
      'En confirmant, vous acceptez cette commande telle qu\'affichée.';

  @override
  String get confirmation => 'Confirmation';

  @override
  String get confirmationDate => 'Confirmée le';

  @override
  String get confirmed => 'confirmée';

  @override
  String get confirmedRevision => 'Révision confirmée';

  @override
  String get confirmedVia => 'Confirmée via';

  @override
  String get confirmedViaPortal => 'portail client';

  @override
  String get confirmedViaStaff => 'collaborateur, au nom du client';

  @override
  String conflictsOnDate(int count) {
    return '$count ont déjà un prix à cette date';
  }

  @override
  String get contactName => 'Nom du contact';

  @override
  String get contactPerson => 'Personne de contact';

  @override
  String get contacts => 'Contacts';

  @override
  String get convertHelp =>
      'Le client souhaite des modifications ? Créez d\'abord une nouvelle révision de l\'offre, liez-la ici, puis convertissez.';

  @override
  String get convertToOrder => 'Convertir en commande';

  @override
  String get countAddLine => 'Ajouter du stock non listé';

  @override
  String get countCancel => 'Annuler l\'inventaire';

  @override
  String get countCounted => 'Compté';

  @override
  String get countDifference => 'Écart';

  @override
  String get countExpected => 'Attendu';

  @override
  String get countInvalidQuantity =>
      'Une quantité comptée n\'est pas un nombre.';

  @override
  String get countNew => 'Nouvel inventaire';

  @override
  String countOf(int count, int total) {
    return '$count sur $total';
  }

  @override
  String get countOneProduct => 'Un seul produit (facultatif)';

  @override
  String get countPost => 'Comptabiliser l\'inventaire';

  @override
  String get countPostConfirm =>
      'Les écarts sont comptabilisés comme corrections de stock. Les lignes sans quantité comptée restent inchangées.';

  @override
  String get countProgress => 'Compté';

  @override
  String get countStart => 'Démarrer l\'inventaire';

  @override
  String get countStatusCounting => 'En cours';

  @override
  String get countStatusPosted => 'Comptabilisé';

  @override
  String get countWarehouseRequired => 'Choisissez un entrepôt.';

  @override
  String get countWholeWarehouse => 'Tout l\'entrepôt';

  @override
  String get countedBy => 'Démarré par';

  @override
  String get country => 'Pays';

  @override
  String get create => 'Créer';

  @override
  String get createLead => 'Créer une opportunité';

  @override
  String get createRepair => 'Créer une réparation';

  @override
  String get csatAlready => 'Cette enquête a déjà reçu une réponse.';

  @override
  String get csatBad => 'Pas satisfait';

  @override
  String get csatComment => 'Commentaire (facultatif)';

  @override
  String get csatEnabled =>
      'Envoyer une enquête de satisfaction à la clôture d\'un ticket';

  @override
  String get csatExpired => 'Ce lien a expiré.';

  @override
  String get csatGood => 'Satisfait';

  @override
  String get csatNone => 'Pas encore d\'évaluation';

  @override
  String csatQuestion(String number) {
    return 'Êtes-vous satisfait du traitement du ticket $number ?';
  }

  @override
  String get csatThanks => 'Merci pour votre avis !';

  @override
  String get csatTitle => 'Satisfaction client';

  @override
  String get current => 'Actuel';

  @override
  String get customer => 'Client';

  @override
  String get customerLanguage => 'Langue du client';

  @override
  String customerMainNumber(String name) {
    return 'Numéro principal de $name';
  }

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
  String get defaultTeam => 'Équipe par défaut pour les nouveaux tickets';

  @override
  String get deliveryFailed => 'non envoyé';

  @override
  String get deliveryQueued => 'en attente d\'envoi';

  @override
  String get deliverySent => 'envoyé';

  @override
  String get department => 'Département';

  @override
  String get departmentCode => 'Code';

  @override
  String get departmentMembers => 'Collègues de ce département';

  @override
  String get departments => 'Départements';

  @override
  String get departmentsHelp =>
      'Les réparations sont transmises à ces départements. Seuls les collègues d\'un département peuvent traiter ses réparations.';

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
  String get dismiss => 'Rejeter';

  @override
  String get dismissRequest => 'Rejeter la demande';

  @override
  String get draftSaved => 'Brouillon enregistré';

  @override
  String get edit => 'Modifier';

  @override
  String get editContact => 'Modifier le contact';

  @override
  String get editDepartment => 'Modifier le département';

  @override
  String get editJob => 'Modifier l\'intervention';

  @override
  String get email => 'E-mail';

  @override
  String get emailAddresses => 'Adresses e-mail (la première est principale)';

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
  String get faultDescription => 'Quel est le problème';

  @override
  String get firstName => 'Prénom';

  @override
  String get firstResponseMinutes => 'Première réponse (min)';

  @override
  String get from => 'À partir du';

  @override
  String get fromYou => 'Vous';

  @override
  String generalRebateInfo(String percent) {
    return 'Remise générale sur tous les produits : $percent % (les produits à prix net ne sont jamais remisés).';
  }

  @override
  String get generalRebatePercent => 'Remise générale %';

  @override
  String greetingPreview(String greeting) {
    return 'Salutation : $greeting';
  }

  @override
  String get helpdesk => 'Service client';

  @override
  String get helpdeskSettings => 'Paramètres du helpdesk';

  @override
  String get history => 'Historique';

  @override
  String get inactive => 'inactif';

  @override
  String get inactiveContact => 'N\'est plus actif (parti)';

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
  String get instructions => 'Instructions';

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
  String get jobCancelled => 'Annulée';

  @override
  String get jobCompleted => 'Terminée';

  @override
  String get jobInProgress => 'En cours';

  @override
  String get jobKindInspection => 'Inspection';

  @override
  String get jobKindInstallation => 'Installation';

  @override
  String get jobKindMaintenance => 'Maintenance';

  @override
  String get jobKindOther => 'Autre';

  @override
  String get jobKindRepair => 'Réparation';

  @override
  String get jobName => 'Titre';

  @override
  String get jobPlanned => 'Planifiée';

  @override
  String get jobTitle => 'Fonction';

  @override
  String get jobs => 'Interventions';

  @override
  String get keepAgreedPrices => 'Garder les prix convenus';

  @override
  String get language => 'Langue';

  @override
  String languageSameAsCustomer(String language) {
    return 'Comme l\'entreprise ($language)';
  }

  @override
  String get lastName => 'Nom';

  @override
  String get leadCreated => 'Opportunité créée';

  @override
  String get lineDiscount => 'Remise ligne';

  @override
  String get listPrice => 'Prix catalogue';

  @override
  String get loadMore => 'Charger plus';

  @override
  String get logCall => 'Enregistrer un appel';

  @override
  String get logTime => 'Enregistrer du temps';

  @override
  String get logWork => 'Enregistrer le travail';

  @override
  String get loginLinkInvalid =>
      'Ce lien a expiré ou a déjà été utilisé. Demandez-en un nouveau.';

  @override
  String get loginLinkSent =>
      'Si cette adresse peut utiliser le portail, un lien de connexion vous a été envoyé. Vérifiez votre boîte de réception.';

  @override
  String get lookUp => 'Rechercher';

  @override
  String get lost => 'Perdue';

  @override
  String get lostReason => 'Motif de perte';

  @override
  String get markAsLost => 'Marquer comme perdue';

  @override
  String get markAsSent => 'Marquer comme envoyée';

  @override
  String get markCompleted => 'Marquer comme terminée';

  @override
  String get markReceived => 'Marquer comme reçue';

  @override
  String get markShipped => 'Marquer comme renvoyée';

  @override
  String get markWaitingCustomer => 'En attente du client';

  @override
  String get markWaitingParts => 'En attente de pièces';

  @override
  String get materialRequirements => 'Besoins en matières (révision active)';

  @override
  String get mergeAction => 'Fusionner';

  @override
  String get mergeHelp =>
      'Tous les messages, fichiers, étiquettes et temps enregistrés passent au ticket choisi du même client. Ce ticket est fermé. Cette action est irréversible.';

  @override
  String get mergeNoCandidates => 'Aucun autre ticket ouvert de ce client.';

  @override
  String get mergeTicket => 'Fusionner avec un autre ticket…';

  @override
  String mergedInto(String number) {
    return 'Fusionné avec $number';
  }

  @override
  String get message => 'Message';

  @override
  String get messageSent => 'Message envoyé';

  @override
  String get minutes => 'Minutes';

  @override
  String minutesShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get myJobs => 'Mes interventions';

  @override
  String get myOrders => 'Mes commandes';

  @override
  String get myProfile => 'Mes données';

  @override
  String get myRepairs => 'Mes réparations';

  @override
  String get myTickets => 'Mes tickets';

  @override
  String get name => 'Nom';

  @override
  String get navigate => 'Naviguer';

  @override
  String get netPrice => 'Prix net';

  @override
  String get newAnswer => 'Nouvelle réponse';

  @override
  String get newContact => 'Nouveau contact';

  @override
  String get newCustomer => 'Nouveau client';

  @override
  String get newDepartment => 'Nouveau département';

  @override
  String get newFamily => 'Nouvelle famille';

  @override
  String get newItem => 'Nouveau';

  @override
  String get newJob => 'Nouvelle intervention';

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
  String get newPriority => 'Nouvelle priorité';

  @override
  String get newProduct => 'Nouveau produit';

  @override
  String get newQuotation => 'Nouvelle offre';

  @override
  String get newRepair => 'Nouvelle réparation';

  @override
  String get newRevision => 'Nouvelle révision';

  @override
  String newRevisionOf(String number) {
    return 'Nouvelle révision de $number';
  }

  @override
  String get newTeam => 'Nouvelle équipe';

  @override
  String get newTicket => 'Nouveau ticket';

  @override
  String get noAccess =>
      'Votre compte n\'a pas encore accès à une section. Demandez à un administrateur.';

  @override
  String get noActiveBom => 'Aucune nomenclature active.';

  @override
  String get noBom => 'Pas encore de nomenclature.';

  @override
  String get noContactLinked => 'Aucune personne de contact liée';

  @override
  String get noContacts => 'Pas encore de contacts.';

  @override
  String get noCustomerLinked => 'Aucun client lié';

  @override
  String get noExpectedClose => 'Pas de date de clôture prévue';

  @override
  String get noJobsAssigned => 'Aucune intervention ne vous est assignée.';

  @override
  String get noLines => 'Pas encore de lignes.';

  @override
  String get noOrdersYet => 'Vous n\'avez pas encore de commandes.';

  @override
  String get noPermission =>
      'Vous n\'avez pas le droit de modifier ces paramètres.';

  @override
  String get noPhotos => 'Pas encore de photos.';

  @override
  String get noPrices => 'Pas encore de prix.';

  @override
  String get noPriorityChanges => 'Aucun changement de priorité.';

  @override
  String get noPriorityRequests => 'Aucune demande.';

  @override
  String get noQuotations => 'Pas encore d\'offres.';

  @override
  String get noRebates => 'Aucune remise produit ou famille.';

  @override
  String get noRepairs => 'Aucune réparation.';

  @override
  String get noRepairsYet => 'Vous n\'avez pas encore de réparations.';

  @override
  String get noSerialComponents => 'Aucun composant sérialisé.';

  @override
  String get noTeam => 'Aucune équipe';

  @override
  String get noTechnicians => 'Personne d\'assigné';

  @override
  String get noTicketsYet => 'Vous n\'avez pas encore de tickets.';

  @override
  String get noTimeEntries => 'Aucun temps enregistré.';

  @override
  String get nobodyFound => 'Personne trouvé avec ce numéro.';

  @override
  String get none => 'Aucun';

  @override
  String get notClosed => 'Non clôturés';

  @override
  String get notRouted => 'Pas encore transmise';

  @override
  String get notScheduled => 'Non planifié';

  @override
  String get noteAdded => 'Note ajoutée';

  @override
  String get noteOptional => 'Remarque (facultatif)';

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
  String get onSiteContact => 'Contact sur place';

  @override
  String get openEnded => 'ouvert';

  @override
  String get openJobsOnly => 'Actives seulement';

  @override
  String get openOnly => 'Ouvertes uniquement';

  @override
  String get openOpportunity => 'Ouvrir l\'opportunité';

  @override
  String openPriorityRequests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count demandes de priorité en cours',
      one: '1 demande de priorité en cours',
    );
    return '$_temp0';
  }

  @override
  String openRepairsCount(String count) {
    return '$count ouvertes';
  }

  @override
  String get opportunities => 'Opportunités';

  @override
  String get opportunity => 'Opportunité';

  @override
  String get opportunityOptional => 'Opportunité (facultatif)';

  @override
  String get order => 'Commande';

  @override
  String orderAlreadyConfirmed(String date) {
    return 'Cette commande a été confirmée le $date.';
  }

  @override
  String get orderAwaitingConfirmation => 'en attente de votre confirmation';

  @override
  String get orderConfirmationQueued =>
      'La confirmation de commande est en attente d\'envoi.';

  @override
  String get orderConfirmedSnack => 'Commande confirmée.';

  @override
  String get orderConfirmedThanks => 'Merci, votre commande est confirmée.';

  @override
  String get orderCreated => 'Commande créée';

  @override
  String get orderSaved => 'Commande enregistrée.';

  @override
  String get orderStatusInPlanning => 'en planification';

  @override
  String get orderStatusInProduction => 'en production';

  @override
  String get orderStatusPlanned => 'planifiée';

  @override
  String get orderStatusReadyForShipping => 'prête à l\'expédition';

  @override
  String get orderStockRelease => 'Libérer';

  @override
  String get orderStockReserve => 'Réserver';

  @override
  String get orderStockReserveHint =>
      'Le stock peut être réservé une fois la commande confirmée par le client.';

  @override
  String orderStockThisLine(String quantity) {
    return '$quantity réservé pour cette ligne';
  }

  @override
  String get orderStockTitle => 'Disponibilité du stock';

  @override
  String get orders => 'Commandes';

  @override
  String get owner => 'Responsable';

  @override
  String get paymentDays => 'Délai de paiement (jours)';

  @override
  String get pdf => 'PDF';

  @override
  String get personTitle => 'Titre';

  @override
  String get phone => 'Téléphone';

  @override
  String get phoneCall => 'Appel téléphonique';

  @override
  String get phoneDirect => 'Direct';

  @override
  String get phoneHint => 'Avec indicatif, p. ex. +32 475 12 34 56';

  @override
  String get phoneMobile => 'Mobile';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get phoneNumbers => 'Numéros de téléphone';

  @override
  String get phoneOther => 'Autre';

  @override
  String get phoneWork => 'Bureau';

  @override
  String photoBy(String name) {
    return 'par $name';
  }

  @override
  String get photos => 'Photos';

  @override
  String get photosAdded => 'Photos ajoutées';

  @override
  String get placeholdersHelp =>
      'Variables (cliquer pour insérer dans la langue affichée) :';

  @override
  String get portalAccess => 'Accès au portail client';

  @override
  String get portalScope => 'Voit dans le portail';

  @override
  String get portalScopeCustomer => 'Tous les tickets de l\'entreprise';

  @override
  String get portalScopeOwn => 'Uniquement ses tickets';

  @override
  String get portalSignInIntro =>
      'Saisissez votre adresse e-mail. Nous vous envoyons un lien de connexion, sans mot de passe.';

  @override
  String get portalTitle => 'Portail client';

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
  String priorityChangeLine(String date, String from, String to, String name) {
    return '$date : $from → $to par $name';
  }

  @override
  String get priorityChangedSnack => 'Priorité modifiée.';

  @override
  String get priorityExpedite => 'urgente';

  @override
  String get priorityHigh => 'haute';

  @override
  String get priorityHistory => 'Historique de la priorité';

  @override
  String get priorityLow => 'basse';

  @override
  String get priorityNormal => 'normale';

  @override
  String get priorityRequestHelp =>
      'Notre équipe décide si et comment la priorité est modifiée.';

  @override
  String priorityRequestLine(String name, String priority) {
    return '$name demande la priorité : $priority';
  }

  @override
  String get priorityRequestSent => 'Votre demande a été envoyée.';

  @override
  String get priorityRequests => 'Demandes de priorité du client';

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
  String get productDescription => 'Produit';

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
  String get profileHelp =>
      'Choisissez la langue et la façon dont nous nous adressons à vous dans nos e-mails et ce portail.';

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
  String raisedBy(String name) {
    return 'Créé par $name';
  }

  @override
  String get reason => 'Motif';

  @override
  String get reasonRequired => 'Un motif est obligatoire.';

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
  String get removeLine => 'Supprimer la ligne';

  @override
  String removedBy(String date, String name) {
    return 'retiré le $date par $name';
  }

  @override
  String get reopenJob => 'Rouvrir';

  @override
  String get repairAnnouncedByTicket =>
      'Le client l\'a annoncée (le produit n\'est pas encore arrivé)';

  @override
  String get repairAnnouncedOk =>
      'Réparation annoncée. Inscrivez le numéro sur le colis et envoyez-nous le produit.';

  @override
  String get repairPhotosHelp =>
      'Des photos du produit et du défaut nous aident beaucoup.';

  @override
  String get repairPortalAnnounced => 'Annoncée, pas encore reçue';

  @override
  String get repairPortalInRepair => 'En réparation';

  @override
  String get repairPortalReady => 'Réparée, prête à l\'expédition';

  @override
  String get repairPortalWaitingCustomer => 'En attente de votre réponse';

  @override
  String get repairStatusAnnounced => 'Annoncée';

  @override
  String get repairStatusCancelled => 'Annulée';

  @override
  String get repairStatusCompleted => 'Terminée';

  @override
  String get repairStatusInProgress => 'En cours';

  @override
  String get repairStatusReceived => 'Reçue';

  @override
  String get repairStatusRouted => 'En file du département';

  @override
  String get repairStatusShipped => 'Renvoyée';

  @override
  String get repairStatusWaitingCustomer => 'En attente du client';

  @override
  String get repairStatusWaitingParts => 'En attente de pièces';

  @override
  String get repairs => 'Réparations';

  @override
  String get replyQueued => 'Réponse en file d\'envoi';

  @override
  String get replyToCustomer => 'Répondre au client';

  @override
  String repricingFailed(String error) {
    return 'Les prix du jour n\'ont pas pu être calculés : $error';
  }

  @override
  String get requestDismissedSnack => 'Demande rejetée.';

  @override
  String get requestLessUrgent => 'Moins urgent';

  @override
  String get requestMoreUrgent => 'Plus urgent (urgente)';

  @override
  String get requestPriorityChange => 'Demander un changement de priorité';

  @override
  String get requestStatusApplied => 'appliquée';

  @override
  String get requestStatusDismissed => 'rejetée';

  @override
  String get requestStatusOpen => 'ouverte';

  @override
  String get required => 'Obligatoire';

  @override
  String get resolutionMinutes => 'Résolution (min)';

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
  String revisionNumber(int revision) {
    return 'Révision $revision';
  }

  @override
  String revisionPriceLists(String agreed, String current) {
    return 'Prix convenus : tarif du $agreed. Prix actuels : tarif du $current.';
  }

  @override
  String revisionViewNotice(int revision, int current) {
    return 'Vous consultez la révision $revision (lecture seule). La révision actuelle est la $current.';
  }

  @override
  String get revisions => 'Révisions';

  @override
  String get roleInvoicing => 'Facturation';

  @override
  String get roleManagement => 'Direction';

  @override
  String get roleOther => 'Autre';

  @override
  String get rolePurchasing => 'Achats';

  @override
  String get roleQuality => 'Qualité';

  @override
  String get roleSalesContact => 'Contact commercial';

  @override
  String get roleTechnical => 'Technicien';

  @override
  String get roles => 'Rôles';

  @override
  String get roundTo => 'Arrondir à';

  @override
  String get routeNote => 'Remarque pour le département';

  @override
  String get routeRepair => 'Transmettre à un département';

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
  String get scheduledEnd => 'Fin';

  @override
  String get scheduledStart => 'Début';

  @override
  String get scrapPercent => 'Rebut %';

  @override
  String get search => 'Rechercher';

  @override
  String get send => 'Envoyer';

  @override
  String get sendBackToTriage => 'Renvoyer au tri';

  @override
  String get sendLoginLink => 'Envoyer le lien de connexion';

  @override
  String get sendOrderConfirmation => 'Envoyer la confirmation de commande';

  @override
  String get sendOrderConfirmationHelp =>
      'La confirmation de commande est envoyée au client par e-mail en PDF. La révision ne pourra plus être modifiée ensuite.';

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
  String get showInactive => 'Afficher les inactifs';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String signedInAs(String name) {
    return 'Connecté en tant que $name';
  }

  @override
  String get signingIn => 'Connexion…';

  @override
  String get singleProduct => 'Produit unique';

  @override
  String get siteAddress => 'Où aller';

  @override
  String get siteName => 'Nom du site';

  @override
  String skippedWithoutPrice(int count) {
    return '$count combinaisons produit/zone n\'ont pas de prix et sont ignorées';
  }

  @override
  String get sla => 'SLA';

  @override
  String get slaAtRisk => 'À risque';

  @override
  String get slaBreached => 'Dépassé';

  @override
  String slaDue(String date) {
    return 'Échéance $date';
  }

  @override
  String get slaFilterAny => 'Tout état SLA';

  @override
  String get slaFirstResponse => 'Première réponse';

  @override
  String slaLeft(String time) {
    return 'encore $time';
  }

  @override
  String get slaMet => 'Respecté';

  @override
  String get slaNone => 'Pas de SLA';

  @override
  String get slaOnTime => 'Dans les temps';

  @override
  String slaOverdue(String time) {
    return '$time de retard';
  }

  @override
  String get slaPaused => 'Chrono arrêté : en attente du client';

  @override
  String get slaPolicies => 'Niveaux de service (SLA)';

  @override
  String get slaPoliciesHelp =>
      'Temps écoulé réel, les heures ouvrables ne sont pas prises en compte. Le chrono s\'arrête tant qu\'un ticket attend le client.';

  @override
  String get slaResolution => 'Résolution';

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
  String get startJob => 'Démarrer';

  @override
  String get startWork => 'Commencer le travail';

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
  String get stockAdjust => 'Corriger';

  @override
  String get stockAdjustReason => 'Pourquoi corriger le stock ?';

  @override
  String get stockAdjustRequired =>
      'Choisissez un emplacement, saisissez une quantité et un motif.';

  @override
  String get stockAllWarehouses => 'Tous les entrepôts';

  @override
  String get stockAssignedTo => 'Attribué à';

  @override
  String get stockAvailable => 'Disponible';

  @override
  String get stockBarcode => 'Code-barres';

  @override
  String get stockBelowReorder => 'Sous le seuil de réappro.';

  @override
  String get stockChangeBy => 'Modifier de (+/−)';

  @override
  String get stockCounts => 'Inventaires';

  @override
  String get stockExpiry => 'Date de péremption';

  @override
  String get stockFrom => 'De';

  @override
  String get stockInVans => 'Dans les camionnettes';

  @override
  String get stockInvalidNumbers =>
      'Le coût, les seuils et le délai doivent être des nombres.';

  @override
  String get stockIssue => 'Sortir';

  @override
  String get stockKindVan => 'Camionnette de service';

  @override
  String get stockKindWarehouse => 'Entrepôt';

  @override
  String get stockLeadTime => 'Délai (jours)';

  @override
  String get stockLocation => 'Emplacement';

  @override
  String get stockLocations => 'Stock par emplacement';

  @override
  String get stockLot => 'Lot';

  @override
  String get stockLotNumber => 'Numéro de lot';

  @override
  String get stockLotTrackingHelp => 'Lots / batchs';

  @override
  String get stockMoves => 'Mouvements';

  @override
  String get stockNewLocation => 'Nouvel emplacement';

  @override
  String get stockNewLot => 'Nouveau lot';

  @override
  String get stockNewQuantity => 'Nouvelle quantité';

  @override
  String get stockNewVan => 'Nouvelle camionnette de service';

  @override
  String get stockNewWarehouse => 'Nouvel entrepôt';

  @override
  String get stockNoMoves => 'Aucun mouvement';

  @override
  String get stockNoWarehouses =>
      'Aucun entrepôt. Un administrateur les crée ici.';

  @override
  String get stockNote => 'Remarque';

  @override
  String get stockNothingInStock => 'Rien en stock';

  @override
  String get stockOnHand => 'En stock';

  @override
  String get stockOnlyInStock => 'Seulement en stock';

  @override
  String get stockProductQuantityRequired =>
      'Choisissez un produit et saisissez une quantité.';

  @override
  String get stockReasonConsumption => 'Consommation';

  @override
  String get stockReasonCorrection => 'Correction';

  @override
  String get stockReasonCount => 'Inventaire';

  @override
  String get stockReasonManualReceipt => 'Réception manuelle';

  @override
  String get stockReasonProductionOutput => 'Production terminée';

  @override
  String get stockReasonPurchaseReceipt => 'Réception d\'achat';

  @override
  String get stockReasonRepairUse => 'Utilisé en réparation';

  @override
  String get stockReasonReturn => 'Retour client';

  @override
  String get stockReasonReversal => 'Annulation';

  @override
  String get stockReasonScrap => 'Rebut';

  @override
  String get stockReasonShipment => 'Expédition';

  @override
  String get stockReasonVanReplenishment => 'Réapprovisionnement camionnette';

  @override
  String get stockReceive => 'Réceptionner';

  @override
  String get stockReorderMax => 'Stock maximum';

  @override
  String get stockReorderMin => 'Stock minimum';

  @override
  String get stockReservations => 'Réservé pour des commandes';

  @override
  String get stockReserved => 'Réservé';

  @override
  String get stockReverse => 'Annuler';

  @override
  String get stockReverseTitle => 'Annuler ce mouvement';

  @override
  String get stockReversed => 'annulé';

  @override
  String stockShortBy(String quantity) {
    return 'Manque $quantity';
  }

  @override
  String get stockStandardCost => 'Coût standard';

  @override
  String get stockStateAvailable => 'En stock';

  @override
  String get stockStateNotStocked => 'Non stocké';

  @override
  String get stockStatePartial => 'En stock partiellement';

  @override
  String get stockStateReserved => 'Réservé';

  @override
  String get stockStateShort => 'Pas en stock';

  @override
  String get stockTitle => 'Stock';

  @override
  String get stockTo => 'Vers';

  @override
  String get stockTrackingLot => 'lot';

  @override
  String get stockTransfer => 'Transférer';

  @override
  String get stockWarehouse => 'Entrepôt';

  @override
  String get stockWarehouses => 'Entrepôts';

  @override
  String get street => 'Rue';

  @override
  String get streetAddress => 'Rue et numéro';

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
  String get tags => 'Étiquettes';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get tasks => 'Tâches';

  @override
  String tasksProgress(String done, String total) {
    return '$done sur $total terminées';
  }

  @override
  String get team => 'Équipe';

  @override
  String get teamLead => 'Responsable';

  @override
  String get teamMembers => 'Membres';

  @override
  String get teamName => 'Nom de l\'équipe';

  @override
  String get teams => 'Équipes';

  @override
  String get technicians => 'Techniciens';

  @override
  String get text => 'Texte';

  @override
  String get ticketClosed => 'Clôturé';

  @override
  String get ticketDetails => 'Détails du ticket';

  @override
  String get ticketInProgress => 'En cours de traitement';

  @override
  String get ticketMerged => 'Tickets fusionnés';

  @override
  String get ticketOpened => 'Ticket créé';

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
  String get ticketWaitingForYou => 'En attente de votre réponse';

  @override
  String get timeNote => 'Note';

  @override
  String timeTotal(String total, String billable) {
    return 'Total $total, facturable $billable';
  }

  @override
  String timeTotals(String work, String travel) {
    return 'Travail $work · Déplacement $travel';
  }

  @override
  String get timeTracking => 'Suivi du temps';

  @override
  String get title => 'Titre';

  @override
  String get titleCustomerValueRequired =>
      'Le titre, le client et une valeur valide sont obligatoires.';

  @override
  String get titleMr => 'M.';

  @override
  String get titleMs => 'Mme';

  @override
  String get titleNone => 'Non précisé';

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
  String get unknownCaller => 'Appelant inconnu';

  @override
  String get until => 'Jusqu\'au';

  @override
  String get updateToCurrentPrices => 'Mettre à jour aux prix actuels';

  @override
  String get updated => 'Mis à jour';

  @override
  String get uploadingFile => 'Envoi…';

  @override
  String get uploadingPhotos => 'Envoi…';

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
  String get viaPortal => 'Via le portail client';

  @override
  String get warranty => 'Garantie';

  @override
  String get warrantyIn => 'Sous garantie';

  @override
  String get warrantyOut => 'Hors garantie';

  @override
  String get warrantyUnknown => 'Inconnue';

  @override
  String weighted(String amount) {
    return 'pondéré $amount';
  }

  @override
  String get whatWasAsked => 'Quelle est la demande ?';

  @override
  String get whoIsCalling => 'Qui appelle ?';

  @override
  String get won => 'Gagnée';

  @override
  String get workFrom => 'De';

  @override
  String get workKindTravel => 'Déplacement';

  @override
  String get workKindWork => 'Travail';

  @override
  String get workLogs => 'Temps enregistré';

  @override
  String get workUntil => 'À';

  @override
  String writeIn(String language) {
    return 'Rédiger en $language';
  }

  @override
  String get yourMessage => 'Votre message';

  @override
  String get yourReference => 'Votre référence (RMA ou commande)';

  @override
  String get zone => 'Zone';

  @override
  String zoneAndRebate(String zone, String percent) {
    return 'Zone $zone · remise générale $percent %';
  }

  @override
  String get zonesNoneAll => 'Zones (aucune sélection = toutes)';

  @override
  String get kbTitle => 'Base de connaissances';

  @override
  String get kbNewArticle => 'Nouvel article';

  @override
  String get kbSearchHint => 'Rechercher des articles';

  @override
  String get kbAllCategories => 'Toutes les catégories';

  @override
  String get kbAllStatuses => 'Tous les statuts';

  @override
  String get kbAllAudiences => 'Tous les publics';

  @override
  String get kbManageCategories => 'Catégories';

  @override
  String get kbStatusPublished => 'Publié';

  @override
  String get kbStatusArchived => 'Archivé';

  @override
  String get kbAudience => 'Public';

  @override
  String get kbAudienceInternal => 'Interne (personnel uniquement)';

  @override
  String get kbAudiencePortal => 'Portail client';

  @override
  String get kbAudiencePublic => 'Public';

  @override
  String get kbArticleTitle => 'Titre';

  @override
  String get kbSummary => 'Résumé';

  @override
  String get kbBody => 'Texte (Markdown)';

  @override
  String get kbPreview => 'Aperçu';

  @override
  String get kbWriteTab => 'Rédiger';

  @override
  String get kbMarkdownHelp =>
      'Utilisez # pour les titres, **gras**, *italique*, - pour les listes, [texte](https://…) pour les liens et ![description](image:ID) pour les images.';

  @override
  String get kbTagsLabel => 'Étiquettes (séparées par des virgules)';

  @override
  String get kbRelated => 'Articles liés';

  @override
  String get kbAddRelated => 'Ajouter un article lié';

  @override
  String get kbImages => 'Images';

  @override
  String get kbUploadImage => 'Téléverser une image';

  @override
  String get kbInsertImage => 'Insérer dans le texte';

  @override
  String get kbPublish => 'Publier';

  @override
  String get kbUnpublish => 'Dépublier';

  @override
  String get kbArchive => 'Archiver';

  @override
  String get kbHistory => 'Historique des versions';

  @override
  String kbVersionLine(int version, String name, String date) {
    return 'Version $version · $name · $date';
  }

  @override
  String get kbRestore => 'Restaurer cette version';

  @override
  String kbRestoredFrom(int version) {
    return 'restaurée depuis la version $version';
  }

  @override
  String kbFeedback(int yes, int no) {
    return '$yes l\'ont trouvé utile, $no non';
  }

  @override
  String kbViews(int count) {
    return '$count vues';
  }

  @override
  String get kbNoArticles => 'Aucun article trouvé.';

  @override
  String get kbNoCategory => 'Aucune catégorie';

  @override
  String get kbMainCategory => 'Catégorie principale';

  @override
  String get kbSortOrder => 'Ordre';

  @override
  String get kbNewCategory => 'Nouvelle catégorie';

  @override
  String get kbCategoryNames => 'Nom par langue';

  @override
  String get kbDelete => 'Supprimer';

  @override
  String get kbSuggestedArticles => 'Articles suggérés';

  @override
  String get kbNoSuggestions => 'Aucun article correspondant.';

  @override
  String get kbInsertText => 'Insérer le texte';

  @override
  String get kbInsertLink => 'Insérer le lien';

  @override
  String get kbInsertArticle => 'Insérer un article';

  @override
  String get kbNoPortalLink =>
      'Cet article est interne : seul son texte peut être inséré.';

  @override
  String get kbHelp => 'Aide';

  @override
  String get kbHelpHeading => 'Comment pouvons-nous vous aider ?';

  @override
  String get kbHelpSearch => 'Rechercher dans les articles d\'aide';

  @override
  String get kbHelpEmpty =>
      'Aucun article trouvé. Vous pouvez ouvrir un ticket.';

  @override
  String get kbWasHelpful => 'Cet article vous a-t-il aidé ?';

  @override
  String get kbYes => 'Oui';

  @override
  String get kbNo => 'Non';

  @override
  String get kbThanks => 'Merci pour votre retour.';

  @override
  String get kbStillNeedHelp => 'Besoin d\'aide ? Ouvrez un ticket.';

  @override
  String get kbRelatedReading => 'Articles liés';

  @override
  String get kbDeflectionTitle =>
      'Ces articles répondent peut-être déjà à votre question';

  @override
  String kbShownIn(String language) {
    return 'Non disponible dans votre langue ; affiché en $language.';
  }

  @override
  String kbUpdatedOn(String date) {
    return 'Mis à jour le $date';
  }
}
