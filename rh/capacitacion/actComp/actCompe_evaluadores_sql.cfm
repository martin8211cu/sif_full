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
﻿<!--- VERIFICA QUE LOS EMPLEADOS ASIGNADOS COMO JEFES NO ESTÉN ASIGNADOS EN OTRAS EVALUACIONES QUE ESTE EN ESTADO
		HABILITADA O EN PROCESO --->
<cfquery name="rsEmpl" datasource="#session.dsn#">
	Select DEid
	from DatosEmpleado
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and DEid in (#form.EMPLEADOIDLIST#)
		and DEid not in (
			Select DEid
			from RHEvaluadoresCalificacion ec
				inner join RHRelacionCalificacion rc
					on rc.Ecodigo=ec.Ecodigo
						and rc.RHRCid=ec.RHRCid
						and RHRCestado in (0,10)
			where ec.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ec.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
	)
</cfquery>
<!--- SE OBTIENE EL ESTADO DE LA RELACION --->
<cfquery name="rsRelacion" datasource="#session.DSN#">
	select RHRCestado
	from RHRelacionCalificacion
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
</cfquery>
<cfset vEstadoRel = rsRelacion.RHRCestado>

<!--- SE INSERTAN LOS EVALUADORES EN LA TABLA RHEvaluadoresCalificacion --->
<cfif isdefined('rsEmpl') and rsEmpl.recordCount GT 0>
	
	<cfset FromEmail = "gestion@soin.co.cr">
	<cfquery name="CuentaPortal"   datasource="asp">
		Select valor
		from  PGlobal
		Where parametro='correo.cuenta'
	</cfquery>
	<cfif isdefined('CuentaPortal') and CuentaPortal.Recordcount GT 0>
		<cfset FromEmail = CuentaPortal.valor>
	</cfif>
	
	<cfloop query="rsEmpl"> 
		<cfquery datasource="#session.dsn#">
			insert into RHEvaluadoresCalificacion 
				(RHRCid, DEid, Ecodigo, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpl.DEid#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">)
		</cfquery>

		<cfif vEstadoRel EQ 10>
			<!--- CUANDO LA RELACION ESTA HABILITADA Y SE AGREGA UN NUEVO EVALUADOR, SE TIENE QUE ENVIAR UN 
				CORREO, AVISANDO AL EMPLEADO QUE HA SIDO ASIGNADO A UNA RELACION. --->
			<cfquery name="rsEmplCF" datasource="#session.DSN#">
				select distinct RHRCdesc
					, RHRCfdesde
					, RHRCfhasta
					, ec.DEid
					, DEemail
					, DEidentificacion
					, {fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})} as empleado
				from RHEvaluadoresCalificacion ec
					inner join RHRelacionCalificacion rc
						on rc.Ecodigo = ec.Ecodigo 
							and rc.RHRCid=ec.RHRCid
					
					inner join DatosEmpleado de
						on de.Ecodigo = ec.Ecodigo 
						and de.DEid = ec.DEid
				where ec.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and ec.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#"> 			
				  and ec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpl.DEid#">
			</cfquery>
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
			<!---<cfset Email_remitente = "gestion@soin.co.cr">--->
			
			<cfif email_to NEQ ''>				
				<cfquery datasource="#session.dsn#">						
					insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#FromEmail#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
				</cfquery>
			</cfif>	
		</cfif>
	</cfloop>
</cfif>

<cfset params = "">
<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "modo=CAMBIO">
<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "Sel=3">	

<cfif isdefined("form.RHRCid") and len(trim(form.RHRCid)) gt 0>
	<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "RHRCid="  &  form.RHRCid>
</cfif>
	
<cflocation url="actCompetencias.cfm#params#">