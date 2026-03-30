<!--- 
		Modificado por Gustavo Fonseca H.
		Fecha: 14-6-2005.
		Motivo: Se utiliza el tipo de dato correspondiente al de la Base de datos(numeric) debido 
		a que estaba utilizando Integer.
 --->


<cfquery name="empresas" datasource="#session.DSN#">
  select EEnombre
  from EncuestaEmpresa
  where EEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EEid#">
</cfquery>

<cfquery name="TipoOrg" datasource="#session.DSN#">
  select  'Tipo de Organización : ' || ETdescripcion as  ETdescripcion
  from EmpresaOrganizacion
  where EEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EEid#">
  and   ETid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ETid#">
</cfquery>

<cfquery name="encuestas" datasource="#session.DSN#">
  select Edescripcion
  from Encuesta
  where EEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EEid#">
  and   Eid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Eid#">
</cfquery>

<cfif not isdefined("url.AllPuestos") and isdefined("url.PUESTOIDLIST") and len(trim(url.PUESTOIDLIST))>
  <cfset Puestos  = "'" & replace(url.PUESTOIDLIST,",","','","All") & "'">
</cfif>


<cfquery name="RsReporte" datasource="#session.DSN#">
  select
    '#empresas.EEnombre#'     as   EEnombre,
    '#TipoOrg.ETdescripcion#'   as   ETdescripcion,
    '#encuestas.Edescripcion#'  as   Edescripcion,
    de.DEidentificacion,
    de.DEapellido1  || ' ' || de.DEapellido2 || ' ' ||  de.DEnombre as  Nombre,
    lt.LTsalario,
    p.RHPcodigo as codplaza,
    p.RHPdescripcion as Plaza,
    cf.CFcodigo,
    cf.CFdescripcion,
    pu.RHPcodigo as codpuesto,
    pu.RHPdescpuesto as puesto,
    ep.EPcodigo as codpue_enc,
    ep.EPdescripcion as puesto_enc,
    case
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 25 then ESp25
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 50 then ESp50
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 75 then ESp75
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 1 then ESpromedioanterior
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 0 then ESpromedio
      when <cfqueryparam  cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 10 then ESvariacion
    end as percentil,
    case
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 25 then lt.LTsalario - ESp25
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 50 then lt.LTsalario - ESp50
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 75 then lt.LTsalario - ESp75
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 1 then lt.LTsalario - ESpromedioanterior
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 0 then lt.LTsalario - ESpromedio
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 10 then lt.LTsalario - ESvariacion
    end as diferencia,
    case
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 25
        then  case  when ESp25 > 0   then ((lt.LTsalario - ESp25)/ESp25)* 100  else 100.00 end

      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 50
        then case  when ESp50 > 0   then  ((lt.LTsalario - ESp50)/ESp50)* 100  else 100.00 end

      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 75
        then case  when ESp75 > 0   then  ((lt.LTsalario - ESp75)/ESp75)* 100   else 100.00 end

      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 1
        then case  when ESpromedioanterior > 0  then   ((lt.LTsalario - ESpromedioanterior)/ESpromedioanterior)* 100  else 100.00 end

      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 0
        then case  when ESpromedio > 0  then   ((lt.LTsalario - ESpromedio)/ESpromedio)* 100   else 100.00 end

      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 10
        then case  when ESvariacion > 0   then   ((lt.LTsalario - ESvariacion)/ESvariacion)* 100   else 100.00 end

    end as Porcentaje,
    case
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 25 then 'P25'
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 50 then 'P50'
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 75 then 'P75'
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 1 then 'Prom. Anterior'
      when <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 0 then 'Promedio'
      when <cfqueryparam  cfsqltype="cf_sql_integer" value="#url.NivelS#"> = 10 then 'Otro Percentil'
    end as tipopercentil
  from LineaTiempo lt

  inner join DatosEmpleado de
    on  de.Ecodigo = lt.Ecodigo
    and de.DEid = lt.DEid

  inner join RHPuestos pu
    on  lt.Ecodigo = pu.Ecodigo
    and lt.RHPcodigo = pu.RHPcodigo
     <cfif not isdefined("url.AllPuestos") and isdefined("url.PUESTOIDLIST") and len(trim(url.PUESTOIDLIST))>
      and pu.RHPcodigo  in (#PreserveSingleQuotes(Puestos)#)
    </cfif>

  inner join RHPlazas p
    on  lt.RHPid   = p.RHPid
    and lt.Ecodigo = p.Ecodigo

  inner join CFuncional cf
    on  p.Ecodigo      = cf.Ecodigo
    and p.CFid         = cf.CFid
    <cfif isdefined("url.CFid") and len(trim(url.CFid))>
      and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
    </cfif>

  inner join RHEncuestaPuesto c
    on  lt.Ecodigo    = c.Ecodigo
    and lt.RHPcodigo  = c.RHPcodigo

  inner join EncuestaEmpresa ee
    on  ee.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EEid#">

  inner join Encuesta e
    on   e.EEid = ee.EEid
    and  e.Eid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Eid#">

  inner join EncuestaSalarios es
    on   es.ETid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ETid#">
    and  es.Eid    = e.Eid
    and  es.EEid   = e.EEid
    and  es.Moneda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Mcodigo#">
    and  es.EPid   = c.EPid

  inner join EncuestaPuesto ep
    on  es.EEid = ep.EEid
    and es.EPid = ep.EPid

  where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#"> between lt.LTdesde and lt.LThasta
    and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
  order by cf.CFid, de.DEapellido1, de.DEapellido2, de.DEnombre

</cfquery>
<!--- <cf_dump var="#RsReporte#"> --->
<cfif isdefined("url.FORMATO") and url.FORMATO eq 1>
  <cfset TipoRep = 'flashpaper'>
</cfif>
<cfif isdefined("url.FORMATO") and url.FORMATO eq 2>
  <cfset TipoRep = 'PDF'>
</cfif>
<cfif isdefined("url.FORMATO") and url.FORMATO eq 3>
  <cfset TipoRep = 'Excel'>
</cfif>
<cfreport format="#TipoRep#" template="ComparaSalario-rep.cfr" query="RsReporte">
</cfreport>