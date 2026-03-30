<cfset sbDump ("Se Ejecuto el WEB SERVICE")>

<!---
	url.I = id_instancia
	url.R = id_requisito
	url.P = id_persona
--->
<cftry>
	<cfquery name="rsMetodos" datasource="tramites_cr">
		select 	  m.id_metodo
				, s.nombre_servicio
				, s.con_url
				, s.con_usuario
				, s.con_passwd
				, s.proxy_servidor
				, s.proxy_puerto
				, m.nombre_metodo
				, m.clase_input
				, m.clase_output
				, m.activo
				, rm.tipo_proceso
		  from TPRequisitoWSMetodo rm
			  inner join WSMetodo m
				inner join WSServicio s
					on s.id_servicio = m.id_servicio
				 on m.id_metodo = rm.id_metodo
		 where rm.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.R#">
		order by rm.id_requisito, rm.secuencia
	</cfquery>
	<cfquery name="rsRequisito" datasource="tramites_cr">
		select d.id_tipo, t.es_impedimento 
		  from TPRequisito t
		 	left join TPDocumento d
				 on d.id_documento = t.id_documento
		 where t.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.R#">
	</cfquery>

	<cfquery name="rsRegistro" datasource="tramites_cr">
		select coalesce(i.id_registro,-1) as id_registro
		  from TPInstanciaRequisito i
		  	left join DDRegistro r
			 	on r.id_registro = i.id_registro
		 where i.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.I#">
		   and i.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.R#">
	</cfquery>
<cfset sbDump ("#rsRegistro#")>
	<cfquery name="rsPersona" datasource="tramites_cr">
		select p.identificacion_persona
		  from TPPersona p
		 where p.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.P#">
	</cfquery>

	<cfloop query="rsMetodos">
		<cfquery name="rsDatos" datasource="tramites_cr">
			select 	  d.nombre_dato
					, d.direccion
					, d.tipo_dato
					, d.tipo_valor
					, case 
						when d.tipo_valor = 'V' then d.valor
						when d.tipo_valor = 'D' then c.valor
						when d.tipo_valor = 'T' then 
							case 
								when d.valor = 'Cedula' 		then '#rsPersona.identificacion_persona#'
								when d.valor = 'Numero Tramite' then '#url.I#'
							end
					  end as valor
					, d.id_campo
			  from WSDato d
				left join DDCampo c
					 on c.id_campo = d.id_campo
					and c.id_registro = #rsRegistro.id_registro#
			 where d.id_metodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMetodos.id_metodo#">
		</cfquery>
		
		<cfset LvarWS = StructNew()>
	
		<cfset LvarWS.Url 			= "#rsMetodos.con_url#">
		<cfset LvarWS.proxyServer 	= "#rsMetodos.proxy_servidor#">
		<cfset LvarWS.proxyPort 	= "#rsMetodos.proxy_puerto#">
		<cfset LvarWS.uid 			= "#rsMetodos.con_usuario#">
		<cfset LvarWS.pwd 			= "#rsMetodos.con_passwd#">
		<cfset LvarWS.clase_input 	= "#rsMetodos.clase_input#">
		<cfset LvarWS.clase_output	= "#rsMetodos.clase_output#">
		
		<cfset LvarWS.servicio		= "#rsMetodos.nombre_servicio#">
		<cfset LvarWS.nombre		= "#rsMetodos.nombre_metodo#">
		<cfset LvarWS.inputDatos	= ArrayNew(1)>
		<cfset LvarWS.outputDatos	= ArrayNew(1)>
		
		<cfset LvarTipoProceso = rsMetodos.Tipo_proceso>
		
		<cfoutput query="rsDatos">
			<cfif direccion EQ "I">
				<cfset LvarDireccion = "inputDatos">
			<cfelse>
				<cfset LvarDireccion = "outputDatos">
			</cfif>
			<cfset LvarDato = StructNew()>
			<cfset LvarDato.Nombre = nombre_dato>
			<cfset LvarDato.Tipo   = tipo_dato>

			<cfif direccion EQ "I">
				<cfset LvarDato.Valor  = rsDatos.valor>
			<cfelse>
				<cfset LvarDato.id_campo = rsDatos.id_campo>
			</cfif>
			
			<cfset ArrayAppend(LvarWS[LvarDireccion], LvarDato)>
		</cfoutput>

		<cfobject name="LvarObjWS" component="home.tramites.componentes.WS">
		<cfobject name="LvarObjVistas" component="home.tramites.componentes.WS">
		
		<cftry>
			<cfset LvarResultado = LvarObjWS.fnInvocaMetodo (LvarWS, LvarWS)>

			<cfif LvarTipoProceso EQ "3">	<!--- Verifica Existencia --->
				<cfif LvarWS.clase_output EQ "D" AND LvarWS.outputDatos[1].tipo EQ "B">
					<cfset LvarExistencia = evaluate("LvarResultado.#LvarWS.outputDatos[1].nombre#")>
				<cfelse>
					<cfset LvarExistencia = (LvarResultado.recordCount GT 0)>
				</cfif>
				<cfset LvarSatisfecho = NOT rsRequisito.es_impedimento AND LvarExistencia OR rsRequisito.es_impedimento AND NOT LvarExistencia>
				<script language="javascript">
					<cfif rsRequisito.es_impedimento>
						<cfif LvarExistencia>
							alert("El documento Ya existe, el requisito NO ha sido satisfecho");
						<cfelse>
							alert("El documento No existe, el requisito ha sido satisfecho");
						</cfif>
					<cfelse>
						<cfif LvarExistencia>
							alert("El documento Ya existe, el requisito ha sido satisfecho");
						<cfelse>
							alert("El documento No existe, el requisito NO ha sido satisfecho");
						</cfif>
					</cfif>
				</script>
				<cfquery datasource="tramites_cr">
					update TPInstanciaRequisito
					   set <cfif LvarSatisfecho>completado<cfelse>rechazado</cfif> = 1
					 where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.I#">
					   and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.R#">
				</cfquery>
				<cfif NOT LvarSatisfecho>
					<cfbreak>
				</cfif>
			<cfelseif LvarTipoProceso NEQ "0">			<!--- No procesar Resultado --->
				<cfloop query="LvarResultado">
					<cfif LvarTipoProceso EQ "1" AND rsRegistro.id_registro EQ "-1">		<!--- Guardar 1er Resultado en el Tramite Sin Registro --->
						<cfset LvarMethod="insRegistro">
					<cfelseif LvarTipoProceso EQ "1">	<!--- Guardar 1er Resultado en el Tramite --->
						<cfset LvarMethod="updRegistro">
					<cfelseif LvarTipoProceso EQ "2">	<!--- Guardar todos los Resultados en el Expediente --->
						<cfset LvarMethod="insRegistro">
					</cfif>
<cfset sbDump ("#rsMetodos#")>
					<cfinvoke 	component="home.tramites.componentes.vistas"
								method="#LvarMethod#"
								returnvariable="LvarNewIdRegistro"
					>
					<cfif LvarTipoProceso EQ "1" AND rsRegistro.id_registro EQ "-1">		<!--- Guardar 1er Resultado en el Tramite Sin Registro --->
							<cfinvokeargument name="id_tipo" 	value="#rsRequisito.id_tipo#">
							<cfinvokeargument name="id_persona" value="#url.P#">
					<cfelseif LvarTipoProceso EQ "1">		<!--- Guardar 1er Resultado en el Tramite --->
							<cfinvokeargument name="id_registro" 	value="#rsRegistro.id_registro#">
					<cfelseif LvarTipoProceso EQ "2">		<!--- Guardar todos los Resultados en el Expediente --->
							<cfinvokeargument name="id_tipo" 	value="#rsRequisito.id_tipo#">
							<cfinvokeargument name="id_persona" value="#url.P#">
					</cfif>

					<cfloop index="i" from="1" to="#ArrayLen(LvarWS.outputDatos)#">
						<cfif LvarWS.outputDatos[i].id_campo neq "">
							<cfset LvarValor = evaluate("LvarResultado.#LvarWS.outputDatos[i].nombre#")>
							<cfif LvarWS.outputDatos[i].tipo EQ "F">
								<cfset LvarValor = DateFormat(LvarValor, "DD/MM/YYYY")>
							</cfif>
		
							<cfif LvarTipoProceso EQ "1">		<!--- Guardar 1er Resultado en el Tramite --->
								<cfinvokeargument name="C_#LvarWS.outputDatos[i].id_campo#" 	value="#LvarValor#">
							<cfelseif LvarTipoProceso EQ "2">		<!--- Guardar todos los Resultados en el Expediente --->
								<cfinvokeargument name="C_#LvarWS.outputDatos[i].id_campo#" 	value="#LvarValor#">
							</cfif>
 						</cfif>
					</cfloop>
					</cfinvoke>
					<cfif LvarTipoProceso EQ "1">		<!--- Procesar sólo 1er Resultado --->
						<cfif rsRegistro.id_registro EQ "-1">		<!--- Registro Nuevo --->
							<cfquery datasource="tramites_cr">
								update TPInstanciaRequisito
								   set id_registro = #LvarNewIdRegistro#
								 where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.I#">
								   and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.R#">
							</cfquery>
						</cfif>
						<cfbreak>
					</cfif>
				</cfloop>
				<cfset sbDump ("#LvarResultado#")>
			</cfif>
		<cfcatch type="any">
			<cfset sbDump ("#cfcatch#")>
			<script language="javascript">
			<cfoutput>
				alert("SERVICIO WEB:\t#LvarWS.servicio#\nFUNCION:\t#LvarWS.nombre#\n\n#cfcatch.Message#");
			</cfoutput>
			</script>
		</cfcatch>
		</cftry>
	</cfloop>
<cfcatch type="database">
	<script language="javascript">
	<cfoutput>
		alert("El Servicio Remoto no está disponible, intente más tarde (CODE=0690)");
	</cfoutput>
	</script>
</cfcatch>
<cfcatch type="any">
	<cfset sbDump ("#cfcatch#")>
	<script language="javascript">
	<cfoutput>
		alert("#cfcatch.Message#");
	</cfoutput>
	</script>
</cfcatch>
</cftry>
<script language="javascript">
<cfoutput>
	var LvarPag = window.parent.document.location.href;
	var LvarPto = LvarPag.indexOf("?");
	if (LvarPto > 0)
		LvarPag = LvarPag.substr(0,LvarPto);
	LvarPag = LvarPag + "?id_persona=#url.P#&id_instancia=#url.I#&id_requisito=#url.R#&tab=3"
	//window.parent.document.location.href = LvarPag;
</cfoutput>
</script>

<cffunction name="sbDump" output="true">
	<cfargument name="Valor" type="any" required="yes">
	
<!---
	<cfreturn>
--->	
	<cfdump var="#Valor#">
</cffunction>