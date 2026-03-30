<cfparam name="Form.EScodigo" default="500000000000006">
<cfoutput>
<link href="#Session.JSroot#/js/xtree/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="#Session.JSroot#/js/xtree/xtree.js"></script>
</cfoutput>

<script language="JavaScript1.2">
	function ProcesarDatos(lin, CARcodigo, CARnombre) {
		document.arbol.CARcodigo.value = CARcodigo;
		//document.arbol.EScodigo.value = EScodigo;
		document.arbol.modo.value = "CAMBIO";
		
		if (tree.getSelected() != null) {
		alert(tree.getSelected().text+'***'+tree.getSelected().id);
			s = new String (tree.getSelected().id);
			document.arbol.ItemId.value = s;
		}
		
		document.arbol.submit();
	}
</script>

<cfquery name="rsNodoRoot" datasource="#Session.DSN#">
	select convert(varchar, EScodigo) as EScodigo, ESOnombre
	from EstructuraOrganizacional
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigo#">
</cfquery>

<cfquery name="rs" datasource="#Session.DSN#">
	select
		c.CARcodigo, c.CARcodificacion, c.CARnombre, 
		p.PEScodigo, p.PEScodificacion, p.PESnombre, 
		p.PEScodigoComun, 
		c.EScodigo
	from Carrera c, PlanEstudios p
	where c.EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EScodigo#">
	  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and c.CARcodigo *= p.CARcodigo
	order by c.CARcodificacion, p.PEScodigo, p.PEScodigoComun
</cfquery>
<!---<cfdump var="#rs#" label="rs">--->

<cfquery name="rsniv1" dbtype="query">
	select distinct CARcodigo, CARnombre, CARcodificacion 
	from rs 
	where EScodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNodoRoot.EScodigo#">
	order by CARcodigo, CARcodificacion
</cfquery>
<!---<cfdump var="#rsniv1#" label="rsniv1">--->

<cfquery name="rsnivn" dbtype="query">	
	select distinct PEScodigo, PESnombre, PEScodificacion, CARcodigo, CARnombre, CARcodificacion, PEScodigoComun
	from rs
	order by CARcodigo, CARcodificacion, PEScodificacion, PESnombre	
</cfquery>
<!---<cfdump var="#rsnivn#" label="rsnivn">--->

<script language="JavaScript">

	var arreglo  = new Array();
	var indice = 0;
	<cfoutput>
		<cfloop query="rsnivn">
			arreglo[indice] = new Array('#CARnombre#', '#EScodigo#', '#CARcodigo#', '0', '#PESnombre#', '#PEScodigo#', '#PEScodigoComun#');
			indice = indice + 1;
		</cfloop>
	</cfoutput>
	
	function mas_datos( parreglo ){
		// RESULTADO
		// Retorna la hilera dentro de (), y que contiene el codigo de usuario

		for ( var i=0; i<parreglo.length; i++ ){
			if ( parreglo[i][3] == "0" ){
				return true;
			}
		}
		
		return false;
	}

	function codigo ( ptexto ){
		// RESULTADO
		// Retorna la hilera dentro de (), y que contiene el codigo de usuario

		var texto = new String( ptexto );
		var ini = texto.indexOf( ','  );
		texto = texto.substring(ini+1,texto.length);
		var fin = texto.indexOf( ',' );
		texto = texto.substring(1,fin);		
		
		return texto;	
	}

	function buscar( hijo ){
		// RESULTADO
		// Busca en el manejador del arbol el padre para el item actual.
		// Retorna el id del padre.
		
		var texto = "";	
		var id    = "";
		for (var j=3;j<webFXTreeHandler.idCounter;j++) {
			texto  = webFXTreeHandler.all['webfx-tree-object-'+j].action;			
			id = codigo( texto );
			if ( id == hijo )
				return webFXTreeHandler.all['webfx-tree-object-'+j];			
		}
		return;
	}

	<cfoutput>
	var Funcion = "";
	var texto   = "";
	var imgraiz = "#Session.JSroot#/imagenes/estructura/web_users.gif";
	var imgnormal = "#Session.JSroot#/imagenes/iconos/leave_wht.gif";
	var imgselec = "/cfmx/sif/js/xtree/images/openfoldericon.png";
	var imgselec2 = "#Session.JSroot#/imagenes/iconos/leave_sel.gif";
	
	Funcion     = "CarrerasPlanes.cfm";
	var tree    = new WebFXTree("#rsNodoRoot.ESOnombre#",Funcion);
	tree.setBehavior('explorer');
	tree.icon = imgraiz;
	tree.openIcon = imgraiz;
	</cfoutput>
	
	<cfoutput>
	<cfloop query="rsniv1">

		texto="#Replace(rsniv1.CARnombre,chr(34),'''')#";		
		Funcion="javascript:ProcesarDatos(0, #rsniv1.CARcodigo#, '#rsniv1.CARnombre#');";
		var dato0 = new WebFXTreeItem(texto, Funcion);
		dato0.icon = imgnormal;
		dato0.openIcon = imgnormal;
		
		var s = new String (dato0.id);
		s = s.substring(18,s.length);
				
		<cfif isdefined("Form.ItemId") and Form.ItemId NEQ "">			
			if ('#Form.ItemId#' == s) {				
				dato0.icon = imgselec;
				dato0.openIcon = imgselec;
			}
		</cfif>		
		tree.add(dato0);
	</cfloop>		
	</cfoutput>
	
	var salir = 1;
	var padre = "";		
	while ( mas_datos( arreglo ) ){
		salir = salir + 1;
		var CARcodigo = "";
		for ( var j=0; j<arreglo.length; j++ ){
			if ( arreglo[j][3] != '1' ){			
				padre = buscar(arreglo[j][2]);
				/*
				alert("CARcodigo="+arreglo[j][2]+",CARnombre="+arreglo[j][0]
						+",PEScodigo="+arreglo[j][4]+",PESnombre="+arreglo[j][5]
						+",PEScodigoComun="+arreglo[j][6]);
				*/
				if ( padre != null){
					texto = arreglo[j][4];
					Funcion = "javascript:ProcesarDatos(0, " + arreglo[j][2] + ", '" + arreglo[j][0] + "');";								
					var dato0 = new WebFXTreeItem(texto, Funcion);
					
					var s1 = new String (dato0.id);
					s1 = s1.substring(18,s1.length);
								
					<cfif isdefined("Form.ItemId") and Form.ItemId NEQ "">			
						if ('<cfoutput>#Form.ItemId#</cfoutput>' == s1) {
							dato0.icon = imgselec;
							dato0.openIcon = imgselec;
						}

						else {
							dato0.icon = imgnormal;
							dato0.openIcon = imgnormal;											
						}						
					<cfelse>
						dato0.icon = imgnormal;
						dato0.openIcon = imgnormal;					
					</cfif>
					padre.add(dato0);					
					arreglo[j][3] = '1';
				} // if
			} //if
		} // for
		if (salir == 10) 
			break;
	} // while
	alert("salir="+salir);
	document.write(tree);
</script>


<form name="arbol" method="post" action="../../director/planAcademico/CarrerasPlanes.cfm">
	<input type="hidden" name="EScodigo" value="">
	<input type="hidden" name="modo" value="CAMBIO">
	<input type="hidden" name="CARcodigo" value="">
	<input type="hidden" name="root" value="0">
	<input type="hidden" name="ItemId" value="">
</form>

