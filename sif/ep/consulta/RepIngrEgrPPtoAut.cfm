<!---
	Creado por Martin S. Estevez
		Fecha: 09-06-2014.
	Situacion Financiera Detallada
 --->
<cfinvoke key="MSG_Saldos_Finales_Cero"	default="Mostrar movimientos en cero"	returnvariable="MSG_Saldos_Finales_Cero"	component="sif.Componentes.Translate" method="Translate"/>

<cfinclude template="../../cg/consultas/Funciones.cfm">
<cfset Lvartitulo = 'Presupuesto de Ingresos y Presupuesto de Egresos Autorizados'>
<!--- Variables --->
<cfset fnGeneraConsultasBD()>
<cfset periodo="#get_val(30).Pvalor#">
<cfset mes="#get_val(40).Pvalor#">
<cfset longitud = len(Trim(rsMonedas.Miso4217))>

<cf_templateheader title="#Lvartitulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#Lvartitulo#'>
		<cfinclude template="../../portlets/pNavegacion.cfm">

		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<form name="form1" method="get" action="RepIngrEgrPPtoAut-SQL.cfm" style="margin:0; " onsubmit="return sinbotones()">
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
			   <td align="right" nowrap><div align="right">Presentaci&oacute;n:&nbsp;</div></td>
			  <td>
				<select name="Unidad" tabindex="15">
					<option value="1">Unidades</option>
					<!--- <option value="2">Miles</option> --->
				</select>
			  </td>
            </tr>
			<tr>
			  <td align="right" nowrap><div align="right">Disponibilidad Inicial:&nbsp;</div></td>
                <td nowrap>
              	<div align="left">
					<cf_inputNumber  name="disponibilidad" value="0" enteros = "15" decimales = "2">
			  	</div>
               </td>
			  <td align="right" nowrap><div align="right">&nbsp;</div></td>
			  <td>&nbsp;</td>
			</tr>

            <tr>
            	<script language="javascript" src="../../js/utilesMonto.js"></script>
				<td align="left" colspan="2">&nbsp;</td>
			   <td align="left" colspan="2">&nbsp;</td>
			</tr>
			<tr>
			  <td colspan="6">
				<div align="center">
                	<cfif isdefined('url.rsMensaje')>
                    	<strong><cfoutput>#url.rsMensaje#</cfoutput></strong>
                    <cfelse>
				  		<input type="submit" name="Submit" value="Consultar" tabindex="18">&nbsp;
                        <input type="Reset" name="Limpiar" value="Limpiar" tabindex="19">
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
