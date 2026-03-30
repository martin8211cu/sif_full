<cfif isdefined("url.ETidtracking") and not isdefined("form.ETidtracking")>
	<cfset form.ETidtracking = url.ETidtracking >
</cfif>

<cf_templateheader title="	Seguimiento de Embarques">
			<cf_web_portlet_start titulo="Seguimiento de Embarques">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td valign="top"><cfinclude template="trackingSeguimiento-form.cfm"></td>
						</tr>
						<tr>
							<td align="center">
								<table width="98%" align="center" cellpadding="0" cellspacing="0">
									<TR>
										<TD>
											<cfquery name="rsLista" datasource="sifpublica">
												select ETidtracking,
													   DTidtracking, 
													   DTactividad, 
													   case DTtipo 
													   when 'E' then 'Llegada' 
													   when 'S' then 'Salida' 
													   when 'T' then 'Entrega'
													   when 'C' then 'Consolidacion'
													   when 'M' then 'Transaccion'
													   else '' end as DTtipo, 
													   DTfechaincidencia,
													   DTfechaest,
													   DTubicacion
												from DTracking
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												and ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETidtracking#">
												and DTtipo in ('E', 'S', 'T', 'C', 'M')
												order by DTfechaincidencia desc
											</cfquery>
											
											<cfinvoke 
											 component="sif.Componentes.pListas"
											 method="pListaQuery"
											 returnvariable="pListaRet">
												<cfinvokeargument name="query" value="#rsLista#"/>
												<cfinvokeargument name="desplegar" value="DTtipo, DTactividad, DTfechaincidencia, DTfechaincidencia, DTfechaest, DTubicacion"/>
												<cfinvokeargument name="etiquetas" value="Tipo de Actividad, Actividad, Fecha Entrada / Salida, Hora, Fecha Estimada Llegada, Ubicaci&oacute;n"/>
												<cfinvokeargument name="formatos" value="V,V,D,H,D,V"/>
												<cfinvokeargument name="align" value="left,left,center,center,center,left"/>
												<cfinvokeargument name="ajustar" value=""/>
												<cfinvokeargument name="irA" value="trackingSeguimiento.cfm"/>
												<cfinvokeargument name="formName" value="lista"/>
												<cfinvokeargument name="MaxRows" value="15"/>
												<cfinvokeargument name="debug" value="N"/>
												<cfinvokeargument name="showEmptyListMsg" value="true"/>
												<cfinvokeargument name="conexion" value="sifpublica"/>
												<cfinvokeargument name="keys" value="ETidtracking, DTidtracking"/>
											</cfinvoke>
										</TD>
									</TR>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
			<cf_web_portlet_end>
	<cf_templatefooter>
