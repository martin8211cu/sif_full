<cfparam name="session.usucodigo" default="0">
<style type="text/css">
td,*,p,a {font-size:12px;font-family:Verdana, Arial, Helvetica, sans-serif }

table.navbar {background-color:#666666;margin-bottom:4px;}
table.navbar * *{color:#ffffff; text-decoration:none;}

th, th a{background-color:#4444cc;color:white;font-weight:bold; text-align:left}
.mf{background-color:#ccddff;color:black;font-weight:normal}

</style>
<cfoutput>
<table cellpadding="4" class="navbar"><tr>
<td nowrap>
<cfif session.Usucodigo NEQ 0>
<a href="test-logout.cfm"  >logout #session.usuario# (#session.Usucodigo#)</a>
<cfelse>
<a href="test-login.cfm"  >Login</a>
</cfif>
</td>
<td nowrap>|</td>
<td nowrap><a href="test-add.cfm"  >Agregar usuario</a></td>
<td nowrap>|</td>
<td nowrap><a href="test-auth.cfm" >Autenticar usuario</a></td>
<td nowrap>|</td>
<td nowrap><a href="test-rename.cfm" >Renombrar usuario</a></td>
<td nowrap>|</td>
<td nowrap><a href="test-recordar.cfm" >Recordar contrase&ntilde;a </a></td>
<td nowrap>|</td>
<td nowrap><a href="test-mailbody.cfm" >Ver correo</a></td>
<td nowrap>|</td>
<td nowrap><a href="test-listuser.cfm" >Ver usuarios </a></td>
<td nowrap>|</td>
<td nowrap><a href="test-session.cfm" >Ver sesi&oacute;n </a></td>
</tr></table>
</cfoutput>
<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
</cfinvoke>