<script language="JavaScript1.2">
function CambiaIdioma(valor) {
	document.Languaje.submit();
}
</script>
<cfquery name="rsIdiomas" datasource="sifcontrol">
	select convert(varchar,Iid) as Iid, Icodigo, Descripcion, Inombreloc from Idiomas
</cfquery>
<form name="Languaje" method="post">
	<div align="left"><cfoutput><cf_translate  key="LB_Idioma">Idioma</cf_translate>:</cfoutput><br>
	  <select name="Idioma" onChange="javascript:CambiaIdioma('this.value');">
	    <cfoutput query="rsIdiomas">
		    <option value="#rsIdiomas.Icodigo#" <cfif Session.Idioma EQ "#rsIdiomas.Icodigo#">selected</cfif>>#rsIdiomas.Inombreloc#</option>
	      </cfoutput>
	    </select>
    </div>
</form>
