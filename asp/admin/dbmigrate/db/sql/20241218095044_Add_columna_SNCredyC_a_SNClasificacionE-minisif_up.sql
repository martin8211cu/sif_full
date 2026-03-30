
IF not exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'SNCredyC' AND TABLE_NAME = 'SNClasificacionE'
                )
              BEGIN
                  ALTER TABLE SNClasificacionE add SNCredyC bit not null default(0)
              END;
