<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document">

<cffunction name="notificarAgente" output="false" returntype="void" access="remote">
	<cfargument name="AGid" type="numeric" required="Yes" displayname="Agente">
	<cfargument name="typenote" type="string" required="Yes" default="P" displayname="Tipo de Notificación (P)reventiva (H)abilitación (I)nhabilitación">

	<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="301" returnvariable="emailFrom"/>
	<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="10" returnvariable="plazoMax"/>

	<cfquery datasource="asp" name="rsCorreo">
		Select valor from PGlobal
		Where rtrim(ltrim(parametro)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="correo.cuenta"> 
	</cfquery>

	<cfquery datasource="#session.DSN#" name="rsAgente">
		Select loc.Pemail,per.Pnombre, per.Papellido, per.Papellido2
			From ISBpersona per
			inner join ISBagente ag
				on per.Pquien = ag.Pquien 
			inner join ISBlocalizacion loc
				on RefId = ag.AGid
				and Ltipo = 'A' 
		Where ag.AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AGid#">
	</cfquery>
	
	<cfquery name="rsContratos" datasource="#session.DSN#">
		Select per.Pid,per.Pnombre,per.Papellido, per.Papellido2, p.CNapertura,
				datediff(dd,p.CNapertura,getDate()) dias,
				(Select coalesce(LGlogin,'_') From ISBlogin x Where x.Contratoid = p.Contratoid and LGprincipal = 1) as login
		from ISBproducto p
			inner join ISBvendedor v
				on v.Vid=p.Vid
				and v.Habilitado=1	
			inner join ISBcuenta cue
				on cue.CTid  = p.CTid
			inner join ISBpersona per
				on per.Pquien = cue.Pquien			
			inner join ISBagente a
				on a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" null="#Len(session.Ecodigo) Is 0#">
					and a.AGid=v.AGid
					and a.Habilitado=1
					and a.AAinterno = 0
		where p.CTcondicion='0'
			and p.CNfechaContrato is null
			<cfif typenote eq 'I'>
						and datediff(dd,p.CNapertura,getDate()) > (Select coalesce(AAplazoDocumentacion,0)
                                                            From ISBagente x
                                                            Where x.AGid = a.AGid) + <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoMax#"> 
			<cfelse>
						and datediff(dd,p.CNapertura,getDate()) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoMax#">
			</cfif>
			and datediff(dd,p.CNapertura,getDate()) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoMax#">
			and a.AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AGid#">
		Order by datediff(dd,p.CNapertura,getDate()) Desc
	</cfquery>	
	
	<cfif Not Len(rsCorreo.valor)>
		<cfthrow message="No existe parámetro (cuenta origen de los correos de salida del portal)">
	</cfif>
	<cfset Email_remitente = rsCorreo.valor>	
			
	<cfif Arguments.typenote eq 'P'>
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
											<td width="94%"><cfoutput>#Email_remitente#</cfoutput></td>
										</tr>
										<tr>
											<td><strong>Para:</strong></td>
											<td><cfoutput>#rsAgente.Pnombre# #rsAgente.Papellido# #rsAgente.Papellido2#</cfoutput></td>
										</tr>
										<tr>
											<td nowrap><strong>Asunto:</strong></td>
											<td>Notificaci&oacute;n</td>	
										</tr>																			
									</table>
								</td>
							</tr>	
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td width="3%">&nbsp;</td>
								<td colspan="6">
									Sr(a)/ Srta: &nbsp;<cfoutput>#rsAgente.Pnombre# #rsAgente.Papellido# #rsAgente.Papellido2#</cfoutput>.<br><br>
									Se le notifica que existen contratos con documentación pendiente de entrega, se detallan a continuaci&oacute;n:
									
								</td>
							</tr>
								<tr>
									<td>&nbsp;</td>
									<td width="11%"><strong>Identificaci&oacute;n</strong></td>
									<td width="24%"><strong>Nombre de Cliente</strong></td>
									<td width="33%"><strong>Fecha de Contrato</strong></td>
									<td width="12%"><strong>Días Pendientes</strong></td>
									<td width="17%"><strong>Login Principal</strong></td>
								</tr>							
								<cfoutput>
									<cfloop query="rsContratos">
										<tr>
											<td>&nbsp;</td>
											<td>#rsContratos.Pid#</td>
											<td>#rsContratos.Pnombre# #rsContratos.Papellido# #rsContratos.Papellido2#</td>
											<td>#LSdateFormat(rsContratos.CNapertura,'dd/mm/yyyy')#</td>
											<td>#rsContratos.dias#</td>
											<td>(#rsContratos.login#)</td>
										</tr>
									</cfloop>
								</cfoutput>													
							<tr><td colspan="6">&nbsp;</td></tr>	
							<tr>
								<td>&nbsp;</td>
								<td colspan = "6">
									<strong>Favor realizar la entrega de la documentación de los contratos lo antes posible, 
									de lo contrario será inhabilitada su cuenta.</strong>
								</td>
							</tr>	
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td colspan = "6">
									<strong>Atentamente,<br> 
									Departamento de Soporte Operativo Comercial<br>
									RACSA.</strong>
								</td>
							</tr>
							<tr><td colspan="7">&nbsp;</td></tr>
							<tr><td colspan="7">&nbsp;</td></tr>							
					</table>
					</body>
				</html>
			</cfsavecontent>
	<cfelseif Arguments.typenote eq 'H'>
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
											<td width="94%"><cfoutput>#Email_remitente#</cfoutput></td>
										</tr>
										<tr>
											<td><strong>Para:</strong></td>
											<td><cfoutput>#rsAgente.Pnombre# #rsAgente.Papellido# #rsAgente.Papellido2#</cfoutput></td>
										</tr>
										<tr>
											<td nowrap><strong>Asunto:</strong></td>
											<td>Notificaci&oacute;n de Habilitaci&oacute;n de acceso al Sistema.</td>	
										</tr>																			
									</table>
								</td>
							</tr>	
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td width="2%">&nbsp;</td>
								<td colspan="6">
									Sr(a)/ Srta: &nbsp;<cfoutput>#rsAgente.Pnombre# #rsAgente.Papellido# #rsAgente.Papellido2#</cfoutput>.<br><br>
									Se le notifica que ha sido habilitado el acceso al Sistema.
									
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td colspan = "6">
									<strong>Atentamente,<br> 
									Departamento de Soporte Operativo Comercial<br>
									RACSA.</strong>
								</td>
							</tr>
							<tr><td colspan="7">&nbsp;</td></tr>
							<tr><td colspan="7">&nbsp;</td></tr>							
						</table>
					</body>
				</html>
			</cfsavecontent>
	
	<cfelseif typenote eq 'I'>
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
											<td width="94%"><cfoutput>#Email_remitente#</cfoutput></td>
										</tr>
										<tr>
											<td><strong>Para:</strong></td>
											<td><cfoutput>#rsAgente.Pnombre# #rsAgente.Papellido# #rsAgente.Papellido2#</cfoutput></td>
										</tr>
										<tr>
											<td nowrap><strong>Asunto:</strong></td>
											<td>Notificaci&oacute;n de Inhabilitaci&oacute;n de Acceso al Sistema.</td>	
										</tr>																			
									</table>
								</td>
							</tr>	
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td width="2%">&nbsp;</td>
								<td colspan="6">
									Sr(a)/ Srta: &nbsp;<cfoutput>#rsAgente.Pnombre# #rsAgente.Papellido# #rsAgente.Papellido2#</cfoutput>.<br><br>
									Se le notifica que fue Inhabilitado  debido a que existen contratos con documentación pendiente de entrega.
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td colspan = "6">
									<strong>Favor realizar la entrega de la documentación de los contratos lo antes posible<br>
										para habilitar de nuevo el acceso al Sistema.</strong>
								</td>
							</tr>	
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td colspan = "6">
									<strong>Atentamente,<br> 
									Departamento de Soporte Operativo Comercial<br>
									RACSA.</strong>
								</td>
							</tr>
							<tr><td colspan="7">&nbsp;</td></tr>
							<tr><td colspan="7">&nbsp;</td></tr>							
						</table>
					</body>
				</html>
		</cfsavecontent>
	</cfif>
		<cfset email_subject = "Noticación Automática.">
		<cfset email_to = rsAgente.Pemail>

		
		<cfif len(trim(email_to))>	
		<cftransaction>
				<cfquery datasource="#session.DSN#">						
					insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#Email_remitente#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
				</cfquery>			
				
				<cfquery datasource="#session.DSN#" name="isbcorreo">
				insert into ISBagenteEmail
					(AGid,AMEinout, AMEfrom, AMEto,
					AMEsubject, AMEbody, AMErecibido, AMEestado,<!--- Registra las notificaciones enviadas --->
					AMEinicio, AMEfin, AMtipo, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AGid#">,
					'out',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Email_remitente#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_to#">,
					
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
					<cfqueryparam cfsqltype="cf_sql_clob" value="#email_body#">,
					getdate(), 'N',

					getdate(), getdate(),
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.typenote#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
				<cf_dbidentity1 datasource="#session.DSN#" name="isbcorreo">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="isbcorreo">
		</cftransaction>	
		</cfif>
						
</cffunction>

<cffunction name="inhabilitarAgente" output="false" returntype="void" access="remote">
  <cfargument name="AGid" type="numeric" required="Yes" displayname="Agente">
  <cfargument name="MStexto" type="string" required="No" displayname="Indica si la Inhabilitación es manual o automática">
  <cfargument name="MBmotivo" type="string" required="No" default="" displayname="Indica el motivo de la Inhabilitación">
  <cfargument name="BLobs" type="string" required="No" default="" displayname="Observaciones de la Inhabilitación">
  <cfargument name="Habilitado" type="numeric" required="No" default="0" displayname="Estado de Inhabilitación">
  
	<cfif Len(Arguments.MBmotivo)>
		<cfset motivo = Arguments.MBmotivo>
	<cfelse>
		<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="228" returnvariable="motivobloqueo"/>
		<cfset motivo = motivobloqueo>
	</cfif>	
		
	<cfquery datasource="#session.dsn#" name="descmotivo">
		Select MBdescripcion 
		from ISBmotivoBloqueo
		Where MBmotivo= <cfqueryparam cfsqltype="cf_sql_char" value="#motivo#" null="#Len(motivo) Is 0#">
	</cfquery>

	<cfif isdefined('descmotivo') and descmotivo.RecordCount gt 0>
		<cfset Arguments.BLobs = #descmotivo.MBdescripcion# & '. ' & #Trim(Arguments.BLobs)#>
	</cfif>
	
	<cftransaction>
		<!--- Se buscan todos los logines asociados al agente --->
		<cfquery datasource="#session.dsn#" name="rsLogines">
			SELECT LGnumero 
			FROM ISBlogin
			WHERE Contratoid in (
					SELECT Contratoid 
					FROM ISBproducto
					WHERE CTid in (
								SELECT CTid 
								FROM ISBcuenta
								WHERE Pquien in (
											select Pquien
											from ISBagente
											where AGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
										)
								)
					)
		</cfquery> 

		<cfif isdefined('rsLogines') and rsLogines.recordCount GT 0>
			<cfif Len(motivo) >
				<!--- Se bloquea todos los logines asociados al agente --->
				<cfloop query="rsLogines">
					<!---Agrega el registro de bloqueo y Bloquea el login--->								
					<cfinvoke component="saci.comp.ISBbloqueoLogin" method="Alta">
						<cfinvokeargument name="LGnumero" value="#rsLogines.LGnumero#">
						<cfinvokeargument name="MBmotivo" value="#motivo#">
						<cfinvokeargument name="BLQdesde" value="#now()#">
						<cfinvokeargument name="BLQhasta" value="1-1-6100">
						<cfinvokeargument name="BLQdesbloquear" value="0">
						<cfinvokeargument name="AGid" value="#Arguments.AGid#">
						<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">						
					</cfinvoke>
				</cfloop>			
			<cfelse>
				<cfthrow message="Error, no existe el motivo de bloqueo en la base de datos para la inhabilitación del Agente.">
			</cfif>
		</cfif>
		
		<!--- inhabilita todos los vendedores por agente 	--->
		<cfinvoke component="saci.comp.ISBvendedor" method="hab_inhabVendXagente">
			<cfinvokeargument name="AGid" value="#Arguments.AGid#">
			<cfinvokeargument name="Habilitado" value="0">
		</cfinvoke>

		<!---  Busqueda del Usucodigo del agente seleccionado  --->
		<cfquery name="rsUsucodigo" datasource="#session.dsn#">
			Select Usucodigo
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
				and STabla='ISBagente'
				and llave=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
		</cfquery>
			
		<cfif isdefined('rsUsucodigo') and rsUsucodigo.recordCount GT 0>
			<!---  Busqueda si ya existe el registro antes de insertarlo en UsuarioBloqueo  --->
			<cfquery name="rsUsuarioBloqueo" datasource="#session.dsn#">
				Select 1
				from UsuarioBloqueo
				where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsucodigo.Usucodigo#">
					and bloqueo=<cfqueryparam cfsqltype="cf_sql_timestamp" value="1-1-6100">
					and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			</cfquery>		
	
			<cfif isdefined('rsUsuarioBloqueo') and rsUsuarioBloqueo.recordCount EQ 0>
				<!---  BLOQUEO DEL USUARIO AGENTE que como pertenece a otro DataSource debe estar fuera de la transaccion	--->
				<cfquery datasource="#session.dsn#">
					insert into UsuarioBloqueo (Usucodigo, bloqueo, CEcodigo, fecha, razon, desbloqueado)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsucodigo.Usucodigo#">
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="1-1-6100">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="agente inhabilitado/bloqueado por el saci">
						, 0)
			   </cfquery>					
			 <cfelse>
				<!---  DESBLOQUEO DEL USUARIO AGENTE que como pertenece a otro DataSource debe estar fuera de la transaccion	--->
				<cfquery datasource="#session.dsn#">
					update UsuarioBloqueo
					set desbloqueado = 0
					where bloqueo   > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsUsucodigo.Usucodigo#">
					  and CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">
					  and desbloqueado = 1
				</cfquery>					 
			</cfif>
		</cfif>
		
		<!---  BLOQUEO DEL AGENTE  --->
 		 <cfquery name="rsdatos" datasource="#session.dsn#">
			Select AAinterno
				From  ISBagente
			Where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
		</cfquery>
		
		<cfquery name="querydatos" datasource="#session.dsn#">
			update ISBagente
				set Habilitado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#"> 
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
		select @@rowcount as update_rowcount
		</cfquery>		
	</cftransaction>	
		
		<cfif querydatos.update_rowcount neq 0 and rsdatos.AAinterno is 0 and #Arguments.Habilitado# is 0>
			<cfinvoke component="saci.comp.ISBagente" method="notificarAgente">
				<cfinvokeargument name="AGid" value="#Arguments.AGid#">
				<cfinvokeargument name="typenote" value="I">
			</cfinvoke>
		</cfif>

</cffunction>

<cffunction name="habilitarAgente" output="false" returntype="void" access="remote">
  <cfargument name="AGid" type="numeric" required="Yes" displayname="Agente">
 <cfargument name="MBmotivo" type="string" required="No" default="" displayname="Indica el motivo de la Inhabilitación">
  
	<cfset motivo = "">

	<cfif Len(Arguments.MBmotivo)>
		<cfset motivo = Arguments.MBmotivo>
	<cfelse>
		<cfquery datasource="#session.dsn#" name="rsMotivosBloqueo">
			Select MBmotivo from ISBmotivoBloqueo
			Where MBagente = 1
		</cfquery>
		
		<cfset motivo = ValueList(rsMotivosBloqueo.MBmotivo,',')>
	</cfif>
  

  
	<cftransaction>
		<!--- Se buscan todos los logines asociados al agente --->
		<cfquery datasource="#session.dsn#" name="rsLogines">
			SELECT LGnumero 
			FROM ISBlogin
			WHERE Contratoid in (
					SELECT Contratoid 
					FROM ISBproducto
					WHERE CTid in (
								SELECT CTid 
								FROM ISBcuenta
								WHERE Pquien in (
											select Pquien
											from ISBagente
											where AGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
										)
								)
					)
		</cfquery> 
		<cfif isdefined('rsLogines') and rsLogines.recordCount GT 0>
			<cfif Listlen(motivo)>
				<!--- Seleccion de los logines a desbloquear --->
				<cfquery datasource="#session.dsn#" name="rsLoginesBloqueados">
					select a.LGnumero, a.BLQid
					from ISBbloqueoLogin a
					where a.LGnumero in (
							SELECT LGnumero 
							FROM ISBlogin
							WHERE Contratoid in (
									SELECT Contratoid 
									FROM ISBproducto
									WHERE CTid in (
												SELECT CTid 
												FROM ISBcuenta
												WHERE Pquien in (
															select Pquien
															from ISBagente
															where AGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
														)
												)
									)							
							)
					and a.BLQdesbloquear = 0	
					and a.MBmotivo in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator=","  value="#motivo#" null="#ListLen(motivo) Is 0#">)
				</cfquery> 			
				
				<cfif isdefined('rsLoginesBloqueados') and rsLoginesBloqueados.recordCount GT 0>
					<!--- Se desbloquean todos los logines bloqueados asociados al agente --->
					<cfloop query="rsLogines">
						<cfquery dbtype="query" name="rsLoginBloq">
							select BLQid
							from rsLoginesBloqueados
							where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLogines.LGnumero#" null="#Len(rsLogines.LGnumero) Is 0#">
						</cfquery>
					
						<cfif isdefined('rsLoginBloq') and rsLoginBloq.recordCount GT 0>
							<cfinvoke component="saci.comp.ISBbloqueoLogin" method="Desbloquear">
								<cfinvokeargument name="BLQid" value="#rsLoginBloq.BLQid#">
								<cfinvokeargument name="BLQhasta" value="#now()#">
								<cfinvokeargument name="MBmotivo" value="#motivo#">
								<cfinvokeargument name="LGnumero" value="#rsLogines.LGnumero#">
							</cfinvoke>						
						</cfif>	
					</cfloop>			
				</cfif>
			<cfelse>
				<cfthrow message="Error, no existe el motivo de bloqueo en la base de datos para la habilitaci&oacute;n del Agente.">				
			</cfif>
		</cfif>
		
		<!---Habilita todos los vendedores por agente 	--->
		<cfinvoke component="saci.comp.ISBvendedor" method="hab_inhabVendXagente">
			<cfinvokeargument name="AGid" value="#Arguments.AGid#">
			<cfinvokeargument name="Habilitado" value="1">
		</cfinvoke>

		<!---  Busqueda del Usucodigo del agente seleccionado  --->
 		<cfquery name="rsUsucodigo" datasource="#session.dsn#">
			Select Usucodigo
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
				and STabla='ISBagente'
				and llave=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
		</cfquery>
			
		<cfif isdefined('rsUsucodigo') and rsUsucodigo.recordCount GT 0>
			<!---  DESBLOQUEO DEL USUARIO AGENTE que como pertenece a otro DataSource debe estar fuera de la transaccion	--->
			<cfquery datasource="#session.dsn#">
				update UsuarioBloqueo
				set desbloqueado = 1
				where bloqueo   > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsUsucodigo.Usucodigo#">
				  and CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.CEcodigo#">
				  and desbloqueado = 0
			</cfquery>				
		</cfif>
		
		<!---  DESBLOQUEO DEL AGENTE  --->
 		<cfquery name="rsdatos" datasource="#session.dsn#">
			Select AAinterno
				From  ISBagente
			Where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
		</cfquery>
		
		<cfquery name="querydatos" datasource="#session.dsn#">
			update ISBagente
				set Habilitado = 1
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
		select @@rowcount as update_rowcount
		</cfquery>		
	</cftransaction>
									
		<cfif querydatos.update_rowcount neq 0 and rsdatos.AAinterno is 0>
			<cfinvoke component="saci.comp.ISBagente" method="notificarAgente">
				<cfinvokeargument name="AGid" value="#Arguments.AGid#">
				<cfinvokeargument name="typenote" value="H">
			</cfinvoke>
		</cfif>
</cffunction>

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="AGid" type="numeric" required="Yes" displayname="Agente">
  <cfargument name="Pquien" type="numeric" required="Yes" displayname="Persona">
  <cfargument name="AAplazoDocumentacion" type="numeric" required="Yes"  displayname="Plazo de documentos">
  <cfargument name="AAprospecta" type="boolean" required="No" default="0"  displayname="Prospecta?">
  <cfargument name="AAcomisionTipo" type="string" required="No" default="" displayname="Tipo de comisión">
  <cfargument name="AAcomisionPctj" type="numeric" required="No"  displayname="% Comisión">
  <cfargument name="AAcomisionMnto" type="numeric" required="No"  displayname="Monto comisión">
  <cfargument name="AAfechacontrato" type="string" required="No"  displayname="Fecha Firma Contrato">
  <cfargument name="AAinterno" type="boolean" required="Yes"  displayname="Es agente interno">
  <cfargument name="Habilitado" type="numeric" required="No" default="0"  displayname="Habilitado">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

	<cf_dbtimestamp datasource="#session.dsn#"
					table="ISBagente"
					redirect="metadata.code.cfm"
					timestamp="#Arguments.ts_rversion#"
					field1="AGid"
					type1="numeric"
					value1="#Arguments.AGid#">

	<cfquery datasource="#session.dsn#">
		update ISBagente
		set Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
		, AAplazoDocumentacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AAplazoDocumentacion#" null="#Len(Arguments.AAplazoDocumentacion) Is 0#">
		
		, AAprospecta = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.AAprospecta#" null="#Len(Arguments.AAprospecta) Is 0#">
		, AAcomisionTipo = <cfif isdefined("Arguments.AAcomisionTipo") and Len(Trim(Arguments.AAcomisionTipo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.AAcomisionTipo#"><cfelse>null</cfif>
		, AAcomisionPctj = <cfif isdefined("Arguments.AAcomisionPctj") and Len(Trim(Arguments.AAcomisionPctj))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AAcomisionPctj#" scale="2"><cfelse>null</cfif>
		, AAcomisionMnto = <cfif isdefined("Arguments.AAcomisionMnto") and Len(Trim(Arguments.AAcomisionMnto))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AAcomisionMnto#" scale="2"><cfelse>null</cfif>
		, AAfechacontrato = <cfif isdefined("Arguments.AAfechacontrato") and Len(Trim(Arguments.AAfechacontrato))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.AAfechacontrato#"><cfelse>null</cfif>
		
		
		, AAinterno = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.AAinterno#" null="#Len(Arguments.AAinterno) Is 0#">
		<!---, Habilitado = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">--->
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
	</cfquery>

</cffunction>


<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="AGid" type="numeric" required="Yes">

	<cfquery datasource="#session.dsn#">
		delete ISBagente
		where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
	</cfquery>
</cffunction>


<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Persona">
  <cfargument name="CTidAcceso" type="numeric" required="No"  displayname="Cuenta acceso">
  <cfargument name="CTidFactura" type="numeric" required="No"  displayname="Cuenta repositorio">
  <cfargument name="AAregistro" type="date" required="No" default="#Now()#" displayname="Registro">
  <cfargument name="AAaprobacion" type="date" required="No" displayname="Fecha de aprobación">
  <cfargument name="AAplazoDocumentacion" type="numeric" required="Yes"  displayname="Plazo de documentos">
  <cfargument name="AAprospecta" type="boolean" required="No" default="0"  displayname="Prospecta?">
  <cfargument name="AAcomisionTipo" type="string" required="No" default="" displayname="Tipo de comisión">
  <cfargument name="AAcomisionPctj" type="numeric" required="No"  displayname="% Comisión">
  <cfargument name="AAcomisionMnto" type="numeric" required="No"  displayname="Monto comisión">
  <cfargument name="AAfechacontrato" type="string" required="No"  displayname="Fecha Firma Contrato">
  <cfargument name="AAinterno" type="boolean" required="Yes"  displayname="Es agente interno">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">
  		
	<cfquery datasource="#session.dsn#" name="rsAlta">
		insert into ISBagente (
			Pquien,
			CTidAcceso,
			CTidFactura,
			AAfechacontrato,
			
			Ecodigo,
			AAregistro,
			AAaprobacion,
			AAplazoDocumentacion,
			
			AAprospecta,
			AAcomisionTipo,
			AAcomisionPctj,
			AAcomisionMnto,
			
			AAinterno,
			Habilitado,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">,
			<cfif isdefined("Arguments.CTidAcceso") and Len(Trim(Arguments.CTidAcceso))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTidAcceso#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CTidFactura") and Len(Trim(Arguments.CTidFactura))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTidFactura#"><cfelse>null</cfif>,
			
		<cfif isdefined("Arguments.AAfechacontrato") and Len(Trim(Arguments.AAfechacontrato))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.AAfechacontrato#"><cfelse>null</cfif>,
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfif isdefined("Arguments.AAregistro") and Len(Trim(Arguments.AAregistro))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.AAregistro#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.AAaprobacion") and Len(Trim(Arguments.AAaprobacion))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.AAaprobacion#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AAplazoDocumentacion#" null="#Len(Arguments.AAplazoDocumentacion) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.AAprospecta#" null="#Len(Arguments.AAprospecta) Is 0#">,
			<cfif isdefined("Arguments.AAcomisionTipo") and Len(Trim(Arguments.AAcomisionTipo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.AAcomisionTipo#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.AAcomisionPctj") and Len(Trim(Arguments.AAcomisionPctj))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AAcomisionPctj#" scale="2"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.AAcomisionMnto") and Len(Trim(Arguments.AAcomisionMnto))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AAcomisionMnto#" scale="2"><cfelse>null</cfif>,
			
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.AAinterno#" null="#Len(Arguments.AAinterno) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
			<cf_dbidentity1 conexion="#Session.DSN#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 conexion="#Session.DSN#" name="rsAlta" verificar_transaccion="false">
			
	<cfif isdefined("rsAlta.identity") and len(trim(rsAlta.identity))>
		<cfreturn rsAlta.identity>
	<cfelse>
		<cfset retorna = -1>
		<cfreturn retorna>
	</cfif>
</cffunction>


<cffunction name="altaValoraciones" output="false" returntype="void" access="remote">
	<cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
	<cfargument name="tipo" type="numeric" required="no" default="1"  displayname="Tipo_de_valoracion">	<!--- 1.positiva 	-1.Negativa --->
	<cfargument name="automatica" type="boolean" required="no" default="1"  displayname="Automatica">	<!--- 1.Si 	0.No --->
  	<cfargument name="observacion" type="string" required="yes" displayname="Texto_de_Observacion">	
  	<cfargument name="conexion" type="string" required="no" default="#session.dsn#"  displayname="Conexion">    
  
  	<cfset LvarHoy = CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 0, 0, 0)>

	<!--- Insertar valoracion negativa para el agente --->
	<cfquery datasource="#Arguments.conexion#">
		insert ISBagenteValoracion (AGid, ANvaloracion, ANautomatica, ANobservacion, ANpuntaje, ANfecha, BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
			, <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.tipo#">
			, <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.automatica#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.observacion#">	
			, <cfqueryparam cfsqltype="cf_sql_integer" value="1">
			, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)
	</cfquery>    
</cffunction>

</cfcomponent>