<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Grupos" 	default="Grupos de Anexos" 
returnvariable="LB_Grupos" xmlfile="arbol.xml"/>
<link href="/cfmx/sif/js/xtree/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="/cfmx/sif/js/xtree/xtree.js"></script>

<cfquery name="rsArbol" datasource="#session.dsn#">
	select ag.GAid, ag.GAcodigo, ag.GAnombre, ag.GApadre, ag.GAruta, ag.GAprofundidad
		,count(distinct a.AnexoId) as cant_hijos
	from AnexoGrupo ag
		join AnexoGrupoCubo cubo
			on ag.GAid = cubo.GApadre
		join Anexo a
			on a.GAid = cubo.GAhijo
			and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		join AnexoEm ae
			on ae.AnexoId = a.AnexoId
			and ae.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		join AnexoPermisoDef pd
			on (pd.GAid = a.GAid or pd.AnexoId = a.AnexoId)
			and pd.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			and pd.APcalc = 1
	where ag.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	group by ag.GAid, ag.GAcodigo, ag.GAnombre, ag.GApadre, ag.GAruta, ag.GAprofundidad
	order by ag.GAruta
</cfquery>

<table width="200"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
			<script language="javascript">
				<!--//
				var LimgRoot = "/cfmx/sif/js/xtree/images/blank.png";
				var LimgFolderClose = "/cfmx/sif/js/xtree/images/foldericon.png"; 
				var LimgFolderOpen = "/cfmx/sif/js/xtree/images/openfoldericon.png"; 
				var LimgFile = "/cfmx/sif/js/xtree/images/file.png"; 
				var tree = new WebFXTree("<strong><cfoutput>#LB_Grupos#</cfoutput></strong>", "");
				var padres = "";
				tree.setBehavior('classic');
				tree.icon = LimgFolderClose;
				tree.openIcon = LimgFolderOpen;	
				<cfif rsArbol.recordcount>
					<cfoutput query="rsArbol">
						var Lvartreeitem#rsArbol.GAid# = new WebFXTreeItem("#RepeatString(' ',10-len(rsArbol.GAcodigo))##rsArbol.GAcodigo# - #rsArbol.GAnombre# (#rsArbol.cant_hijos#)", "index.cfm?GAid=#rsArbol.GAid#",<cfif len(rsArbol.GApadre)>Lvartreeitem#rsArbol.GApadre#<cfelse>tree</cfif>,LimgFolderClose,LimgFolderOpen)
					</cfoutput>
				<cfelse>
					var Lvartreeitem = new WebFXTreeItem("No existen anexos definidos o no tiene permisos.", "",tree,LimgFolderClose,LimgFolderOpen)
				</cfif>
				document.write(tree);
				tree.expand();
				//-->
			</script>
		</td>
  </tr>
</table>