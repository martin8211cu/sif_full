<cfif isdefined("url.CGCid") and len(trim(url.CGCid))><cfset form.CGCid = url.CGCid></cfif>

<cfset rsModo = QueryNew("value,description")>
<cfset temp = QueryAddRow(rsModo,3)>
<cfset temp = QuerySetCell(rsModo,"value",-1,1)>
<cfset temp = QuerySetCell(rsModo,"value",1,2)>
<cfset temp = QuerySetCell(rsModo,"value",2,3)>
<cfset temp = QuerySetCell(rsModo,"description","Todos",1)>
<cfset temp = QuerySetCell(rsModo,"description","Por Catálogo",2)>
<cfset temp = QuerySetCell(rsModo,"description","Por Clasificación",3)>

<cf_dbfunction name='concat' args="b.PCEcodigo + ' - ' + b.PCEdescripcion" delimiters='+' returnvariable='LvarB'>
<cf_dbfunction name='concat' args="c.PCCEcodigo + ' - ' + c.PCCEdescripcion" delimiters='+' returnvariable='LvarC'>

<cf_templateheader title="Contabiliada General">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Catálogo de Conductores'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top" width="45%">
					<cfinvoke component="sif.Componentes.pListas" method="pLista"
						tabla="CGConductores a 
								 left join PCECatalogo b
									on a.CGCidc = b.PCEcatid 
								 left join PCClasificacionE c
									on a.CGCidc = c.PCCEclaid "
						columnas="	a.CGCid, 
									a.CGCcodigo,
									a.CGCdescripcion,
									a.CGCmodo,
									a.CGCtipo,
									case when a.CGCmodo = 1 then 
										'Por Catálogo' 
									else 
										'Por Clasificación' 
									end as cboCGCmodo, 
									case when a.CGCmodo = 1 then
										 #LvarB#
									else
										 #LvarC#
									end as Catalogos,
									a.CGCidc as F_Catalogo "
						desplegar="CGCcodigo, CGCdescripcion, cboCGCmodo, Catalogos"
						etiquetas="Código, Conductor, Modo, Catalogo"
						formatos="S,S,C,S"
						filtro=" a.Ecodigo=#session.Ecodigo# Order By CGCid"
						align="left,left,left,left"
						checkboxes="N"
						keys="CGCid"
						MaxRows="6"
						pageindex="1"
						filtrar_automatico="true"
						mostrar_filtro="true"
						filtrar_por="CGCcodigo,CGCdescripcion, CGCmodo,   case when a.CGCmodo = 1 then
																				#LvarB# 
																			else
																				#LvarC#
																			end"
						rscboCGCmodo="#rsModo#"
						ira="Conductores.cfm"
						showEmptyListMsg="true">
				</td>					
				<td valign="top" width="55%">
					<cfinclude template="formConductores.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
