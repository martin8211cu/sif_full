
IF not exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'estatusCliente' AND TABLE_NAME = 'CRCTransaccion'
                )
              BEGIN
                  ALTER TABLE CRCTransaccion ADD estatusCliente numeric null
              END;
