<cf_templateheader title="Reporte de Saldos">
	<cf_web_portlet_start titulo="Generaci&oacute;n del Reporte de Saldos">
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
	<form name="form1" action="QPassRSaldos_form.cfm" method="post" onsubmit="return validar(this);">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
            <tr>
                <td align="right"></td>
            <tr>
                <td align="right"><strong>Fecha Desde:</strong></td>
                <td>
                    <cfset QPLfechaSaldoD = '01/01/2009'>
                    <cf_sifcalendario form="form1" value="#QPLfechaSaldoD#" name="QPLfechaSaldoD" tabindex="1">
                </td>
                <td align="right"><strong>Fecha Hasta:</strong></td>
                <td>
                    <cfset QPLfechaSaldoH = DateFormat(Now(),'dd/mm/yyyy')>
                    <cf_sifcalendario form="form1" value="#QPLfechaSaldoH#" name="QPLfechaSaldoH" tabindex="1">
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
<script language="javascript1" type="text/javascript">
	
	function fnFechaYYYYMMDD (LvarFecha)
		{
			return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
		}
	
	function validar(formulario)
	{
			var error_input;
			var error_msg = '';
	
		if (fnFechaYYYYMMDD(document.form1.QPLfechaSaldoD.value) > fnFechaYYYYMMDD(document.form1.QPLfechaSaldoH.value)
		& fnFechaYYYYMMDD(document.form1.QPLfechaSaldoH.value) != '')
		{
			alert ("La Fecha Hasta no puede ser menor a la Fecha Desde");
			return false;
		}
		else
		{ return true;
		}
	}    
</script>
</cfoutput>

