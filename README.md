# Consol-PO-Req Extension

## Overview
The standard Purchase requisition worksheet functionality within Business Central did not match our business process requirements. We have modified the standard functionality by creating new codeunits based on the system codeunits as well as extension system objects. This approach requires monitoring and mirroring of future releases of the system code.
The **Consol-PO-Req** (Consolidated Purchase Order from Requisitions) extension for Microsoft Dynamics 365 Business Central enhances the requisition worksheet functionality to create consolidated purchase orders from sales order requirements. This extension is designed to streamline the procurement process by automatically generating purchase orders based on released sales orders.

## Features

### �� Core Functionality
- **Consolidated Purchase Order Creation**: Automatically generate purchase orders from requisition worksheet lines
- **Sales Order Integration**: Pull requirements directly from released sales orders
- **Smart Consolidation**: Group purchase lines by vendor, location, and other criteria
- **Add-to Existing Orders**: Option to add lines to existing open purchase orders

### �� Key Capabilities
- **Get Sales Orders**: Import released sales order lines into the requisition worksheet
- **Create Purchase Orders**: Generate consolidated purchase orders from worksheet lines
- **Back-to-Back Ordering**: Create separate purchase orders for specific line items
- **Sales Order Tracking**: Maintain links between sales orders and purchase requirements
- **Price Management**: Track sales order prices and currencies

## Installation

### Prerequisites
- Microsoft Dynamics 365 Business Central 18.0 or later
- Platform version 1.0.0.0 or later
- Runtime version 13.0

### Installation Steps
1. Download the extension package
2. Install the extension in your Business Central environment
3. Assign the required permissions to users
4. Configure the requisition worksheet templates

## Usage

### Getting Started

1. **Navigate to Requisition Worksheet**
   - Go to **Planning** → **Requisition Worksheet**

2. **Import Sales Orders**
   - Click **Get Sales Orders** action
   - Select the sales orders to import
   - Only released sales orders will be considered

3. **Review and Modify Lines**
   - Review the imported requisition lines
   - Modify quantities, vendors, or other details as needed
   - Use **Add-to Purchase Order No.** to consolidate with existing orders

4. **Create Purchase Orders**
   - Click **Create Purchase Orders** action
   - The system will generate consolidated purchase orders

### Key Fields

| Field | Description |
|-------|-------------|
| **Add-to Purchase Order No.** | Specify an existing open purchase order to add this line to |
| **Sales Order Price** | Net selling price from the original sales order |
| **Sales Order Currency** | Currency of the original sales order |
| **Sales Order No.** | Source sales order number (clickable link) |
| **Sales Order Line No.** | Source sales order line number |

### Actions

#### Get Sales Orders
- Imports released sales order lines into the requisition worksheet
- Only considers items with insufficient inventory
- Maintains sales order pricing and currency information

#### Create Purchase Orders
- Generates consolidated purchase orders from worksheet lines
- Groups lines by vendor, location, and other criteria
- Creates separate orders for back-to-back scenarios

## Technical Details

### Object Structure

#### Codeunits
- **50104 "Req. Wksh.-Make Order2"**: Main logic for creating purchase orders from requisition lines. This is a copy of the system codeunit “Req. Wksh.-Make Order”.
- **50105 "CheckForLinkedB2BPuchOrder"**: Validates back-to-back purchase order links
- **50106 "OpenMatchingB2BOrder"**: Opens related back-to-back orders

#### Reports
- **50102 "Get Sales Orders2"**: Imports sales order lines into requisition worksheet. This is a copy of the system codeunit “Get Sales Orders”.
- **50103 "CarryOutActionMsgPOMod"**: Executes action messages to create purchase orders

#### Page Extensions
- **50100 "ReqWorksheetExt"**: Extends the requisition worksheet with custom fields and actions
- Various other page extensions for sales and purchase documents

#### Table Extensions
- **50100 "ReqLineConsolPOMod"**: Extends requisition lines with consolidation fields
- Extensions for sales lines, purchase lines, and related documents

### Custom Fields

#### Requisition Line Extensions
- `Add-to Purchase Order No.` (Code[20]): Links to existing purchase orders
- `Back-to-back Order` (Boolean): Flag for separate purchase orders
- `Sales Order Price` (Decimal): Original sales order unit price
- `Sales Order Currency` (Code[10]): Original sales order currency

### Permissions

The extension includes a permission set that grants access to:
- Requisition worksheet operations
- Sales order access
- Purchase order creation
- Related document modifications

## Configuration

### Setup Requirements
1. **Requisition Worksheet Templates**: Configure templates for different consolidation scenarios
2. **Vendor Assignment**: Ensure vendors are properly assigned to items
3. **Location Setup**: Configure locations for inventory management
4. **Currency Setup**: Set up currencies for multi-currency environments

### Best Practices
- Regularly review and clean up requisition worksheet lines
- Use consistent vendor assignments for better consolidation
- Monitor the consolidation process for optimal results
- Maintain proper inventory levels to minimize manual interventions

## Troubleshooting

### Common Issues

#### Sales Orders Not Importing
- Ensure sales orders are in "Released" status
- Check that items have insufficient inventory
- Verify user permissions

#### Purchase Orders Not Creating
- Check requisition worksheet line status
- Verify vendor assignments
- Ensure proper action message settings

#### Consolidation Issues
- Review vendor assignments on requisition lines
- Check location codes for consistency
- Verify currency settings

### Error Messages

| Error | Solution |
|-------|----------|
| "Sales order not found" | Verify sales order exists and is accessible |
| "No lines to process" | Check requisition worksheet for valid lines |
| "Vendor not found" | Assign proper vendor to items |

## Version History

### Version 1.0.0.8 (Current)
- Enhanced consolidation logic
- Improved sales order integration
- Bug fixes and performance improvements

### Previous Versions
- Version 1.0.0.7: Initial release with basic consolidation features
- Version 1.0.0.6: Added back-to-back ordering capabilities

## Support

### Documentation
- Refer to this README for basic usage
- Check Business Central documentation for standard features
- Review code comments for technical details

### Contact
For support and questions:
- **Publisher**: DHLab
- **Extension ID**: 65359388-1596-40f5-91c1-38c6a4a134bd

## License

This extension is provided by DHLab. Please refer to the EULA for licensing terms and conditions.

---

**Note**: This extension modifies standard Business Central functionality. Always test in a development environment before deploying to production.
