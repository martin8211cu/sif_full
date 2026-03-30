<!----================ TRADUCCION ===============--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_no_puede_ser_creada_porque_en_uno_o_varios_centros_funcionales_genera_traslapes"
	Default=" no puede ser creada porque en uno o varios centros funcionales genera traslapes."	
	returnvariable="LB_no_puede_ser_creada_porque_en_uno_o_varios_centros_funcionales_genera_traslapes"/>
	
<cfif not isdefined("Form.btnNuevo")>
	<!--- Agregar Planificación de Jornada para todos los empleados del Centro Funcional, los cuales no han sido agregados al Planificador durante estas fechas --->
	<cfif isdefined("Form.Alta")>
		<cfset cf = ListToArray(Form.chk, ',')>
		<cftransaction>
		<cftry>
			<cfloop from="1" to="#ArrayLen(cf)#" index="i">
				<!---Verificar que no exista ya la jornada asignada a los funcionarios del centro funcional---->				
				<cfquery name="rsVerifica" datasource="#session.DSN#">
					select count(1)	as cantregistros
					from RHPlanificador pla
					
						inner join DatosEmpleado de
							on pla.DEid = de.DEid
						
							inner join LineaTiempo lt
								on de.DEid = lt.DEid
								and pla.RHPJfinicio between lt.LTdesde  and lt.LThasta
							
								inner join RHPlazas pl
									on lt.RHPid = pl.RHPid
									and pl.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cf[i]#">
					
					where pla.RHPJfinicio <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJffinal)#">
						and pla.RHPJffinal >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJfinicio)#">
						<!---pla.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">---->
				</cfquery>
				
				<cfif rsVerifica.RecordCount EQ 0 or rsVerifica.cantregistros EQ 0>
					<cfquery name="ABC_Planificador" datasource="#Session.DSN#">
						insert RHPlanificador (DEid, RHJid, RHPJfinicio, RHPJffinal, RHPJusuario, RHPJfregistro)
						select de.DEid, 
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHJid#">, 
							   <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJfinicio)#">, 
							   <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJffinal)#">, 
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							   <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
						from DatosEmpleado de, LineaTiempo lt, RHPlazas p, RHUsuariosMarcas um
						where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
						and de.Ecodigo = lt.Ecodigo
						and de.DEid = lt.DEid
						and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHPJfinicio)#"> between lt.LTdesde and lt.LThasta
						and lt.RHPid = p.RHPid
						and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cf[i]#">
						and p.Ecodigo = um.Ecodigo
						and p.CFid = um.CFid
						and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						and um.RHUMpjornadas = 1
						and not exists (
							select 1
							from RHPlanificador x
							where x.DEid = de.DEid
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
					<cf_throw message="#rsJornada.Jornada# : #LB_no_puede_ser_creada_porque_en_uno_o_varios_centros_funcionales_genera_traslapes#" errorcode="4030">
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
	<cfelseif isdefined("form.eliminar") and len(trim(form.eliminar))><!---Eliminar jornada a los funcionarios del centro funcional---->
		<cfquery name="eliminarJornadas" datasource="#session.DSN#">
			delete from RHPlanificador
			from RHPlanificador pla
			
				inner join DatosEmpleado de
					on pla.DEid = de.DEid
				
					inner join LineaTiempo lt
						on de.DEid = lt.DEid
						and pla.RHPJfinicio between lt.LTdesde  and lt.LThasta
					
						inner join RHPlazas pl
							on lt.RHPid = pl.RHPid
							and pl.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			where pla.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Jornada#">
				and pla.RHPJfinicio =	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechaInicial)#">
				and pla.RHPJffinal = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechaFinal)#">			
		</cfquery>
	</cfif>
</cfif>	

<cfoutput>
<form action="PlanificaJornadas.cfm" method="post" name="sql">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
