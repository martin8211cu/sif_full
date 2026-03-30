<cfquery name="rsReintegro" datasource="#session.dsn#">
	select CCHTAtranRelacionada,
	from CCHTransaccionesAplicadas 
	where CCHTtipo='GASTO' and CCHTAreintegro < 0 and CCHid= #url.CCHid#
</cfquery>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsReintegro#"
				desplegar="CCHTAtranRelacionada"
				etiquetas="Liquidacion"
				formatos="S"
				align="left"
				ira="CCHtransac_form.cfm"
				form_method="post"	
				showEmptyListMsg="yes"
				keys="CCHTAtranRelacionada"
				incluyeForm="yes"
				formName="formReintegro"
				PageIndex="3"
				MaxRows="5"	
				navegacion=""/>
	
