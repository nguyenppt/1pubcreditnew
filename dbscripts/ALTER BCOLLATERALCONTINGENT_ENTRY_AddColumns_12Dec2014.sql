SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE BCOLLATERALCONTINGENT_ENTRY
ADD [ReferenceID] nvarchar(50)  NULL ;

UPDATE BCOLLATERALCONTINGENT_ENTRY SET [ReferenceID] = [CollateralInfoID] ;