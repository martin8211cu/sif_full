<cfquery name="rsconceptos" datasource="#session.dsn#">
	select IREid
	from RHIndicadoresRegistroE 
	where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>	

<cfquery name="rsempleado" datasource="#session.dsn#">
	 select  a.DEid,  b.REaplicaempleado,coalesce(a.DEidjefe,a.DEid) as DEidjefe ,REaplicajefe
	from RHEmpleadoRegistroE a
	inner join RHRegistroEvaluacion b
		on a.REid = b.REid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.REid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#"> 
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
</cfquery>	

<cftransaction>
<cfif rsempleado.recordcount gt 0>
	<!--- paso 1 carga la tabla de evaluadores por evaluación.--->
	<cfset llave = -1>
	<cfquery name="Insert_Empleados" datasource="#session.dsn#">
	 insert into RHRegistroEvaluadoresE (
		Ecodigo
		,REid
		,DEid
		,REENotae
		,REEaplicae
		,REEevaluadorj
		,REEfinale
		,REENotaj
		,REEaplicaj
		,REEfinalj
		,BMUsucodigo
		,BMfechaalta
	 )
	 values (
	 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsempleado.DEid#">,
		0,
		<cfqueryparam cfsqltype="cf_sql_bit" value="#rsempleado.REaplicaempleado#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsempleado.DEidjefe#">,
		0,
		0,
		<cfqueryparam cfsqltype="cf_sql_bit" value="#rsempleado.REaplicajefe#">,
		0,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	 )
	 <cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="Insert_Empleados">

	<cfif isdefined("Insert_Empleados.identity")>
		<cfset llave = Insert_Empleados.identity>
		<!--- paso 2 carga la tabla de conceptos de evaluación.--->
		<cfloop query="rsconceptos">
			<cfquery name="Insert_conceptos" datasource="#session.dsn#">
				insert into RHConceptosDelEvaluador (
					Ecodigo
					,IREid 
					,REEid
					,REid
					,CDENotae
					,CDENotaj
					,CDERespuestae
					,CDERespuestaj
					,BMfechaalta
					,BMUsucodigo
				 )
				 values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsconceptos.IREid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#llave#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">,
					0,
					0,
					null,
					null,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				 )
			</cfquery>
			<cfdump var="#rsconceptos.IREid#"> <br>
		</cfloop>
		<cfdump var="#Empleado#"><br>
	</cfif>
	<!----============== Enviar correo a participante tanto evaluador como evaluando ==============---->	
	<!----Obtener las cuentas de correo de los participantes en la relacion---->
	<cfquery name="rsDatos" datasource="#session.DSN#"	>
		select 	distinct b.DEid, 
						 ltrim(rtrim(c.DEemail)) as DEemail, 
						 a.REdesde, 
						 a.REhasta, 
						 a.REdescripcion,
						 {fn concat( c.DEnombre,
						 			 {fn concat( ' ',
									 			 {fn concat( c.DEapellido1,
												    		 {fn concat(' ', c.DEapellido2)
												  			 }
														   )
												 }
											   )
									 }
								   )
						 } as Destinatario

		from RHRegistroEvaluacion a

		inner join RHEmpleadoRegistroE b
			on a.REid = b.REid
			and b. EREnoempleado = 0
			and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsempleado.DEid#">
		inner join DatosEmpleado c
			on b.DEid = c.DEid

		where a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

		union all

		select 	distinct b.DEidjefe,
				ltrim(rtrim(c.DEemail)), 
				a.REdesde, 
				a.REhasta, 
				a.REdescripcion,
				{fn concat(c.DEnombre,{fn concat(' ',{fn concat(c.DEapellido1,{fn concat(' ',c.DEapellido2)})})})} as Destinatario

		from RHRegistroEvaluacion a

		inner join RHEmpleadoRegistroE b
			on a.REid = b.REid
			and b.DEidjefe is not null
			and b.EREnojefe = 0				
			and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsempleado.DEid#">
		inner join DatosEmpleado c
			on b.DEidjefe = c.DEid

		where a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">				
	</cfquery>		

	<cfloop query="rsDatos"><!---Para cada empleado de la relacion--->
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
					<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
						<tr>
							<td colspan="7">
								<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
									<tr>
										<td nowrap width="6%"><strong><cf_translate key="LB_De">De:</cf_translate></strong></td>										
										<td width="94%"><cfoutput>#session.Enombre#</cfoutput></td>
									</tr>
									<tr>
										<td><strong><cf_translate key="LB_Para">Para:</cf_translate></strong></td>
										<td><cfoutput>#rsDatos.Destinatario#</cfoutput></td>
									</tr>
									<tr>
										<td nowrap><strong><cf_translate key="LB_Asunto">Asunto:</cf_translate></strong></td>
										<td><cfoutput><cf_translate key="LB_HabilitaEvaluacion">Habilitaci&oacute;n de Evaluaci&oacute;n</cf_translate></cfoutput></td>	
									</tr>																			
								</table>
							</td>
						</tr>	
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td width="2%">&nbsp;</td>
							<td colspan="6" width="98%">
								Sr(a)/ Srta:&nbsp;<cfoutput>#rsDatos.Destinatario#</cfoutput>. <br><br>
								Se le habilit&oacute; la evaluaci&oacute;n&nbsp;<cfoutput>#rsDatos.REdescripcion#</cfoutput>.&nbsp;&nbsp;
								La cual tiene vigencia a partir del <cfoutput>#LSDateFormat(rsDatos.REdesde,'dd/mm/yyyy')#</cfoutput> hasta el d&iacute;a  <cfoutput>#LSDateFormat(rsDatos.REhasta,'dd/mm/yyyy')#</cfoutput>.<br><br>
								Por favor entrar en autogesti&oacute;n para continuar con el correspondiente proceso.
							</td>
						</tr>	
						<tr><td colspan="7">&nbsp;</td></tr>
						<tr><td colspan="7">&nbsp;</td></tr>						
					</table>
				</body>
			</html>
		</cfsavecontent>			
		<cfset email_subject = 'Habilitacion de evaluacion'>
		<cfset email_to = rsDatos.DEemail>
		<cfset Email_remitente = "gestion@soin.co.cr">
		
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
	</cfloop><!---Fin del loop de empleados---->
</cfif>
</cftransaction>