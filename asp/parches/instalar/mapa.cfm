<!--- Para no tener un Application.cfm --->
<cfinvoke component="asp.parches.comp.instala" method="parametros_instalar"/>
<cfscript>
/* igual que en crear/mapa.cfm */
function ispage(pages){
	if (ListFindNoCase(pages, ListFirst( GetFileFromPath(CGI.SCRIPT_NAME), '.'))) {
		return ' cfmenu_sel ';
	} else {
		return ' " onmouseover="this.sc=this.className;this.className=this.sc+&quot; cfmenu_sel&quot;;" onmouseout="this.className=this.sc; ';
	}
}
</cfscript>
<style type="text/css">
	.cfmenu_sel, .cfmenu_sel a {
		background-color:#eeeeee;
		color:#000000;
	}
	.isok {
		background-image:url(../../images/w-check.gif);
		background-repeat:no-repeat;
	}
</style>
<cfoutput>
<div style="float:left">
  <table width="275" border="0" cellpadding="0" cellspacing="0">
    <tr>
      <td width="231" class="cfmenu_titulo"><a>Cargar parche</a></td>
      <td width="44" rowspan="20">&nbsp;</td>
    </tr>
    <tr><cfset isok = IsDefined('session.instala.xxx') and Len(session.instala.xxx)>
      <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('subir')#"><a href="../carga/subir.cfm">Cargar JAR </a></td>
    </tr>
    <tr><cfset isok = IsDefined('session.instala.parche') and Len(session.instala.parche)>
      <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('selecc')#"><a href="../carga/selecc.cfm">Seleccionar parche </a></td>
    </tr>
    <tr><cfset isok = IsDefined('session.instala.parche') and Len(session.instala.parche)>
      <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('retomar')#"><a href="../carga/retomar.cfm">Continuar instalación suspendida</a></td>
    </tr>
    
    <tr><cfset isok = IsDefined('session.instala.xxx') and Len(session.instala.xxx)>
      <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('ver')#"><a href="../carga/ver.cfm">Información del parche </a></td>
    </tr>    
    <tr>
      <td class="cfmenu_titulo"><a>Prerrequisitos</a></td>
    </tr>
    <tr><cfset isok = IsDefined('session.instala.ds') and Len(session.instala.ds)>
      <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('ds')#"><a href="../prerreq/ds.cfm">Seleccionar datasources</a></td>
      </tr>
    <tr>
      <td class="cfmenu_titulo"><a>Ejecutar parche </a></td>
      </tr>
    <tr><cfset isok = IsDefined('session.instala.ejecutado') and Len(session.instala.ejecutado)>
      <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('ejecuta')#"><a href="../ejecuta/ejecuta.cfm">Ejecutar parche</a></td>
      </tr>
    <tr>
      <td class="cfmenu_titulo"><a>Validación</a></td>
      </tr>
    <tr><cfset isok = IsDefined('session.instala.contado2') and Len(session.instala.contado2)>
      <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('contar2')#"><a href="../valida/contar2.cfm">Conteo de datos </a></td>
      </tr>
    <tr><cfset isok = IsDefined('session.instala.xxx') and Len(session.instala.xxx)>
      <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('notifica')#"><a href="../valida/notifica.cfm">Notificar resultado </a></td>
      </tr>
    <tr>
      <td width="231" class="cfmenu_titulo"><a>Herramientas</a></td>
    </tr>
    <tr><cfset isok = IsDefined('session.instala.xxx') and Len(session.instala.xxx)>
      <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('opciones')#"><a href="../herram/opciones.cfm">Opciones </a></td>
    </tr>
    <tr><cfset isok = IsDefined('session.instala.xxx') and Len(session.instala.xxx)>
      <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('parches')#"><a href="../herram/parches.cfm">Parches instalados </a></td>
    </tr>
    <tr>
      <td class="cfmenu_bottom">&nbsp;</td>
    </tr>
  </table>
</div>
<cfif IsDefined('session.instala.nombre')>
<div class="subTitulo">
Usando parche: # HTMLEditFormat( session.instala.nombre ) #
</div></cfif>
</cfoutput>
