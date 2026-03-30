<link href="../../js/xtree/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../../js/xtree/xtree.js"></script>

<script language="JavaScript1.2">
function Procesar2(lin, Usucodigo, CMCnombre, CMCid) {
	document.arbol.CMCid.value = CMCid;	
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

<cfquery name="rs" datasource="#Session.DSN#">
	select
		CMCid, 
		CMCnombre,
		Usucodigo,
		CMCjefe 
	from CMCompradores where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by CMCjefe
</cfquery>

<cfquery name="rsniv1" dbtype="query">
	select * from rs where (CMCjefe is null or CMCjefe = Usucodigo)
</cfquery>

<cfquery name="rsnivn" dbtype="query">
	select * from rs where (CMCjefe is not null and CMCjefe != Usucodigo) order by Usucodigo desc
</cfquery>

<script language="JavaScript">

	var arreglo  = new Array()
	var indice = 0
	<cfoutput>
		<cfloop query="rsnivn">
			arreglo[indice] = new Array('#CMCnombre#', '#CMCjefe#', '#Usucodigo#', '0', '#CMCid#');
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
	Funcion     = "Compradores.cfm";
	var tree    = new WebFXTree("Lista de Compradores",Funcion);
	tree.setBehavior('explorer');
	tree.icon = imgraiz;
	tree.openIcon = imgraiz;
	
	<cfoutput>
	<cfloop query="rsniv1">
		texto="#Replace(rsniv1.CMCnombre,chr(34),'''')#";		
		Funcion="javascript:Procesar2(0, #rsniv1.Usucodigo#, '#rsniv1.CMCnombre#', #rsniv1.CMCid#);";
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
					Funcion = "javascript:Procesar2(0, " + arreglo[j][2] + ", '" + arreglo[j][0] + "', " + arreglo[j][4] + ");";								
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

<form name="arbol" method="post" action="Compradores.cfm">
	<input type="hidden" name="CMCjefe" value="">
	<input type="hidden" name="modo" value="CAMBIO">
	<input type="hidden" name="CMCid" value="">
	<input type="hidden" name="ItemId" value="">		
</form>