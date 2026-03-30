<link href="/cfmx/sif/js/xtree/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="/cfmx/sif/js/xtree/xtree.js"></script>

<script language="JavaScript1.2">
function ProcesarDatos(lin, CFid, CFdescripcion) {
	document.arbol.CFid.value = CFid;	
	document.arbol.modo.value = "CAMBIO";

	if (tree.getSelected() != null) {
		//alert(tree.getSelected().text+'***'+tree.getSelected().id);		
		s = new String (tree.getSelected().id);
		s = s.substring(18,s.length);
		document.arbol.ItemId.value = s;
	}
	document.arbol.submit();
}
</script>

<!---
<cfquery name="rs" datasource="crm">
	select convert(varchar,CRMTEid1) as CFid, 
		   CRMRPdescripcion1 as CFdescripcion,
		   convert(varchar,CRMTEid2) as CFidresp
	from CRMRelacionesPermitidas
	where Ecodigo = 2
	order by CFidresp
</cfquery>
--->

<cfquery name="rs" datasource="minisif">
	select convert(varchar,CFid) as CFid, 
		   CFdescripcion as CFdescripcion,
		   convert(varchar,CFidresp) as CFidresp
	from CFuncional
	where Ecodigo = 1
	order by CFidresp
</cfquery>


<cfdump var="#rs#">

<cfquery name="rsniv1" dbtype="query">
	select * from rs where (CFidresp is null or CFid = CFidresp)
</cfquery>
<cfdump var="#rsniv1#">

<cfquery name="rsnivn" dbtype="query">
	select * from rs where (CFidresp is not null and CFidresp != CFid) order by CFid desc
</cfquery>
<cfdump var="#rsnivn#">

<script language="JavaScript">

	var arreglo  = new Array()
	var indice = 0
	<cfoutput>
		<cfloop query="rsnivn">
			arreglo[indice] = new Array('#CFdescripcion#', '#CFidresp#', '#CFid#', '0');
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

	var Funcion = "";
	var texto   = "";
	var imgraiz = "/cfmx/sif/imagenes/Web_Users.gif";
	var imgnormal = "/cfmx/sif/imagenes/usuario04_T.gif";
	var imgselec = "/cfmx/sif/imagenes/usuario01_T.gif";
	Funcion     = "CFuncional.cfm";
	var tree    = new WebFXTree("Lista de Centros Funcionales",Funcion);
	tree.setBehavior('explorer');
	tree.icon = imgraiz;
	tree.openIcon = imgraiz;
	
	<cfoutput>
	<cfloop query="rsniv1">

		texto="#Replace(rsniv1.CFdescripcion,chr(34),'''')#";		
		Funcion="javascript:ProcesarDatos(0, #rsniv1.CFid#, '#rsniv1.CFdescripcion#');";
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
	
	var padre = "";		
	while ( mas_datos( arreglo ) ){
		for ( var j=0; j<arreglo.length; j++ ){
			if ( arreglo[j][3] != '1' ){
				padre = buscar(arreglo[j][1]);
				if ( padre != null ){
					texto = arreglo[j][0] ;
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
	} // while
	
	document.write(tree);
</script>


<form name="arbol" method="post" action="CFuncional.cfm">
	<input type="hidden" name="CFidresp" value="">
	<input type="hidden" name="modo" value="CAMBIO">
	<input type="hidden" name="CFid" value="">
	<input type="hidden" name="ItemId" value="">		
</form>

