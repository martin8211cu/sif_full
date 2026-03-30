
---------------------------------------------------------------------------------------------
        IF EXISTS (SELECT * FROM SModulos where SScodigo='CRED' and SMcodigo='CREDADM')
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM SProcesos WHERE SPcodigo = 'SNCLASIF' and SMcodigo='CREDADM')
              INSERT INTO SProcesos (SScodigo, SMcodigo, SPcodigo, SPdescripcion, SPhomeuri, SPmenu, BMfecha, BMUsucodigo, SPanonimo, SPpublico, SPinterno)
                           VALUES ('CRED', 'CREDADM', 'SNCLASIF', 'Clasificación de Socios de Negocios', '/sif/ad/catalogos/SNClasificaciones.cfm', 1, GETDATE(), 1, 0, 0, 0)


            IF NOT EXISTS (SELECT 1 FROM SComponentes WHERE SPcodigo = 'SNCLASIF' and SScodigo = 'CRED' and SMcodigo = 'CREDADM' and SCuri = '/sif/ad/catalogos/formSNClasificaciones.cfm')
            BEGIN
                 insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
                 values ('CRED', 'CREDADM', 'SNCLASIF', '/sif/ad/catalogos/formSNClasificaciones.cfm', 'P', 0, GETDATE(), 1)
            END

            IF NOT EXISTS (SELECT 1 FROM SComponentes WHERE SPcodigo = 'SNCLASIF' and SScodigo = 'CRED' and SMcodigo = 'CREDADM' and SCuri = '/sif/ad/catalogos/SQLSNClasificaciones.cfm')
            BEGIN
                 insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
                 values ('CRED', 'CREDADM', 'SNCLASIF', '/sif/ad/catalogos/SQLSNClasificaciones.cfm', 'P', 0, GETDATE(), 1)
            END

            
        END;
