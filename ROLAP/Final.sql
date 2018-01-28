/****** Object:  Database ist722_group9_dw    Script Date: 4/6/2017 6:16:29 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE ist722_group9_dw
GO
CREATE DATABASE ist722_group9_dw
GO
ALTER DATABASE ist722_group9_dw
SET RECOVERY SIMPLE
GO
*/
USE  ist722_group9_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;


-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
CREATE SCHEMA nopCommerce
GO


/* Drop table nopCommerce.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'nopCommerce.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE nopCommerce.DimCustomer 
;

/* Create table nopCommerce.DimCustomer */
CREATE TABLE nopCommerce.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  int   NOT NULL
,  [CustomerName]  nvarchar(201)  NOT NULL
,  [City]  nvarchar(100)   NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
,  [Gender] nvarchar(200)NULL
,  [Birthyear] int NULL
, CONSTRAINT [PK_nopCommerce.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT nopCommerce.DimCustomer ON
;
INSERT INTO nopCommerce.DimCustomer (CustomerKey, CustomerID, CustomerName, City, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT nopCommerce.DimCustomer OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[nopCommerce].[Customer]'))
DROP VIEW [nopCommerce].[Customer]
GO
CREATE VIEW [nopCommerce].[Customer] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [CustomerID] AS [CustomerID]
, [CustomerName] AS [Name]
, [City] AS [City]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM nopCommerce.DimCustomer
GO


/* Drop table nopCommerce.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'nopCommerce.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE nopCommerce.DimDate 
;


-- date dimension
PRINT 'CREATE TABLE northwind.DimDate'
CREATE TABLE [nopCommerce].[DimDate](
	[DateKey] [int] NOT NULL,
	[Date] [datetime] NULL,
	[FullDateUSA] [nchar](11) NOT NULL,
	[DayOfWeek] [tinyint] NOT NULL,
	[DayName] [nchar](10) NOT NULL,
	[DayOfMonth] [tinyint] NOT NULL,
	[DayOfYear] [int] NOT NULL,
	[WeekOfYear] [tinyint] NOT NULL,
	[MonthName] [nchar](10) NOT NULL,
	[MonthOfYear] [tinyint] NOT NULL,
	[Quarter] [tinyint] NOT NULL,
	[QuarterName] [nchar](10) NOT NULL,
	[Year] [int] NOT NULL,
	[IsAWeekday] varchar(1) NOT NULL DEFAULT (('N')),
	constraint [PK_nopCommerce.DimDate] PRIMARY KEY ([DateKey])
)

-- Unknown Date Value
INSERT INTO [nopCommerce].[DimDate]
           ([DateKey]
           ,[Date]
           ,[FullDateUSA]
           ,[DayOfWeek]
           ,[DayName]
           ,[DayOfMonth]
           ,[DayOfYear]
           ,[WeekOfYear]
           ,[MonthName]
           ,[MonthOfYear]
           ,[Quarter]
           ,[QuarterName]
           ,[Year]
           ,[IsAWeekday])
     VALUES
           (-1
           ,null
           ,'Unknown'
           ,0
           ,'Unknown'
           ,0
           ,0
           ,0
           ,'Unknown'
           ,0
           ,0
           ,'Unknown'
           ,0
           ,'?')
GO


/* Drop table nopCommerce.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'nopCommerce.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE nopCommerce.DimProduct 
;

/* Create table nopCommerce.DimProduct */
CREATE TABLE nopCommerce.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int   NOT NULL
,  [ProductName]  nvarchar(400)   NOT NULL
,  [CategoryName]  nvarchar(400)   NOT NULL
,  [ProductPrice]  decimal(18,4)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_nopCommerce.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT nopCommerce.DimProduct ON
;
INSERT INTO nopCommerce.DimProduct (ProductKey, ProductID, ProductName, CategoryName, ProductPrice, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', 0.0000, 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT nopCommerce.DimProduct OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[nopCommerce].[Product]'))
DROP VIEW [nopCommerce].[Product]
GO
CREATE VIEW [nopCommerce].[Product] AS 
SELECT [ProductKey] AS [ProductKey]
, [ProductID] AS [ProductID]
, [ProductName] AS [ProductName]
, [CategoryName] AS [CategoryName]
, [ProductPrice] AS [ProductPrice]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM nopCommerce.DimProduct
GO


/* Drop table nopCommerce.DimAddress */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'nopCommerce.DimAddress') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE nopCommerce.DimAddress 
;

CREATE TABLE [ nopCommerce.DimProductRatings] (
    [Id] int,
    [CustomerId] int,
    [ProductId] int,
    [StoreId] int,
    [IsApproved] bit,
    [Title] nvarchar(max),
    [ReviewText] nvarchar(max),
    [Rating] int,
    [HelpfulYesTotal] int,
    [HelpfulNoTotal] int,
    [CreatedOnUtc] datetime,
	[IsVerified] int
)
/* Create table nopCommerce.DimAddress */
CREATE TABLE nopCommerce.DimAddress (
   [AddressKey]  int IDENTITY  NOT NULL
,  [AddressId]  int   NOT NULL
,  [CustomerId]  int   NOT NULL
,  [Address]  nvarchar(50)   NOT NULL
,  [StateName]  nvarchar(100)   NOT NULL
,  [ZipPostalCode]  nvarchar(50)   NOT NULL
,  [City]  nvarchar(50)   NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '1/1/2000' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/1999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_nopCommerce.DimAddress] PRIMARY KEY CLUSTERED 
( [AddressKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT nopCommerce.DimAddress ON
;
INSERT INTO nopCommerce.DimAddress (AddressKey, AddressId, CustomerId, Address, StateName, ZipPostalCode, City, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, -1, 'Unknown ', 'Unknown ', 'Unknown ', 'Unknown ', 1, '1/1/2000', '12/31/1999', 'N/A')
;
SET IDENTITY_INSERT nopCommerce.DimAddress OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[nopCommerce].[DimAddress]'))
DROP VIEW [nopCommerce].[Address]
GO
CREATE VIEW [nopCommerce].[Address] AS 
SELECT [AddressKey] AS [AddressKey]
, [AddressId] AS [AddressId]
, [CustomerId] AS [CustomerId]
, [Address] AS [Address]
, [StateName] AS [StateName]
, [ZipPostalCode] AS [ZipPostalCode]
, [City] AS [City]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM nopCommerce.DimAddress
GO



/* Drop table nopCommerce.SalesFact */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'nopCommerce.SalesFact') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE nopCommerce.SalesFact 
;

/* Create table nopCommerce.SalesFact */
CREATE TABLE nopCommerce.SalesFact (

   [CustomerKey]  int   NOT NULL
,  [ProductKey]  int   NOT NULL
,  [AddressKey]  int   NOT NULL
	-- dimensions
,  [OrderItemID]  int   NOT NULL
,  [Quantity]  int   NOT NULL
,  [UnitPriceInclTax] decimal(18,4) NOT NULL
	-- facts
,  [DiscountAmontInclTax]  decimal(18,4) NOT NULL
,  [ExtendedPriceAmount] decimal(18,4) NOT NULL
,  [SoldAmount] decimal(18,4) NOT NULL
   --keys
, CONSTRAINT pkFactSales PRIMARY KEY (OrderItemID, AddressKey)
, CONSTRAINT fkFactSalesProductKey FOREIGN KEY ( ProductKey )
	REFERENCES nopCommerce.DimProduct (ProductKey)
, CONSTRAINT fkFactSalesCustomerKey FOREIGN KEY ( CustomerKey )
	REFERENCES nopCommerce.DimCustomer (CustomerKey)
, CONSTRAINT fkFactSalesAddressKey FOREIGN KEY ( AddressKey )
	REFERENCES nopCommerce.DimAddress (AddressKey)
)
;


-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[nopCommerce].[Sales]'))
DROP VIEW [nopCommerce].[Sales]
GO
CREATE VIEW [nopCommerce].[Sales] AS 
SELECT [ProductKey] AS [ProductKey]
, [AddressKey] AS [BillingAddress]
, [OrderItemID] AS [OrderItemID]
, [DateKey] AS [OrderDate]
, [ProductQuantity] AS [Product Quantity]
, [SoldAmount] AS [Sold Amount]
, [OrderDiscount] AS [Product Discount]
FROM nopCommerce.SalesFact
GO


/* Drop table nopCommerce.ProductRatingFact */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'nopCommerce.ProductRatingFact') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE nopCommerce.ProductRatingFact 
;

/* Create table nopCommerce.ProductRatingFact */
CREATE TABLE nopCommerce.ProductRatingFact (
   [CustomerKey]  int   NOT NULL
,  [ProductKey]  int   NOT NULL
,  [ProductReviewDateKey]  int   NOT NULL
,  [ProductReviewID]  int   NOT NULL
,  [Ratings]  int   NOT NULL
,  [VerifiedCustomer]  int   NOT NULL
, CONSTRAINT [PK_nopCommerce.ProductRatingFact] PRIMARY KEY NONCLUSTERED 
( [CustomerKey], [ProductKey], [ProductReviewDateKey], [ProductReviewID] )
) ON [PRIMARY]
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[nopCommerce].[ProductRating]'))
DROP VIEW [nopCommerce].[ProductRating]
GO
CREATE VIEW [nopCommerce].[ProductRating] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [ProductKey] AS [ProductKey]
, [ProductReviewDateKey] AS [ProductReviewDateKey]
, [ProductReviewID] AS [Product Review ID]
, [Ratings] AS [Ratings]
, [VerifiedCustomer] AS [Verified Customer]
FROM nopCommerce.ProductRatingFact
GO

ALTER TABLE nopCommerce.ProductRatingFact ADD CONSTRAINT
   FK_nopCommerce_ProductRatingFact_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES nopCommerce.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE nopCommerce.ProductRatingFact ADD CONSTRAINT
   FK_nopCommerce_ProductRatingFact_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES nopCommerce.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE nopCommerce.ProductRatingFact ADD CONSTRAINT
   FK_nopCommerce_ProductRatingFact_ProductReviewDateKey FOREIGN KEY
   (
   ProductReviewDateKey
   ) REFERENCES nopCommerce.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;