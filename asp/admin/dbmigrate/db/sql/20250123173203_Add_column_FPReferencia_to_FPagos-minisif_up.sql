
IF not exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'FPReferencia' AND TABLE_NAME = 'FPagos'
                )
              BEGIN
                  ALTER TABLE FPagos add FPReferencia varchar(15)
              END;
