<cfif isdefined("LvarUsuarioCorporativo") and LvarUsuarioCorporativo EQ true>
	<cfset LvarOficinas = "">
<cfelse>
	<cfquery name="rsOficinasUsuario" datasource="#session.DSN#">
		select Ocodigo
        from QPassUsuarioOficina
        where Usucodigo = #session.Usucodigo#
    </cfquery>
	<cfif rsOficinasUsuario.recordCount gt 0>
   	 <cfset LvarOficinas = " and a.Ocodigo in (#valuelist(rsOficinasUsuario.Ocodigo)#) ">
	<cfelse>
		<cfthrow message="El usuario no se encuentra asociado a ninguna oficina">
	</cfif>	
</cfif>
<cf_templateheader title="Generaci&oacute;n del Reporte de Ventas">
	<cf_web_portlet_start titulo="Generaci&oacute;n del Reporte de Ventas">
	<br>
	<cfquery name="rsSucursal" datasource="#session.dsn#">
		select 
			a.Ocodigo,
			a.Oficodigo,
			a.Odescripcion 
        from Oficinas a
        where a.Ecodigo = #session.Ecodigo#
		#LvarOficinas#
        order by Oficodigo
	</cfquery>	
	
	<cfoutput>
	<form name="form1" action="QPassRVentas_form.cfm" method="post" onsubmit="return validar(this);">
		<input type="hidden" name="LvarOficinas" value="#LvarOficinas#" />
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
            <tr>
                <td align="right"></td>
            <tr>
                <td align="right"><strong>Fecha Desde:</strong></td>
                <td>
                    <cfset QPLfechaVentaD = DateFormat(Now(),'dd/mm/yyyy')>
                    <cf_sifcalendario form="form1" value="#QPLfechaVentaD#" name="QPLfechaVentaD" tabindex="1">
                </td>
                <td align="right"><strong>Fecha Hasta:</strong></td>
                <td>
                    <cfset QPLfechaVentaH = DateFormat(Now(),'dd/mm/yyyy')>
                    <cf_sifcalendario form="form1" value="#QPLfechaVentaH#" name="QPLfechaVentaH" tabindex="1">
                </td>
                <td align="right"><strong>Sucursal:</strong></td>
                <td>
                    <select name="Oficina" tabindex="1">
                        <option value="" selected>--Todos--</option>
                        <cfloop query="rsSucursal">
                            <option value="#rsSucursal.Ocodigo#">#rsSucursal.Oficodigo#-#rsSucursal.Odescripcion#</option>
                        </cfloop>
                    </select>
                </td> 
		<td nowrap align="right"><strong>Formato:</strong>&nbsp;</td>
	  	<td nowrap>
			<select name="formato" tabindex="1">
				<option value="xls">Archivo Plano</option>
				<option value="html">En l&iacute;nea (HTML)</option>
			</select>
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
	
		if (fnFechaYYYYMMDD(document.form1.QPLfechaVentaD.value) > fnFechaYYYYMMDD(document.form1.QPLfechaVentaH.value)
		& fnFechaYYYYMMDD(document.form1.QPLfechaVentaH.value) != '')
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
