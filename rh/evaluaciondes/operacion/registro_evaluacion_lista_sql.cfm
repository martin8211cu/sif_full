<cfsetting requesttimeout="36000">
<cfset LISTACHK = ListToArray(FORM.CHK)>

<!--- Toma el correo remitente desde las politicas del portal--->
<cfset FromEmail= "gestion_evaluacion@soin.co.cr">
<cfquery name="CuentaPortal"   datasource="asp">
	Select valor
	from  PGlobal
	Where parametro='correo.cuenta'
</cfquery>
<cfif isdefined('CuentaPortal') and CuentaPortal.Recordcount GT 0>
	<cfset FromEmail = CuentaPortal.valor>
</cfif>	

<cftry>
		<cfloop from="1" to="#ArrayLen(LISTACHK)#" index="i">
		  <cfif isdefined("FORM.ABRIR")>				
				<cfquery name="ABC_Evaluacion_Masivo" datasource="#Session.DSN#">
					update RHEEvaluacionDes
					set RHEEestado = 2
					where Ecodigo = <cfqueryparam value="#SESSION.ECODIGO#" cfsqltype="cf_sql_integer">
					and RHEEid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					and RHEEestado < 2	
				</cfquery>
				<!----Enviar correos---->
				<cfset hostname = session.sitio.host>
				<!----Obtener las cuentas de correo de los empleados en la relacion
				<cfquery name="rsDatos" datasource="#session.DSN#"	>
					select c.RHEEdescripcion,c.RHEEfdesde,c.RHEEfhasta,
						b.DEemail,
						b.DEidentificacion,
						{fn concat(b.DEnombre,{fn concat(' ',{fn concat(b.DEapellido1,{fn concat(' ',b.DEapellido2)})})})} as empleado
					from RHListaEvalDes a
						inner join DatosEmpleado b
							on a.Ecodigo = b.Ecodigo 
							and a.DEid = b.DEid
						inner join RHEEvaluacionDes c
							on b.Ecodigo = c.Ecodigo
							and a.RHEEid = c.RHEEid
					where   a.Ecodigo = <cfqueryparam value="#SESSION.ECODIGO#" cfsqltype="cf_sql_integer">
						and a.RHEEid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cf_dump var = "#rsDatos#">---->
				<cfquery name="rsDatos" datasource="#session.DSN#"	>
					select distinct c.RHEEdescripcion,c.RHEEfdesde,c.RHEEfhasta,
						b.DEemail,
						b.DEidentificacion,
						{fn concat(b.DEnombre,{fn concat(' ',{fn concat(b.DEapellido1,{fn concat(' ',b.DEapellido2)})})})} as empleado
					from RHEvaluadoresDes a
						inner join DatosEmpleado b
							on a.DEideval = b.DEid
						inner join RHEEvaluacionDes c
							on  a.RHEEid = c.RHEEid
					where   c.Ecodigo = <cfqueryparam value="#SESSION.ECODIGO#" cfsqltype="cf_sql_integer">
						and a.RHEEid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
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
													<td nowrap width="6%"><strong>De:</strong></td>										
													<td width="94%"><cfoutput>#session.Enombre#</cfoutput></td>
												</tr>
												<tr>
													<td><strong>Para:</strong></td>
													<td><cfoutput>#rsDatos.empleado#</cfoutput></td>
												</tr>
												<tr>
													<td nowrap><strong>Asunto:</strong></td>
													<td>Habilitaci&oacute;n de evaluaci&oacute;n</td>	
												</tr>																			
											</table>
										</td>
									</tr>	
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td width="2%">&nbsp;</td>
										
										<!---20160712. Con visto bueno de Olman se personaliza Fuente en SOIN.NET para enviar las evaluaciones de Desempeño, pendiente de modo dinámico de hacerse --->                                                                            
                                        <!---
										<td colspan="6" width="98%">
											Estimado Colaborador:&nbsp;<cfoutput>#rsDatos.empleado#</cfoutput>. <br><br>
											
											<p>Como hemos anticipado  para este año hemos iniciado el proceso de evaluación de personal.  Este proceso se lleva a cabo en varias etapas como hemos explicado.</p>
 											<p>En este momento se está habilitando la etapa de la encuesta 360 para medición de las competencias, este es un proceso muy importante en el desarrollo de toda la organización y agradecemos su colaboración.</p>
 
											<p>El proceso de evaluación es por grupos, es decir, algunos de ustedes serán evaluados y otros serán evaluadores.</p> 

											<p>Con este correo se habilitó la evaluación <b><cfoutput>#rsDatos.RHEEdescripcion#</cfoutput></b> la cual tiene vigencia a partir del <b><cf_locale name="date" value="#rsDatos.RHEEfdesde#"/></b> hasta el día  <b><cf_locale name="date" value="#rsDatos.RHEEfhasta#"/></b>.</p>
                                            <br>
											<p>Agradecemos mucho la inversión de un tiempo muy valioso para el sólido crecimiento de nuestra organización.</p>
                                            <br>
											Por favor ingresar al módulo de  Autogestión, por medio del siguiente dirección: <b><a href="https://erp.soin.net">https://erp.soin.net</a></b>, para continuar con el correspondiente proceso.
										</td>
                                        --->
                                        
										<td colspan="6" width="98%">
											Sr(a)/ Srta:&nbsp;<cfoutput>#rsDatos.empleado#</cfoutput>. <br><br>
											Se le habilitó la evaluación&nbsp;<cfoutput>#rsDatos.RHEEdescripcion#</cfoutput>.&nbsp;&nbsp;
											La cual tiene vigencia a partir del <cfoutput><cf_locale name="date" value="#rsDatos.RHEEfdesde#"/></cfoutput> hasta el día  <cfoutput><cf_locale name="date" value="#rsDatos.RHEEfhasta#"/></cfoutput>.<br><br>
											Por favor entrar en autogestión para continuar con el correspondiente proceso.
										</td>
									</tr>	
									<tr><td colspan="7">&nbsp;</td></tr>
									<tr><td colspan="7">&nbsp;</td></tr>
									<!----
									<tr>														
										<td colspan="7">
											<strong>Nota:</strong> En <cfoutput>#hostname#</cfoutput> respetamos su privacidad.
											Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click 
											<a href="http://#hostname#/cfmx/home/public/optout.cfm?b=#CEcodigo#&amp;c=#hostname#&amp;#Hash('please let me out of ' & hostname)#">aqu&iacute;</a>. 
										</td>
									</tr>
									---->					
								</table>
							</body>
						</html>
					</cfsavecontent>
					
					<cfset email_subject = "Habilitación de evaluación">
					<cfset email_to = rsDatos.DEemail>
					<cfset Email_remitente = trim(FromEmail)>
					
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
					
		  <cfelseif isdefined("FORM.CERRAR")>
				<!---========= ACTUALIZAR EL PROMEDIO DE OTROS EVALUADORES (Antes del update contiene la suma de las 
					notas de c/evaluador) =======---->

				<!--- paso 1 verifica que tipo es la relacion  0 POR CONOCIMIENTOS, -1 POR HABILIDADES, -2 POR HABILIDADES Y CONOCIMIENTOS  --->	
				<cfquery name="rsEsPorRHabilidad" datasource="#session.DSN#">
					select PCid as valor ,RHEEfdesde,RHEEdescripcion 
					from RHEEvaluacionDes
					where RHEEid  = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">        
				</cfquery>
				<cfif rsEsPorRHabilidad.recordcount gt 0 and rsEsPorRHabilidad.valor LT 0><!--- -1 POR HABILIDADES, -2 POR HABILIDADES Y CONOCIMIENTOS --->
					<!--- paso 2 si la relacion es por habilidad  busca las habilidades asociadas a la habilidad  por empleado--->	
					<cfquery name="rsRHabilidades" datasource="#session.DSN#">
						select b.DEid,a.RHHid, coalesce(a.RHNEDpromJCS,0)	 as notajcs
						from RHNotasEvalDes a
						inner join RHListaEvalDes b
							on b.RHEEid=a.RHEEid
							and b.DEid=a.DEid
							and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						where a.RHEEid=<cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
						  and a.RHHid is not null
						order by b.DEid,a.RHHid
					</cfquery>
					<!--- paso 3 si hay habilidades por empleado inserta  la información para alimentar el expediente  de capacitación por empleado --->	
					<cfif rsRHabilidades.recordcount gt 0>
						<cfloop query="rsRHabilidades">
							<!--- paso 4 busca si ya tiene una nota para esa habilidad  --->
	
							<cfset fecha = CreateDateTime('6100','01','01', 00,00,0)>
							<cfset fecha2 =DateAdd('d',-1,rsEsPorRHabilidad.RHEEfdesde)>

							<cfquery name="validaInsert" datasource="#session.DSN#">
								select RHCEid 
								from RHCompetenciasEmpleado
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHabilidades.DEid#">
								  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  and idcompetencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsRHabilidades.RHHid#">
								  and tipo ='H'
								  and RHCEfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#" > 
							</cfquery>
							
							
							<cfif validaInsert.recordcount gt 0>
								<!--- paso 5 si tiene  hace un update para que deje de ser el ultimo --->
								<cfquery name="validaInsert" datasource="#session.DSN#">
									update  RHCompetenciasEmpleado  set
									RHCEfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha2#" >
									where  RHCEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#validaInsert.RHCEid#">
								</cfquery>	
							</cfif>

							<!--- paso 6 inserta el nuevo registro --->
							<cfset RHCEjustificacion = 'Evaluación de desempeño - (' & trim(rsEsPorRHabilidad.RHEEdescripcion) & ')'>
							<cfquery name="RHCompetenciasEmpleadoInsert" datasource="#session.DSN#">
								insert into RHCompetenciasEmpleado (
									DEid,
									Ecodigo,
									idcompetencia,
									tipo,
									RHCEfdesde,
									RHCEfhasta,
									RHCEdominio,
									RHCEjustificacion,
									BMUsucodigo,
									BMfecha)
								values(
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHabilidades.DEid#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rsRHabilidades.RHHid#">,
									'H',
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsEsPorRHabilidad.RHEEfdesde#" >,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#" >,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rsRHabilidades.notajcs#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#RHCEjustificacion#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								)
							</cfquery>	
						</cfloop>
					</cfif>
				</cfif>
				<!--- SI ES POR CONOCIMIENTOS --->
				<cfif rsEsPorRHabilidad.recordcount gt 0 and (rsEsPorRHabilidad.valor EQ 0 or rsEsPorRHabilidad.valor EQ -2)><!--- 0 POR CONOCIMIENTOS, -2 POR HABILIDADES Y CONOCIMIENTOS --->
					<!--- paso 2 si la relacion es por habilidad  busca las habilidades asociadas a la habilidad  por empleado--->	
					<cfquery name="rsRConocimientos" datasource="#session.DSN#">
						select b.DEid,a.RHCid, coalesce(a.RHNEDnotajefe,0)	 as nota
						from RHNotasEvalDes a
						inner join RHListaEvalDes b
							on b.RHEEid=a.RHEEid
							and b.DEid=a.DEid
							and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						where a.RHEEid=<cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
						  and a.RHCid is not null
						order by b.DEid,a.RHCid
					</cfquery>
					<!--- paso 3 si hay habilidades por empleado inserta  la información para alimentar el expediente  de capacitación por empleado --->	
					<cfif rsRConocimientos.recordcount gt 0>
						<cfloop query="rsRConocimientos">
							<!--- paso 4 busca si ya tiene una nota para esa habilidad  --->
	
							<cfset fecha = CreateDateTime('6100','01','01', 00,00,0)>
							<cfset fecha2 =DateAdd('d',-1,rsEsPorRHabilidad.RHEEfdesde)>

							<cfquery name="validaInsert" datasource="#session.DSN#">
								select RHCEid 
								from RHCompetenciasEmpleado
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRConocimientos.DEid#">
								  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  and idcompetencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsRConocimientos.RHCid#">
								  and tipo ='C'
								  and RHCEfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#" > 
							</cfquery>
							
							
							<cfif validaInsert.recordcount gt 0>
								<!--- paso 5 si tiene  hace un update para que deje de ser el ultimo --->
								<cfquery name="validaInsert" datasource="#session.DSN#">
									update  RHCompetenciasEmpleado  set
									RHCEfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha2#" >
									where  RHCEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#validaInsert.RHCEid#">
								</cfquery>	
							</cfif>

							<!--- paso 6 inserta el nuevo registro --->
							<cfset RHCEjustificacion = 'Evaluación de desempeño - (' & trim(rsEsPorRHabilidad.RHEEdescripcion) & ')'>
							<cfquery name="RHCompetenciasEmpleadoInsert" datasource="#session.DSN#">
								insert into RHCompetenciasEmpleado (
									DEid,
									Ecodigo,
									idcompetencia,
									tipo,
									RHCEfdesde,
									RHCEfhasta,
									RHCEdominio,
									RHCEjustificacion,
									BMUsucodigo,
									BMfecha)
								values(
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRConocimientos.DEid#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rsRConocimientos.RHCid#">,
									'C',
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsEsPorRHabilidad.RHEEfdesde#" >,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#" >,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rsRConocimientos.nota#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#RHCEjustificacion#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								)
							</cfquery>	
						</cfloop>
					</cfif>
				</cfif>
				<cfquery name="ABC_Evaluacion_Masivo" datasource="#Session.DSN#">
					update RHEEvaluacionDes
					set RHEEestado = 3
					where Ecodigo = <cfqueryparam value="#SESSION.ECODIGO#" cfsqltype="cf_sql_integer">
					and RHEEid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					and RHEEestado = 2
				</cfquery>
		  </cfif>
		</cfloop>

	<!--- genera una anotacion positiva en el expediente --->
	<cfif isdefined("FORM.CERRAR")>
		<cfloop from="1" to="#ArrayLen(LISTACHK)#" index="i">
			<cfquery name="data" datasource="#session.DSN#">
				select RHEEtipoeval, TEcodigo, RHEEdescripcion
				from RHEEvaluacionDes
				where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHEEid = <cfqueryparam value="#listaChk[i]#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset descripcion = 'Obtención de calificación máxima para Evaluación de Desempeño: ' & data.RHEEdescripcion >
			
			<cfif data.RHEEtipoeval eq 'T'>
				<!--- Trae el valor maximo de la tabla de evaluacion --->
				<cfquery name="data_maximo" datasource="#session.DSN#">
					select isnull(max(TEVmaximo),max(TEVequivalente)) as TEVmaximo
					from TablaEvaluacionValor a, TablaEvaluacion b
					where a.TEcodigo=<cfqueryparam value="#data.TEcodigo#" cfsqltype="cf_sql_numeric">
					  and b.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and a.TEcodigo=b.TEcodigo
				</cfquery>
				
				<!--- verifica que haya empleados con calficacion maxima --->
				<cfquery name="data_empleados" datasource="#session.DSN#">
					select DEid
					from RHListaEvalDes a, RHEEvaluacionDes b, TablaEvaluacion c, TablaEvaluacionValor d
					where a.RHEEid = <cfqueryparam value="#listaChk[i]#" cfsqltype="cf_sql_numeric">
					and a.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and d.TEVmaximo = <cfqueryparam value="#data_maximo.TEVmaximo#" cfsqltype="cf_sql_numeric">
					and a.RHEEid=b.RHEEid
					and b.TEcodigo=c.TEcodigo
					and b.Ecodigo=c.Ecodigo
					and c.TEcodigo=d.TEcodigo
					and a.promglobal between isnull(d.TEVminimo, d.TEVequivalente) and isnull(d.TEVmaximo, d.TEVequivalente)
				</cfquery>
	
			<cfelse>
				<cfquery name="data_empleados" datasource="#session.DSN#">
					select DEid
					from RHListaEvalDes
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHEEid = <cfqueryparam value="#listaChk[i]#" cfsqltype="cf_sql_numeric">
					  and promglobal = 100
				</cfquery>
			</cfif>
			
			<cfif isdefined("data_empleados") and data_empleados.RecordCount gt 0>
				<cfquery name="insert_anotacion" datasource="#session.DSN#">
					<cfloop query="data_empleados">
						insert into RHAnotaciones(DEid, RHAfecha, RHAfsistema, RHAdescripcion, Usucodigo, Ulocalizacion, RHAtipo)
						values ( <cfqueryparam value="#data_empleados.DEid#" cfsqltype="cf_sql_numeric">,
								 getDate(),
								 getDate(),
								 <cfqueryparam value="#descripcion#" cfsqltype="cf_sql_varchar">,
								 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
								 '00',
								 1
							   )
					</cfloop>
				</cfquery>
			</cfif>
		</cfloop>	
	</cfif>	

	<cfcatch type="any">
		<cfinclude template="/cfmx/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<cflocation url="registro_evaluacion.cfm">