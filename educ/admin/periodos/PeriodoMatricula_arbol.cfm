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
//	function SOINarbol
</script>
<script language="JavaScript1.2">
	function ProcesarCicloLectivo(root, pCILcodigo, nodollave, TipoCiclo) {
		document.arbol.CILcodigo.value = pCILcodigo;
		document.arbol.PLcodigo.value = "";
		document.arbol.PEcodigo.value = "";
		document.arbol.PMcodigo.value = "";
		document.arbol.CILtipoCicloDuracion.value = TipoCiclo;
		document.arbol.root.value = root;
		document.arbol.nivel.value = "1";
		if (root == 1) {
			document.arbol.modo.value = "ALTA";
		} else {
			document.arbol.modo.value = "CAMBIO";
		}
		document.arbol.submit();
	}

	function ProcesarPeriodosLectivo(root, pCILcodigo, pPLcodigo, TipoCiclo) {
		document.arbol.CILcodigo.value = pCILcodigo;
		document.arbol.PLcodigo.value = pPLcodigo;
		document.arbol.PEcodigo.value = "";
		document.arbol.PMcodigo.value = "";
		document.arbol.CILtipoCicloDuracion.value = TipoCiclo;
		document.arbol.root.value = root;
		if (TipoCiclo == "L")
			document.arbol.nivel.value = "3";
		else
			document.arbol.nivel.value = "2";
		document.arbol.modo.value = "ALTA";
		document.arbol.submit();
	}

	function ProcesarPeriodoEvaluacion(root, pCILcodigo, pPLcodigo, pPEcodigo, TipoCiclo) {
		document.arbol.CILcodigo.value = pCILcodigo;
		document.arbol.PLcodigo.value = pPLcodigo;
		document.arbol.PEcodigo.value = pPEcodigo;
		document.arbol.PMcodigo.value = "";
		document.arbol.CILtipoCicloDuracion.value = TipoCiclo;
		document.arbol.root.value = root;
		document.arbol.nivel.value = "3";
		document.arbol.modo.value = "ALTA";
		document.arbol.submit();
	}
	
	function AgregarPeriodoMatricula(root, pCILcodigo, pPLcodigo, pPEcodigo, TipoCiclo) {
		document.arbol.CILcodigo.value = pCILcodigo;
		document.arbol.PLcodigo.value = pPLcodigo;
		document.arbol.PEcodigo.value = pPEcodigo;
		document.arbol.PMcodigo.value = "";
		document.arbol.PMsecuencia.value = "";
		document.arbol.CILtipoCicloDuracion.value = TipoCiclo;
		document.arbol.root.value = root;
		document.arbol.nivel.value = "4";
		document.arbol.modo.value = "ALTA";
		document.arbol.submit();
	}
	function TarifasPeriodoMatricula(root, pCILcodigo, pPLcodigo, pPEcodigo, TipoCiclo) {
		document.arbol.CILcodigo.value = pCILcodigo;
		document.arbol.PLcodigo.value = pPLcodigo;
		document.arbol.PEcodigo.value = pPEcodigo;
		document.arbol.PMcodigo.value = "";
		document.arbol.PMsecuencia.value = "";
		document.arbol.CILtipoCicloDuracion.value = TipoCiclo;
		document.arbol.root.value = root;
		document.arbol.nivel.value = "5";
		document.arbol.modo.value = "CAMBIO";
		document.arbol.submit();
	}
	function ProcesarPeriodoMatricula(root, pCILcodigo, pPLcodigo, pPEcodigo, pPMcodigo, pPMsecuencia, TipoCiclo) {
		document.arbol.CILcodigo.value = pCILcodigo;
		document.arbol.PLcodigo.value = pPLcodigo;
		document.arbol.PEcodigo.value = pPEcodigo;
		document.arbol.PMcodigo.value = pPMcodigo;
		document.arbol.PMsecuencia.value = pPMsecuencia;
		document.arbol.CILtipoCicloDuracion.value = TipoCiclo;
		document.arbol.root.value = root;
		document.arbol.nivel.value = "4";
		document.arbol.modo.value = "CAMBIO";
		document.arbol.submit();
	}

</script>

<cfquery name="rsCicloLectivo" datasource="#Session.DSN#">
	select convert(varchar,CILcodigo) as CILcodigo,
	CILnombre , CILcicloLectivo , CILtipoCicloDuracion
	from CicloLectivo 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>



<cfif isdefined("form.CILcodigo") and form.CILcodigo NEQ "">
	<cfquery name="rsPeriodoLectivo" datasource="#Session.DSN#">
		select convert(varchar,a.CILcodigo) as CILcodigo,
		convert(varchar,PLcodigo) as PLcodigo,
		PLnombre , 
		convert(varchar,b.PLinicio,103) as PLinicio, 
		convert(varchar,b.PLfinal,103) as PLfinal,
		a.CILtipoCicloDuracion 
		from CicloLectivo a, PeriodoLectivo b
		where a.CILcodigo = b.CILcodigo
		   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		   and a.CILcodigo = <cfif isdefined('Form.CILcodigo')><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#"><cfelse>null</cfif>
	</cfquery>
</cfif>

<cfif isdefined("form.PLcodigo") and form.PLcodigo NEQ "">
	<cfquery name="rsPeriodoEvaluacion" datasource="#Session.DSN#">
		select convert(varchar,a.CILcodigo) as CILcodigo , 
		convert(varchar,c.PLcodigo) as PLcodigo, 
		convert(varchar,PEcodigo) as PEcodigo, 
		PEnombre, 
		convert(varchar,PEinicio,103) as PEinicio, 
		convert(varchar,PEfinal,103) as PEfinal, 
		a.CILtipoCicloDuracion 
		from CicloLectivo a, PeriodoLectivo b, PeriodoEvaluacion c
		where a.CILcodigo = b.CILcodigo
		   and b.PLcodigo = c.PLcodigo
		   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		   and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
		   and b.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PLcodigo#">
		   and a.CILtipoCicloDuracion = 'E'
	</cfquery>
</cfif>

<cfif isdefined("form.PLcodigo") and  len(trim(form.PLcodigo)) NEQ 0>
	<cfquery name="rsPeriodoMatricula" datasource="#Session.DSN#">
			select convert(varchar,a.CILcodigo) as CILcodigo, 
			convert(varchar,d.PLcodigo) as PLcodigo,
			convert(varchar,d.PEcodigo) as PEcodigo,
			convert(varchar,d.PMcodigo) as PMcodigo, 
			convert(varchar,d.PMsecuencia) as PMsecuencia,
			a.CILtipoCicloDuracion, 
			convert(varchar,d.PMinicio,103) as PMinicio, 
			convert(varchar,d.PMfinal,103) as PMfinal,
			case d.PMtipo when '2' then 'Extraordinaria' when '1' then 'Ordinaria' when '3' then 'de Retiro Justificado'  when '4' then 'de Retiro Injustificado' end as PMtipo,
			d.ts_rversion
			from CicloLectivo a, PeriodoLectivo b, PeriodoMatricula d
			where a.CILcodigo = b.CILcodigo
			   and b.PLcodigo = d.PLcodigo
			   and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			   and a.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CILcodigo#">
			   and d.PLcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PLcodigo#">
			<cfif form.CILtipoCicloDuracion EQ "L">
			   and a.CILtipoCicloDuracion = 'L'
			<cfelse>
			   and a.CILtipoCicloDuracion = 'E' and d.PEcodigo = <cfif form.PEcodigo EQ "">null<cfelse><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEcodigo#"></cfif>
			</cfif>
	</cfquery>
</cfif>

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
	//var imgraiz = "#Session.JSroot#/imagenes/estructura/web_users.gif";
	var imgraiz = "#Session.JSroot#/js/xtree/images/blank.png";
	var flecha =  "#Session.JSroot#/imagenes/iconos/leave_sel.gif";
	var blanco = "#Session.JSroot#/imagenes/iconos/leave_wht.gif";
	var abierto = "#Session.JSroot#/imagenes/iconos/folder_opn.gif"; 
	var cerrado = "#Session.JSroot#/imagenes/iconos/folder_opn.gif"; 
	var agregar = "#Session.JSroot#/imagenes/iconos/leave_add.gif"; 
	var dinero = "#Session.JSroot#/imagenes/iconos/leave_money.gif"; 
	var tree = new WebFXTree(" ", "");
	var selected = null;
	tree.setBehavior('explorer');
	tree.icon = imgraiz;
	tree.openIcon = imgraiz;
	
	<cfloop query="rsCicloLectivo">
		var datoCIL = new WebFXTreeItem("Tipo Ciclo: #Replace(rsCicloLectivo.CILnombre,chr(34),'''')#", "javascript:ProcesarCicloLectivo(1, '#rsCicloLectivo.CILcodigo#', 'P-#rsCicloLectivo.CILcodigo#','#rsCicloLectivo.CILTipoCicloDuracion#');");
		tree.add(datoCIL);
		<cfif isdefined("form.CILcodigo") AND rsCicloLectivo.CILcodigo EQ form.CILcodigo>
			<cfif form.PLcodigo EQ "">
			datoCIL.icon = abierto;
			datoCIL.openIcon = abierto;
			</cfif>
			<cfloop query="rsPeriodoLectivo">
				var datoPL = new WebFXTreeItem("Ciclo: #Replace(rsPeriodoLectivo.PLnombre,chr(34),'''')&' del '&Replace(rsPeriodoLectivo.PLinicio,chr(34),'''')&' al '&Replace(rsPeriodoLectivo.PLfinal,chr(34),'''')#", "javascript:ProcesarPeriodosLectivo(0, '#rsPeriodoLectivo.CILcodigo#', '#rsPeriodoLectivo.PLcodigo#', '#rsPeriodoLectivo.CILtipoCicloDuracion#');");
				datoCIL.add(datoPL);
				<cfif rsPeriodoLectivo.PLcodigo EQ form.PLcodigo>
					<cfif form.PEcodigo EQ "" AND form.PMcodigo EQ "" >
					datoPL.icon = abierto;
					datoPL.openIcon = abierto;
					</cfif>
					<cfif rsPeriodoLectivo.CILtipoCicloDuracion EQ "L">
						var datoPM = new WebFXTreeItem("(Agregar nuevo Período de Matricula)", "javascript:AgregarPeriodoMatricula(0, '#rsPeriodoLectivo.CILcodigo#', '#rsPeriodoLectivo.PLcodigo#', '','#rsPeriodoLectivo.CILtipoCicloDuracion#');");
						datoPL.add(datoPM);
						datoPM.icon = agregar;
						datoPM.openIcon = agregar;
						var datoPM = new WebFXTreeItem("(Actualizar Tarifas del Período)", "javascript:TarifasPeriodoMatricula(0, '#rsPeriodoLectivo.CILcodigo#', '#rsPeriodoLectivo.PLcodigo#', '', '#rsPeriodoLectivo.CILtipoCicloDuracion#');");
						datoPE.add(datoPM);
						datoPM.icon = dinero;
						datoPM.openIcon = dinero;
						<cfloop query="rsPeriodoMatricula">
							var datoPM = new WebFXTreeItem("Matricula #Replace(rsPeriodoMatricula.PMtipo,chr(34),'''')# del #Replace(rsPeriodoMatricula.PMinicio,chr(34),'''') & ' al ' & Replace(rsPeriodoMatricula.PMfinal,chr(34),'''') & ' '#", "javascript:ProcesarPeriodoMatricula(0, '#rsPeriodoMatricula.CILcodigo#', '#rsPeriodoMatricula.PLcodigo#', '', '#rsPeriodoMatricula.PMcodigo#', '#rsPeriodoMatricula.PMsecuencia#','#rsPeriodoMatricula.CILtipoCicloDuracion#');");
							datoPL.add(datoPM);
							<cfif rsPeriodoMatricula.PMcodigo EQ form.PMcodigo>
							datoPM.icon = flecha;
							datoPM.openIcon = flecha;
							<cfelse>
							datoPM.icon = blanco;
							datoPM.openIcon = blanco;
							</cfif>
						</cfloop> 
					<cfelseif rsPeriodoLectivo.CILtipoCicloDuracion EQ "E">
						<cfloop query="rsPeriodoEvaluacion">
							var datoPE = new WebFXTreeItem("Período: #Replace(rsPeriodoEvaluacion.PEnombre,chr(34),'''')#", "javascript:ProcesarPeriodoEvaluacion(0, '#rsPeriodoEvaluacion.CILcodigo#', '#rsPeriodoEvaluacion.PLcodigo#', '#rsPeriodoEvaluacion.PEcodigo#', '#rsPeriodoEvaluacion.CILtipoCicloDuracion#');");
							datoPL.add(datoPE);
							<cfif rsPeriodoEvaluacion.PEcodigo EQ form.PEcodigo>
								datoPE.icon = abierto;
								datoPE.openIcon = abierto;
								var datoPM = new WebFXTreeItem("(Agregar nuevo Período de Matricula)", "javascript:AgregarPeriodoMatricula(0, '#rsPeriodoEvaluacion.CILcodigo#', '#rsPeriodoEvaluacion.PLcodigo#', '#rsPeriodoEvaluacion.PEcodigo#', '#rsPeriodoEvaluacion.CILtipoCicloDuracion#');");
								datoPE.add(datoPM);
								datoPM.icon = agregar;
								datoPM.openIcon = agregar;
								var datoPM = new WebFXTreeItem("(Actualizar Tarifas del Período)", "javascript:TarifasPeriodoMatricula(0, '#rsPeriodoEvaluacion.CILcodigo#', '#rsPeriodoEvaluacion.PLcodigo#', '#rsPeriodoEvaluacion.PEcodigo#', '#rsPeriodoEvaluacion.CILtipoCicloDuracion#');");
								datoPE.add(datoPM);
								datoPM.icon = dinero;
								datoPM.openIcon = dinero;
								<cfloop query="rsPeriodoMatricula">
									var datoPM = new WebFXTreeItem("Matricula #Replace(rsPeriodoMatricula.PMtipo,chr(34),'''')# del #Replace(rsPeriodoMatricula.PMinicio,chr(34),'''') & ' al ' & Replace(rsPeriodoMatricula.PMfinal,chr(34),'''') & ' '#", "javascript:ProcesarPeriodoMatricula(0, '#rsPeriodoMatricula.CILcodigo#', '#rsPeriodoMatricula.PLcodigo#', '#rsPeriodoMatricula.PEcodigo#', '#rsPeriodoMatricula.PMcodigo#', '#rsPeriodoMatricula.PMsecuencia#','#rsPeriodoMatricula.CILtipoCicloDuracion#');");
									datoPE.add(datoPM);
									<cfif rsPeriodoMatricula.PMcodigo EQ form.PMcodigo>
									datoPM.icon = flecha;
									datoPM.openIcon = flecha;
									<cfelse>
									datoPM.icon = blanco;
									datoPM.openIcon = blanco;
									</cfif>
								</cfloop> 
							</cfif>
						</cfloop>
					</cfif>
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
		<input type="hidden" name="PMcodigo" value="<cfif isdefined('Form.PMcodigo')>#Form.PMcodigo#</cfif>">
		<input type="hidden" name="PMtipo" value="<cfif isdefined('Form.PMtipo')>#Form.PMtipo#</cfif>">	
		<input type="hidden" name="PMsecuencia" value="<cfif isdefined('Form.PMsecuencia')>#Form.PMsecuencia#</cfif>">		
		<input type="hidden" name="CILtipoCicloDuracion" value="<cfif isdefined('Form.CILtipoCicloDuracion')>#Form.CILtipoCicloDuracion#</cfif>">		
		<input type="hidden" name="modo" value="CAMBIO">
	</form>
</cfoutput>
