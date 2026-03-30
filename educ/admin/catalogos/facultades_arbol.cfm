<cfoutput>
<link href="#Session.JSroot#/js/xtree/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="#Session.JSroot#/js/xtree/xtree.js"></script>
</cfoutput>
<script language="JavaScript1.2">
	function AgregarFacultades() 
	{
		document.arbol.nivel.value = "1";
		document.arbol.modo.value = "ALTA";
		document.arbol.Fcodigo.value = "";
		document.arbol.EScodigo.value = "";
		document.arbol.submit();
	}
	function ProcesarFacultades(Fcodigo) 
	{
		document.arbol.nivel.value = "1";
		document.arbol.Fcodigo.value = Fcodigo;
		document.arbol.EScodigo.value = "";
		document.arbol.modo.value = "CAMBIO";
		document.arbol.submit();
	}

	function AgregarEscuelas(Fcodigo) 
	{
		document.arbol.nivel.value = "2";
		document.arbol.Fcodigo.value = Fcodigo;
		document.arbol.EScodigo.value = "";
		document.arbol.modo.value = "ALTA";
		document.arbol.submit();
	}
	function ProcesarEscuelas(Fcodigo, EScodigo)
	{
		document.arbol.nivel.value = "2";
		document.arbol.Fcodigo.value = Fcodigo;
		document.arbol.EScodigo.value = EScodigo;
		document.arbol.modo.value = "CAMBIO";
		document.arbol.submit();
	}
</script>

<cfquery name="rsNodoRoot" datasource="#Session.DSN#">
	select Edescripcion as Enombre
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsnivFacultades" datasource="#Session.DSN#">
	select convert(varchar, Fcodigo) as Fcodigo, 
		   Fnombre + ' (' + Fcodificacion + ')' as Fnombre
	from Facultad
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Fcodificacion
</cfquery>

<cfif isdefined("form.Fcodigo") and form.Fcodigo NEQ "">
</cfif>

<script language="JavaScript" type="text/javascript">
	var imgraiz = "/cfmx/educ/imagenes/iconos/edificio.gif";
	var imgopn = "/cfmx/educ/imagenes/iconos/folder_opn.gif";
	var imgcls = "/cfmx/educ/imagenes/iconos/folder_cls.gif";
	var imgadd = "/cfmx/educ/imagenes/iconos/leave_add.gif";
	var imgaddfolder = "/cfmx/educ/imagenes/iconos/folder_add.gif";
	<cfoutput query="rsNodoRoot">
	var tree = new WebFXTree("#rsNodoRoot.Enombre#");
	</cfoutput>
	var selected = null;
	tree.setBehavior('classic');
	tree.icon = imgraiz;
	tree.openIcon = imgraiz;

	<cfoutput>
	var Facultad = new WebFXTreeItem("(Agregar Nueva <cfoutput>#session.parametros.Facultad#</cfoutput>...)", "javascript:AgregarFacultades();",tree,imgaddfolder,imgaddfolder);
	<cfloop query="rsnivFacultades">
		var Facultad = new WebFXTreeItem("<cfoutput>#session.parametros.Facultad#</cfoutput>: #Replace(rsnivFacultades.Fnombre,chr(34),'''')#", "javascript:ProcesarFacultades('#rsnivFacultades.Fcodigo#');",tree,imgcls,imgopn);
		<cfif isdefined("form.Fcodigo") AND rsnivFacultades.Fcodigo EQ form.Fcodigo>
			selected = Facultad;
		</cfif>
		<cfset LvarFcodigo = rsnivFacultades.Fcodigo>
		<cfquery name="rsnivEscuelas" datasource="#Session.DSN#">
			select convert(varchar, b.EScodigo) as EScodigo, 
				b.ESnombre + ' (' + b.EScodificacion + ')' as ESnombre
			from Escuela b
			where Fcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarFcodigo#">
			order by b.EScodificacion
		</cfquery>
		var Escuela = new WebFXTreeItem("(Agregar Nueva <cfoutput>#session.parametros.Escuela#</cfoutput>...)", "javascript:AgregarEscuelas('#LvarFcodigo#');",Facultad,imgadd,imgadd);
		<cfloop query="rsnivEscuelas">
			var Escuela = new WebFXTreeItem("#Session.parametros.Escuela#: #Replace(rsnivEscuelas.ESnombre,chr(34),'''')#", "javascript:ProcesarEscuelas('#LvarFcodigo#', '#rsnivEscuelas.EScodigo#');",Facultad);
		</cfloop>
	</cfloop>		
	
	</cfoutput>

	document.write(tree);

	// para expandir la carpeta seleccionada
	tree.collapseAll();
	tree.expand();
	if (selected != null) selected.expand();

</script>

<cfoutput>
	<form name="arbol" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0">
		<input type="hidden" name="root" value="0">
		<input type="hidden" name="ItemId" value="">
		<input type="hidden" name="nivel" value="<cfif isdefined('Form.EScodigo')>#Form.nivel#</cfif>">
		<input type="hidden" name="Fcodigo" value="<cfif isdefined('Form.Fcodigo')>#Form.Fcodigo#</cfif>">
		<input type="hidden" name="EScodigo" value="<cfif isdefined('Form.EScodigo')>#Form.EScodigo#</cfif>">
		<input type="hidden" name="modo" value="CAMBIO">
	</form>
</cfoutput>
