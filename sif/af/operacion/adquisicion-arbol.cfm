<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>

<table width="250"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
<!--- Consulta Detalle de Activos en Proceso de Aquisicion para una línea de Adquisición --->
<cfquery name="rsActivosAdq" datasource="#Session.DSN#">
	select a.DAlinea, 
		b.EAdescripcion, 
		b.Ocodigo, 
		b.SNcodigo, 
		case b.EAstatus when 0 then 'En Proceso' when 1 then 'Listo para Aplicar' when 2 then 'Aplicado' else 'Desconocido' end as EAstatus,
		b.Mcodigo,
		b.EAtipocambio
	from DAadquisicion a
	inner join EAadquisicion b
	on b.Ecodigo = a.Ecodigo
	  and b.EAcpidtrans = a.EAcpidtrans
	  and b.EAcpdoc = a.EAcpdoc
	  and b.EAcplinea = a.EAcplinea
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.EAcpidtrans = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EAcpidtrans#">
		and b.EAcpdoc = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EAcpdoc#">
		and b.EAcplinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAcplinea#">
</cfquery>
<!--- Consulta Detalle de Separación de Activos Adquiridos para una línea de Adquisición --->
<cfquery name="rsDSActivosAdq" datasource="#Session.DSN#">
	select DAlinea, lin, DSdescripcion
	from DSActivosAdq
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and EAcpidtrans = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EAcpidtrans#">
		and EAcpdoc = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EAcpdoc#">
		and EAcplinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAcplinea#">
</cfquery>
<!--- Funciones de funcionamiento y pintado del Árbol de Activos para una línea de Adquisición --->
<script language="Javascript">
	function Procesar(lin, EAcpidtrans, EAcpdoc, EAcplinea, DAlinea) {
		document.arbol.lin.value=lin;
		document.arbol.EAcpidtrans.value=EAcpidtrans;
		document.arbol.EAcpdoc.value=EAcpdoc;
		document.arbol.EAcplinea.value=EAcplinea;
		document.arbol.DAlinea.value=DAlinea;
		document.arbol.submit();
	}	
</script>

<!---Pintado del Árbol--->
<script language="JavaScript" src="/cfmx/sif/js/xtree/xtree.js"></script>	
<script language="JavaScript">
<cfoutput>
	//declara variables auxiliares
	var Funcion = "adquisicion-lista#LvarPar#.cfm";
	var texto = #DE(JSStringFormat(rsActivosAdq.EAdescripcion))#;
	//declara el objeto y crea el elemento raíz
	var tree = new WebFXTree(texto,Funcion);
	//define comportamiento del objeto tree
	tree.setBehavior('explorer');
	tree.icon = '/cfmx/sif/imagenes/Computer16x16.gif';
	tree.openIcon = '/cfmx/sif/imagenes/Computer16x16.gif';
	//ciclo a través del detalle de activos
	<cfloop query="rsActivosAdq">
		//consulta los detalles de separación de la línea de detalle
		<cfquery name="DSActivos" dbtype="query">
			select DAlinea, lin, DSdescripcion
			from rsDSActivosAdq
			where DAlinea = #rsActivosAdq.DAlinea#
		</cfquery>
		//prepara variables auxiliares para crear tree item
		Funcion = "javascript:Procesar(0,'#PreserveSingleQuotes(Form.EAcpidtrans)#', '#PreserveSingleQuotes(Form.EAcpdoc)#', #Form.EAcplinea#, #rsActivosAdq.DAlinea#);";
		texto = "#PreserveSingleQuotes(rsActivosAdq.EAdescripcion)# (#rsActivosAdq.DAlinea#)";
		//crea el tree item de la línea de detalle
		var treeItem#rsActivosAdq.DAlinea# = new WebFXTreeItem(texto,Funcion);
		treeItem#rsActivosAdq.DAlinea#.icon='/cfmx/sif/imagenes/Hardware16x16.gif';
		treeItem#rsActivosAdq.DAlinea#.openIcon='/cfmx/sif/imagenes/Hardware16x16.gif';
		tree.add(treeItem#rsActivosAdq.DAlinea#);
		//ciclo para agregar detalles de separación a las lista de detalles
		<cfloop query="DSActivos">
			//prepara variables auxiliares para crear un tree item hijo del tree item de la línea de detalle para este detalle de separación
			Funcion="javascript:Procesar(#lin#, '#PreserveSingleQuotes(Form.EAcpidtrans)#', '#PreserveSingleQuotes(Form.EAcpdoc)#', #Form.EAcplinea#, #DSActivos.DAlinea#);";
			texto="#DSActivos.CurrentRow#-#Replace(DSdescripcion,chr(34),'''')#";
			//crea el treeitem de la linea de detalle de separación
			var dato#DSActivos.DAlinea# = new WebFXTreeItem(texto, Funcion);
			<cfif isdefined("Form.lin") and len(trim(Form.lin)) and Form.lin EQ DSActivos.lin>
				dato#DSActivos.DAlinea#.icon= '/cfmx/sif/imagenes/arrow12.gif';
				dato#DSActivos.DAlinea#.openIcon='/cfmx/sif/imagenes/arrow12.gif';
			<cfelse>
				dato#DSActivos.DAlinea#.icon= webFXTreeConfig.fileIcon;
				dato#DSActivos.DAlinea#.openIcon=webFXTreeConfig.fileIcon;
			</cfif>
			treeItem#DSActivos.DAlinea#.add(dato#DSActivos.DAlinea#);
		</cfloop>
	</cfloop>
	document.write(tree);
</cfoutput>
</script>

<cfset LVarAction = 'adquisicion-cr.cfm'>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LVarAction = 'adquisicion-cr_JA.cfm'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>    
    <cfset LVarAction = 'adquisicion-cr_Aux.cfm'>
</cfif>

<!---form para ir por post al mantenimiento--->
<form action="<cfoutput>#LVarAction#</cfoutput>" name="arbol" method="post">
	<input type="hidden" name="EAcpidtrans" value="">
	<input type="hidden" name="EAcpdoc" value="">
	<input type="hidden" name="EAcplinea" value="">
	<input type="hidden" name="DAlinea" value="">
	<input type="hidden" name="lin" value="">
</form>