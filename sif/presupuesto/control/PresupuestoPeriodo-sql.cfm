<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cftransaction>
		<cfif isdefined("Form.Cambio") AND Form.CPPestado NEQ 0>
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="CPresupuestoPeriodo" 
				redirect="PresupuestoPeriodo.cfm"
				timestamp="#form.ts_rversion#"
				field1="CPPid,numeric,#form.CPPid#">
		
			<cfquery name="ABC_PeriodosPresupuesto" datasource="#Session.DSN#">
				update CPresupuestoPeriodo 
				   set CPPestado 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPPestado#"> 
					<cfif isdefined("form.chkCrearCta")>
						, CPPcrearCtaCalculo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboCalculoDefault#">
						, CPPcrearFrmCalculo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboCalculoDefault#">
					<cfelseif isdefined("form.chkCrearFrm")>
						, CPPcrearCtaCalculo	= 0
						, CPPcrearFrmCalculo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboCalculoDefault#">
					<cfelse>
						, CPPcrearCtaCalculo	= 0
						, CPPcrearFrmCalculo	= 0
					</cfif>
				 where CPPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
			</cfquery>		
			
			<cfif Form.CPPestado EQ 1>
				<cfquery name="rsPresupuestosAbiertos" datasource="#Session.DSN#">
					select count(1) as cantidad 
					  from CPresupuestoPeriodo
					 where Ecodigo = #session.Ecodigo#
					   and CPPestado = 1
				</cfquery>		
				<cfif rsPresupuestosAbiertos.cantidad GT 2>
					<cf_errorCode	code = "50475" msg = "No se permite mantener más de 2 Períodos Presupuestarios Abiertos">
				</cfif>
			</cfif>

			<cfset modo="CAMBIO"> 
		<cfelse>
			<cfif isdefined("Form.Alta") or isdefined("Form.Cambio")>
				<cfset fdesde = CreateDate(Form.CPPfechaDesde1, Form.CPPfechaDesde2, 1)>
				<cfset fdesdeYYYYMM = Form.CPPfechaDesde1 & right('00' & Form.CPPfechaDesde2,2)>
				<cfset fhasta = DateAdd('d', -1, DateAdd('m', Form.CPPtipoPeriodo, fdesde))>
				<cfset fhastaYYYYMM = DatePart('yyyy', fhasta) & right('00' & DatePart('m', fhasta),2)>
			</cfif>	
			<cfif isdefined("Form.Alta")>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select count(1) as cantidad
					  from CPresupuestoPeriodo
					 where Ecodigo = #session.Ecodigo#
					   and 	(
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fdesde#">
								between CPPfechaDesde and CPPfechaHasta
							or
							CPPfechaDesde
								between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fdesde#">
									and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fhasta#">
							)
				</cfquery>
				<cfif rsSQL.cantidad GT 0>
					<cf_errorCode	code = "50476" msg = "No se permiten Periodos Presupuestarios traslapados">
				</cfif>
				<cfquery name="ABC_PeriodosPresupuesto" datasource="#Session.DSN#">
					insert INTO CPresupuestoPeriodo (Ecodigo, CPPtipoPeriodo, 
												CPPfechaDesde, CPPanoMesDesde, CPPfechaHasta, CPPanoMesHasta, 
												CPPfechaUltmodif, Mcodigo, CPPestado,
												CPPcrearCtaCalculo, CPPcrearFrmCalculo)
					values (
						#Session.Ecodigo#, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPtipoPeriodo#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fdesde#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#fdesdeYYYYMM#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fhasta#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#fhastaYYYYMM#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPPestado#">,

						<cfif isdefined("form.chkCrearCta")>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboCalculoDefault#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboCalculoDefault#">
						<cfelseif isdefined("form.chkCrearFrm")>
							0, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboCalculoDefault#">
						<cfelse>
							0, 
							0
						</cfif>
					)
					<cf_dbidentity1 verificar_transaccion="false" datasource="#Session.DSN#">
				</cfquery>
				<cf_dbidentity2 name="ABC_PeriodosPresupuesto" verificar_transaccion="false" datasource="#Session.DSN#">
				<cfset Form.CPPid = ABC_PeriodosPresupuesto.identity>
				<cfset modo="ALTA">
	
			<cfelseif isdefined("Form.Baja")>
				<cfquery datasource="#Session.DSN#">
					update CPmeses
					   set CPPid = null
					 where Ecodigo = #session.Ecodigo#
					   and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
				</cfquery>
				<cfquery name="ABC_PeriodosPresupuesto" datasource="#Session.DSN#">
					delete from CPresupuestoPeriodo 
					where CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
				</cfquery>
				<cfset modo="BAJA">
	
			<cfelseif isdefined("Form.Cambio")>
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="CPresupuestoPeriodo" 
					redirect="PresupuestoPeriodo.cfm"
					timestamp="#form.ts_rversion#"
					field1="CPPid,numeric,#form.CPPid#">
			
				<cfquery name="ABC_PeriodosPresupuesto" datasource="#Session.DSN#">
					update CPresupuestoPeriodo set 
						CPPtipoPeriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPtipoPeriodo#">, 
						CPPfechaDesde = <cfqueryparam cfsqltype="cf_sql_date" value="#fdesde#">, 
						CPPanoMesDesde = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fdesdeYYYYMM#">, 
						CPPfechaHasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fhasta#">,
						CPPanoMesHasta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fhastaYYYYMM#">,
						CPPfechaUltmodif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">, 
						CPPestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPPestado#"> 
					<cfif isdefined("form.chkCrearCta")>
						, CPPcrearCtaCalculo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboCalculoDefault#">
						, CPPcrearFrmCalculo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboCalculoDefault#">
					<cfelseif isdefined("form.chkCrearFrm")>
						, CPPcrearCtaCalculo	= 0
						, CPPcrearFrmCalculo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboCalculoDefault#">
					<cfelse>
						, CPPcrearCtaCalculo	= 0
						, CPPcrearFrmCalculo	= 0
					</cfif>
					where CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
				</cfquery>		
				
				<cfset modo="CAMBIO">  				  
			</cfif>			
			<cfif isdefined("Form.Alta") or isdefined("Form.Cambio")>
				<cfquery datasource="#Session.DSN#">
					update CPmeses
					   set CPPid = null
					 where Ecodigo = #session.Ecodigo#
					   and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
				</cfquery>
				<cfloop index="M" from="0" to="#Form.CPPtipoPeriodo-1#">
					<cfset LvarFecha = DateAdd('m', M, fdesde)>
					<cfset LvarAno = DatePart('yyyy', LvarFecha)>
					<cfset LvarMes = DatePart('m', LvarFecha)>
					<cfquery name="rsCPmeses" datasource="#Session.DSN#">
						select count(1) as cantidad
						  from CPmeses
						 where Ecodigo = #session.Ecodigo#
						   and CPCano  = #LvarAno#
						   and CPCmes  = #LvarMes#
					</cfquery>
					<cfif rsCPmeses.cantidad GT 0>
						<cfquery datasource="#Session.DSN#">
							update CPmeses
							   set CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
							 where Ecodigo = #session.Ecodigo#
							   and CPCano  = #LvarAno#
							   and CPCmes  = #LvarMes#
						</cfquery>
					<cfelse>
						<cfquery name="rsCPmeses" datasource="#Session.DSN#">
							insert into CPmeses (Ecodigo, CPCano, CPCmes, CPPid)
								   values (#session.Ecodigo#, #LvarAno#, #LvarMes#, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">)
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>	
		</cfif>
	</cftransaction>
</cfif>

<cfoutput>
<form action="PresupuestoPeriodo.cfm" method="post" name="sql">
	<cfif modo EQ "CAMBIO">
	   	<input name="CPPid" type="hidden" value="#form.CPPid#">
	</cfif>
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")><cfoutput>#Form.PageNum#</cfoutput></cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


