<cf_templateheader title="Reporte de Recuperación de Cobros">
	<cf_web_portlet_start titulo="Generaci&oacute;n del Recuperación de Cobros">
	<br>
	<cfquery name="rsSucursal" datasource="#session.dsn#">
		select 
			a.Ocodigo,
			a.Oficodigo,
			a.Odescripcion 
        from Oficinas a
        where a.Ecodigo = #session.Ecodigo#
        order by Oficodigo
	</cfquery>	
	
	<cfoutput>
	<form name="form1" action="QPassRecuperaciones_form.cfm" method="post" onsubmit="return validar(this);">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
            <tr>
                <td align="right"></td>
            <tr>
                <td align="right"><strong>Fecha:</strong></td>
                <td>
                    <cfset fecha1 = DateFormat(Now(),'dd/mm/yyyy')>
                    <cf_sifcalendario form="form1" value="#fecha1#" name="fecha" tabindex="1">
                </td>
                <td align="center"><input type="submit" name="Generar" tabindex="1"value="Generar">
                </td>
            </tr>
             <tr> 
                <td valign="top"> </td>
             </tr>
        </table>
    </form>
    </cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>

<cfoutput>
<script language="javascript" type="text/javascript">
	function validar(formulario)
	{

			var error_input;
			var error_msg = '';
	
		if (formulario.fecha.value == "" ) 
		{
				
			alert ("La Fecha no puede quedar en blanco");
			return false;
		}
		else
		{ return true;
		}
	}    
</script>
</cfoutput>
