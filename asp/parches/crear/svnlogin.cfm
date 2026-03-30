<cf_templateheader title="Creación de Parches">
<cfinclude template="mapa.cfm">
<h1>Usuario subversion</h1>
<cfoutput>
  <cfform title="Crear nuevo parche" id="form1" name="form1" method="post" 
	height="250" timeout="60" width="700"
	action="#URLSessionFormat('svnlogin-control.cfm')#" format="#session.parche.form_format#">
	<cf_web_portlet_start titulo="Indique los parámetros de conexión con el servicio de Subversion" width="700">
    <cfformgroup type="panel" label="Indique los parámetros de conexión con el servicio de Subversion">
	<table>
	<tr style="color:##FF0000;font-weight:bold">
		<cfformitem type="text" style="color:##FF0000;font-weight:bold">
			<cfparam name="url.msg" default="">
			<cfif url.msg EQ '1'>No se puede acceder al servicio de subversion. #session.parche.msg#</cfif>
		</cfformitem>
	</tr>
	<tr><td><label for="reposURL">Repositorio de fuentes</label></td><td>
    <cfinput label="Repositorio de fuentes" name="reposURL" type="text" id="reposURL" value="#session.parche.reposURL#" size="50"  readonly="true" />
	</td></tr>
	<tr><td><label for="svnBranch">Branch</label></td><td>
    <cfinput label="Branch" name="svnBranch" type="text" id="svnBranch" value="#session.parche.svnBranch#" size="50"  readonly="true" />
	</td></tr>
	<tr><td><label for="svnuser">Usuario para subversion</label></td><td>
    <cfinput label="Usuario para subversion" name="svnuser" type="text" id="svnuser" value="#session.parche.svnuser#" size="50"  />
	</td></tr>
	<tr><td><label for="svnpasswd">Contraseña</label></td><td>
    <cfinput label="Contraseña" name="svnpasswd" type="password" id="svnpasswd" value="" size="50"  />
	</td></tr>
	<tr><td colspan="2">
    <cfinput type="submit" name="Submit" value="Continuar" class="btnSiguiente" />
    </td></tr>
	
<cfif ArrayLen(session.parche.errores)>
<tr>    <td colspan="2">
	<cfinclude template="lista-errores.cfm"/></td></tr>
</cfif>

	</table></cfformgroup><cf_web_portlet_end>
  </cfform>
</cfoutput><cf_templatefooter>
