<cfoutput>
<link href="#Session.JSroot#/js/xtree/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="#Session.JSroot#/js/xtree/xtree.js"></script>
</cfoutput>
<cfparam name="form.nivel" default="0">
<cfparam name="form.CILcodigo" default="">
<cfparam name="form.PLcodigo" default="">
<cfparam name="form.PEcodigo" default="">
<cfparam name="form.PMcodigo" default="">
<script language="JavaScript1.2">

	function ProcesarCicloLectivo(root, pCILcodigo) {
		document.arbol.CILcodigo.value = pCILcodigo;
		document.arbol.PLcodigo.value = "";
		document.arbol.PEcodigo.value = "";
		document.arbol.root.value = root;
		document.arbol.nivel.value = "1";
		if (root == 1) {
			
			document.arbol.modo.value = "ALTA";
		} else {
			document.arbol.modo.value = "CAMBIO";
		}
		document.arbol.submit();
	}

	function AgregarPeriodoLectivo(root, pCILcodigo) {
		document.arbol.CILcodigo.value = pCILcodigo;
		document.arbol.PLcodigo.value = "";
		document.arbol.PEcodigo.value = "";
		document.arbol.root.value = root;
		document.arbol.nivel.value = "2";
		document.arbol.modo.value = "ALTA";
		document.arbol.submit();
	}
	function ProcesarPeriodosLectivo(root, pCILcodigo, pPLcodigo) {
		document.arbol.CILcodigo.value = pCILcodigo;
		document.arbol.PLcodigo.value = pPLcodigo;
		document.arbol.PEcodigo.value = "";
		document.arbol.root.value = root;
		document.arbol.nivel.value = "2";
		document.arbol.modo.value = "CAMBIO";
		document.arbol.submit();
	}

	function ProcesarPeriodoEvaluacion(root, pCILcodigo, pPLcodigo, pPEcodigo) {
		document.arbol.CILcodigo.value = pCILcodigo;
		document.arbol.PLcodigo.value = pPLcodigo;
		document.arbol.PEcodigo.value = pPEcodigo;
		document.arbol.root.value = root;
		document.arbol.nivel.value = "3";
		document.arbol.modo.value = "CAMBIO";
		document.arbol.submit();
	}

</script>

<cfquery name="rsCicloLectivo" datasource="#Session.DSN#">
	select CILcodigo, CILnombre , CILcicloLectivo 
	from CicloLectivo 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>


<cfif isdefined("form.CILcodigo") AND form.CILcodigo NEQ "">
	<cfquery name="rsPeriodoLectivo" datasource="#Session.DSN#">
		select convert(varchar, a.CILcodigo) as CILcodigo,
			convert(varchar, PLcodigo) as PLcodigo, PLnombre, 
			convert(varchar,b.PLinicio,103) as PLinicio, 
			convert(varchar,b.PLfinal,103) as PLfinal
		from CicloLectivo a, PeriodoLectivo b
		where a.CILcodigo = b.CILcodigo
		   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
 		   and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#"> 
	</cfquery>
</cfif>

<cfif isdefined("form.PLcodigo") and  form.PLcodigo NEQ "">
	<cfquery name="rsPeriodoEvaluacion" datasource="#Session.DSN#">
		select convert(varchar,a.CILcodigo) as CILcodigo,
			convert(varchar,b.PLcodigo) as PLcodigo, 
		convert(varchar,PEcodigo) as PEcodigo, PEnombre, 
		convert(varchar,PEinicio,103) as PEinicio, 
		convert(varchar,PEfinal,103) as PEfinal
		from CicloLectivo a, PeriodoLectivo b, PeriodoEvaluacion c
		where a.CILcodigo = b.CILcodigo
		   and b.PLcodigo = c.PLcodigo
		   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		   and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
		   and b.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PLcodigo#">
	</cfquery>
</cfif>
<script language="JavaScript" type="text/javascript">
	<cfoutput>
	//var imgraiz = "#Session.JSroot#/imagenes/estructura/web_users.gif";
	var imgraiz = "#Session.JSroot#/js/xtree/images/blank.png";
	var flecha =  "#Session.JSroot#/imagenes/iconos/leave_sel.gif";
	var blanco = "#Session.JSroot#/imagenes/iconos/leave_wht.gif";
	var abierto = "#Session.JSroot#/imagenes/iconos/folder_opn.gif"; 
	var cerrado = "#Session.JSroot#/imagenes/iconos/folder_cls.gif"; 
	var agregarF = "#Session.JSroot#/imagenes/iconos/folder_add.gif"; 
	var tree = new WebFXTree(" ");
	var selected = null;
	tree.setBehavior('explorer');
	tree.icon = imgraiz;
	tree.openIcon = imgraiz;
	</cfoutput>
	<cfoutput>
	<cfloop query="rsCicloLectivo">
		var datoCIL = new WebFXTreeItem("Tipo Ciclo: #Replace(rsCicloLectivo.CILnombre,chr(34),'''')#", "javascript:ProcesarCicloLectivo(1, '#rsCicloLectivo.CILcodigo#');");
		tree.add(datoCIL);
		datoCIL.icon = abierto;
		datoCIL.openIcon = cerrado;
		<cfif isdefined("form.CILcodigo") AND rsCicloLectivo.CILcodigo EQ form.CILcodigo>
			<cfif form.PLcodigo EQ "">
			datoCIL.icon = abierto;
			datoCIL.openIcon = abierto;
			//datoCIL.expand();
			</cfif>
			var datoPL = new WebFXTreeItem("(Agregar nuevo Ciclo Lectivo)", "javascript:AgregarPeriodoLectivo(0, '#rsCicloLectivo.CILcodigo#');");
			datoCIL.add(datoPL);
			datoPL.icon = agregarF;
			datoPL.openIcon = agregarF;
			<cfloop query="rsPeriodoLectivo">
				var datoPL = new WebFXTreeItem("Ciclo: #Replace(rsPeriodoLectivo.PLnombre,chr(34),'''')&' del '&Replace(rsPeriodoLectivo.PLinicio,chr(34),'''')&' al '&Replace(rsPeriodoLectivo.PLfinal,chr(34),'''')#", "javascript:ProcesarPeriodosLectivo(0, '#rsPeriodoLectivo.CILcodigo#', '#rsPeriodoLectivo.PLcodigo#');");
				datoCIL.add(datoPL);
				<cfif isdefined("form.PLcodigo") and rsPeriodoLectivo.PLcodigo EQ form.PLcodigo>
					<cfif form.PEcodigo EQ "">
					datoPL.icon = abierto;
					datoPL.openIcon = abierto;
					</cfif>
					<cfloop query="rsPeriodoEvaluacion">
						var datoPE = new WebFXTreeItem("Período: #Replace(rsPeriodoEvaluacion.PEinicio,chr(34),'''')&' '&Replace(rsPeriodoEvaluacion.PEfinal,chr(34),'''')&' '&Replace(rsPeriodoEvaluacion.PEnombre,chr(34),'''')#", "javascript:ProcesarPeriodoEvaluacion(0, '#rsPeriodoEvaluacion.CILcodigo#', '#rsPeriodoEvaluacion.PLcodigo#', '#rsPeriodoEvaluacion.PEcodigo#');");
						datoPL.add(datoPE);
						<cfif rsPeriodoEvaluacion.PEcodigo EQ form.PEcodigo>
						datoPE.icon = flecha;
						datoPE.openIcon = flecha;
						<cfelse>
						datoPE.icon = blanco;
						datoPE.openIcon = blanco;
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>
		</cfif>
	</cfloop>		
	</cfoutput>

	document.write(tree);

	tree.expandAll();

</script>

<cfoutput>
	<form name="arbol" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0">
		<input type="hidden" name="root" value="0">
		<input type="hidden" name="ItemId" value="">
		<input type="hidden" name="nivel" value="<cfif isdefined('Form.CILcodigo')>#Form.nivel#</cfif>">
		<input type="hidden" name="CILcodigo" value="<cfif isdefined('Form.CILcodigo')>#Form.CILcodigo#</cfif>">
		<input type="hidden" name="PLcodigo" value="<cfif isdefined('Form.PLcodigo')>#Form.PLcodigo#</cfif>">
		<input type="hidden" name="PEcodigo" value="<cfif isdefined('Form.PEcodigo')>#Form.PEcodigo#</cfif>">
		<input type="hidden" name="modo" value="CAMBIO">
	</form>
</cfoutput>
