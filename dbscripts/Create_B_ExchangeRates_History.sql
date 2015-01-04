
/****** Object:  Table [dbo].[B_ExchangeRates_History]    Script Date: 1/4/2015 9:54:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[B_ExchangeRates_History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Currency] [varchar](3) NOT NULL,
	[Rate] [decimal](18, 4) NULL,
	[Rate_New] [decimal](18, 4) NULL,
	[Actions] nvarchar(50) NULL,
	[CreatedDateTime] datetime NULL,
	[CreatedBy] int null,
 CONSTRAINT [PK_B_ExchangeRates_History] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


