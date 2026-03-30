<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MantenimientoDeInstructores"
	Default="Mantenimiento de Instructores"
	returnvariable="LB_MantenimientoDeInstructores"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo"
	Default="Tipo"
	returnvariable="LB_Tipo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Area"
	Default="Area"
	returnvariable="LB_Area"/>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Servicio"
	Default="Servicio"
	returnvariable="LB_Servicio"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar" xmlfile="/rh/generales.xml" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="BTN_Limpiar" default="Limpiar" xmlfile="/rh/generales.xml" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate"/>			
<!--- FIN VARIABLES DE TRADUCCION --->
﻿<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_web_portlet_start border="true" titulo="#LB_MantenimientoDeInstructores#" skin="#Session.Preferences.Skin#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfquery datasource="#session.dsn#" name="rsTident">
				select NTIcodigo, NTIdescripcion
				from NTipoIdentificacion
				where Ecodigo = #Session.Ecodigo#
				order by NTIcodigo
			</cfquery>
			<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
			<cfquery datasource="#session.dsn#" name="lista">
					select a.RHIid,NTIdescripcion,a.RHIidentificacion,
					coalesce(a.RHInombre,'') #LvarCNCT# ' ' #LvarCNCT# coalesce(a.RHIapellido1,'')#LvarCNCT# ' '#LvarCNCT# coalesce(a.RHIapellido2,'') as Nombre
					from RHInstructores a
					inner join NTipoIdentificacion b
					on b.NTIcodigo=a.NTIcodigo	
					and b.Ecodigo = #Session.Ecodigo#
					<cfif isDefined("form.RHACid") and len("#form.RHACid#") and form.RHACid gt 0>
						inner join RHAreasxInst ai
						on ai.RHIid=a.RHIid
						and ai.RHACid=#form.RHACid#
					</cfif>
					
					<cfif isDefined("form.RHTSid") and len("#form.RHTSid#") and form.RHTSid gt 0>
						inner join RHTiposServxInst si
						on si.RHIid=a.RHIid
						and si.RHTSid=#form.RHTSid#
					</cfif>
					
					where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isDefined("form.ftipo") and len("#form.ftipo#")>
						and upper(b.NTIcodigo) like upper(<cfqueryparam cfsqltype="cf_sql_char" value="%#form.ftipo#%">)
					</cfif>	
					<cfif isDefined("form.Fidentificacion") and len("#form.Fidentificacion#")>
						and upper(a.RHIidentificacion) like upper(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.Fidentificacion#%">)
					</cfif>				
					<cfif isDefined("form.Fnombre") and len("#form.Fnombre#")>
                        and upper(<cf_dbfunction name="concat" args="coalesce(a.RHInombre,'')|' '|coalesce(a.RHIapellido1,'')|' '|coalesce(a.RHIapellido2,'')"delimiters="|">) 
						like upper(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.Fnombre#%">)
					</cfif>
						
					and a.NTIcodigo = b.NTIcodigo
					order by 2				
			</cfquery>
			
			<table width="100%" border="0" cellspacing="6">
				<tr>
					<td valign="top" width="50%">
					<form style="Margin:0" action="RHInstructores.cfm" method="post" name="filtro">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
						  <tr>
							<cfoutput>
							<td nowrap class="fileLabel">#LB_Tipo#</td>
							<td nowrap class="fileLabel">#LB_Identificacion#</td>
							<td nowrap class="fileLabel">#LB_Nombre#</td>
							</cfoutput>
							<td nowrap>&nbsp;</td>
						  </tr>
						  <tr>
						  	<td>
							<cfoutput>
							<select name="ftipo">
							<option value="">- Seleccione - </option>
								<cfloop query="rsTident">												
									<option value="#rsTident.NTIcodigo#"> #rsTident.NTIdescripcion# </option>
								</cfloop>
							</select>
							</cfoutput>
							
							</td>
							<td nowrap>
								<input name="Fidentificacion" type="text" size="20" maxlength="20" value="<cfif isDefined("Fidentificacion")><cfoutput>#Form.Fidentificacion#</cfoutput></cfif>">
							</td>
							<td nowrap>
								<input name="Fnombre" type="text" size="20" maxlength="80" value="<cfif isDefined("Fnombre")><cfoutput>#Form.Fnombre#</cfoutput></cfif>">
							</td>
							<td nowrap>
								<input name="butFiltrar" type="submit" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
								<input name="resButton" type="button" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onclick="document.filtro.Fidentificacion.value=''; document.filtro.Fnombre.value=''; document.filtro.ftipo.value='';">
							</td>
						  </tr>
						  <tr>
						  	<td>&nbsp;</td>
						  </tr>
						   <tr>	
						  	<cfoutput><td colspan="3">#LB_Area#</cfoutput>
							<cfquery name="rsArea" datasource="#session.dsn#">
								select RHACid,RHACcodigo,RHACdescripcion from RHAreasCapacitacion where Ecodigo=#session.Ecodigo#
							</cfquery>
							<select name="RHACid" id="RHACid">
									<option value="0">- Seleccione -</option>
									<cfif rsArea.RecordCount>
										<cfoutput query="rsArea">
											<option value="#rsArea.RHACid#" <cfif isdefined('form.RHACid') and rsArea.RHACid  eq form.RHACid> selected="selected" </cfif>>#rsArea.RHACcodigo#-#rsArea.RHACdescripcion#</option>									
										</cfoutput>
									</cfif>                       
							</select>
							</td>
						</tr>
						<tr>
							<cfoutput><td colspan="3">#LB_Servicio#</cfoutput>						
							<cfquery name="rsServ" datasource="#session.dsn#">
								select RHTSid,RHTScodigo,RHTSdescripcion from RHTiposServ where Ecodigo=#session.Ecodigo#
							</cfquery>
							<select name="RHTSid" id="RHTSid">
								<option value="0">- Seleccione -</option>
									<cfif rsServ.RecordCount>
										<cfoutput query="rsServ">
											<option value="#rsServ.RHTSid#">#rsServ.RHTScodigo#-#rsServ.RHTSdescripcion#</option>									
										</cfoutput>
									</cfif>                       
							</select>
							</td>
						</tr>					 
						</table>
					</form>
					
					
					<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
						query="#lista#"
						desplegar="NTIdescripcion,RHIidentificacion,Nombre"
						etiquetas="#LB_Tipo#,#LB_Identificacion#,#LB_Nombre#"
						formatos="S,S,S"
						align="left,left,left"
						ira="RHInstructores.cfm"
						form_method="get"
						keys="RHIid"
						filtrar_automatico="true"
						mostrar_filtro="false"	
						MaxRows="10"
						/>		
					</td>
					<td valign="top" width="50%">
						<cfinclude template="RHInstructores-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>


