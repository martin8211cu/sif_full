<!---  --->
<cfset modo = 'ALTA' >
<cfif isdefined("form.Modo") and form.Modo NEQ 'ALTA'>
	<cfset modo = 'CAMBIO' >
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rsCContratacion" datasource="#Session.DSN#">
		select CTPCcodigo, CTPCdescripcion
		from CTProcedimientoContratacion
		where CTPCid = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CTPCid#" >
			and Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>

<form action="ProcedimientoDContratacion-SQL.cfm" method="post" name="form1" onSubmit="javascript: document.form1.CTPCcodigo.disabled = false; return true;" >
	<cfoutput>
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">
	<input name="CTPCid" type="hidden" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(Form.CTPCid)#</cfoutput></cfif>">
	</cfoutput>
  <table width="100%" align="center">
    <tr>
      <td width="50%" align="right" valign="middle" nowrap> C&oacute;digo:&nbsp;</td>
      <td>
        <input  name="CTPCcodigo" type="text" tabindex="1"  <cfoutput><cfif modo NEQ "ALTA"> value="#HTMLEditFormat(rsCContratacion.CTPCcodigo)#"
		</cfif></cfoutput> size="10" maxlength="20" <cfif modo neq 'ALTA'>disabled</cfif>>
		<div align="right"></div>
      </td>
    </tr>
    <tr>
      <td align="right" valign="middle" nowrap>Descripci&oacute;n:&nbsp;</td>
      <td>
        <input name="CTPCdescripcion" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsCContratacion.CTPCdescripcion)#</cfoutput></cfif>" size="40" maxlength="80">
		<div align="right"></div>
      </td>
    </tr>

    <tr>
      <td colspan="2" nowrap>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" align="center" nowrap>
		<cfset tabindex = 2 >

		<input type="submit" <cfif modo eq 'ALTA'> name="Alta" value="Agregar"<cfelse>name="Cambio" value="Modificar"</cfif> class="btnGuardar" onclick="return valida();">

	<cfif modo neq 'ALTA'>
		<input type="submit" name="Nuevo" value="Nuevo" class="btnNuevo">
		<input type="submit" name="Baja" value="Eliminar" class="btnEliminar">
	</cfif>
		<input type="button" name="Limpiar" value="Limpiar" class="btnLimpiar" onclick="return limpiar();">
		<input type="submit" name="Buscar" value="Buscar" class="btnNormal" size="5" style="margin: 2px 5px;">

      </td>
    </tr>
  </table>
<cfset ts = "">

 </form>

<script>

function valida(){
var err = '';

	if(form1.CTPCcodigo.value == ''){
	err = "\n - El Codigo del Contrato es requerido";

	}
	if(form1.CTPCdescripcion.value == ''){
	 err = err +  "\n - La Descripcion del Contrato es requerido";
	}

	if(err != ''){
		alert("Se presentaron los siguientes errores: " + err);
		return false;
	}else{
	return true;
	}

}


function limpiar(){
	document.form1.CTPCcodigo.value = ''
	document.form1.CTPCdescripcion.value = ''
}


</script>

<cf_qforms form="form1">
<!--- 	<cf_qformsRequiredField  name="CTPCcodigo" description="C�digo">
	<cf_qformsRequiredField name="CTPCdescripcion" description="Descripci�n"> --->
</cf_qforms>