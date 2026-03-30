  <iframe name="frmUpdSede" id="frmUpdSede" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>

	<script language="javascript" type="text/javascript">
		function bajar(cod) {
			document.listaSedes.SCODIGO.value = cod;
			document.listaSedes._ActionTag.value = "pushDown";
			document.listaSedes.action = "sede_SQL.cfm";
			document.listaSedes.submit();
		}
		
		function subir(cod) {
			document.listaSedes.SCODIGO.value = cod;
			document.listaSedes._ActionTag.value = "pushUp";
			document.listaSedes.action = "sede_SQL.cfm";
			document.listaSedes.submit();
		}
	</script>
			  
	<cfinvoke component="educ.componentes.pListas" 
			  method="pListaEdu" 
			  returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="Sede"/>
		<cfinvokeargument name="columnas" value="convert(varchar,Scodigo) as Scodigo
				, Snombre
				, Scodificacion
				, Sprefijo
				, Sorden
				, '#Session.JSroot#/imagenes/iconos/array_up.gif' as upImg
				, '#Session.JSroot#/imagenes/iconos/array_dwn.gif' as downImg
				, '-1' as upDir
				, '1' as downDir"/>
		<cfinvokeargument name="desplegar" value="Scodificacion, Snombre, Sprefijo, upImg, downImg"/>
		<cfinvokeargument name="etiquetas" value="C&oacute;digo, Nombre, Prefijo Edificio, &nbsp;, &nbsp;"/>
		<cfinvokeargument name="formatos" value="V,V,V,IMG,IMG"/>
		<cfinvokeargument name="filtro" value=" Ecodigo = #session.Ecodigo# 
												order by Sorden, upper(Snombre)"/>
		<cfinvokeargument name="align" value="left,left,center,center,center"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="funcion" value=" , , ,subir,bajar"/>
		<cfinvokeargument name="fparams" value="Scodigo"/>
		<cfinvokeargument name="funcionByCols" value="true"/>
		<cfinvokeargument name="keys" value="Scodigo"/>
		<cfinvokeargument name="irA" value="Sede.cfm"/>
		<cfinvokeargument name="formName" value="listaSedes"/>
		<cfinvokeargument name="MaxRows" value="0"/>
		<cfinvokeargument name="botones" value="Nueva"/>		
		<cfinvokeargument name="debug" value="N"/>
	</cfinvoke>
				