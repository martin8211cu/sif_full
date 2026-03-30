<cfif isdefined('form.id_menu') and len(form.id_menu)>
	<cflocation url="SMenu.cfm?id_menu=#form.id_menu#">
</cfif><cf_templateheader title="Mantenimiento de Menú del portal">
<cf_web_portlet_start titulo="Menúes para el portal ASP">
<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top" width="55%">
		<cfquery datasource="asp" name="lista">
			select 	id_menu, 
					
					nombre_menu #_Cat# case when default_menu = 1 then ' <strong style="color:##FF0000">(Menú Público Default)</strong>' else '' end as nombre_menu, 
					orden_menu, 
					case when ocultar_menu=1 then 'X' else ' ' end as ocultar_x,
					case when publico_menu=1 then 'X' else ' ' end as publico_x
			from SMenu
			where 1=1
			<cfif IsDefined('filtro_nombre_menu') and Len(Trim(filtro_nombre_menu))>
			  and upper(nombre_menu) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCASE(Trim(filtro_nombre_menu))#%">
			</cfif>
			<cfif IsDefined('filtro_orden_menu') and Len(Trim(filtro_orden_menu))>
			  and orden_menu >= <cfqueryparam cfsqltype="cf_sql_integer" value="#filtro_orden_menu#">
			</cfif>
			<cfif IsDefined('filtro_ocultar_x') and UCase(filtro_ocultar_x) IS 'X'>
			  and ocultar_menu = 1
			</cfif>
			order by orden_menu, nombre_menu
		</cfquery>
		
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="nombre_menu,orden_menu,ocultar_x,publico_x"
			etiquetas="Menu,Posición,Ocultar,Público"
			formatos="S,S,S,S"
			keys="id_menu"
			mostrar_filtro="yes"
			form_method="get"
			align="left,right,center,center"
			ira="SMenu.cfm"
		/>		
	</td>
    <td valign="top" align="center">
		<cfinclude template="SMenu-form.cfm">
	</td>
  </tr>
</table>
<cf_web_portlet_end><cf_templatefooter>