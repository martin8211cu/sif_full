<cfparam name="Attributes.Titulo" 			default="" 		type="String">
<cfparam name="Attributes.name" 			default="" 		type="String">
<cfparam name="Attributes.mostrarSubHeader" default="true" 	type="boolean">
<cfparam name="Attributes.width" 			default="500px" type="string">
<cfparam name="Attributes.align" 			default="left" 	type="String">
<cfif ThisTag.ExecutionMode is 'start'>
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.js"><\/script>');
	</script>
	<script language="javascript" type="text/javascript">
		$(document).ready(function() {
			/*Funcion para que el Porlet se contraiga y se expanda*/					   
			$("#Portlet-<cfoutput>#Attributes.name#</cfoutput>").click(function(){	
				$("#Portlet-content-<cfoutput>#Attributes.name#</cfoutput>").fadeToggle("normal", "linear");;
				$(this).toggleClass("active");
			});	
		});		
	</script>
	
    <table width="<cfoutput>#Attributes.width#</cfoutput>" align="<cfoutput>#Attributes.align#</cfoutput>" cellspacing="0" cellpadding="0" border="0" class="Portlet">
        <tr class="Portlet-header">
            <td align="left" class="Portlet-header-icon-left">&nbsp;</td>
            <td align="center"><cfif Attributes.mostrarSubHeader>&nbsp;<cfelse><cfoutput>#Attributes.Titulo#</cfoutput></cfif></td>
            <td class="Portlet-header-td-right" id="Portlet-<cfoutput>#Attributes.name#</cfoutput>" align="right"><img src="/cfmx/plantillas/Cloud/images/tabla-header-arrow.gif" width="13" height="7" /></td>
        </tr>
        <cfif Attributes.mostrarSubHeader>
        <tr class="Portlet-subheader"> 
           <td colspan="3" align="center"><cfoutput>#Attributes.Titulo#</cfoutput></td>
        </tr>
        </cfif>
        <tr>
            <td colspan="3">
                <div class="Portlet-content" id="Portlet-content-<cfoutput>#Attributes.name#</cfoutput>">
</cfif>
                
<cfif ThisTag.ExecutionMode is 'end'>
            </div>
     	</td>
  	</tr>
    <tr>
    	<td colspan="3" class="Portlet-footer" align="center"></td>
    </td>
</table>
</cfif>