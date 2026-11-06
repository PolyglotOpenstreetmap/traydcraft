// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get accepted => 'Aceptado';

  @override
  String get accessToken => 'Token de acceso';

  @override
  String get account => 'Cuenta';

  @override
  String get actions => 'Acciones';

  @override
  String get activate => 'Activar';

  @override
  String get active => 'Activo';

  @override
  String activeSince(String date) {
    return 'Activa desde el $date. Los cambios se hacen con una nueva revisión.';
  }

  @override
  String get addComponent => 'Añadir componente';

  @override
  String get addComponentBySerial =>
      'Añadir componente por número de serie (en stock)';

  @override
  String get addNote => 'Añadir nota';

  @override
  String get addNoteHint => 'Añadir una nota interna';

  @override
  String get addPhone => 'Añadir teléfono';

  @override
  String get addPhoto => 'Añadir foto';

  @override
  String get addProduct => 'Añadir producto';

  @override
  String get addRebate => 'Añadir descuento';

  @override
  String get addTask => 'Añadir tarea';

  @override
  String addedBy(String date, String name) {
    return 'añadido el $date por $name';
  }

  @override
  String get addressForm => 'Forma de trato';

  @override
  String get addressFormal => 'Formal (usted)';

  @override
  String get addressInformal => 'Informal (tú)';

  @override
  String get agreed => 'Acordado';

  @override
  String get all => 'Todos';

  @override
  String get allProducts => 'Todos los productos';

  @override
  String get allStatuses => 'Todos los estados';

  @override
  String get always => 'siempre';

  @override
  String andMore(int count) {
    return '… y $count más';
  }

  @override
  String get announceRepair => 'Anunciar una reparación';

  @override
  String get announcedNotReceived => 'Anunciada, aún no recibida';

  @override
  String answerFallback(String ticketLanguage, String usedLanguage) {
    return 'Aún no hay texto en $ticketLanguage: se ha usado el texto en $usedLanguage. Tradúzcalo antes de enviarlo.';
  }

  @override
  String get appLanguage => 'Idioma';

  @override
  String get appTitle => 'traydcraft';

  @override
  String get apply => 'Aplicar';

  @override
  String get assignTo => 'Asignar a';

  @override
  String get automatic => 'Automático';

  @override
  String get backIntoWork => 'Volver a trabajar';

  @override
  String get billOfMaterials => 'Lista de materiales';

  @override
  String get bomActive => 'activa';

  @override
  String get bomObsolete => 'obsoleta';

  @override
  String get bomRev => 'Rev. LdM';

  @override
  String get bomRevision => 'Revisión de la LdM';

  @override
  String get builtInto => 'Montado en';

  @override
  String get bulkKeepsQuotes =>
      'Los presupuestos anteriores a esta fecha mantienen los precios actuales';

  @override
  String get bulkPriceChange => 'Cambio de precios en bloque';

  @override
  String get byStage => 'según la fase';

  @override
  String get callIncoming => 'Llamada entrante';

  @override
  String get callLogged => 'Llamada registrada';

  @override
  String get callMinutes => 'Duración (minutos)';

  @override
  String get callOutgoing => 'Llamada saliente';

  @override
  String get callSummary => 'Qué se habló';

  @override
  String callWith(String name) {
    return 'Llamada con $name';
  }

  @override
  String get canStillKeep => 'Aún puede mantener los precios acordados.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cancelJob => 'Cancelar trabajo';

  @override
  String get cancelRepair => 'Cancelar reparación';

  @override
  String get cancelled => 'cancelado';

  @override
  String get category => 'Categoría';

  @override
  String get categoryComplaint => 'reclamación';

  @override
  String get categoryLead => 'prospecto (nueva solicitud)';

  @override
  String get categoryOrderConfirmation => 'confirmación de pedido';

  @override
  String get categoryOther => 'otro';

  @override
  String get categoryProductionQuestion => 'consulta de producción';

  @override
  String get categoryQuestion => 'consulta';

  @override
  String get categoryQuoteChange => 'cambio de presupuesto';

  @override
  String get categoryService => 'servicio / reparación';

  @override
  String get cc => 'CC';

  @override
  String get change => 'Cambio';

  @override
  String get chooseCustomerAndLine =>
      'Elija un cliente y añada al menos una línea válida.';

  @override
  String get choosePhoto => 'Elegir de la galería';

  @override
  String get chooseRebateTarget =>
      'Elija un producto o familia e indique un porcentaje.';

  @override
  String get chooseZonePrice => 'Elija una zona e indique un precio.';

  @override
  String get city => 'Ciudad';

  @override
  String get close => 'Cerrar';

  @override
  String get code => 'Código';

  @override
  String get codeNameVatRequired =>
      'El código, el nombre y el tipo de IVA son obligatorios.';

  @override
  String get completeJob => 'Completar trabajo';

  @override
  String get completionNotes => 'Qué se hizo (y qué queda pendiente)';

  @override
  String get component => 'Componente';

  @override
  String get componentHistory => 'Historial de componentes';

  @override
  String componentSince(String product, String date) {
    return '$product · desde $date';
  }

  @override
  String get componentsAsBuilt => 'Componentes (según fabricación)';

  @override
  String get confirm => 'confirmar';

  @override
  String get confirmed => 'confirmado';

  @override
  String conflictsOnDate(int count) {
    return '$count ya tienen un precio en esta fecha';
  }

  @override
  String get contactName => 'Nombre del contacto';

  @override
  String get contactPerson => 'Persona de contacto';

  @override
  String get contacts => 'Contactos';

  @override
  String get convertHelp =>
      '¿El cliente quiere cambios? Cree primero una nueva revisión del presupuesto, vincúlela aquí y luego conviértala.';

  @override
  String get convertToOrder => 'Convertir en pedido';

  @override
  String countOf(int count, int total) {
    return '$count de $total';
  }

  @override
  String get country => 'País';

  @override
  String get create => 'Crear';

  @override
  String get createLead => 'Crear oportunidad';

  @override
  String get createRepair => 'Crear reparación';

  @override
  String get current => 'Actual';

  @override
  String get customer => 'Cliente';

  @override
  String get customerLanguage => 'Idioma del cliente';

  @override
  String customerMainNumber(String name) {
    return 'Número principal de $name';
  }

  @override
  String customerNamed(String name) {
    return 'Cliente: $name';
  }

  @override
  String get customerOptional => 'Cliente (opcional)';

  @override
  String get customerReference => 'Referencia del cliente';

  @override
  String get customers => 'Clientes';

  @override
  String get date => 'Fecha';

  @override
  String get deliveryFailed => 'no enviado';

  @override
  String get deliveryQueued => 'pendiente de envío';

  @override
  String get deliverySent => 'enviado';

  @override
  String get department => 'Departamento';

  @override
  String get departmentCode => 'Código';

  @override
  String get departmentMembers => 'Compañeros de este departamento';

  @override
  String get departments => 'Departamentos';

  @override
  String get departmentsHelp =>
      'Las reparaciones se envían a estos departamentos. Solo los compañeros de un departamento pueden trabajar en sus reparaciones.';

  @override
  String get description => 'Descripción';

  @override
  String get devModeHelp => 'El servidor debe ejecutarse con AUTH_MODE=dev';

  @override
  String get developmentUser => 'Usuario de desarrollo';

  @override
  String get deviceLanguage => 'Idioma del dispositivo';

  @override
  String get difference => 'Diferencia';

  @override
  String get draftSaved => 'Borrador guardado';

  @override
  String get edit => 'Editar';

  @override
  String get editContact => 'Editar contacto';

  @override
  String get editDepartment => 'Editar departamento';

  @override
  String get editJob => 'Editar trabajo';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailAddresses =>
      'Direcciones de correo (la primera es la principal)';

  @override
  String get enterChange => 'Indique el cambio, p. ej. 4,5 para +4,5 %.';

  @override
  String enterValidNumbersLine(int line) {
    return 'Línea $line: indique números válidos.';
  }

  @override
  String get expectedClose => 'Cierre previsto';

  @override
  String expectedCloseDate(String date) {
    return 'Cierre previsto el $date';
  }

  @override
  String get expectedValue => 'Valor esperado';

  @override
  String get expectedValueEur => 'Valor esperado (€)';

  @override
  String get expectedValueOptional => 'Valor esperado (opcional)';

  @override
  String get explode => 'Desglosar';

  @override
  String get families => 'Familias';

  @override
  String get family => 'Familia';

  @override
  String familyNamed(String code) {
    return 'Familia $code';
  }

  @override
  String get faultDescription => 'Qué falla';

  @override
  String get firstName => 'Nombre';

  @override
  String get from => 'Desde';

  @override
  String get fromYou => 'Usted';

  @override
  String generalRebateInfo(String percent) {
    return 'Descuento general en todos los productos: $percent % (los productos con precio neto nunca tienen descuento).';
  }

  @override
  String get generalRebatePercent => 'Descuento general %';

  @override
  String greetingPreview(String greeting) {
    return 'Saludo: $greeting';
  }

  @override
  String get helpdesk => 'Atención al cliente';

  @override
  String get history => 'Historial';

  @override
  String get inactive => 'inactivo';

  @override
  String get inactiveContact => 'Ya no está activo (se ha ido)';

  @override
  String indicativeLine(String description) {
    return '$description (orientativo, por confirmar)';
  }

  @override
  String indicativeToConfirm(int count) {
    return '$count precio(s) orientativo(s) por confirmar antes de enviar el presupuesto: indique el precio acordado en el campo precio de tarifa.';
  }

  @override
  String get insertPreparedAnswer => 'Insertar respuesta predefinida';

  @override
  String get instructions => 'Instrucciones';

  @override
  String get internalNote => 'Nota interna';

  @override
  String internalQuestionHelp(String language) {
    return 'Pregunta interna. Pregunte al cliente en $language con una respuesta y después anote la respuesta para su compañero como nota interna.';
  }

  @override
  String get internalTicket => 'Ticket interno';

  @override
  String get internalTicketHelp =>
      'Una pregunta entre compañeros; no se envía nada al cliente.';

  @override
  String get jobCancelled => 'Cancelado';

  @override
  String get jobCompleted => 'Completado';

  @override
  String get jobInProgress => 'En curso';

  @override
  String get jobKindInspection => 'Inspección';

  @override
  String get jobKindInstallation => 'Instalación';

  @override
  String get jobKindMaintenance => 'Mantenimiento';

  @override
  String get jobKindOther => 'Otro';

  @override
  String get jobKindRepair => 'Reparación';

  @override
  String get jobName => 'Título';

  @override
  String get jobPlanned => 'Planificado';

  @override
  String get jobTitle => 'Cargo';

  @override
  String get jobs => 'Trabajos';

  @override
  String get keepAgreedPrices => 'Mantener precios acordados';

  @override
  String get language => 'Idioma';

  @override
  String languageSameAsCustomer(String language) {
    return 'Igual que la empresa ($language)';
  }

  @override
  String get lastName => 'Apellidos';

  @override
  String get leadCreated => 'Oportunidad creada';

  @override
  String get lineDiscount => 'Dto. línea';

  @override
  String get listPrice => 'Precio de tarifa';

  @override
  String get loadMore => 'Cargar más';

  @override
  String get logCall => 'Registrar llamada';

  @override
  String get logWork => 'Registrar trabajo';

  @override
  String get loginLinkInvalid =>
      'Este enlace ha caducado o ya se usó. Solicite uno nuevo.';

  @override
  String get loginLinkSent =>
      'Si esta dirección puede usar el portal, le hemos enviado un enlace de acceso. Revise su bandeja de entrada.';

  @override
  String get lookUp => 'Buscar';

  @override
  String get lost => 'Perdida';

  @override
  String get lostReason => 'Motivo de pérdida';

  @override
  String get markAsLost => 'Marcar como perdida';

  @override
  String get markAsSent => 'Marcar como enviado';

  @override
  String get markCompleted => 'Marcar como completada';

  @override
  String get markReceived => 'Marcar como recibida';

  @override
  String get markShipped => 'Marcar como enviada';

  @override
  String get markWaitingCustomer => 'Esperando al cliente';

  @override
  String get markWaitingParts => 'Esperando piezas';

  @override
  String get materialRequirements =>
      'Necesidades de material (revisión activa)';

  @override
  String get message => 'Mensaje';

  @override
  String get messageSent => 'Mensaje enviado';

  @override
  String minutesShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get myJobs => 'Mis trabajos';

  @override
  String get myProfile => 'Mis datos';

  @override
  String get myRepairs => 'Mis reparaciones';

  @override
  String get myTickets => 'Mis tickets';

  @override
  String get name => 'Nombre';

  @override
  String get navigate => 'Navegar';

  @override
  String get netPrice => 'Precio neto';

  @override
  String get newAnswer => 'Nueva respuesta';

  @override
  String get newContact => 'Nuevo contacto';

  @override
  String get newCustomer => 'Nuevo cliente';

  @override
  String get newDepartment => 'Nuevo departamento';

  @override
  String get newFamily => 'Nueva familia';

  @override
  String get newItem => 'Nuevo';

  @override
  String get newJob => 'Nuevo trabajo';

  @override
  String get newLabel => 'Nuevo';

  @override
  String get newOpportunity => 'Nueva oportunidad';

  @override
  String get newPrice => 'Nuevo precio';

  @override
  String newPricesValidFrom(String date) {
    return 'Nuevos precios válidos desde $date';
  }

  @override
  String get newProduct => 'Nuevo producto';

  @override
  String get newQuotation => 'Nuevo presupuesto';

  @override
  String get newRepair => 'Nueva reparación';

  @override
  String get newRevision => 'Nueva revisión';

  @override
  String newRevisionOf(String number) {
    return 'Nueva revisión de $number';
  }

  @override
  String get newTicket => 'Nuevo ticket';

  @override
  String get noAccess =>
      'Su cuenta aún no tiene acceso a ninguna sección. Consulte a un administrador.';

  @override
  String get noActiveBom => 'No hay lista de materiales activa.';

  @override
  String get noBom => 'Aún no hay lista de materiales.';

  @override
  String get noContactLinked => 'Ninguna persona de contacto vinculada';

  @override
  String get noContacts => 'Aún no hay contactos.';

  @override
  String get noCustomerLinked => 'Ningún cliente vinculado';

  @override
  String get noExpectedClose => 'Sin fecha de cierre prevista';

  @override
  String get noJobsAssigned => 'No tiene trabajos asignados.';

  @override
  String get noLines => 'Aún no hay líneas.';

  @override
  String get noPhotos => 'Aún no hay fotos.';

  @override
  String get noPrices => 'Aún no hay precios.';

  @override
  String get noQuotations => 'Aún no hay presupuestos.';

  @override
  String get noRebates => 'Sin descuentos por producto o familia.';

  @override
  String get noRepairs => 'Sin reparaciones.';

  @override
  String get noRepairsYet => 'Aún no tiene reparaciones.';

  @override
  String get noSerialComponents => 'Sin componentes con número de serie.';

  @override
  String get noTechnicians => 'Nadie asignado';

  @override
  String get noTicketsYet => 'Aún no tiene tickets.';

  @override
  String get nobodyFound => 'No se encontró a nadie con este número.';

  @override
  String get none => 'Ninguno';

  @override
  String get notClosed => 'No cerrados';

  @override
  String get notRouted => 'Aún sin enviar';

  @override
  String get notScheduled => 'Sin planificar';

  @override
  String get noteAdded => 'Nota añadida';

  @override
  String get notes => 'Observaciones';

  @override
  String get number => 'Número';

  @override
  String get numberRequired => 'Número';

  @override
  String get obsoleteRevision => 'Revisión obsoleta (solo lectura).';

  @override
  String get oidcAccessToken => 'Token de acceso OIDC';

  @override
  String get ok => 'Aceptar';

  @override
  String get onSiteContact => 'Contacto en el lugar';

  @override
  String get openEnded => 'abierto';

  @override
  String get openJobsOnly => 'Solo activos';

  @override
  String get openOnly => 'Solo abiertas';

  @override
  String get openOpportunity => 'Abrir oportunidad';

  @override
  String openRepairsCount(String count) {
    return '$count abiertas';
  }

  @override
  String get opportunities => 'Oportunidades';

  @override
  String get opportunity => 'Oportunidad';

  @override
  String get opportunityOptional => 'Oportunidad (opcional)';

  @override
  String get order => 'Pedido';

  @override
  String get orderCreated => 'Pedido creado';

  @override
  String get orders => 'Pedidos';

  @override
  String get owner => 'Responsable';

  @override
  String get paymentDays => 'Plazo de pago (días)';

  @override
  String get pdf => 'PDF';

  @override
  String get personTitle => 'Tratamiento';

  @override
  String get phone => 'Teléfono';

  @override
  String get phoneCall => 'Llamada telefónica';

  @override
  String get phoneDirect => 'Directo';

  @override
  String get phoneHint => 'Con prefijo, p. ej. +32 475 12 34 56';

  @override
  String get phoneMobile => 'Móvil';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get phoneNumbers => 'Teléfonos';

  @override
  String get phoneOther => 'Otro';

  @override
  String get phoneWork => 'Trabajo';

  @override
  String photoBy(String name) {
    return 'por $name';
  }

  @override
  String get photos => 'Fotos';

  @override
  String get photosAdded => 'Fotos añadidas';

  @override
  String get placeholdersHelp =>
      'Marcadores (clic para insertar en el idioma actual):';

  @override
  String get portalAccess => 'Acceso al portal de clientes';

  @override
  String get portalScope => 'Ve en el portal';

  @override
  String get portalScopeCustomer => 'Todos los tickets de la empresa';

  @override
  String get portalScopeOwn => 'Solo sus tickets';

  @override
  String get portalSignInIntro =>
      'Introduzca su correo electrónico. Le enviaremos un enlace para acceder, sin contraseña.';

  @override
  String get portalTitle => 'Portal de clientes';

  @override
  String get postalCode => 'Código postal';

  @override
  String get preparedAnswers => 'Respuestas predefinidas';

  @override
  String get preparedAnswersHelp =>
      'Respuestas reutilizables a preguntas frecuentes, un texto por idioma. Los marcadores como «quotation.number» se rellenan para el ticket; el texto puede editarse antes de enviarlo.';

  @override
  String get preview => 'Vista previa';

  @override
  String priceListOf(String date) {
    return 'Tarifa del $date';
  }

  @override
  String get priceListValidOn => 'Tarifa válida el';

  @override
  String get priceZone => 'Zona de precios';

  @override
  String pricedOnPriceListOf(String date) {
    return 'Valorado con la tarifa del $date';
  }

  @override
  String get prices => 'Precios';

  @override
  String pricesCreated(int count, String date) {
    return '$count precios creados, válidos desde $date';
  }

  @override
  String pricesWillChange(int count) {
    return 'Cambiarán $count precios';
  }

  @override
  String get pricing => 'Precios';

  @override
  String get pricingIndicative => 'orientativo';

  @override
  String get pricingIndicativeHelp =>
      'Orientativo (confirmar en cada presupuesto)';

  @override
  String get pricingList => 'precio de tarifa';

  @override
  String get pricingListHelp => 'Precio de tarifa (se aplican descuentos)';

  @override
  String get pricingNet => 'neto';

  @override
  String get pricingNetHelp => 'Precio neto (nunca con descuento)';

  @override
  String get priority => 'Prioridad';

  @override
  String get priorityHigh => 'alta';

  @override
  String get priorityLow => 'baja';

  @override
  String get priorityNormal => 'normal';

  @override
  String get priorityUrgent => 'urgente';

  @override
  String get probability => 'Probabilidad';

  @override
  String get probabilityPercent => 'Probabilidad %';

  @override
  String get probabilityShort => 'Prob.';

  @override
  String get product => 'Producto';

  @override
  String productCount(int count) {
    return '$count productos';
  }

  @override
  String get productDescription => 'Producto';

  @override
  String get productFamilies => 'Familias de productos';

  @override
  String get productFamily => 'Familia de productos';

  @override
  String get productRebates => 'Descuentos por producto';

  @override
  String get productTypeConfigurable => 'configurable';

  @override
  String get productTypeManufactured => 'fabricado';

  @override
  String get productTypePurchased => 'comprado';

  @override
  String get productTypeService => 'servicio';

  @override
  String get products => 'Productos';

  @override
  String get profileHelp =>
      'Elija el idioma y el trato que usamos en nuestros correos y en este portal.';

  @override
  String get quantity => 'Cantidad';

  @override
  String get question => 'Pregunta';

  @override
  String get questionToSales => 'Pregunta a ventas';

  @override
  String questionToSalesHelp(String salesperson) {
    return '$salesperson recibe esta pregunta y la plantea al cliente en su idioma.';
  }

  @override
  String get quotation => 'Presupuesto';

  @override
  String get quotations => 'Presupuestos';

  @override
  String raisedBy(String name) {
    return 'Creado por $name';
  }

  @override
  String get reason => 'Motivo';

  @override
  String get rebate => 'Descuento';

  @override
  String rebateFor(String target, String percent) {
    return '$target: $percent %';
  }

  @override
  String get rebatePercent => 'Descuento %';

  @override
  String get rebateSourceFamily => 'familia';

  @override
  String get rebateSourceGeneral => 'general';

  @override
  String get rebateSourceProduct => 'producto';

  @override
  String rebatesOf(String customer) {
    return 'Descuentos · $customer';
  }

  @override
  String registerProduct(String product) {
    return 'Registrar $product';
  }

  @override
  String get registerUnit => 'Registrar unidad';

  @override
  String get registered => 'Registrado';

  @override
  String get rejected => 'Rechazado';

  @override
  String get remove => 'Eliminar';

  @override
  String get removeAndScrap => 'Quitar y desechar';

  @override
  String get removeBackToStock => 'Quitar, devolver al stock';

  @override
  String removedBy(String date, String name) {
    return 'quitado el $date por $name';
  }

  @override
  String get reopenJob => 'Reabrir trabajo';

  @override
  String get repairAnnouncedByTicket =>
      'El cliente la anunció (el producto aún no ha llegado)';

  @override
  String get repairAnnouncedOk =>
      'Reparación anunciada. Escriba el número en el paquete y envíenos el producto.';

  @override
  String get repairPhotosHelp =>
      'Las fotos del producto y de la avería nos ayudan mucho.';

  @override
  String get repairPortalAnnounced => 'Anunciada, aún no recibida';

  @override
  String get repairPortalInRepair => 'En reparación';

  @override
  String get repairPortalReady => 'Reparada, lista para enviar';

  @override
  String get repairPortalWaitingCustomer => 'Esperando su respuesta';

  @override
  String get repairStatusAnnounced => 'Anunciada';

  @override
  String get repairStatusCancelled => 'Cancelada';

  @override
  String get repairStatusCompleted => 'Completada';

  @override
  String get repairStatusInProgress => 'En curso';

  @override
  String get repairStatusReceived => 'Recibida';

  @override
  String get repairStatusRouted => 'En cola del departamento';

  @override
  String get repairStatusShipped => 'Enviada de vuelta';

  @override
  String get repairStatusWaitingCustomer => 'Esperando al cliente';

  @override
  String get repairStatusWaitingParts => 'Esperando piezas';

  @override
  String get repairs => 'Reparaciones';

  @override
  String get replyQueued => 'Respuesta en cola de envío';

  @override
  String get replyToCustomer => 'Responder al cliente';

  @override
  String repricingFailed(String error) {
    return 'No se han podido calcular los precios de hoy: $error';
  }

  @override
  String get required => 'Obligatorio';

  @override
  String get retry => 'Reintentar';

  @override
  String get revisionActivated => 'Revisión activada';

  @override
  String revisionItem(int revision, String status, int lines) {
    return 'Revisión $revision · $status · $lines líneas';
  }

  @override
  String get revisionNotes => 'Notas de la revisión';

  @override
  String revisionPriceLists(String agreed, String current) {
    return 'Precios acordados: tarifa del $agreed. Precios actuales: tarifa del $current.';
  }

  @override
  String get roleInvoicing => 'Facturación';

  @override
  String get roleManagement => 'Dirección';

  @override
  String get roleOther => 'Otro';

  @override
  String get rolePurchasing => 'Compras';

  @override
  String get roleQuality => 'Calidad';

  @override
  String get roleSalesContact => 'Contacto comercial';

  @override
  String get roleTechnical => 'Técnico';

  @override
  String get roles => 'Funciones';

  @override
  String get roundTo => 'Redondear a';

  @override
  String get routeNote => 'Nota para el departamento';

  @override
  String get routeRepair => 'Enviar a departamento';

  @override
  String get salesperson => 'Comercial';

  @override
  String get save => 'Guardar';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get saveDraft => 'Guardar borrador';

  @override
  String get saved => 'Guardado';

  @override
  String savedNumber(String number) {
    return '$number guardado';
  }

  @override
  String get scheduledEnd => 'Fin';

  @override
  String get scheduledStart => 'Inicio';

  @override
  String get scrapPercent => 'Merma %';

  @override
  String get search => 'Buscar';

  @override
  String get send => 'Enviar';

  @override
  String get sendBackToTriage => 'Devolver a triaje';

  @override
  String get sendLoginLink => 'Enviar enlace de acceso';

  @override
  String get serial => 'n.º de serie';

  @override
  String get serialBuiltIn => 'montado';

  @override
  String get serialDelivered => 'entregado';

  @override
  String get serialInStock => 'en stock';

  @override
  String get serialInstalled => 'instalado';

  @override
  String get serialNumber => 'Número de serie';

  @override
  String get serialNumbers => 'Números de serie';

  @override
  String get serialNumbersHelp =>
      'Cada unidad tiene su propio número de serie e historial';

  @override
  String get serialScrapped => 'desechado';

  @override
  String get server => 'Servidor';

  @override
  String get showInactive => 'Mostrar inactivos';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String signedInAs(String name) {
    return 'Conectado como $name';
  }

  @override
  String get signingIn => 'Accediendo…';

  @override
  String get singleProduct => 'Producto concreto';

  @override
  String get siteAddress => 'Dónde ir';

  @override
  String get siteName => 'Nombre del lugar';

  @override
  String skippedWithoutPrice(int count) {
    return '$count combinaciones producto/zona no tienen precio y se omiten';
  }

  @override
  String get stage => 'Fase';

  @override
  String get stageLead => 'prospecto';

  @override
  String get stageLost => 'perdida';

  @override
  String get stageNegotiation => 'negociación';

  @override
  String get stageProposal => 'propuesta';

  @override
  String get stageQualified => 'cualificada';

  @override
  String get stageWon => 'ganada';

  @override
  String get startJob => 'Empezar trabajo';

  @override
  String get startWork => 'Empezar el trabajo';

  @override
  String get status => 'Estado';

  @override
  String get statusAccepted => 'aceptado';

  @override
  String get statusAfterwards => 'Estado después';

  @override
  String get statusDraft => 'borrador';

  @override
  String get statusRejected => 'rechazado';

  @override
  String get statusSent => 'enviado';

  @override
  String get statusSuperseded => 'sustituido';

  @override
  String get street => 'Calle';

  @override
  String get streetAddress => 'Calle y número';

  @override
  String structureRevision(int revision) {
    return 'Estructura (revisión $revision)';
  }

  @override
  String get subassembly => 'subconjunto';

  @override
  String get subject => 'Asunto';

  @override
  String get subjectOptional => 'Asunto (opcional)';

  @override
  String suggested(String value) {
    return 'Sugerencia: $value';
  }

  @override
  String get takePhoto => 'Hacer una foto';

  @override
  String get tasks => 'Tareas';

  @override
  String tasksProgress(String done, String total) {
    return '$done de $total hechas';
  }

  @override
  String get technicians => 'Técnicos';

  @override
  String get text => 'Texto';

  @override
  String get ticketClosed => 'Cerrado';

  @override
  String get ticketDetails => 'Detalles del ticket';

  @override
  String get ticketInProgress => 'En tramitación';

  @override
  String get ticketOpened => 'Ticket creado';

  @override
  String get ticketStatusClosed => 'cerrado';

  @override
  String get ticketStatusNew => 'nuevo';

  @override
  String get ticketStatusOpen => 'abierto';

  @override
  String get ticketStatusPendingCustomer => 'esperando al cliente';

  @override
  String get ticketStatusPendingInternal => 'esperando a un compañero';

  @override
  String get ticketWaitingForYou => 'Esperando su respuesta';

  @override
  String timeTotals(String work, String travel) {
    return 'Trabajo $work · Desplazamiento $travel';
  }

  @override
  String get title => 'Título';

  @override
  String get titleCustomerValueRequired =>
      'El título, el cliente y un valor válido son obligatorios.';

  @override
  String get titleMr => 'Sr.';

  @override
  String get titleMs => 'Sra.';

  @override
  String get titleNone => 'No especificado';

  @override
  String get to => 'Para';

  @override
  String get total => 'Total';

  @override
  String totalChange(String from, String to, String difference) {
    return 'Total sin IVA: $from → $to ($difference)';
  }

  @override
  String get totalExclVat => 'Total sin IVA';

  @override
  String get totalInclVat => 'Total IVA incl.';

  @override
  String get totalsToBuyOrMake => 'Totales a comprar o fabricar';

  @override
  String get tracking => 'Trazabilidad';

  @override
  String get twoLetters => '2 letras';

  @override
  String get type => 'Tipo';

  @override
  String get unassigned => 'Sin asignar';

  @override
  String get unchanged => 'Sin cambios';

  @override
  String get unit => 'Unidad';

  @override
  String get unitPrice => 'Precio unitario';

  @override
  String get unitPriceExclVat => 'Precio unitario (sin IVA)';

  @override
  String get unknownCaller => 'Llamante desconocido';

  @override
  String get until => 'Hasta';

  @override
  String get updateToCurrentPrices => 'Actualizar a precios actuales';

  @override
  String get updated => 'Actualizado';

  @override
  String get uploadingPhotos => 'Subiendo…';

  @override
  String get useAnotherPriceListDate => 'Usar otra fecha de tarifa';

  @override
  String get validFrom => 'Válido desde';

  @override
  String validFromDate(String date) {
    return 'Válido desde $date';
  }

  @override
  String validUntil(String date) {
    return 'válido hasta $date';
  }

  @override
  String get value => 'Valor';

  @override
  String get vat => 'IVA';

  @override
  String get vatNumber => 'NIF-IVA';

  @override
  String vatOn(String rate, String base) {
    return 'IVA $rate % sobre $base';
  }

  @override
  String get vatPercent => 'IVA %';

  @override
  String get viaPortal => 'A través del portal de clientes';

  @override
  String get warranty => 'Garantía';

  @override
  String get warrantyIn => 'En garantía';

  @override
  String get warrantyOut => 'Fuera de garantía';

  @override
  String get warrantyUnknown => 'Desconocida';

  @override
  String weighted(String amount) {
    return 'ponderado $amount';
  }

  @override
  String get whatWasAsked => '¿Qué se ha preguntado?';

  @override
  String get whoIsCalling => '¿Quién llama?';

  @override
  String get won => 'Ganada';

  @override
  String get workFrom => 'Desde';

  @override
  String get workKindTravel => 'Desplazamiento';

  @override
  String get workKindWork => 'Trabajo';

  @override
  String get workLogs => 'Tiempo registrado';

  @override
  String get workUntil => 'Hasta';

  @override
  String writeIn(String language) {
    return 'Escribir en $language';
  }

  @override
  String get yourMessage => 'Su mensaje';

  @override
  String get yourReference => 'Su referencia (RMA o pedido)';

  @override
  String get zone => 'Zona';

  @override
  String zoneAndRebate(String zone, String percent) {
    return 'Zona $zone · descuento general $percent %';
  }

  @override
  String get zonesNoneAll => 'Zonas (sin selección = todas)';
}
