<cfparam name="modo_errores" default="">
<cfinclude template="lista-query.cfm">

	<cf_templateheader title="#titulo#">
	<cf_web_portlet_start titulo="#titulo#">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<form action="index.cfm" style="margin:0">
	<cfoutput>
	<input type="hidden" name="modo_errores" value="#HTMLEditFormat(modo_errores)#" />
	</cfoutput>
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsProductos#"/>
			<cfinvokeargument name="cortes" value=""/>
			<cfinvokeargument name="desplegar" value="ContractNo, Documento, NumeroSocio, CodigoItem, FechaDocumento, VoucherNo, PrecioTotal, ImporteImpuesto, CodigoMoneda, Modulo, CodigoTransacion #err_desplegar#"/>
			<cfinvokeargument name="etiquetas" value="Contrato, Documento, Socio, Producto, Fecha Documento, No.Trade, Importe, Iva, Moneda, Módulo, Tipo Trans. #err_etiquetas#"/>
			<cfinvokeargument name="formatos" value="S,S,S,S,D,S,M,M,S,S,S #err_formatos#"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N,N,N,N,N #err_ajustar#"/>
			<cfinvokeargument name="align" value="left,left,left,left,left,left,right,right,left,left,left #err_align#"/>
			<cfinvokeargument name="lineaRoja" value=""/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="index.cfm"/>
			<cfinvokeargument name="MaxRows" value="20"/>
			<cfinvokeargument name="incluyeform" value="false"/>
			<cfinvokeargument name="PageIndex" value="1"/>
			<cfif modo_errores is '1'>
			<cfinvokeargument name="botones" value="Aplicar,Imprimir,Lista">
			<cfinvokeargument name="EmptyListMsg" value="- No hay registros de error -"/>
			<cfelse>
			<cfinvokeargument name="botones" value="Aplicar,Imprimir,Errores,Regresar">
			<cfinvokeargument name="EmptyListMsg" value="- No hay registros por aplicar -"/>
			</cfif>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="showEmptyListMsg" value="True"/>
			<cfinvokeargument name="Keys" value=""/>
		</cfinvoke>
	</form>
	<cf_web_portlet_end>
	
<cfif modo_errores neq '1'>
<cfoutput>
	<script type="text/javascript">
		document.lista.btnErrores.value = 
			'(<cfif rsCantidadErrores.cant eq "0">no hay<cfelse>#rsCantidadErrores.cant#</cfif>)' +
			' Errores';
	</script>
</cfoutput>
</cfif>	
	<cf_templatefooter>
