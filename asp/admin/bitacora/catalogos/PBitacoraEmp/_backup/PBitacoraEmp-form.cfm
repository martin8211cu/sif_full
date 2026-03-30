<cfparam name="url.PBtabla" default="">

<cfquery datasource="asp" name="tablas">
	select PBtabla from PBitacora
	order by PBtabla
</cfquery>

<cfquery datasource="asp" name="data">
	select t.PBtabla, coalesce (e.PBinactivo,0) as PBinactivo, e.ts_rversion
	from PBitacoraEmp e
	right join PBitacora t
		on e.PBtabla = t.PBtabla
		and e.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.la_empresa#" null="#Len(url.la_empresa) Is 0#">
	where t.PBtabla = <cfqueryparam cfsqltype="cf_sql_char" value="#url.PBtabla#" null="#Len(url.PBtabla) Is 0#">
</cfquery>


<cfquery datasource="asp" name="empresa">
select Enombre from Empresa
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.la_empresa#" null="#Len(url.la_empresa) Is 0#">
</cfquery>

<cfoutput>
  <script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: PBitacoraEmp - Parámetros de Bitácora por empresa
				// Columna: PBtabla Tabla varchar(30)
				if (formulario.PBtabla.value == "") {
					error_msg += "\n - Tabla no puede quedar en blanco.";
					error_input = formulario.PBtabla;
				}
				// Columna: PBinactivo Inactivo bit
				if (formulario.PBinactivo.value == "") {
					error_msg += "\n - Inactivo no puede quedar en blanco.";
					error_input = formulario.PBinactivo;
				}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
//-->
</script>
  <form action="PBitacoraEmp-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
  <input type="hidden" name="la_empresa" value="#HTMLEditFormat(url.la_empresa)#">
		<input type="hidden" name="PBtabla" value="#HTMLEditFormat(data.PBtabla)#">
    <table width="299" summary="Tabla de entrada">
      <tr>
        <td colspan="5" class="subTitulo"> Parámetros de Bitácora por empresa </td>
      </tr>
      <tr>
        <td valign="top">&nbsp;</td>
        <td colspan="4" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td width="80" valign="top">Empresa</td>
        <td colspan="4" valign="top">#HTMLEditFormat(empresa.Enombre)#</td>
      </tr>
      <tr>
        <td valign="top">Tabla </td>
        <td colspan="4" valign="top">#HTMLEditFormat(data.PBtabla)#
        </td>
      </tr>
      <tr>
        <td valign="top">Bit&aacute;cora</td>
        <td width="20" valign="middle">
		<input name="PBinactivo" id="PBinactivo0" type="radio" value="0" onChange="this.form.submit()" <cfif Len(data.PBinactivo) is 0 or data.PBinactivo is 0>checked</cfif> >
        </td>
        <td width="81" valign="middle"><label for="PBinactivo0">Activa</label></td>
        <td width="20" valign="middle"><input name="PBinactivo" id="PBinactivo1" type="radio" value="1" onChange="this.form.submit()" <cfif Len(data.PBinactivo) And data.PBinactivo neq 0>checked</cfif> ></td>
        <td width="74" valign="middle"><label for="PBinactivo1">Inactiva</label></td>
      </tr>
      <tr>
        <td colspan="5" class="formButtons">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="5" class="formButtons" align="center">
		<input type="Submit" value="Modificar">
        </td>
      </tr>
    </table>
    <cfset ts = "">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
    </cfinvoke>
    <input type="hidden" name="ts_rversion" value="#ts#">
  </form>
</cfoutput> 