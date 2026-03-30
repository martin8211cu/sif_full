
<cf_templateheader title="Administración de Documentos de Autorización Externa">
	<cf_web_portlet_start titulo="Administración de Documentos de Autorización Externa">
		<cf_navegacion name="Ecodigo"	default="#session.Ecodigo# " navegacion="">
		<cf_navegacion name="CPDAEid"	default="" navegacion="">

		<cfif isdefined("url.opD")>
			<cfinclude template="docsAutExt_det.cfm">
		<cfelse>
			<cfif isdefined("url._")>
				<cfset session.CPPid = "">
			</cfif>
			<cfparam name="session.CPPid" default="">
			<cfif session.CPPid EQ "">
				<cfquery name="rsPeriodos" datasource="#Session.DSN#">
					select CPPid, CPPfechaHasta, CPPfechaDesde
					  from CPresupuestoPeriodo p inner join Monedas m on p.Mcodigo=m.Mcodigo
					 where p.Ecodigo = #session.Ecodigo# 
					   and p.CPPestado = 1
					 order by CPPfechaHasta asc, CPPfechaDesde desc
				</cfquery>
				
				<cfif rsPeriodos.CPPid EQ "">
					<BR>
					<div style="color:#FF0000; text-align:center">
					No existen Periodos de Presupuesto Abiertos
					</div>
					<BR>
					<cfexit>
				</cfif>
			
				<cfset session.CPPid = rsPeriodos.CPPid>
			</cfif>
			<cf_navegacion name="CPPid"		default="#session.CPPid#" navegacion="">
			<cfset session.CPPid = form.CPPid>
			
			<form name="formFiltro" action="docsAutExt.cfm" method="post">
			Período de Presupuesto: <cf_cboCPPid CPPestado="1" form="formFiltro" onchange="document.formFiltro.submit();" value="#form.CPPid#">
			</form>
			<cfif isdefined ('form.CPDAEid') AND form.CPDAEid NEQ "">
				<cfset modo='CAMBIO'>
			<cfelse>
				<cfset modo='ALTA'>
			</cfif>
			<table width="100%" align="center">
				<tr>
				<cfif modo EQ  "ALTA" and not isdefined("form.btnnuevo") and not isdefined("url.nuevo")>
					<td valign="top" align="center">
						<cf_dbfunction name="OP_concat" returnvariable="_CAT">
						<cf_dbfunction name="to_char" args="d.CPDAEid" isnumber="no" returnvariable="LvarCPDAEid">
						<cfquery name="rsLista" datasource="#session.dsn#">
							select 
								d.CPDAEid,
								d.Ecodigo, 
								d.CPDAEcodigo,
								d.CPDAEdescripcion,
								t.CPTAEcodigo,
								case d.CPDAEestado
									when 0 then 	'Inactivo: El documento no se puede utilizar'
									when 1 then 	'Abierto: Se pueden asignar traslados'
									when 2 then 	'Pausa: no permite asignar traslados nuevos'
									when 3 then 	'Cerrado: no permite traslados en Trámites'
									when 10 then 	'APLICADO PARCIALMENTE'
									when 11 then 	'APLICADO'
									when 12 then 	'RECHAZADO'
								end as estado,
								case d.CPDAEestado
									when 0 then
										'<img src="/cfmx/sif/imagenes/OP/btn-play.gif" 	title="Abrir: permite asignar traslados nuevos"				style="cursor:pointer"	onclick="sbOP(1,'	#_CAT# #preserveSingleQuotes(LvarCPDAEid)# #_CAT# ')">'
									when 1 then
										'<img src="/cfmx/sif/imagenes/OP/btn-pause.gif" title="Pausa: no permite asignar traslados nuevos"			style="cursor:pointer"	onclick="sbOP(2,'	#_CAT# #preserveSingleQuotes(LvarCPDAEid)# #_CAT# ')">'
									when 2 then
										'<img src="/cfmx/sif/imagenes/OP/btn-stop.gif" 	title="Cerrar: no permite traslados en Tramites"			style="cursor:pointer"	onclick="sbOP(3,'	#_CAT# #preserveSingleQuotes(LvarCPDAEid)# #_CAT# ')">'
										#_CAT# ' ' #_CAT#
										'<img src="/cfmx/sif/imagenes/Base.gif" 		title="Trabajar con documentos de traslado"					style="cursor:pointer"	onclick="sbOP(20,'	#_CAT# #preserveSingleQuotes(LvarCPDAEid)# #_CAT# ')">'
										#_CAT# ' ' #_CAT#
										'<img src="/cfmx/sif/imagenes/OP/btn-first.gif" title="ReAbrir: permite volver a asignar traslados nuevos"	style="cursor:pointer"	onclick="sbOP(1,'	#_CAT# #preserveSingleQuotes(LvarCPDAEid)# #_CAT# ')">'
									when 3 then
										'<img src="/cfmx/sif/imagenes/Cfinclude.gif" 	title="Aplicar y afectar presupuesto"						style="cursor:pointer"	onclick="sbOP(11,'	#_CAT# #preserveSingleQuotes(LvarCPDAEid)# #_CAT# ')">'
										#_CAT# ' ' #_CAT#
										'<img src="/cfmx/sif/imagenes/Base.gif" 		title="Trabajar con documentos de traslado"					style="cursor:pointer"	onclick="sbOP(20,'	#_CAT# #preserveSingleQuotes(LvarCPDAEid)# #_CAT# ')">'
										#_CAT# ' ' #_CAT#
										'<img src="/cfmx/sif/imagenes/OP/btn-first.gif" title="ReAbrir: permite volver a asignar traslados nuevos"	style="cursor:pointer"	onclick="sbOP(1,'	#_CAT# #preserveSingleQuotes(LvarCPDAEid)# #_CAT# ')">'
									when 10 then
										'<img src="/cfmx/sif/imagenes/Cfinclude.gif" 	title="Aplicar y afectar presupuesto"						style="cursor:pointer"	onclick="sbOP(11,'	#_CAT# #preserveSingleQuotes(LvarCPDAEid)# #_CAT# ')">'
										#_CAT# ' ' #_CAT#
										'<img src="/cfmx/sif/imagenes/Base.gif" 		title="Trabajar con documentos de traslado"					style="cursor:pointer"	onclick="sbOP(20,'	#_CAT# #preserveSingleQuotes(LvarCPDAEid)# #_CAT# ')">'
									when 11 then ''
									when 12 then ''
								end as OPs,
								d.BMUsucodigo 
							from CPDocumentoAE d
								inner join CPtipoAutExterna t
									on t.CPTAEid = d.CPTAEid
							where d.Ecodigo=#session.Ecodigo# 
							  and d.CPPid = #session.CPPid#
						</cfquery>
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
							query="#rsLista#"
							columnas="CPDAEid,CPDAEcodigo,CPDAEdescripcion,CPTAEcodigo, Estado"
							desplegar="OPs,CPDAEcodigo,CPDAEdescripcion,CPTAEcodigo, Estado"
							etiquetas="OP,Número, Descripción, Tipo, Estado"
							formatos="S,S,S,S,S"
							align="left,left,left,left,left"
							ira="docsAutExt.cfm"
							form_method="post"	
							showEmptyListMsg="yes"
							keys="CPDAEid"
							incluyeForm="yes"
							formName="formLista1"
							PageIndex="2"
							MaxRows="8"
							botones="Nuevo"
						/>
						<script language="javascript">
							function sbOP(op,id)
							{
								document.formLista1.nosubmit=true;
								location.href = 'docsAutExt_sql.cfm?OP='+op+'&id='+id;
							}
						</script>
					</td>
				<cfelse>
					<td valign="top">
						<cfinclude template="docsAutExt_form.cfm">
					</td>
				</cfif>
				</tr>
			</table>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
