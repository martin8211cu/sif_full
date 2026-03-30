
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

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

<cfif modo NEQ "ALTA">
	<cfquery name="rsMetodoPagoFac" datasource="#Session.DSN#">
		select   MPid,CSATcodigo,CSATdescripcion
        from CSATMetPago
		where  MPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MPid#">	
	</cfquery>
</cfif>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<cfoutput>

<form action="SQLMetodoPago.cfm" method="post" name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  	<cfif modo eq "CAMBIO" and isdefined("rsMetodoPagoFac")>
		<input type="hidden" name="MPid" value="#rsMetodoPagoFac.MPid#">
	</cfif>
  <tr>
    <td align="right" nowrap>Código:&nbsp;</td>
    <td nowrap>
		<input name="codigo_MetodoPago" type="text" 
		value="<cfif modo eq "CAMBIO" and isdefined("rsMetodoPagoFac")>#trim(rsMetodoPagoFac.CSATcodigo)#</cfif>">
    </td>
  </tr>	
  <tr>
    <td align="right" nowrap>Descripción Método Pago:&nbsp;</td>
    <td nowrap><input name="des_MetodoPago" type="text" value="<cfif modo eq "CAMBIO" and isdefined("rsMetodoPagoFac")>#trim(rsMetodoPagoFac.CSATdescripcion)#</cfif>" size="80">
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td nowrap align="center">
<!--- 		Copiado del portlet de botones para poner funcion en el borrado --->
		<cf_templatecss>
		<cfoutput>
		<cfif modo EQ "ALTA">
			<input type="submit" name="Alta" value="#Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#">
			<input type="reset" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#">
		<cfelse>	
			<input type="submit" name="Cambio" value="#Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#">
			<input type="submit" name="Baja" value="#Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#"> 
			<input type="submit" name="Nuevo" value="#Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" >
		</cfif>
		</cfoutput>
		<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
<!--- 		Copiado del portlet de botones para poner funcion en el borrado --->
	</td>
  </tr>
</table>
</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.codigo_MetodoPago.required = true;
	objForm.des_MetodoPago.required = true;
	function justNumbers(e) {
        var keynum = window.event ? window.event.keyCode : e.which;
        if ((keynum == 8) || (keynum == 46))
        return true;
         
        return /\d/.test(String.fromCharCode(keynum));
        }
	
</script>
