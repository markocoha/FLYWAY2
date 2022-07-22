SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Creating [dbo].[DM_EMPLOYEE]'
GO
CREATE TABLE [dbo].[DM_EMPLOYEE]
(
[person_id] [int] NOT NULL,
[assignment_id] [int] NOT NULL,
[emp_id] [varchar] (50) NULL,
[first_name] [varchar] (40) NULL,
[last_name] [varchar] (40) NULL,
[full_name] [varchar] (40) NULL,
[birth_date] [datetime] NULL,
[gender] [varchar] (1) NULL,
[title] [varchar] (10) NULL,
[emp_data] [varchar] (100) NULL
)
GO
PRINT N'Creating index [empInd1] on [dbo].[DM_EMPLOYEE]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [empInd1] ON [dbo].[DM_EMPLOYEE] ([person_id], [emp_id])
GO
PRINT N'Creating [dbo].[DM_EMP_AUDIT]'
GO
CREATE TABLE [dbo].[DM_EMP_AUDIT]
(
[identCol] [int] NOT NULL IDENTITY(1, 1),
[person_id] [int] NOT NULL,
[assignment_id] [int] NOT NULL,
[emp_id] [varchar] (10) NULL,
[first_name] [varchar] (40) NULL,
[last_name] [varchar] (40) NULL,
[full_name] [varchar] (40) NULL
)
GO
PRINT N'Creating primary key [PK__DM_EMP_A__2DE3C94A81C39737] on [dbo].[DM_EMP_AUDIT]'
GO
ALTER TABLE [dbo].[DM_EMP_AUDIT] ADD CONSTRAINT [PK__DM_EMP_A__2DE3C94A81C39737] PRIMARY KEY CLUSTERED ([identCol])
GO
PRINT N'Creating trigger [dbo].[EMP_trig1] on [dbo].[DM_EMPLOYEE]'
GO

create trigger [dbo].[EMP_trig1]
on [dbo].[DM_EMPLOYEE] after update
AS
BEGIN
  DECLARE @person_id integer
  DECLARE @assignment_id integer
  DECLARE @emp_id varchar(10)
  DECLARE @first_name varchar(40)
  DECLARE @last_name varchar(40)
  DECLARE @full_name varchar(40)
  Select @person_id=person_id, @assignment_id=assignment_id, @emp_id=emp_id, @first_name=first_name, @last_name=last_name, @full_name=full_name from DM_EMPLOYEE;
  insert into DM_EMP_AUDIT (person_id,assignment_id, emp_id,first_name,last_name,full_name) 
     values (@person_id,@assignment_id, @emp_id,@first_name,@last_name,@full_name);
END
GO
DISABLE TRIGGER [dbo].[EMP_trig1] ON [dbo].[DM_EMPLOYEE]
GO
PRINT N'Creating [dbo].[DM_INVOICE_LINE]'
GO
CREATE TABLE [dbo].[DM_INVOICE_LINE]
(
[invoice_number] [varchar] (10) NOT NULL,
[inventory_item_id] [varchar] (10) NOT NULL,
[invoice_line_quantity] [int] NULL,
[invoice_line_sale_price] [decimal] (10, 2) NULL
)
GO
PRINT N'Creating primary key [PK__DM_INVOI__D69CED10DB7ACE48] on [dbo].[DM_INVOICE_LINE]'
GO
ALTER TABLE [dbo].[DM_INVOICE_LINE] ADD CONSTRAINT [PK__DM_INVOI__D69CED10DB7ACE48] PRIMARY KEY CLUSTERED ([invoice_number], [inventory_item_id])
GO
PRINT N'Creating [dbo].[DM_INVOICE_LINE_HISTORY]'
GO
CREATE TABLE [dbo].[DM_INVOICE_LINE_HISTORY]
(
[identCol] [int] NOT NULL IDENTITY(1, 1),
[invoice_number] [varchar] (6) NOT NULL,
[item_id] [varchar] (6) NOT NULL,
[quantity] [int] NULL
)
GO
PRINT N'Creating primary key [PK__DM_INVOI__2DE3C94ADBE5D564] on [dbo].[DM_INVOICE_LINE_HISTORY]'
GO
ALTER TABLE [dbo].[DM_INVOICE_LINE_HISTORY] ADD CONSTRAINT [PK__DM_INVOI__2DE3C94ADBE5D564] PRIMARY KEY CLUSTERED ([identCol])
GO
PRINT N'Creating trigger [dbo].[IL_trig1] on [dbo].[DM_INVOICE_LINE]'
GO
create trigger [dbo].[IL_trig1]
on [dbo].[DM_INVOICE_LINE] after insert, update
AS
BEGIN
  DECLARE @invNum integer
  DECLARE @itemID integer
  DECLARE @itemQty integer
  Select @invNum=invoice_number, @itemID=inventory_item_id, @itemQty=invoice_line_quantity from DM_INVOICE_LINE;
  insert into DM_INVOICE_LINE_HISTORY (invoice_number,item_id,quantity) 
     values (@invNum,@itemID,@itemQty);
END
GO
DISABLE TRIGGER [dbo].[IL_trig1] ON [dbo].[DM_INVOICE_LINE]
GO
PRINT N'Creating [dbo].[DM_CUSTOMER]'
GO
CREATE TABLE [dbo].[DM_CUSTOMER]
(
[customer_id] [varchar] (10) NOT NULL,
[customer_firstname] [varchar] (60) NULL,
[customer_lastname] [varchar] (60) NULL,
[customer_gender] [varchar] (1) NULL,
[customer_company_name] [varchar] (60) NULL,
[customer_street_address] [varchar] (60) NULL,
[customer_region] [varchar] (60) NULL,
[customer_country] [varchar] (60) NULL,
[customer_email] [varchar] (60) NULL,
[customer_telephone] [varchar] (60) NULL,
[customer_zipcode] [varchar] (60) NULL,
[credit_card_type_id] [varchar] (2) NULL,
[customer_credit_card_number] [varchar] (60) NULL
)
GO
PRINT N'Creating primary key [PK__DM_CUSTO__CD65CB85E63B8F04] on [dbo].[DM_CUSTOMER]'
GO
ALTER TABLE [dbo].[DM_CUSTOMER] ADD CONSTRAINT [PK__DM_CUSTO__CD65CB85E63B8F04] PRIMARY KEY CLUSTERED ([customer_id])
GO
PRINT N'Creating [dbo].[DM_CUSTOMER_NOTES]'
GO
CREATE TABLE [dbo].[DM_CUSTOMER_NOTES]
(
[customer_id] [varchar] (10) NOT NULL,
[customer_firstname] [varchar] (60) NULL,
[customer_lastname] [varchar] (60) NULL,
[customer_notes_entry_date] [datetime] NOT NULL,
[customer_note] [varchar] (2000) NULL
)
GO
PRINT N'Creating index [cnInd1] on [dbo].[DM_CUSTOMER_NOTES]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [cnInd1] ON [dbo].[DM_CUSTOMER_NOTES] ([customer_id], [customer_notes_entry_date])
GO
PRINT N'Creating [dbo].[DM_CREDIT_CARD_TYPE]'
GO
CREATE TABLE [dbo].[DM_CREDIT_CARD_TYPE]
(
[credit_card_type_id] [varchar] (2) NOT NULL,
[credit_card_type_name] [varchar] (60) NULL
)
GO
PRINT N'Creating primary key [PK__DM_CREDI__F7653008B5A28155] on [dbo].[DM_CREDIT_CARD_TYPE]'
GO
ALTER TABLE [dbo].[DM_CREDIT_CARD_TYPE] ADD CONSTRAINT [PK__DM_CREDI__F7653008B5A28155] PRIMARY KEY CLUSTERED ([credit_card_type_id])
GO
PRINT N'Creating [dbo].[DM_INVOICE]'
GO
CREATE TABLE [dbo].[DM_INVOICE]
(
[invoice_number] [varchar] (10) NOT NULL,
[invoice_date] [datetime] NULL,
[invoice_customer_id] [varchar] (60) NULL
)
GO
PRINT N'Creating primary key [PK__DM_INVOI__8081A63B539C2392] on [dbo].[DM_INVOICE]'
GO
ALTER TABLE [dbo].[DM_INVOICE] ADD CONSTRAINT [PK__DM_INVOI__8081A63B539C2392] PRIMARY KEY CLUSTERED ([invoice_number])
GO
PRINT N'Creating [dbo].[DM_INVENTORY_ITEM]'
GO
CREATE TABLE [dbo].[DM_INVENTORY_ITEM]
(
[inventory_item_id] [varchar] (10) NOT NULL,
[inventory_item_name] [varchar] (60) NULL
)
GO
PRINT N'Creating primary key [PK__DM_INVEN__61D4B2B4D91AF460] on [dbo].[DM_INVENTORY_ITEM]'
GO
ALTER TABLE [dbo].[DM_INVENTORY_ITEM] ADD CONSTRAINT [PK__DM_INVEN__61D4B2B4D91AF460] PRIMARY KEY CLUSTERED ([inventory_item_id])
GO
PRINT N'Creating [dbo].[DMSSTAT_RSTATS]'
GO
CREATE TABLE [dbo].[DMSSTAT_RSTATS]
(
[runid] [varchar] (250) NOT NULL,
[ruleid] [varchar] (50) NOT NULL,
[ruleblock] [int] NOT NULL,
[rulenum] [int] NOT NULL,
[rulesubscript] [int] NOT NULL,
[ruletype] [varchar] (50) NOT NULL,
[rulecreated] [datetime] NOT NULL,
[ruleupdated] [datetime] NOT NULL,
[secondsactive] [int] NOT NULL,
[rulestatus] [char] (1) NOT NULL,
[rulesource] [varchar] (250) NULL,
[ruletarget] [varchar] (250) NULL,
[rowoperations] [bigint] NULL,
[coloperations] [bigint] NULL,
[rulePrevRPN] [int] NULL,
[ruleRPN] [int] NULL
)
GO
PRINT N'Creating index [IX_DMSSTAT_RSTATS] on [dbo].[DMSSTAT_RSTATS]'
GO
CREATE NONCLUSTERED INDEX [IX_DMSSTAT_RSTATS] ON [dbo].[DMSSTAT_RSTATS] ([runid], [ruleid])
GO
PRINT N'Creating [dbo].[DMSSTAT_TSTATS]'
GO
CREATE TABLE [dbo].[DMSSTAT_TSTATS]
(
[runid] [varchar] (250) NOT NULL,
[ruleid] [varchar] (50) NOT NULL,
[statscreated] [datetime] NOT NULL,
[statsupdated] [datetime] NOT NULL,
[ruletype] [varchar] (50) NOT NULL,
[ruleblock] [int] NOT NULL,
[rulenum] [int] NOT NULL,
[rulesubscript] [int] NOT NULL,
[controllerid] [varchar] (50) NULL,
[tabledatabase] [varchar] (250) NOT NULL,
[tableschema] [varchar] (250) NOT NULL,
[tablename] [varchar] (250) NOT NULL,
[tablecolumn] [varchar] (250) NULL,
[rowoperations] [bigint] NULL,
[coloperations] [bigint] NULL
)
GO
PRINT N'Creating index [IX_DMSSTAT_TSTATS_A] on [dbo].[DMSSTAT_TSTATS]'
GO
CREATE NONCLUSTERED INDEX [IX_DMSSTAT_TSTATS_A] ON [dbo].[DMSSTAT_TSTATS] ([runid], [ruleid])
GO
PRINT N'Creating [dbo].[DMS_AUDITTAB]'
GO
CREATE TABLE [dbo].[DMS_AUDITTAB]
(
[runid] [varchar] (100) NOT NULL,
[ruleid] [varchar] (50) NOT NULL,
[rulestatus] [char] (1) NULL,
[rulecreated] [datetime] NOT NULL,
[ruleupdated] [datetime] NULL,
[ruleblock] [int] NULL,
[rulenum] [int] NULL,
[rulesubscript] [int] NULL,
[ruletype] [varchar] (50) NULL,
[ruletarget] [varchar] (250) NULL,
[rstat1] [int] NULL,
[rstat2] [int] NULL,
[rstat3] [int] NULL,
[rstat4] [decimal] (18, 0) NULL,
[rstat5] [datetime] NULL,
[rstat6] [varchar] (50) NULL
)
GO
PRINT N'Creating index [IX_DMS_AUDITTAB] on [dbo].[DMS_AUDITTAB]'
GO
CREATE NONCLUSTERED INDEX [IX_DMS_AUDITTAB] ON [dbo].[DMS_AUDITTAB] ([runid], [ruleid])
GO
PRINT N'Creating [dbo].[DM_ASSIGNMENT]'
GO
CREATE TABLE [dbo].[DM_ASSIGNMENT]
(
[assignment_id] [int] NOT NULL,
[person_id] [int] NOT NULL,
[emp_id] [varchar] (10) NULL,
[emp_jobtitle] [varchar] (100) NULL,
[assignment_notes] [varchar] (1000) NULL
)
GO
PRINT N'Creating index [asgnInd1] on [dbo].[DM_ASSIGNMENT]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [asgnInd1] ON [dbo].[DM_ASSIGNMENT] ([person_id], [assignment_id])
GO
PRINT N'Creating [dbo].[DM_CUSTOMER_ASXML_IDAttr]'
GO
CREATE TABLE [dbo].[DM_CUSTOMER_ASXML_IDAttr]
(
[customer_id] [varchar] (10) NOT NULL,
[customer_data] [xml] NULL
)
GO
PRINT N'Creating primary key [PK_DM_CUSTOMER_ASXML_IDAttr] on [dbo].[DM_CUSTOMER_ASXML_IDAttr]'
GO
ALTER TABLE [dbo].[DM_CUSTOMER_ASXML_IDAttr] ADD CONSTRAINT [PK_DM_CUSTOMER_ASXML_IDAttr] PRIMARY KEY CLUSTERED ([customer_id])
GO
PRINT N'Creating [dbo].[DM_CUSTOMER_CONTACTS]'
GO
CREATE TABLE [dbo].[DM_CUSTOMER_CONTACTS]
(
[CONTACT_ID] [int] NOT NULL IDENTITY(1, 1),
[CONTACT_PERSON] [xml] NOT NULL CONSTRAINT [DF__DM_CUSTOM__CONTA__4D94879B] DEFAULT ('<Company />')
)
GO
PRINT N'Creating primary key [PK__DM_CUSTO__99DE4258D381C1FD] on [dbo].[DM_CUSTOMER_CONTACTS]'
GO
ALTER TABLE [dbo].[DM_CUSTOMER_CONTACTS] ADD CONSTRAINT [PK__DM_CUSTO__99DE4258D381C1FD] PRIMARY KEY CLUSTERED ([CONTACT_ID])
GO
PRINT N'Creating [dbo].[DM_SUPPLIERS]'
GO
CREATE TABLE [dbo].[DM_SUPPLIERS]
(
[supplier_id] [int] NOT NULL,
[supplier_name] [varchar] (60) NULL
)
GO
PRINT N'Creating primary key [PK__DM_SUPPL__6EE594E866ABD8FE] on [dbo].[DM_SUPPLIERS]'
GO
ALTER TABLE [dbo].[DM_SUPPLIERS] ADD CONSTRAINT [PK__DM_SUPPL__6EE594E866ABD8FE] PRIMARY KEY CLUSTERED ([supplier_id])
GO
PRINT N'Creating [dbo].[Hahahaha]'
GO
CREATE TABLE [dbo].[Hahahaha]
(
[haha] [nchar] (10) NULL
)
GO
PRINT N'Creating [dbo].[ha2]'
GO
CREATE TABLE [dbo].[ha2]
(
[ha2] [nchar] (10) NULL
)
GO
PRINT N'Adding foreign keys to [dbo].[DM_CUSTOMER]'
GO
ALTER TABLE [dbo].[DM_CUSTOMER] ADD CONSTRAINT [CU_FK] FOREIGN KEY ([credit_card_type_id]) REFERENCES [dbo].[DM_CREDIT_CARD_TYPE] ([credit_card_type_id])
GO
PRINT N'Adding foreign keys to [dbo].[DM_CUSTOMER_NOTES]'
GO
ALTER TABLE [dbo].[DM_CUSTOMER_NOTES] ADD CONSTRAINT [CN_FK] FOREIGN KEY ([customer_id]) REFERENCES [dbo].[DM_CUSTOMER] ([customer_id])
GO
PRINT N'Adding foreign keys to [dbo].[DM_INVOICE_LINE]'
GO
ALTER TABLE [dbo].[DM_INVOICE_LINE] ADD CONSTRAINT [I4_FK] FOREIGN KEY ([inventory_item_id]) REFERENCES [dbo].[DM_INVENTORY_ITEM] ([inventory_item_id])
GO
ALTER TABLE [dbo].[DM_INVOICE_LINE] ADD CONSTRAINT [I3_FK] FOREIGN KEY ([invoice_number]) REFERENCES [dbo].[DM_INVOICE] ([invoice_number])
GO
