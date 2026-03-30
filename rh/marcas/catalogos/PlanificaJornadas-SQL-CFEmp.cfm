<!----================ TRADUCCION ===============--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_no_puede_ser_creada_porque_se_encuentra_contemplada_en_un_intervalo_existente"
	Default=" no puede ser creada porque se encuentra contemplada en el intervalo de una ya existe para los empleados seleccionados."	
	returnvariable="LB_no_puede_ser_creada_porque_se_encuentra_contemplada_en_un_intervalo_existente"/>
	
<cfif not isdefined("Form.btnNuevo")>
	<!--- Agregar Planificación de Jornada para los empleados seleccionados al Planificador durante estas fechas --->
	<cfif isdefined("Form.Alta")>
		<cfset emp = ListToArray(Form.chk, ',')>
		<cftransaction>
		<cftry>
			<cfloop from="1" to="#ArrayLen(emp)#" index="i">
				<!---Verificar que no exista ya la jornada asignada al funcionario---->				
				<cfquery name="rsVerifica" datasource="#session.DSN#">
					select count(1)	as cantregistros
					from RHPlanificador pla
					where pla.RHPJfinicio <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJffinal)#">
						and pla.RHPJffinal >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJfinicio)#">
						and pla.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#emp[i]#">
				</cfquery>
				
				<cfif rsVerifica.RecordCount EQ 0 or rsVerifica.cantregistros EQ 0>
					<cfquery name="ABC_Planificador" datasource="#Session.DSN#">
						insert RHPlanificador (DEid, RHJid, RHPJfinicio, RHPJffinal, RHPJusuario, RHPJfregistro)
						select 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#emp[i]#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#">, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJfinicio)#">, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJffinal)#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
						from DatosEmpleado a, LineaTiempo lt, RHPlazas r, RHUsuariosMarcas um
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#emp[i]#">
						and a.Ecodigo = lt.Ecodigo
						and a.DEid = lt.DEid
						and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.LTdesde and lt.LThasta
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
			</cfloop>
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
	<input name="PageNum2" type="hidden" value="<cfif isdefined("Form.PageNum2")>#Form.PageNum2#</cfif>">
	<cfif isdefined("Form.CFid")>
		<input name="CFid" type="hidden" value="#Form.CFid#">
	</cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
