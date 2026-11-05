# 0008 — Statutory accounting stays in Exact; Peppol via an access point

**Status:** Accepted

**Decision.**
* Exact Online remains the general ledger, VAT returns and annual accounts until the operational
  ERP is proven. The ERP creates invoices and sends them to Exact through its API.
* Belgian B2B e-invoicing (mandatory since 1 January 2026) goes through a certified Peppol access
  point; the ERP stores status and history but does not operate Peppol infrastructure.
* Whether to replace Exact's accounting is a separate, later decision.
