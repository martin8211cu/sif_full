<cfif isdefined("Url.RCNid") and not isdefined("Form.RCNid")>
	<cfparam name="Form.RCNid" default="#Url.RCNid#">
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

<form name="form1" method="post" action="SQL-Deducciones.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="22%" nowrap><div align="right">
        <input type="checkbox" name="chkCeros" value="N" onClick="javascript: if (this.value=='N') { this.value='S'} else {this.value='N'};">
      </div>
    </td>
    <td width="26%"> Mostrar Saldos Finales en Cero</td>
    <td width="24%">&nbsp;</td>
    <td width="28%">&nbsp;</td>
  </tr>
  <tr>
    <td align="right" nowrap><div align="right">Formato:&nbsp;</div>
    </td>
    <td><select name="formato">
        <option value="html">En l&iacute;nea (HTML)</option>
        <option value="pdf">Adobe PDF</option>
        <option value="xls">Microsoft Excel</option>
      </select>
    </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
   
  	<td colspan="4">  <div align="center"> 
        	  <input type="submit" name="Submit" value="Consultar">&nbsp;
			  <input type="Reset" name="Limpiar" value="Limpiar">
          </div>
	</td>
   
  </tr>
</table>


</form> 