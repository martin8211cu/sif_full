<cfdump var="#form#">
<cfdump var="#url#">

<cfquery name="rsParametro" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 981
</cfquery>
<cfset LvarParametro = 0>
<cfif isdefined("rsParametro") and rsParametro.recordcount eq 1>
		<cfset LvarParametro= rsParametro.Pvalor>
</cfif>


<cfquery name="rsReporte" datasource="#session.DSN#">
    select 
        count (1) as cantidad
    from HEContables e
       inner join HDContables d
          on d.IDcontable = e.IDcontable
    where e.Ecodigo = #session.Ecodigo#
     <cfif isdefined ("url.periodoIni") and isdefined ("url.PeriodoFin")>
        and e.Eperiodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#">
        and e.Eperiodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoFin#">
     </cfif>
     <cfif isdefined ("url.periodoini") and isdefined ("url.mesini")>
       and ((e.Eperiodo * 100 + e.Emes)  between (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesIni#">) and (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoFin#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesFin#">))
     </cfif>
     <cfif isdefined ("url.Usuario") and len(trim(url.Usuario))>
        and (upper(ltrim(rtrim(e.ECusuario))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(url.Usuario))#"> or '#url.Usuario#' = 'Todos')
     </cfif>
     
    
      <!--- FILTROS DE Conceptos --->
     <cfif isdefined("url.loteini") and len(trim(url.loteini)) and isdefined("url.lotefin") and len(trim(url.lotefin))>
        and e.Cconcepto >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.loteini#"> 
        and e.Cconcepto <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.lotefin#">
     <cfelseif isdefined("url.loteini") and len(trim(url.loteini))>
        and e.Cconcepto >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.loteini#">
     <cfelseif isdefined("url.lotefin") and len(trim(url.lotefin))> 
        and e.Cconcepto <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.lotefin#">
     </cfif> 
     
    <!--- FILTROS DE ASIENTOS --->
    <cfif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI)) and isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
        and e.Edocumento >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoI#"> 
        and e.Edocumento <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoF#">
    <cfelseif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI))>
        and e.Edocumento >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoI#">
    <cfelseif isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))> 
        and e.Edocumento <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoF#">
    </cfif>
      <!--- FILTROS DE FECHAS --->
     <cfif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and isdefined("url.fechaFin") and len(trim(url.fechaFin))>
        and <cf_dbfunction name="to_date00" args="e.Efecha"> between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaIni)#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaFin)#">
     <cfelseif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and not isdefined("url.fechaFin")>
        and <cf_dbfunction name="to_date00" args="e.Efecha"> >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaIni)#">
     <cfelseif isdefined("url.fechaFin") and len(trim(url.fechaFin)) and not isdefined("url.fechaIni")>
        and <cf_dbfunction name="to_date00" args="e.Efecha"> <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaFin)#">
     </cfif> 
</cfquery>

<cfdump var="#rsReporte#">