<cfparam name="url.s" default="">
<cfparam name="categoria.RecordCount" default="0">

<form name="catsearchform" method="get" style="margin:0" action="catsearch.cfm" onSubmit="return(this.s.value.length != 0)">
<table border="0">
  <tr>
    <td>Buscar 
      <cfif categoria.RecordCount and categoria.Ccodigo>
en <cfoutput>#categoria.Cdescripcion#
<input type="hidden" name="cat" value="#categoria.Ccodigo#"></cfoutput>
</cfif></td>
    <td>&nbsp;</td>
    <td><input type="text" name="s" value="<cfoutput>#HTMLEditFormat(url.s)#</cfoutput>"></td>
    <td><img src="images/btn_search.gif" width="21" height="21" onClick="if (document.catsearchform.s.value.length != 0)document.catsearchform.submit()"></td>
  </tr>
</table>

</form>
