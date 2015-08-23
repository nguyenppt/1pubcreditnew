

/****** Object:  StoredProcedure [dbo].[B_CONTINGENT_ENTRY_Insert_Update]    Script Date: 13/11/2014 2:20:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select convert(date,'9/12/2014')
ALTER PROCEDURE [dbo].[B_CONTINGENT_ENTRY_Insert_Update](@CollateralInfoID nvarchar(20), @ContingentEntryID nvarchar(20), @CustomerID nvarchar(20), @CustomerAddress nvarchar(250),
 @DocIDTaxCode nvarchar(50), @DateOfIssue nvarchar(50), @TransactionCode nvarchar(10),
 @TransactionName nvarchar(200), @DCMode nvarchar(20), @DCName nvarchar(100), @Currency nvarchar(20), @AccountNo nvarchar(20), @AccountName nvarchar(300), 
 @Amount decimal(18,2), @DealRate decimal(10,6), @ValueDate date, @Narrative nvarchar(300), @ApprovedUser nvarchar(200), @CollateralTypeCode nvarchar(20))
 AS 
 
 IF @DateOfIssue !='' set @DateOfIssue = convert(date,@DateOfIssue) else set @DateOfIssue =null;
 IF exists (select [ContingentEntryID] FROM  [dbo].[BCOLLATERALCONTINGENT_ENTRY] WHERE [ContingentEntryID]= @ContingentEntryID) 
 BEGIN
 UPDATE [dbo].[BCOLLATERALCONTINGENT_ENTRY] SET [CollateralInfoID]=@CollateralInfoID,[ContingentEntryID]=@ContingentEntryID,[CustomerID]=@CustomerID
 ,[CustomerAddress]=@CustomerAddress,[DocIDTaxCode]=@DocIDTaxCode,[DateOfIssue]=@DateOfIssue,[TransactionCode]=@TransactionCode,[TransactionName]=@TransactionName
      ,[DCTypeCode]=@DCMode,[DCTypeName]=@DCName,[Currency]=@Currency, [AccountNo]= @AccountNo,[AccountName]=@AccountName,[Amount]=@Amount,[DealRate]=@DealRate
      ,[ValueDate]=@ValueDate,[Narrative]=@Narrative,[ApprovedUser]=@ApprovedUser, [CollateralType_Code] = @CollateralTypeCode
 WHERE [ContingentEntryID]= @ContingentEntryID
 END
 ELSE
 BEGIN
 INSERT INTO [dbo].[BCOLLATERALCONTINGENT_ENTRY]([CollateralInfoID],[ContingentEntryID],[CustomerID],[CustomerAddress],[DocIDTaxCode],[DateOfIssue],[TransactionCode]
      ,[TransactionName],[DCTypeCode],[DCTypeName],[Currency],[AccountNo],[AccountName],[Amount],[DealRate],[ValueDate],[Narrative],[ApprovedUser],[CollateralType_Code])
	   
VALUES(@CollateralInfoID, @ContingentEntryID, @CustomerID, @CustomerAddress, @DocIDTaxCode, @DateOfIssue, @TransactionCode, @TransactionName, @DCMode, @DCName
, @Currency, @AccountNo, @AccountName,@Amount,  @DealRate, @ValueDate,@Narrative,  @ApprovedUser,@CollateralTypeCode)
END

GO


