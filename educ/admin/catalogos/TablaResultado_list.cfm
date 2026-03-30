<cfinvoke 
	 component="educ.componentes.pListas"
	 method="pListaEdu"
	 returnvariable="pListaPlan">
		<cfinvokeargument name="tabla" value="TablaResultado "/>
		<cfinvokeargument name="columnas" value="TRnombre  as TRnombre_lista, convert(varchar,TRcodigo) as TRcodigo"/>
		<cfinvokeargument name="desplegar" value="TRnombre_lista"/>
		<cfinvokeargument name="etiquetas" value="Tipo Aprobación"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# order by TRnombre"/>
		<cfinvokeargument name="align" value="left"/>
		<cfinvokeargument name="ajustar" value="N"/>,
		<cfinvokeargument name="irA" value="TablaResultado.cfm"/>
		<cfinvokeargument name="botones" value="Nuevo"/>
		<cfinvokeargument name="debug" value="N"/>
</cfinvoke>
