<cfset rsFPCCconcepto = QueryNew("ID","VarChar")>
<cfset QueryAddRow(rsFPCCconcepto, 10)>
<cfset QuerySetCell(rsFPCCconcepto, "ID", "1", 1)><!---Otros--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "2", 2)><!---Concepto Salarial--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "3", 3)><!---Amortización de prestamos--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "4", 4)><!---Financiamiento--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "5", 5)><!---Patrimonio--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "6", 6)><!---Ventas--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "F", 7)><!---Activos--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "S", 8)><!---Servicio--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "A", 9)><!---Articulos de Inventario--->
<cfset QuerySetCell(rsFPCCconcepto, "ID", "P", 10)><!---Obras en Proceso--->
<cfset ListFPCCconceptoCon = right(ValueList(rsFPCCconcepto.ID), LEN(ValueList(rsFPCCconcepto.ID))-14)><!--- Lista de conceptos que requieren el "FPCCTablaC" diferente de nulo y vacio--->
<cfset ListFPCCconceptoSin = left(ValueList(rsFPCCconcepto.ID), LEN(ValueList(rsFPCCconcepto.ID))-6)><!--- Lista de conceptos que no requieren el "FPCCTablaC" --->

<cfset longuitud=30>
<cf_dbfunction name="sPart" 	args="FPCCdescripcion,1,#longuitud#" returnvariable="Spart_Desc">
<cf_dbfunction name="length"	args="FPCCdescripcion" 		returnvariable="Len_Desc">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif isdefined('url.codigo')>
	<cfparam name="url.formName" default="form1">
	<cfparam name="url.name" default="concepto">
	<cfif len(trim(url.codigo))>
		<cfquery datasource="#session.dsn#" name="rsConcepto">
			select FPCCconcepto, FPCCtipo, FPCCid, FPCCcodigo, #Spart_Desc#  #_Cat# case when #Len_Desc# > #longuitud# then '...' else '' end  as FPCCdescripcion, FPCCcomplementoC, FPCCcomplementoP, FPCCidPadre
			from FPCatConcepto as FPCatConcepto
			where Ecodigo = #session.Ecodigo# and FPCCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.codigo#">
			#preservesinglequotes(url.filtro)#
			<cfif url.ultimoNivel>
				and ((FPCCconcepto in(<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListFPCCconceptoCon#" list="yes">) and FPCCTablaC is not null) OR (FPCCconcepto in(<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListFPCCconceptoSin#" list="yes">) and (select count(1) from FPCatConcepto as hijos where hijos.Ecodigo = #session.Ecodigo# and hijos.FPCCidPadre = FPCatConcepto.FPCCid) = 0))
			</cfif>
			order by FPCCcodigo, FPCCdescripcion
		</cfquery>
		<cfoutput>
		<cfdump var="#rsConcepto#">
		<script language="javascript1.2" type="text/javascript">
			<cfif rsConcepto.recordcount>
				window.parent.document.#url.formName#.#url.name#.value="#rsConcepto.FPCCid#";
				window.parent.document.#url.formName#.#url.name#_codigo.value="#rsConcepto.FPCCcodigo#";
				window.parent.document.#url.formName#.#url.name#_descripcion.value="#rsConcepto.FPCCdescripcion#";
				<cfif isdefined("url.funcionT") and Len(Trim(url.funcionT))>
					<cfif find('()',url.funcionT) EQ 0>
						<cfset i = find('(',#url.funcionT#)>
						<cfset f = find(')',#url.funcionT#)>
						<cfset s = mid(url.funcionT,i+1,len(url.funcionT)-i-1)>
						<cfset Funcion = mid(#url.funcionT#,1,i)>
						<cfloop list="#s#" index="i">
							<cfset Funcion &="'"&evaluate("rsConcepto.#i#")&"',">
						</cfloop>
						<cfset Funcion =mid(Funcion,1,len(Funcion)-1)&")">
							window.parent.#Funcion#;
					<cfelse>
						window.parent.#url.funcionT#;
					</cfif>
				</cfif>
			<cfelse>
				window.parent.document.#url.formName#.#url.name#.value="";
				window.parent.document.#url.formName#.#url.name#_codigo.value="";
				window.parent.document.#url.formName#.#url.name#_descripcion.value="--- No existe dato ---";
			</cfif>
		</script>
		</cfoutput>
	<cfelse>
		<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			window.parent.document.#url.formName#.#url.name#.value="";
			window.parent.document.#url.formName#.#url.name#_codigo.value="";
			window.parent.document.#url.formName#.#url.name#_descripcion.value="";
		</script>
		</cfoutput>
	</cfif>
<cfelse>

<cfparam name="url.name" default="concepto">
<cfparam name="url.ultimoNivel" default="false">
<cfparam name="url.tabindex" default="">

<cfquery datasource="#session.dsn#" name="rsPadre">
	select 	FPCCid, FPCCtipo, FPCCcodigo, #Spart_Desc#  #_Cat# case when #Len_Desc# > #longuitud# then '...' else '' end  as FPCCdescripcion, FPCCidPadre, FPCCconcepto, FPCCTablaC,
	(select count(1) from FPCatConcepto as hijos where hijos.Ecodigo = #session.Ecodigo# and hijos.FPCCidPadre = FPCatConcepto.FPCCid) as cantHijos
	from FPCatConcepto  FPCatConcepto
	where Ecodigo = #session.Ecodigo# and FPCCidPadre is null
	#preservesinglequotes(url.filtro)#
	order by FPCCcodigo, FPCCdescripcion
</cfquery>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><cfoutput>#url.titulo#</cfoutput></title>
</head>
<cf_templatecss>
<body>
<link href="xtree/xtree.css" rel="stylesheet" type="text/css">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center" class="tituloAlterno"><cfoutput>#url.titulo#</cfoutput></td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td width="2%">&nbsp;</td>
		<td>
<script language="JavaScript" src="/cfmx/sif/js/xtree/xtree.js"></script>
<script language="JavaScript" type="text/javascript">
		var tree#url.tabindex# = new WebFXTree(" ", "");
		tree#url.tabindex#.setBehavior('explorer');
		tree#url.tabindex#.icon = '/cfmx/sif/js/xtree/images/blank.png';
		tree#url.tabindex#.openIcon = '/cfmx/sif/js/xtree/images/blank.png';
		<cfloop query="rsPadre">
			
			<cfif (ListFind(ListFPCCconceptoCon, FPCCconcepto) and len(trim(FPCCTablaC))) OR (ListFind(ListFPCCconceptoSin, FPCCconcepto) and cantHijos EQ 0)>
				<cfset icon = '/cfmx/sif/imagenes/Script.gif'>
			<cfelse>
				<cfset icon = '/cfmx/sif/imagenes/MasterDetail.gif'>
			</cfif>
			<cfset funcion="javascript:fnOK('#FPCCcodigo#');">
			<cfif url.ultimoNivel and (ListFind(ListFPCCconceptoCon, FPCCconcepto) and len(trim(FPCCTablaC))) OR (ListFind(ListFPCCconceptoSin, FPCCconcepto) and cantHijos EQ 0)>
				<cfset funcion="javascript:fnOK('#FPCCcodigo#');">
			<cfelseif url.ultimoNivel>
				<cfset funcion="">
			</cfif>
			var LvarSIS = new WebFXTreeItem("#FPCCcodigo#: #FPCCdescripcion#","#funcion#",tree#url.tabindex#,"#icon#","#icon#");
			<cfset hijos = fnGetHijos(FPCCid)>
		</cfloop>
		document.write(tree#url.tabindex#);
		tree#url.tabindex#.collapseAll();
		tree#url.tabindex#.expand();
		function fnOK(valor){
			<cfset funcion="">
			<cfif isdefined('funcionT') and Len(Trim(funcionT))>
				<cfset funcion="&funcionT=#funcionT#">
			</cfif>
			window.opener.traerDatos_#name#_popup(valor,"#funcion#");
			window.close();
		}
</script>
	</td>
	<td width="2%">&nbsp;</td>
</tr>
<tr>
	<td colspan="3">&nbsp;
		
	</td>
</tr>
<cfif url.mostrarAyuda>
<tr>
	<td width="2%">&nbsp;</td>
	<td colspan="3">
		<strong>Notas:</strong>
	</td>
	<td width="2%">&nbsp;</td>
</tr>
<tr>
	<td width="2%">&nbsp;</td>
	<td>
		<input type="image" src="/cfmx/sif/imagenes/MasterDetail.gif" name="ImgPadre"/> Nivel superior, no se han definido los atributos del concepto.
	</td>
	<td width="2%">&nbsp;</td>
</tr>
<tr>
	<td width="2%">&nbsp;</td>
	<td>
		<input type="image" src="/cfmx/sif/imagenes/Script.gif" name="ImgPadre"/> Nivel inferior, se han definido los atributos del concepto.
	</td>
	<td width="2%">&nbsp;</td>
</tr>
</cfif>
</table>
</body>
</html>
</cfoutput>
<cffunction name="fnGetHijos" returntype="query" access="private">
  	<cfargument name='idPadre'		type='numeric' 	required='true'>	
  	<cfquery datasource="#session.dsn#" name="rsSQL">
		select 	FPCCid,FPCCtipo, FPCCcodigo, #Spart_Desc#  #_Cat# case when #Len_Desc# > #longuitud# then '...' else '' end  as FPCCdescripcion, FPCCidPadre, FPCCconcepto, FPCCTablaC,
		(select count(1) from FPCatConcepto as hijos where hijos.Ecodigo = #session.Ecodigo# and hijos.FPCCidPadre = FPCatConcepto.FPCCid) as hijos
		from FPCatConcepto as FPCatConcepto
		where Ecodigo = #session.Ecodigo# and FPCCidPadre = #arguments.idPadre#
		#preservesinglequotes(url.filtro)#
		order by FPCCcodigo, FPCCdescripcion
	</cfquery>
	<cfloop query="rsSQL"> 
		<cfset funcion="javascript:fnOK('#FPCCcodigo#');">
		<cfif (ListFind(ListFPCCconceptoCon, FPCCconcepto) and len(trim(FPCCTablaC))) OR (ListFind(ListFPCCconceptoSin, FPCCconcepto) and hijos EQ 0)>
			<cfset icon = '/cfmx/sif/imagenes/Script.gif'>
		<cfelse>
			<cfset icon = '/cfmx/sif/imagenes/MasterDetail.gif'>
		</cfif>
		<cfif url.ultimoNivel and (ListFind(ListFPCCconceptoCon, FPCCconcepto) and len(trim(FPCCTablaC))) OR (ListFind(ListFPCCconceptoSin, FPCCconcepto) and hijos EQ 0)>
				<cfset funcion="javascript:fnOK('#FPCCcodigo#');">
		<cfelseif url.ultimoNivel>
				<cfset funcion="">
		</cfif>
		<cfif hijos>
			<cfoutput>
				var treeTemp = LvarSIS;
				var LvarMOD = new WebFXTreeItem("#FPCCcodigo#: #FPCCdescripcion#","#funcion#",LvarSIS,"#icon#","#icon#");
				LvarSIS = LvarMOD;
				<cfset hijos = fnGetHijos(FPCCid)>
				LvarSIS = treeTemp;
			</cfoutput>
		<cfelse>
			<cfoutput>
				var LvarMOD = new WebFXTreeItem("#FPCCcodigo#: #FPCCdescripcion#","#funcion#",LvarSIS,"#icon#","#icon#");
			</cfoutput>
		</cfif>
	</cfloop>
	<cfreturn rsSQL>
</cffunction>
</cfif>