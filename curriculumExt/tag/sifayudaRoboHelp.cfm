<cfparam name="Attributes.name" default="imAyuda" type="string">
<cfparam name="Attributes.width" default="700" type="numeric">
<cfparam name="Attributes.height" default="650" type="numeric">
<cfparam name="Attributes.left" default="20" type="numeric">
<cfparam name="Attributes.top" default="5" type="numeric">
<cfparam name="Attributes.url" default="/UtilesExt/sifayudahelp.cfm" type="string">
<cfparam name="Attributes.imagen" default="3" type="numeric">

<SCRIPT LANGUAGE="JavaScript">
	<!-- Begin
	var rh_popUpWin<cfoutput>#Attributes.name#</cfoutput>=0;
	function rh_popUpWindow<cfoutput>#Attributes.name#</cfoutput>(){
		<cfif Attributes.width EQ "">
			ww = parseInt(screen.width) - 10;
		<cfelse>
			ww = <cfoutput>#Attributes.width#;</cfoutput>
		</cfif>	
		<cfif Attributes.height EQ "">
			wh = parseInt(screen.height) - 60;
		<cfelse>
			wh = <cfoutput>#Attributes.height#;</cfoutput>
		</cfif>	
		<cfif Attributes.left EQ "">
			wl = 0;
		<cfelse>
			wl = <cfoutput>#Attributes.left#;</cfoutput>
		</cfif>	
		<cfif Attributes.top EQ "">
			wt = 0;
		<cfelse>
			wt = <cfoutput>#Attributes.top#;</cfoutput>
		</cfif>	

		  if(rh_popUpWin<cfoutput>#Attributes.name#</cfoutput>){
			if(!rh_popUpWin<cfoutput>#Attributes.name#</cfoutput>.closed) rh_popUpWin<cfoutput>#Attributes.name#</cfoutput>.close();
		  }

		URLStr = "<cfoutput>#cgi.CONTEXT_PATH#</cfoutput>/sif/hh/ayudas/SIF/!SSL!/WebHelp_Pro/SIF.htm#<cfoutput>#attributes.url#</cfoutput>";
//alert(URLStr);
		rh_popUpWin<cfoutput>#Attributes.name#</cfoutput> = open(URLStr, 'rh_popUpWin<cfoutput>#Attributes.name#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height='+wh+',left=200, top='+wt+',screenX='+wl+',screenY='+wt+'');			
	}
	// End -->
</script>
<script language="javascript1.2" type="text/javascript">
	function rh_mostrar<cfoutput>#Attributes.name#</cfoutput>(URLStr){
		rh_popUpWindow<cfoutput>#Attributes.name#</cfoutput>('#attributes.URLStr#');
	}
</script>

<!--- IMAGEN DE AYUDA ---> 
<cfoutput>
	<img	name="#Attributes.name#"
		src=
			<cfif Attributes.imagen EQ 0>"#cgi.CONTEXT_PATH#imagenes/help_u.gif"</cfif>
			<cfif Attributes.imagen EQ 1>"#cgi.CONTEXT_PATH#imagenes/Help01_T.gif"</cfif>
			<cfif Attributes.imagen EQ 2>"#cgi.CONTEXT_PATH#imagenes/Bulb.gif"</cfif>
			<cfif Attributes.imagen EQ 3>"#cgi.CONTEXT_PATH#imagenes/Help02_T.gif"</cfif>
		border="0" 
		style="cursor:hand;"
		onClick="javascript:rh_mostrar<cfoutput>#Attributes.name#()</cfoutput>"
		alt="Mostrar Ayuda" >
</cfoutput>