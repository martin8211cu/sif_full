<!---Establecimiento de la navegacion --->
<cfif isdefined("url.FFAM09MAQ") and not isdefined("form.FFAM09MAQ") >
	<cfset form.FFAM09MAQ = url.FFAM09MAQ >
</cfif>
<cfif isdefined("url.FFAM09DES") and not isdefined("form.FFAM09DES") >
	<cfset form.FFAM09DES = url.FFAM09DES >
</cfif>
<cfoutput>
<form style="margin: 0" action="cajasProceso.cfm" name="cajas" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
  		<!--- FILTROS --->
   		<tr> 
    		<td align="right" class="fileLabel" nowrap width="1%"><label for="FFAM09MAQ"><strong>C&oacute;digo:&nbsp;</strong></label><input type="text" name="FFAM09MAQ" size="20" maxlength="100" value="<cfif isdefined('form.FFAM09MAQ')>#form.FFAM09MAQ#</cfif>"  ></td>
	  		<td align="right" class="fileLabel" nowrap width="1%"><label for="FFAM09DES"><strong>Descripci&oacute;n:&nbsp;</strong></label><input type="text" name="FFAM09DES" size="20" maxlength="100" value="<cfif isdefined('form.FFAM09DES')>#form.FFAM09DES#</cfif>"  ></td>
	 		<td>&nbsp;&nbsp;<input type="submit" name="btnFiltro"  value="Filtrar"></td>
  		</tr>
 	</table>
</form>

</cfoutput>
<!--- Definir el Filtro --->
<cfset filtro = "">
<cfset nav = "">
<cfif isdefined("form.FFAM09MAQ") and len(trim(form.FFAM09MAQ))>
	<cfset filtro = filtro & " and FAM09MAQ = #form.FFAM09MAQ#">
	<cfset nav = "&FFAM09MAQ=#form.FFAM09MAQ#">
</cfif>

<cfif isdefined("form.FFAM09DES") and len(trim(form.FFAM09DES))>
	<cfset filtro = filtro & " and FAM09DES like '%#form.FFAM09DES#%'">
	<cfset nav = "&FFAM09DES=#form.FFAM09DES#">
</cfif>
