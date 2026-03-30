<cfquery name="rsEmpresas" datasource="#Session.DSN#">
SELECT * FROM Empresas 
</cfquery>
<cfquery name="rsDefEmpresas" datasource="#Session.DSN#">
SELECT min(Ecodigo) as minimo FROM Empresas 
</cfquery>

<cfif isdefined("Form.Ecodigo")>
	<cfset Session.Ecodigo = Form.Ecodigo>
<cfelse>
	<cfif isdefined("Session.Ecodigo")>
		<cfset Session.Ecodigo = Session.Ecodigo>
	<cfelse>
		<cfset Session.Ecodigo=rsDefEmpresas.minimo>
	</cfif>
</cfif>
<cfquery name="rsSeleccionada" dbtype="query">
	select * from rsEmpresas where Ecodigo = #session.Ecodigo#
</cfquery>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

<script language="JavaScript">
<!--
function Empresa(empresa) {
	document.pEmpresas.Ecodigo.value = empresa;
	document.pEmpresas.submit();
}
//-->
</script>


<cf_templatecss>
<div id="Layer1" style="width:198px; height:109px; z-index:1"> 
  <form name="pEmpresas" method="post" action="/cfmx/sif/<cfif isdefined("Session.modulo") and Session.modulo neq "index"><cfoutput>#lcase(session.modulo)#/Menu#session.modulo#</cfoutput><cfelse>#Session.modulo#</cfif>.cfm">
    <table width="34%" border="0" cellspacing="0" cellpadding="0">
      <tr> 
        <td width="11%" class="Titulo"><img src="/cfmx/rh/imagenes/sp.gif"></td>
        <td width="3%" class="Titulo" >&nbsp;</td>
        <td width="79%" class="Titulo">Empresas</td>
        <td width="7%" class="Titulo" valign="top"><img src="/cfmx/rh/imagenes/rt.gif"></td>
      </tr>
      <tr> 
        <td  colspan="4" class="contenido-lrborder"> <div align="center">
            <p><img src="/cfmx/rh/imagenes/<cfif isDefined("form.Ecodigo")><cfoutput>#form.Ecodigo#</cfoutput><cfelseif isdefined("Session.Ecodigo")><cfoutput>#Session.Ecodigo#</cfoutput><cfelse><cfoutput query="rsDefEmpresas">#minimo#</cfoutput></cfif>.gif" name="Logo" width="90" height="60" alt="<cfoutput>#rsSeleccionada.Edescripcion#</cfoutput>"></p>
          </div></td>
      </tr>
      <cfoutput query="rsEmpresas">
        <tr> 
          <td class="contenido-lborder"><div align="center"><img src="/cfmx/rh/imagenes/arrow.right.png" width="3" height="6"></div></td>
          <td colspan="2" nowrap> 
            <a href="javascript:Empresa(#Ecodigo#)" onclick=""><font size="-2" face="Verdana, Arial, Helvetica, sans-serif"><cfif #rsEmpresas.Ecodigo# EQ #Session.Ecodigo#><b>#rsEmpresas.Edescripcion#</b><cfelse>#rsEmpresas.Edescripcion#</cfif></font></a></td>
          <td class="contenido-rborder">&nbsp;</td>
        </tr>
      </cfoutput> 
      <tr> 
        <td height="2" colspan="4" class="contenido-lbrborder">&nbsp;</td>
      </tr>
    </table>
  <input type="hidden" name="Ecodigo">
  </form>
</div>
