<cfoutput>
<link href="xtree/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="xtree/xtree.js"></script>
</cfoutput>
<cfparam name="form.nivel" default="0">
<cfparam name="form.SScodigo" default="">
<cfparam name="form.SMcodigo" default="">
<cfparam name="form.SMNcodigo" default="">
<cfparam name="form.SPcodigo" default="">
<script language="JavaScript1.2">
//	function SOINarbol
</script>
<script language="JavaScript1.2">
	function ProcesarSistemas(pSScodigo) 
	{
		document.arbol.SScodigo.value = pSScodigo;
		document.arbol.SMcodigo.value = "";
		document.arbol.SMNcodigo.value = "";
		document.arbol.SMNcodigoPadre.value = "";
		document.arbol.SMNtipo.value = "";
		document.arbol.SPcodigo.value = "";
		document.arbol.nivel.value = "1";
		document.arbol.modo.value = "LISTA";
		document.arbol.submit();
	}

	function ProcesarModulos(pSScodigo, pSMcodigo) 
	{
		document.arbol.SScodigo.value = pSScodigo;
		document.arbol.SMcodigo.value = pSMcodigo;
		document.arbol.SMNcodigo.value = "";
		document.arbol.SMNcodigoPadre.value = "";
		document.arbol.SMNtipo.value = "";
		document.arbol.SPcodigo.value = "";
		document.arbol.nivel.value = "2";
		document.arbol.modo.value = "LISTA";
		document.arbol.submit();
	}

	function AgregarOpcion(pSScodigo, pSMcodigo, pSMNcodigo, pSMNtipo)
	{
		document.arbol.SScodigo.value = pSScodigo;
		document.arbol.SMcodigo.value = pSMcodigo;
		document.arbol.SMNcodigo.value = "";
		document.arbol.SMNcodigoPadre.value = pSMNcodigo;
		document.arbol.SMNtipo.value = pSMNtipo;
		document.arbol.SPcodigo.value = "";
		document.arbol.nivel.value = "3";
		document.arbol.modo.value = "ALTA";
		document.arbol.submit();
	}

	function ProcesarOpciones(pSScodigo, pSMcodigo, pSMNcodigo) 
	{
		document.arbol.SScodigo.value = pSScodigo;
		document.arbol.SMcodigo.value = pSMcodigo;
		document.arbol.SMNcodigo.value = pSMNcodigo;
		document.arbol.SMNcodigoPadre.value = "";
		document.arbol.SMNtipo.value = "";
		document.arbol.SPcodigo.value = "";
		document.arbol.nivel.value = "3";
		document.arbol.modo.value = "CAMBIO";
		document.arbol.submit();
	}
	

	function ProcesarProcesos(pSScodigo, pSMcodigo, pSPcodigo) {
		document.arbol.SScodigo.value = pSScodigo;
		document.arbol.SMcodigo.value = pSMcodigo;
		document.arbol.SMNcodigo.value = "";
		document.arbol.SMNcodigoPadre.value = "";
		document.arbol.SMNtipo.value = "";
		document.arbol.SPcodigo.value = pSPcodigo;
		document.arbol.nivel.value = "3";
		document.arbol.modo.value = "CAMBIO";
	}

</script>

<cfif form.nivel EQ 2>
	<cfquery name="rsHayMenues" datasource="asp">
		select 1 from SMenues 
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
    </cfquery>
	<cfif (rsHayMenues.RecordCount EQ 0)>
		<cfquery name="rscodMenu" datasource="asp">
			Select (coalesce(max(SMNcodigo),0) + 1) as codMenu
			from SMenues
		</cfquery>
		<cfquery name="rsSMenues" datasource="asp">
			insert into SMenues (
				SMNcodigo,
				SScodigo,
				SMcodigo,
				SMNcodigoPadre,
				SMNnivel,
				SMNtipo,
				SPcodigo,
				SMNtipoMenu,
				SMNtitulo,
				SMNexplicativo,
				SMNorden,
				SMNimagenGrande,
				SMNimagenPequena)
			values ( 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rscodMenu.codMenu#">,
				'#form.SScodigo#',
				'#form.SMcodigo#',
				null,
				0,
				'M',
				null,
				1,
				'Menú Inicial',
				'Menu Inicial del Módulo',
				0,
				null,
				null)
		</cfquery>
	</cfif>
</cfif>

<cfparam  name="form.modo" default="LISTA">

<cfquery name="rsSistemas" datasource="asp">
	select {fn RTRIM(SScodigo)} as SScodigo,
	SSdescripcion, SSmenu
	from SSistemas 
	order by SScodigo
</cfquery>

<cfif isdefined("form.SScodigo") and form.SScodigo NEQ "">
	<cfquery name="rsModulos" datasource="asp">
		select {fn RTRIM(SScodigo)} as SScodigo,
				{fn RTRIM(SMcodigo)} as SMcodigo,
				SMdescripcion,
				SMmenu
		from SModulos
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
		order by SScodigo, SMcodigo
	</cfquery>
</cfif>

<cfif isdefined("form.SMcodigo") and form.SMcodigo NEQ "">
	<cfquery name="rsMenues" datasource="asp">
		select {fn RTRIM(m.SScodigo)} as SScodigo,
			{fn RTRIM(m.SMcodigo)} as SMcodigo,
			SMNcodigo,
			m.SMNtipo, 
			{fn RTRIM(m.SPcodigo)} as SPcodigo,
			p.SPdescripcion, p.SPmenu,
			SMNcodigoPadre,
			m.SMNtitulo
		 from SMenues m 
		 	left outer join SProcesos p 
			  on m.SScodigo = p.SScodigo
			  and m.SMcodigo = p.SMcodigo
			  and m.SPcodigo = p.SPcodigo
		where m.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		  and m.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		order by SMNpath
	</cfquery>
	<cfquery name="rsProcesosSinMenu" datasource="asp">
		select {fn RTRIM(SScodigo)} as SScodigo,
				{fn RTRIM(SMcodigo)} as SMcodigo,
				{fn RTRIM(SPcodigo)} as SPcodigo,
				SPdescripcion,
				SPmenu
		 from SProcesos p
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SScodigo#">
		  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">
		  and not exists (select * from SMenues m
			 					  where m.SScodigo = p.SScodigo
								    and m.SMcodigo = p.SMcodigo
								    and m.SPcodigo = p.SPcodigo)
		order by SScodigo, SMcodigo, SPcodigo
	</cfquery>
</cfif>

<script language="JavaScript" type="text/javascript">
function isdefined( variable)
{
    return (typeof(window[variable]) == "undefined")?  false: true;
}
	<cfoutput>
	var LvarExpand = null;
	var LimgRoot = "xtree/images/blank.png";
	var LimgFolderClose = "iconos/folder_cls.gif"; 
	var LimgFolderOpen = "iconos/folder_opn.gif"; 
	var LimgFolderNoAplica = "iconos/folder_na.gif"; 
	var LimgFolderAgrega = "iconos/folder_add.gif"; 
	var LimgPrcNoSelec = "iconos/leave_wht.gif";
	var LimgPrcSelec =  "iconos/leave_sel.gif";
	var LimgPrcNoAplica = "iconos/leave_na.gif";
	var LimgPrcAgrega = "iconos/leave_add.gif";
	var tree = new WebFXTree(" ", "");
	var selected = null;
	tree.setBehavior('explorer');
	tree.icon = LimgRoot;
	tree.openIcon = LimgRoot;
	
	<cfloop query="rsSistemas">
	  <cfif rsSistemas.SSmenu EQ 0>
		var LvarSIS = new WebFXTreeItem("Sistema: #Replace(rsSistemas.SSdescripcion,chr(34),'''')#");
		tree.add(LvarSIS);
		LvarSIS.icon = LimgFolderNoAplica;
		LvarSIS.openIcon = LimgFolderNoAplica;
	  <cfelse>
		var LvarSIS = new WebFXTreeItem("Sistema: #Replace(rsSistemas.SSdescripcion,chr(34),'''')#", "javascript:ProcesarSistemas('#rsSistemas.SScodigo#');");
		tree.add(LvarSIS);
		<cfif isdefined("form.SScodigo") AND trim(rsSistemas.SScodigo) EQ trim(form.SScodigo)>
			LvarExpand = LvarSIS;
			<cfif form.SMcodigo EQ "">
			LvarSIS.icon = LimgFolderOpen;
			LvarSIS.openIcon = LimgFolderOpen;
			</cfif>
			<cfloop query="rsModulos">
				<cfif rsModulos.SMmenu EQ 0>
					var LvarMOD = new WebFXTreeItem("Módulo: #Replace(rsModulos.SMdescripcion,chr(34),'''')#");
					LvarSIS.add(LvarMOD);
					LvarMOD.icon = LimgFolderNoAplica;
					LvarMOD.openIcon = LimgFolderNoAplica;
				<cfelse>
					var LvarMOD = new WebFXTreeItem("Módulo: #Replace(rsModulos.SMdescripcion,chr(34),'''')#", "javascript:ProcesarModulos('#rsModulos.SScodigo#', '#rsModulos.SMcodigo#');");
					LvarSIS.add(LvarMOD);
					<cfif trim(rsModulos.SMcodigo) EQ trim(form.SMcodigo)>
						LvarExpand = LvarMOD;
						LvarMOD.icon = LimgFolderOpen;
						LvarMOD.openIcon = LimgFolderOpen;
						<cfloop query="rsMenues">
						  <cfif rsMenues.SMNcodigoPadre EQ "">
							var LvarMENU#rsMenues.SMNcodigo# = new WebFXTreeItem("#Replace(rsMenues.SMNtitulo,chr(34),'''')#", "javascript:ProcesarOpciones('#rsMenues.SScodigo#', '#rsMenues.SMcodigo#', '#rsMenues.SMNcodigo#');");
							LvarMOD.add(LvarMENU#rsMenues.SMNcodigo#);
						  <cfelse>
							<cfif rsMenues.SMNtipo EQ "P">
							var LvarMENU#rsMenues.SMNcodigo# = new WebFXTreeItem("Proceso: #Replace(rsMenues.SPdescripcion,chr(34),'''')#", "javascript:ProcesarOpciones('#rsMenues.SScodigo#', '#rsMenues.SMcodigo#', '#rsMenues.SMNcodigo#');");
							<cfelse>
							var LvarMENU#rsMenues.SMNcodigo# = new WebFXTreeItem("Menú: #Replace(rsMenues.SMNtitulo,chr(34),'''')#", "javascript:ProcesarOpciones('#rsMenues.SScodigo#', '#rsMenues.SMcodigo#', '#rsMenues.SMNcodigo#');");
							</cfif>
							if (isdefined('LvarMENU#rsMenues.SMNcodigoPadre#')){
								LvarMENU#rsMenues.SMNcodigoPadre#.add(LvarMENU#rsMenues.SMNcodigo#);
							} else {
								window.status = ("Alerta: Menu padre no encontrado: #rsMenues.SMNcodigoPadre#");
							}
						  </cfif>
						  <cfif rsMenues.SMNtipo EQ "P">
								<cfif rsMenues.SPmenu EQ 0>
								LvarMENU#rsMenues.SMNcodigo#.icon = LimgPrcNoAplica;
								LvarMENU#rsMenues.SMNcodigo#.openIcon = LimgPrcNoAplica;
								<cfelse>
								LvarMENU#rsMenues.SMNcodigo#.icon = LimgPrcNoSelec;
								LvarMENU#rsMenues.SMNcodigo#.openIcon = LimgPrcNoSelec;
								</cfif>
						  <cfelse>
								<cfif trim(rsMenues.SMNcodigo) EQ trim(form.SMNcodigo)>
									LvarExpand = LvarMENU#rsMenues.SMNcodigo#;
								</cfif>
								LvarMENU#rsMenues.SMNcodigo#.icon = LimgFolderClose;
								LvarMENU#rsMenues.SMNcodigo#.openIcon = LimgFolderOpen;
								var LvarMENU0 = new WebFXTreeItem("(Agregar Nueva Opcion tipo Menu)", "javascript:AgregarOpcion('#rsMenues.SScodigo#', '#rsMenues.SMcodigo#', '#rsMenues.SMNcodigo#', 'M');");
								LvarMENU#rsMenues.SMNcodigo#.add(LvarMENU0);
								LvarMENU0.icon = LimgFolderAgrega;
								LvarMENU0.openIcon = LimgFolderAgrega;
								var LvarMENU0 = new WebFXTreeItem("(Agregar Nueva Opcion tipo Proceso)", "javascript:AgregarOpcion('#rsMenues.SScodigo#', '#rsMenues.SMcodigo#', '#rsMenues.SMNcodigo#', 'P');");
								LvarMENU#rsMenues.SMNcodigo#.add(LvarMENU0);
								LvarMENU0.icon = LimgPrcAgrega;
								LvarMENU0.openIcon = LimgPrcAgrega;
						  </cfif>
						</cfloop> 
						<cfloop query="rsProcesosSinMenu">
							var datoPRC = new WebFXTreeItem("Proceso sin menu: #Replace(rsProcesosSinMenu.SPdescripcion,chr(34),'''')#", "javascript:ProcesarProcesos('#rsProcesosSinMenu.SScodigo#', '#rsProcesosSinMenu.SMcodigo#', '#rsProcesosSinMenu.SPcodigo#');");
							LvarMOD.add(datoPRC);
							<cfif rsProcesosSinMenu.SPmenu EQ 0>
								datoPRC.icon = LimgPrcNoAplica;
								datoPRC.openIcon = LimgPrcNoAplica;
							<cfelseif form.SPcodigo EQ rsProcesosSinMenu.SPcodigo>
								datoPRC.icon = LimgPrcSelec;
								datoPRC.openIcon = LimgPrcSelec;
							<cfelse>
								datoPRC.icon = LimgPrcNoSelec;
								datoPRC.openIcon = LimgPrcNoSelec;
							</cfif>
						</cfloop>		
					</cfif>
				</cfif>
			</cfloop> 
		</cfif>
	  </cfif>
	</cfloop>		
	</cfoutput>

	document.write(tree);
	if (LvarExpand)	LvarExpand.expand();


	//tree.expandAll();

</script>

<cfoutput>
	<form name="arbol" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0">
		<input type="hidden" name="nivel" value="<cfif isdefined('Form.SScodigo')>#Form.nivel#</cfif>">
		<input type="hidden" name="SScodigo" value="<cfif isdefined('Form.SScodigo')>#Form.SScodigo#</cfif>">
		<input type="hidden" name="SMcodigo" value="<cfif isdefined('Form.SMcodigo')>#Form.SMcodigo#</cfif>">
		<input type="hidden" name="SMNcodigo" value="<cfif isdefined('Form.SMNcodigo')>#Form.SMNcodigo#</cfif>">
		<input type="hidden" name="SPcodigo" value="">
		<input type="hidden" name="SMNcodigoPadre" value="">
		<input type="hidden" name="SMNtipo" value="">
		<input type="hidden" name="modo" value="LISTA">
	</form>
</cfoutput>
