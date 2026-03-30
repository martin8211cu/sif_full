<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_templateheader title="Lista de Planes de Pago">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de Planes de Pago por Empleado'>
		<cfinclude template="../../portlets/pNavegacion.cfm">

			<!--- Asignación del valor que viene por url a form de DEid y TDid --->
			<cfif isdefined("url.DEid") and len(trim(url.DEid))>
				<cfset form.DEid = url.DEid>
			</cfif>	
			<cfif isdefined("url.TDid") and len(trim(url.TDid))>
				<cfset form.TDid = url.TDid>
			</cfif>
			
			<!--- Si los valores no estan definidos te envia a la pantalla de filtro otra vez --->
			<cfif not (isdefined("form.DEid")  and len(trim(form.DEid)) and isdefined("form.TDid") and len(trim(form.TDid))) >
				<cflocation url="planPagosFiltro.cfm">	
			</cfif>
			
			<!--- Mantiene los valores de navegación con las llaves --->
			<cfset navegacion = "">
			<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
			</cfif>
			<cfif isdefined("Form.TDid") and Len(Trim(Form.TDid)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TDid=" & Form.TDid>
			</cfif>
			
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr><td>&nbsp;</td></tr>
				<tr><td><cfinclude template="/sif/portlets/pEmpleado.cfm"></td></tr>

				<tr>
					<td>
						<table width="100%" align="center" class="areaFiltro" cellpadding="0" cellspacing="0">
							<tr><td style="padding:4; "><strong>Seleccione el plan de pagos con el que desea trabajar.</strong></td></tr>
						</table>
					</td>
				</tr>	

				<tr>
					<td>
						<cfquery name="rsLista" datasource="#session.DSN#">
							select a.DEid, a.Did, a.TDid, rtrim(b.TDcodigo) #_Cat# '-' #_Cat# b.TDdescripcion as TDeduccion, a.Dreferencia, a.Ddescripcion, a.SNcodigo, c.SNnumero, c.SNnombre, a.Dfechaini, Dvalor
							from DeduccionesEmpleado a
							
							inner join TDeduccion b
							on a.TDid=b.TDid
							and a.Ecodigo=b.Ecodigo
							
							left outer join SNegocios c
							on a.SNcodigo=c.SNcodigo
							and a.Ecodigo=c.Ecodigo
							
							where a.Ecodigo= #session.Ecodigo# 
							and b.TDfinanciada=1
							
							and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
							and a.TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
							
							and a.Did in (	select distinct Did 
											from DeduccionesEmpleadoPlan
											where Ecodigo= #session.Ecodigo# 	)
							order by a.Dfechaini				
						</cfquery>

						<cfif rsLista.recordCount eq 1>
							<cfoutput>
							<cfif not isdefined("form.btnRegresar2")>
								<cfset parametros = "?DEid=#rsLista.DEid#&Did=#rsLista.Did#&TDid=#rsLista.TDid#" >
								<cflocation url="planPagosCambiar.cfm#parametros#">
							<cfelse>
								<cflocation url="planPagosFiltro.cfm">
							</cfif>
							</cfoutput>
						</cfif>

						<cfinvoke 
								component="sif.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="TDeduccion, Dreferencia, Ddescripcion, Dfechaini, Dvalor"/>
							<cfinvokeargument name="etiquetas" value="Tipo Deducci&oacute;n, Referencia, Descripci&oacute;n, Fecha de Inicio, Monto Cuota"/>
							<cfinvokeargument name="formatos" value="V,V,V,D,M"/>
							<cfinvokeargument name="align" value="left,left,left,left,right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="MaxRows" value="25"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="irA" value="planPagosCambiar.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
						</cfinvoke>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center"><input type="button" name="Regresar" value="<< Regresar" onclick="location.href='planPagosFiltro.cfm'"></td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>