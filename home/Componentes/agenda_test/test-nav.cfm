
<cfparam name="session.usucodigo" default="0">
<style type="text/css">
td,*,p,a {font-size:12px;font-family:Verdana, Arial, Helvetica, sans-serif; }

table.navbar {background-color:#666666;margin-bottom:4px;}
table.navbar * *,a.navbar{color:#ffffff; text-decoration:none;}

th, th a{background-color:#4444cc;color:white;font-weight:bold; text-align:left}
.mf{background-color:#ccddff;color:black;font-weight:normal}

</style>
<cfoutput>
  <table cellpadding="4" class="navbar">
    <tr>
      <td nowrap><strong>Agenda </strong></td>
      <td nowrap><a href="test-CrearAgenda.cfm"  class="navbar" >Crear agenda</a></td>
      <td nowrap>|</td>
      <td nowrap><a href="test-EstablecerHorario.cfm" class="navbar" >EstablecerHorario</a></td>
      <td nowrap>|</td>
      <td nowrap><a href="test-Renombrar.cfm" class="navbar" >Renombrar</a></td>
      <td nowrap>|</td>
      <td nowrap><a href="test-VerAgenda.cfm" class="navbar" >ListarAgendas</a></td>
      <td nowrap>|</td>
      <td nowrap><a href="test-session.cfm" class="navbar" ><strong>Ver sesi&oacute;n </strong></a></td>
      <td nowrap>&nbsp;</td>
      <td nowrap>&nbsp;</td>
    </tr>
    <tr>
      <td nowrap><strong>Permisos</strong></td>
      <td nowrap><a href="test-ListarPermisos.cfm" class="navbar" >ListarPermisos</a></td>
      <td nowrap>|</td>
      <td nowrap><a href="test-RevocarPermiso.cfm" class="navbar" >RevocarPermiso</a></td>
      <td nowrap>|</td>
      <td nowrap><a href="test-OtorgarPermiso.cfm" class="navbar" >OtorgarPermiso</a></td>
      <td nowrap>&nbsp;</td>
      <td nowrap>&nbsp;</td>
      <td nowrap>&nbsp;</td>
      <td nowrap>&nbsp;</td>
      <td nowrap>&nbsp;</td>
      <td nowrap>&nbsp;</td>
    </tr>
    <tr>
      <td nowrap><strong>Citas</strong></td>
      <td nowrap><a href="test-LeerAgenda.cfm" class="navbar" >LeerAgenda</a></td>
      <td nowrap>|</td>
      <td nowrap><a href="test-NuevaCita.cfm" class="navbar" >NuevaCita</a></td>
      <td nowrap>|</td>
      <td nowrap><a href="test-TiempoLibre.cfm" class="navbar" >TiempoLibre</a></td>
      <td nowrap>|</td>
      <td nowrap><a href="test-EliminarCita.cfm" class="navbar" >EliminarCita</a></td>
      <td nowrap>|</td>
      <td nowrap><a href="test-ListarCitas.cfm" class="navbar" >ListarCitas</a></td>
      <td nowrap>&nbsp;</td>
      <td nowrap>&nbsp;</td>
    </tr>
  </table>
  </cfoutput>
<cfset agenda = CreateObject("component", "home.Componentes.Agenda")>
