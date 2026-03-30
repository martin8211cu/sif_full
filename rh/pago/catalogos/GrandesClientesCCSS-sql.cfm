<cfsetting  requesttimeout="36000">
<cfif isdefined("form.CPperiodo") and len(trim(form.CPperiodo))>
<cfelse>
	<cfset form.CPperiodo = Year(Now())>
</cfif>
<cfif isdefined("form.CPmes") and len(trim(form.CPmes))>
<cfelse>
	<cfset form.CPmes = Month(Now())> 
</cfif>
<cfif isdefined("form.GrupoPlanilla") and len(trim(form.GrupoPlanilla))>
<cfelse>
	<cfset form.GrupoPlanilla = ''>
</cfif>
<!--- Esto llama a sif\rh\importar\ExportarGrandesClientes.cfm--->
<cf_sifimportar eicodigo="CCSSGRANDES" mode="out" exec="yes" html="no" header="no">
  <cf_sifimportarparam name="Empresa" value="#Session.Ecodigo#"> 
  <cf_sifimportarparam name="Pperiodo" value="#form.CPperiodo#"> 
  <cf_sifimportarparam name="Mmes" value="#form.CPmes#">
  <cf_sifimportarparam name="GGrupoPlanillas" value="#form.GrupoPlanilla#">
  <cf_sifimportarparam name="Debug" value="false"> 
