<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 09 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Retención de cheques
----------->
<cfif IsDefined("form.Retener")>
	<cfquery datasource="#session.dsn#">
		update TEScontrolFormulariosD
			set TESCFDfechaRetencion = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fecharet)#">,
				UsucodigoRetencion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		 where TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumformulario#">
		   and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		   and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		   and TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TESMPcodigo#">
	</cfquery>
</cfif>
<cflocation url="retencionCheques.cfm">
