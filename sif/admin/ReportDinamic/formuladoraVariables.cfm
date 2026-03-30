<cfquery name="rsVariables" datasource="#session.dsn#">
select DRDNombre, AnexoCon, DRDNegativo, AVid, ANHCid, DRDValor
	from DReportDinamic
 where ERDid  = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#url.ERDid#">
 and DRDNombre != <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="120"  	value="#url.DRDNombre#">
 and AnexoCon > 18 --No variables de texto
 and AnexoCon != 63 -- No para vaiables formuladas puede aver un error pues cual calculo primero??
</cfquery>
<cfquery name="rsFormula" datasource="#session.dsn#">
select DRDNombre, AnexoCon, DRDNegativo, AVid, ANHCid, DRDValor
	from DReportDinamic
 where ERDid  = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#url.ERDid#">
 and DRDNombre = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="120"  	value="#url.DRDNombre#">
</cfquery>
<table width="90%" align="center">
	<tr>
		<td>
            <div id="cajaMadre" style=" height:150px; width:600px;border-color: #CCCCCC; border-radius: 0pt 10px 10px 10px; border-style: solid; border-width: 1px;">
     			
            </div>
        </td>
        <td width="20%">
        	<div  style="border-color: #CCCCCC; height:150px; border-radius: 10px 10px 10px 10px; border-style: solid; border-width: 1px;">
        	<label> Variables </label><br/>
            <cfloop query="rsVariables">
            	<cfoutput>
            	<input type="button"  value="#rsVariables.DRDNombre#" onClick="insert('#rsVariables.DRDNombre#','variable')" > <br />
                </cfoutput>
            </cfloop>
            </div>
        </td>
    </tr>
    <tr>
    	<td align="center">
         <div    style="border-color: #CCCCCC; width:350px; border-radius: 10px 10px 10px 10px; border-style: solid; border-width: 1px;">
            <input type="button"  value="Suma" onClick="insert('|','operador')"><!---se cambia elvalor para enviarlo por url--->
            <input type="button"  value="Resta" onClick="insert('-','operador')">
            <input type="button"  value="Multiplicacion" onClick="insert('*','operador')">
            <input type="button"  value="Division" onClick="insert('/','operador')">
         </div>
        </td>
        <td>
        	<input type="button" value="Guardar" onclick="guardarCambios()" />
        </td>
    </tr>
</table>
<iframe frameborder="0" name="fra" height="100" width="300" src=""></iframe>
<script type="text/javascript" language="javascript">
var tipo="";

	function insert(DRDNombre,tipodato){
		if(tipodato==""|| tipodato!=tipo){
			resultadoActual = document.getElementById("cajaMadre");
			if(DRDNombre!='|'){
				resultadoActual.innerHTML +="<div id="+DRDNombre+" style='width:auto; float:left; border-color: #CCCCCC;  border-style: solid; border-width: 1px;' onClick='remover(this)'> "+DRDNombre+"</div>";
			}
			else{
				resultadoActual.innerHTML +="<div id="+DRDNombre+" style='width:auto; float:left; border-color: #CCCCCC;  border-style: solid; border-width: 1px;' onClick='remover(this)'> + </div>";
			}
			tipo = tipodato;
		}
		else{
			if(tipodato=="operador"){
				alert("Debe escoger una variable");
			}
			else{
				alert("Debe escoger un operador");
			}
		}
	}
	function remover(elemento){
		var padre = elemento.parentNode;
		padre.removeChild(elemento);
	}
	function guardarCambios(){
		resultadoFinal = document.getElementById("cajaMadre");
		var numeroDescendientes = resultadoFinal.childNodes.length;
		var result= "";
		for(i=1; i<numeroDescendientes; i++){
			result= result+resultadoFinal.childNodes[i].id;
		}
	 	document.all["fra"].src="/cfmx/sif/admin/ReportDinamic/ReportDinamic-sql.cfm?DRDValor="+result+"&ERDid=<cfoutput>#url.ERDid#</cfoutput>&DRDNombre=<cfoutput>#url.DRDNombre#</cfoutput>";
	}
	<cfif len(trim(rsFormula.DRDValor)) gt 0>
	/*function armaFormula(){*/
		resultadoActual = document.getElementById("cajaMadre");
		inicia = true; palabra="";
		var variable="<cfoutput>#rsFormula.DRDValor#</cfoutput>";
		for(i=0; i<variable.length; i++){
			ch = variable.charAt(i);
			if( palabra!=""&&ch=='+'||ch=='*'||ch=='/'||ch=='-' ){
				resultadoActual.innerHTML +="<div id="+palabra+" style='width:auto; float:left; border-color: #CCCCCC;  border-style: solid; border-width: 1px;' onClick='remover(this)'> "+palabra+"</div>";
				 palabra="";
			}
			if(ch=='+'){
				resultadoActual.innerHTML +="<div id='|' style='width:auto; float:left; border-color: #CCCCCC;  border-style: solid; border-width: 1px;' onClick='remover(this)'> + </div>";
			}
			else if(ch=='*'){
				resultadoActual.innerHTML +="<div id='*' style='width:auto; float:left; border-color: #CCCCCC;  border-style: solid; border-width: 1px;' onClick='remover(this)'> * </div>";
			}
			else if(ch=='/'){
				resultadoActual.innerHTML +="<div id='/' style='width:auto; float:left; border-color: #CCCCCC;  border-style: solid; border-width: 1px;' onClick='remover(this)'> / </div>";
			}
			else if(ch=='-'){
				resultadoActual.innerHTML +="<div id='-' style='width:auto; float:left; border-color: #CCCCCC;  border-style: solid; border-width: 1px;' onClick='remover(this)'> - </div>";
			}
			else if( palabra!=""&& i==variable.length-1){
				palabra = palabra+ch;
				resultadoActual.innerHTML +="<div id="+palabra+" style='width:auto; float:left; border-color: #CCCCCC;  border-style: solid; border-width: 1px;' onClick='remover(this)'> "+palabra+"</div>";
				 palabra="";
			}
			else{
				palabra = palabra+ch;
			}
			
		}
	/*}*/
	<!---armaFormula();--->
	</cfif>
 </script>