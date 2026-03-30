<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate></title>
</head>
<body>
<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AnotacionALaAccionASeguir"
	Default="Anotaci&oacute;n a la acci&oacute;n a seguir"	
	returnvariable="LB_Titulo"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Modificar"
	Default="Modificar"	
	returnvariable="BTN_Modificar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Cerrar"
	Default="Cerrar"	
	returnvariable="BTN_Cerrar"/>		
	
<cfif isdefined("url.CMBid") and len(trim(url.CMBid))>
	<cfquery name="rsAnotacion" datasource="#session.DSN#">
		select Anotacion from RHCMBitacoraAccionesSeguir 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CMBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CMBid#">
	</cfquery>
</cfif>
<!----============== MODIFICACION DE ANOTACIONES DE LA BITACORA =====================---->
<cfif isdefined("form.btnModificar") and isdefined("form.CMBid") and len(trim(form.CMBid))>
	<cfquery name="actualiza" datasource="#session.DSN#">
		update RHCMBitacoraAccionesSeguir 
			set Anotacion = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#trim(form.Anotacion)#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CMBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMBid#">
	</cfquery>
	<script type="text/javascript" language="javascript1.2">
		window.close();
	</script>
</cfif>
<cfoutput>			
	<form name="form1" method="post" action="">
      <input type="hidden" name="CMBid" value="<cfif isdefined("url.CMBid") and len(trim(url.CMBid))>#url.CMBid#</cfif>">
	  <table width="100%" cellpadding="2" cellspacing="0">
        <tr>
          <td width="28%">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="4" align="center"><strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:12pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#LB_Titulo#</strong></td>
        </tr>
        <tr>
          <td colspan="4" align="center"><table width="95%" align="center">
			<tr><td><hr></td></tr>
          </table></td>
        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr>
          <td align="right" valign="top"><strong><cf_translate key="LB_Anotacion">Anotaci&oacute;n</cf_translate>:&nbsp;</strong></td>
          <td width="72%" valign="top"><textarea name="Anotacion" cols="60" rows="5"><cfif isdefined("rsAnotacion") and rsAnotacion.RecordCount NEQ 0 and len(trim(rsAnotacion.Anotacion))>#rsAnotacion.Anotacion#</cfif></textarea></td>
        </tr>        
        <tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
          <td colspan="4" align="center"><table width="23%" cellpadding="0" cellspacing="0">
              <tr>
                <td><input type="submit" name="btnModificar" value="#BTN_Modificar#" tabindex="4"></td>
				<td><input type="submit" name="btnCerrar" value="#BTN_Cerrar#" tabindex="5" onClick="javascript: window.close();"></td>
              </tr>
          </table></td>
        </tr>
      </table>
	</form>	
</cfoutput>
</body>
</html>