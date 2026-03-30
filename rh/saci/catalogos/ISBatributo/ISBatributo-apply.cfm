
<cfif IsDefined("form.Cambio")>
	<!--- Modificacin del atributo --->
	<cfinvoke component="saci.comp.ISBatributo" method="Cambio">
		<cfinvokeargument name="Aid" value="#val(form.Aid)#">
		<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
		<cfinvokeargument name="Aetiq" value="#form.Aetiq#">
		<cfinvokeargument name="Adesc" value="#form.Adesc#">
		<cfinvokeargument name="AtipoDato" value="#form.AtipoDato#">
		<cfinvokeargument name="Aorden" value="#form.Aorden#">
		<cfinvokeargument name="AapFisica" value="#IsDefined('form.AapFisica')#">
		<cfinvokeargument name="AapJuridica" value="#IsDefined('form.AapJuridica')#">
		<cfinvokeargument name="AapCuenta" value="#IsDefined('form.AapCuenta')#">
		<cfinvokeargument name="AapAgente" value="#IsDefined('form.AapAgente')#">
		<cfinvokeargument name="Habilitado" value="#Iif(IsDefined('form.Habilitado'), DE('1'), DE('0'))#">
	</cfinvoke>	
	<cflocation url="ISBatributo.cfm?Aid=#URLEncodedFormat(form.Aid)#">
	<!--- <cflocation url="ISBatributo.cfm?Aid=#URLEncodedFormat(form.Aid)#&Pagina='#form.Pagina#'&Filtro_Aetiq='#form.Filtro_Aetiq#'&Filtro_Adesc='#form.Filtro_Adesc#'&Filtro_AtipoDato='#form.Filtro_AtipoDato#'&HFiltro_Aetiq='#form.Filtro_Aetiq#'&HFiltro_Adesc='#form.Filtro_Adesc#'&HFiltro_AtipoDato='#form.Filtro_AtipoDato#'">---->
<cfelseif IsDefined("form.Baja")>
	<!--- Borrado del atributo --->
	<cfinvoke component="saci.comp.ISBatributo" method="Baja">
		<cfinvokeargument name="Aid" value="#form.Aid#">
	</cfinvoke>
<cfelseif IsDefined("form.Nuevo")>
	<!--- Nuevo Atributo --->
<cfelseif IsDefined("form.Alta")>
	<!--- Agregar Atributo --->
	<cfinvoke component="saci.comp.ISBatributo" method="Alta" returnvariable="result">
		<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
		<cfinvokeargument name="Aetiq" value="#form.Aetiq#">
		<cfinvokeargument name="Adesc" value="#form.Adesc#">
		<cfinvokeargument name="AtipoDato" value="#form.AtipoDato#">
		<cfinvokeargument name="Aorden" value="#form.Aorden#">
		<cfinvokeargument name="AapFisica" value="#IsDefined('form.AapFisica')#">
		<cfinvokeargument name="AapJuridica" value="#IsDefined('form.AapJuridica')#">
		<cfinvokeargument name="AapCuenta" value="#IsDefined('form.AapCuenta')#">
		<cfinvokeargument name="AapAgente" value="#IsDefined('form.AapAgente')#">
		<cfinvokeargument name="Habilitado" value="#Iif(IsDefined('form.Habilitado'), DE('1'), DE('0'))#">
	</cfinvoke>
	<cflocation url="ISBatributo.cfm?Aid=#URLEncodedFormat(result)#">
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="ISBatributo.cfm">



