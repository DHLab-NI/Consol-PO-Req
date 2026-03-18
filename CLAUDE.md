# Consol-PO-Req — Extension Context

## Purpose
Extends the BC requisition worksheet to support two procurement workflows: (1) **back-to-back (B2B) ordering** — linking sales order lines to corresponding purchase order lines so changes on one side flag the other; and (2) **consolidated PO creation** — allowing requisition lines to be added to an existing open purchase order rather than always creating a new one. Also includes a custom inventory replenishment report.

---

## Object IDs Used
| ID | Type | Name |
|----|------|------|
| 50100 | Table Extension | Requisition Line |
| 50101 | Table Extension | Purch. Inv. Line |
| 50102 | Table Extension | Purch. Rcpt. Line |
| 50103 | Table Extension | Purchase Line |
| 50104 | Table Extension | Sales Line |
| 50105 | Table Extension | Sales Shipment Line |
| 50106 | Table Extension | Sales Invoice Line |
| 50107 | Table Extension | Sales Line Archive |
| 50108 | Table Extension | Purchase Line Archive |
| 50101 | Page | Item Requisition FactBox |
| 50102 | Page | Related Sales Order FactBox |
| 50100 | Page Extension | Req. Worksheet (page 291) |
| 50101 | Page Extension | Posted Purchase Receipt Lines (page 528) |
| 50102 | Page Extension | Purchase Order Subform (page 54) |
| 50103 | Page Extension | Sales Order Subform (page 46) |
| 50104 | Page Extension | Posted Sales Shipment Lines (page 525) |
| 50105 | Page Extension | Posted Purchase Rcpt. Subform (page 137) |
| 50106 | Page Extension | Sales Order Archive Subform (page 5160) |
| 50107 | Page Extension | Purchase Order Archive Subform (page 5168) |
| 50108 | Page Extension | Posted Sales Shpt. Subform (page 131) |
| 50109 | Page Extension | Sales Lines (page 516) |
| 50110 | Page Extension | Purchase Lines (page 518) |
| 50101 | Report | Carry Out Action Msg. - Req.2 |
| 50102 | Report | Get Sales Orders2 |
| 50103 | Report | Replenish Inventory |
| 50104 | Codeunit | Req. Wksh.-Make Order2 |
| 50105 | Codeunit | CheckForLinkedB2BPurchOrder |
| 50106 | Codeunit | B2BOrderMatching |
| 50100 | Permission Set | Purchase Order Req |

---

## Key Objects

### Table Extensions
- **Table Extension 50100 — Requisition Line**: Adds `Add-to Purchase Order No.` (filtered to open POs for the same vendor), `Sales Order Price`, `Sales Order Currency`, and the deprecated `Back-to-back Order` boolean. Also adds a custom SQL key sorted by `Action Message` to allow the make-order codeunit to process "add to existing PO" lines separately from "new PO" lines.
- **Table Extension 50103 — Purchase Line**: Adds `B2B Sales Order No.`, `B2B Sales Order Line No.`, `B2B Modified` (flag set when linked SO is changed), and `B2B Modified Description`. `OnDelete` clears the corresponding B2B fields on the linked Sales Line.
- **Table Extension 50104 — Sales Line**: Adds `B2B Purch. Order No.` and `B2B Purch. Order Line No.`. `OnBeforeValidate` of Quantity flags the linked Purchase Line as modified (sets `B2B Modified` = true and writes a description). `OnDelete` unlinks the corresponding Purchase Line.
- **Table Extension 50102 — Purch. Rcpt. Line**: Adds B2B SO link fields plus several FlowFields: `O/S Qty. on SO`, `Inventory`, `Sell-to Customer No.`, `Shelf No.`, `B2B Modified`, and `B2B Modified Description`.

### Reports
- **Report 50101 "Carry Out Action Msg. - Req.2"**: Modified copy of system report 493. Calls `Req. Wksh.-Make Order2` (codeunit 50104) instead of the standard make-order codeunit.
- **Report 50102 "Get Sales Orders2"**: Modified copy of system report 698. Only processes **Released** sales orders. Skips lines where available stock (Inventory + PO qty − SO qty) already covers demand. Intentionally does **not** copy dimensions from sales lines to requisition lines. Populates `Sales Order Price` and `Sales Order Currency` on the req line.
- **Report 50103 "Replenish Inventory"**: Custom report. Loops over inventory items with a Maximum Inventory > 0 and adds req worksheet lines for items where available stock (Inventory + PO qty − SO qty) is at or below the Reorder Point. Quantity = Maximum Inventory − available stock. Requires a Location Code.

### Codeunits
- **Codeunit 50104 "Req. Wksh.-Make Order2"**: Modified copy of system codeunit 333. Core logic for creating POs from the req worksheet. Uses the `Action Message` field on the req line to distinguish between "add to existing PO" (Action Message = " ", `Add-to Purchase Order No.` set) and "new PO" (Action Message = New). Writes B2B link fields onto the created Purchase Line and the source Sales Line.
- **Codeunit 50105 "CheckForLinkedB2BPurchOrder"**: All logic is commented out. Originally prevented quantity changes and deletion of B2B-linked sales lines. The approach was replaced by the notification/flag mechanism on the Purchase Line (`B2B Modified` / `B2B Modified Description`).
- **Codeunit 50106 "B2BOrderMatching"**: Helper to open the matching B2B Sales or Purchase order (falls back to the archive if the live order is not found).

### Pages
- **Page 50101 "Item Requisition FactBox"**: Replaces the standard Item Replenishment FactBox on the Req. Worksheet. Shows vendor details, last purchase price/currency/date/invoice number, and availability figures (Inventory, Qty on SO, Qty on PO, Reorder Point, Maximum Inventory).
- **Page 50102 "Related Sales Order FactBox"**: Card part surfaced on the Posted Purchase Receipt Lines page. Shows the linked B2B Sales Order header and line details including quantities, requested delivery date, shipping advice, and shelf/bin location.

### Page Extensions
- **Page Extension 50100 — Req. Worksheet**: Adds three actions to a DHLab group — *Get Sales Orders* (runs report 50102), *Create Purchase Orders* (runs report 50101 via codeunit 50104), and *Replenish Inventory* (runs report 50103). Adds columns for inventory, PO qty outstanding, Add-to PO No., Sales Order Price, Sales Order Currency, SO No./Line No. Replaces the standard replenishment factbox with the custom one.
- **Page Extension 50102 — Purchase Order Subform**: Adds B2B Sales Order fields and a *Link B2B Sales Order* action that allows manually linking a purchase line to a sales line (and updating the reverse link).

---

## Dependencies
- Base Application
- **Documents** extension depends on Consol-PO-Req — changes to B2B fields on Sales Line or Purchase Line may affect Documents layouts

---

## Integration Points
No REST API or external service endpoints. The B2B fields on Sales Line and Purchase Line are consumed by the **FisherEDI** extension (fields are marked `Editable = True` with `// Fisher EDI Mod` comments) — treat fields 50104 and 50105 on Sales Line and Purchase Line as a semi-public interface.

---

## Known Gotchas
- **`Add-to Purchase Order No.` sets Action Message to " " (space)**, not `New`. The custom make-order codeunit uses this to route lines to an existing PO. Do not change this logic without updating `ReqWkshMakeOrderPOMod.codeunit.al`.
- **Field 50101 `Back-to-back Order` on Requisition Line is deprecated** (commented note: "not working properly") but cannot be removed — AL does not allow field deletion from table extensions once published. Do not add logic that depends on this field.
- **Dimensions were intentionally not copied (but now reinstated)** from Sales Lines to Req Worksheet lines. The corresponding code block was commented out in `GetSalesOrdersReleasedMod.report.al`. This has now been temporarily reinstated and must be momitored for downstraem impact on PO posting. Note: For Dimensions to be copied, the option "Retrieve dimensions from" must be set to "Sales Line" when running "Get Sales Orders".
- **`CheckForLinkedB2BPurchOrder` (codeunit 50105) contains only commented-out code.** The original approach of blocking qty changes/deletion on B2B-linked SO lines was replaced by the `B2B Modified` flag mechanism on the Purchase Line. Do not delete the codeunit shell (the permission set references it indirectly via naming).
- **`Get Sales Orders2` deduplicates** — if a req line for the same item/SO/SO line already exists in the worksheet it is skipped. This prevents duplicate lines if the report is run multiple times.
- **Available quantity formula** (used in both `Get Sales Orders2` and `Replenish Inventory`): `Inventory + Qty on Purch. Order − Qty on Sales Order`. This is calculated at the sales line's location. Ensure item flow-fields are CalcFields'd before comparing.

---

## What NOT to Do
- Do not rename or remove fields 50104/50105 on Sales Line or Purchase Line — FisherEDI reads these fields
- Do not modify the `Action Message` toggle logic in `ReqLineConsolPO.tableext.al` without also updating `ReqWkshMakeOrderPOMod.codeunit.al`
- Do not add new fields to the Sales Line or Purchase Line table extensions using IDs 50106–50111 without checking for conflicts with the Purch. Rcpt. Line extension which already uses 50106–50113
