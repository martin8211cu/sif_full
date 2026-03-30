<cfparam name="modo" default="ALTA">
<cfif ( isdefined("ALTA") or isdefined("CAMBIO") ) >
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select CRMTEapellido1, CRMTEapellido2, CRMTEdireccion, CRMTEapartado, CRMTEtel1, CRMTEtel2, CRMTEtel3, CRMTEemail, CRMTEidentificacion 
		from CRMTipoEntidad
		where CRMTEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMTEid#">
          and CEcodigo = #session.CEcodigo#
		  and Ecodigo  = #session.Ecodigo#
	</cfquery>

	<cfif Len(Trim(form.CRMEimagen)) gt 0 >
		<cfinclude template="imagen.cfm">
	</cfif>	
</cfif>
	
<cfif not isdefined("form.Nuevo") >
	<!---AGREGAR--->
	<cfif isdefined("form.ALTA")>
		<cfquery datasource="#session.DSN#">
			insert CRMEntidad ( CEcodigo, Ecodigo, CRMTEid, CRMEnombre, CRMEapellido1, CRMEapellido2, 
			                    CRMEdireccion, CRMEapartado, CRMEemail, CRMEtel1, CRMEtel2, CRMEtel3, 
								TIcodigo, CRMEidentificacion, CRMEfechaini, CRMEfechafin, 
								CRMEimagen, Usucodigo, Ulocalizacion,CRMEdonacion
							  )
			        values(	#session.CEcodigo#,
					 		#session.Ecodigo#,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMTEid#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEnombre#">,
							<cfif rsDatos.CRMTEapellido1 eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEapellido1#"><cfelse>null</cfif>,
							<cfif rsDatos.CRMTEapellido2 eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEapellido2#"><cfelse>null</cfif>,
							<cfif rsDatos.CRMTEdireccion eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEdireccion#"><cfelse>null</cfif>,
							<cfif rsDatos.CRMTEapartado eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEapartado#"><cfelse>null</cfif>,
							<cfif rsDatos.CRMTEemail eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEemail#"><cfelse>null</cfif>,
							<cfif rsDatos.CRMTEtel1 eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEtel1#"><cfelse>null</cfif>,
							<cfif rsDatos.CRMTEtel2 eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEtel2#"><cfelse>null</cfif>,
							<cfif rsDatos.CRMTEtel3 eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEtel3#"><cfelse>null</cfif>,
							<cfif rsDatos.CRMTEidentificacion eq '1'><cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#"><cfelse>null</cfif>,
							<cfif rsDatos.CRMTEidentificacion eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEidentificacion#"><cfelse>null</cfif>,
							convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEfechaini#">, 103),
							convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEfechafin#">, 103),
							<cfif isdefined("ts")>#ts#<cfelse>null</cfif>,
							null,
							null,
		 					 <cfif isdefined("form.CRMEdonacion")>1<cfelse>0</cfif>
						  )
		</cfquery>
	<!---MODIFICAR--->
	<cfelseif isdefined("form.CAMBIO") >
			<cfquery datasource="#session.DSN#">
				update CRMEntidad
				set	CRMTEid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMTEid#">,
					CRMEnombre 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEnombre#">,
					CRMEapellido1 		= <cfif rsDatos.CRMTEapellido1 eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEapellido1#"><cfelse>null</cfif>,
					CRMEapellido2 		= <cfif rsDatos.CRMTEapellido2 eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEapellido2#"><cfelse>null</cfif>,
					CRMEdireccion 		= <cfif rsDatos.CRMTEdireccion eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEdireccion#"><cfelse>null</cfif>,
					CRMEapartado 		= <cfif rsDatos.CRMTEapartado eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEapartado#"><cfelse>null</cfif>,
					CRMEemail 			= <cfif rsDatos.CRMTEemail eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEemail#"><cfelse>null</cfif>,
					CRMEtel1 			= <cfif rsDatos.CRMTEtel1 eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEtel1#"><cfelse>null</cfif>,
					CRMEtel2 			= <cfif rsDatos.CRMTEtel2 eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEtel2#"><cfelse>null</cfif>,
					CRMEtel3 			= <cfif rsDatos.CRMTEtel3 eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEtel3#"><cfelse>null</cfif>,
					TIcodigo 			= <cfif rsDatos.CRMTEidentificacion eq '1'><cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#"><cfelse>null</cfif>,
					CRMEidentificacion 	= <cfif rsDatos.CRMTEidentificacion eq '1'><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEidentificacion#"><cfelse>null</cfif>,
					CRMEfechaini 		= convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEfechaini#">, 103),
					CRMEfechafin 		= convert( datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRMEfechafin#">, 103),
					CRMEdonacion 		= <cfif isdefined("form.CRMEdonacion")>1<cfelse>0</cfif>
					<cfif isdefined("ts")>,CRMEimagen = #ts#</cfif>
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
				  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
				  and CRMEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMEid#" >
		</cfquery>
			<cfset modo = "CAMBIO">
	<!---ELIMINAR--->
	<cfelseif isdefined("form.BAJA")>	
		<cfquery datasource="#session.DSN#">
			delete from CRMEntidad
			where CEcodigo = #session.CEcodigo#
			  and Ecodigo  = #session.Ecodigo#
			  and CRMEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMEid#" >
		</cfquery>
		</cfif>
</cfif>

<cfoutput>
<form action="Entidad.cfm" method="post">
	<input type="hidden" name="modo" value="#modo#">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="CRMEid" value="#form.CRMEid#">
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