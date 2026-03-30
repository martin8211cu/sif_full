<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfquery name="rstemp" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor"> as value
	from Parametros 
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 50
</cfquery>

<cfset LvarPeriodo = rstemp.value>
<cfquery name="rstemp" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor"> as value
	from Parametros 
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 60
</cfquery>
<cfset LvarMes = rstemp.value>
<cf_templateheader title="Activos Fijos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de Activos'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td valign="top" width="50%">
						<cfscript>
							//Define navegacion y filtro
							filtro = "";
							navegacion = "";
							//Procesa los datos del filtro cuando vienen en url de los filtros no automáticos
							if (isdefined("url.AFMid") and len(trim(url.AFMid))) form.AFMid = url.AFMid; 
							if (isdefined("url.AFMMid") and len(trim(url.AFMMid))) form.AFMMid = url.AFMMid;
							if (isdefined("url.CFid") and len(trim(url.CFid))) form.CFid = url.CFid;
							//define el filtro adicional y la navegacion para los filtros no automáticos
							if (isdefined("form.AFMid") and len(trim(form.AFMid))){
								filtro = filtro & " and a.AFMid = " & form.AFMid;
								navegacion = navegacion & "&AFMid=" & form.AFMid;
							}
							if (isdefined("form.AFMMid") and len(trim(form.AFMMid))){
								filtro = filtro & " and a.AFMMid = " & form.AFMMid;
								navegacion = navegacion & "&AFMMid=" & form.AFMMid;
							}
							if (isdefined("form.CFid") and len(trim(form.CFid))){
								filtro = filtro & " and s.CFid = " & form.CFid;
								navegacion = navegacion & "&CFid=" & form.CFid;
							}
						</cfscript>
						
						<cfset rsEstado = QueryNew("value,description")>
						<cfset temp = QueryAddRow(rsEstado,3)>
						<cfset temp = QuerySetCell(rsEstado,"value","",1)>
						<cfset temp = QuerySetCell(rsEstado,"value",0,2)>
						<cfset temp = QuerySetCell(rsEstado,"value",60,3)>
						<cfset temp = QuerySetCell(rsEstado,"description","Todos",1)>
						<cfset temp = QuerySetCell(rsEstado,"description","Activos",2)>
						<cfset temp = QuerySetCell(rsEstado,"description","Retirados",3)>
						<form action="action" method="post" name="lista">
						<!--- Filtro no automático --->
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr class="titulolistas">
							<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
							<td class="titulolistas">Marca:&nbsp;</td>
							<td class="titulolistas">Modelo:&nbsp;</td>
							<td class="titulolistas">Centro Funcional:&nbsp;</td>
						</tr>
						<tr class="titulolistas">
							<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
							<td class="titulolistas">
								<cfset valuesArray = ArrayNew(1)>
								<cfif isdefined("form.AFMid") and len(trim(form.AFMid))>
									<cfquery name="rsAFMarcas" datasource="#session.dsn#">
										select AFMid, AFMcodigo, AFMdescripcion
										from AFMarcas
										where AFMid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMid#">
									</cfquery>
									<cfif rsAFMarcas.recordcount gt 0>
										<cfset ArrayAppend(valuesArray,'#rsAFMarcas.AFMid#')>
										<cfset ArrayAppend(valuesArray,'#rsAFMarcas.AFMcodigo#')>
										<cfset ArrayAppend(valuesArray,'#rsAFMarcas.AFMdescripcion#')>
									</cfif>
								<cfelse>
									<cfset ArrayAppend(valuesArray,'')>
									<cfset ArrayAppend(valuesArray,'')>
									<cfset ArrayAppend(valuesArray,'')>
								</cfif>
								<cf_conlis
									campos="AFMid, AFMcodigo, AFMdescripcion"
									desplegables="N,S,S"
									size="0,10,20"
									valuesArray="#valuesArray#"
									title="Lista de Marcas"
									tabla="AFMarcas"
									columnas="AFMid, AFMcodigo, AFMdescripcion"
									filtro="Ecodigo = #session.Ecodigo#"
									desplegar="AFMcodigo, AFMdescripcion"
									etiquetas="Marca, Descripci&oacute;n"
									formatos="S,S"
									align="left,left"
									asignar="AFMid, AFMcodigo, AFMdescripcion"
									asignarformatos="I, S, S"
									form="lista"
									modificables="N,S,N"
									alt="Marca, Marca, Marca"
									onchange="limpiaAFMMid"
									tabindex="1"
									>
							</td>
							<td class="titulolistas">
								<cfset valuesArray = ArrayNew(1)>
								<cfif isdefined("form.AFMid") and len(trim(form.AFMid))
										and isdefined("form.AFMMid") and len(trim(form.AFMMid))>
									<cfquery name="rsAFMModelos" datasource="#session.dsn#">
										select AFMMid, AFMMcodigo, AFMMdescripcion
										from AFMModelos
										where AFMMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMMid#">
										and AFMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMid#">
									</cfquery>
									<cfif rsAFMModelos.recordcount gt 0>
										<cfset ArrayAppend(valuesArray,'#rsAFMModelos.AFMMid#')>
										<cfset ArrayAppend(valuesArray,'#rsAFMModelos.AFMMcodigo#')>
										<cfset ArrayAppend(valuesArray,'#rsAFMModelos.AFMMdescripcion#')>
									</cfif>
								<cfelse>
									<cfset ArrayAppend(valuesArray,'')>
									<cfset ArrayAppend(valuesArray,'')>
									<cfset ArrayAppend(valuesArray,'')>
								</cfif>
								<cf_conlis
									campos="AFMMid, AFMMcodigo, AFMMdescripcion"
									desplegables="N,S,S"
									size="0,10,20"
									valuesArray="#valuesArray#"
									title="Lista de Modelos de la Marca Seleccionada"
									tabla="AFMModelos"
									columnas="AFMMid, AFMMcodigo, AFMMdescripcion"
									filtro="Ecodigo = #session.Ecodigo# and AFMid = $AFMid,numeric$"
									desplegar="AFMMcodigo, AFMMdescripcion"
									etiquetas="Modelo, Descripci&oacute;n"
									formatos="S,S"
									align="left,left"
									asignar="AFMMid, AFMMcodigo, AFMMdescripcion"
									asignarformatos="I, S, S"
									form="lista"
									modificables="N,S,N"
									alt="Modelo, Modelo, Modelo"
									tabindex="1"
									>
							</td>
							<td class="titulolistas">
								
								<cfif isdefined("form.CFid") and len(trim(form.CFid))>
									<cfquery name="rsCFuncional" datasource="#session.dsn#">
										select CFid, CFcodigo, CFdescripcion
										from CFuncional
										where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
									</cfquery>								
									<cf_rhcfuncional form="lista" query="#rsCFuncional#" tabindex="1">
								<cfelse>
									<cf_rhcfuncional form="lista" tabindex="1">
								</cfif>
								<!--- --->
							</td>
						  </tr>
						</table>
						
						<cfset XMes = rstemp.value>
						<cfset LvarTabla = "Activos a ">
						<cfif isdefined("form.CFid") and len(trim(form.CFid))>
							<cfset LVarTabla = "Activos a inner join AFSaldos s on s.AFSperiodo = #LvarPeriodo# and s.AFSmes = #Lvarmes# and s.Ecodigo = #session.Ecodigo# and s.CFid = #form.CFid# and s.Aid = a.Aid ">
						</cfif>
						<cf_dbfunction name="sPart"	args="ACdescripcion,1,30" returnvariable="ACdescripcion">
						<cf_dbfunction name="sPart"	args="a.Adescripcion,1,30" returnvariable="aACdescripcion">
						<cf_dbfunction name="sPart"	args="AFMdescripcion,1,30" returnvariable="AFMdescripcion">	
						<cf_dbfunction name="sPart"	args="AFMMdescripcion,1,30" returnvariable="AFMMdescripcion">			
								
						 <cfinvoke  component="sif.Componentes.pListas"	 method="pLista" returnvariable="pListaRet">
							<cfinvokeargument name="columnas" value="a.Aid, 
																	(select ACcodigodesc #_Cat# ' '#_Cat# #ACdescripcion# 
																		from ACategoria x 
																			where x.Ecodigo = a.Ecodigo 
																			  and x.ACcodigo = a.ACcodigo) as Categoria, 
																	(select ACcodigodesc #_Cat# ' ' #_Cat# #ACdescripcion# 
																		from AClasificacion x 
																			where x.Ecodigo = a.Ecodigo 
																			  and x.ACid = a.ACid 
																			  and x.ACcodigo = a.ACcodigo) as Clase, 
																	a.Aplaca, 
																	#aACdescripcion# as Adescripcion, 
																	case when a.Astatus = 0 then 'Activo' else 'Retirado' end as Estado, 
																	a.Aserie,
																	(select #AFMdescripcion# from AFMarcas x where x.AFMid = a.AFMid) as AFMdescripcion, 
																	(select #AFMMdescripcion# from AFMModelos x where x.AFMMid = a.AFMMid) as AFMMdescripcion"/>
							<cfinvokeargument name="tabla" value="#LVarTabla#"/>
							<cfinvokeargument name="keys" value="Aid"/>
							<cfinvokeargument name="cortes" value="Categoria, Clase"/>
							<cfinvokeargument name="desplegar" value="Aplaca, Aserie, Adescripcion, Estado, AFMdescripcion, AFMMdescripcion"/>
							<cfinvokeargument name="filtrar_por" value="Aplaca, Aserie, Adescripcion, Astatus, '', ''"/>
							<cfinvokeargument name="etiquetas" value="Placa, Serie, Descripci&oacute;n, Estado, Marca, Modelo"/>
							<cfinvokeargument name="formatos" value="S, S, S, S, U, U, U"/>
							<cfinvokeargument name="align" value="left, left, left, left, left, left"/>
							<cfinvokeargument name="ajustar" value="N, N, N, N, S, S"/>
							<cfinvokeargument name="irA" value="Activos.cfm"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# #filtro# order by 2, 3, 4"/>
							<cfinvokeargument name="mostrar_filtro" value="#true#"/>
							<cfinvokeargument name="filtrar_automatico" value="#true#"/>
							<cfinvokeargument name="rsEstado" value="#rsEstado#"/>
							<cfinvokeargument name="showEmptyListMsg" value="#true#"/>
							<cfinvokeargument name="EmptyListMsg" value="No se encontraron Activos"/>
							<cfinvokeargument name="formname" value="lista"/>
							<cfinvokeargument name="incluyeform" value="no"/>
							<cfinvokeargument name="MaxRows" value="25"/>
							<cfinvokeargument name="MaxRowsQuery" value="200"/>
						</cfinvoke>

						</form>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>