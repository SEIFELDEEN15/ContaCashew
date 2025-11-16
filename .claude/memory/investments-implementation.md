# Investments Feature Implementation

## Overview
The investments feature tracks user investments (stocks, crypto, ETFs, bonds, etc.) with price history and portfolio analytics.

## Database Structure

### Tables
- **Investments**: Main table storing investment records
  - `investmentPk`: Primary key (UUID)
  - `name`: Investment name (e.g., "Apple Inc.")
  - `symbol`: Optional ticker symbol (e.g., "AAPL")
  - `shares`: Number of shares/units owned
  - `purchasePrice`: Price per share at purchase
  - `currentPrice`: Current price per share
  - `purchaseDate`: Date of purchase
  - `walletFk`: Associated wallet (default "0")
  - `categoryFk`: Investment category (ETF, Crypto, Stock, Bond, etc.)
  - `colour`: Optional color for display
  - `iconName`: Optional custom icon
  - `note`: Optional notes
  - `dateCreated`, `dateTimeModified`: Timestamps

- **InvestmentPriceHistories**: Historical price data
  - `investmentFk`: Reference to investment
  - `price`: Price at this point in time
  - `date`: Date of price record
  - `note`: Optional note (e.g., "initial-purchase")

## Key Pages

### 1. AddInvestmentPage (`lib/pages/addInvestmentPage.dart`)
**Purpose**: Create/edit investments

**Key Components**:
- Uses `SelectAmount` widget for numeric inputs (shares, prices)
- Validates all inputs before saving
- Symbol auto-converts to uppercase
- Creates initial price history entry on first save

**Similar to**: Add Transaction Page (uses same widgets and validation patterns)

### 2. InvestmentsListPage (`lib/pages/investmentsListPage.dart`)
**Purpose**: Display all investments with portfolio summary and analytics

**Sections**:
- Portfolio Summary Card: Total value, gain/loss, percentage
- Aggregated Timeline Graph: All investments combined over time
- Pie Chart: Investment breakdown by category
- Investment List: Individual investment entries

**Similar to**: Wallet Details Page (uses same chart components)

### 3. InvestmentPage (`lib/pages/investmentPage.dart`)
**Purpose**: Investment detail view

**Sections**:
- Header: Icon, name, symbol
- Current Value Card: Value, gain/loss percentage
- Portfolio Weight: Percentage of total portfolio
- Price History Chart: Timeline of this specific investment's price
- Holdings Details: Shares, prices, dates, notes

## Key Widgets

### InvestmentEntry (`lib/widgets/investmentEntry.dart`)
**Purpose**: List item for an investment

**Features**:
- CategoryIcon for visual identification
- Name, symbol, shares display
- Current value and gain/loss with color coding
- Tappable to open detail page
- Supports selection (long press)

**Similar to**: TransactionEntry (same structure and styling)

## Database Methods

### Streams
- `watchAllInvestments()`: Stream of all investments
- `getInvestment(pk)`: Stream of single investment
- `watchPriceHistory(investmentPk)`: Stream of price history
- `watchPortfolioSummary()`: Stream of portfolio totals (Map with totalValue, gainLoss, gainLossPercentage)

### Mutations
- `createOrUpdateInvestment(companion, insert)`: Create or update investment
- `deleteInvestment(pk)`: Delete investment and its price history
- `addPriceHistory(companion)`: Add price history entry

## Chart Components Used

### Line Chart (fl_chart)
- **Used for**: Price history timeline
- **Data**: `FlSpot` points from price history
- **Features**:
  - Curved lines
  - Area fill below line
  - Dynamic color (green for gain, red for loss)
  - Grid lines
  - Auto-scaling Y axis

### Pie Chart (fl_chart)
- **Used for**: Category breakdown
- **Data**: Investment categories with total values
- **Features**:
  - Touch interaction
  - Percentage labels
  - Category colors
  - Donut style (circular cutout)

## Integration with Rest of App

### Navigation
- Added to navbar shortcuts (bottomNavBar.dart)
- Added to navigation sidebar (navigationSidebar.dart)
- Navigation indexed stack index: 18
- Icon: `Icons.trending_up`

### Categories
Uses existing TransactionCategory system but with investment-specific categories:
- ETF
- Stock
- Crypto
- Bond
- Real Estate
- Commodities
- etc.

## Color Coding
- **Gain** (positive): incomeAmount color (green)
- **Loss** (negative): expenseAmount color (red)
- Consistent across all views

## Styling Patterns
- Uses `getColor()` for theme-aware colors
- Uses `TextFont` widget for consistent typography
- Uses `getHorizontalPaddingConstrained()` for responsive padding
- Border radius: 15 (Android), 0 (iOS)
- Container color: "lightDarkAccentHeavyLight"

## Validation
All numeric inputs validated via `SelectAmount` widget which:
- Prevents invalid doubles (NaN, infinity)
- Enforces decimal limits per currency
- Provides calculator interface
- Handles copy/paste

## Future Enhancements
- Auto-fetch prices from APIs
- Performance analytics
- Dividend tracking
- Cost basis calculations
- Tax reporting
