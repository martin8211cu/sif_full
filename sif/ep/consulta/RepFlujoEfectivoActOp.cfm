<!---
	Creado por Martin S. Estevez
		Fecha: 09-06-2014.
	Situacion Financiera Detallada
 --->
<cfinvoke key="MSG_Saldos_Finales_Cero"	default="Mostrar movimientos en cero"	returnvariable="MSG_Saldos_Finales_Cero"	component="sif.Componentes.Translate" method="Translate"/>

<cfinclude template="../../cg/consultas/Funciones.cfm">
<cfset Lvartitulo = 'Flujo de Efectivo por Actividades de Operaci&oacute;n'>
<!--- Variables --->
<cfset fnGeneraConsultasBD()>
<cfif isdefined("form.periodo")>
	<cfset periodo="#form.periodo#">
<cfelse>
	<cfset periodo="#get_val(30).Pvalor#">
</cfif>
<cfif isdefined("form.mes")>
	<cfset mes="#form.mes#">
<cfelse>
<cfset mes="#get_val(40).Pvalor#">
</cfif>
<cfset longitud = len(Trim(rsMonedas.Miso4217))>

<cf_templateheader title="#Lvartitulo#">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#Lvartitulo#'>
<cfinclude template="../../portlets/pNavegacion.cfm">

<cfquery name="rsSaldos" datasource="#Session.DSN#">
	select * from CGEstrProgFESaldos
	where EPSIano = #periodo#
		and Ecodigo = #Session.Ecodigo#
	order by EPSImes
</cfquery>

<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
<form name="form1" method="post" action="RepFlujoEfectivoActOp-SQL.cfm" style="margin:0; " onsubmit="return sinbotones()">
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
<tr>
    <td nowrap><div align="right">Per&iacute;odo:&nbsp;</div></td>
<td>
<select name="periodo" tabindex="3" onchange="javascript: this.form.botonSel.value = ''; submit()">
<cfloop query = "rsPeriodos">
	<option value="<cfoutput>#rsPeriodos.Speriodo#</cfoutput>" <cfif trim(periodo) EQ "#trim(rsPeriodos.Speriodo)#">selected</cfif>><cfoutput>#rsPeriodos.Speriodo# </cfoutput></option>
</cfloop>
</select>
</td>
    <td align="right" nowrap><div align="right">Presentaci&oacute;n:&nbsp;</div></td>
<td>
<select name="Unidad" tabindex="15">
        <option value="1" <cfif isdefined("form.Unidad") and form.Unidad EQ "1">selected</cfif>>Unidades</option>
		<option value="2" <cfif isdefined("form.Unidad") and form.Unidad EQ "2">selected</cfif>>Miles</option>
</select>
</td>
</tr>
<tr>
    <td align="right" nowrap><div align="right">Mes:&nbsp;</div></td>
<td>
<select name="mes" size="1" tabindex="4" onchange="this.form.botonSel.value = ''; submit()">
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
    <td align="right" nowrap><div align="right">Formato:&nbsp;</div></td>
<td>
<select name="mensAcum" size="1" tabindex="4" onchange="this.form.botonSel.value = ''; submit()">
        <option value="1" <cfif (isdefined("form.mensAcum") and form.mensAcum EQ "1")>selected</cfif>>Mensual</option>
        <option value="2" <cfif (isdefined("form.mensAcum") and form.mensAcum EQ "2")>selected</cfif>>Detallado por Mes</option>
</select>
</td>
</tr>
<!---            <tr>--->
<!---                <td colspan="2"/>--->
<!---			  	<td align="right" nowrap><div align="right">Presentar codificaci&oacute;n:&nbsp;</div></td>--->
<!---	              <td nowrap>--->
<!---	              	<div align="left">--->
<!---						<input type="checkbox" name="chkCeros" tabindex="17">--->
<!---				  	</div>--->
<!---	              </td>--->
<!---			</tr>--->
    <tr><td colspan="4">&nbsp;</td> </tr>
    <tr>
        <td colspan="4" align="center" nowrap="nowrap"><strong>Saldos</strong></td>
    </tr>
<tr>
<td colspan="4" align="center">
    <cfset a = SaldosMeses(mes)>
</td>
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
        <input type="hidden" value="" name="botonSel">
        <input type="submit" name="Consultar" value="Consultar" tabindex="18" onclick="javascript: this.form.botonSel.value = this.name;">&nbsp;
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

<cffunction name="SaldosMeses" access="public" output="yes" >
    <cfargument name="mes" 		    type="numeric" 	required="yes">
    <cfargument name="mesMostrar" 	type="numeric" 	required="false" default="0">

    <cfif Arguments.mes mod 3 eq 0>
        <cfset PageCount =  Arguments.mes / 3 >
        <cfelse>
        <cfset PageCount =  Arguments.mes / 3 + 1 >
    </cfif>

	<cfset arSaldos = ArrayNew(1)>
	<cfif rsSaldos.RecordCount EQ 12>
		<cfloop query="rsSaldos">
			<cfset structObj = {chequei="#ChequeTranIni#", chequef="#ChequeTranFin#", flucmb="#FluctuacionCambiaria#"} />
			<cfset arrayappend(arSaldos ,#structObj#)>
		</cfloop>
	<cfelse>
		<cfloop from="1" to="12" index="j">
			<cfset structObj = {chequei="0", chequef="0", flucmb="0"} />
			<cfset arrayappend(arSaldos ,#structObj#)>
		</cfloop>
	</cfif>

    <cfoutput>
        <table width="98%" align="center" border="0" >
        <cfset ix = 1>
        <cfloop from="1" to="#PageCount#" index="i">
            <tr>
                <td width="1%"/>
            <cfloop from="1" to="3" index="j">
                <cfif ix LTE Arguments.mes>
                    <td>
                    <table width="100%" align="center" border="0" >
                    <tr>
                   <cfset mesMuestra = ix>
                    <cfif Arguments.mesMostrar NEQ "0"><cfset mesMuestra = Arguments.mesMostrar></cfif>
                    <td class="tituloAlterno" align="center" colspan="2" nowrap><div align="center"><b> #Ucase(MonthAsString(mesMuestra,"es"))#</b></div></td>
               </tr>
                    <tr>
                           <td align="right" nowrap><div align="right">Cheques en Transito Inicial:&nbsp;</div></td>
                        <td nowrap>
                        <div align="left">
                        <cf_inputNumber  readonly="true" name="ChequeI#ix#" value="#arSaldos[ix].chequei#" enteros = "15" decimales = "2">
                        </div>
                        </td>
                        </tr>
                    <tr>
                        <td align="right" nowrap><div align="right">Cheques en Transito Final:&nbsp;</div></td>
	                    <td nowrap>
	                    <div align="left">
	                    <cf_inputNumber  readonly="true" name="ChequeF#ix#" value="#arSaldos[ix].chequef#" enteros = "15" decimales = "2">
	                    </div>
	                    </td>
                    </tr>
                    <tr>
                        <td align="right" nowrap><div align="right">Fluctuaci&oacute;n Cambiaria:&nbsp;</div></td>
	                    <td nowrap>
	                    <div align="left">
	                    <cf_inputNumber  readonly="true" name="Fluctuacion#ix#" value="#arSaldos[ix].flucmb#" enteros = "15" decimales = "2">
	                    </div>
	                    </td>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                    </table>
                    </td>
                        <td width="1%"/>
                </cfif>
                <cfset ix = ix+1>
            </cfloop>
            </tr>
                <tr><td>&nbsp</td></tr>
        </cfloop>
        </table>
    </cfoutput>
</cffunction>
