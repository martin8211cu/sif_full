<!--- Cuenta los Errores Para indicarlo en el boton de Errores--->
<cfquery name="Errores" datasource="sifinterfaces">
	select count(mensajeerror) as TotalErrores
		from facturasProdPMI a1
		where mensajeerror is not null
		and sessionid=#session.monitoreo.sessionid#
</cfquery>
<cfif Errores.TotalErrores NEQ "">
	<cfset varErrores = Errores.TotalErrores>
<cfelse>
	<cfset varErrores = 0>
</cfif>

<cfquery name="rsProductos" datasource="sifinterfaces">
	select *, 'CP' as Modulo
	from sif_interfacesser..facturasProdPMI
	where mensajeerror is null
	and sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsProductos#"/>
	<cfinvokeargument name="cortes" value=""/>
	<cfinvokeargument name="desplegar" value="c_orden, c_docto_proveedor, i_empresa, c_producto, voucher_creation_date, voucher_num, f_importe, f_iva, voucher_curr_code , Modulo, c_tipo_folio"/>
	<cfinvokeargument name="etiquetas" value="Contrato, Documento, Socio, Producto, Fecha Voucher, No.Voucher, Importe, Iva, Moneda, Módulo, Tipo Trans."/>
	<cfinvokeargument name="formatos" value="S,S,S,S,D,S,M,M,S,S,S"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N,N,N,N,N"/>
	<cfinvokeargument name="align" value="left,left,left,left,left,left,right,right,left,left,left"/>
	<cfinvokeargument name="lineaRoja" value=""/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="formName" value=""/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="botones" value="Aplicar,Imprimir,Errores(#varErrores#),Regresar">
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="showEmptyListMsg" value="True"/>
	<cfinvokeargument name="EmptyListMsg" value="No existen registros a procesar"/>
	<cfinvokeargument name="Keys" value=""/>
</cfinvoke>
<!---<cfabort showerror="para query">--->

<script language="JavaScript" type="text/javascript">
	function funcAplicar()
		{
			if (confirm('¿Confirma aplicar los Documentos?, El proceso puede tardar algunos Momentos'))
				{return true;}
			else
				{return false;}
		}
</script>