<cfset modo = "ALTA">
<!----================ TRADUCCION ===============--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_no_puede_ser_creada_porque_se_encuentra_contemplada_en_un_intervalo_existente"
	Default=" no puede ser creada porque se encuentra contemplada en el intervalo de una ya existe para el empleado."	
	returnvariable="LB_no_puede_ser_creada_porque_se_encuentra_contemplada_en_un_intervalo_existente"/>

<!--- Verificacion de si el usuario actual tiene derechos para planificar jornadas --->
<cfquery name="rsPermisoPlanificar" datasource="#Session.DSN#">
	select 1
	from DatosEmpleado a, LineaTiempo lt, RHPlazas r, RHUsuariosMarcas um
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.Ecodigo = lt.Ecodigo
	and a.DEid = lt.DEid
	and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJfinicio)#"> between lt.LTdesde and lt.LThasta
	and lt.Ecodigo = r.Ecodigo
	and lt.RHPid = r.RHPid
	and r.Ecodigo = um.Ecodigo
	and r.CFid = um.CFid
	and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and um.RHUMpjornadas = 1
</cfquery>

<cfif rsPermisoPlanificar.recordCount GT 0>

	<cfif not isdefined("Form.btnNuevo")>
		<cftransaction>
		<cftry>
			<!--- Agregar Planificación de Jornada --->
			<cfif isdefined("Form.Alta")>
				<cfquery name="rsVerifica" datasource="#session.DSN#">
					select 1 
					from RHPlanificador x
					where x.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					and x.RHPJfinicio <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJffinal)#">
					and x.RHPJffinal >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJfinicio)#">
				</cfquery>
				
				<cfif rsVerifica.RecordCount EQ 0>
					<cfquery name="ABC_Planificador" datasource="#Session.DSN#">
						insert RHPlanificador (DEid, RHJid, RHPJfinicio, RHPJffinal, RHPJusuario, RHPJfregistro)
						select 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#">, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJfinicio)#">, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJffinal)#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
						from DatosEmpleado a, LineaTiempo lt, RHPlazas r, RHUsuariosMarcas um
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
						and a.Ecodigo = lt.Ecodigo
						and a.DEid = lt.DEid
						and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJfinicio)#"> between lt.LTdesde and lt.LThasta
						and lt.Ecodigo = r.Ecodigo
						and lt.RHPid = r.RHPid
						and r.Ecodigo = um.Ecodigo
						and r.CFid = um.CFid
						and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						and um.RHUMpjornadas = 1
						and not exists (
										select 1
										from RHPlanificador x
										where x.DEid = a.DEid
										and (<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJfinicio)#"> between x.RHPJfinicio and x.RHPJffinal
										or <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJffinal)#"> between x.RHPJfinicio and x.RHPJffinal)
									)
					</cfquery>	
				<cfelse>
					<cfquery name="rsJornada" datasource="#session.DSN#">
						select {fn concat(RHJcodigo,{fn concat(' - ',RHJdescripcion)})} as Jornada
						from RHJornadas
						where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
					</cfquery>
					<cfoutput>
						<cf_throw message="#rsJornada.Jornada# : #LB_no_puede_ser_creada_porque_se_encuentra_contemplada_en_un_intervalo_existente#" errorcode="4045">
					</cfoutput>
				</cfif>			
				
				<cfset modo = 'ALTA'>
				
			<!--- Actualizar Planificación de Jornada --->
			<cfelseif isdefined("Form.Cambio")>
				<cfquery name="rsVerifica" datasource="#session.DSN#">
					select 1 from RHPlanificador x
					where x.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
						and RHPJid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPJid#">
						and (<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJfinicio)#"> between x.RHPJfinicio and x.RHPJffinal
							or <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJffinal)#"> between x.RHPJfinicio and x.RHPJffinal)							
				</cfquery>
				<cfif rsVerifica.RecordCount EQ 0>
					<cfquery name="ABC_Planificador" datasource="#Session.DSN#">						
						update RHPlanificador set 
							RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#">, 
							RHPJfinicio = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJfinicio)#">,
							RHPJffinal = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJffinal)#">
						where RHPJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPJid#">
						  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
					</cfquery>
				</cfif>
				<cfset modo = 'CAMBIO'>
					  
			<!--- Borrar una Jornada --->
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="ABC_Planificador" datasource="#Session.DSN#">
					delete from RHPlanificador
					where RHPJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPJid#">
				</cfquery>
				<cfset modo = 'ALTA'>
				
			</cfif>
	
		<cfcatch type="any">
			<cfinclude template="/sif/errorPages/BDerror.cfm">
			<cftransaction action="rollback">
			<cfabort>
		</cfcatch>
		</cftry>
		</cftransaction>
	</cfif>	
</cfif>


<cfoutput>
<form action="PlanificaJornadas.cfm" method="post" name="sql">
	<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
		<input name="DEid" type="hidden" value="#Form.DEid#">
	</cfif>
	<cfif modo EQ "CAMBIO">
		<input name="RHPJid" type="hidden" value="#Form.RHPJid#">
	</cfif>
	<input name="PageNum3" type="hidden" value="<cfif isdefined("Form.PageNum3")>#Form.PageNum3#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
