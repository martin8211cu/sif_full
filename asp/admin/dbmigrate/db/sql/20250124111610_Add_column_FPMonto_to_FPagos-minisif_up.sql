
IF not exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'FPMonto' AND TABLE_NAME = 'FPagos'
                )
              BEGIN
                  ALTER TABLE FPagos add FPMonto money null
              END;
