<!---Misma funcion del rh/admin/catalogos/SQLJornadas---->
<cffunction name="crearFecha" returntype="date" output="true">
	<cfargument name="hora" type="string" required="yes">
	<cfargument name="minutos" type="string" required="yes">
	<cfargument name="tipo" type="string" required="yes">
	
	<cfset anno = DatePart('yyyy', Now())>
	<cfset mes = DatePart('m', Now())>
	<cfset dia = DatePart('d', Now())>

	<cfset vhora = arguments.hora >
	<cfif trim(tipo) eq 'PM' and compare(vhora,'12') neq 0>
		<cfset vhora = vhora + 12 >
	<cfelseif trim(tipo) eq 'AM' and compare(vhora,'12') eq 0 >
		<cfset vhora = 0 >
	</cfif>

	<cfset fecha = CreateDateTime(anno, mes, dia, vhora, arguments.minutos, 0) >
	<cfreturn fecha >
</cffunction>


<cfloop list="#form.RHDJdia#" index="i">
	<!---Obtener la hora inicial de la jornada---->
	<cfif isdefined("Form.horaini_#i#")>
		<cfset horaInicial = crearFecha(Mid(Form['horaini_#i#'],1,2), Mid(Form['minutoini_#i#'],1,2), Mid(Form['horaini_#i#'],3,3)) >		
	</cfif>
	<!---Obtener la hora final de la jornada---->
	<cfif isdefined("Form.horafin_#i#")>
		<cfset horaFinal = crearFecha(Mid(Form['horafin_#i#'],1,2), Mid(Form['minutofin_#i#'],1,2), Mid(Form['horafin_#i#'],3,3)) >
	</cfif>
	<!---Obtener la hora inicial de la comida---->
	<cfif isDefined("form.horainicom_#i#") and Len(Trim(form['horainicom_#i#'])) GT 0 >
		<cfset horaIncialCom = crearFecha(Mid(Form['horainicom_#i#'],1,2), Mid(Form['minutoinicom_#i#'],1,2), Mid(Form['horainicom_#i#'],3,3)) >
	</cfif>
	<!---Obtener la hora final de la comida---->
	<cfif isDefined("form.horafincom_#i#") and Len(Trim(form['horafincom_#i#'])) GT 0 >
		<cfset horaFinalCom = crearFecha(Mid(Form['horafincom_#i#'],1,2), Mid(Form['minutofincom_#i#'],1,2), Mid(Form['horafincom_#i#'],3,3)) >
	</cfif>

	<cfquery name="updateDetalle" datasource="#session.DSN#">
		update RHDJornadas
			set RHJhoraini = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#horaInicial#">,
				RHJhorafin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#horaFinal#">,
				RHJhorainicom = <cfif isdefined("horaIncialCom") and len(trim(horaIncialCom))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#horaIncialCom#"><cfelse>null</cfif>,
				RHJhorafincom = <cfif isdefined("horaFinalCom") and len(trim(horaFinalCom))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#horaFinalCom#"><cfelse>null</cfif>,
				RHJhorasNormales = <cfif isdefined("form.RHJhorasNormales_#i#") and Len(Trim(form['RHJhorasNormales_#i#']))><cfqueryparam cfsqltype="cf_sql_float" value="#form['RHJhorasNormales_#i#']#"><cfelse>null</cfif>,
				RHJhorasExtraA = <cfif isdefined("form.RHJhorasExtraA_#i#") and Len(Trim(form['RHJhorasExtraA_#i#']))><cfqueryparam cfsqltype="cf_sql_float" value="#form['RHJhorasExtraA_#i#']#"><cfelse>null</cfif>,
				RHJhorasExtraB = <cfif isdefined("form.RHJhorasExtraA_#i#") and Len(Trim(form['RHJhorasExtraB_#i#']))><cfqueryparam cfsqltype="cf_sql_float" value="#form['RHJhorasExtraB_#i#']#"><cfelse>null</cfif>
		where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
			and RHDJdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">	
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
	</cfquery>	
</cfloop>

<cfoutput>
<form action="Jornadas-tabs.cfm?tab=2" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="RHJid" type="hidden" value="<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>#form.RHJid#"</cfif>>
</form>
</cfoutput>

<HTML><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>