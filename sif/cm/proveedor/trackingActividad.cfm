<cf_templateheader title="Registro Actividades por Tracking">
			<cf_web_portlet_start titulo="Registro Actividades por Tracking">
					<table width="100%" cellpadding="0" cellspacing="0">
                  <tr>
							<td valign="top">
                            <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
								<cfquery name="rsLista" datasource="sifpublica">
									select 
                                    			CMATid, 
                                    			CMATcodigo, 
                                                CMATdescripcion,
                                                '<img border=''0'' src=''/cfmx/rh/imagenes/' #_Cat# coalesce((case ETA_R when 0 then 'un' end),rtrim(''))  #_Cat# 'checked.gif''>'  as ETA_R,
                                                '<img border=''0'' src=''/cfmx/rh/imagenes/' #_Cat# coalesce((case CMATFDO when 0 then 'un' end),rtrim(''))  #_Cat# 'checked.gif''>'  as DO,
                                                '<img border=''0'' src=''/cfmx/rh/imagenes/' #_Cat# coalesce((case ETA_A when 0 then 'un' end),rtrim(''))  #_Cat# 'checked.gif''>'  as ETA_A,
												'<img border=''0'' src=''/cfmx/rh/imagenes/' #_Cat# coalesce((case ETS when 0 then 'un' end),rtrim(''))  #_Cat# 'checked.gif''>'  as ETS
									from CMActividadTracking
									where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								</cfquery>
								
								<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="CMATcodigo,CMATdescripcion,ETA_R, ETA_A, ETS, DO"/>
									<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, ETA_R, ETA_A, ETS, DO"/>
									<cfinvokeargument name="formatos" value="string,string,string,string,string, string,string"/>
									<cfinvokeargument name="align" value="left,left,left,left,left, left, left"/>
									<cfinvokeargument name="ajustar" value=""/>
									<cfinvokeargument name="irA" value="trackingActividad.cfm"/>
									<cfinvokeargument name="MaxRows" value="15"/>
									<cfinvokeargument name="debug" value="N"/>
                                    <cfinvokeargument name="conexion" value="sifpublica"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
								</cfinvoke>
							</td>
							<td valign="top"><cfinclude template="trackingActividad-form.cfm"></td>
						</tr>
					</table>
			<cf_web_portlet_end>
	<cf_templatefooter>
