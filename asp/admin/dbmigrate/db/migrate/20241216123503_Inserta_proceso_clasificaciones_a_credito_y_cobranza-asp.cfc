<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Inserta proceso clasificaciones a credito y cobranza">
  <cffunction name="up">
    <cfscript>
      execute("
        ---------------------------------------------------------------------------------------------
        IF EXISTS (SELECT * FROM SModulos where SScodigo='CRED' and SMcodigo='CREDADM')
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM SProcesos WHERE SPcodigo = 'SNCLASIF' and SMcodigo='CREDADM')
              INSERT INTO SProcesos (SScodigo, SMcodigo, SPcodigo, SPdescripcion, SPhomeuri, SPmenu, BMfecha, BMUsucodigo, SPanonimo, SPpublico, SPinterno)
                           VALUES ('CRED', 'CREDADM', 'SNCLASIF', 'Clasificación de Socios de Negocios', '/sif/ad/catalogos/SNClasificaciones.cfm', 1, GETDATE(), #session.Usucodigo#, 0, 0, 0)


            IF NOT EXISTS (SELECT 1 FROM SComponentes WHERE SPcodigo = 'SNCLASIF' and SScodigo = 'CRED' and SMcodigo = 'CREDADM' and SCuri = '/sif/ad/catalogos/formSNClasificaciones.cfm')
            BEGIN
                 insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
                 values ('CRED', 'CREDADM', 'SNCLASIF', '/sif/ad/catalogos/formSNClasificaciones.cfm', 'P', 0, GETDATE(), #session.Usucodigo#)
            END

            IF NOT EXISTS (SELECT 1 FROM SComponentes WHERE SPcodigo = 'SNCLASIF' and SScodigo = 'CRED' and SMcodigo = 'CREDADM' and SCuri = '/sif/ad/catalogos/SQLSNClasificaciones.cfm')
            BEGIN
                 insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
                 values ('CRED', 'CREDADM', 'SNCLASIF', '/sif/ad/catalogos/SQLSNClasificaciones.cfm', 'P', 0, GETDATE(), #session.Usucodigo#)
            END

            
        END
      ");    
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("
          select 1 from dual
      "); 
    </cfscript>
  </cffunction>
</cfcomponent>
