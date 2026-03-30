<cf_templateheader title="Generaci&oacute;n de Programas Autom&aacute;ticos">
<cfinclude template="env.cfm">
<cfparam name="url.Diagram" default="">
<cfparam name="url.code"    default="">
<cfoutput>

<cfhtmlhead text='<link href="gen.css" rel="stylesheet" type="text/css" >'>
<cfinclude template="/home/menu/pNavegacion.cfm">

<table width="100%" border="1" cellpadding="4">
  <tr> 
    <td colspan="3" valign="top" style="border:solid 1px darkblue;background-color:skyblue">
		<cfinclude template="pdm.list.cfm" /></td>
  </tr>
  <tr> 
    <td valign="top"><cfinclude template="diagrams.cfm" /></td>
    <td valign="top"><iframe marginheight="0" frameborder="1" name="gen" src="about:blank<!---<cfif Len(url.code)>tablamd.cfm?code=#url.code#</cfif>--->" width="300px" height="600px">[ Area de trabajo ]</iframe></td>
  </tr>
</table>

</cfoutput><cf_templatefooter>