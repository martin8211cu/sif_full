<cfif isdefined("Form.id_metodo") AND len(form.id_metodo)>
	<cfset Form.id_metodo1=Form.id_metodo>
<cfelseif isdefined("Form.id_metodo1")>
	<cfparam name="Form.id_metodo" default="#Form.id_metodo1#">
<cfelse>
	<cfparam name="Form.id_metodo" default="-1">
</cfif>

<cfobject name="LvarObj" component="home.tramites.componentes.WS">
<cfparam name="LvarMSG1" default="">
<cfparam name="LvarMSG2" default="">

<cfparam name="modo2" default="CAMBIO">
<cfset tab = '2'>

<cfif isdefined("form.btnGuardar")>
	<!--- <cfif not isdefined("form.id_servicio")> --->
		<cfset LvarWS = StructNew()>
		<cfset LvarWS.Url = "#form.con_url#">
		<cfset LvarWS.proxyServer = "#form.proxy_servidor#">
		<cfset LvarWS.proxyPort = "#form.proxy_puerto#">
		<cfset LvarWS.uid = "#form.con_usuario#">
		<cfset LvarWS.pwd = "#form.con_passwd#">

		<cftry>
			<cfset LvarMetodos = LvarObj.fnListaMetodos(LvarWS)>
		<cfcatch type="any">
			<cfset LvarMSG1 = cfcatch.Message>
		</cfcatch>
		</cftry>

			<cftransaction>
				<cfquery name="rsInsert" datasource="#session.tramites.dsn#">
					insert into WSServicio(id_documento, nombre_servicio, con_url, con_usuario, con_passwd, proxy_servidor, proxy_puerto, BMUsucodigo, BMfechamod)
					values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_servicio#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.con_url#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.con_usuario#" 	null="#trim(form.con_usuario) EQ ''#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.con_passwd#" 		null="#trim(form.con_usuario) EQ '' OR trim(form.con_passwd) EQ ''#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.proxy_servidor#" 	null="#trim(form.proxy_servidor) EQ ''#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.proxy_puerto#" 	null="#trim(form.proxy_servidor) EQ '' OR trim(form.proxy_puerto) EQ ''#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
							)
					<cf_dbidentity1 datasource="#session.tramites.dsn#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.tramites.dsn#" name="rsInsert">
				<cfset form.id_servicio = rsInsert.identity>
				<cfif LvarMSG1 EQ "">
					<cfset sbActualizaMetodos (LvarMetodos)>
				</cfif>
			</cftransaction>

	<cfset modo2='CAMBIO'>
	<cfset tab = '2'>
	
<cfelseif isdefined("form.btnModificar")>	
	<cfset LvarWS = StructNew()>
	<cfset LvarWS.Url = "#form.con_url#">
	<cfset LvarWS.proxyServer = "#form.proxy_servidor#">
	<cfset LvarWS.proxyPort = "#form.proxy_puerto#">
	<cfset LvarWS.uid = "#form.con_usuario#">
	<cfset LvarWS.pwd = "#form.con_passwd#">

	<cftry>
		<cfset LvarMetodos = LvarObj.fnListaMetodos(LvarWS)>
	<cfcatch type="any">
		<cfset LvarMSG1 = cfcatch.Message>
	</cfcatch>
	</cftry>

	<cftransaction>
		<cfquery datasource="#session.tramites.dsn#">
			update WSServicio
			 set 
				nombre_servicio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_servicio#">,
				con_url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.con_url#">,
				con_usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.con_usuario#"		null="#trim(form.con_usuario) EQ ''#">,
				con_passwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.con_passwd#"			null="#trim(form.con_usuario) EQ '' OR trim(form.con_passwd)  EQ ''#">,
				proxy_servidor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.proxy_servidor#"	null="#trim(form.proxy_servidor) EQ ''#">,
				proxy_puerto = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.proxy_puerto#" 	null="#trim(form.proxy_servidor) EQ '' OR trim(form.proxy_puerto) EQ ''#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfechamod = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
			where id_servicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_servicio#">
		</cfquery>		
		<cfif LvarMSG1 EQ "">
			<cfset sbActualizaMetodos (LvarMetodos)>
		</cfif>
	</cftransaction>

	<cfset modo2='CAMBIO'>
	<cfset tab = '2'>

	 
<cfelseif isdefined("form.btnEliminar")>	
	<cftransaction>
		<cfquery datasource="#session.tramites.dsn#">
			delete WSDato
			where exists 
				(
					select 1 from WSMetodo m
					 where m.id_servicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_servicio#">
					   and m.id_metodo	 = WSDato.id_metodo
				)
		</cfquery>
		<cfquery datasource="#session.tramites.dsn#">
			delete WSMetodo
			 where id_servicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_servicio#">
		</cfquery>
		<cfquery datasource="#session.tramites.dsn#">
			delete WSServicio
			 where id_servicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_servicio#">
		</cfquery>
	</cftransaction>
	<cfset modo2='ALTA'>
	<cfset tab = '2'>	

<cfelseif isdefined("form.btnNuevo")>
	<cfset modo2 = 'ALTA'>
<cfelseif isdefined("form.btnEliminarDatos")>
		<cfquery datasource="#session.tramites.dsn#">
			update WSMetodo
			   set activo = 0
			where id_metodo = #form.id_metodo1#
		</cfquery>
<cfelseif isdefined("form.btnGuardarDatos")>
	<cftransaction>
		<cfif isdefined("form.id_dato")>
			<cfloop list="#form.id_dato#" index="LvarIdDato">
				<cfset LvarTipoValor 	= evaluate("form.tipo_valor_#LvarIdDato#")>
				<cfset LvarIdCampo 		= evaluate("form.id_campo_#LvarIdDato#")>
				<cfset LvarValor 		= evaluate("form.valor_#LvarIdDato#")>
				<cfif LvarTipoValor EQ "D">
					<cfif isnumeric(LvarIdCampo)>
						<cfset LvarTipoValor 	= "D">
						<cfset LvarValor 		= "">
						<cfset LvarIdCampo 		= LvarIdCampo>
					<cfelse>
						<cfset LvarTipoValor 	= "T">
						<cfset LvarValor 		= LvarIdCampo>
						<cfset LvarIdCampo 		= "">
					</cfif>
				<cfelse>
					<cfset LvarTipoValor 	= "V">
					<cfset LvarValor 		= LvarValor>
					<cfset LvarIdCampo 		= "">
				</cfif>
				<cfquery datasource="#session.tramites.dsn#">
					update WSDato
					   set tipo_valor 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTipoValor#">
						 , id_campo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIdCampo#"	null="#LvarIdCampo EQ ''#">
						 , valor		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarValor#"		null="#LvarValor EQ ''#">
					where id_dato = #LvarIdDato#
				</cfquery>
			</cfloop>
		</cfif>
		<cfquery datasource="#session.tramites.dsn#">
			update WSMetodo
			   set activo = 1
			where id_metodo = #form.id_metodo1#
		</cfquery>
	</cftransaction>
	
	<cfset form.status='1'>
	<cfset modo2='CAMBIO'>
	<cfset tab = '2'>	
<cfelseif isdefined("form.status")>	
		<cfset LvarWS = StructNew()>
		<cfset LvarWS.Url = "#form.con_url#">
		<cfset LvarWS.proxyServer = "#form.proxy_servidor#">
		<cfset LvarWS.proxyPort = "#form.proxy_puerto#">
		<cfset LvarWS.uid = "#form.con_usuario#">
		<cfset LvarWS.pwd = "#form.con_passwd#">

		<cftry>
			<cfset LvarMetodo = LvarObj.fnObtieneMetodo(LvarWS,#form.nombre_metodo#)>
		<cfcatch type="any">
			<cfset LvarMSG2 = cfcatch.Message>
		</cfcatch>
		</cftry>
		<cfif LvarMSG2 EQ "">
			<cfset sbActualizaDatos(LvarMetodo)>
		</cfif>
</cfif>

<form action="Tp_Documentos.cfm" method="post" name="sql">
	<input name="modo2" type="hidden" value="<cfif isdefined("modo2")><cfoutput>#modo2#</cfoutput></cfif>">
	<cfif isdefined("form.btnNuevo")>
		<input name="btnNuevo" type="hidden" value="<cfoutput>#form.btnNuevo#</cfoutput>">
	</cfif>
	
	<cfif isdefined("form.id_servicio")>
		<input name="id_servicio" type="hidden" value="<cfoutput>#form.id_servicio#</cfoutput>">
	</cfif>
	<cfif isdefined("form.status")>
		<cfif isdefined("Form.id_metodo1")>
			<input name="id_metodo1" type="hidden" value="<cfoutput>#form.id_metodo1#</cfoutput>">
		</cfif>
		<input name="nombre_metodo" type="hidden" value="<cfoutput>#form.nombre_metodo#</cfoutput>">
		<input name="clase_input" type="hidden" value="<cfoutput>#form.clase_input#</cfoutput>">
		<input name="clase_output" type="hidden" value="<cfoutput>#form.clase_output#</cfoutput>">
	</cfif>
	
	<input name="id_documento" type="hidden" value="<cfif isdefined("Form.id_documento")><cfoutput>#Form.id_documento#</cfoutput></cfif>">
	<input type="hidden" name="tab" value="<cfoutput>#tab#</cfoutput>">
	<input type="hidden" name="MSG1" value="<cfoutput>#LvarMSG1#</cfoutput>">
	<input type="hidden" name="MSG2" value="<cfoutput>#LvarMSG2#</cfoutput>">
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<cffunction name="sbActualizaMetodos">
	<cfargument name="metodos" type="array" required="yes">
	
	<cfset LvarLstMetodos = "">
	<cfloop index="i" from="1" to="#ArrayLen(Arguments.metodos)#">
		<cfset LvarLstMetodos = LvarLstMetodos & "'#Arguments.metodos[i]#',">
		<cfquery name="rsMetodo" datasource="#session.tramites.dsn#">
			select id_metodo
			  from WSMetodo
			 where id_servicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_servicio#">
			   and nombre_metodo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.metodos[i]#">
		</cfquery>
		<cfif rsMetodo.recordCount EQ 0>
			<cfquery name="rsMetodo" datasource="#session.tramites.dsn#">
				insert into WSMetodo
					( 	
						id_servicio, nombre_metodo, BMUsucodigo, BMfechamod
					)
				values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_servicio#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.metodos[i]#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					)
			</cfquery>
		</cfif>
	</cfloop>
	<cfset LvarLstMetodos = LvarLstMetodos & "'0'">
	<cfquery datasource="#session.tramites.dsn#">
		delete WSDato
		 where exists
			(
				select 1
				  from WSMetodo m
				 where m.id_servicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_servicio#">
				   and m.nombre_metodo not in (#preservesinglequotes(LvarLstMetodos)#)
				   and m.id_metodo = WSDato.id_metodo
			)
	</cfquery>
	<cfquery datasource="#session.tramites.dsn#">
		delete WSMetodo
		 where id_servicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_servicio#">
		   and nombre_metodo not in (#preservesinglequotes(LvarLstMetodos)#)
	</cfquery>
</cffunction>

<cffunction name="sbActualizaDatos">
	<cfargument name="metodo" type="struct" required="yes">

	<cfquery name="rsMetodo" datasource="#session.tramites.dsn#">
		update WSMetodo
		   set 	clase_input  = '#Arguments.metodo.clase_input#',
				clase_output = '#Arguments.metodo.clase_output#'
		 where id_servicio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_servicio#">
		   and id_metodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_metodo1#">
	</cfquery>
	
	<!--- Incluye los Datos de Entrada (Input) o Parametros --->
	<!--- Incluye los Datos de Salida (Output) o Resultados --->
	<cfset LvarDireccionDatos = "InputDatos">
	<cfset LvarDireccion = "I">
	<cfloop index="h" from="1" to="2">
		<cfset LvarLstDatos = "">
		<cfset LvarArray = evaluate("Arguments.metodo.#LvarDireccionDatos#")>
		<cfloop index="i" from="1" to="#ArrayLen(LvarArray)#">
			<cfset LvarLstDatos = LvarLstDatos & "'#LvarArray[i].Nombre#',">
			<cfquery name="rsDato" datasource="#session.tramites.dsn#">
				select id_dato
				  from WSDato
				 where id_metodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_metodo1#">
				   and direccion = '#LvarDireccion#'
				   and nombre_dato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarArray[i].Nombre#">
			</cfquery>
			<cfif rsDato.recordCount EQ 0>
				<cfquery datasource="#session.tramites.dsn#">
					insert into WSDato
						( 	
							id_metodo, nombre_dato, direccion, tipo_dato, valor, BMUsucodigo, BMfechamod
						)
					values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_metodo1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarArray[i].Nombre#">,
							'#LvarDireccion#',
							<cfif LvarArray[i].clase EQ "E">
								'E', <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarArray[i].Tipo#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarArray[i].Tipo#">,
								NULL,
							</cfif>
							
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
						)
				</cfquery>
			</cfif>
		</cfloop>
		<cfset LvarLstDatos = LvarLstDatos & "'0'">
		<cfquery datasource="#session.tramites.dsn#">
			delete WSDato
			 where id_metodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_metodo1#">
			   and direccion = '#LvarDireccion#'
			   and nombre_dato not in (#preservesinglequotes(LvarLstDatos)#)
		</cfquery>
		<cfset LvarDireccionDatos = "OutputDatos">
		<cfset LvarDireccion = "O">
	</cfloop>
</cffunction>