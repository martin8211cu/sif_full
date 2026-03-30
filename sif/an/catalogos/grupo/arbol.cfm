<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Grupos" 	default="Grupos de Anexos" 
returnvariable="LB_Grupos" xmlfile="arbol.xml"/>
<link href="/cfmx/asp/portal/catalogos/xtree/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="/cfmx/asp/portal/catalogos/xtree/xtree.js"></script>
<cfif isdefined("rsAnexoGrupo")>
	<cfquery name="rsArbol" dbtype="query">
		select GAid, GAcodigo, GAnombre, GAdescripcion, GApadre, GAruta, GAprofundidad, ts_rversion
		from rsAnexoGrupo
		order by GAruta
	</cfquery>
<cfelse>
	<cfquery name="rsArbol" datasource="#session.dsn#">
		select GAid, GAcodigo, GAnombre, GAdescripcion, GApadre, GAruta, GAprofundidad, ts_rversion
		from AnexoGrupo
		order by GAruta
	</cfquery>
</cfif>
<table width="200"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
			<script language="javascript">
				<!--//
				var LvarExpand = null;
				var LimgRoot = "/cfmx/asp/portal/catalogos/xtree/images/blank.png";
				var LimgFolderClose = "/cfmx/asp/portal/catalogos/iconos/folder_cls.gif"; 
				var LimgFolderOpen = "/cfmx/asp/portal/catalogos/iconos/folder_opn.gif"; 
				var tree = new WebFXTree("<strong><cfoutput>#LB_Grupos#</cfoutput></strong>", "");
				var selected = null;
				var padres = "";
				tree.setBehavior('classic');
				tree.icon = LimgRoot;
				tree.openIcon = LimgRoot;	
				<cfif rsArbol.recordcount>
					<cfoutput query="rsArbol">
						var Lvartreeitem#rsArbol.GAid# = new WebFXTreeItem("#RepeatString(' ',10-len(rsArbol.GAcodigo))##rsArbol.GAcodigo# - #rsArbol.GAnombre#", "index.cfm?GAid=#rsArbol.GAid#",<cfif len(rsArbol.GApadre)>Lvartreeitem#rsArbol.GApadre#<cfelse>tree</cfif>,LimgFolderClose,LimgFolderOpen)
					</cfoutput>
				<cfelse>
					var Lvartreeitem = new WebFXTreeItem("No existen grupos definidos.", "",tree,LimgFolderClose,LimgFolderOpen)
				</cfif>
				document.write(tree);
				//-->
			</script>
		</td>
  </tr>
</table>