<cfoutput>
<cfif isdefined("url.modificar")>
	<cfquery datasource="sifcontrol">
		update PortalRespuesta
		set PRtexto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.PRtexto)#">
		where PRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRid#">
	</cfquery>

	<cfquery name="data" datasource="sifcontrol">
		select PRtexto
		from PortalRespuesta
		where PRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRid#">
	</cfquery>
	
	<cfset expresion = "\<[A-Za-z=\'" >
	<cfset expresion = expresion & '\"\0-9.\(\)\:\;\-## ]*>' >
	
	<cfset dato = REReplace(data.PRtexto, expresion,'', 'ALL') >
	
	<script type="text/javascript" language="javascript1.2">
		function trim(dato) {
			dato = dato.replace(/^\s+|\s+$/g, '');
			return dato;
		}
	
		window.opener.document.form3['_PRtexto_#url.indice#'].value = '#trim(JSStringFormat(dato))#';
		window.opener.document.form3['_PRtexto_#url.indice#'].value = trim(window.opener.document.form3['_PRtexto_#url.indice#'].value);
		window.opener.document.form3['PRtexto_#url.indice#'].value = '#JSStringFormat(data.PRtexto)#';
	</script>
</cfif>

<script type="text/javascript" src="/cfmx/rh/js/FCKeditor/fckeditor.js"></script>
<cf_templatecss>

<form name="form1" method="get" action="">
<table width="100%" cellpadding="5" cellspacing="0" >
	<tr>
		<td>
			<!---<cf_sifeditorhtml name="PRtexto" value="#data.PRtexto#">--->
			<script type="text/javascript">
				<!--
				<cfoutput>
				
				var oFCKeditor = new FCKeditor( 'oFCKeditor_PRtexto' ) ;
				oFCKeditor.InstanceName	= 'PRtexto';
				<cfif isdefined("url.modificar")>
					oFCKeditor.Value = '#JSStringFormat(data.PRtexto)#';
				<cfelse>
					oFCKeditor.Value = window.opener.document.form3['PRtexto_#url.indice#'].value;
				</cfif>

				oFCKeditor.ToolbarSet = 'SIF';
				oFCKeditor.Width  = '100%';
				oFCKeditor.Height = '200';
			
				oFCKeditor.Create() ;
				</cfoutput>
				//-->
			</script>
		</td>
	</tr>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Modificar"
	Default="Modificar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Modificar"/>	

	
	<tr><td align="center"><input type="submit" name="modificar" value="<cfoutput>#BTN_Modificar#</cfoutput>"></td></tr>
</table>
	<input type="hidden" name="PRid" value="#url.PRid#">
	<input type="hidden" name="indice" value="#url.indice#">
</form>
</cfoutput>

<!---
<cfoutput>
<cfset x = '<strong>Respuesta</strong> 2 de la <font style="BACKGROUND-COLOR: ##ff9900">Pregun</font>' >
<cfset dato = REReplace(x, expresion,'', 'ALL') >
<input type="text" size="100" value="#dato#">
</cfoutput>
--->

