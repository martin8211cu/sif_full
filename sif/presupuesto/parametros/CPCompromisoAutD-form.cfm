

<cfif isdefined("form.Periodo")>
	<cfset vs_per = "#form.Periodo#">
<cfelse>
	<cfset vs_per = "">
</cfif>
<cfif isdefined("form.CPCCmascara")>
	<cfset vs_CPCCmascara = "#form.CPCCmascara#">
<cfelse>
	<cfset vs_CPCCmascara = "">
</cfif>
<cfif isdefined("form.CPCCid")>
	<cfset vs_CPCCid = "#form.CPCCid#">
<cfelse>
	<cfset vs_CPCCid = "">
</cfif>
<cfif isdefined("form.CPcambioAplicado")>
	<cfset vs_CPcambioAplicado = "#form.CPcambioAplicado#">
<cfelse>
	<cfset vs_CPcambioAplicado = "">
</cfif>
<cfif isdefined("form.CPPid")>
	<cfset vs_CPPid = "#form.CPPid#">
<cfelse>
	<cfset vs_CPPid = "">
</cfif>

<!---<cf_dump var ="#Form.CPPid#">--->

<cfset vs_Inputs="">

<cfset CMB_Enero 	= t.Translate('CMB_Enero','Enero','/sif/generales.xml')>
<cfset CMB_Febrero 	= t.Translate('CMB_Febrero','Febrero','/sif/generales.xml')>
<cfset CMB_Marzo 	= t.Translate('CMB_Marzo','Marzo','/sif/generales.xml')>
<cfset CMB_Abril 	= t.Translate('CMB_Abril','Abril','/sif/generales.xml')>
<cfset CMB_Mayo 	= t.Translate('CMB_Mayo','Mayo','/sif/generales.xml')>
<cfset CMB_Junio 	= t.Translate('CMB_Junio','Junio','/sif/generales.xml')>
<cfset CMB_Julio 	= t.Translate('CMB_Julio','Julio','/sif/generales.xml')>
<cfset CMB_Agosto 	= t.Translate('CMB_Agosto','Agosto','/sif/generales.xml')>
<cfset CMB_Septiembre = t.Translate('CMB_Septiembre','Septiembre','/sif/generales.xml')>
<cfset CMB_Octubre = t.Translate('CMB_Octubre','Octubre','/sif/generales.xml')>
<cfset CMB_Noviembre = t.Translate('CMB_Noviembre','Noviembre','/sif/generales.xml')>
<cfset CMB_Diciembre = t.Translate('CMB_Diciembre','Diciembre','/sif/generales.xml')>
<cfset LB_PeriododelPres = t.Translate('LB_PeriododelPres','Período del Presupuesto')>
<cfset LB_CuentadePres = t.Translate('LB_CuentadePres','Cuenta de Presupuesto')>
<cfset LB_EliminarCta = t.Translate('LB_EliminarCta','¿Desea Eliminar la Cuenta?')>
<cfset LB_Periodo = t.Translate('LB_Periodo','Periodo')>
<cfset LB_Mes = t.Translate('LB_Mes','Mes')>
<cfset LB_Compromiso = t.Translate('LB_Compromiso','Compromiso')>
<cfset LB_Ampliaciones = t.Translate('LB_ Ampliaciones','Ampliaciones')>
<cfset LB_NuevoMontoa = t.Translate('LB_NuevoMontoa','Nuevo Monto a')>
<cfset LB_Original = t.Translate('LB_Original','Original')>
<cfset LB_Reducciones = t.Translate('LB_Reducciones','Reducciones')>
<cfset LB_Modificado = t.Translate('LB_Modificado','Modificado')>
<cfset LB_Comprometer = t.Translate('LB_Comprometer','Comprometer')>
<cfset BTN_Eliminar = t.Translate('BTN_Eliminar','Eliminar','/sif/generales.xml')>
<cfset BTN_Regresar = t.Translate('BTN_Regresar','Regresar','/sif/generales.xml')>
<cfset LB_btnGuardar = t.Translate('LB_btnGuardar','Guardar','/sif/generales.xml')>
<!---<cfset LB_btnReset = t.Translate('LB_btnReset','Reset')>--->
<cfset LB_MesCerrado = t.Translate('LB_MesCerrado','Mes Cerrado')>

<cfoutput>
<form method="post" name="form1" action="CPComprAutPerMes-SQL.cfm" style="margin: 0;">
	<table>
        <tr>
            <td colspan="2">&nbsp;</td>
            <td colspan="2">
                <strong>#LB_PeriododelPres#</strong>:&nbsp;
            </td>
            <td>
            	#vs_per#
            </td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
            <td colspan="2">
                <strong>#LB_CuentadePres#</strong>:&nbsp;
            </td>
            <td>
            	#vs_CPCCmascara#
            </td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        	<td colspan="6" align="center">
            	<input type="submit" name="BorrarD" value="#BTN_Eliminar#" onclick="javascript: return confirm('#LB_EliminarCta#');">
          		<input type="button" name="btnRegresar" value="#BTN_Regresar#" onClick="javascript: location.href='CPCompromisoAut.cfm';">
            </td>

        </tr>

	</table>
    <input type="hidden" name="CPCCid" value="#vs_CPCCid#">
    <input type="hidden" name="CPPid"  value="#vs_CPPid#">
</form>
</cfoutput>

<cfquery name="MontosCompromiso" datasource="#Session.DSN#">
	select CPCDid,CPperiodo,CPmes,
 	case CPmes
     when 1 then '#CMB_Enero#'
     when 2 then '#CMB_Febrero#'
     when 3 then '#CMB_Marzo#'
     when 4 then '#CMB_Abril#'
     when 5 then '#CMB_Mayo#'
     when 6 then '#CMB_Junio#'
     when 7 then '#CMB_Julio#'
     when 8 then '#CMB_Agosto#'
     when 9 then '#CMB_Septiembre#'
     when 10 then '#CMB_Octubre#'
     when 11 then '#CMB_Noviembre#'
     when 12 then '#CMB_Diciembre#'
     else ''
    end as Mes,
    CPComprOri,CPComprMod, CPComp_Anterior from CPresupuestoComprAutD
    where CPCCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#vs_CPCCid#">
    order by CPperiodo,CPmes
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsget_val">
	select ltrim(rtrim(Pvalor)) as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 50
</cfquery>
<cfset vs_periodo="#rsget_val.Pvalor#">

<cfquery datasource="#Session.DSN#" name="rsget_val">
	select ltrim(rtrim(Pvalor)) as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 60
</cfquery>
<cfset vs_mes="#rsget_val.Pvalor#">

<script src="/cfmx/sif/js/utilesMonto.js"></script>
<cfoutput>
<form method="post" name="form" action="CPComprAutPerMes-SQL.cfm" style="margin: 0;">
    <table width="100%"  border="0" cellspacing="0" cellpadding="2">
        <tr>
            <td align="right" nowrap class="tituloListas"  style="padding-left: 5px;">#LB_Periodo#</td>
            <td nowrap class="tituloListas" style="padding-left: 5px;">#LB_Mes#</td>
            <td nowrap class="tituloListas" style="padding-left: 5px;">#LB_Compromiso#</td>
            <td nowrap class="tituloListas" style="padding-left: 5px;">#LB_Compromiso#</td>
			<td nowrap class="tituloListas" style="padding-left: 5px;">#LB_Ampliaciones#/</td>
            <td nowrap class="tituloListas" style="padding-left: 5px;">#LB_NuevoMontoa#</td>
        </tr>
        <tr>
            <td align="left" nowrap class="tituloListas" style="padding-left: 5px;"></td>
            <td nowrap class="tituloListas" style="padding-left: 5px;"></td>
            <td nowrap class="tituloListas" style="padding-left: 5px;">#LB_Original#</td>
            <td nowrap class="tituloListas" style="padding-left: 5px;">#LB_Modificado#</td>
            <td nowrap class="tituloListas" style="padding-left: 5px;">#LB_Reducciones#</td>
            <td nowrap class="tituloListas" style="padding-left: 5px;">#LB_Comprometer#</td>
        </tr>
        <cfloop query="MontosCompromiso">
			<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
                <td align="right"  style="padding-right: 5px;"nowrap>#MontosCompromiso.CPperiodo#</td>
                <td style="padding-right: 5px;">#MontosCompromiso.Mes#</td>
                <td style="padding-right: 5px;" nowrap>
                #LSNumberFormat(MontosCompromiso.CPComprOri, ',9.00')#
                </td>
				 <td style="padding-right: 5px;" nowrap>
                #LSNumberFormat(MontosCompromiso.CPComp_Anterior, ',9.00')#
                </td>
                <td style="padding-right: 5px;" nowrap>
                #LSNumberFormat(MontosCompromiso.CPComprMod-MontosCompromiso.CPComprOri, ',9.00')#
                </td>

                <td align="left" nowrap style="padding-right: 5px;">
                	<cfif MontosCompromiso.CPperiodo le vs_periodo and MontosCompromiso.CPmes lt vs_mes>
                    	#LB_MesCerrado#
                    <cfelse>
                        <input type="text" name="CPDDmonto_#MontosCompromiso.CPCDid#" size="20" maxlength="18"
                        onFocus="this.value=qf(this); this.select();"
        <!---			onBlur="javascript: fm(this,2);" --->
                        onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
                        style="text-align: right;"
                        value="#LSNumberFormat(MontosCompromiso.CPComprMod,',9.00')#"
                        >
                	</cfif>
                </td>

        	</tr>
            <cfset vs_Inputs="CREADOS">
        </cfloop>
		<tr>
		  <td colspan="6">&nbsp;</td>
		  </tr>
		<tr align="center">
		  <td colspan="6">
			<input type="submit" name="btnGuardarD" value="#LB_btnGuardar#"
            <!---onClick="javascript: if (window.habilitarValidacionD) habilitarValidacionD(); "---> >
			<!---<input type="reset" name="btnResetD" value="#LB_btnReset#">--->
		  </td>
		</tr>
		<tr>
		  <td colspan="6">&nbsp;</td>
		</tr>
    </table>
    <input type="hidden" name="CPCCid" value="#vs_CPCCid#">
    <input type="hidden" name="Periodo" value="#vs_per#">
    <input type="hidden" name="CPCCmascara" value="#vs_CPCCmascara#">

</form>
</cfoutput>

