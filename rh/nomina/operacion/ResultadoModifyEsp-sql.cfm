<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.IAlta")>
			<cfquery name="sqlIncidencia" datasource="#Session.DSN#">
				insert into Incidencias (DEid, CIid, CFid, Ifecha,Ivalor,Ifechasis,Usucodigo, Ulocalizacion, RHJid)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">, 
					<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#"><cfelse>null</cfif>, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDatetime(Form.ICfecha)#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.ICvalor#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
					<cfif isdefined("form.RHJid") and len(trim(form.RHJid)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#"><cfelse>null</cfif>	 
				)
			</cfquery>		
			
			<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo"
				datasource="#session.dsn#"
				Ecodigo = "#Session.Ecodigo#"
				RCNid = "#Form.RCNid#"
				Tcodigo = "#Form.Tcodigo#"
				Usucodigo = "#Session.Usucodigo#"
				Ulocalizacion = "#Session.Ulocalizacion#"
				pDEid = "#Form.DEid#" />
		<cfelseif isdefined("Form.Alta")>
			<cfquery name="sqlIncidencia" datasource="#Session.DSN#">
				insert into DeduccionesEmpleado ( DEid, TDid, Ecodigo, SNcodigo, Ddescripcion, Dmetodo, Dvalor, Dfechaini, Dfechafin, 
											 Dmonto, Dtasa, Dsaldo, Dmontoint, Destado, Usucodigo, Ulocalizacion, Dactivo, Dcontrolsaldo,
											 Dreferencia  )
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ddescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dmetodo#">,					
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dvalor#">,
					convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Dfechaini#">, 103),
					convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Dfechafin#">, 103),
					<cfif isdefined("form.Dcontrolsaldo")><cfqueryparam cfsqltype="cf_sql_money" value="#form.Dmonto#"><cfelse>0</cfif>,
					<cfif isdefined("form.Dcontrolsaldo")><cfqueryparam cfsqltype="cf_sql_float" value="#form.Dtasa#"><cfelse>0</cfif>,
					<cfif isdefined("form.Dcontrolsaldo")><cfqueryparam cfsqltype="cf_sql_money" value="#form.Dsaldo#"><cfelse>0</cfif>,
					<cfif isdefined("form.Dcontrolsaldo")><cfqueryparam cfsqltype="cf_sql_money" value="#form.Dmontoint#"><cfelse>0</cfif>,
					1, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
					<cfif isdefined("form.Dactivo")>1<cfelse>0</cfif>,
					<cfif isdefined("form.Dcontrolsaldo")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Dreferencia#" null="#Len(Trim(Form.Dreferencia)) EQ 0#">
				)
			</cfquery>		

			<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo"
				datasource="#session.dsn#"
				Ecodigo = "#Session.Ecodigo#"
				RCNid = "#Form.RCNid#"
				Tcodigo = "#Form.Tcodigo#"
				Usucodigo = "#Session.Usucodigo#"
				Ulocalizacion = "#Session.Ulocalizacion#"
				pDEid = "#Form.DEid#" />
		<cfelse>
			<!--- nada --->
		</cfif>

	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="ResultadoModifyEsp-form.cfm" method="post" name="sql">
	<cfoutput>
		<input name="RCNid" type="hidden" value="#Form.RCNid#">
		<input name="Tcodigo" type="hidden" value="#Form.Tcodigo#">
		<input name="DEid" type="hidden" value="#Form.DEid#">		
	</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
 
