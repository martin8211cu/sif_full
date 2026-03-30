
<cfinvoke component="aspAdmin.Componentes.pListasASP" 
		  method="pLista" 
		  returnvariable="pListaTiposIdentif">
			<cfinvokeargument name="tabla" value="
					  PaqueteModulo pm
					, Paquete p
					, Modulo m"/>
			<cfinvokeargument name="columnas" value="
					  convert(varchar, pm.PAcodigo) as PAcodigo
					, rtrim(pm.modulo) as modulo
					, nombre
					, sistema
					, '' as modoModulo
					"/>
			<cfinvokeargument name="cortes" value="sistema"/>
			<cfinvokeargument name="desplegar" value="modulo,nombre"/>
			<cfinvokeargument name="etiquetas" value="Módulo, Nombre del Modulo"/>
			<cfinvokeargument name="formatos"  value=""/>
			<cfinvokeargument name="filtro" value="
						pm.PAcodigo =#form.PAcodigo#
					and activo = 1
					and pm.PAcodigo=p.PAcodigo
					and pm.modulo=m.modulo"/>
			<cfinvokeargument name="align" value="left,left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="keys" value="PAcodigo,modulo"/>
			<cfinvokeargument name="irA" value="paquete.cfm"/>
			<cfinvokeargument name="formName" value="form_listaPaqueteModulos"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="botones" value="Agregar"/>
			<cfinvokeargument name="funcionBorrar" value="borrarModulo"/>
			<cfinvokeargument name="fparams" value="PAcodigo,modulo"/>
			<cfinvokeargument name="showLink" value="false"/>
		</cfinvoke>				
<script language="JavaScript">
function funcAgregar()
{
	<cfoutput>	
	document.form_listaPaqueteModulos.PACODIGO.value = "#form.PAcodigo#";
	<cfif isdefined('form.PAcodigo') and form.PAcodigo NEQ ''>
		var params ="";
		params = "?form=formModXPaquete&PAcodigo=#form.PAcodigo#";
		popUpWindow("modulo_conlis.cfm"+params,250,100,520,500);
	</cfif>
	</cfoutput>
	return false;
}
function agregarModulo(modulo)
{
	document.form_listaPaqueteModulos.MODULO.value = modulo;
	document.form_listaPaqueteModulos.MODOMODULO.value = "ALTA";
	document.form_listaPaqueteModulos.action = "paquete_SQL.cfm";
	document.form_listaPaqueteModulos.submit();
}
function borrarModulo(PAcodigo, modulo)
{
	if (confirm("Desea borrar el módulo '"+modulo+"'?"))
	{
		document.form_listaPaqueteModulos.PACODIGO.value = PAcodigo;
		document.form_listaPaqueteModulos.MODULO.value = modulo;
		var LvarButton = fnCrearElemento(document.form_listaPaqueteModulos,"INPUT","hidden","BajaM","1","display:none;");
		document.form_listaPaqueteModulos.action = "paquete_SQL.cfm";
		document.form_listaPaqueteModulos.submit();
	}
}
function fnCrearElemento(LprmPadre,LprmTag,LprmType,LprmName,LprmValue,LprmStyle)
{
	var LvarElemento = document.createElement(LprmTag);
	LvarElemento.type = LprmType;
	LvarElemento.name = LprmName;
	LvarElemento.value = LprmValue;
	LprmPadre.appendChild(LvarElemento);
	return LvarElemento;
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