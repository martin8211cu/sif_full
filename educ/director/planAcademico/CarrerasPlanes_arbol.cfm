<cfoutput>
<link href="#Session.JSroot#/js/xtree/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="#Session.JSroot#/js/xtree/xtree.js"></script>
</cfoutput>
<script language="JavaScript1.2">
	function AgregarCarreras() 
	{
		document.arbol.nivel.value = "1";
		document.arbol.modo.value = "ALTA";
		document.arbol.CARcodigo.value = "";
		document.arbol.PEScodigo.value = "";
		document.arbol.submit();
	}
	function ProcesarCarreras(CARcodigo) 
	{
		document.arbol.nivel.value = "1";
		document.arbol.CARcodigo.value = CARcodigo;
		document.arbol.PEScodigo.value = "";
		document.arbol.modo.value = "CAMBIO";
		document.arbol.submit();
	}

	function AgregarPlanes(CARcodigo) 
	{
		document.arbol.nivel.value = "2";
		document.arbol.CARcodigo.value = CARcodigo;
		document.arbol.PEScodigo.value = "";
		document.arbol.modo.value = "ALTA";
		document.arbol.submit();
	}
	function ProcesarPlanes(CARcodigo, PEScodigo)
	{
		document.arbol.nivel.value = "2";
		document.arbol.CARcodigo.value = CARcodigo;
		document.arbol.PEScodigo.value = PEScodigo;
		document.arbol.modo.value = "CAMBIO";
		document.arbol.submit();
	}
</script>

<cfinclude template="../../queries/qryEscuela.cfm">
<cfquery name="rsNodoRoot" dbtype="query">
	select *
	from rsEscuela
	where EScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EScodigo#">
</cfquery>

<cfquery name="rsnivCarreras" datasource="#Session.DSN#">
	select convert(varchar, CARcodigo) as CARcodigo, 
		CARnombre + ' (' + CARcodificacion + ')' as CARnombre
	from Carrera
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigo#">
	order by EScodigo, CARcodificacion
</cfquery>

<cfif isdefined("form.CARcodigo") and form.CARcodigo NEQ "">
</cfif>

<script language="JavaScript" type="text/javascript">
	var imgraiz = "/cfmx/educ/imagenes/estructura/web_users.gif";
	var imgopn = "/cfmx/educ/imagenes/iconos/folder_opn.gif";
	var imgcls = "/cfmx/educ/imagenes/iconos/folder_cls.gif";
	var imgadd = "/cfmx/educ/imagenes/iconos/leave_add.gif";
	var imgaddfolder = "/cfmx/educ/imagenes/iconos/folder_add.gif";
	<cfoutput query="rsNodoRoot">
	var tree = new WebFXTree("#rsNodoRoot.ESnombre#");
	</cfoutput>
	var selected = null;
	tree.setBehavior('classic');
	tree.icon = imgraiz;
	tree.openIcon = imgraiz;

	<cfoutput>
	var carrera = new WebFXTreeItem("(Agregar Nueva Carrera...)", "javascript:AgregarCarreras();",tree,imgaddfolder,imgaddfolder);
	<cfloop query="rsnivCarreras">
		var carrera = new WebFXTreeItem("Carrera: #Replace(rsnivCarreras.CARnombre,chr(34),'''')#", "javascript:ProcesarCarreras('#rsnivCarreras.CARcodigo#');",tree,imgcls,imgopn);
		<cfif isdefined("form.CARcodigo") AND rsnivCarreras.CARcodigo EQ form.CARcodigo>
			selected = carrera;
		</cfif>
		<cfset LvarCARcodigo = rsnivCarreras.CARcodigo>
		<cfquery name="rsnivPlanEstudios" datasource="#Session.DSN#">
			select convert(varchar, b.PEScodigo) as PEScodigo, 
				a.GAnombre + ' en ' + b.PESnombre + ' (' + b.PEScodificacion + ') ' +
				case
					when PESestado = 0 then '(INACTIVO)'
					when PESestado = 2 then '(CERRADO)'
					when PESdesde > getdate() then '(PLANEADO)'
					when isnull(PEShasta,getdate()) >= convert(varchar,getdate(),112) then '(VIGENTE NUEVOS)'
					when isnull(PESmaxima,getdate()) >= convert(varchar,getdate(),112) then '(VIGENTE ANTIGUOS)'
					else '(OBSOLETO)'
				end as PESnombre
			from PlanEstudios b, GradoAcademico a
			where CARcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCARcodigo#">
			  and a.GAcodigo = b.GAcodigo
			order by b.PEScodificacion
		</cfquery>
		var plan = new WebFXTreeItem("(Agregar Nuevo Plan de Estudios...)", "javascript:AgregarPlanes('#LvarCARcodigo#');",carrera,imgadd,imgadd);
		<cfloop query="rsnivPlanEstudios">
			var plan = new WebFXTreeItem("Plan: #Replace(rsnivPlanEstudios.PESnombre,chr(34),'''')#", "javascript:ProcesarPlanes('#LvarCARcodigo#', '#rsnivPlanEstudios.PEScodigo#');",carrera);
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
		<input type="hidden" name="EScodigo" value="<cfif isdefined('Form.EScodigo')>#Form.EScodigo#</cfif>">
		<input type="hidden" name="CARcodigo" value="<cfif isdefined('Form.CARcodigo')>#Form.CARcodigo#</cfif>">
		<input type="hidden" name="PEScodigo" value="<cfif isdefined('Form.PEScodigo')>#Form.PEScodigo#</cfif>">
		<input type="hidden" name="modo" value="CAMBIO">
	</form>
</cfoutput>
