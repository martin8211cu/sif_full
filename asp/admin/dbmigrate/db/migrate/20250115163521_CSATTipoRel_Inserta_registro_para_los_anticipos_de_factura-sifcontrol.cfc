<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="CSATTipoRel Inserta registro para los anticipos de factura ">
  <cffunction name="up">
    <cfscript>
      execute("IF not exists(Select * from CSATTipoRel where CSATcodigo = '07')
              BEGIN
                  insert into CSATTipoRel  (CSATcodigo, CSATdescripcion, CSATdefault)
                  values ('07', 'CFDI por aplicación de anticipo',null)
              END");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("IF exists(Select * from CSATTipoRel where CSATcodigo = '07')
              BEGIN
                  delete from CSATTipoRel where CSATcodigo = '07'
              END");
    </cfscript>
  </cffunction>
</cfcomponent>
