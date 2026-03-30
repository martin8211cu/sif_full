<cfinvoke component="aspAdmin.Componentes.pListasASP" 
	  method="pLista" 
	  returnvariable="pListaTiposIdentif">
		<cfinvokeargument name="tabla" value="
				ClienteContratoPaquetes ccp
				, ClienteContrato cc
				, Paquete p"/>
		<cfinvokeargument name="columnas" value="
				convert(varchar, cc.cliente_empresarial) as cliente_empresarial
				, convert(varchar, ccp.COcodigo) as COcodigo					  
				, convert(varchar, ccp.PAcodigo) as PAcodigo					  					  
				, PAdescripcion
				, '' as modoCuentaContr"/>
		<cfinvokeargument name="desplegar" value="PAdescripcion"/>
		<cfinvokeargument name="etiquetas" value="Paquete"/>
		<cfinvokeargument name="formatos"  value=""/>
		<cfinvokeargument name="filtro" value="
					cliente_empresarial=#form.cliente_empresarial#
					and ccp.COcodigo=#form.COcodigo#
					and ccp.COcodigo=cc.COcodigo
					and ccp.PAcodigo=p.PAcodigo
					order by PAdescripcion"/>
		<cfinvokeargument name="align" value="left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="keys" value="COcodigo,PAcodigo,cliente_empresarial"/>
		<cfinvokeargument name="irA" value="cuentaContrato_SQL.cfm"/>
		<cfinvokeargument name="formName" value="form_listaPaqueteContrato"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="botones" value="Agregar"/>
		<cfinvokeargument name="funcionBorrar" value="borrarPaquete"/>
		<cfinvokeargument name="fparams" value="PAcodigo"/>
		<cfinvokeargument name="showLink" value="false"/>
</cfinvoke>				
		
<script language="JavaScript">
function funcAgregar(){
	<cfoutput>	
		document.form_listaPaqueteContrato.COCODIGO.value = "#form.COcodigo#";
		<cfif isdefined('form.COcodigo') and form.COcodigo NEQ ''>
			var params ="";
			params = "?form=formPaqueteXContrato&COcodigo=#form.COcodigo#&cliente_empresarial=#form.cliente_empresarial#";
			popUpWindow("paquete_conlis.cfm"+params,250,100,520,500);
		</cfif>
	</cfoutput>
	return false;
}
function agregarPaquete(Paq){
	document.form_listaPaqueteContrato.CLIENTE_EMPRESARIAL.value = <cfoutput>#form.cliente_empresarial#</cfoutput>;
	document.form_listaPaqueteContrato.COCODIGO.value = <cfoutput>#form.COcodigo#</cfoutput>;	
	document.form_listaPaqueteContrato.PACODIGO.value = Paq;
	document.form_listaPaqueteContrato.MODOCUENTACONTR.value = 'ALTA';	
	document.form_listaPaqueteContrato.submit();
}
function borrarPaquete(pacodigo){
	if (confirm("Desea borrar el paquete ?"))	{
		document.form_listaPaqueteContrato.CLIENTE_EMPRESARIAL.value = <cfoutput>#form.cliente_empresarial#</cfoutput>;
		document.form_listaPaqueteContrato.COCODIGO.value = <cfoutput>#form.COcodigo#</cfoutput>;	
		document.form_listaPaqueteContrato.MODOCUENTACONTR.value = 'BAJA';
		document.form_listaPaqueteContrato.PACODIGO.value = pacodigo;
		document.form_listaPaqueteContrato.submit();
	}
}

var popUpWin=0;
//Levanta el Conlis
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWin){
		if(!popUpWin.closed) 
			popUpWin.close();
	}
	popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
}
  
</script>