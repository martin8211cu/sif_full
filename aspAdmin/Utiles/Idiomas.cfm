<script language="JavaScript1.2">
function CambiaIdioma(valor) {
	document.Languaje.submit();
}
</script>
<cfquery name="rsIdioma" datasource="sifcontrol">
	select convert(varchar,Iid) as Iid, Icodigo, Descripcion, Inombreloc from Idioma
</cfquery>
<form name="Languaje" method="post">
	<div align="left"><cfoutput>#Request.Translate('Idioma','Idioma','/sif/Utiles/Generales.xml')#:</cfoutput><br>
	  <select name="Idioma" onChange="javascript:CambiaIdioma('this.value');">
	    <cfoutput query="rsIdioma">
		    <option value="#rsIdioma.Icodigo#" <cfif Session.Idioma EQ "#rsIdioma.Icodigo#">selected</cfif>>#rsIdioma.Inombreloc#</option>
	      </cfoutput>
	    </select>
    </div>
</form>
