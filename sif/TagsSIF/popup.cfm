<cfparam name="Attributes.link" 		default="SIF" 		type="string">
<cfparam name="Attributes.url" 			default="##" 		type="string">
<cfparam name="Attributes.boton" 		default="true" 		type="boolean">
<cfparam name="Attributes.width" 		default="-1" 		type="numeric">
<cfparam name="Attributes.height" 		default="-1"  		type="numeric">
<cfparam name="Attributes.left" 		default="-1" 		type="numeric">
<cfparam name="Attributes.top" 			default="-1"  		type="numeric">
<cfparam name="Attributes.name" 		default="1"  		type="numeric">
<cfparam name="Attributes.resize" 		default="no"  		type="string">
<cfparam name="Attributes.status" 		default="no"  		type="string">
<cfparam name="Attributes.scrollbars" 	default="no"  		type="string">
<cfparam name="Attributes.menubar" 		default="no"  		type="string">
<cfparam name="Attributes.ejecutar" 	default="false"  	type="boolean">
<cfparam name="Attributes.class" 		default="btnNormal" type="string">


<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
var popUpWin<cfoutput>#Attributes.name#</cfoutput>=0;
function popUpWindow<cfoutput>#Attributes.name#</cfoutput>(URLStr){
<cfif Attributes.width LT 0>
	ww = parseInt(screen.width) - 10;
<cfelse>
	ww = <cfoutput>#Attributes.width#;</cfoutput>
</cfif>	
<cfif Attributes.height LT 0>
	wh = parseInt(screen.height) - 60;
<cfelse>
	wh = <cfoutput>#Attributes.height#;</cfoutput>
</cfif>	
<cfif Attributes.left LT 0>
	wl = 0;
<cfelse>
	wl = <cfoutput>#Attributes.left#;</cfoutput>
</cfif>	
<cfif Attributes.top LT 0>
	wt = 0;
<cfelse>
	wt = <cfoutput>#Attributes.top#;</cfoutput>
</cfif>	
  if(popUpWin<cfoutput>#Attributes.name#</cfoutput>)
  {
	if(!popUpWin<cfoutput>#Attributes.name#</cfoutput>.closed) popUpWin<cfoutput>#Attributes.name#</cfoutput>.close();
  }
  popUpWin<cfoutput>#Attributes.name#</cfoutput> = open(URLStr, 'popUpWin<cfoutput>#Attributes.name#</cfoutput>', 'toolbar=no,location=no,directories=no,status=<cfoutput>#Attributes.status#</cfoutput>,menubar=<cfoutput>#Attributes.menubar#</cfoutput>,scrollbars=<cfoutput>#Attributes.scrollbars#</cfoutput>,resizable=<cfoutput>#Attributes.resize#</cfoutput>,copyhistory=yes,width='+ww+',height='+wh+',left='+wl+', top='+wt+',screenX='+wl+',screenY='+wt+'');
}
// End -->
</script>
<cfoutput>
<cfif Attributes.ejecutar>
	<script language="JavaScript1.2">
		popUpWindow<cfoutput>#Attributes.name#</cfoutput>('#attributes.url#')	
	</script>
<cfelse>
	<cfif Attributes.boton>
		<input type="button" name="btnpopUp" value="#attributes.link#" onclick="javascript:popUpWindow<cfoutput>#Attributes.name#</cfoutput>('#attributes.url#')" class="#Attributes.class#">
	<cfelse>
		<a href="javascript:popUpWindow<cfoutput>#Attributes.name#</cfoutput>('#attributes.url#')" title="#attributes.link#">#attributes.link#</a>
	</cfif>
</cfif>
</cfoutput>
