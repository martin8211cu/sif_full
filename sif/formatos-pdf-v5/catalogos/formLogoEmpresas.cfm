<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfquery name="rsEmpresas" datasource="emperador">
	select CGE1COD, CGE1DES from CGE001 
	<cfif modo NEQ "ALTA">	
	where rtrim(CGE1COD) = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Empresa#">
	</cfif>
	order by CGE1DES
</cfquery>

<cfquery name="rsForm" datasource="emperador">
	select a.Ecodigo, a.Llogo, a.timestamp, b.CGE1DES
	from LogoEmpresas a, CGE001 b
	where a.Ecodigo = b.CGE1COD
	<cfif modo NEQ "ALTA">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Empresa#">
    </cfif>
</cfquery>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<script language="JavaScript1.4" type="text/javascript">
	var boton = "";
	function setBtn(button){
		boton = button.name;
	}
	
	function validar(form){
		var mensaje = "Se presentaron los siguientes errores:\n\n";	
		var salir = false; 
		
		if ( boton != 'btnEliminar' && boton != 'btnNuevo' && boton != 'btnRegresar'){
			if (!salir && form.Empresa.value == ""){
				mensaje = mensaje + "La posición X es requerida.\n";
				salir = true;								
			}
			//if (boton != 'btnCambiar' ) {
				if (!salir && form.FiletoUpload.value == ""){
					mensaje = mensaje + "La imagen es requerida.";				
					salir = true;				
				}
			//}
			if (salir) alert(mensaje);			
			return !salir;			
		}
		return true;
	}

	function Formato()	 {
		/*
		var f = document.form1;
		f.action='EFormatosImpresion.cfm';
		f.submit();
		*/
		return false;
	}

	
</script>


<form name="form1" action="SQLLogoEmpresas.cfm" method="post" 
onSubmit="javascript: return validar(this);" enctype="multipart/form-data">

	
  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td align="right">Empresa:&nbsp;</td>
      <td valign="center"> <select name="Empresa" >
          <cfoutput query="rsEmpresas"> 
            <option value="#CGE1COD#" <cfif modo NEQ 'ALTA' and Trim(CGE1COD) EQ Trim(rsForm.Ecodigo)>selected</cfif>>#CGE1DES#</option>
          </cfoutput> </select> </td>
    </tr>
    <tr align="center" nowrap> 
      <td align="left" >&nbsp;</td>
      <td align="left" >&nbsp;</td>
    </tr>
    <tr align="center" nowrap> 
      <td align="left" ><div align="right">Imagen:&nbsp;</div></td>
      <td align="left" > <input type="file" name="FiletoUpload" size="45"> </td>
    </tr>
    <tr>
      <td colspan="2" valign="top" nowrap>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2" valign="top" nowrap><div align="center"> 
          <cfif modo NEQ "CAMBIO">
            <input type="submit" name="btnAgregar" value="Agregar" onClick="javascript:setBtn(this);">
            <cfelse>
            <input type="submit" name="btnCambiar" value="Modificar" onclick="javascript:setBtn(this);return true;">
            <input type="submit" name="btnEliminar" value="Eliminar" onclick="javascript:setBtn(this);;return confirm('¿Desea Eliminar la Imagen?');">
            <input type="submit" name="btnNuevo" value="Nuevo" onclick="javascript:setBtn(this);return true;">
          </cfif>
          <input type="submit" name="btnRegresar" value="Regresar" onclick="javascript:setBtn(this); return Formato();">
        </div></td>
    </tr>
    <tr> 
      <td colspan="2" valign="top" nowrap><div align="center">&nbsp; </div></td>
    </tr>
    <tr> 
      <td colspan="2" valign="top" nowrap><div align="center"> 
          <cfif modo NEQ "ALTA">
            <cf_sifleerimagen autosize="true" border="false"  tabla="LogoEmpresas" campo="Llogo" condicion="Ecodigo = '#Form.Empresa#'" conexion="emperador" imgname="Img#Form.Empresa#" width="80" height="80"> 
          </cfif>
        </div></td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>
  </table>
	
</form>

