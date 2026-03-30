
<cfset params = ''>
<cfif isdefined('form.btnAprobar')> <!--- Aprobar ---> 
	<cfquery name="UpdateDatoAdjunto" datasource="#session.DSN#">
		update DatosOferentesArchivos
		set aprobado = <cfif isdefined('form.btnAprobar')> 1 <cfelseif isdefined('form.BtnRechazar')> 0 </cfif>
		where <cfoutput>#form.fk#</cfoutput> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fkvalor#">
			and DOAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DOAid#">
	</cfquery>

	<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "DEid=" & DEid>	
</cfif>

<cfif isdefined('form.btnEliminar')> <!--- Eliminar datos adjuntos ya aprobados --->
	<cfquery datasource="#session.DSN#">
		delete from DatosOferentesArchivos 
		where <cfoutput>#form.fk#</cfoutput> = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fkvalor#">
			and DOAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DOAid#">
	</cfquery>
</cfif>

<cfif isdefined("fromAprobacionCV")> <!--- si se trabaja desde aprobacion de curriculum vitae --->
	<cflocation url="AprobacionCV.cfm?DEid=#form.DEid#&tab=7">
<cfelse>
	<cflocation url="AprobacionCV.cfm">	
</cfif>
