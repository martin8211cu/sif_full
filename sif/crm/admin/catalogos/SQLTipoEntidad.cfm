<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.Nuevo") >
	<cfquery name="abc_tipoentidad" datasource="#session.DSN#">
		set nocount on
		<cfif isdefined("form.ALTA")>
			insert CRMTipoEntidad ( CEcodigo, Ecodigo, CRMTEcodigo, CRMTEdesc, CRMTEapellido1, CRMTEapellido2, CRMTEdireccion, CRMTEapartado, CRMTEtel1, CRMTEtel2, CRMTEtel3, CRMTEemail, CRMTEidentificacion, CRMTEdonacion, CRMTEdonacionentidad)
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_char" value="#form.CRMTEcodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMTEdesc#">, 
					 <cfif isdefined("form.CRMTEapellido1")>1<cfelse>0</cfif>, 
					 <cfif isdefined("form.CRMTEapellido2")>1<cfelse>0</cfif>, 
					 <cfif isdefined("form.CRMTEdireccion")>1<cfelse>0</cfif>, 
					 <cfif isdefined("form.CRMTEapartado")>1<cfelse>0</cfif>, 
					 <cfif isdefined("form.CRMTEtel1")>1<cfelse>0</cfif>, 
					 <cfif isdefined("form.CRMTEtel2")>1<cfelse>0</cfif>, 
					 <cfif isdefined("form.CRMTEtel3")>1<cfelse>0</cfif>, 
					 <cfif isdefined("form.CRMTEemail")>1<cfelse>0</cfif>, 
					 <cfif isdefined("form.CRMTEidentificacion")>1<cfelse>0</cfif>,
 					 <cfif isdefined("form.CRMTEdonacion")>1<cfelse>0</cfif>,
 					 <cfif isdefined("form.CRMTEdonacionentidad")>1<cfelse>0</cfif>
				   )
		<cfelseif isdefined("form.CAMBIO") >
			update CRMTipoEntidad
			set CRMTEcodigo 		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.CRMTEcodigo#">, 
				CRMTEdesc   		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMTEdesc#">, 
				CRMTEapellido1 		= <cfif isdefined("form.CRMTEapellido1")>1<cfelse>0</cfif>, 
				CRMTEapellido2	 	= <cfif isdefined("form.CRMTEapellido2")>1<cfelse>0</cfif>, 
				CRMTEdireccion	 	= <cfif isdefined("form.CRMTEdireccion")>1<cfelse>0</cfif>, 
				CRMTEapartado	 	= <cfif isdefined("form.CRMTEapartado")>1<cfelse>0</cfif>, 
				CRMTEtel1	 		= <cfif isdefined("form.CRMTEtel1")>1<cfelse>0</cfif>, 
				CRMTEtel2	 		= <cfif isdefined("form.CRMTEtel2")>1<cfelse>0</cfif>, 
				CRMTEtel3	 		= <cfif isdefined("form.CRMTEtel3")>1<cfelse>0</cfif>, 
				CRMTEemail	        = <cfif isdefined("form.CRMTEemail")>1<cfelse>0</cfif>, 
				CRMTEidentificacion = <cfif isdefined("form.CRMTEidentificacion")>1<cfelse>0</cfif>,
				CRMTEdonacion       = <cfif isdefined("form.CRMTEdonacion")>1<cfelse>0</cfif>,
				CRMTEdonacionentidad= <cfif isdefined("form.CRMTEdonacionentidad")>1<cfelse>0</cfif>
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
			  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
			  and CRMTEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMTEid#" >
			  
			<cfset modo = "CAMBIO">
		<cfelseif isdefined("form.BAJA")>	
			delete from CRMTipoEntidad
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
			  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
			  and CRMTEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMTEid#" >
		</cfif>
		set nocount off
	</cfquery>
</cfif>

<cfoutput>
<form action="TipoEntidad.cfm" method="post">
	<input type="hidden" name="modo" value="#modo#">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="CRMTEid" value="#form.CRMTEid#">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("form.Pagina")>#form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>