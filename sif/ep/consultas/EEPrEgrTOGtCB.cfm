<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 03-01-2013.
	Reporte Estado del Ejercicio del Presupuesto de Egresos por Tipo y Objeto de Gasto
 --->
<cfinvoke key="MSG_Saldos_Finales_Cero"	default="Mostrar movimientos en cero"	returnvariable="MSG_Saldos_Finales_Cero"	component="sif.Componentes.Translate" method="Translate"/>

<cfinclude template="../../cg/consultas/Funciones.cfm">
<cfset Lvartitulo = 'Estado del Ejercicio del Presupuesto de Egresos por Tipo y Objeto de Gasto'>
<!--- Variables --->
<cfset fnGeneraConsultasBD()>
<cfset periodo="#get_val(30).Pvalor#">
<cfset mes="#get_val(40).Pvalor#">			
<cfset longitud = len(Trim(rsMonedas.Miso4217))>

<cf_templateheader title="#Lvartitulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#Lvartitulo#'>
		<cfinclude template="../../portlets/pNavegacion.cfm">
	
		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<form name="form1" method="get" action="EEPrEgrTOGtCB-SQL.cfm" style="margin:0; " onsubmit="return sinbotones()">
			<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
			<tr> 
			  <td nowrap><div align="right">Período:&nbsp;</div></td>
			  <td> 
				<select name="periodo" tabindex="3">
					<cfloop query = "rsPeriodos">
						<option value="<cfoutput>#rsPeriodos.Speriodo#</cfoutput>"><cfoutput>#rsPeriodos.Speriodo#</cfoutput></option> <cfif periodo EQ "#rsPeriodos.Speriodo#">selected</cfif>></option>
					</cfloop>
				</select>
              </td>
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
              <td nowrap><div align="right">Mensual Acumulado:&nbsp;</div></td>
			  <td> 
				<select name="mensAcum" size="1" tabindex="4">
				  <option value="1">Mensual</option>
				  <option value="2">Acumulado</option>
				</select>
			  </td>
			</tr>
			<tr> 
			  <td nowrap><div align="right">Moneda:&nbsp;</div></td>
			  <td rowspan="3" valign="top">
              	<table border="0" cellspacing="0" cellpadding="2">
                    <tr>
                      <td nowrap><input name="mcodigoopt" type="radio" value="-2" checked tabindex="5"></td>
                      <td nowrap><div align="right">                      Local:</div></td>
                      <td><cfoutput><strong>#rsMonedaLocal.Mnombre#</strong></cfoutput></td>
                    </tr>
                    <tr>
                      <td nowrap><input name="mcodigoopt" type="radio" value="0" tabindex="7"></td>
                      <td nowrap><div align="right">                     Origen:</div></td>
                      <td><select name="Mcodigo" tabindex="8">
                        <cfoutput query="rsMonedas">
                          <option value="#rsMonedas.Mcodigo#"
                           <cfif isdefined('rsMonedas') and isdefined('rsMonedaLocal')>
                                <cfif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo >selected</cfif>
                            </cfif>
                            >#rsMonedas.Mnombre#</option>
                        </cfoutput>
                      </select>
                      </td>
                    </tr>
			  	</table>
              </td>
              <td align="right" nowrap><div align="right">Formato:&nbsp;</div></td>
			  <td>
				<select name="formato" tabindex="9">
					<option value="FlashPaper">FlashPaper</option>
					<option value="HTML">HTML</option>
					<option value="PDF">PDF</option>
				  </select>
			  </td>
              <td align="right" nowrap><cfoutput> #MSG_Saldos_Finales_Cero#</cfoutput></td>
			  <td nowrap>
              	<div align="left">
					<input type="checkbox" name="chkCeros" value="N" tabindex="10">
			  	</div>
              </td>
			</tr>
            
			<tr> 
			  <td colspan="2">&nbsp;</td>
              <td align="right" nowrap><div align="right">Presentaci&oacute;n:&nbsp;</div></td>
			  <td>
				<select name="Unidad" tabindex="15">
					<option value="1">Unidades</option>
					<option value="2">Miles</option>
					<option value="3">Millones</option>
				  </select>
			  </td>
			</tr>
			<tr> 
			  <td colspan="6"> 
				<div align="center">
                	<cfif isdefined('url.rsMensaje')> 
                    	<strong><cfoutput>#url.rsMensaje#</cfoutput></strong>                    
                    <cfelse>
				  		<input type="submit" name="Submit" value="Consultar" tabindex="16">&nbsp;
                        <input type="Reset" name="Limpiar" value="Limpiar" tabindex="17">                    
                    </cfif>
				</div>
			  </td>
			</tr>
			</table>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>

<cffunction name="fnGeneraConsultasBD" access="private" output="no" returntype="any">
	<!--- consultas --->
	<cfquery datasource="#Session.DSN#" name="rsNivelDef">
		select ltrim(rtrim(Pvalor)) as valor
		from Parametros 
		where Ecodigo = #Session.Ecodigo# 
		and Pcodigo = 10 
	</cfquery>
	
	<cfquery name="rsPeriodos" datasource="#Session.DSN#">
		select distinct Speriodo
		from CGPeriodosProcesados
		where Ecodigo = #session.Ecodigo#
		order by Speriodo desc
	</cfquery>

	<cfquery name="rsMonedas" datasource="#Session.DSN#">
		select Mcodigo as Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
		from Monedas
		where Ecodigo = #Session.Ecodigo#
	</cfquery>

	<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
		select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
		from Empresas a, Monedas b
		where a.Ecodigo = #Session.Ecodigo#
		and a.Ecodigo = b.Ecodigo
		and a.Mcodigo = b.Mcodigo
	</cfquery>
	
	<cfquery name="rsParam" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		and Pcodigo = 660
	</cfquery>
</cffunction>
