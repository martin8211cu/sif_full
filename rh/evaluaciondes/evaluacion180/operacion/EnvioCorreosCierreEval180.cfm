<cfset registros = 0 >

<cfquery name="rsCaches" datasource="asp">
	select distinct c.Ccache
	from 	Empresa e, 
			ModulosCuentaE m, 
			Caches c, 
			SModulos d
	where e.CEcodigo = m.CEcodigo
		and c.Cid = e.Cid
		and m.SScodigo = 'SIF'
		and d.SScodigo=m.SScodigo 
		and d.SMcodigo=m.SMcodigo 
		and d.SMcodigo='CM' 
		and Ereferencia is not null
</cfquery>


<cfloop query="rsCaches"><!---Obtener las empresas de c/cache---->
	<cfset vsCache = trim(rsCaches.Ccache) >	<!---Variable con el cache que se esta procesando----> 
	<cftry>
	<!-----Obtener todas las empresas del cache---->
	<cfquery name="empresas" datasource="#vsCache#">
		select Ecodigo, Edescripcion
		from Empresas
	</cfquery>		
	<cfset continuar = true >
	<cfif continuar>
	<cftransaction>
		<!----Para c/empresa realiza envio de correos---->			
		<cfloop query="empresas">			
			<cfset vnEmpresa = empresas.Ecodigo>			<!----Variable con la empresa a procesar---->
			<cfset vsNombreEmpresa = empresas.Edescripcion>	<!---Variable con el nombre de la empresa---->			

				<cfquery name="rsEvaluaciones" datasource="#vsCache#">
					<!----Empleados evaluados---->
					select distinct b.DEid, c.DEemail, 
									{fn concat(c.DEnombre,{fn concat(' ',{fn concat(c.DEapellido1,{fn concat(' ',c.DEapellido2)})})})} as Destinatario,
									a.REdesde, a.REhasta, a.REdescripcion,
									<cf_dbfunction name="datediff" args="#now()# , a.REhasta" datasource="#vsCache#"> as Diferencia
					from RHRegistroEvaluacion a
						inner join RHEmpleadoRegistroE b
							on a.REid = b.REid
						inner join DatosEmpleado c
							on b.DEid = c.DEid
						inner join RHRegistroEvaluadoresE d
							on b.DEid = d.DEid
							and b.REid = d.REid
							and d.REEfinale = 0	<!---Solo a los empleados que no hayan llenado la evaluacion---->
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vnEmpresa#">
						and a.REestado = 1	<!----Evaluaciones publicadas y NO cerradas----->
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a.REdesde and a.REhasta						
						and a.REdias= <cf_dbfunction name="datediff" args="#now()# , a.REhasta" datasource="#vsCache#">
					
					union 
					<!----Evaluadores de los empleados---->
					select distinct  b.DEidjefe,c.DEemail,
									{fn concat(c.DEnombre,{fn concat(' ',{fn concat(c.DEapellido1,{fn concat(' ',c.DEapellido2)})})})} as Destinatario,
									a.REdesde, a.REhasta,a.REdescripcion,
									<cf_dbfunction name="datediff" args="#now()# , a.REhasta" datasource="#vsCache#"> as Diferencia
					from RHRegistroEvaluacion a
						inner join RHEmpleadoRegistroE b
							on a.REid = b.REid
							and b.DEidjefe is not null
						inner join DatosEmpleado c
							on b.DEidjefe = c.DEid
						inner join RHRegistroEvaluadoresE d
							on b.DEid = d.DEid
							and b.REid = d.REid
							and d.REEfinale = 0 <!---Solo a los evaluadores que no hayan llenado la evaluacion---->
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vnEmpresa#">
						and a.REestado = 1	<!----Evaluaciones publicadas y NO cerradas----->
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a.REdesde and a.REhasta						
						and a.REdias= <cf_dbfunction name="datediff" args="#now()# ,  a.REhasta" datasource="#vsCache#">
				</cfquery>
				
			<cfloop query="rsEvaluaciones">
				<cfif len(trim(rsEvaluaciones.DEemail))> 
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
													<td nowrap width="6%"><strong>De:</strong></td>										
													<td width="94%"><cfoutput>#vsNombreEmpresa#</cfoutput></td>
												</tr>
												<tr>
													<td><strong>Para:</strong></td>
													<td><cfoutput>#rsEvaluaciones.Destinatario#</cfoutput></td>
												</tr>
												<tr>
													<td nowrap><strong>Asunto:</strong></td>
													<td>Cierre de Relaci&oacute;n de Evaluaci&oacute;n &nbsp; <cfoutput>#rsEvaluaciones.REdescripcion#</cfoutput></td>	
												</tr>																			
											</table>
										</td>
									</tr>	
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td width="2%">&nbsp;</td>
										<td colspan="6" width="98%">
											Sr(a)/ Srta: &nbsp;<cfoutput>#rsEvaluaciones.Destinatario#</cfoutput> &nbsp; se le informa que:<br><br>
											A la Relaci&oacute;n de Evaluaci&oacute;n: <cfoutput>#rsEvaluaciones.REdescripcion#</cfoutput>
											le faltan <cfoutput>#rsEvaluaciones.Diferencia#</cfoutput> día(s) para que sea cerrada.<br>
										</td>
									</tr>	
									<tr><td colspan="7">&nbsp;</td></tr>
									<tr><td colspan="7">&nbsp;</td></tr>							
								</table>
							</body>
						</html>
					</cfsavecontent>
					
					<cfset email_subject = "Cierre de Relacion de Evaluacion">
					<cfif len(trim(rsEvaluaciones.DEemail))>
						<cfset email_to = rsEvaluaciones.DEemail>
					</cfif>
					<cfset Email_remitente = "gestion@soin.co.cr">	
					<cfif len(trim(email_to))>				
						<cfquery datasource="#vsCache#">						
							insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
							values (
								<cfqueryparam cfsqltype="cf_sql_varchar" value='#Email_remitente#'>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
						</cfquery>
						<cfset registros = registros + 1>
					</cfif>			
				</cfif>	
			</cfloop>	<!----Fin del loop de evaluaciones---->
		</cfloop>		<!----Fin del loop de Empresas----->
	</cftransaction>
	</cfif>	
	<cfcatch type="any">
		<cfset continuar = false >
	</cfcatch>
	</cftry>	
</cfloop>
<cfabort>
