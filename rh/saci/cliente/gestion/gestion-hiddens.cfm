<cfoutput>
	<input type="hidden" name="cue" value="<cfif isdefined("form.cue") and Len(Trim(form.cue))>#form.cue#</cfif>" />		<!---id de la cuenta --->
	<input type="hidden" name="pkg" value="<cfif isdefined("form.pkg") and Len(Trim(form.cue))>#form.pkg#</cfif>" />		<!---id del contrato --->
	<input type="hidden" name="pqc" value="<cfif isdefined("form.pqc") and Len(Trim(form.pqc))>#form.pqc#</cfif>" />		<!--- Pquien (id del contacto)--->
	<input type="hidden" name="traf" value="<cfif isdefined("form.traf") and Len(Trim(form.traf))>#form.traf#</cfif>"/>		<!--- consulta de tráfico--->
	<input type="hidden" name="logg" value="<cfif isdefined("form.logg") and Len(Trim(form.logg))>#form.logg#</cfif>"/>		<!---id del login--->
	<input type="hidden" name="cli" value="<cfif isdefined("form.cli") and Len(Trim(form.cli))>#form.cli#</cfif>"/>			<!---id cliente--->
	<input type="hidden" name="cpass" value="<cfif isdefined("form.cpass") and Len(Trim(form.cpass))>#form.cpass#</cfif>"/><!---Cambio de Password--->
	<input type="hidden" name="lpaso" value="<cfif isdefined("form.lpaso") and Len(Trim(form.lpaso))>#form.lpaso#</cfif>" /><!---paso para el menu de logines --->
	<input type="hidden" name="cpaso" value="<cfif isdefined("form.cpaso") and Len(Trim(form.cpaso))>#form.cpaso#</cfif>" /><!---paso para el menu de cuentas--->
	<input type="hidden" name="csub" value="<cfif isdefined("form.csub") and Len(Trim(form.csub))>#form.csub#</cfif>" />	<!---sub-paso para el menu en cuentas en el paso 3 (forma de cobro)--->
	<input type="hidden" name="ppaso" value="<cfif isdefined("form.ppaso") and Len(Trim(form.ppaso))>#form.ppaso#</cfif>" /><!---paso para el menu de Productos(paquetes) --->
	<input type="hidden" name="tab" value="<cfif isdefined("form.tab") and Len(Trim(form.tab))>#form.tab#</cfif>" />		<!--- tab para la informacion del cliente --->
	<input type="hidden" name="adser" value="<cfif isdefined("form.adser") and Len(Trim(form.adser))>#form.adser#</cfif>" /><!--- Agregar servicios (funciona como indicador de paso)--->
	<input type="hidden" name="recarga" value="<cfif isdefined("form.recarga") and Len(Trim(form.recarga))>#form.recarga#</cfif>" /><!--- Recarga de prepagos (funciona como indicador de paso)--->
	<input type="hidden" name="pintaBotones" value="<cfif isdefined("form.pintaBotones") and Len(Trim(form.pintaBotones))>1<cfelse>0</cfif>"/>			<!---Bandera para pintar o no lo s botones--->		
</cfoutput>
