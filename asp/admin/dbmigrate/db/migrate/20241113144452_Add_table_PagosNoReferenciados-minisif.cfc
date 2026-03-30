<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Add table PagosNoReferenciados">
  <cffunction name="up">
    <cfscript>
      execute("
            If not exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ListaNegraSAT')
            BEGIN
                create table PagosNoReferenciados
                ( PNRId int primary key not null identity,
                  Ecodigo int not null,
                  FCid int not null,  ---Id caja
                  CCTcodigo char(2) not null, ---Transacción
                  CFid int not null, ---Id Centro funcional
                  Mcodigo numeric not null, ---Codigo moneda
                  TCambio numeric not null, ---Tipo de cambio
                  FATid numeric not null, ---Id tarjeta
                  id_zona numeric not null, ---id zona
                  PNRReferencias varchar(255),
                  PNRMonto money,
                  PNRFecha datetime,
                  PNRCuenta varchar(100),
                  PNRGuardado bit default(0),
                  PNREnRevision bit default(0),
                  PNRAplicado bit default(0),
                  BMFecha datetime,
                  BMFechaAprobado datetime,
                  BMusuario int,
                  BMusuarioAprobador int,
                  ts_rversion timestamp
                )
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
