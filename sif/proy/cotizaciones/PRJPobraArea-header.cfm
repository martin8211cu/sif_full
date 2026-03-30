
<cfparam name="url.PRJPOid">

<cfquery datasource="#session.dsn#" name="hdr">
	select PRJPOid, PRJPOcodigo,PRJPOdescripcion, PRJPOcliente, PRJPOlugar, PRJPOnumero
	from PRJPobra
	where PRJPOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJPOid#" null="#Len(url.PRJPOid) is 0#">
</cfquery>


<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="4" style="border:1px solid black">
  <tr>
    <td>&nbsp;</td>
    <td><strong>Obra:</strong></td>
    <td>#hdr.PRJPOcodigo#</td>
    <td>&nbsp;</td>
    <td><strong>Lugar: </strong></td>
    <td>#hdr.PRJPOlugar#</td>
    <td>&nbsp;</td>
    <td rowspan="2"><form name="form_back" method="get" action="PRJPobras.cfm">
        <input type="hidden" name="PRJPOid" value="#hdr.PRJPOid#">
		<input type="hidden" name="btnatras" value="1">
        <input type="submit" name="Submit" value="<< Regresar a la Obra">
      </form></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><strong>Descripci&oacute;n:</strong></td>
    <td>#hdr.PRJPOdescripcion#</td>
    <td>&nbsp;</td>
    <td><strong>Cliente:</strong></td>
    <td>#hdr.PRJPOcliente#</td>
    <td>&nbsp;</td>
  </tr>
</table>
</cfoutput>
