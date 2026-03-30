
<cfparam name="url.PRJid">

<cfquery datasource="#session.dsn#" name="hdr">
	select PRJid, PRJcodigo,PRJfechaInicio,PRJdescripcion,Cmayor
	from PRJproyecto
	where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#" null="#Len(url.PRJid) is 0#">
</cfquery>


<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="4" style="border:1px solid black">
  <tr>
    <td>&nbsp;</td>
    <td><strong>Proyecto:</strong></td>
    <td>#hdr.PRJcodigo#</td>
    <td>&nbsp;</td>
    <td><strong>Fecha de inicio: </strong></td>
    <td><cfif Len(hdr.PRJfechaInicio)>#DateFormat(hdr.PRJfechaInicio,'dd-mm-yyyy')#
	<cfelse>
	Todav&iacute;a no se define
    </cfif></td>
    <td>&nbsp;</td>
    <td rowspan="2"><form name="form_back" method="get" action="Proyectos.cfm">
        <input type="hidden" name="PRJid" value="#hdr.PRJid#">
        <input type="submit" name="Submit" value="<< Regresar a Proyecto">
      </form></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><strong>Descripci&oacute;n:</strong></td>
    <td>#hdr.PRJdescripcion#</td>
    <td>&nbsp;</td>
    <td><strong>Cuenta de mayor:</strong></td>
    <td>#hdr.Cmayor#</td>
    <td>&nbsp;</td>
  </tr>
</table>
</cfoutput>