<cfoutput>
<link href="xtreee/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="xtreee/xtree.js"></script>
</cfoutput>
<cfparam name="form.LCid" default="">
<cfparam name="form.LCcod" default="">
<cfparam name="form.LCnombre" default="">
<cfparam name="form.LCidPadre" default="">
<cfparam name="form.modoLoc" default="">
<script language="JavaScript1.2">
//	function SOINarbol
</script>
<script language="JavaScript1.2">
	function ProcesarLocalidad(varLCid,varNombre,varCod,varLCidPadre) {										
		document.arbol.LCid.value = varLCid;
		document.arbol.LCidPadre.value = varLCidPadre;
		document.arbol.LCnombre.value = varNombre;
		document.arbol.LCcod.value = varCod;
		document.arbol.modoLoc.value = "CAMBIO";
		document.arbol.submit();
	}
</script>

<cfparam  name="form.modo" default="LISTA">

<cfquery name="rsProvincias" datasource="#session.DSN#">
	Select LCid,LCcod,LCnombre,DPnivel
	from Localidad
	where DPnivel = 1
		and LCidPadre is null
	order by LCcod,LCnombre
</cfquery>

<cfquery name="rsCantones" datasource="#session.DSN#">
	Select LCid,LCcod,LCnombre,DPnivel,LCidPadre
	from Localidad
	where DPnivel = 2
		and LCidPadre is not null
	order by LCcod,LCnombre
</cfquery>

<cfquery name="rsDistritos" datasource="#session.DSN#">
	Select LCid,LCcod,LCnombre,DPnivel,LCidPadre
	from Localidad
	where DPnivel = 3
		and LCidPadre is not null
	order by LCcod,LCnombre
</cfquery>

<cfoutput>
	<form name="arbol" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0">
		<input type="hidden" name="LCidPadre" value="">
		<input type="hidden" name="LCnombre" value="">
		<input type="hidden" name="LCcod" value="">
		<input type="hidden" name="LCid" value="">		
		<input type="hidden" name="modoLoc" value="">
		
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td align="center">
				&nbsp;
			</td>
		  </tr>		
		  <tr>
			<td align="center">
				<input type="submit" name="btnNuevo" value="Nueva Provincia">
			</td>
		  </tr>		  
		</table>
  </form>
</cfoutput>

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
	
	<cfloop query="rsProvincias">
	  <cfif isdefined('rsCantones') and rsCantones.recordCount GT 0>
		<cfquery name='rsCantonesXprov' dbtype='query'>
			Select LCid,LCcod,LCnombre,DPnivel,LCidPadre
			from rsCantones
			where LCidPadre = <cfqueryparam cfsqltype='cf_sql_numeric' value='#rsProvincias.LCid#'>
			order by LCcod,LCnombre
		</cfquery>	  
	  </cfif>
	  
		var LvarPROV = new WebFXTreeItem("#Replace(rsProvincias.LCnombre,chr(34),'''')#", "javascript:ProcesarLocalidad('#rsProvincias.LCid#', '#rsProvincias.LCnombre#', '#rsProvincias.LCcod#','');");
		tree.add(LvarPROV);
		LvarExpand = LvarPROV;
		LvarPROV.icon = LimgFolderOpen;
		LvarPROV.openIcon = LimgFolderOpen;
			
			<cfif isdefined('rsCantonesXprov') and rsCantonesXprov.recordCount GT 0>
				<cfloop query="rsCantonesXprov">
						var LvarCAN = new WebFXTreeItem("#Replace(rsCantonesXprov.LCnombre,chr(34),'''')#", "javascript:ProcesarLocalidad('#rsCantonesXprov.LCid#', '#rsCantonesXprov.LCnombre#', '#rsCantonesXprov.LCcod#','#rsCantonesXprov.LCidPadre#');");
						LvarPROV.add(LvarCAN);
						LvarExpand = LvarCAN;
						LvarCAN.icon = LimgFolderOpen;
						LvarCAN.openIcon = LimgFolderOpen; 		
					  	<cfif isdefined('rsDistritos') and rsDistritos.recordCount GT 0>
							<cfquery name='rsDistritosXcanton' dbtype='query'>
								Select LCid,LCcod,LCnombre,DPnivel,LCidPadre
								from rsDistritos
								where LCidPadre = <cfqueryparam cfsqltype='cf_sql_numeric' value='#rsCantonesXprov.LCid#'>
								order by LCcod,LCnombre
							</cfquery>	  
							<cfif isdefined('rsDistritosXcanton') and rsDistritosXcanton.recordCount GT 0>
								<cfloop query="rsDistritosXcanton">
									var LvarDIS = new WebFXTreeItem("#Replace(rsDistritosXcanton.LCnombre,chr(34),'''')#", "javascript:ProcesarLocalidad('#rsDistritosXcanton.LCid#', '#rsDistritosXcanton.LCnombre#', '#rsDistritosXcanton.LCcod#','#rsDistritosXcanton.LCidPadre#');");
									LvarCAN.add(LvarDIS);
									LvarExpand = LvarDIS;
									LvarCAN.icon = LimgFolderOpen;
									LvarCAN.openIcon = LimgFolderOpen; 							
								</cfloop>								
							</cfif>
					  	</cfif>
				</cfloop>			
			</cfif>
	</cfloop>		
	</cfoutput>

	document.write(tree);
	if (LvarExpand)	LvarExpand.expand();

	//tree.expandAll();

</script>