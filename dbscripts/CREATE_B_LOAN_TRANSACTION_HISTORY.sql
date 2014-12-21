USE [bisolutions_vvcb]
GO


/****** Object:  Table [dbo].[B_LOAN_TRANSACTION_HISTORY]    Script Date: 12/10/2014 10:23:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[B_LOAN_TRANSACTION_HISTORY](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TxnId] [nvarchar](50) NOT NULL,
	[TxnType] [nvarchar](50) NULL,
	[TxnAmount] [decimal](18, 4) NOT NULL,
	[Balance] [decimal](18, 4) NOT NULL,
	[NewBalance] [decimal](18, 4) NOT NULL,
	[ProcessDate] [date] NULL,
	[ProcessUser] [int] NULL,
	[AccountNo] [nvarchar](50) NULL,
 CONSTRAINT [PK_B_LOAN_TRANSACTION_HISTORY] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


