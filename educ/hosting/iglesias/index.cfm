<style type="text/css">
<!--
.style7 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; color: ##FFFFFF; }
.style8 {color: ##FFFFFF}
-->
</style>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
Administraci&oacute;n de iglesias
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">

<script language="JavaScript">
<!--
function Empresa(empresa) {
	document.pEmpresas2a.Ecodigo.value = empresa;
	document.pEmpresas2a.submit();
}
//-->
</script>

 <cf_templatecss>
 <cfoutput>
  <form name="pEmpresas2a" method="post" action="/cfmx/hosting/iglesias/index.cfm" style="margin:0">
     <table width="100%" border="0">
              <tr>
                  <td valign="top">
                    <span class="style7">
<input type="hidden" name="Ecodigo" value="">
Est&aacute; administrando la iglesia: </span></td>
                  <td bgcolor="##FFFFFF"> 
  <cfloop query="rsEmpresas2"> 
	<cfif (isDefined("Session.Ecodigo") AND rsEmpresas2.Ecodigo EQ Session.Ecodigo)>
	  <span style="color:##family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; color: ##">#rsEmpresas2.Edescripcion#
	  </span>
	</cfif>
  </cfloop> </td>
              </tr>
              <tr>
                <td colspan="2"><span class="style8"></span></td>
              </tr>
              <tr>
                <td colspan="2"> 
                  <cfif rsEmpresas2.RecordCount GT 1>
                    <span class="style7"> Usted tambi&eacute;n figura como administrador de otras iglesias. Para trabajar con una de ellas, seleccione su nombre:<br>
                    </span>
                    <ul class="style7">
      <cfloop query="rsEmpresas2">
        <cfif rsEmpresas2.Ecodigo NEQ Session.Ecodigo>
          <li><a href="##" onClick="javascript: Empresa(#rsEmpresas2.Ecodigo#)" style="text-decoration:underline "> #rsEmpresas2.Edescripcion# </a> </li>
        </cfif>
      </cfloop>
    </ul>
                  </cfif> </td>
              </tr>
</table>
  </form>
</cfoutput>
</cf_templatearea>
</cf_template>
