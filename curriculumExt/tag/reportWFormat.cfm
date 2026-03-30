<cfparam name="Attributes.url" type="string" default="">
<cfparam name="Attributes.orientacion" type="string" default="portrait">
<cfparam name="Attributes.params" type="string" default="">
<cfparam name="Attributes.regresar" type="string" default="">
<cfparam name="Attributes.pagina" type="string" default="">

<cfoutput><form action="#Attributes.regresar#" method="get" name="form1" style="margin:0">
<table width="950" border="0" cellspacing="0" cellpadding="0" style="margin:0">
  <tr>
    <th scope="col" nowrap valign="middle" width="99%">&nbsp;</th>
    <th scope="col" nowrap valign="middle"><strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></th>
    <th scope="col" nowrap valign="middle" width="99%">
            <select name="formato" tabindex="1" onchange="javascript: changeFormat(this.value);">
                <option value="HTML">HTML</option>
                <option value="FlashPaper">FlashPaper</option>
                <option value="PDF">Adobe PDF</option>
            </select>
    </th>
    <th scope="col" nowrap valign="middle">
		<cfif isdefined('Attributes.regresar') and LEN(TRIM(Attributes.regresar))>
	    <cf_botones values="Regresar">
		<cfelse>
		&nbsp;
		</cfif>
    </th>
  </tr>
</table>
</form>
<iframe
	id="r" 
    frameborder="0" 
	name="r" 
    width="950"  
    height="600" 
	style="visibility:visible;border:none; 
    vertical-align:top" align="middle" 
	src="/UtilesExt/reportWFormatLayout.cfm?formato=HTML&url=#Attributes.url#&orientacion=#Attributes.orientacion#&pagina=#Attributes.pagina#&#Attributes.params#">
</iframe>
</cfoutput>
<script language="javascript">
	function changeFormat(formato){
		document.getElementById("r").src="/UtilesExt/reportWFormatLayout.cfm?formato="+formato+"&url=<cfoutput>#Attributes.url#</cfoutput>&orientacion=<cfoutput>#Attributes.orientacion#</cfoutput>&pagina=<cfoutput>#Attributes.pagina#</cfoutput>&<cfoutput>#Attributes.params#</cfoutput>";
	}
</script>