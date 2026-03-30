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

<cfif not isdefined("form.ckDetalle")>
	
	 <cf_sifimportar eicodigo="CCSSGRANDES" mode="out" exec="yes" html="yes" header="no">
		<!--- Ecodigo--->
		<cf_sifimportarparam name="Ecodigo" value="#session.Ecodigo#"> 
		<!--- periodo --->
		<cf_sifimportarparam name="periodo" value="form.CPperiodo"> 
		<!--- mes --->
		<cf_sifimportarparam name="mes" value="form.CPmes"> 
		<!--- mes --->
		<cf_sifimportarparam name="GrupoPlanillas" value="form.GrupoPlanilla"> 
		<cf_sifimportarparam name="Debug" value="false"> 
	</cf_sifimportar> 
	
<cfelse>
	<!--- <cfdump var="#form#"> --->
</cfif>