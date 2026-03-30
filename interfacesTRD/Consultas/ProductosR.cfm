<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 2-3-2006.
		Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el 
		rendimiento de la pantalla.

	Modificado por Gustavo Fonseca H.
		Fecha: 21-3-2006.
		Motivo: Se agrega las opciones de pdf y excel al combo de formatos.
 --->
<cf_templateheader title="Balance de Comprobación">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Balance de Comprobaci&oacute;n'>
			<cfinclude template="../../portlets/pNavegacion.cfm">

			<!--- Variables --->
			<cfparam name="url.ubicacion" default="">

			<!--- consultas --->
			<cfquery datasource="#Session.DSN#" name="rsOficinas">
				select Ocodigo, Odescripcion
				from Oficinas 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
				order by Odescripcion
			</cfquery>

			<cfquery name="rsGE" datasource="#session.DSN#">			
				select ge.GEid, ge.GEnombre
				from AnexoGEmpresa ge
					join AnexoGEmpresaDet gd
						on ge.GEid = gd.GEid
				where ge.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				  and gd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				order by ge.GEnombre
			</cfquery>

			<cfquery name="rsGO" datasource="#session.DSN#">
				select GOid, GOnombre
				from AnexoGOficina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				order by GOnombre
			</cfquery>

			<cfquery datasource="#Session.DSN#" name="rsNivelDef">
				select ltrim(rtrim(Pvalor)) as valor
				from Parametros 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
				and Pcodigo = 10 
			</cfquery>
			
			<cfquery name="rsPeriodos" datasource="#Session.DSN#">
				select distinct Speriodo
				from CGPeriodosProcesados
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				order by Speriodo desc
			</cfquery>
			
			<cfset nivelDef="#ArrayLen(ListtoArray(rsNivelDef.valor, '-'))#">
			<cfinclude template="Funciones.cfm">
			<cfset periodo="#get_val(30).Pvalor#">
			<cfset mes="#get_val(40).Pvalor#">			
			
			<cfquery name="rsMonedas" datasource="#Session.DSN#">
				select convert(varchar,Mcodigo) as Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
				from Monedas
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset longitud = len(Trim(rsMonedas.Miso4217))>
			
			<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
				select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
				from Empresas a, Monedas b
				where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and a.Ecodigo = b.Ecodigo
				and a.Mcodigo = b.Mcodigo
			</cfquery>
			
			<cfquery name="rsParam" datasource="#Session.DSN#">
				select Pvalor
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Pcodigo = 660
			</cfquery>
			
			<cfif rsParam.recordCount> 
				<cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
					select Mcodigo, Mnombre
					from Monedas
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParam.Pvalor#">
				</cfquery>
			</cfif>
			<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
			<form name="form1" method="get" action="SQLBalCompR2_Pre.cfm" style="margin:0; " onsubmit="return sinbotones()">
		 
			<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
            	<tr><td colspan="5" align="right"><cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Balance_comprobacion.htm"></td></tr>
                <tr> 
                	<td nowrap width="20%"> <div align="right">Empresa u oficina:&nbsp;</div></td>
                  	<td> 

						<cfoutput>
			          	<select name="ubicacion" id="ubicacion" style="width:200px">
						  	<optgroup label="Empresa">
								<option value="" <cfif Len(url.ubicacion) EQ 0> selected</cfif>> #HTMLEditFormat(session.Enombre)#</option>
				            </optgroup>

				            <optgroup label="Oficina">
					            <cfloop query="rsOficinas">
									<option value="of,#rsOficinas.Ocodigo#"  <cfif url.ubicacion eq 'of,' & rsOficinas.Ocodigo>selected</cfif> > #HTMLEditFormat(rsOficinas.Odescripcion)#</option>
				    	        </cfloop>
				            </optgroup>

				            <cfif rsGE.RecordCount>
								<optgroup label="Grupo de Empresas">
					              	<cfloop query="rsGE">
    						            <option value="ge,#rsGE.GEid#" <cfif url.ubicacion eq 'ge,' & rsGE.GEid>selected</cfif> > #HTMLEditFormat(rsGE.GEnombre)#</option>
					 				</cfloop>
					           </optgroup>
				            </cfif>

				            <cfif rsGO.RecordCount>
				     			<optgroup label="Grupo de Oficinas">
					            	<cfloop query="rsGO">
					                	<option value="go,#rsGO.GOid#"  <cfif url.ubicacion eq 'go,' & rsGO.GOid>selected</cfif> > #HTMLEditFormat(rsGO.GOnombre)#</option>
					              	</cfloop>
				              	</optgroup>
				            </cfif>
			          </select>
			          </cfoutput>
                  </td>
                  <td nowrap>&nbsp;</td>
                  <td nowrap><div align="right">Período:&nbsp;</div></td>
                  <td> 
                    <select name="periodo" tabindex="3">
						<cfloop query = "rsPeriodos">
							<option value="<cfoutput>#rsPeriodos.Speriodo#</cfoutput>"><cfoutput>#rsPeriodos.Speriodo#</cfoutput></option>" <cfif periodo EQ "#rsPeriodos.Speriodo#">selected</cfif>></option>
						</cfloop>
 					</select>
                  </td>
                </tr>
                <tr> 
                  <td nowrap><div align="right">Nivel:&nbsp;&nbsp;</div></td>
                  <td><select name="nivel" size="1" id="nivel" tabindex="3">
                    <cfloop index="i" from="1" to="6">
                      <option value="<cfoutput>#i#</cfoutput>"
						  	<cfif nivelDef EQ i>selected</cfif>> <cfoutput>#i#</cfoutput> </option>
                    </cfloop>
                  </select>
                  </td>
                  <td nowrap>&nbsp;</td>
                  <td nowrap><div align="right">Mes:&nbsp;</div></td>
                  <td> 
                    <select name="mes" size="1" tabindex="4">
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
                    </select>
                  </td>
                </tr>
                <tr> 
                  <td nowrap><div align="right">Moneda:&nbsp;</div></td>
                  <td rowspan="3" valign="top"><table border="0" cellspacing="0" cellpadding="2">
                    <tr>
                      <td nowrap><input name="mcodigoopt" type="radio" value="-2" checked tabindex="5"></td>
                      <td nowrap>                      Local:</td>
                      <td><cfoutput><strong>#rsMonedaLocal.Mnombre#</strong></cfoutput></td>
                    </tr>
					<cfif isdefined("rsMonedaConvertida")>
                    <tr>
                      <td nowrap><input name="mcodigoopt" type="radio" value="-3" tabindex="6"></td>
                      <td nowrap>                      Convertida:</td>
                      <td><cfoutput><strong>#rsMonedaConvertida.Mnombre#</strong></cfoutput></td>
                    </tr>
					</cfif>
                    <tr>
                      <td nowrap><input name="mcodigoopt" type="radio" value="0" tabindex="7"></td>
                      <td nowrap>                      Origen:</td>
                      <td><select name="Mcodigo" tabindex="8">
                        <cfoutput query="rsMonedas">
                          <option value="#rsMonedas.Mcodigo#"
						   <cfif isdefined('rsMonedas') and isdefined('rsMonedaLocal')>
								<cfif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo >selected</cfif>
							</cfif>
							>#rsMonedas.Mnombre#</option>
                        </cfoutput>
                      </select></td>
                    </tr>
                  </table></td>
                  <td nowrap>&nbsp;</td>
                  <td nowrap> <div align="right">Cuenta Inicial:&nbsp;</div></td>
                  <td nowrap> 
				  	<cf_sifCuentasMayor form="form1" Cmayor="cmayor_ccuenta1" Cdescripcion="Cdescripcion1" size="50" tabindex="9">
				  </td>
                </tr>
                <tr> 
                  <td nowrap>&nbsp;</td>
                  <td nowrap>&nbsp;</td>
                  <td nowrap> <div align="right">Cuenta Final:&nbsp;</div></td>
				  <td nowrap> 
					<cf_sifCuentasMayor form="form1" Cmayor="cmayor_ccuenta2" Cdescripcion="Cdescripcion2" size="50" tabindex="10">					
				  </td>
                </tr>
                <tr>
                  <td align="right" nowrap>&nbsp;</td>
                  <td nowrap>&nbsp;</td>
                  <td nowrap><div align="right">
                      <input type="checkbox" name="chkCeros" value="N" tabindex="12" onClick="javascript: if (this.value=='N') { this.value='S'} else {this.value='N'};">
                  </div></td>
                  <td nowrap> Mostrar Saldos Finales en Cero</td>
                </tr>
                <tr>
				  <td nowrap align="right">&nbsp;
				  	
				  </td>
                  <td>&nbsp;</td>
                  <td align="right" nowrap>&nbsp;</td>
                  <td nowrap align="right">
				  	<input type="checkbox" name="IncluirOficina" value="N" tabindex="14" onClick="javascript: if (this.value=='N') { this.value='S'} else {this.value='N'};">
				  </td>
                  <td>Saldos por Oficina</td>
                </tr>
				<tr>
					<td align="right" nowrap colspan="2">&nbsp;</td>
					<td nowrap>&nbsp;</td>
					<td nowrap><div align="right">
						<input type="checkbox" name="CHKMesCierre" value="1" tabindex="13">
					</div></td>
					<td colspan="5">Cierre Anual</td>
				</tr>
				<tr>
                  <td align="right" nowrap><div align="right">Formato:</div></td>
                  <td colspan="4">
				  	<select name="formato" tabindex="11">
                    	<option value="HTML">HTML</option>
						<option value="FlashPaper">FlashPaper</option>
						<option value="PDF">PDF</option>
        	          </select>
				  </td>
				</tr>				
                <tr> 
                  <td nowrap> 
                    <div align="right"></div>
                  </td>
                  <td>&nbsp;</td>
                  <td nowrap>&nbsp;</td>
                  <td nowrap> 
                    <div align="right">&nbsp;</div>
                  </td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="5"> 
                    <div align="center"> 
                      <input type="submit" name="Submit" value="Consultar" tabindex="14">&nbsp;
					  <input type="Reset" name="Limpiar" value="Limpiar" tabindex="15">
                    </div>
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
            </form>
		<cf_web_portlet_end>
<cf_templatefooter>