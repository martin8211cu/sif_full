<cfinclude template="../../Utiles/sifConcat.cfm">
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

	<cfset continuar = true >
	<!--- Validación de existencia de las tablas --->
	<cftry>
		
	<cfif continuar>
		<!-----Obtener todas las empresas del cache---->
		<cfquery name="empresas" datasource="#vsCache#">
			select Ecodigo, Edescripcion
			from Empresas
		</cfquery>
		
		<cftransaction>
			<!----Para c/empresa realiza envio de correos---->			
			<cfloop query="empresas">
				
				<cfset vnEmpresa = empresas.Ecodigo>			<!----Variable con la empresa a procesar---->
				<cfset vsNombreEmpresa = empresas.Edescripcion>	<!---Variable con el nombre de la empresa---->			

				<cfif Application.dsinfo[#vsCache#].type EQ 'oracle'><!----Si es oracle---->
					<cfquery name="rsContratos" datasource="#vsCache#">
						select 	a.ECdesc,
								coalesce(d.Pemail1,d.Pemail2) as correoElectronio,
								d.Pnombre#_Cat#' '#_Cat#d.Papellido1 #_Cat#' '#_Cat# d.Papellido2 as NombreUsuario,
								(a.ECfechafin - trunc(sysdate)) as Diferencia,
								a.ECaviso, e.SNnumero #_Cat#' '#_Cat# e.SNnombre as Proveedor
								
						from EContratosCM a
							inner join SNegocios e
								   on a.SNcodigo = e.SNcodigo
								   and a.Ecodigo = e.Ecodigo
								   
							inner join CMContratoNotifica b
								on a.ECid = b.ECid
								and a.Ecodigo = b.Ecodigo
								
								inner join Usuario c	
									on b.Usucodigo = c.Usucodigo 
							
									inner join DatosPersonales d
										on c.datos_personales = d.datos_personales
								
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vnEmpresa#"> 
							and trunc(sysdate) between a.ECfechaini and a.ECfechafin
							and a.ECaviso = (a.ECfechafin - trunc(sysdate))
					</cfquery>
					
				<cfelseif Application.dsinfo[#vsCache#].type EQ 'sybase'><!----Si es sybase---->
					<cfquery name="rsContratos" datasource="#vsCache#">
						select 	a.ECdesc,
								coalesce(d.Pemail1,d.Pemail2) as correoElectronio,
								d.Pnombre#_Cat#' '#_Cat#d.Papellido1 #_Cat#' '#_Cat# d.Papellido2 as NombreUsuario,								
								<cf_dbfunction name="datediff" args="#now()# , a.ECfechafin" datasource="#vsCache#"> as Diferencia,								
								a.ECaviso,  e.SNnumero #_Cat#' '#_Cat# e.SNnombre as Proveedor
								
						from EContratosCM a
						
							inner join SNegocios e
							   on a.SNcodigo = e.SNcodigo
							   and a.Ecodigo = e.Ecodigo
							   
							inner join CMContratoNotifica b
								on a.ECid = b.ECid
								and a.Ecodigo = b.Ecodigo
								
								inner join Usuario c	
									on b.Usucodigo = c.Usucodigo 
							
									inner join DatosPersonales d
										on c.datos_personales = d.datos_personales
																		
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vnEmpresa#"> 							
							and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a.ECfechaini and a.ECfechafin							
							and a.ECaviso = <cf_dbfunction name="datediff" args="#now()# , a.ECfechafin " datasource="#vsCache#">
					</cfquery>
				</cfif>

				<cfloop query="rsContratos">
					<cfif len(trim(rsContratos.correoElectronio))> 
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
														<td><cfoutput>#rsContratos.NombreUsuario#</cfoutput></td>
													</tr>
													<tr>
														<td nowrap><strong>Asunto:</strong></td>
														<td>Vencimiento de contrato&nbsp; <cfoutput>#rsContratos.ECdesc#</cfoutput></td>	
													</tr>																			
												</table>
											</td>
										</tr>	
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td width="2%">&nbsp;</td>
											<td colspan="6" width="98%">
												Sr(a)/ Srta: &nbsp;<cfoutput>#rsContratos.NombreUsuario#</cfoutput> &nbsp; se le informa que:<br><br>
												A el contrato: <cfoutput>#rsContratos.ECdesc#</cfoutput>, del proveedor <cfoutput>#rsContratos.Proveedor#</cfoutput>,
												le faltan <cfoutput>#rsContratos.Diferencia#</cfoutput> 
												día(s) para que se cumpla su vencimiento.<br>
											</td>
										</tr>	
										<tr><td colspan="7">&nbsp;</td></tr>
										<tr><td colspan="7">&nbsp;</td></tr>							
									</table>
								</body>
							</html>
						</cfsavecontent>
						
						<cfset email_subject = "Vencimiento de contrato">
						<cfif len(trim(rsContratos.correoElectronio))>
							<cfset email_to = rsContratos.correoElectronio>
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
				</cfloop>	<!----Fin del loop de contratos---->
			</cfloop>		<!----Fin del loop de Empresas----->
		</cftransaction>	
	</cfif>	
	
	<cfcatch type="any">
		<cfset continuar = false >
	</cfcatch>
	</cftry>
	
</cfloop>
