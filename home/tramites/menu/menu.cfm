<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfobject name="tramites" component="home.tramites.componentes.tramites">
<cfif isdefined("session.tramites.id_funcionario") and len(session.tramites.id_funcionario)>
	<cfset lvar_funcionario = session.tramites.id_funcionario >
<cfelse>
	<cfinclude template="../Operacion/portlet/ventanilla_sql.cfm">
	<cfset lvar_funcionario = session.tramites.id_funcionario >
</cfif>
<cfquery datasource="#session.tramites.dsn#" name="lista">
	select a.id_vista,
		   a.id_tipo,
		   a.nombre_vista,
		   a.titulo_vista, 
		   d.es_documento, 
		   a.es_masivo, 
		   a.es_individual,
		   e.id_documento

	from DDVista a
		inner join DDTipo d on d.id_tipo = a.id_tipo

		join TPDocumento e 
		  on e.id_tipo = a.id_tipo

	where a.es_interna = 0
	  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between a.vigente_desde and a.vigente_hasta 
	order by a.titulo_vista
</cfquery>

<cfquery dbtype="query" name="list_ind">
	select * from lista where es_individual = 1
</cfquery>

<cfquery dbtype="query" name="list_mas">
	select * from lista where es_masivo = 1
</cfquery>
<!---
<cfquery name="rsCatalogos" datasource="#session.tramites.dsn#">
	select a.id_vista, a.id_tipo, a.nombre_vista, a.titulo_vista
	from DDVista a
		inner join DDTipo b
			on b.id_tipo = a.id_tipo
			and b.es_documento = 0
			and b.clase_tipo = 'C'
	where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between a.vigente_desde and a.vigente_hasta
	order by a.nombre_vista
</cfquery>
--->
<cfquery name="rsAdmim" datasource="#session.tramites.dsn#">
	select 1 
	from TPFuncionario
	where id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" 
		value="#lvar_funcionario#" null="#Len(lvar_funcionario) EQ 0#">
	  and es_admin = 1
</cfquery>
<!---
<SCRIPT language="javascript">
<!--
function doLogin() {
	document.forms.Userpasshidden.user.value = doEncode('user');
	document.forms.Userpasshidden.pass.value = doEncode('pass');
	document.forms.Userpasshidden.submit();
}

function doEncode(val) {
	var thex = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F");
	var encStr = "";
	for (var i = 0 ; i < val.length ; i++) {
	var unicodeval = val.charCodeAt(i);
	encStr += thex[unicodeval >> 12] + thex[(unicodeval >> 8) & 15] + thex[(unicodeval >> 4) & 15] + thex[unicodeval & 15];
	}
   return encStr;
}
//-->
</SCRIPT>
--->
<table width="162" border="0" cellspacing="2" cellpadding="0" style="border-top-color:#000066 ">
	<cfif list_ind.RecordCount>
        <cfset NoTieneNingunPermiso = true>
		<cfset NoTieneTitulo = true>
		<cfoutput query="list_ind"> 
		  <cfif (len(id_documento) and len(lvar_funcionario) and tramites.permisos_obj(lvar_funcionario,id_documento,'D'))>
		  <cfset NoTieneNingunPermiso = false>
		  <cfif NoTieneTitulo>
		  	<tr>
				<td colspan="2" class="tituloListas"><strong>Documentos</strong></td>
			</tr>
			<cfset NoTieneTitulo=false>
		  </cfif>
		  <tr>
		  	<td width="18"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" width="15" height="15"></td>
            <td width="138"><a href="/cfmx/home/tramites/vistas/index-ind-list.cfm?id_vista=#id_vista#&amp;id_tipo=#id_tipo#">#HTMLEditFormat(titulo_vista)#</a></td>
          </tr>
		  </cfif>
        </cfoutput>
	</cfif>
	<cfif list_mas.RecordCount>
		<cfset NoTieneNingunPermiso = true>
		<cfset NoTieneTituloMasivo = true>
        <cfoutput query="list_mas"> 		
          <cfif (len(id_documento) and len(lvar_funcionario) and tramites.permisos_obj(lvar_funcionario,id_documento,'D'))>
		  <cfset NoTieneNingunPermiso = false>
		  <cfif NoTieneTituloMasivo>
			<tr>
				<td colspan="2" class="tituloListas"><strong>Documentos Masivos</strong></td>
			</tr>
			<cfset NoTieneTituloMasivo = false>
		  </cfif>
		  <tr>
		  	<td valign="top"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" width="15" height="15"></td>
            <td valign="top">
			<a href="/cfmx/home/tramites/vistas/vistas.cfm?id_vista=#id_vista#&amp;id_tipo=#id_tipo#">
			#HTMLEditFormat(titulo_vista)#</a></td>
          </tr>
		  </cfif>
        </cfoutput>
	</cfif>
	<tr>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
  	</tr>
	<tr>
	  <td colspan="2" class='TituloListas'><strong>Mi Perfil</strong></td>
	</tr>
	<tr>
	  <td valign="top"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" width="15" height="15"></td>
	  <td valign="top"><a href="/cfmx/home/tramites/Consultas/funcionarios-perfil.cfm">Funcionario</a></td>
  	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
  	</tr>
	<!---
	<cfif rsCatalogos.RecordCount>
	<tr>
	  <td colspan="2" class='TituloListas'><strong>Cat&aacute;logos</strong></td>
  </tr>
  </cfif>
	<cfloop query="rsCatalogos">
	<tr>
		<td valign="top"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" width="15" height="15"></td>
		<td valign="top">
			<cfif acceso_uri("/home/tramites/vistas/catalogo.cfm")>
				<cfoutput><a href="/cfmx/home/tramites/vistas/catalogo.cfm?id_vista=#rsCatalogos.id_vista#&id_tipo=#rsCatalogos.id_tipo#&btnNuevo=1">#rsCatalogos.titulo_vista#</a><br>
				</cfoutput>
			</cfif>
	  </td>
	 </tr>
	</cfloop>
	<tr>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
  </tr>
  --->
  <cfif rsAdmim.recordcount>
  <tr>
	  <td colspan="2" class='TituloListas'><strong>Administraci&oacute;n</strong></td>
  </tr>
	<tr>
	  <td valign="top"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" width="15" height="15"></td>
	  <td valign="top"><a href="/cfmx/home/tramites/Catalogos/instituciones-lista.cfm">Instituciones</a></td>
  </tr>
  <td valign="top"></tr>
	<tr>
	  <td valign="top"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" width="15" height="15"></td>
	  <td valign="top"><a href="/cfmx/home/tramites/Catalogos/tramitesList.cfm">Tr&aacute;mites</a></td>
  </tr>
	<tr>
	  <td valign="top"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" width="15" height="15"></td>
	  <td valign="top"><a href="/cfmx/home/tramites/Catalogos/Tp_RequisitosList.cfm">Requisitos</a></td>
  </tr>
  <tr>
	  <td valign="top"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" width="15" height="15"></td>
	  <td valign="top"><a href="/cfmx/home/tramites/Catalogos/tipo/DiccDato.cfm">Diccionario de Datos</a></td>
  </tr>
   <tr>
	  <td valign="top"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" width="15" height="15"></td>
	  <td valign="top"><a href="/cfmx/home/tramites/Catalogos/vista/listaVista.cfm">Vistas</a></td>
  </tr>
  
   <tr>
	  <td valign="top"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" width="15" height="15"></td>
	  <td valign="top"><a href="/cfmx/home/tramites/Catalogos/Tp_DocumentosList.cfm">Documentos</a></td>
  </tr>


     <tr>
	  <td valign="top"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" width="15" height="15"></td>
	  <td valign="top"><a href="javascript:void(0)">Cierre de Ventanilla (en proceso)</a></td>
  </tr>

     <tr>
	  <td valign="top"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" width="15" height="15"></td>
	  <td valign="top"><a href="/cfmx/home/tramites/Operacion/cierre/listado.cfm">Cierre de Tr&aacute;mites</a></td>
  </tr>

     <tr>
	  <td valign="top"><img src="/cfmx/sif/imagenes/16x16_flecha_right.gif" width="15" height="15"></td>
	  <td valign="top"><a href="http://bo.soin.net/apps/jsp/UPHome.jsp">An&aacute;lisis de informaci&oacute;n</a></td>
  </tr>
  </cfif>
</table>
<!---
<form method="POST" name="Userpasshidden" onsubmit='return true' action="http://10.7.7.13/apps/scripts/login/login.jsp"  style="margin:0">
<input type=hidden name=UTCOffset value="-360">
<input type=hidden name=user value="">
<input type=hidden name=pass value="">
</form>

--->