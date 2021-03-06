ALTER PROCEDURE [dbo].[USER_ITEM_SEAL]
@strAccountID	char(21),
@strUserID		char(21),
@strPasswd		char(8),
@nItemSerial	bigint,
@nItemID		int,
@bSealType		tinyint,
@nRet			tinyint OUTPUT

AS
DECLARE @strSealPasswd char(8)
BEGIN

SET @nRet = 2 --Default error : "Item Sealing failed."

SELECT @strSealPasswd = strSealPassword FROM TB_USER WHERE strAccountID = @strAccountID

IF @bSealType < 3 AND @strSealPasswd <> @strPasswd
	BEGIN
		SET @nRet = 4 --"Invalid Citizen Registration number"
		RETURN
	END
ELSE
	BEGIN
		IF @bSealType = 1 OR @bSealType = 3		--If we are sealing (or binding)
			INSERT INTO SEALED_ITEMS (strAccountID, strUserID, nItemSerial, nItemID, bSealType) VALUES (@strAccountID, @strUserID, @nItemSerial, @nItemID, @bSealType)
		ELSE IF @bSealType = 2	--If we are unsealing
			DELETE FROM SEALED_ITEMS WHERE nItemSerial = @nItemSerial AND strAccountID = @strAccountID AND strUserID = @strUserID AND nItemID = @nItemID
			
		SET @nRet = 1 -- "Success!"
	END

RETURN
END