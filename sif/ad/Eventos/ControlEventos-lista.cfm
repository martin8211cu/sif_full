
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
		<cfinvokeargument name="query" 				value="#rsEvento#"/>
		<cfinvokeargument name="desplegar" 			value="TEVDescripcion,CEVDescripcion,FechaEvento"/>
		<cfinvokeargument name="etiquetas" 			value="Tipo Evento, Descripcion, Fecha del Evento"/>
		<cfinvokeargument name="formatos" 			value="S,S,D"/>
		<cfinvokeargument name="align" 				value="left,left,left"/>
		<cfinvokeargument name="formName" 			value="ValoreVariables"/>
		<cfinvokeargument name="checkboxes" 		value="S"/>
		<cfinvokeargument name="keys" 				value="CEVid"/>
		<cfinvokeargument name="ira" 				value="#CurrentPage#"/>
		<cfinvokeargument name="MaxRows" 			value="10"/>
		<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
		<cfinvokeargument name="PageIndex" 			value="1"/>
		<cfinvokeargument name="mostrar_filtro" 	value="true"/>
</cfinvoke>

<div align="center"><input name="NUEVO" class="btnNuevo" value="Nuevo" type="submit" onClick="javascript: NuevoEvento()"/></div>
<script language="javascript" type="text/javascript">
	function NuevoEvento(){
		location.href="<cfoutput>#PaginaInicial#</cfoutput>?Nuevo=true";
	}
</script>