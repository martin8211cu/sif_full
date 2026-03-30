 
	<cf_templateheader title="Saldos Diarios">
		
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Saldos Diarios'>
					 <!--- <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>--->
					  <cfinclude template="Funciones.cfm">
					  <cfset periodo="#get_val(30).Pvalor#">
					  <cfset mes="#get_val(40).Pvalor#">
						<cfinclude template="../../Utiles/sifConcat.cfm">
						<cfquery name="rsCuentas" datasource="#Session.DSN#">
							select Cmayor, Cmayor #_Cat# ' - ' #_Cat# Cdescripcion as Cuenta
							from CtasMayor
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							order by 1
						</cfquery>
			
						<cfquery name="rsMonedas" datasource="#Session.DSN#">
							select Mcodigo, Miso4217 #_Cat# ' - ' #_Cat# Mnombre as Moneda
							from Monedas
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							order by 2
						</cfquery>

					  <form name="form1" method="post" action="SaldosDiarios-sql.cfm" <!---onsubmit="return sinbotones()"--->>
						  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
							<tr> 
							  <td colspan="10">
								<cfinclude template="../../portlets/pNavegacion.cfm">
							  </td>
							</tr>
							<tr><td colspan="10" align="right">&nbsp;</td></tr>
							<tr>
							  <td width="10%" nowrap><div align="right">Per&iacute;odo:&nbsp;</div></td>
							  <td width="10%">
								<select name="periodo" tabindex="1">
								  <option value="<cfoutput>#periodo-5#</cfoutput>"><cfoutput>#periodo-5#</cfoutput></option>
								  <option value="<cfoutput>#periodo-4#</cfoutput>"><cfoutput>#periodo-4#</cfoutput></option>
								  <option value="<cfoutput>#periodo-3#</cfoutput>"><cfoutput>#periodo-3#</cfoutput></option>
								  <option value="<cfoutput>#periodo-2#</cfoutput>"><cfoutput>#periodo-2#</cfoutput></option>
								  <option value="<cfoutput>#periodo-1#</cfoutput>"><cfoutput>#periodo-1#</cfoutput></option>
								  <option value="<cfoutput>#periodo#</cfoutput>" selected><cfoutput>#periodo#</cfoutput></option>
								</select>
							  </td>
							  <td nowrap>&nbsp;</td>
							  <td width="10%" align="right" nowrap> Cuenta:&nbsp; </td>
							  <td width="30%" colspan="3" nowrap>
							  	<select name="Cmayor" tabindex="1">
							  	<cfoutput query="rsCuentas">
									<option value="#rsCuentas.Cmayor#">#rsCuentas.Cuenta#</option>
								</cfoutput>
							  </select>							  
							  </td>

							  <td nowrap>&nbsp;</td>
							  <td width="10%" align="right" nowrap> Moneda:&nbsp; </td>
							  <td width="30%" colspan="3" nowrap>
							  	<select name="Mcodigo" tabindex="1">
								<option value="-1"> Todas </option>
							  	<cfoutput query="rsMonedas">
									<option value="#rsMonedas.Mcodigo#">#rsMonedas.Moneda#</option>
								</cfoutput>
							  </select>							  
							  </td>

							</tr>
							<tr> 
							  <td colspan="10" nowrap>&nbsp;</td>
						    </tr>
							<tr> 
							  <td colspan="10" align="center"> 
								  <cf_botones values="Consultar,Exportar" names="Consultar,Exportar" tabindex="1">
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