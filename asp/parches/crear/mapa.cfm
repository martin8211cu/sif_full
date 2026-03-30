<!--- Para no tener un Application.cfm --->
<cfinvoke component="asp.parches.comp.parche" method="parametros_parche" />
<cfscript>
/* igual que en instalar/mapa.cfm */
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
		background-image:url(../images/w-check.gif);
		background-repeat:no-repeat;
	}
</style>
<cfoutput>
<div style="float:left">
<table width="275" border="0" cellpadding="0" cellspacing="0">
<tr>
    <td class="cfmenu_titulo">
	<a>Administrar parches</a></td>
	      </tr>
      <td class="cfmenu_submenu #ispage('admabrir')#">
	<a href="admabrir.cfm">Trabajar con ...</a>	  </td>
	      </tr><tr>
    <td class="cfmenu_submenu #ispage('admreset')#">
	<a href="<cfif Len(session.parche.guid)>admreset.cfm<cfelse>admreset-control.cfm?ok=1</cfif>">Nuevo parche ... </a></td>
	      </tr><tr>
    <td class="cfmenu_submenu #ispage('admguardar')#">
	<a href="admguardar.cfm">Nombre del Parche</a></td>
	      </tr>
  <tr>
    <td width="231" class="cfmenu_titulo">
	  <a>Construcción del parche</a></td>
	  <td width="44" rowspan="19">&nbsp;</td>
    </tr>
  <tr><cfset isok = Len(session.parche.svnuser)>
    <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('svnlogin')#" >
	<a href="svnlogin.cfm">Usuario Subversion </a></td>
    </tr>
  <tr><cfset isok = session.parche.cant_fuentes NEQ 0>
    <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('svnconfirmar,svnbuscar')#" >
	<a href="<cfif isok>svnconfirmar.cfm<cfelse>svnbuscar.cfm</cfif>">Archivos <cfif isok>(#session.parche.cant_fuentes#)</cfif></a></td>
    </tr>

  <!----*****************************************---->

	<tr>
  		<cfset isok = session.parche.cant_dbm NEQ 0>
		    <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('dbmbuscar')#" >
			<a href="dbmbuscar.cfm">Versiones DBModel <cfif isok>(#session.parche.cant_dbm#)</cfif></a></td>
	</tr>

  <!----*****************************************---->

  <tr><cfset isok = session.parche.cant_menus NEQ 0>
    <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('menubuscar-a')#" >
	<a href="menubuscar-a.cfm">Opciones de Menú <cfif isok>(#session.parche.cant_menus#)</cfif></a></td>
    </tr>

  <!----*****************************************---->		
  <tr><cfset isok = session.parche.cant_sql NEQ 0>
    <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('sqlbuscar')#" >
	<a href="sqlbuscar.cfm">Instrucciones sql<cfif isok>(#session.parche.cant_sql#)</cfif></a></td>
    </tr>
  <tr><cfset isok = session.parche.cant_seg NEQ 0>
    <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('segconfirmar,segbuscar')#" >
	<a href="<cfif isok>segconfirmar.cfm<cfelse>segbuscar.cfm</cfif>">Definición de la seguridad <cfif isok>(#session.parche.cant_seg#)</cfif></a></td>
    </tr>
  <tr><cfset isok = StructCount(session.parche.tabla) NEQ 0 OR StructCount(session.parche.procedimiento) NEQ 0>
    <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('objconfirmar,objbuscar')#" >
	<a href="<cfif isok>objconfirmar.cfm<cfelse>objbuscar.cfm</cfif>">Tablas por validar
    <cfif isok>
      (#StructCount(session.parche.tabla)#)
    </cfif>
    </a></td>
    </tr>
  <tr><cfset isok = StructCount(session.parche.importar)>
    <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('impbuscar')#" >
	<a href="impbuscar.cfm">Definiciones del importador <cfif isok>(#StructCount(session.parche.importar)#)</cfif></a></td>
    </tr><tr><cfset isok = session.parche.generado>
    <td class="cfmenu_submenu <cfif isok>isok</cfif> #ispage('generar,generado')#" >
	<a href="generar.cfm">Generar el parche</a>	  </td>    </tr><tr>
    <td class="cfmenu_titulo">
	<a>Seleccionar formato</a>
	  <cfif IsDefined('url.ff') And ListFind('flash,html', url.ff)>
	    <cfset session.parche.form_format=url.ff>
      </cfif>	</td>
	      </tr><tr>
    <td class="cfmenu_submenu">
		<a href="?ff=flash" style="<cfif session.parche.form_format is 'flash'>font-weight:bold</cfif>">flash</a>
		|
	  <a href="?ff=html" style="<cfif session.parche.form_format is 'html'>font-weight:bold</cfif>">html</a>	  </td>    </tr>
  <tr>
    <td class="cfmenu_bottom">&nbsp;</td>
    </tr>
  <tr>
    <td height="360">&nbsp;</td>
    </tr>
</table>
</div><div class="subTitulo">
<cfif IsDefined('session.parche.info.nombre') and Len(session.parche.info.nombre)>
Usando parche: # HTMLEditFormat( session.parche.info.nombre ) #
<cfelseif IsDefined('session.parche.guid') and Len(session.parche.guid)>
Parche # HTMLEditFormat( session.parche.guid ) #
<cfelse>
Parche sin título.
</cfif>
</div>
</cfoutput>