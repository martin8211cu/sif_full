<link href="/cfmx/sif/js/xtree/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="/cfmx/sif/js/xtree/xtree.js"></script>

<script language="JavaScript1.2">
function ProcesarDatos(lin, PCRid, PCRregla) {
	document.arbol.PCRid.value = PCRid;
	document.arbol.modo.value = "CAMBIO";
/*
	if (tree.getSelected() != null) {
		//alert(tree.getSelected().text+'***'+tree.getSelected().id);		
		s = new String (tree.getSelected().id);		
		s = s.substring(18,s.length);
		document.arbol.ItemId.value = s;
	}
	*/
	document.arbol.submit();
}
</script>

<cfquery name="rsvig" datasource="#Session.DSN#">
Select PCEMid, CPVid
from CPVigencia
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
  and CPVid   = <cfqueryparam value="#form.CPVid#" cfsqltype="cf_sql_numeric">
</cfquery>

<cfif rsvig.recordcount gt 0 and len(trim(rsvig.PCEMid))>
	<cfset V_PCEMid = rsvig.PCEMid>
</cfif>

<cfquery name="rs" datasource="#Session.DSN#">
	select PCRid, 
		PCEMid, 
		PCRref, 
		PCRregla, PCRvalida
	from PCReglas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
	  <cfif isdefined("V_PCEMid")>
		  and PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#V_PCEMid#">
	  </cfif>	
	order by PCRref
</cfquery>

<cfquery name="rsniv1" dbtype="query">
	select * from rs where (PCRref is null or PCRid = PCRref)
</cfquery>

<cfquery name="rsnivn" dbtype="query">
	select * from rs where (PCRref is not null and PCRref != PCRid) order by PCRid desc
</cfquery>

<script language="JavaScript">

	var arreglo  = new Array()
	var indice = 0
	<cfoutput>
		<cfloop query="rsnivn">
			arreglo[indice] = new Array('#PCRregla#', '#PCRref#', '#PCRid#', '0');
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

	function RaizArbol() {
		document.arbol.action = "ReglasXMascaraCuenta.cfm";
		document.arbol.modo.value = "ALTA";
		document.arbol.submit(); 
	}
	
	var Funcion = "javascript: RaizArbol();";
	var texto   = "";
	var imgraiz = "/cfmx/sif/imagenes/iindex.gif";
	var imgnormal = "/cfmx/sif/imagenes/start.gif";
	var imgselec = "/cfmx/sif/imagenes/stop.gif";
	var tree    = new WebFXTree("Lista de Reglas por Máscara",Funcion);

	tree.setBehavior('explorer');
	tree.icon = imgraiz;
	tree.openIcon = imgraiz;
	
	<cfoutput>
	<cfloop query="rsniv1">

		texto="#Replace(rsniv1.PCRregla,chr(34),'''')#";		
		Funcion="javascript:ProcesarDatos(0, #rsniv1.PCRid#, '#rsniv1.PCRregla#');";
		var dato0 = new WebFXTreeItem(texto, Funcion);
		dato0.icon = imgnormal;
		dato0.openIcon = imgnormal;
		
		var s = new String (dato0.id);
		s = s.substring(18,s.length);

		<cfif isdefined("Form.PCRid") and Form.PCRid NEQ "">			
			if ('#Form.PCRid#' == '#rsniv1.PCRid#') {				
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
								
					<cfif isdefined("Form.PCRid") and Form.PCRid NEQ "">			
						if ('<cfoutput>#Form.PCRid#</cfoutput>' == arreglo[j][2]) {
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

<form name="arbol" method="post" action="ReglasXMascaraCuenta.cfm">
	<input type="hidden" name="PCRref" value="">
	<input type="hidden" name="modo" value="">
	<input type="hidden" name="PCRid" value="">
	<input type="hidden" name="Cmayor" value="<cfoutput>#Form.Cmayor#</cfoutput>">
	<input type="hidden" name="PCEMid" value="<cfoutput>#Form.PCEMid#</cfoutput>">
	<cfif rsvig.recordcount gt 0>
		<input type="hidden" name="CPVid" value="<cfoutput>#rsvig.CPVid#</cfoutput>">
	</cfif>	
	<!---<input type="hidden" name="ItemId" value="">		--->
</form>

