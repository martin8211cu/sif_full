<!--- 	
	Modificado por: Ana Villavicencio
	Fecha: 16 de setiembre del 2005
	Motivo: Se modificó la variable de navegación, ya q no estaba tomando en cuenta los datos del filtro.
			Se agrego un campo mas en la lista, tipo de transaccion.
			
 --->
<cfif isdefined("url.btnFiltro")>
	<cfset form.btnFiltro = "filtrar">
</cfif>
<cf_templateheader title=" Reimpresi&oacute;n de Facturas">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reimpresi&oacute;n de Facturas'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">

			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	    		<tr>
      				<td>
						<cfinclude template="reimprimeFactura-filtro.cfm">
						<cfset navegacion = "&btnFiltro=filtrar">

						<cfif isdefined("form.btnFiltro")>
							<cfif isdefined("form.fDreferencia") and len(trim(form.fDreferencia)) >
								<cfset navegacion = navegacion & "&fDreferencia=#form.fDreferencia#">
							</cfif>

							<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo)) >
								<cfset navegacion = navegacion & "&SNcodigo=#form.SNcodigo#">
							</cfif>
							<cfif isdefined("Form.fEDAfecha") and len(trim(form.fEDAfecha))>
								<cfset navegacion = navegacion & "&fEDAfecha=#form.fEDAfecha#">
							</cfif>
							
							
							<cf_dbfunction name="to_char" args="a.EDAfechaglobal" returnvariable = "EDAfechaglobalV">
							<cf_dbfunction name="to_date" args="#PreserveSingleQuotes(EDAfechaglobalV)#" returnvariable="EDAfechaglobal">
							<cfinclude template="../../Utiles/sifConcat.cfm">
							<cfquery name="rsLista" datasource="#session.DSN#">
								select distinct 
									a.Dreferencia, 
									a.SNcodigo, 
									b.SNnumero, 
									b.SNnombre, 
									#PreserveSingleQuotes(EDAfechaglobal)# as EDAfechaglobal, 
									a.EDAtotalglobal, 
									c.CCTtipo, c.CCTcodigo #_Cat# '-' #_Cat# c.CCTdescripcion as Transaccion
								from EDocumentosAgrupados a
								
								inner join SNegocios b
								on a.SNcodigo=b.SNcodigo
								and a.Ecodigo=b.Ecodigo
								
								inner join CCTransacciones c
								   on a.Ecodigo = c.Ecodigo and 
								      a.CCTcodigo = c.CCTcodigo
									  
								where a.EDAestado in ('I','R', 'P')
								  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  
								<cfif isdefined("form.fDreferencia") and len(trim(form.fDreferencia))>
									and a.Dreferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fDreferencia#">
								</cfif>  

								<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
									and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
								</cfif>  
								
								<cfif isdefined("form.fEDAfecha") and len(trim(form.fEDAfecha))>
									and a.EDAfechaglobal = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fEDAfecha)#">
								</cfif>  
								
								order by Dreferencia
							</cfquery>
	
							<cfinvoke 
									component="sif.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsLista#"/>
								<cfinvokeargument name="desplegar" value="Dreferencia,Transaccion,SNnumero, SNnombre, EDAfechaglobal, EDAtotalglobal"/>
								<cfinvokeargument name="etiquetas" value="Referencia, Transacci&oacute;n,N&uacute;mero de Socio, Nombre de Socio, Fecha, Monto"/>
								<cfinvokeargument name="formatos" value="V, V, V, V, D, M"/>
								<cfinvokeargument name="align" value="center, left, left, left, left, right"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="irA" value="reimprimeFactura-sql.cfm"/>
                                <cfinvokeargument name="form_method" value="get"/>
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
								<cfinvokeargument name="keys" value="Dreferencia"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
								<cfinvokeargument name="maxRows" value="15"/>							
							</cfinvoke>
						<cfelse>	
							<br>
							<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
								<tr><td><strong>Reimpresi&oacute;n de Facturas</strong></td></tr>
								<tr><td >Para el proceso de Reimpresi&oacute;n de facturas, debe seleccionar un valor para los siguientes criterios de selecci&oacute;n:</td></tr>
								<tr><td style="padding-left:20px;"><li>Socio de Negocios</li></td></tr>
								<tr><td style="padding-left:20px;"><li>Fecha</li></td></tr>
							</table>
						</cfif>
					</td>
				</tr>
				
				<tr><td>&nbsp;</td></tr>
				
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>