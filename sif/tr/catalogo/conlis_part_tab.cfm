<cfparam name="url.ActivityId" type="numeric">

<script type="text/javascript">
<!--
	function listmov(elem) {
		elem.bg = elem.style.backgroundColor;
		elem.style.backgroundColor='#e4e8f3';
	}
	function listmout(elem) {
		elem.style.backgroundColor = elem.bg;
	}
	function regresar(Type, Name, Description, rol, Usucodigo, CFid, ParticipantId) {
		window.opener.NuevoParticipante(Type, Name, Description, rol, Usucodigo, CFid, ParticipantId);
		window.close();
	}
//-->
</script>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Recientes"
	Default="Recientes"
	returnvariable="LB_Recientes"/>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Usuarios"
	Default="Usuarios"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_Usuarios"/>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	Default="Centro Funcional"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_CentroFuncional"/>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RolSistema"
	Default="Rol del sistema"
	returnvariable="LB_RolSistema"/>
<cfset tabNames = ListToArray('#LB_Recientes#,#LB_Usuarios#,#LB_CentroFuncional#,#LB_RolSistema#')>
<cfset tabLinks = ListToArray('conlis_part_all.cfm,conlis_part_users.cfm,conlis_part_cf.cfm,conlis_part_rol.cfm')>

<table cellpadding="0" cellspacing="2" width="100%"><tr>
  <cfloop from="1" to="#ArrayLen(tabNames)#" index="i">
	<cfoutput>
		<cfset selected = FindNoCase(tabLinks[i], CGI.SCRIPT_NAME)>
	  <td class="<cfif selected>#Session.Preferences.Skin#_tabsel<cfelse>#Session.Preferences.Skin#_tabnorm</cfif>" nowrap>
			<a href="#HTMLEditFormat( tabLinks[i] )#?ActivityId=#HTMLEditFormat(url.ActivityId)#" onMouseOver="javascript: window.status='#tabNames[i]#'; return true;"
			 onMouseOut="javascript: window.status=''; return true;" tabindex="-1">						

			&nbsp;&nbsp;&nbsp;#tabNames[i]#&nbsp;&nbsp;&nbsp;
				</a>
	  </td>
	</cfoutput>
  </cfloop>
</tr></table>