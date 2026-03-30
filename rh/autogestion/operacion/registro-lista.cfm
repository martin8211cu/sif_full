<cfquery name="rsMarcas" datasource="#session.dsn#">
	select RHCMid,tipomarca,
	<cf_dbfunction name="date_format" args="fechahoramarca,DD/MM/YYYY"> as fecha,
	<cf_dbfunction name="date_format"  args="fechahoramarca,HH:MI"> as hora,
	fechahoramarca
	from RHControlMarcas
	where registroaut=0
	and Ecodigo=#session.Ecodigo#
	and DEid=#form.DEid#
</cfquery>


<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" 
				query="#rsMarcas#"
				columnas="RHCMid,tipomarca,fechahoramarca,fecha,hora"
				desplegar="tipomarca,fecha,hora"
				etiquetas="Tipo, Fecha,Hora"
				formatos="S,S,S"
				align="left,left,left"
				ira="registro.cfm"
				form_method="post"	
				showEmptyListMsg="yes"
				keys="RHCMid"
				incluyeForm="yes"
				formName="formLista"
				PageIndex="1"
				MaxRows="5"	/>