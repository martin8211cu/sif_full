
<cfif not isdefined ('form.MIGReid') and isdefined ('url.MIGReid') and trim(url.MIGReid) >
	<cfset form.MIGReid=url.MIGReid>
</cfif>
<cfif not isdefined("Form.modo") and not isdefined ('URL.Nuevo') and not isdefined ('form.Nuevo')>
	<cfset form.modo=url.modo>
</cfif>
<cfif not isdefined ('url.Tab')>
	<cfset url.Tab=1>
<cfelse>
	<cfset url.Tab=url.Tab>
	<cfset modo='CAMBIO'>
</cfif>
   <cfinvoke component="mig.Componentes.Translate"
    method="Translate"
    Key="LB_DatosGenerales"
    Default="Responsables"
    returnvariable="LB_generales"/>

    <cfinvoke component="mig.Componentes.Translate"
    method="Translate"
    Key="LB_Cuentas"
    Default="Departamentos"
    returnvariable="LB_SD"/>

	<cf_tabs width="100%">
    	<cf_tab text="#LB_generales#" selected="#url.Tab NEQ 2#">
    		<cf_web_portlet_start border="true" titulo="#LB_generales#" >
    			<cfinclude template="ResponsableTab1.cfm">
    		<cf_web_portlet_end>
   		</cf_tab>
   	<cfif modo NEQ 'ALTA'>
    	<cf_tab text="#LB_SD#" selected="#url.Tab EQ 2#">
			<cf_web_portlet_start border="true" titulo="#LB_SD#">
			  <cfinclude template="ResponsableTab2.cfm">
			<cf_web_portlet_end>
    	</cf_tab>
	</cfif>
	</cf_tabs>

        </td>
      </tr>
    </table>


<!--- ********************************************************************************** --->




 <!---


<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset modo=url.modo>
</cfif>
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfset LvarInclude="">

<cfif modo EQ 'ALTA'>
	<cfset LvarInclude="Importar">
</cfif>

<cfif not isdefined ('form.MIGReid') and isdefined ('url.MIGReid') and trim(url.MIGReid) >
	<cfset form.MIGReid=url.MIGReid>
</cfif>
<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsResponsable">
		select
				MIGReid,
				MIGRcodigo,
				MIGRenombre,
				MIGRecorreo,
				MIGRecorreoadicional,
				case Dactivas
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Dactiva desconocido'
				end as Dactiva
		from MIGResponsables
		where MIGReid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGReid#">
	</cfquery>
</cfif>


<cfoutput>
	<form method="post" name="form1" action="ResponsableSQL.cfm" onSubmit="return validar(this);">
	<table align="center">
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Responsable: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#rsResponsable.MIGRcodigo#
					<input type="hidden" name="MIGReid" id="MIGReid" value="#rsResponsable.MIGReid#">
				<cfelse>
					<input type="text" name="MIGRcodigo" id='MIGRcodigo' maxlength="10" value="" size="32" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Nombre Responsable:</td>
			<td align="left"><input type="text" name="MIGRenombre" id='MIGRenombre' maxlength="100" value="<cfif modo NEQ 'ALTA'>#rsResponsable.MIGRenombre#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Correo Electr&oacute;nico:</td>
			<td align="left"><input type="text" name="MIGRecorreo" id='MIGRecorreo' maxlength="100" value="<cfif modo NEQ 'ALTA'>#rsResponsable.MIGRecorreo#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Correo Electr&oacute;nico Adicional:</td>
			<td align="left"><input type="text" name="MIGRecorreoadicional" id='MIGRecorreoadicional' maxlength="100" value="<cfif modo NEQ 'ALTA'>#rsResponsable.MIGRecorreoadicional#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center" nowrap><cf_botones modo="#modo#" include="#LvarInclude#"></td>
		</tr>
	</table>
	</form>
</cfoutput>

<!---ValidacionesFormulario--->

<script type="text/javascript">
function validar(formulario)	{
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Importar',document.form1) ){
		var error_input;
		var error_msg = '';
	<cfif modo EQ 'ALTA'>
		if (formulario.MIGRcodigo.value == "") {
			error_msg += "\n - El código del Reponsable no puede quedar en blanco.";
			error_input = formulario.MIGRcodigo;
		}
	</cfif>
		if (formulario.MIGRenombre.value == "") {
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGRenombre;
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>

--->


