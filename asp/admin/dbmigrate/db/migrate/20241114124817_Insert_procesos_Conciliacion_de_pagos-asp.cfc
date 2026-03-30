<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Insert procesos Conciliacion de pagos">
  <cffunction name="up">
    <cfscript>
      execute("
        ---------------------------------------------------------------------------------------------
        IF EXISTS (SELECT * FROM SModulos where SScodigo='CRED' and SMcodigo='CREDCB')
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM SProcesos WHERE SPcodigo = 'PAGOSNOREF' and SMcodigo='CREDCB')
              INSERT INTO SProcesos (SScodigo, SMcodigo, SPcodigo, SPdescripcion, SPhomeuri, SPmenu, BMfecha, BMUsucodigo, SPanonimo, SPpublico, SPinterno)
                           VALUES ('CRED', 'CREDCB', 'PAGOSNOREF', 'Conciliación de pagos no referenciados', '/crc/cobros/operacion/ConciliacionPagosNRef.cfm', 1, GETDATE(), #session.Usucodigo#, 0, 0, 0)


            IF NOT EXISTS (SELECT 1 FROM SComponentes WHERE SPcodigo = 'PAGOSNOREF' and SScodigo = 'CRED' and SMcodigo = 'CREDCB' and SCuri = '/crc/cobros/operacion/ConciliacionPagosNRef.cfc')
            BEGIN
                 insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
                 values ('CRED', 'CREDCB', 'PAGOSNOREF', '/crc/cobros/operacion/ConciliacionPagosNRef.cfc', 'P', 0, GETDATE(), #session.Usucodigo#)
            END

            IF NOT EXISTS (SELECT 1 FROM SComponentes WHERE SPcodigo = 'PAGOSNOREF' and SScodigo = 'CRED' and SMcodigo = 'CREDCB' and SCuri = '/crc/cobros/operacion/ConciliacionPagosNRef_form.cfm')
            BEGIN
                 insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
                 values ('CRED', 'CREDCB', 'PAGOSNOREF', '/crc/cobros/operacion/ConciliacionPagosNRef_form.cfm', 'P', 0, GETDATE(), #session.Usucodigo#)
            END

            IF NOT EXISTS (SELECT 1 FROM SComponentes WHERE SPcodigo = 'PAGOSNOREF' and SScodigo = 'CRED' and SMcodigo = 'CREDCB' and SCuri = '/crc/cobros/operacion/ConciliacionPagosNRef_sql.cfm')
            BEGIN
                 insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
                 values ('CRED', 'CREDCB', 'PAGOSNOREF', '/crc/cobros/operacion/ConciliacionPagosNRef_sql.cfm', 'P', 0, GETDATE(), #session.Usucodigo#)
            END

            IF NOT EXISTS (SELECT 1 FROM SProcesos WHERE SPcodigo = 'PAGONOREFA' and SMcodigo='CREDCB')
              INSERT INTO SProcesos (SScodigo, SMcodigo, SPcodigo, SPdescripcion, SPhomeuri, SPmenu, BMfecha, BMUsucodigo, SPanonimo, SPpublico, SPinterno)
                           VALUES ('CRED', 'CREDCB', 'PAGONOREFA', 'Aprobación de pagos no referenciados', '/crc/cobros/operacion/ConciliacionPagosNRef-Aprobador.cfm', 1, GETDATE(), #session.Usucodigo#, 0, 0, 0)


            IF NOT EXISTS (SELECT 1 FROM SComponentes WHERE SPcodigo = 'PAGONOREFA' and SScodigo = 'CRED' and SMcodigo = 'CREDCB' and SCuri = '/crc/cobros/operacion/ConciliacionPagosNRef.cfc')
            BEGIN
                 insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
                 values ('CRED', 'CREDCB', 'PAGONOREFA', '/crc/cobros/operacion/ConciliacionPagosNRef.cfc', 'P', 0, GETDATE(), #session.Usucodigo#)
            END

            IF NOT EXISTS (SELECT 1 FROM SComponentes WHERE SPcodigo = 'PAGONOREFA' and SScodigo = 'CRED' and SMcodigo = 'CREDCB' and SCuri = '/crc/cobros/operacion/ConciliacionPagosNRef_form.cfm')
            BEGIN
                 insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
                 values ('CRED', 'CREDCB', 'PAGONOREFA', '/crc/cobros/operacion/ConciliacionPagosNRef_form.cfm', 'P', 0, GETDATE(), #session.Usucodigo#)
            END

            IF NOT EXISTS (SELECT 1 FROM SComponentes WHERE SPcodigo = 'PAGONOREFA' and SScodigo = 'CRED' and SMcodigo = 'CREDCB' and SCuri = '/crc/cobros/operacion/ConciliacionPagosNRef_sql.cfm')
            BEGIN
                 insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
                 values ('CRED', 'CREDCB', 'PAGONOREFA', '/crc/cobros/operacion/ConciliacionPagosNRef_sql.cfm', 'P', 0, GETDATE(), #session.Usucodigo#)
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
