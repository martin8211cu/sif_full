<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CODIGO" Default="C&oacute;digo" XmlFile="/rh/generales.xml" returnvariable="LB_CODIGO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DESCRIPCION" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ValorEmpleado" Default="Valor Empleado" returnvariable="LB_ValorEmpleado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ValorPatrono" Default="Valor Patrono" returnvariable="LB_ValorPatrono" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_METODO" Default="Método" XmlFile="/rh/generales.xml" returnvariable="LB_METODO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_RegistroDeCargasObreroPatronales" Default="Registro de Cargas Obrero Patronales" XmlFile="/rh/generales.xml"  returnvariable="LB_RegistroDeCargasObreroPatronales" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
		<cfparam name="filtro" default=" ">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_RegistroDeCargasObreroPatronales#">
						
						<!--- ******* Para el manejo de la navegacion *********---->
						<cfif isdefined("url.ECid") and not isdefined("form.ECid") >
							<cfset form.ECid = url.ECid >
						</cfif>
						<cfif isdefined("url.Modo") and not isdefined("form.Modo") >
							<cfset form.Modo = url.Modo >
						</cfif>

						<cfset navegacion = ""><!---Variable con los valores de la navegacion---->
						<cfif isdefined("form.ECid") and len(trim(form.ECid)) >
							<cfset navegacion = navegacion & "&ECid=#form.ECid#">
						</cfif>	
						<cfif isdefined("form.Modo") and len(trim(form.Modo)) >
							<cfset navegacion = navegacion & "&Modo=#form.Modo#">
						</cfif>						
						<cfset modo = 'ALTA'>
						<cfif isdefined("form.ECid") and len(trim(form.ECid))>
							<cfset modo = 'CAMBIO'>
						</cfif>
 						
						<!-- modo para el detalle -->
						<cfif isdefined("Form.DClinea")>
							<cfset modoDet ="CAMBIO">
						<cfelse>
							<cfif not isdefined("Form.DRlinea")>
								<cfset modoDet = "ALTA">
							<cfelseif Form.modoDet EQ "CAMBIO">
								<cfset modoDet = "CAMBIO">
							<cfelse>
								<cfset modoDet = "ALTA">
							</cfif>
						</cfif>
		
						<cfif isdefined("Form.NuevoL")>
							<cfset modo = "ALTA">
						</cfif>	
						
						<cfset ECid = "">
						<cfset DClinea = "">
												
						<cfif not isDefined("Form.NuevoE")>
							<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
								<cfset arreglo = ListToArray(Form.datos,"|")>
								<cfset ECid = Trim(arreglo[1])>
							<cfelse>
								<cfif not isDefined("Form.ECid")>
									<cflocation addtoken="no" url="listaCargasOP.cfm"><!--- url="../../nomina/catalogos/listaCargasOP.cfm"---->	
								<cfelse>
									<cfif Len(Trim(Form.ECid)) NEQ 0 and Trim(Form.ECid) NEQ "">
										<cfset ECid = Form.ECid>
									</cfif>
								</cfif>
						
							</cfif>
						</cfif>
		
						<cfif Len(Trim(ECid)) NEQ 0 >
							<cfquery name="rsLineas" datasource="#Session.DSN#">
								select 
									a.ECid, 
									a.DClinea,
									a.SNcodigo,
									c.SNnombre,
									a.DCcodigo,
									a.DCmetodo,
									case when a.DCmetodo = 1 then '%' else '' end as Simbolo,
									a.DCdescripcion,
									a.DCvaloremp,
									a.DCvalorpat,
									a.DCprovision,					
									a.ts_rversion					
								from DCargas a, ECargas b, SNegocios c
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">								  
								  and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
								  and a.Ecodigo = b.Ecodigo				  
								  and a.ECid = b.ECid
								  and a.Ecodigo = c.Ecodigo				  
								  and a.SNcodigo = c.SNcodigo				  
								order by a.DClinea
							</cfquery>		
						</cfif>

						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td colspan="2">
									<cfset Regresar = "listaCargasOP.cfm">
									<cfinclude template="/rh/portlets/pNavegacion.cfm">
								</td>          
							</tr>							
							<tr> 
								<cfif modo neq 'ALTA'>
									<td valign="top" nowrap width="50%">
										<cfquery name="rsLista" datasource="#session.DSN#">
											select a.ECid, a.DClinea, a.DCcodigo, a.DCdescripcion , a.DCvaloremp, a.DCvalorpat, b.RHCSATid, 
												   case when a.DCmetodo = 1 then 'Porcentaje' when a.DCmetodo = 2 then 'Porcentaje/Sal. M&iacute;nimo' else 'Monto' end as Metodo
											from DCargas a
											inner join ECargas b 
												on  a.Ecodigo = b.Ecodigo				  
											where 	a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"><!---#Session.Ecodigo#--->
												and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#"><!---#form.ECid#--->
												and a.ECid = b.ECid					
											order by a.DClinea 													  
										</cfquery>
										<cfinvoke 
											component="rh.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet">
											<cfinvokeargument name="query" value="#rsLista#"/>
											<cfinvokeargument name="desplegar" value="DCcodigo,DCdescripcion,DCvaloremp,DCvalorpat, Metodo"/>
											<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#,#LB_ValorEmpleado#,#LB_ValorPatrono#,#LB_METODO#"/>
											<cfinvokeargument name="formatos" value="V,V,N,N,S"/>
											<cfinvokeargument name="filtro" value="#filtro#"/>
											<cfinvokeargument name="align" value="left,left,right,right,left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
											<cfinvokeargument name="irA" value="CargasOP.cfm"/>
											<cfinvokeargument name="keys" value="DClinea"/>
											<cfinvokeargument name="showEmptyListMsg" value="true"/>
											<cfinvokeargument name="navegacion" value="#navegacion#"/>
										</cfinvoke>
									</td>
								</cfif>		
								<td valign="top" nowrap  width="50%" align="center"><cfinclude template="formCargasOP.cfm"></td>
							</tr>			
						</table>		  
	                <cf_web_portlet_end>
		            <script language="JavaScript1.2">
						// Link de cada línea que pasa los datos
						function Editar(data) {
							if (data!="") {
								document.form2.action='CargasOP.cfm';
								document.form2.datos.value=data;
								document.form2.submit();
							}
							return false;
						}
		            </script>	  
				</td>	
			</tr>
		</table>	
<cf_templatefooter>