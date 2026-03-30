<cf_templateheader title="Lista de Planes de Pago">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de Planes de Pago por Empleado'>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

			<cfif isdefined("url.DEid") and len(trim(#url.DEid#)) neq 0>
				<cfset form.DEid=url.DEid >
			</cfif>
			
			<cfif isdefined("url.TDid")and len(trim(url.TDid))NEQ 0>
				<cfset form.TDid=url.TDid >
			</cfif>
			
			<cfif not (isdefined("form.DEid")  and len(trim(form.DEid)) and isdefined("form.TDid") and len(trim(form.TDid))) >
				<cflocation url="planPagosFiltro.cfm">	
			</cfif>

			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr><td>&nbsp;</td></tr>
				<tr><td><cfinclude template="/sif/portlets/pEmpleado.cfm"></td></tr>

				<tr>
					<td>
						<table width="100%" align="center" class="areaFiltro" cellpadding="0" cellspacing="0">
							<tr><td style="padding:4; "><strong>Seleccione el plan de pagos al que desea registrar un pago.</strong></td></tr>
						</table>
					</td>
				</tr>	

				<tr>
					<td>
						<cfset navegacion = "">
						
						<cfif isdefined("form.DEid") and len(trim(#form.DEid#)) neq 0>
							<cfset navegacion = navegacion & "DEid="&form.DEid>	
						</cfif>
						
						<cfif isdefined("form.TDid")and len(trim(form.TDid))NEQ 0>
							<cfif navegacion NEQ "">
								<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "TDid="&form.TDid>
							<cfelse>	
								<cfset navegacion = navegacion & 'TDid='&form.TDid>
							</cfif> 
						</cfif>
						
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
								<cflocation url="registroPagosE.cfm#parametros#">
							<cfelse>
								<cflocation url="registroPagosEFiltro.cfm">
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
							<cfinvokeargument name="formatos" value="V,V, V, D, M"/>
							<cfinvokeargument name="align" value="left,left, left, left, right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="irA" value="registroPagosE.cfm"/> 
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="maxrows" value="18"/>
						</cfinvoke>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center"><input type="button" name="Regresar" value="<< Regresar" onclick="location.href='registroPagosEFiltro.cfm'"></td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>