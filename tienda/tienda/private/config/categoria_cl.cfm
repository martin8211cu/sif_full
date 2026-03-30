<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Seleccione categor&iacute;a</title>
	<script src="xtree-117.js"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link href="xtree-117.css" rel="stylesheet" type="text/css">
</head>

<!--- categoria por seleccionar default --->
<cfparam name="url.id" default="0">
<!--- ver que sea numerico. si es vacio o invalido, poner en cero --->
<cfif REFind("^[0-9]+$",url.id) IS 0><cfset url.id = 0></cfif>

<!--- categoria por excluir, si aplica --->
<cfparam name="url.ex" default="0">
<!--- ver que sea numerico. si es vacio o invalido, poner en cero --->
<cfif REFind("^[0-9]+$",url.ex) IS 0><cfset url.ex = 0></cfif>
<!--- no excluir root --->
<cfif url.ex Is 0><cfset url.ex = -1></cfif>

	<!--- Buscar mis ancestros --->
	<cfquery datasource="#session.dsn#" name="papa">
		select distinct ancestro
		from CategoriaRelacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	</cfquery>
	<cfset ruta = ValueList(papa.ancestro) & ",0">
	<cfquery datasource="#session.dsn#" name="lista" maxrows="200">
		select c.id_categoria,c.nombre_categoria,c.orden_relativo,
			c.color_borde, c.color_fondo, c.profundidad, categoria_padre,
			(select count(*) from Categoria h
				where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and h.categoria_padre = c.id_categoria) as hijos
		from Categoria c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and categoria_padre in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ruta#" list="yes">)
		  and id_categoria != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ex#" >
		  and id_categoria != 0
		order by profundidad, orden_relativo
	</cfquery>
	
<body style="margin:0">
	<div style="width: 300px; height: 400px; padding: 5px; overflow: auto;border:1px solid black; ">
	<script type="text/javascript">
	<!--
	if (document.getElementById) {
		var node0 = new WebFXTree('Categorías','javascript:nodeclick(\'0\',\'\',1)');
		node0.setBehavior('explorer');
	<cfoutput query="lista">
		var node#id_categoria# = new WebFXTreeItem('#JSStringFormat(nombre_categoria)#',
			'javascript:nodeclick(#id_categoria#,\'#JSStringFormat(nombre_categoria)#\',#hijos#)');
		node#id_categoria#.open = true;
		<cfif hijos is 0>
		node#id_categoria#.icon = webFXTreeConfig.fileIcon;
		</cfif>
	</cfoutput>
	<cfoutput query="lista">
		node#categoria_padre#.add(node#id_categoria#);
	</cfoutput>
	<!--- mostrar solamente la categoria seleccionada --->
		<cfoutput>
		var shownode = #IIf(url.id, DE('node'&url.id), DE('node0'))#;
		</cfoutput>
		while (shownode) {
			shownode.open = true;
			shownode=shownode.parentNode;
		}
		document.write(node0);
		<cfif url.id>
			node<cfoutput>#url.id#</cfoutput>.select();
		</cfif>;
	}
	function nodeclick(id,name,hijos){
		if (hijos == 0 || id == <cfoutput>#url.id#</cfoutput>) {
			window.opener.getcat(id,name);
			window.close();
		} else {
			location.replace('categoria_cl.cfm?id='+escape(id)+'&ex=<cfoutput>#url.ex#</cfoutput>');
		}
	}
	//-->
	</script>
	</div>

</body>
</html>
