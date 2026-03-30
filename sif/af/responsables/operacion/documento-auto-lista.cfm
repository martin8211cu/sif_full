<!--- lista de documentos registrados por un usuario en autogestiÃ³n --->
<cfset Lvar_Autogestion = true>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput> (Autogestion)">
			<cfoutput>#pNavegacion#</cfoutput>
			<cfif isdefined("Session.DEid") and len(trim(Session.DEid))>
				<cfset form.DEid = Session.DEid>
			<cfelse>
				<cfquery name="rsgetdeid" datasource="#session.dsn#">
					select DEid 
					from DatosEmpleado
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
					and DEusuarioportal  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				</cfquery>
				<cfif rsgetdeid.recordcount neq 1>
					<cfquery name="rsgetdeid" datasource="asp">
						select llave as DEid 
						from UsuarioReferencia
						where Usucodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigosdc#">
							and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
					</cfquery>
				</cfif>
				<cfif rsgetdeid.recordcount eq 1 and len(trim(rsgetdeid.DEid)) gt 0>
					<cfset form.DEid = rsgetdeid.DEid>
				<cfelse>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_Error40001NoSePudoObtenerElEmpleadoAsociadoASuUsuario"
						Default="Error  40001. No se pudo obtener el Empleado Asociado a su Usuario"
						returnvariable="MSG_Error40001NoSePudoObtenerElEmpleadoAsociadoASuUsuario"/>
					<cf_errorCode	code = "50128"
									msg  = "documnento-auto.cfm. @errorDat_1@."
									errorDat_1="#MSG_Error40001NoSePudoObtenerElEmpleadoAsociadoASuUsuario#"
					>
				</cfif>
			</cfif>
			<!--- A partir de este punto el empleado es requerido --->
			<cfparam name="form.DEid">
			<cfquery name="rsEmpleado" datasource="#session.dsn#">
				select a.DEid, rhp.CFid
				from DatosEmpleado a
					inner join LineaTiempo lt
							inner join RHPlazas rhp
								on rhp.RHPid = lt.RHPid
						on lt.DEid = a.DEid
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						between lt.LTdesde and lt.LThasta
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">					
			</cfquery>
			<cfif rsEmpleado.recordcount neq 1>
				<cfquery name="rsEmpleado" datasource="#session.dsn#">
					select DEid, CFid
					from EmpleadoCFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">					
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						between ECFdesde and ECFhasta
				</cfquery>
			</cfif>
			<cfif rsEmpleado.recordcount neq 1>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Error40002NoSePudoObtenerElEmpleadoAsociadoASuUsuario"
					Default="Error  40002. No se pudo obtener el Empleado Asociado a su Usuario"
					returnvariable="MSG_Error40002NoSePudoObtenerElEmpleadoAsociadoASuUsuario"/>

				<cf_errorCode	code = "50129"
								msg  = "documnento-auto.cfm @errorDat_1@."
								errorDat_1="#MSG_Error40002NoSePudoObtenerElEmpleadoAsociadoASuUsuario#"
				>
			</cfif>
			<cfinclude template="/sif/portlets/pEmpleado.cfm">
			<!--- Variables de Traduccion --->
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Placa"
				Default="Placa"
				returnvariable="LB_Placa"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Descripcion"
				Default="Descripci&oacute;n"
				XmlFile="/sif/generales.xml"
				returnvariable="LB_Descripcion"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Fecha"
				Default="Fecha"
				returnvariable="LB_Fecha"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Marca"
				Default="Marca"
				returnvariable="LB_Marca"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Modelo"
				Default="Modelo"
				returnvariable="LB_Modelo"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Clasificacion"
				Default="Clasificaci&oacute;n"
				returnvariable="LB_Clasificacion"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Monto"
				Default="Monto"
				returnvariable="LB_Monto"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_NoSeEncontraronDocumentos"
				Default="No se encontraron documentos"
				returnvariable="MSG_NoSeEncontraronDocumentos"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Regresar"
				Default="Regresar"
				XmlFile="/sif/generales.xml"
				returnvariable="BTN_Regresar"/>
			
			<cfinvoke 
				component="sif.Componentes.pListas" 
				method="pLista" 
				returnvariable="Lvar_Lista" 
				columnas="(select {fn concat({fn concat(rtrim(ltrim(CRCCcodigo)), ' ')}, rtrim(ltrim(CRCCdescripcion)))} from CRCentroCustodia where Ecodigo = a.Ecodigo and CRCCid = a.CRCCid) as CentroCustodia,
								(select {fn concat({fn concat(rtrim(ltrim(ACcodigodesc)), ' ')}, rtrim(ltrim(ACdescripcion)))} from ACategoria where Ecodigo = a.Ecodigo and ACcodigo = a.ACcodigo) as Categoria,
								(select {fn concat({fn concat(rtrim(ltrim(ACcodigodesc)), ' ')}, rtrim(ltrim(ACdescripcion)))} from AClasificacion where Ecodigo = a.Ecodigo and ACcodigo = a.ACcodigo and ACid = a.ACid) as Clase,
								(select rtrim(ltrim(AFMcodigo)) from AFMarcas where Ecodigo = a.Ecodigo and AFMid = a.AFMid) as Marca,
								(select rtrim(ltrim(AFMMcodigo)) from AFMModelos where Ecodigo = a.Ecodigo and AFMMid = a.AFMMid) as Modelo,
								(select rtrim(ltrim(AFCcodigoclas)) from AFClasificaciones where Ecodigo = a.Ecodigo and AFCcodigo = a.AFCcodigo) as Clasificacion,	
								CRDRplaca, CRDRdescripcion, CRDRdescdetallada, CRDRfdocumento, 
								CRDRtipodocori, CRDRdocori, CRDRfalta, CRDRserie, CRDRlindocori, Monto, '' as e"
				tabla="CRDocumentoResponsabilidad a"
				filtro="Ecodigo = #session.Ecodigo# and DEid = #form.DEid# and BMUsucodigo = #session.Usucodigo# and CRDRestado = 0 order by 1, 2, 3, CRDRplaca"
				cortes="CentroCustodia, Categoria, Clase"
				desplegar="CRDRplaca, CRDRdescripcion, CRDRfdocumento, Marca, Modelo, Clasificacion, Monto, e"
				filtrar_por="CRDRplaca, CRDRdescripcion, CRDRfdocumento, 
								(select rtrim(ltrim(AFMcodigo)) from AFMarcas where Ecodigo = a.Ecodigo and AFMid = a.AFMid),
								(select rtrim(ltrim(AFMMcodigo)) from AFMModelos where Ecodigo = a.Ecodigo and AFMMid = a.AFMMid),
								(select rtrim(ltrim(AFCcodigoclas)) from AFClasificaciones where Ecodigo = a.Ecodigo and AFCcodigo = a.AFCcodigo),	
								Monto,''"
				etiquetas="#LB_Placa#, #LB_Descripcion#, #LB_Fecha#, #LB_Marca#, #LB_Modelo#, #LB_Clasificacion#, #LB_Monto#, "
				formatos="S,S,D,S,S,S,UM,U"
				align="left,left,center,left,left,left,right,left"
				mostrar_filtro="true"
				filtrar_automatico="true"
				showemptylistmsg="true"
				botones="#BTN_Regresar#"
				showLink="false"
				emptylistmsg=" --- #MSG_NoSeEncontraronDocumentos# --- "
				ira="documento-auto.cfm"
			/>
			<script language="javascript" type="text/javascript">
				function funcRegresar(){
					location.href = "documento-auto.cfm";
					return false;
				}
			</script>
		<cf_web_portlet_end>
	<cf_templatefooter>

