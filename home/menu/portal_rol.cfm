<cf_template>
<cf_templatearea name="title">Inicio</cf_templatearea>
<cf_templatearea name="body">

<cfif isdefined("url._nav")>
	<cfset session.menues.id_menu = url.id_menu >
	<cfset session.menues.id_root = url.id_root >

	<cfif isdefined("url.Recordar") AND url.Recordar EQ "1">
		<cfset session.menues.id_default = session.menues.id_root>
		<cfquery datasource="asp">
			update Preferencias
			   set id_root = #session.menues.id_root#
			 where Usucodigo = #session.Usucodigo#
			   and Ecodigo	 = #session.EcodigoSDC#
		</cfquery>
	</cfif>
	<!---<cflocation url="#url.url#">--->

	<cfif isdefined("session.origen") and listcontains(session.origen, 'sistema') >
		<cflocation url="index.cfm">
	<cfelse>
		<cflocation url="portal.cfm">
	</cfif>
</cfif>

<!--- /////////////////// --->
<!--- No pintar navegacion--->
<cfparam name="url._nav" default="1" >
<cfparam name="url.root" default="1" >
<!--- /////////////////// --->
<cfinclude template="portal_control.cfm">

<table width="955"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="162">&nbsp;</td>
    <td width="631">&nbsp;</td>
    <td width="162">&nbsp;</td>
    </tr>
  <tr>
    <td valign="top">
	
	
<cf_web_portlet titulo="Agenda" skin="portlet" width="164">
<form action="portlets/agenda/agenda.cfm" name="calform">
<!--- onChange="document.calform.submit()" --->
<cf_calendario form="calform" includeForm="no" name="fecha" fontSize="10" onChange="document.getElementById('pendientes').src='/cfmx/home/menu/portlets/agenda/lista_hoy-form.cfm?fecha='+escape(dmy)">
</form>
	</cf_web_portlet>
	<br>
	<cf_web_portlet titulo="Pendientes para hoy" skin="portlet" width="164">
		<cfinclude template="portlets/agenda/lista-hoy.cfm">
	</cf_web_portlet>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p></td>

    <td valign="top" align="center">
<style type="text/css">
	.va{ text-decoration:none;
		font-size:12px; 
	}
	.va:hover{ text-decoration:underline;
	font-size:12px;
			 color:#FF0000; } 
</style> 
		<cfoutput>
		<table width="420"  cellpadding="2" cellspacing="0" align="center">
			<TR>
				<TD>
					<cfquery name="rsLista" datasource="asp">
						select m.id_menu, m.id_root, m.nombre_menu, m.orden_menu, m.descripcion_menu, m.ts_rversion
						  from SMenu m
							left join SRolMenu rm
								inner join UsuarioRol ur
									 on ur.Usucodigo 	= #session.Usucodigo#
									and ur.Ecodigo		= #session.EcodigoSDC#
									and ur.SScodigo		= rm.SScodigo
									and ur.SRcodigo		= rm.SRcodigo
								 on rm.id_root = m.id_root
						 where ocultar_menu = 0
						   and (rm.id_root is not null or publico_menu = 1)
						order by orden_menu, m.id_root, nombre_menu
					</cfquery>
			
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr><td colspan="3"><input type="checkbox" name="chkRecordar" id="chkRecordar" value="1">Recordar Rol Seleccionado (Rol Inicial Default)</td></tr>
						<tr><td colspan="3" class="tituloListas"><strong><font size="2">Seleccione el rol con el que desea trabajar:</font></strong></td></tr>
						<cfset LvarId_root = "">
						<cfset LvarIdx = 0>
						<cfloop query="rsLista">
						  <cfif LvarId_root NEQ id_root>
							<cfset LvarId_root = id_root>
							<cfset LvarIdx = LvarIdx + 1>
							<cfif IsDefined('session.menues.id_default') and session.menues.id_default EQ rsLista.id_root>
							  	<cfset style='font-weight:bold;color:##009900'>
								<cfset LvarTipo = " (Rol default)">
							<cfelseif IsDefined('session.menues.id_root') and session.menues.id_root EQ rsLista.id_root>
							  	<cfset style='font-weight:bold;color:##000099'>
								<cfset LvarTipo = " (Rol actual)">
							<cfelse>
							  	<cfset style=''>
								<cfset LvarTipo = "">
							</cfif>
							<tr class="<cfif LvarIdx mod 2>listaNon<cfelse>listaPar</cfif>">
								<td width="12">&nbsp;</td>
							  <td width="12" rowspan="2">
							  	<!---
								<cfinvoke 
									 component="sif.Componentes.DButils"
									 method="toTimeStamp"
									 returnvariable="tsurl"
									 arTimeStamp="#rsLista.ts_rversion#"/> 
								<img src="../../home/public/logo_menurol.cfm?m=#rsLista.id_menu#&amp;ts=#tsurl#" height="32" >
								--->
								<img src="../../home/public/imagen.cfm?f=/home/menu/imagenes/content_arrow.gif" width="12" height="17">
								</td>
								<td><a 	class="va" style="#style#" 
										<!--- href="portal.cfm?_nav=1&amp;id_root=#URLEncodedFormat(rsLista.id_root)#&amp;id_menu=#URLEncodedFormat(rsLista.id_menu)#"
										href="/cfmx/home/menu/empresa.cfm" --->
										href="javascript:sbCambiarRol(#rsLista.id_menu#, #rsLista.id_root#)";
									>
										<cf_TranslateDB VSvalor="#rsLista.id_menu#" VSgrupo="123" Idioma="#session.Idioma#">#HTMLEditFormat(rsLista.nombre_menu)#</cf_TranslateDB> #LvarTipo#</a></td>
							</tr>
							<tr class="<cfif LvarIdx mod 2>listaNon<cfelse>listaPar</cfif>">
							  <td></td>
							  <td>
							  #HTMLEditFormat(rsLista.descripcion_menu)#</td>
						    </tr>
						   </cfif>
						</cfloop>
						<script language="javascript">
							function sbCambiarRol(id_menu,id_root)
							{
								location.href="portal_rol.cfm?_nav=1&recordar=" + (document.getElementById("chkRecordar").checked ? "1" : "0") + "&id_menu=" + id_menu + "&id_root=" + id_root + "&url=#URLencodedFormat(url.url)#";
							}
						</script>
					</table>
				</TD>
			</TR>
		</table>
		</cfoutput>
	</td>


    <td valign="top">&nbsp; </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
</table>


</cf_templatearea>
</cf_template>