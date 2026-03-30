<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ErrorLaRelacion"
	Default="Error, la relación "
	returnvariable="MSG_ErrorLaRelacion"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ConFechaDeInicio"
	Default="con fecha de inicio"
	returnvariable="MSG_ConFechaDeInicio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_YFechaFinal"
	Default="y fecha final"
	returnvariable="MSG_YFechaFinal"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoPoseeEvaluadoresAsociadosProcesoCancelado"
	Default="no posee Evaluadores asociados. Proceso cancelado"
	returnvariable="MSG_NoPoseeEvaluadoresAsociadosProcesoCancelado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HabilitacionDeRelacionDeCalificacion"
	Default="Habilitaci&oacute;n de Relaci&oacute;n de Calificaci&oacute;n"
	returnvariable="LB_HabilitacionDeRelacionDeCalificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Asunto"
	Default="Asunto"
	returnvariable="LB_Asunto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_De"
	Default="De"
	returnvariable="LB_De"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Para"
	Default="Para"
	returnvariable="LB_Para"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CuerpoEmail1"
	Default="Sr(a)/ Srta"
	returnvariable="LB_CuerpoEmail1"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CuerpoEmail2"
	Default="Se le habilit&oacute; la Relaci&oacute;n de Calificaci&oacute;n"
	returnvariable="LB_CuerpoEmail2"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CuerpoEmail3"
	Default="La cual tiene vigencia a partir del "
	returnvariable="LB_CuerpoEmail3"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CuerpoEmail4"
	Default=" hasta el d&iacute;a "
	returnvariable="LB_CuerpoEmail4"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CuerpoEmail5"
	Default="Por favor entrar en autogesti&oacute;n para continuar con el correspondiente proceso."
	returnvariable="LB_CuerpoEmail5"/>	
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined("FORM.BTNHABILITAR")>
	<cftransaction >
	<cfquery name="rsEval_tmp" datasource="#session.DSN#">
		Select 1
		from RHEvaluadoresCalificacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHRCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
	</cfquery>		
	
	
	<!--- SI NO SE HA ASIGNADO LOS EVALUADORES --->
	<cfif isdefined('rsEval_tmp') and rsEval_tmp.recordCount EQ 0>	
		<cfquery name="rsEval_tmp" datasource="#session.DSN#">
			Select RHRCdesc, RHRCfdesde, RHRCfhasta
			from RHRelacionCalificacion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		</cfquery>		

		<cfoutput>
	        <cf_locale name="date" value="#rsEval_tmp.RHRCfdesde#" returnvariable="LvarRHRCfdesde"/>
            <cf_locale name="date" value="#rsEval_tmp.RHRCfhasta#" returnvariable="LvarRHRCfhasta"/>
			<cf_errorCode	code="52136" msg="@errorDat_1@ @errorDat_2@ @errorDat_3@: @errorDat_4@ @errorDat_5@: @errorDat_6@ @errorDat_7@."
							errorDat_1="#MSG_ErrorLaRelacion#"
							errorDat_2="#rsEval_tmp.RHRCdesc#"
							errorDat_3="#MSG_ConFechaDeInicio#"
							errorDat_4="#LvarRHRCfdesde#"
							errorDat_5="#MSG_YFechaFinal#"
							errorDat_6="#LvarRHRCfhasta#"
							errorDat_7="#MSG_NoPoseeEvaluadoresAsociadosProcesoCancelado#"
			>
		</cfoutput>
	</cfif>	
	
	<!--- Modificacion del estado de la relacion a 10 de habilitada --->
	<cfquery datasource="#session.DSN#">
		update RHRelacionCalificacion set
			RHRCestado = 10
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#"> 
	</cfquery>
	<!--- CREA LOS REGISTROS RELACIONADOS CON LA EVALUACION PARA LOS 
		EMPLEADOS Q SE CREARON EN LA RELACION --->
	<cfquery name="rsDatosRelCal" datasource="#session.DSN#">
		select RHRCitems,RHRCestado
		from RHRelacionCalificacion
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 	  and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
	</cfquery>
		
	<!--- RHHabilidadesPuesto --->
	<cfif rsDatosRelCal.RHRCitems EQ 'H' OR rsDatosRelCal.RHRCitems EQ 'A'>
		<cfquery name="data" datasource="#session.DSN#">
			insert into RHEvaluacionComp (RHRCid, CFid, DEid, RHHid, RHCid, nuevanota, Ecodigo, BMUsucodigo, notaant)
			select 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				, a.CFid
				, a.DEid
				, b.RHHid
				, null
				, 0
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				, 0
			from RHEmpleadosCF a
			inner join RHHabilidadesPuesto b
				on a.Ecodigo = b.Ecodigo
				and a.RHPcodigo = b.RHPcodigo
			where a.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		</cfquery>
	</cfif>

	<!--- RHConocimientosPuesto --->
	<cfif rsDatosRelCal.RHRCitems EQ 'C' OR rsDatosRelCal.RHRCitems EQ 'A'>
		<cfquery name="data" datasource="#session.DSN#">
			insert into RHEvaluacionComp (RHRCid, CFid, DEid, RHHid, RHCid, nuevanota, Ecodigo, BMUsucodigo, notaant)
			select 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				, a.CFid
				, a.DEid
				, null
				, b.RHCid
				, 0
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				, 0
			from RHEmpleadosCF a
			inner join RHConocimientosPuesto b
				on a.Ecodigo = b.Ecodigo
				and a.RHPcodigo = b.RHPcodigo
			where a.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		</cfquery>		
	</cfif>

	<!--- Actualizacion del campo de nota anterior de la tabla RHEvaluacionComp --->
	<cfquery name="rsEvalComp" datasource="#session.DSN#">
		Select RHEClinea,RHHid,RHCid,DEid
		from RHEvaluacionComp
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		order by DEid,CFid
	</cfquery>
	
	<cfif isdefined('rsEvalComp') and rsEvalComp.recordCount GT 0>
		<cfloop query="rsEvalComp">
			<!--- Habilidades --->
			<cfif rsEvalComp.RHHid NEQ ''>
				<cfquery name="rsCompetEmpl" datasource="#session.DSN#">
					Select RHCEdominio
					from RHCompetenciasEmpleado
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and tipo = 'H'
						and idcompetencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.RHHid#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.DEid#">
						and getDate() between RHCEfdesde and RHCEfhasta
				</cfquery>
				<cfif isdefined('rsCompetEmpl') and rsCompetEmpl.recordCount GT 0 and rsCompetEmpl.RHCEdominio GT 0>
					<!--- Modificacion de la nota anterior para la habilidad --->
					<cfquery datasource="#session.DSN#">
						update RHEvaluacionComp set
							notaant = <cfqueryparam cfsqltype="cf_sql_money" value="#rsCompetEmpl.RHCEdominio#">
						where RHEClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.RHEClinea#">
					</cfquery>
				</cfif>
			<!--- Conocimientos --->
			<cfelseif rsEvalComp.RHCid NEQ ''>
				<cfquery name="rsCompetEmpl" datasource="#session.DSN#">
					Select RHCEdominio
					from RHCompetenciasEmpleado
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and tipo = 'C'
						and idcompetencia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.RHCid#">
						and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.DEid#">
						and getDate() between RHCEfdesde and RHCEfhasta
				</cfquery>
				<cfif isdefined('rsCompetEmpl') and rsCompetEmpl.recordCount GT 0 and rsCompetEmpl.RHCEdominio GT 0>
					<!--- Modificacion de la nota anterior para la habilidad --->
					<cfquery datasource="#session.DSN#">
						update RHEvaluacionComp set
							notaant = <cfqueryparam cfsqltype="cf_sql_money" value="#rsCompetEmpl.RHCEdominio#">
						where RHEClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalComp.RHEClinea#">
					</cfquery>
				</cfif>				
			</cfif>
		</cfloop>
	</cfif>

	<!--- LLENADO LA TABLA RHEvalPlanSucesion --->
	<cfquery name="rsEmpleadosCF" datasource="#session.DSN#">
		Select ecf.DEid,ecf.CFid,RHRCid
		from RHEmpleadosCF ecf
			inner join RHEmpleadosPlan ep
				on ep.Ecodigo=ecf.Ecodigo
					and ep.DEid=ecf.DEid
					and ep.RHPcodigo=ecf.RHPcodigo
		where ecf.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer"value="#session.Ecodigo#">
			and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		order by DEid,CFid
	</cfquery>		
	
	<cfif isdefined('rsEmpleadosCF') and rsEmpleadosCF.recordCount GT 0>
		<cfloop query="rsEmpleadosCF">
			<cfif rsDatosRelCal.RHRCitems EQ 'H' OR rsDatosRelCal.RHRCitems EQ 'A'>
				<!--- Habilidades de los puestos en el plan de susecion para el empleado --->
				<cfquery name="rsHabPuesto" datasource="#session.DSN#">
					Select RHHid,RHPcodigo
					from RHHabilidadesPuesto
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHPcodigo in (
							Select RHPcodigo
							from RHEmpleadosPlan
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosCF.DEid#">
							)		
				</cfquery>			
				<cfif isdefined('rsHabPuesto') and rsHabPuesto.recordCount GT 0>
					<cfloop query="rsHabPuesto">
						<!--- LLENADO LA TABLA RHEvalPlanSucesion --->
						<cfquery datasource="#session.DSN#">
							insert into RHEvalPlanSucesion 
								(RHRCid, CFid, DEid, RHPcodigo, Ecodigo, RHHid, RHCid, fechaalta, BMUsucodigo, nuevanota, notaant)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosCF.CFid#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosCF.DEid#">
								, <cfqueryparam cfsqltype="cf_sql_char" value="#rsHabPuesto.RHPcodigo#">
								, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHabPuesto.RHHid#">
								, null
								, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								, 0
								, 0)			
						</cfquery>				
					</cfloop>
				</cfif>
			</cfif>
			<cfif rsDatosRelCal.RHRCitems EQ 'C' OR rsDatosRelCal.RHRCitems EQ 'A'>
				<!--- Conocimientos de los puestos en el plan de susecion para el empleado --->
				<cfquery name="rsConPuesto" datasource="#session.DSN#">
					Select RHCid,RHPcodigo
					from RHConocimientosPuesto
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHPcodigo in (
							Select RHPcodigo
							from RHEmpleadosPlan
							where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosCF.DEid#">
							)
				</cfquery>			
				<cfif isdefined('rsConPuesto') and rsConPuesto.recordCount GT 0>
					<cfloop query="rsConPuesto">
						<!--- LLENADO LA TABLA RHEvalPlanSucesion --->
						<cfquery datasource="#session.DSN#">
							insert into RHEvalPlanSucesion 
								(RHRCid, CFid, DEid, RHPcodigo, Ecodigo, RHHid, RHCid, fechaalta, BMUsucodigo, nuevanota, notaant)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosCF.CFid#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosCF.DEid#">
								, <cfqueryparam cfsqltype="cf_sql_char" value="#rsConPuesto.RHPcodigo#">
								, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								, null
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConPuesto.RHCid#">
								, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								, 0
								, 0)			
						</cfquery>				
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>					
	</cfif>
	
	<!--- Modificacion de las notas anteriores para la tabla de RHEvalPlanSucesion --->
	<cfquery name="rsEvalPlanSus" datasource="#session.DSN#">
		Select DEid,CFid,RHHid,RHCid,RHEPSlinea
		from RHEvalPlanSucesion 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHRCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		order by DEid,CFid
	</cfquery>
	
	<cfif isdefined('rsEvalPlanSus') and rsEvalPlanSus.recordCount GT 0>
		<cfloop query="rsEvalPlanSus">
			<!--- Habilidades --->
			<cfif rsEvalPlanSus.RHHid NEQ ''>
				<cfquery name="rsCompetEmpl" datasource="#session.DSN#">
					Select RHCEdominio
					from RHCompetenciasEmpleado
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and tipo = 'H'
						and idcompetencia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.RHHid#">
						and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.DEid#">
						and getDate() between RHCEfdesde and RHCEfhasta
				</cfquery>
				<cfif isdefined('rsCompetEmpl') and rsCompetEmpl.recordCount GT 0 and rsCompetEmpl.RHCEdominio GT 0>
					<!--- Modificacion de la nota anterior para la habilidad --->
					<cfquery datasource="#session.DSN#">
						update RHEvalPlanSucesion set
							notaant=<cfqueryparam cfsqltype="cf_sql_money" value="#rsCompetEmpl.RHCEdominio#">
						where RHEPSlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.RHEPSlinea#">
					</cfquery>
				</cfif>
			<!--- Conocimientos --->
			<cfelseif rsEvalPlanSus.RHCid NEQ ''>
				<cfquery name="rsCompetEmpl" datasource="#session.DSN#">
					Select RHCEdominio
					from RHCompetenciasEmpleado
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and tipo = 'C'
						and idcompetencia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.RHCid#">
						and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.DEid#">
						and getDate() between RHCEfdesde and RHCEfhasta
				</cfquery>
				<cfif isdefined('rsCompetEmpl') and rsCompetEmpl.recordCount GT 0 and rsCompetEmpl.RHCEdominio GT 0>
					<!--- Modificacion de la nota anterior para la habilidad --->
					<cfquery datasource="#session.DSN#">
						update RHEvalPlanSucesion set
							notaant=<cfqueryparam cfsqltype="cf_sql_money" value="#rsCompetEmpl.RHCEdominio#">
						where RHEPSlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvalPlanSus.RHEPSlinea#">
					</cfquery>
				</cfif>				
			</cfif>
		</cfloop>
	</cfif>		
	
	
	<!--- SE ENVIAN LOS CORREOS A LOS EMPLEADOS ASIGNADOS COMO EVALUADORES--->
	<cfquery name="rsEmplCF" datasource="#session.DSN#">
		select distinct RHRCdesc
			, RHRCfdesde
			, RHRCfhasta
			, a.DEid
			, DEemail
			, DEidentificacion
			, {fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as empleado
		from RHEvaluadoresCalificacion a
		inner join RHRelacionCalificacion b
		   on a.Ecodigo = b.Ecodigo 
		  and a.RHRCid  = b.RHRCid
			
		inner join DatosEmpleado de
		   on de.Ecodigo = a.Ecodigo 
		  and de.DEid 	 = a.DEid
		where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHRCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#"> 			
	</cfquery>
	<cfif isdefined('rsEmplCF') and rsEmplCF.recordCount GT 0>
	
		<cfset FromEmail = "gestion@soin.co.cr">
		<cfquery name="CuentaPortal"   datasource="asp">
			Select valor
			from  PGlobal
			Where parametro='correo.cuenta'
		</cfquery>
		<cfif isdefined('CuentaPortal') and CuentaPortal.Recordcount GT 0>
			<cfset FromEmail = CuentaPortal.valor>
		</cfif>
				
		<cfloop query="rsEmplCF">
			<!--- Se arma el cuerpo del mail ---->
			<cfsavecontent variable="email_body">
				<html>
					<head>
						<style type="text/css">
							.tituloIndicacion {
								font-size: 10pt;
								font-variant: small-caps;
								background-color: #CCCCCC;
							}
							.tituloListas {
								font-weight: bolder;
								vertical-align: middle;
								padding: 2px;
								background-color: #F5F5F5;
							}
							.listaNon { background-color:#FFFFFF; vertical-align:middle; padding-left:5px;}
							.listaPar { background-color:#FAFAFA; vertical-align:middle; padding-left:5px;}
							body,td {
								font-size: 12px;
								background-color: #f8f8f8;
								font-family: Verdana, Arial, Helvetica, sans-serif;
							}
						</style>
					</head>
					<body>
						<cfoutput> 
						<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
							<tr>
								<td colspan="7">
									<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
										<tr>
											<td nowrap width="6%"><strong>#LB_De#:</strong></td>										
											<td width="94%"><cfoutput>#session.Enombre#</cfoutput></td>
										</tr>
										<tr>
											<td><strong>#LB_Para#:</strong></td>
											<td><cfoutput>#rsEmplCF.empleado#</cfoutput></td>
										</tr>
										<tr>
											<td nowrap><strong>#LB_Asunto#:</strong></td>
											<td>#LB_HabilitacionDeRelacionDeCalificacion#</td>	
										</tr>																			
									</table>
								</td>
							</tr>	
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td width="2%">&nbsp;</td>
								<td colspan="6" width="98%">
									#LB_CuerpoEmail1#:&nbsp;#rsEmplCF.empleado#. <br><br>
									#LB_CuerpoEmail2#&nbsp;#rsEmplCF.RHRCdesc#.&nbsp;&nbsp;
									#LB_CuerpoEmail3# #LSDateFormat(rsEmplCF.RHRCfdesde,'dd/mm/yyyy')# #LB_CuerpoEmail4#  
									#LSDateFormat(rsEmplCF.RHRCfhasta,'dd/mm/yyyy')#.<br><br>
									#LB_CuerpoEmail5#
								</td>
							</tr>	
							<tr><td colspan="7">&nbsp;</td></tr>
							<tr><td colspan="7">&nbsp;</td></tr>	
						</table>
						</cfoutput>
					</body>
				</html>
			</cfsavecontent>
			
			<cfset email_subject = LB_HabilitacionDeRelacionDeCalificacion>
			<cfset email_to = rsEmplCF.DEemail>
			<cfset Email_remitente = FromEmail>
			
			<cfif email_to NEQ ''>				
				<cfquery datasource="#session.dsn#">						
					insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#Email_remitente#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
				</cfquery>
			</cfif>	
		</cfloop>
	</cfif>
	</cftransaction>
</cfif>	
<cflocation url="actCompetencias.cfm">