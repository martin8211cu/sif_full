	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cfif isdefined("url.fTcodigo") and len(trim(url.fTcodigo))>
			<cfset form.fTcodigo = url.fTcodigo >
		</cfif>
		<cfif isdefined("url.fCPcodigo") and len(trim(url.fCPcodigo))>
			<cfset form.fCPcodigo = url.fCPcodigo >
		</cfif>
		<cfif isdefined("url.fecha1") and len(trim(url.fecha1))>
			<cfset form.fecha1 = url.fecha1 >
		</cfif>
		<cfif isdefined("url.fecha2") and len(trim(url.fecha2))>
			<cfset form.fecha2 = url.fecha2 >
		</cfif>
		<cfif isdefined("url.pageNum_lista") and len(trim(url.pageNum_lista))>
			<cfset form.pageNum_lista = url.pageNum_lista >
		</cfif>

		<!--- Traduccion --->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Tipo_de_Nomina" 			
			Default="Tipo de N&oacute;mina"
			xmlfile="/rh/generales.xml"			
			returnvariable="vTipoNomina"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Fecha_Inicio" 			
			Default="Fecha Inicio"
			xmlfile="/rh/generales.xml"			
			returnvariable="vFechaInicio"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="BTN_Filtrar"
			Default="Filtrar"
			xmlfile="/rh/generales.xml"			
			returnvariable="vFiltrar"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Fecha_Final"
			Default="Fecha Final"
			xmlfile="/rh/generales.xml"			
			returnvariable="vFechaFinal"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Nomina"
			Default="N&oacute;mina"
			returnvariable="vNomina"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Calendario_de_Pago"
			Default="Calendario de Pago"
			returnvariable="vCalendario"/>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_Reporte_de_Revision_Contable"
			Default="Reporte de Revisi&oacute;n Contable"
			returnvariable="vTitulo"/>

		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#vTitulo#">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td>
						<cfoutput>
						<form method="post" name="filtro" action="revisionContable-filtro.cfm" style="margin:0;">
							<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
								<tr >
									<td colspan="4"></td>
									<td rowspan="3" valign="middle"><input type="submit" class="btnFiltrar" name="btnFiltrar" value="#vFiltrar#" /></td>
								</tr>
								<tr>
									<td><strong>#vTipoNomina#:</strong></td>
									<td>
										<cfquery name="rsTipo" datasource="#session.DSN#">
											select a.Tcodigo, a.Tdescripcion
											from TiposNomina a
											where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and exists ( select 1
														 from HRCalculoNomina
														 where Ecodigo = a.Ecodigo
														   and Tcodigo = a.Tcodigo
														   <!--- and IDcontable is not null  --->)
											order by a.Tcodigo
										</cfquery>
										<select name="fTcodigo" >
											<option value="">-Todas-</option>
											<cfloop query="rsTipo">
												<option value="#rsTipo.Tcodigo#" <cfif isdefined("form.fTcodigo") and trim(form.fTcodigo) eq trim(rsTipo.Tcodigo) >selected</cfif> >#trim(rsTipo.Tcodigo)# - #rsTipo.Tdescripcion#</option>
											</cfloop>
										</select>
									</td>
									<td><strong>#vFechaInicio#:</strong></td>
									<td>
										<cfset vFecha1 = ''>
										<cfif isdefined("form.fecha1") and len(trim(form.fecha1))>
											<cfset vFecha1 = form.fecha1 >
										</cfif>
										<cf_sifcalendario form="filtro" name="fecha1" value="#vFecha1#">
									</td>
								</tr>
								<tr>
									<td><strong>#vCalendario#:</strong></td>
									<td><input name="fCPcodigo" size="15" maxlength="12" value="<cfif isdefined('form.fCPcodigo') and len(trim(form.fCPcodigo)) >#form.fCPcodigo#</cfif>" /></td>
									<td><strong>#vFechaFinal#:</strong></td>
									<td>
										<cfset vFecha2 = ''>
										<cfif isdefined("form.fecha2") and len(trim(form.fecha2))>
											<cfset vFecha2 = form.fecha2 >
										</cfif>
										<cf_sifcalendario form="filtro" name="fecha2" value="#vFecha2#" >
									</td>
								</tr>
							</table>
						</form>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td>
						<cfset navegacion = '' >
						<cfif isdefined("form.fTcodigo") and len(trim(form.fTcodigo))>
							<cfset navegacion = navegacion & '&fTcodigo=#trim(form.fTcodigo)#' >
						</cfif>
						<cfif isdefined("form.fCPcodigo") and len(trim(form.fCPcodigo))>
							<cfset navegacion = navegacion & '&fCPcodigo=#trim(form.fCPcodigo)#' >
						</cfif>
						<cfif isdefined("form.fecha1") and len(trim(form.fecha1))>
							<cfset navegacion = navegacion & '&fecha1=#trim(form.fecha1)#' >
						</cfif>
						<cfif isdefined("form.fecha2") and len(trim(form.fecha2))>
							<cfset navegacion = navegacion & '&fecha2=#trim(form.fecha2)#' >
						</cfif>
						
						<cfparam name="form.fecha1" default="01/01/1900">
						<cfparam name="form.fecha2" default="01/01/6100">
						<cfif isdefined("form.fecha1") and len(trim(form.fecha1)) eq 0 >
							<cfset form.fecha1 = '01/01/1900' >
						</cfif>
						<cfif isdefined("form.fecha2") and len(trim(form.fecha2)) eq 0 >
							<cfset form.fecha2 = '01/01/6100' >
						</cfif>
						
						<cfparam name="form.pageNum_lista" default="1">
						
						<cfquery name="rsLista" datasource="#Session.DSN#">
							select a.RCNid, 
								   cp.CPcodigo, 
								   a.RCDescripcion, 
								   a.RChasta, 
								   a.RCdesde, 
								   {fn concat( {fn concat(rtrim(a.Tcodigo), ' - ')},  b.Tdescripcion)} as Tcodigo_desc,
								   b.Tcodigo
							from RCalculoNomina a
							
							inner join CalendarioPagos cp
							on cp.CPid=a.RCNid
							<cfif isdefined("form.fCPcodigo") and len(trim(form.fCPcodigo))>
								and upper(cp.CPcodigo) like '%#ucase(form.fCPcodigo)#%'
							</cfif>
							
							inner join TiposNomina b
							on b.Ecodigo=a.Ecodigo
							and b.Tcodigo=a.Tcodigo
							
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							<!--- and a.IDcontable is not null --->
							and RCestado = 3
							
							and a.RChasta between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha1)#"> 
							                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha2)#">
							
							<cfif isdefined("form.fTcodigo") and len(trim(form.fTcodigo))>
								and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fTcodigo#">
							</cfif>
							
							order by a.Tcodigo, cp.CPcodigo, a.RCDescripcion
						</cfquery>
			
						<form name="form1" method="post" style="margin:0" action="revisionContable.cfm"  >
							<cfinvoke 
							 component="rh.Componentes.pListas"
							 method="pListaQuery"
							 returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsLista#"/>
								<cfinvokeargument name="desplegar" value="CPcodigo,RCDescripcion,RCdesde,RChasta"/>
								<cfinvokeargument name="etiquetas" value="#vCalendario#,#vNomina#,#vFechaInicio#,#vFechaFinal#"/>
								<cfinvokeargument name="formatos" value="V,V,D,D"/>
								<cfinvokeargument name="align" value="left, left, center, center"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="keys" value="RCNid"/>
								<cfinvokeargument name="debug" value="N"/>
								<cfinvokeargument name="cortes" value="Tcodigo"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
								<cfinvokeargument name="incluyeForm" value="false"/>
								<cfinvokeargument name="formName" value="form1"/>
								<cfinvokeargument name="irA" value="revisionContable.cfm"/>
							</cfinvoke>
						</form>
					</td>
				</tr>
			</table>						
		<cf_web_portlet_end>
	<cf_templatefooter>
