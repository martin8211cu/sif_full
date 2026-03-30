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

<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>
<cfif isdefined("Url.ECid") and not isdefined("Form.ECid")>
	<cfset Form.ECid = Url.ECid>
</cfif>

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<style type="text/css">
.chk {  
 background: buttonface; 
 padding: 1px;
 color: buttontext;
}
</style>
	<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js">//</script>
	<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>
	<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
	<script language="JavaScript1.2" type="text/javascript">
	
	function validar(){	return true; }
	
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		popUpWindow("ConlisCargasEmpleados.cfm" ,250,200,650,350);
	}
	function limpiar() {
		document.form1.ECid.value = "";
		document.form1.DCdescripcion.value = "";
	}

</script>
<cfset pintarReporte = true>
<cfinclude template="/rh/portlets/pRelacionCalculo.cfm">

<form name="form1" method="post" action="Cargas-SQL.cfm">
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
    <td width="31%"> &nbsp;<select name="formato">
        <option value="html">En l&iacute;nea (HTML)</option>
        <option value="pdf">Adobe PDF</option>
        <option value="xls">Microsoft Excel</option>
      </select>
    </td>
    <td width="3%">&nbsp;</td>
    <td width="21%" nowrap><cfoutput>
      <input name="DCdescripcion" disabled type="text" value="<cfif modo NEQ "ALTA" >#rsForm.DCdescripcion#</cfif>" size="60" maxlength="50">
    </cfoutput><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Cargas" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();"></td>
    <td width="9%">&nbsp;</td>
    <td width="22%">&nbsp;</td>
  </tr>
  <tr>
  	<td colspan="6">
		<div align="center"> 
        	<input type="submit" name="Submit" value="Consultar">&nbsp;
			<input type="button" name="Limpiar" value="Limpiar"  onClick="javascript: limpiar();">
			<input type="hidden" name="RCNid" value="<cfif isdefined("form.RCNid") and len(trim(#form.RCNid#)) neq 0><cfoutput>#form.RCNid#</cfoutput></cfif>">
			<input type="hidden" name="ECid" value="<cfif isdefined("form.ECid") and len(trim(#form.ECid#)) neq 0><cfoutput>#form.ECid#</cfoutput></cfif>" >
        </div>
	</td>
   
  </tr>
</table>


</form> 