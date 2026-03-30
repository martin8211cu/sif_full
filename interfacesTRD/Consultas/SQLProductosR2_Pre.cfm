<cfparam name="url.formato" default="HTML">
<cfparam name="url.IncluirOficina" default="01">

<cfif not isdefined('form.formato') and isdefined('url.formato')>
	<cfset form.formato = url.formato>
</cfif>
<!---
<form name="form1" method   = "post">
 <table border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td><strong>Visualizar en formato:</strong></td>
		<td>
			<select name="formato">
				<option value="flashpaper" <cfif ucase(form.formato) EQ "FLASHPAPER">selected</cfif> >FLASHPAPER</option>
				<option value="pdf" <cfif ucase(form.formato) EQ "PDF">selected</cfif> >PDF</option>
				<option value="HTML" <cfif ucase(form.formato) EQ "HTML">selected</cfif> >HTML</option>
			</select>
		</td>
		<td><input name="visualiza" type="submit" value="Generar"></td>
		<td><input name="Regresar" type="button" value="Regresar" onclick="funcRegresar()"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
</form>
--->
<cfoutput>

<cfif not isdefined('form.Formato')>
	<cfset form.formato = 'HTML'>
</cfif>
<script language="javascript" type="text/javascript">
	function funcRegresar(){
		document.form1.action="/cfmx/interfacesPMI/componentesInterfaz/ProcFactProd.cfm";
		document.form1.submit();
	}

</script>
<cfif form.formato EQ "HTML">
	<form name="form1n" action="SQLProductosR2.cfm" method="post">
		<input type="hidden" name="IncluirOficina" value="#url.IncluirOficina#" />
	</form>
	<script language="javascript" type="text/javascript">
		document.form1n.submit();
	</script>
</cfif>
</cfoutput>
