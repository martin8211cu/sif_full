
<cfparam name="prevPag">
<cfparam name="targetAction">
<cfparam name="printableArea"   default="printableArea">
<cfparam name="iframeSRC"       default="#targetAction#">
<cfparam name="iframeName"      default="printerIframe">
<cfparam name="debug"           default=0>

<cfset iframeSRC = "/cfmx/crc/credito/operacion/#iframeSRC#">

<cfif debug>
    <cfdump var="#form#">
    <cfdump var="#url#">
</cfif>
<cfif isDefined('url.p') && url.p eq 1>
    <cfif debug>
        <cfif isdefined('form.html')>
            <cfdump var="#form.html#">
        <cfelse>
            <cfdump var="FALTA HTML">
        </cfif>
    </cfif>
	<cfset filePath = "ram:///#Replace(LB_Titulo2,' ','_','all')#.pdf">
	<cfdocument 
		format = "PDF" marginBottom = "0" marginLeft = "0" marginRight = "0" marginTop = "0"
		pageType = "letter" unit= "cm" filename = "#filePath#" overwrite = "yes"
	>
		<cfoutput> #form.html# </cfoutput>
	</cfdocument>
	<cfheader name="Content-Disposition" value="attachment; filename=#Replace(LB_Titulo2,' ','_','all')#.pdf">
	<cfcontent type="text/html" file="#filePath#" deletefile="yes">

<cfelseif isDefined('url.p') && url.p eq 0>
    <cfoutput>

        <cfset vparams="&p=1">
        
        <cfif debug>
            <iframe name="#iframeName#" id="#iframeName#" 
                src="#iframeSRC#"
                width="800px" height="600px"
                >
            </iframe>
        <cfelse>
            <iframe name="#iframeName#" id="#iframeName#" 
                src="#iframeSRC#" 
                style="border:0; border:none;"
                width="0px" height="0px"
                >
            </iframe>
        </cfif>

        <form name="form1" method="post" action="#targetAction#?#vparams#">
            <input type="hidden" name="html">
            <a onclick="prevPag('#prevPag#')"><img src="/cfmx/rh/imagenes/back.gif" alt="Regresar" 	name="regresar" border="0" align="absmiddle"> Regresar</a>
            &emsp;<a onclick="printDiv('#printableArea#')"><img src="/cfmx/rh/imagenes/impresora.gif" border="0"> Imprimir</a>
        </form>

        <script>

            function printDiv(divName) {
                var printContents = document.getElementById(divName).innerHTML;
                document.form1.target='printerIframe';
                document.form1.html.value = printContents;
                document.form1.submit();
            }

            function prevPag(pagina){
                console.log(pagina);
                window.location.href = pagina;
            }

        </script>
    </cfoutput>
</cfif>