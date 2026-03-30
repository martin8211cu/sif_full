<cfoutput>
<link href="#Session.JSroot#/js/xtree/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="#Session.JSroot#/js/xtree/xtree.js"></script>
</cfoutput>

<script language="JavaScript1.2">
	function ProcesarDatos(root, EScodigo, EScodigoPadre) {
		document.arbol.EScodigo.value = EScodigo;
		document.arbol.EScodigoPadre.value = EScodigoPadre;
		document.arbol.modo.value = "CAMBIO";
		document.arbol.root.value = root;
		
		if (tree.getSelected() != null) {
			s = new String (tree.getSelected().id);
			document.arbol.ItemId.value = s;
		}
		
		document.arbol.submit();
	}
</script>

<cfquery name="rs" datasource="#Session.DSN#">
	select convert(varchar, a.EScodigo) as EScodigo, 
		    b.ETnombre + ':&nbsp;&nbsp;' + a.ESOnombre + 
				case when a.ESOcodificacion is not null then ' (' + a.ESOcodificacion + ') ' end as Organizacion,
		   a.ESOnombre,
		   a.ESOcodificacion, 
		   convert(varchar, a.EScodigoPadre) as EScodigoPadre,
		   a.ESOultimoNivel
	from EstructuraOrganizacional a, EstructuraTipo b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and a.ETcodigo = b.ETcodigo
	order by a.EScodigoPadre, a.ESOcodificacion
</cfquery>

<cfquery name="rsNodoRoot" datasource="#Session.DSN#">
	select convert(varchar, EScodigo) as EScodigo, ESOnombre
	from EstructuraOrganizacional
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and EScodigoPadre is null
</cfquery>

<cfquery name="rsniv1" dbtype="query">
	select * from rs 
	where EScodigoPadre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNodoRoot.EScodigo#">
	order by EScodigoPadre, ESOcodificacion
</cfquery>

<cfquery name="rsnivn" dbtype="query">
	select * from rs 
	where EScodigoPadre is not null
	and EScodigoPadre != <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNodoRoot.EScodigo#">
	order by EScodigoPadre, ESOcodificacion
</cfquery>

<script language="JavaScript" type="text/javascript">

	function buscarUnidad(cod) {
		for (var j=2;j<webFXTreeHandler.idCounter;j++) {
			var texto  = webFXTreeHandler.all['webfx-tree-object-'+j].action;
			if (texto.indexOf("'P-"+cod+"'") != -1) {
				return webFXTreeHandler.all['webfx-tree-object-'+j];
			}
		}
		return null;
	}

	<cfoutput>
	var imgraiz = "#Session.JSroot#/imagenes/estructura/web_users.gif";
	var imgselec = "/cfmx/sif/js/xtree/images/openfoldericon.png";
	var imgnormal = "#Session.JSroot#/imagenes/iconos/leave_wht.gif";
	var imgselec2 = "#Session.JSroot#/imagenes/iconos/leave_sel.gif";
	var tree = new WebFXTree("#rsNodoRoot.ESOnombre#", "javascript:ProcesarDatos(1, '#rsNodoRoot.EScodigo#', '', 'P-#rsNodoRoot.EScodigo#');");
	var selected = null;
	tree.setBehavior('explorer');
	tree.icon = imgraiz;
	tree.openIcon = imgraiz;
	</cfoutput>
	
	<cfoutput>
	<cfloop query="rsniv1">
		var dato0 = new WebFXTreeItem("#Replace(rsniv1.Organizacion,chr(34),'''')#", "javascript:ProcesarDatos(0, '#rsniv1.EScodigo#', '#rsniv1.EScodigoPadre#', 'P-#rsniv1.EScodigo#');");
		<cfif rsniv1.ESOultimoNivel EQ 1>
		dato0.icon = imgnormal;
		dato0.openIcon = imgnormal;
		</cfif>
		
		<cfif isdefined("Form.ItemId") and Form.ItemId NEQ "">
			if ('#Form.ItemId#' == new String (dato0.id)) {
			<cfif rsniv1.ESOultimoNivel EQ 1>
				dato0.icon = imgselec2;
				dato0.openIcon = imgselec2;
			<cfelse>
				dato0.icon = imgselec;
				dato0.openIcon = imgselec;
				selected = dato0;
			</cfif>
			}
		</cfif>
		tree.add(dato0);
	</cfloop>		
	
	<cfloop query="rsnivn">
		var nodo = buscarUnidad("#EScodigoPadre#");
		if (nodo != null) {
			var dato0 = new WebFXTreeItem("#Replace(rsnivn.Organizacion,chr(34),'''')#", "javascript:ProcesarDatos(0, '#rsnivn.EScodigo#', '#rsnivn.EScodigoPadre#', 'P-#rsnivn.EScodigo#');");
			<cfif rsnivn.ESOultimoNivel EQ 1>
			dato0.icon = imgnormal;
			dato0.openIcon = imgnormal;
			</cfif>

			<cfif isdefined("Form.ItemId") and Form.ItemId NEQ "">
				if ('#Form.ItemId#' == new String (dato0.id)) {
				<cfif rsnivn.ESOultimoNivel EQ 1>
					dato0.icon = imgselec2;
					dato0.openIcon = imgselec2;
				<cfelse>
					dato0.icon = imgselec;
					dato0.openIcon = imgselec;
					selected = dato0;
				</cfif>
				}
			</cfif>
			nodo.add(dato0);
		}
	</cfloop>
	</cfoutput>

	document.write(tree);
	if (selected != null) selected.expand();
</script>


<form name="arbol" method="post" action="estructOrgaz.cfm">
	<input type="hidden" name="EScodigoPadre" value="">
	<input type="hidden" name="modo" value="CAMBIO">
	<input type="hidden" name="EScodigo" value="">
	<input type="hidden" name="root" value="0">
	<input type="hidden" name="ItemId" value="">
</form>
