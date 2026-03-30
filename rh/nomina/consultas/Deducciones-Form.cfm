<cfif isdefined("Url.RCNid") and not isdefined("Form.RCNid")>
	<cfparam name="Form.RCNid" default="#Url.RCNid#">
</cfif>
<cfif isDefined("Url.Tcodigo") and not isDefined("Form.Tcodigo")>
	<cfset Form.Tcodigo = Url.Tcodigo>
</cfif>
<cfif isDefined("Url.fecha") and not isDefined("Form.fecha")>
	<cfset Form.fecha = Url.fecha>
</cfif>
<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
	<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
</cfif>
<cfif isdefined("Url.DEidentificacionFiltro") and not isdefined("Form.DEidentificacionFiltro")>
	<cfparam name="Form.DEidentificacionFiltro" default="#Url.DEidentificacionFiltro#">
</cfif>		
<cfif isdefined("Url.fSEcalculado") and not isdefined("form.fSEcalculado")>
	<cfparam name="form.fSEcalculado" default="#Url.fSEcalculado#">
</cfif>		
<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
	<cfparam name="Form.filtrado" default="#Url.filtrado#">
</cfif>	
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>	

<style type="text/css">
.chk {  
 background: buttonface; 
 padding: 1px;
 color: buttontext;
}
</style>


<cfset pintarReporte = true>
<cfinclude template="/rh/portlets/pRelacionCalculo.cfm">

<form name="form1" method="get" action="SQL-Deducciones.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <!---  <tr>
    <td width="22%" nowrap><div align="right">
        <input type="checkbox" name="chkCeros" value="N" onClick="javascript: if (this.value=='N') { this.value='S'} else {this.value='N'};">
      </div>
    </td>
    <td width="26%"> Mostrar Saldos Finales en Cero</td>
    <td width="24%">&nbsp;</td>
    <td width="28%">&nbsp;</td>
  </tr> --->
  <tr>
    <td width="23%"  align="right" nowrap><div align="right"><strong>Formato:</strong>&nbsp;</div>
    </td>
    <td width="31%"> &nbsp;
		<select name="formato">
        <option value="html">En l&iacute;nea (HTML)</option>
        <option value="pdf">Adobe PDF</option>
        <option value="xls">Microsoft Excel</option>
      </select>
    </td>
    <td width="3%">&nbsp;</td>
    <td width="21%"><cf_rhtipodeduccion form="form1" size= "40"></td>
    <td width="9%">&nbsp;</td>
    <td width="22%">&nbsp;</td>
  </tr>
  <tr>
   
  	<td colspan="6">  <div align="center"> 
        	  <input type="submit" name="Submit" value="Consultar">&nbsp;
			  <input type="Reset" name="Limpiar" value="Limpiar">
			  <input type="hidden" name="RCNid" value="<cfif isdefined("url.RCNid") and len(trim(#url.RCNid#)) neq 0><cfoutput>#url.RCNid#</cfoutput></cfif>">
          </div>
	</td>
   
  </tr>
</table>


</form> 