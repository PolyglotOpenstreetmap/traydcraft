-- Development seed data. Loaded by the API when SEED_DEV_DATA=true and no company exists.
-- All names and numbers are fictitious.

INSERT INTO core.companies (id, name, vat_number, street, postal_code, city, country_code, currency, email, phone, iban)
VALUES ('00000000-0000-7000-8000-000000000001', 'Demo Manufacturing BV', 'BE0123456749',
        'Industrieweg 1', '9000', 'Gent', 'BE', 'EUR', 'sales@example.com', '+32 9 000 00 00',
        'BE68 5390 0754 7034');

INSERT INTO core.users (id, email, display_name) VALUES
    ('00000000-0000-7000-8000-000000000101', 'admin@example.com', 'Admin User'),
    ('00000000-0000-7000-8000-000000000102', 'sales@example.com', 'Sales User'),
    ('00000000-0000-7000-8000-000000000103', 'viewer@example.com', 'Viewer User');

INSERT INTO core.user_companies (user_id, company_id, roles, is_default) VALUES
    ('00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000001', '{admin}', true),
    ('00000000-0000-7000-8000-000000000102', '00000000-0000-7000-8000-000000000001', '{sales}', true),
    ('00000000-0000-7000-8000-000000000103', '00000000-0000-7000-8000-000000000001', '{viewer}', true);

INSERT INTO pricing.price_zones (id, company_id, code, name, sort_order) VALUES
    ('00000000-0000-7000-8000-000000000201', '00000000-0000-7000-8000-000000000001', 'Z1', 'Zone 1 – Distributors', 1),
    ('00000000-0000-7000-8000-000000000202', '00000000-0000-7000-8000-000000000001', 'Z2', 'Zone 2 – Installers', 2),
    ('00000000-0000-7000-8000-000000000203', '00000000-0000-7000-8000-000000000001', 'Z3', 'Zone 3 – Industry', 3),
    ('00000000-0000-7000-8000-000000000204', '00000000-0000-7000-8000-000000000001', 'Z4', 'Zone 4 – Export', 4),
    ('00000000-0000-7000-8000-000000000205', '00000000-0000-7000-8000-000000000001', 'Z5', 'Zone 5 – End customers', 5);

INSERT INTO products.products (id, code, name, description, unit, product_type, vat_rate) VALUES
    ('00000000-0000-7000-8000-000000000301', 'UNIT-100', 'Process unit 100', 'Standard process unit', 'pcs', 'manufactured', 21),
    ('00000000-0000-7000-8000-000000000302', 'UNIT-200', 'Process unit 200', 'Configurable process unit', 'pcs', 'configurable', 21),
    ('00000000-0000-7000-8000-000000000303', 'PUMP-05', 'Pump 0.5 kW', 'Purchased pump', 'pcs', 'purchased', 21),
    ('00000000-0000-7000-8000-000000000307', 'FRAME-A', 'Frame assembly', 'Welded frame, made in house', 'pcs', 'manufactured', 21),
    ('00000000-0000-7000-8000-000000000308', 'PROFILE-40', 'Steel profile 40x40', 'Sold and consumed per metre', 'm', 'purchased', 21),
    ('00000000-0000-7000-8000-000000000309', 'BOLT-M8', 'Bolt M8x30', 'Fastener', 'pcs', 'purchased', 21),
    ('00000000-0000-7000-8000-000000000310', 'CTRL-01', 'Controller', 'Purchased control unit', 'pcs', 'purchased', 21),
    ('00000000-0000-7000-8000-000000000304', 'HOSE-25', 'Hose DN25', 'Hose sold per metre', 'm', 'purchased', 21),
    ('00000000-0000-7000-8000-000000000305', 'INSTALL', 'Installation', 'Installation on site, per hour', 'h', 'service', 21),
    ('00000000-0000-7000-8000-000000000306', 'TRAVEL', 'Travel cost', 'Travel cost per km', 'km', 'service', 21);

-- Zone prices from 1 January 2026: zone 1 cheapest, zone 5 list price.
INSERT INTO pricing.zone_prices (id, company_id, zone_id, product_id, unit_price, valid_from)
SELECT gen_random_uuid(), '00000000-0000-7000-8000-000000000001', zf.zone_id, base.product_id,
       round(base.price * zf.factor, 2), DATE '2026-01-01'
FROM (VALUES
        ('00000000-0000-7000-8000-000000000301'::uuid, 4850.00),
        ('00000000-0000-7000-8000-000000000302'::uuid, 7200.00),
        ('00000000-0000-7000-8000-000000000303'::uuid, 640.00),
        ('00000000-0000-7000-8000-000000000304'::uuid, 12.40),
        ('00000000-0000-7000-8000-000000000305'::uuid, 78.00),
        ('00000000-0000-7000-8000-000000000306'::uuid, 0.65),
        ('00000000-0000-7000-8000-000000000307'::uuid, 1450.00),
        ('00000000-0000-7000-8000-000000000308'::uuid, 18.50),
        ('00000000-0000-7000-8000-000000000309'::uuid, 0.35),
        ('00000000-0000-7000-8000-000000000310'::uuid, 890.00)
     ) AS base(product_id, price)
CROSS JOIN (VALUES
        ('00000000-0000-7000-8000-000000000201'::uuid, 0.70),
        ('00000000-0000-7000-8000-000000000202'::uuid, 0.80),
        ('00000000-0000-7000-8000-000000000203'::uuid, 0.90),
        ('00000000-0000-7000-8000-000000000204'::uuid, 0.95),
        ('00000000-0000-7000-8000-000000000205'::uuid, 1.00)
     ) AS zf(zone_id, factor);

INSERT INTO crm.customers (id, code, name, vat_number, email, phone, street, postal_code, city, country_code, language) VALUES
    ('00000000-0000-7000-8000-000000000401', 'C0001', 'Alpha Installaties NV', 'BE0000000097', 'info@alpha.example', '+32 3 000 00 01',
     'Havenlaan 10', '2000', 'Antwerpen', 'BE', 'nl'),
    ('00000000-0000-7000-8000-000000000402', 'C0002', 'Bêta Industrie SA', 'BE0000000196', 'contact@beta.example', '+32 4 000 00 02',
     'Rue de l''Usine 5', '4000', 'Liège', 'BE', 'fr'),
    ('00000000-0000-7000-8000-000000000403', 'C0003', 'Gamma Trading GmbH', 'DE000000000', 'office@gamma.example', '+49 221 000 003',
     'Werkstraße 3', '50667', 'Köln', 'DE', 'en');

INSERT INTO crm.customer_terms (customer_id, company_id, price_zone_id, discount_percent, payment_terms_days) VALUES
    ('00000000-0000-7000-8000-000000000401', '00000000-0000-7000-8000-000000000001', '00000000-0000-7000-8000-000000000202', 5, 30),
    ('00000000-0000-7000-8000-000000000402', '00000000-0000-7000-8000-000000000001', '00000000-0000-7000-8000-000000000203', 0, 60),
    ('00000000-0000-7000-8000-000000000403', '00000000-0000-7000-8000-000000000001', '00000000-0000-7000-8000-000000000204', 2.5, 30);

-- Serial tracking: finished units, pumps and controllers get individual serial numbers.
UPDATE products.products SET tracking = 'serial'
WHERE code IN ('UNIT-100', 'PUMP-05', 'CTRL-01');

-- Active BOMs: UNIT-100 contains the FRAME-A subassembly, which has its own BOM.
INSERT INTO engineering.boms (id, product_id, revision, status, notes, created_by, activated_at) VALUES
    ('00000000-0000-7000-8000-000000000501', '00000000-0000-7000-8000-000000000301', 1, 'active',
     'Initial release', '00000000-0000-7000-8000-000000000101', now()),
    ('00000000-0000-7000-8000-000000000502', '00000000-0000-7000-8000-000000000307', 1, 'active',
     'Initial release', '00000000-0000-7000-8000-000000000101', now());

INSERT INTO engineering.bom_lines (id, bom_id, position, component_product_id, quantity, scrap_percent) VALUES
    (gen_random_uuid(), '00000000-0000-7000-8000-000000000501', 1, '00000000-0000-7000-8000-000000000307', 1, 0),
    (gen_random_uuid(), '00000000-0000-7000-8000-000000000501', 2, '00000000-0000-7000-8000-000000000303', 2, 0),
    (gen_random_uuid(), '00000000-0000-7000-8000-000000000501', 3, '00000000-0000-7000-8000-000000000310', 1, 0),
    (gen_random_uuid(), '00000000-0000-7000-8000-000000000501', 4, '00000000-0000-7000-8000-000000000309', 8, 0),
    (gen_random_uuid(), '00000000-0000-7000-8000-000000000502', 1, '00000000-0000-7000-8000-000000000308', 6.5, 10),
    (gen_random_uuid(), '00000000-0000-7000-8000-000000000502', 2, '00000000-0000-7000-8000-000000000309', 24, 2);

-- One finished unit with its serialised components, and a spare pump in stock.
INSERT INTO engineering.serial_units (id, company_id, product_id, serial_number, status, bom_id, created_by) VALUES
    ('00000000-0000-7000-8000-000000000601', '00000000-0000-7000-8000-000000000001',
     '00000000-0000-7000-8000-000000000301', 'U100-0001', 'in_stock', '00000000-0000-7000-8000-000000000501',
     '00000000-0000-7000-8000-000000000101'),
    ('00000000-0000-7000-8000-000000000602', '00000000-0000-7000-8000-000000000001',
     '00000000-0000-7000-8000-000000000303', 'P-1001', 'built_in', NULL, '00000000-0000-7000-8000-000000000101'),
    ('00000000-0000-7000-8000-000000000603', '00000000-0000-7000-8000-000000000001',
     '00000000-0000-7000-8000-000000000303', 'P-1002', 'built_in', NULL, '00000000-0000-7000-8000-000000000101'),
    ('00000000-0000-7000-8000-000000000604', '00000000-0000-7000-8000-000000000001',
     '00000000-0000-7000-8000-000000000310', 'C-5001', 'built_in', NULL, '00000000-0000-7000-8000-000000000101'),
    ('00000000-0000-7000-8000-000000000605', '00000000-0000-7000-8000-000000000001',
     '00000000-0000-7000-8000-000000000303', 'P-1003', 'in_stock', NULL, '00000000-0000-7000-8000-000000000101');

INSERT INTO engineering.serial_unit_components (id, parent_id, child_id, added_by) VALUES
    (gen_random_uuid(), '00000000-0000-7000-8000-000000000601', '00000000-0000-7000-8000-000000000602', '00000000-0000-7000-8000-000000000101'),
    (gen_random_uuid(), '00000000-0000-7000-8000-000000000601', '00000000-0000-7000-8000-000000000603', '00000000-0000-7000-8000-000000000101'),
    (gen_random_uuid(), '00000000-0000-7000-8000-000000000601', '00000000-0000-7000-8000-000000000604', '00000000-0000-7000-8000-000000000101');

-- Opportunities.
INSERT INTO crm.opportunities (id, company_id, number, title, customer_id, owner_user_id, stage, expected_value,
                               probability, expected_close) VALUES
    ('00000000-0000-7000-8000-000000000701', '00000000-0000-7000-8000-000000000001', 'O2026-00001',
     'Second production line', '00000000-0000-7000-8000-000000000401', '00000000-0000-7000-8000-000000000102',
     'qualified', 42000, 25, DATE '2026-12-15'),
    ('00000000-0000-7000-8000-000000000702', '00000000-0000-7000-8000-000000000001', 'O2026-00002',
     'Pump retrofit', '00000000-0000-7000-8000-000000000402', '00000000-0000-7000-8000-000000000102',
     'lead', 8500, 10, DATE '2027-02-01'),
    ('00000000-0000-7000-8000-000000000703', '00000000-0000-7000-8000-000000000001', 'O2026-00003',
     'Export units', '00000000-0000-7000-8000-000000000403', '00000000-0000-7000-8000-000000000102',
     'negotiation', 65000, 75, DATE '2026-11-30');
INSERT INTO core.number_sequences (company_id, code, year, next_value)
VALUES ('00000000-0000-7000-8000-000000000001', 'opportunity', 2026, 4);

-- A sales manager may change rebates and quote on an earlier price list.
INSERT INTO core.users (id, email, display_name) VALUES
    ('00000000-0000-7000-8000-000000000104', 'manager@example.com', 'Sales Manager');
INSERT INTO core.user_companies (user_id, company_id, roles, is_default) VALUES
    ('00000000-0000-7000-8000-000000000104', '00000000-0000-7000-8000-000000000001', '{sales_manager}', true);

-- Product families and pricing types.
INSERT INTO products.product_families (id, code, name) VALUES
    ('00000000-0000-7000-8000-000000000801', 'UNITS', 'Process units'),
    ('00000000-0000-7000-8000-000000000802', 'PUMPS', 'Pumps'),
    ('00000000-0000-7000-8000-000000000803', 'MATERIALS', 'Materials and fasteners'),
    ('00000000-0000-7000-8000-000000000804', 'ELECTRONICS', 'Controls and electronics'),
    ('00000000-0000-7000-8000-000000000805', 'ASSEMBLIES', 'Subassemblies'),
    ('00000000-0000-7000-8000-000000000806', 'SERVICES', 'Services');
UPDATE products.products SET family_id = '00000000-0000-7000-8000-000000000801' WHERE code IN ('UNIT-100', 'UNIT-200');
UPDATE products.products SET family_id = '00000000-0000-7000-8000-000000000802' WHERE code = 'PUMP-05';
UPDATE products.products SET family_id = '00000000-0000-7000-8000-000000000803' WHERE code IN ('HOSE-25', 'PROFILE-40', 'BOLT-M8');
UPDATE products.products SET family_id = '00000000-0000-7000-8000-000000000804' WHERE code = 'CTRL-01';
UPDATE products.products SET family_id = '00000000-0000-7000-8000-000000000805' WHERE code = 'FRAME-A';
UPDATE products.products SET family_id = '00000000-0000-7000-8000-000000000806' WHERE code IN ('INSTALL', 'TRAVEL');
-- Services have a fixed net price; the configurable unit only has an indicative list price.
UPDATE products.products SET pricing_type = 'net' WHERE code IN ('INSTALL', 'TRAVEL');
UPDATE products.products SET pricing_type = 'indicative' WHERE code = 'UNIT-200';

-- Alpha: 5 % general rebate (in its terms), 12 % on pumps, 15 % on the controller.
INSERT INTO crm.customer_rebates (id, company_id, customer_id, scope, product_id, family_id, percent, created_by) VALUES
    ('00000000-0000-7000-8000-000000000901', '00000000-0000-7000-8000-000000000001',
     '00000000-0000-7000-8000-000000000401', 'family', NULL, '00000000-0000-7000-8000-000000000802', 12,
     '00000000-0000-7000-8000-000000000101'),
    ('00000000-0000-7000-8000-000000000902', '00000000-0000-7000-8000-000000000001',
     '00000000-0000-7000-8000-000000000401', 'product', '00000000-0000-7000-8000-000000000310', NULL, 15,
     '00000000-0000-7000-8000-000000000101');

-- The previous price list (2025): 4 % below the 2026 prices.
INSERT INTO pricing.zone_prices (id, company_id, zone_id, product_id, unit_price, valid_from)
SELECT gen_random_uuid(), company_id, zone_id, product_id, round(unit_price * 0.96, 2), DATE '2025-01-01'
FROM pricing.zone_prices WHERE valid_from = DATE '2026-01-01';

-- Helpdesk users: first-line support and production (production asks questions via internal notes).
INSERT INTO core.users (id, email, display_name) VALUES
    ('00000000-0000-7000-8000-000000000105', 'support@example.com', 'Support Agent'),
    ('00000000-0000-7000-8000-000000000106', 'production@example.com', 'Production Planner');
INSERT INTO core.user_companies (user_id, company_id, roles, is_default) VALUES
    ('00000000-0000-7000-8000-000000000105', '00000000-0000-7000-8000-000000000001', '{support}', true),
    ('00000000-0000-7000-8000-000000000106', '00000000-0000-7000-8000-000000000001', '{production}', true);

-- Prepared answers in the five languages.
INSERT INTO helpdesk.prepared_answers (id, company_id, code, name, category) VALUES
    ('00000000-0000-7000-8000-000000000a01', '00000000-0000-7000-8000-000000000001', 'order-confirmed', 'Order confirmation', 'Orders'),
    ('00000000-0000-7000-8000-000000000a02', '00000000-0000-7000-8000-000000000001', 'quote-sent', 'Quotation sent', 'Quotations'),
    ('00000000-0000-7000-8000-000000000a03', '00000000-0000-7000-8000-000000000001', 'production-question', 'Question from production', 'Orders'),
    ('00000000-0000-7000-8000-000000000a04', '00000000-0000-7000-8000-000000000001', 'delivery-time', 'Delivery time', 'General');

INSERT INTO helpdesk.prepared_answer_texts (answer_id, language, subject, body) VALUES
-- order-confirmed
('00000000-0000-7000-8000-000000000a01', 'nl', 'Orderbevestiging {{order.number}}',
'Beste {{contact.name}},

Hartelijk dank voor uw bestelling. Wij bevestigen order {{order.number}} (uw referentie: {{order.reference}}) op basis van offerte {{quotation.number}} revisie {{quotation.revision}}, voor een totaalbedrag van {{quotation.total}} incl. btw.

U ontvangt de leverdatum zodra de productie gepland is.

Met vriendelijke groeten,
{{agent.name}}
{{company.name}}'),
('00000000-0000-7000-8000-000000000a01', 'fr', 'Confirmation de commande {{order.number}}',
'Bonjour {{contact.name}},

Nous vous remercions pour votre commande. Nous confirmons la commande {{order.number}} (votre référence : {{order.reference}}) sur la base de l''offre {{quotation.number}} révision {{quotation.revision}}, pour un montant total de {{quotation.total}} TVAC.

Nous vous communiquerons la date de livraison dès que la production sera planifiée.

Cordialement,
{{agent.name}}
{{company.name}}'),
('00000000-0000-7000-8000-000000000a01', 'en', 'Order confirmation {{order.number}}',
'Dear {{contact.name}},

Thank you for your order. We confirm order {{order.number}} (your reference: {{order.reference}}) based on quotation {{quotation.number}} revision {{quotation.revision}}, for a total of {{quotation.total}} incl. VAT.

We will let you know the delivery date as soon as production is scheduled.

Kind regards,
{{agent.name}}
{{company.name}}'),
('00000000-0000-7000-8000-000000000a01', 'de', 'Auftragsbestätigung {{order.number}}',
'Sehr geehrte(r) {{contact.name}},

vielen Dank für Ihren Auftrag. Wir bestätigen den Auftrag {{order.number}} (Ihre Referenz: {{order.reference}}) auf Grundlage des Angebots {{quotation.number}} Revision {{quotation.revision}} über insgesamt {{quotation.total}} inkl. MwSt.

Den Liefertermin teilen wir Ihnen mit, sobald die Produktion eingeplant ist.

Mit freundlichen Grüßen
{{agent.name}}
{{company.name}}'),
('00000000-0000-7000-8000-000000000a01', 'es', 'Confirmación de pedido {{order.number}}',
'Estimado/a {{contact.name}}:

Muchas gracias por su pedido. Confirmamos el pedido {{order.number}} (su referencia: {{order.reference}}) según el presupuesto {{quotation.number}} revisión {{quotation.revision}}, por un total de {{quotation.total}} IVA incluido.

Le comunicaremos la fecha de entrega en cuanto la producción esté planificada.

Atentamente,
{{agent.name}}
{{company.name}}'),
-- quote-sent
('00000000-0000-7000-8000-000000000a02', 'nl', 'Offerte {{quotation.number}}',
'Beste {{contact.name}},

In bijlage vindt u onze offerte {{quotation.number}}. Wij horen graag of deze aan uw verwachtingen voldoet. Voor vragen of aanpassingen kunt u eenvoudig op deze e-mail antwoorden.

Met vriendelijke groeten,
{{agent.name}}
{{company.name}}'),
('00000000-0000-7000-8000-000000000a02', 'fr', 'Offre {{quotation.number}}',
'Bonjour {{contact.name}},

Veuillez trouver ci-joint notre offre {{quotation.number}}. N''hésitez pas à répondre à cet e-mail pour toute question ou modification.

Cordialement,
{{agent.name}}
{{company.name}}'),
('00000000-0000-7000-8000-000000000a02', 'en', 'Quotation {{quotation.number}}',
'Dear {{contact.name}},

Please find our quotation {{quotation.number}} attached. If you have any questions or would like changes, simply reply to this e-mail.

Kind regards,
{{agent.name}}
{{company.name}}'),
('00000000-0000-7000-8000-000000000a02', 'de', 'Angebot {{quotation.number}}',
'Sehr geehrte(r) {{contact.name}},

anbei erhalten Sie unser Angebot {{quotation.number}}. Bei Fragen oder Änderungswünschen antworten Sie einfach auf diese E-Mail.

Mit freundlichen Grüßen
{{agent.name}}
{{company.name}}'),
('00000000-0000-7000-8000-000000000a02', 'es', 'Presupuesto {{quotation.number}}',
'Estimado/a {{contact.name}}:

Adjuntamos nuestro presupuesto {{quotation.number}}. Si tiene alguna pregunta o desea algún cambio, basta con responder a este correo.

Atentamente,
{{agent.name}}
{{company.name}}'),
-- production-question
('00000000-0000-7000-8000-000000000a03', 'nl', 'Vraag over uw order {{order.number}}',
'Beste {{contact.name}},

Bij de voorbereiding van de productie van uw order {{order.number}} hebben wij nog een vraag:

[vraag]

Alvast bedankt voor uw antwoord, zodat wij de productie zonder vertraging kunnen voortzetten.

Met vriendelijke groeten,
{{agent.name}}
{{company.name}}'),
('00000000-0000-7000-8000-000000000a03', 'fr', 'Question concernant votre commande {{order.number}}',
'Bonjour {{contact.name}},

En préparant la production de votre commande {{order.number}}, nous avons encore une question :

[question]

Merci d''avance pour votre réponse, afin que nous puissions poursuivre la production sans retard.

Cordialement,
{{agent.name}}
{{company.name}}'),
('00000000-0000-7000-8000-000000000a03', 'en', 'Question about your order {{order.number}}',
'Dear {{contact.name}},

While preparing production of your order {{order.number}}, we have one more question:

[question]

Thank you in advance for your answer, so that we can continue production without delay.

Kind regards,
{{agent.name}}
{{company.name}}'),
('00000000-0000-7000-8000-000000000a03', 'de', 'Rückfrage zu Ihrem Auftrag {{order.number}}',
'Sehr geehrte(r) {{contact.name}},

bei der Vorbereitung der Fertigung Ihres Auftrags {{order.number}} haben wir noch eine Frage:

[Frage]

Vielen Dank im Voraus für Ihre Antwort, damit wir die Fertigung ohne Verzögerung fortsetzen können.

Mit freundlichen Grüßen
{{agent.name}}
{{company.name}}'),
('00000000-0000-7000-8000-000000000a03', 'es', 'Consulta sobre su pedido {{order.number}}',
'Estimado/a {{contact.name}}:

Al preparar la fabricación de su pedido {{order.number}}, nos ha surgido una pregunta:

[pregunta]

Le agradecemos de antemano su respuesta, para poder continuar la fabricación sin retrasos.

Atentamente,
{{agent.name}}
{{company.name}}'),
-- delivery-time
('00000000-0000-7000-8000-000000000a04', 'nl', '',
'Beste {{contact.name}},

Onze standaard levertermijn bedraagt 6 tot 8 weken na orderbevestiging. Voor dringende leveringen bekijken wij graag de mogelijkheden.

Met vriendelijke groeten,
{{agent.name}}'),
('00000000-0000-7000-8000-000000000a04', 'fr', '',
'Bonjour {{contact.name}},

Notre délai de livraison standard est de 6 à 8 semaines après confirmation de commande. Pour les livraisons urgentes, nous examinons volontiers les possibilités.

Cordialement,
{{agent.name}}'),
('00000000-0000-7000-8000-000000000a04', 'en', '',
'Dear {{contact.name}},

Our standard delivery time is 6 to 8 weeks after order confirmation. For urgent deliveries we are happy to look at the options.

Kind regards,
{{agent.name}}'),
('00000000-0000-7000-8000-000000000a04', 'de', '',
'Sehr geehrte(r) {{contact.name}},

unsere Standardlieferzeit beträgt 6 bis 8 Wochen nach Auftragsbestätigung. Für eilige Lieferungen prüfen wir gerne die Möglichkeiten.

Mit freundlichen Grüßen
{{agent.name}}'),
('00000000-0000-7000-8000-000000000a04', 'es', '',
'Estimado/a {{contact.name}}:

Nuestro plazo de entrega estándar es de 6 a 8 semanas tras la confirmación del pedido. Para entregas urgentes, estudiaremos las posibilidades con gusto.

Atentamente,
{{agent.name}}');

-- A German customer for the demo (Gamma is in Germany).
UPDATE crm.customers SET language = 'de' WHERE code = 'C0003';
