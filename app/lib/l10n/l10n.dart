import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// The five languages of the app and of customer communication.
const languageCodes = ['nl', 'fr', 'en', 'de', 'es'];

/// A language's own name, e.g. for a language picker.
String languageName(String code) => switch (code) {
  'nl' => 'Nederlands',
  'fr' => 'Français',
  'en' => 'English',
  'de' => 'Deutsch',
  'es' => 'Español',
  _ => code,
};

/// Labels for values that come from the API as codes.
extension CodeLabels on AppLocalizations {
  String quotationStatus(String s) => switch (s) {
    'draft' => statusDraft,
    'sent' => statusSent,
    'accepted' => statusAccepted,
    'rejected' => statusRejected,
    'superseded' => statusSuperseded,
    _ => s,
  };

  String opportunityStage(String s) => switch (s) {
    'lead' => stageLead,
    'qualified' => stageQualified,
    'proposal' => stageProposal,
    'negotiation' => stageNegotiation,
    'won' => stageWon,
    'lost' => stageLost,
    _ => s,
  };

  String ticketStatus(String s) => switch (s) {
    'new' => ticketStatusNew,
    'open' => ticketStatusOpen,
    'pending_customer' => ticketStatusPendingCustomer,
    'pending_internal' => ticketStatusPendingInternal,
    'closed' => ticketStatusClosed,
    _ => s,
  };

  String ticketPriority(String s) => switch (s) {
    'low' => priorityLow,
    'normal' => priorityNormal,
    'high' => priorityHigh,
    'urgent' => priorityUrgent,
    _ => s,
  };

  String ticketCategory(String s) => switch (s) {
    'question' => categoryQuestion,
    'lead' => categoryLead,
    'quote_change' => categoryQuoteChange,
    'order_confirmation' => categoryOrderConfirmation,
    'production_question' => categoryProductionQuestion,
    'service' => categoryService,
    'complaint' => categoryComplaint,
    'other' => categoryOther,
    _ => s,
  };

  String productType(String s) => switch (s) {
    'purchased' => productTypePurchased,
    'manufactured' => productTypeManufactured,
    'configurable' => productTypeConfigurable,
    'service' => productTypeService,
    _ => s,
  };

  String pricingType(String s) => switch (s) {
    'list' => pricingList,
    'net' => pricingNet,
    'indicative' => pricingIndicative,
    _ => s,
  };

  String rebateSource(String s) => switch (s) {
    'product' => rebateSourceProduct,
    'family' => rebateSourceFamily,
    'general' => rebateSourceGeneral,
    'net' => pricingNet,
    _ => s,
  };

  String serialStatus(String s) => switch (s) {
    'in_stock' => serialInStock,
    'built_in' => serialBuiltIn,
    'delivered' => serialDelivered,
    'installed' => serialInstalled,
    'scrapped' => serialScrapped,
    _ => s,
  };

  String bomStatus(String s) => switch (s) {
    'draft' => statusDraft,
    'active' => bomActive,
    'obsolete' => bomObsolete,
    _ => s,
  };

  String contactRole(String s) => switch (s) {
    'sales_contact' => roleSalesContact,
    'technical' => roleTechnical,
    'purchasing' => rolePurchasing,
    'invoicing' => roleInvoicing,
    'management' => roleManagement,
    'quality' => roleQuality,
    _ => roleOther,
  };

  String personTitleLabel(String s) => switch (s) {
    'mr' => titleMr,
    'ms' => titleMs,
    _ => titleNone,
  };

  String phoneLabel(String s) => switch (s) {
    'work' => phoneWork,
    'mobile' => phoneMobile,
    'direct' => phoneDirect,
    _ => phoneOther,
  };

  /// How the portal shows a ticket's state; internal states read as "in progress".
  String portalTicketStatus(String s) => switch (s) {
    'closed' => ticketClosed,
    'pending_customer' => ticketWaitingForYou,
    _ => ticketInProgress,
  };
}

/// Roles a contact can have at a customer, as the API names them.
const contactRoles = [
  'sales_contact',
  'technical',
  'purchasing',
  'invoicing',
  'management',
  'quality',
  'other',
];
