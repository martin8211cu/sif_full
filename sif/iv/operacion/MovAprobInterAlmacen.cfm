<cf_templateheader title="Aprobación de Movimientos InterAlmacén">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">						
			<cfif isdefined("form.chk") AND isdefined("form.btnAplicar") >
                <cfset datos = ArrayNew(1)>
                <cfloop index = "index" list = "#Form.chk#" delimiters = ",">
                    <cfset i = 1>
                    <cfloop index = "index1" list = "#index#" delimiters = "|">
                        <cfset datos[i] = #index1# >
                        <cfset i = i + 1>
                    </cfloop>
                    <cfinvoke component="sif.Componentes.IN_MovInterAlmacen" method="MovInterAlmacen">
                        <cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
                        <cfinvokeargument name="EMid" value="#datos[1]#"/>				
                        <cfinvokeargument name="usuario" value="#Session.usuario#"/>						
                    </cfinvoke>	
                </cfloop>
                <cflocation addtoken="no" url="listaAprobMovInterAlmacen.cfm">
            </cfif>  
            <cfif isdefined("form.chk") AND isdefined("form.btnRechazar") >
                <cfset datos = ArrayNew(1)>
                <cfloop index = "index" list = "#Form.chk#" delimiters = ",">
                    <cfset i = 1>
                    <cfloop index = "index1" list = "#index#" delimiters = "|">
                        <cfset datos[i] = #index1# >
                        <cfset i = i + 1>
                    </cfloop>
                    <cfinvoke component="sif.Componentes.IN_MovInterAlmacen" method="MovInterAlmacenRechazo">
                        <cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
                        <cfinvokeargument name="EMid" value="#datos[1]#"/>				
                        <cfinvokeargument name="usuario" value="#Session.usuario#"/>						
                    </cfinvoke>	
                </cfloop>
                <cflocation addtoken="no" url="listaAprobMovInterAlmacen.cfm">
            </cfif>  
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Aprobaci&oacute;n de Movimientos InterAlmac&eacute;n'>
				<table border="0" width="100%" align="center" cellpadding="0" cellspacing="0">		
					<cfset regresar = "listaMovInterAlmacenconAprobacion.cfm">	
					<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
					
					<tr>
						<td align="center">
							<cfinclude template="formAProbMovInterAlmacen.cfm">
						</td>
					</tr>
					
					<tr align="center">
						<td align="center">
							<cfif isdefined('form.EMid') and len(trim(form.EMid)) gt 0 >
								<cfquery name="rsLista" datasource="#session.DSN#">
									select a.EMid, a.DMlinea, a.DMAid, a.DMcant, b.Adescripcion, 'CAMBIO' as modoDet, c.EMalm_Orig as AlmIni
									from DMinteralmacen a
									inner join Articulos b
									  on a.DMAid = b.Aid 
									inner join EMinteralmacen c
									  on a.EMid = c.EMid
									where a.EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EMid#">
									order by b.Adescripcion, a.DMcant
								</cfquery>
								<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="Adescripcion, DMcant"/>
									<cfinvokeargument name="etiquetas" value="Artículo, Cantidad"/>
									<cfinvokeargument name="formatos" value=""/>
									<cfinvokeargument name="align" value="left,left"/>
									<cfinvokeargument name="ajustar" value="N,N"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="irA" value="MovAProbInterAlmacen.cfm"/>
									<cfinvokeargument name="keys" value="DMlinea"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
								</cfinvoke>							
							<cfelse>
								<cfif not isdefined('Form.btnNuevo')>
								<cflocation addtoken="no" url='listaAprobMovInterAlmacen.cfm'>
								</cfif>	
							</cfif>
						</td>
					</tr>
				</table>	
			<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>