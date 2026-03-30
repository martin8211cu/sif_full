<cfset params = '' >

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MG_No_se_puede_publicar_la_evaluacion_porque_hay_empleados_que_no_tienen_evaluador_definido"
Default="No se puede publicar la evaluaci&oacute;n porque hay empleados que no tienen evaluador definido"
returnvariable="MG_No_se_puede_publicar_la_evaluacion_porque_hay_empleados_que_no_tienen_evaluador_definido"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MG_La_evaluacion_ya_fue_publicada_Verifique"
Default="La evaluaci&oacute;n ya fue publicada.Verifique."
returnvariable="MG_La_evaluacion_ya_fue_publicada_Verifique"/> 

<cfif isdefined("form.Anterior")>
	<cflocation url="registro_evaluacion.cfm?REid=#form.REid#&sel=6&Estado=#form.Estado#">
</cfif>

<cfif isdefined("form.PUBLICAR")>
	
	<!----========== Verificar que no hayan empleados sin jefe, si la evaluacion incluye jefe y este no esta marcado como no evaluable =========---->
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select 	a.REaplicajefe,
				(select count(1) 
				from RHEmpleadoRegistroE c
				where a.REid = c.REid
					and c.DEidjefe is null
					and c.EREnojefe = 0
				) as SinJefe,
				REestado
		from RHRegistroEvaluacion a			
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
	<cfif rsVerifica.RecordCount NEQ 0 and rsVerifica.REaplicajefe EQ 1 and rsVerifica.SinJefe NEQ 0>		
		<cf_throw message="#MG_No_se_puede_publicar_la_evaluacion_porque_hay_empleados_que_no_tienen_evaluador_definido#" errorcode="8060">
	<cfelseif rsVerifica.RecordCount NEQ 0 and rsVerifica.REestado EQ 1>		
		<cf_throw message="#MG_La_evaluacion_ya_fue_publicada_Verifique#" errorcode="8065">		
	</cfif>
	<cfif rsVerifica.REaplicajefe EQ 1>
		<!--- CONSULTAS A USUARIO REFERENCIA PARA LOS EMPLEADOS Y LOS EVALUADORES --->
		<cfquery name="rsVerificaUsuRefEmpleado" datasource="#session.DSN#">
			select DEid
			from RHEmpleadoRegistroE ere
			where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and EREnoempleado = 0
			  and not exists (select llave
						from UsuarioReferencia
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
						  and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
						  and llave = <cf_dbfunction name="to_char" args="ere.DEid">
							)
		</cfquery>
		EMPLEADOS <BR>	
		<!--- LLAMADA DE EL COMPONENTE DE SEGURIDAD --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfloop query="rsVerificaUsuRefEmpleado">
			<cfset Lvar_DEid = rsVerificaUsuRefEmpleado.DEid>
			<!--- VERIFICA LA CANTIDAD DE USUARIOS QUE TIENE EL EMPLEADO, ESTO EN EL CASO DE QUE SE GENERE 
					DOS VECES EL EMPLEADO, DOS EMPRESAS DIFERENTES --->
			<cfquery name="rsVerifCantUsu" datasource="#session.DSN#">
				select  b.DEidentificacion, a.Usucodigo,b.DEid
				from Usuario a, DatosEmpleado b, DatosPersonales c, Empresa h
				where c.Pid = b.DEidentificacion
				  and a.datos_personales = c.datos_personales
				  and b.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_DEid#">
				  and h.Ereferencia = b.Ecodigo
				  and h.CEcodigo = a.CEcodigo
			 </cfquery>
			<!--- Asociar Referencia PARA LOS EMPLEADOS QUE NO LA TIENEN --->
			<cfloop query="rsVerifCantUsu">
				<cfset Lvar_Usuario = rsVerifCantUsu.Usucodigo>
				<cfset ref = sec.insUsuarioRef(Lvar_Usuario, Session.EcodigoSDC, 'DatosEmpleado', Lvar_DEid)>
			</cfloop> 
		</cfloop>
		EVALUADORES<BR>
		<!--- BUSCA LOS EVALUADORES QUE NO TIENEN USUARIO REFERENCIA --->
		<cfquery name="rsVerificaUsuRefEvaluadores" datasource="#session.DSN#">
			select DEidjefe as DEid
			from RHEmpleadoRegistroE
			where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and EREnojefe = 0
			  and not exists (select llave
						from UsuarioReferencia
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
						  and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
						  and llave = <cf_dbfunction name="to_char" args="RHEmpleadoRegistroE.DEidjefe">
							)
		</cfquery>
		<cfloop query="rsVerificaUsuRefEvaluadores">
			<cfset Lvar_DEid = rsVerificaUsuRefEvaluadores.DEid>
			
			<cfquery name="rsVerifCantUsu" datasource="#session.DSN#">
				select  b.DEidentificacion, a.Usucodigo,b.DEid
				from Usuario a, DatosEmpleado b, DatosPersonales c, Empresa h
				where c.Pid = b.DEidentificacion
				  and a.datos_personales = c.datos_personales
				  and b.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_DEid#">
				  and h.Ereferencia = b.Ecodigo
				  and h.CEcodigo = a.CEcodigo
			 </cfquery>
			<!--- Asociar Referencia PARA LOS EVALUADORES QUE NO LA TIENEN --->
			<cfloop query="rsVerifCantUsu">
				<cfset Lvar_Usuario = rsVerifCantUsu.Usucodigo>
				<cfset ref = sec.insUsuarioRef(Lvar_Usuario, Session.EcodigoSDC, 'DatosEmpleado', Lvar_DEid)>
			</cfloop> 
		</cfloop>
	</cfif>
	<cfquery name="rsconceptos" datasource="#session.dsn#">
		select IREid
		from RHIndicadoresRegistroE 
		where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
	
	<cfquery name="rsempleados" datasource="#session.dsn#">
		 select  a.DEid,  b.REaplicaempleado,coalesce(a.DEidjefe,a.DEid) as DEidjefe ,REaplicajefe
		from RHEmpleadoRegistroE a
		inner join RHRegistroEvaluacion b
			on a.REid = b.REid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.REid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#"> 
	</cfquery>	
	<cftransaction>
	<cfif rsempleados.recordcount gt 0>
		<!--- paso 1 carga la tabla de evaluadores por evaluación.--->
		<cfset llave = -1>
		<cfloop query="rsempleados">
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
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsempleados.DEid#">,
				0,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#rsempleados.REaplicaempleado#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsempleados.DEidjefe#">,
				0,
				0,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#rsempleados.REaplicajefe#">,
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
				</cfloop>
			</cfif>
		</cfloop>
		
		<cfquery datasource="#session.DSN#">
			delete from RHConceptosDelEvaluador  
			where CDEid  in(
							select  CDEid  
							from RHRegistroEvaluadoresE a 
							inner join RHConceptosDelEvaluador b
								on   a.REid = b.REid
								and  a.REEid = b.REEid
							inner join RHIndicadoresRegistroE c
								on   b.IREid  = c.IREid 
								and (c.IREevaluasubjefe = 1 or
									 c.IREevaluajefe = 1)
							inner join RHIndicadoresAEvaluar d
								on c.IAEid  = d.IAEid 
								and  d.IAEtipoconc = 'T'
							where  a.REid = RHConceptosDelEvaluador.REid
							and a.DEid not in (select DEid
												from RHEmpleadoRegistroE ere
												where ere.REid = a.REid
												  and ere.EREjefeEvaluador = 1)	)
			and RHConceptosDelEvaluador.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
		</cfquery>
		<!--- paso 3 cambia el estado de la evaluacion para publicarla.--->
		<cfquery datasource="#session.DSN#">
			update RHRegistroEvaluacion
			set REestado= 1
			where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>


		<!----============== Paso 4. Enviar correos a participantes tanto evaluadores como evaluandos ==============---->	
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
</cfif>


<cflocation url="registro_evaluacion.cfm">