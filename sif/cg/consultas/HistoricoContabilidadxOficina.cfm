<!--- 
	Modificad por Gustavo Fonseca H.
		Fecha: 3-3-2006.
		Motivo: Se corrige la etiqueta desde.
	
 --->
	<cf_templateheader title="Histórico de Contabilidad por Mes">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<br>
	<cfquery datasource="#Session.DSN#" name="rsOficinas">
		select Ocodigo, Odescripcion
		from Oficinas 
		where Ecodigo =  #Session.Ecodigo# order by Ocodigo 
	</cfquery>
	
	 <cfquery name="rsMonedas" datasource="#Session.DSN#">
		select Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
		from Monedas
		where Ecodigo =  #Session.Ecodigo# 
	</cfquery>
	<cfset longitud = len(Trim(rsMonedas.Miso4217))>
			
	<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
		select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
		from Empresas a
			inner join Monedas b
				on a.Mcodigo = b.Mcodigo
		where a.Ecodigo =  #Session.Ecodigo# 
		  and a.Ecodigo = b.Ecodigo
	</cfquery>
			
	<cfquery name="rsParam" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = 660
	</cfquery>
	
	<cfif rsParam.recordCount> 
		<cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo = #Session.Ecodigo#
			  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParam.Pvalor#">
		</cfquery>
	</cfif>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
		     	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Histórico de Contabilidad'>
	
		  <cfinclude template="Funciones.cfm">
		  <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		  <cfset periodo="#get_val(30).Pvalor#">
	   	  <cfset mes="#get_val(40).Pvalor#">

					

		  <form name="form1" method="get" action="HistoricoContabilidad2xOficina.cfm" onsubmit="return sinbotones()">
              <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            	<tr><td colspan="5" align="right"><cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Balance_comprobacion.htm"></td></tr>
				<tr> 
                  <td nowrap> <div align="right"></div></td>
                  <td width="21%" nowrap> <div align="right"></div></td>
                  <td colspan="3">&nbsp;</td>
                </tr>
                <tr> 
                  <td nowrap width="19%">&nbsp;</td>
                  <td nowrap><div align="right">Desde:&nbsp;</div></td>
                  <td width="14%">
                    <select name="periodo">
                      <option value="<cfoutput>#periodo-2#</cfoutput>"><cfoutput>#periodo-2#</cfoutput></option>
                      <option value="<cfoutput>#periodo-1#</cfoutput>"><cfoutput>#periodo-1#</cfoutput></option>
                      <option value="<cfoutput>#periodo#</cfoutput>" selected><cfoutput>#periodo#</cfoutput></option>
                      <option value="<cfoutput>#periodo+1#</cfoutput>"><cfoutput>#periodo+1#</cfoutput></option>
                      <option value="<cfoutput>#periodo+2#</cfoutput>"><cfoutput>#periodo+2#</cfoutput></option>
                    </select>
                  </td>
                  <td width="24%"><select name="mes" size="1">
                      <option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
                      <option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
                      <option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
                      <option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
                      <option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
                      <option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
                      <option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
                      <option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
                      <option value="9" <cfif mes EQ 9>selected</cfif>>Setiembre</option>
                      <option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
                      <option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
                      <option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
                    </select></td>
                  <td width="22%">&nbsp;</td>
                </tr>
                <tr> 
                  <td nowrap>&nbsp;</td>
                  <td nowrap><div align="right">Hasta:&nbsp;</div></td>
                  <td><select name="periodo2">
                      <option value="<cfoutput>#periodo-2#</cfoutput>"><cfoutput>#periodo-2#</cfoutput></option>
                      <option value="<cfoutput>#periodo-1#</cfoutput>"><cfoutput>#periodo-1#</cfoutput></option>
                      <option value="<cfoutput>#periodo#</cfoutput>" selected><cfoutput>#periodo#</cfoutput></option>
                      <option value="<cfoutput>#periodo+1#</cfoutput>"><cfoutput>#periodo+1#</cfoutput></option>
                      <option value="<cfoutput>#periodo+2#</cfoutput>"><cfoutput>#periodo+2#</cfoutput></option>
                    </select>
                  </td>
                  <td><select name="mes2" size="1">
                      <option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
                      <option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
                      <option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
                      <option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
                      <option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
                      <option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
                      <option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
                      <option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
                      <option value="9" <cfif mes EQ 9>selected</cfif>>Setiembre</option>
                      <option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
                      <option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
                      <option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
                  </select></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td nowrap>&nbsp;</td>
                  <td nowrap> <div align="right">Cuenta Inicial:&nbsp;</div></td>
                  <td colspan="3" nowrap> 
					<cf_cuentas NoVerificarPres="yes" cformato="Cformato1" cdescripcion="Cdescripcion1" ccuenta="Ccuenta1" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta1" descwidth="40">
				  </td>
                </tr>
                <tr> 
                  <td nowrap>&nbsp;</td>
                  <td nowrap> <div align="right">Cuenta Final:&nbsp;</div></td>
				  <td colspan="3" nowrap> 
					<cf_cuentas NoVerificarPres="yes" cformato="Cformato2" cdescripcion="Cdescripcion2" ccuenta="Ccuenta2" MOVIMIENTO="S" AUXILIARES="N" frame="frcuenta2" descwidth="40">
				  </td>
                </tr>
                <tr>
                  <td nowrap>&nbsp;</td>
                  <td align="right" nowrap>Oficina:&nbsp; </td>
                  <td nowrap><select name="Ocodigo" id="select">
                      <option value="-1">Todas</option>
                      <cfoutput query="rsOficinas">
                        <option value="#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option>
                      </cfoutput>
                  </select></td>
                  <td nowrap>&nbsp;</td>
                </tr>
                <tr>
                  <td align="right" nowrap>&nbsp;</td>
                  <td nowrap valign="top"><div align="right">Moneda:</div></td>
                  <td colspan="3" rowspan="2" valign="top">
                    <table border="0" cellspacing="0" cellpadding="2">
                      <tr>
                        <td nowrap><input name="mcodigoopt" type="radio" value="-2" checked></td>
                        <td nowrap> Local:</td>
                        <td><cfoutput><strong>#rsMonedaLocal.Mnombre#</strong></cfoutput></td>
                      </tr>
                      <cfif isdefined("rsMonedaConvertida")>
                      </cfif>
                      <tr>
                        <td nowrap><input name="mcodigoopt" type="radio" value="0"></td>
                        <td nowrap> Origen:</td>
                        <td><select name="Mcodigo">
                            <cfoutput query="rsMonedas">
                              <option value="#rsMonedas.Mcodigo#"
						   <cfif isdefined('rsMonedas') and isdefined('rsMonedaLocal')>
								<cfif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo >selected</cfif>
							</cfif>
							>#rsMonedas.Mnombre#</option>
                            </cfoutput>
                        </select></td>
                      </tr>
                      <tr>
                        <td nowrap><input type="checkbox" name="ckOrdenXMonto" value="1" title="Ordenar por monto"></td>
                        <td colspan="2" nowrap>Ordenar por monto</td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td align="right" nowrap>&nbsp;</td>
                  <td nowrap><div align="right">&nbsp;</div></td>
                </tr>
				<tr>
					<td colspan="5"><div align="center"><strong>Formato:&nbsp;</strong>
					<select name="Formato" id="Formato" tabindex="1">
						<option value="1">FLASHPAPER</option>
						<option value="2">PDF</option>
						<option value="3">EXCEL</option>
					</select>
					</div>
					</td>
				</tr>
                <tr> 
                  <td nowrap> 
                    <div align="right"></div>
                  </td>
                  <td nowrap>&nbsp;</td>
                  <td nowrap>
                    <div align="left">                  </div></td>
                  <td >&nbsp;</td>
                  <td >&nbsp;</td> 
                </tr>
                <tr> 
                  <td colspan="5"> 
                    <div align="center"> 
                      <input type="submit" name="Submit" value="Consultar">&nbsp;
					  <input type="Reset" name="Limpiar" value="Limpiar">
                    </div>
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td> 
                    <div align="right"></div>
                  </td>
                  <td colspan="3">&nbsp;</td>
                </tr>
              </table>
			  <div align="center"></div>
            </form>
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>