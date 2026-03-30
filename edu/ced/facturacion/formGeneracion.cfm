<link href="../../css/edu.css" rel="stylesheet" type="text/css"> 
<form name="formGeneracion" id="formGeneracion" method="post" action="SQLgeneracion.cfm">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td width="0%">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3" class="tituloCorte">Proceso de generaci&oacute;n</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="44%" class="subTitulo">Observaci&oacute;n</td>
      <td width="6%" class="subTitulo">&nbsp;</td>
      <td width="50%" class="subTitulo">Fecha de la factura</td>
    </tr>
    <tr> 
      <td rowspan="5"><textarea name="EFobservacion" cols="50" rows="4" id="EFobservacion"></textarea> 
      </td>
      <td valign="top">&nbsp;</td>
      <td valign="top"> <a href="#"> 
        <input name="EFfechadoc" type="text" id="EFfechadoc" onFocus="this.select()" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined('form.EFfechadoc') and form.EFfechadoc NEQ ''>#form.EFfechadoc#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
        <img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formGeneracion.EFfechadoc');"> 
        </a> </td>
    </tr>
    <tr> 
      <td class="subTitulo">&nbsp;</td>
      <td class="subTitulo">Fecha de vencimiento</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td> <a href="#"> 
        <input name="EFfechavenc" type="text" id="EFfechavenc" onFocus="this.select()" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined('form.EFfechavenc') and form.EFfechavenc NEQ ''>#form.EFfechavenc#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
        <img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formGeneracion.EFfechavenc');"> 
        </a> </td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td class="subTitulo">&nbsp;</td>
      <td class="subTitulo">Fecha m&aacute;xima de incidencias</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td> <a href="#"> 
        <input name="IFecha" type="text" id="IFecha" onFocus="this.select()" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined('form.IFecha') and form.IFecha NEQ ''>#form.IFecha#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
        <img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formGeneracion.IFecha');"> 
        </a> 
        <!--- <strong>Fecha de Pago</strong> --->
        <!--- <a href="#">
        <input name="EFfechapago" type="text" id="EFfechapago" onFocus="this.select()" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif isdefined('form.EFfechapago') and form.EFfechapago NEQ ''>#form.EFfechapago#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
        <img src="/cfmx/edu/Imagenes/date_d.GIF" alt="Calendario" name="Calendar" width="11" height="11" border="0" id="Calendar" onClick="javascript:showCalendar('document.formGeneracion.EFfechapago');"> 
        </a> --->
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3" class="tituloCorte">Perioricidad</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="31%"><input name="FCAperiodicidad" type="checkbox" id="FCAperiodicidad" value="A">
              Anual</td>
            <td width="35%"><input name="FCAperiodicidad" type="checkbox" id="FCAperiodicidad" value="S">
              Semestral</td>
            <td width="34%"><input name="FCAperiodicidad" type="checkbox" id="FCAperiodicidad" value="B">
              Bimestral</td>
          </tr>
          <tr> 
            <td><input name="FCAperiodicidad" type="checkbox" id="FCAperiodicidad" value="M">
              Mensual</td>
            <td><input name="FCAperiodicidad" type="checkbox" id="FCAperiodicidad" value="T">
              Trimestral</td>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td colspan="2" align="center"><input name="btnGenerar" type="submit" id="btnGenerar" value="Generar"></td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>

<script language="JavaScript" type="text/javascript" src="../../js/calendar.js" >//</script>
<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script> 
<script language="JavaScript" type="text/javascript" >
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formGeneracion");
//------------------------------------------------------------------------------------------								
	objForm.EFobservacion.required = true;
	objForm.EFobservacion.description = "Observación";
	objForm.EFfechadoc.required = true;
	objForm.EFfechadoc.description = "Fecha de factura";	
	objForm.EFfechavenc.required = true;
	objForm.EFfechavenc.description = "Fecha de vencimiento";	
	objForm.IFecha.required = true;
	objForm.IFecha.description = "Fecha máxima de incidencias";	
//------------------------------------------------------------------------------------------										
</script> 