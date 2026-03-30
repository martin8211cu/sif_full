<cfset def = QueryNew('dato')>
<!--- Parámetros del TAG --->
<cfparam name="Attributes.form" default="form1" type="String">
<cfparam name="Attributes.query" default="#def#" type="query">
<cfparam name="Attributes.conlis" default="true" type="boolean">
<cfparam name="Attributes.idlinea" default="DOlinea" type="string">
<cfparam name="Attributes.iddesc" default="DPDdescripcion" type="string">
<cfparam name="Attributes.EOidorden" default="EOidorden" type="string">
<cfparam name="Attributes.frame" default="fr#Attributes.idlinea#" type="string">
<cfparam name="Attributes.tabindex" default="" type="string">
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfif Attributes.conlis>
<script language="JavaScript" type="text/javascript">
	<!--//
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.idlinea#</cfoutput>(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis

	function doConlisLineasOrdenCM<cfoutput>#Attributes.idlinea#</cfoutput>() {
		var params ="";
		<cfoutput>
			params = "?formname=#Attributes.form#";
				params += "&idlinea=#Attributes.idlinea#";
				params += "&iddesc=#Attributes.iddesc#";
				params += "&EOidorden=#Attributes.EOidorden#";
		</cfoutput>			

		popUpWindow<cfoutput>#Attributes.idlinea#</cfoutput>("/UtilesExt/ConlisLineasOrdenCM.cfm"+params,160,200,800,430);

	}
	//-->
</script>
</cfif>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset idlinea = Trim(Evaluate('Attributes.query.' & Attributes.idlinea))>
		<cfset iddesc = Trim(Evaluate('Attributes.query.' & Attributes.iddesc))>
	</cfif>
	<cfoutput>
	<tr>
		<td>
			<input type="hidden"
				name="#Attributes.idlinea#" id="#Attributes.idlinea#"
				value="<cfif isdefined('Attributes.query') and  Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1>#idlinea#</cfif>">


			<cfif Attributes.conlis>
			<input type="text" size="#Attributes.size#" readonly style="border:0;"
				name="#Attributes.iddesc#" id="#Attributes.iddesc#"
				value="<cfif isdefined('Attributes.query') and  Attributes.query.RecordCount gt 0 and ListLen(Attributes.query.columnList) GT 1>#iddesc#</cfif>">
			<a href="##" tabindex="-1"><img src="/imagenes/Description.gif" alt="Lista de Art&iacute;culos" name="img#Attributes.idlinea#" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisLineasOrdenCM#Attributes.idlinea#();'></a>
			<cfelse>
				#iddesc#
			</cfif>
		</td>
	</tr>
	</cfoutput>
</table>
<cfif Attributes.conlis>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: ;"></iframe>
</cfif>