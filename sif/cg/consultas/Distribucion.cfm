 
	<cf_templateheader title="Distribucion por Conductor">
		
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Distribuciones por Conductor'>
					<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
					
						<cfquery name="rsDistribuciones" datasource="#Session.DSN#">
							select * from DCDistribucion
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and Tipo = 5
							order by Descripcion
						</cfquery>

						<cfquery name="rsPeriodos" datasource="#Session.DSN#">
							select distinct Periodo from DCD_PCClasificacionD
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							order by Periodo DESC
						</cfquery>
						
					  <form name="form1" method="post" action="Distribucion-sql.cfm" onsubmit="return sinbotones()">
						  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
							<tr> 
							  <td colspan="10">
								<cfinclude template="../../portlets/pNavegacion.cfm">
							  </td>
							</tr>
							<tr><td colspan="10" align="right">&nbsp;</td></tr>
							<tr>
							  <td width="15%" nowrap><div align="right"><strong>Distribuci&oacute;n:&nbsp;</strong></div></td>
							  <td width="25%">
								<select name="IDdistribucion" tabindex="1">
								<option value="0">(Seleccione)</option>
								<cfoutput query="rsDistribuciones">
								<option value="#IDdistribucion#">#Descripcion#</option>
								</cfoutput>
								</select>
							  </td>
							  <td nowrap>&nbsp;</td>
							  <td width="10%" align="right" nowrap> <strong>Periodo:</strong>&nbsp; </td>
							  <td width="20%" colspan="3" nowrap>
							  	<select name="Periodo" tabindex="1">
								<option value="-1">(Seleccione)</option>
								<cfoutput query="rsPeriodos">
								<option value="#Periodo#">#Periodo#</option>
								</cfoutput>
								</select>
							  </td>

							  <td nowrap>&nbsp;</td>
							  <td width="10%" align="right" nowrap> <strong>Mes:</strong>&nbsp; </td>
							  <td width="20%" colspan="3" nowrap>
							  <select name="Mes" tabindex="1">
								<option value="1">Enero</option>
								<option value="2">Febrero</option>
								<option value="3">Marzo</option>
								<option value="4">Abril</option>
								<option value="5">Mayo</option>
								<option value="6">Junio</option>
								<option value="7">Julio</option>
								<option value="8">Agosto</option>
								<option value="9">Setiembre</option>
								<option value="10">Octubre</option>
								<option value="11">Noviembre</option>
								<option value="12">Diciembre</option>
							  </select>							  
							  </td>
							  
							  <!---
							  <td nowrap>&nbsp;</td>
							  <td width="10%" align="right" nowrap> Formato:&nbsp; </td>
							  <td width="30%" colspan="3" nowrap>
								<select name="formato">
									<option value="0">Pantalla</option>
									<option value="1">Microsoft Excel</option>
								</select>		
							  </td>
							  --->

							</tr>
							<tr> 
							  <td colspan="10" nowrap>&nbsp;</td>
						    </tr>
							<tr> 
							  <td colspan="10" align="center"> 
								  <cf_botones values="Consultar" names="Consultar" tabindex="1">
							  </td>
							</tr>
							<tr> 
							  <td colspan="7">&nbsp;</td>
						    </tr>
						  </table>
					</form>
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>