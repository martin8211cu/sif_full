
	<cfset modo="ALTA">
	<cfif not isdefined("Form.btnNuevo")>
		<cftry>

			<cfif isdefined("form.opcion") and form.opcion eq 'V' >
				<cfif form.ajustevac eq 'S'>
					<cfset vacaciones = form.DVEdisfrutados >
				<cfelse>
					<cfset vacaciones = form.DVEdisfrutados * -1 >
				</cfif>
			<cfelse>
				<cfset vacaciones = 0 >
			</cfif>
			
			<cfif isdefined("form.opcion") and form.opcion eq 'V' >
				<cfif form.ajustecom eq 'S'>
					<cfset compensados = form.DVEcompensados >
				<cfelse>
					<cfset compensados = form.DVEcompensados * -1 >
				</cfif>
			<cfelse>
				<cfset compensados = 0 >
			</cfif>
			
			<cfif isdefined("form.opcion") and form.opcion eq 'E' >
				<cfif form.ajustevac eq 'S'>
					<cfset enfermedad = form.DVEdisfrutados >
				<cfelse>
					<cfset enfermedad = form.DVEdisfrutados * -1 >
				</cfif>
			<cfelse>
				<cfset enfermedad = 0 >
			</cfif>
			
		<cfif isdefined("Form.btnAgregar")>
			<cfquery name="ABC_Vacaciones" datasource="#Session.DSN#">
				insert into DVacacionesEmpleado(DEid, Ecodigo, DVEfecha,DVEdescripcion, DVEdisfrutados, DVEcompensados, DVEenfermedad, DVEmonto, Usucodigo, Ulocalizacion <cfif isdefined("form.DVEperiodo") and len(trim(form.DVEperiodo))>,DVEperiodo</cfif>)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.DVEfecha)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DVEdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#vacaciones#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#compensados#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#enfermedad#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.DVEmonto#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">,
					<cfif isdefined("form.DVEperiodo") and len(trim(form.DVEperiodo))>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.DVEperiodo#">  
					<cfelse>
					null
					</cfif>
				 )	
			</cfquery>
			<!----Actualiza DVacacionesAcum----->
            <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2505" default="0" returnvariable="vCtrlVacXPeriodo"/>
				<cfif vCtrlVacXPeriodo>
				<cfif isdefined("form.opcion") and form.opcion EQ 'V'>
                	<cfquery datasource="#Session.DSN#">
						insert into DVacacionesAcum
							(DEid, DVAdiasPotenciales, DVAperiodo, DVAsaldodias, DVASalarioProm, DVASalarioPdiario, DVAfecha, Ecodigo, DVAmanual)
						values(#form.DEid#, 0, #form.DVEperiodo#, #vacaciones#, 0, 0
						   ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.DVEfecha)#">, #Session.Ecodigo#, 1)
					</cfquery>
                </cfif>
            </cfif>
			<cfset modo="ALTA">			
		</cfif>

		<cfcatch type="any">
			<cfinclude template="/sif/errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>	
	</cfif>

	<cfset actionsc = "expediente-cons.cfm">
	<cfif isdefined("Form.RHAlinea") and Len(Trim(Form.RHAlinea))>
		<cfset actionsc = "ConlisVacaciones.cfm">
	</cfif>

	<form action="<cfoutput>#actionsc#</cfoutput>" method="post" name="sql">
		<cfif isdefined("Form.RHAlinea") and Len(Trim(Form.RHAlinea))>
			<input type="hidden" name="RHAlinea" value="<cfoutput>#form.RHAlinea#</cfoutput>">
		</cfif>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
		<input name="DEid" type="hidden" value="<cfif isdefined("form.DEid")><cfoutput>#form.DEid#</cfoutput></cfif>">			
		<input name="o" type="hidden" value="9">
		<input name="sel" type="hidden" value="1">
	</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
