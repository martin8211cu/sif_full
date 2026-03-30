<cfinvoke key="CMB_Enero" 			default="Enero" 	returnvariable="CMB_Enero" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"	returnvariable="CMB_Febrero"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 	returnvariable="CMB_Marzo" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"		returnvariable="CMB_Abril"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"		returnvariable="CMB_Mayo"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 	returnvariable="CMB_Junio" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"		returnvariable="CMB_Julio"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 	returnvariable="CMB_Agosto" 	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"	returnvariable="CMB_Setiembre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"	returnvariable="CMB_Octubre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" returnvariable="CMB_Noviembre" 	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"	returnvariable="CMB_Diciembre"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Moneda" 			default="Moneda" 	returnvariable="MSG_Moneda" 	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Oficina" 		default="Oficina"	returnvariable="MSG_Oficina"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mes" 			default="Mes" 		returnvariable="CMB_Mes" 		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_Nivel" 			default="Nivel"		returnvariable="LB_Nivel"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CBM_Ninguno" 		default="Ninguno"	returnvariable="CBM_Ninguno"	component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_Todas"	 		default="Todas"		returnvariable="LB_Todas"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_ConCodigo"		default="Con Código"		returnvariable="LB_ConCodigo"		component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_GrupoOficinas" 	default="Grupo de Oficinas"	returnvariable="MSG_GrupoOficinas"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Periodo" 		default="Per&iacute;odo"	returnvariable="MSG_Periodo"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Local" 			default="Local"				returnvariable="MSG_Local"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Convertida" 		default="Convertida"		returnvariable="MSG_Convertida"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Informe_B15" 	default="Informe B15"		returnvariable="MSG_Informe_B15"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Origen" 			default="Origen"			returnvariable="MSG_Origen"			component="sif.Componentes.Translate" method="Translate"/>

  
<cf_templateheader title="Contabilidad General">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Balance General Detallado'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
		  <cfinclude template="Funciones.cfm">
		  <cfset periodo=get_val(30).Pvalor>
		  <cfset mes=get_val(40).Pvalor>
		  <cfset formato = get_val(10).Pvalor>
		  <cfset cantniv = ArrayLen(listtoarray(formato,'-'))>
		<cfset lvarB15V = get_val(3900).Pvalor>
		<cfif len(trim(lvarB15V)) gt 0>
			<cfset lvarB15M = get_moneda(lvarB15V).Mnombre>
		<cfelse>
			<cfset lvarB15M = "">
		</cfif>
		<cfquery name="rsOficinas" datasource="#Session.DSN#">
			select Ocodigo, Odescripcion 
			from Oficinas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

		<cfquery name="rsGruposOficina" datasource="#Session.DSN#">
			select GOid, GOcodigo, GOnombre
			from AnexoGOficina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by GOcodigo
		</cfquery>
			
		<cfquery name="rsMonedas" datasource="#Session.DSN#">
			select Mcodigo as Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
			from Monedas
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset longitud = len(Trim(rsMonedas.Miso4217))>
		<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
			select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
			from Empresas a, Monedas b 
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a.Mcodigo = b.Mcodigo
		</cfquery>
	
		 <cfquery name="rsPer" datasource="#Session.DSN#">
			select distinct Speriodo as Eperiodo
			from CGPeriodosProcesados
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by Eperiodo desc
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
		  <form name="form1" method="post" action="SQLBalGeneralDet.cfm" onsubmit="return sinbotones()">
			  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
				<tr> 
				  <td colspan="4" align="right"><cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Balance_general.htm"></td>
				</tr>
				<tr> 
				  <td width="30%"><div align="right"><cfoutput>#MSG_Oficina#</cfoutput>:</div></td>
				  <td width="24%"><select name="Oficina" id="Oficina" tabindex="1">
					  <option value="-1" label="Todas"><cfoutput>#LB_Todas#</cfoutput></option>
					  <cfoutput query="rsOficinas"> 
						<option value="#Ocodigo#" label="#rsOficinas.Odescripcion#">#Odescripcion#</option>
					  </cfoutput> </select></td>
				  <td align="right"><cfoutput>#MSG_Periodo#:</cfoutput></td>
				  <td>
					<select name="periodo" tabindex="1">
						<cfloop query = "rsPer">
							<option value="<cfoutput>#rsPer.Eperiodo#</cfoutput>"><cfoutput>#rsPer.Eperiodo#</cfoutput></option>" <cfif periodo EQ "#rsPer.Eperiodo#">selected</cfif>></option>
						</cfloop>

					</select>
				  </td>
				</tr>
				<tr>
				  <td><div align="right"><cfoutput>#MSG_Moneda#</cfoutput></div></td>
				  <td rowspan="2" valign="top"><table border="0" cellspacing="0" cellpadding="2">
                    <tr>
                      <td nowrap><input name="mcodigoopt" type="radio" value="-2" checked tabindex="1"></td>
                      <td nowrap><cfoutput>#MSG_Local#:</cfoutput></td>
                      <td><cfoutput><strong>#rsMonedaLocal.Mnombre#</strong></cfoutput></td>
                    </tr>
                    <cfif isdefined("rsMonedaConvertida")>
                    <tr>
                      <td nowrap><input name="mcodigoopt" type="radio" value="-3" tabindex="6"></td>
                      <td nowrap><cfoutput>#MSG_Convertida#:</cfoutput></td>
                      <td><cfoutput><strong>#rsMonedaConvertida.Mnombre#</strong></cfoutput></td>
                    </tr>
					</cfif>
					<tr>
				  	  <td nowrap><input name="mcodigoopt" type="radio" value="-4" tabindex="6"></td>
				  	  <td nowrap><cfoutput>#MSG_Informe_B15#:</cfoutput></td>
				  	  <td><cfoutput><strong>#lvarB15M#</strong></cfoutput></td>
					</tr>
                    <tr>
                      <td nowrap><input name="mcodigoopt" type="radio" value="0" tabindex="1"></td>
                      <td nowrap> <cfoutput>#MSG_Origen#:</cfoutput></td>
                      <td><select name="Mcodigo" tabindex="1">
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
				  <td width="4%" align="right" ><cfoutput>#CMB_Mes#:</cfoutput></td>
				  <td width="42%"> <select name="mes" size="1" tabindex="1">
					  <option value="1" <cfif mes EQ 1>selected</cfif>><cfoutput>#CMB_Enero#</cfoutput></option>
					  <option value="2" <cfif mes EQ 2>selected</cfif>><cfoutput>#CMB_Febrero#</cfoutput></option>
					  <option value="3" <cfif mes EQ 3>selected</cfif>><cfoutput>#CMB_Marzo#</cfoutput></option>
					  <option value="4" <cfif mes EQ 4>selected</cfif>><cfoutput>#CMB_Abril#</cfoutput></option>
					  <option value="5" <cfif mes EQ 5>selected</cfif>><cfoutput>#CMB_Mayo#</cfoutput></option>
					  <option value="6" <cfif mes EQ 6>selected</cfif>><cfoutput>#CMB_Junio#</cfoutput></option>
					  <option value="7" <cfif mes EQ 7>selected</cfif>><cfoutput>#CMB_Julio#</cfoutput></option>
					  <option value="8" <cfif mes EQ 8>selected</cfif>><cfoutput>#CMB_Agosto#</cfoutput></option>
					  <option value="9" <cfif mes EQ 9>selected</cfif>><cfoutput>#CMB_Setiembre#</cfoutput></option>
					  <option value="10" <cfif mes EQ 10>selected</cfif>><cfoutput>#CMB_Octubre#</cfoutput></option>
					  <option value="11" <cfif mes EQ 11>selected</cfif>><cfoutput>#CMB_Noviembre#</cfoutput></option>
					  <option value="12" <cfif mes EQ 12>selected</cfif>><cfoutput>#CMB_Diciembre#</cfoutput></option>
					</select> </td>
				</tr>
				<tr> 
				  <td>&nbsp;</td>
				  <td><div align="right"><cfoutput>#LB_Nivel#</cfoutput></div></td>
				  <td> <select name="nivel" tabindex="1">
					  <cfloop index="i" from="1" to="#cantniv#">
						<option value="<cfoutput>#i#</cfoutput>" <cfif i EQ 2>selected</cfif>><cfoutput>#i#</cfoutput></option>
					  </cfloop>
					</select> 
                    <cfparam name="session.Conta.balances.ConCodigo" default="false">
                    <input type="checkbox" name="chkConCodigo" value="1" <cfif session.Conta.balances.ConCodigo>checked</cfif>/> <cfoutput>#LB_ConCodigo#</cfoutput>
                   </td>
				</tr>
				<tr>
					<td><div align="right"><cfoutput>#MSG_GrupoOficinas#</cfoutput></div></td>
					<td align="rigth">
						<select name="GOid" id="GOid" tabindex="1">
							<option value="-1"><cfoutput>#CBM_Ninguno#</cfoutput></option>
						  <cfoutput query="rsGruposOficina"> 
							<option value="#rsGruposOficina.GOid#">#rsGruposOficina.GOcodigo# - #rsGruposOficina.GOnombre#</option>
						  </cfoutput> 
						</select>					
					</td>
					<td align="rigth">&nbsp;</td>
					<td align="rigth">&nbsp;</td>
				</tr>
				<tr> 
					<td colspan="4" align="rigth">&nbsp;</td>
				</tr>
				<tr> 
				  	<td colspan="4" align="center">
						<cf_botones values="Consultar,Exportar" names="Consultar,Exportar" tabindex="1">

					</td>
						
						<input type="hidden" name="descOficina" value="">
				</tr>
				<tr> 
				  	<td colspan="4">&nbsp;</td>
				</tr>
			</table>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>