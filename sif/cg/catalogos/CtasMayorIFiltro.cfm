<!--- 
	Modificado por: E. Raúl Bravo Gómez
	Fecha: 21 de agosto del 2013
 --->

<cfquery name="rsIdiomas" datasource="#Session.DSN#">
	select Iid, Descripcion as LOCIdescripcion
	from Idiomas
	order by 1, 2
</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
  
<table  border="0" cellspacing="0" cellpadding="0" class="areafiltro">
<form name="filtroCuentasMayor" method="post" action="#CurrentPage#">
    <cfoutput>
	<input type="hidden" name="Cmayor" 			value="#form.Cmayor#">
 	<input type="hidden" name="Cdescripcion" 	value="#form.Cdescripcion#" />
    <tr>
        <td align="left" ><strong>#Lbl_Idioma#</strong></td>
        <td align="left" ><strong>#MSG_Descripcion#</strong></td>
    </tr>
    <tr>
    <td>
    <select name="IdiomaF">
    <option value="" selected> #Lbl_Ninguno# </option>
    <cfloop query="rsIdiomas">
    	<option value="#rsIdiomas.Iid#" <cfif isdefined("form.IdiomaF") and form.IdiomaF eq rsIdiomas.Iid> selected</cfif>>#rsIdiomas.LOCIdescripcion#</option>
    </cfloop>
    </select>
    </td>
        <td align="left" >
            <input name="DescripcionF" type="text" size="30" tabindex="1" maxlength="80" <cfif isdefined("form.DescripcionF") and len(trim(form.DescripcionF)) gt 0>value="#form.DescripcionF#"</cfif>>
        </td>
        <td align="center">
            <input name="Filtrar" class="BtnFiltrar" type="submit" value="Filtrar" tabindex="1">
        </td>
    </tr>
    </cfoutput>
</form>
</table>
	
