<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.IAlta")>

			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="1010" default="0" returnvariable="vApInc"/>		
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="1060" default="0" returnvariable="vApIncCal"/>		
	
			<cfquery name="sqlIncidencia" datasource="#Session.DSN#">
				insert  into Incidencias (DEid, CIid, CFid, Ifecha,Ivalor,Ifechasis,Usucodigo, Ulocalizacion, RHJid,Iestado)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">, 
					<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#"><cfelse>null</cfif>, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDatetime(Form.ICfecha)#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.ICvalor#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
					<cfif isdefined("form.RHJid") and len(trim(form.RHJid)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#"><cfelse>null</cfif>,
					<cfif isdefined("form.CItipo") and #form.CItipo# LT 3>
						<cfif #vApInc# EQ 1> 0 <cfelse> 1 </cfif>
					<cfelse>
						<cfif #vApIncCal# EQ 1> 0 <cfelse> 1 </cfif>
					</cfif>
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
			<cfquery name="rsTDeduccionRenta" datasource="#session.DSN#">
				select 1 
				from TDeduccion
				where TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
				and TDrenta > 0
			</cfquery>
			<cfif rsTDeduccionRenta.RecordCount GT 0>
				<cfquery name="rsTDeduccionRentaOtra" datasource="#session.DSN#">
					select 1 
					from DeduccionesEmpleado
					where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					and TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
					and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.Dfechaini)#"> 
						between Dfechaini and Dfechafin
						or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.Dfechafin)#"> 
						between Dfechaini and Dfechafin
						)
				</cfquery>
				<cfif rsTDeduccionRentaOtra.RecordCount GT 0>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_mensajeError"
					Default="Transacción Cancelada. 
						Está definiendo una deducción 
						de tipo renta, pero ya tiene otra
						de tipo renta definida para el rango
						de fechas dado, Proceso Cancelado!"
					returnvariable="LB_mensajeError"/> 
					<cf_throw message="#LB_mensajeError#" errorCode="1150">	
				</cfif>
			</cfif>
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
					<cfif rsTDeduccionRenta.RecordCount EQ 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dmetodo#">
					<cfelse>1</cfif>,
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dvalor#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDatetime(form.Dfechaini)#">,
					<cfif isdefined("form.Dfechafin") and len(trim(form.Dfechafin))>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.Dfechafin)#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/6100">,
					</cfif>
					<cfif isdefined("form.Dcontrolsaldo") and rsTDeduccionRenta.RecordCount EQ 0>
						<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dmonto#"><cfelse>0</cfif>,
					<cfif isdefined("form.Dcontrolsaldo") and rsTDeduccionRenta.RecordCount EQ 0>
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.Dtasa#"><cfelse>0</cfif>,
					<cfif isdefined("form.Dcontrolsaldo") and rsTDeduccionRenta.RecordCount EQ 0>
						<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dsaldo#"><cfelse>0</cfif>,
					<cfif isdefined("form.Dcontrolsaldo") and rsTDeduccionRenta.RecordCount EQ 0>
						<cfqueryparam cfsqltype="cf_sql_money" value="#form.Dmontoint#"><cfelse>0</cfif>,
					1, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
					<cfif isdefined("form.Dactivo")>1<cfelse>0</cfif>,
					<cfif isdefined("form.Dcontrolsaldo") and rsTDeduccionRenta.RecordCount EQ 0>
						1<cfelse>0</cfif>,
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

<form action="ResultadoModify-form.cfm" method="post" name="sql">
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
 
