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
		join AnexoPermisoDef pd
			on (pd.GAid = a.GAid or pd.AnexoId = a.AnexoId)
			and pd.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			and pd.APver = 1
		join AnexoEm ae
			on ae.AnexoId = a.AnexoId
			and ae.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	where ag.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	group by ag.GAid, ag.GAcodigo, ag.GAnombre, ag.GApadre, ag.GAruta, ag.GAprofundidad
	order by ag.GAruta
</cfquery>

<cfquery name="rsAnexo" datasource="#session.dsn#">
	select a.AnexoDes, a.AnexoId, a.GAid
	from Anexo a
		join AnexoPermisoDef pd
			on (pd.GAid = a.GAid or pd.AnexoId = a.AnexoId)
			and pd.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			and pd.APver = 1
		join AnexoEm ae
			on ae.AnexoId = a.AnexoId
			and ae.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfif isdefined("LvarInfo")>
	<cfset LvarInd = 'index_INFO.cfm'>
<cfelse>
	<cfset LvarInd = 'index.cfm'>
</cfif>
<table width="200"  border="0" cellspacing="0" cellpadding="0">
<tr>
    <td>
			<script language="javascript">
				<!--//
				var LimgRoot = "/cfmx/sif/js/xtree/images/foldericon.png";
				var LimgFolderClose = "/cfmx/sif/js/xtree/images/foldericon.png"; 
				var LimgFolderOpen = "/cfmx/sif/js/xtree/images/openfoldericon.png"; 
				var LimgFile = "/cfmx/sif/js/xtree/images/file.png"; 
				var tree = new WebFXTree("<strong><cfoutput>#LB_Grupos#</cfoutput></strong>", "");
				var padres = "";
				tree.setBehavior('classic');
				tree.icon = LimgFolderClose;
				tree.openIcon = LimgFolderOpen;	
				<cfif (rsArbol.RecordCount NEQ 0) And (rsAnexo.RecordCount NEQ 0)>
					<cfoutput query="rsArbol">
						var Lvartreeitem#rsArbol.GAid# = new WebFXTreeItem("#rsArbol.GAcodigo# - #rsArbol.GAnombre# (#rsArbol.cant_hijos#)", "#LvarInd#?GAid=#rsArbol.GAid#",
							<cfif len(rsArbol.GApadre)>Lvartreeitem#rsArbol.GApadre#<cfelse>tree</cfif>,LimgFolderClose,LimgFolderOpen)
					</cfoutput>
					<cfoutput query="rsAnexo">
						new WebFXTreeItem("#JSStringFormat(AnexoDes)#", "#LvarInd#?AnexoId=#rsAnexo.AnexoId#&GAid=#rsAnexo.GAid#",
							<cfif len(rsArbol.GAid)>Lvartreeitem#rsAnexo.GAid#<cfelse>tree</cfif>,LimgFile,LimgFolderOpen)
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

