<!--- Consultas --->

<cfquery name="rsData" datasource="asp">
	select a.id_direccion
	from Usuario a
	where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>

<form name="form1" method="post" action="usuario-apply2.cfm" style="margin:0 ">
<cfoutput>
<table width="100%" border="0" align="left" cellpadding="0" cellspacing="4">

				<tr>
				  <td colspan="2"><cf_direccion action="input" key="#rsData.id_direccion#" >&nbsp;</td>
			  </tr>
				<tr align="center">
				  <td colspan="2">
				  <cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Modificar"
					Default="Modificar"
					returnvariable="BTN_Modificar"/>
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Restablecer"
					Default="Restablecer"
					returnvariable="BTN_Restablecer"/>
				  <input name="Cambio" type="submit" class="btnGuardar" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); " value="#BTN_Modificar#">
                  <input name="Reset" type="reset" class="btnLimpiar" value="#BTN_Restablecer#"></td>
			  </tr>
				<tr align="center">
				  <td colspan="2">&nbsp;</td>
	  </tr>
    </table>
</cfoutput>
</form>
