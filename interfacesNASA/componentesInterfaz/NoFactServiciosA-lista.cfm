<!--- Si no se definio el Modo de Visualizacion asigna el Mvista = 1 --->
<cfset ValidaModo = isdefined("Mvista") EQ 1>
<cfif ValidaModo EQ 0>
	<cfset Mvista = 1>
</cfif>

<cfif not isdefined("varCodICTS")>
	<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
		<cfset form.CodICTS = url.CodICTS>
		<cfset varCodICTS = form.CodICTS>
	<cfelseif isdefined("form.CodICTS")>
		<cfset varCodICTS = form.CodICTS>
	<cfelse>
		<cfset varCodICTS = "">
	</cfif>	
</cfif>

<!--- Cuenta los Errores Para indicarlo en el boton de Errores--->
<cfquery name="Errores" datasource="sifinterfaces">
	select count(mensajeError) as TotalErrores
		from PrevIntComprasEnc 
		where mensajeError <>'ok'	
        and i_empresa_prop=#varCodICTS#
</cfquery>
<cfif Errores.TotalErrores NEQ "">
	<cfset varErrores = Errores.TotalErrores>
<cfelse>
	<cfset varErrores = 0>
</cfif>

<!---Se agrega funcion para modo de vista con errores y sin errores --->

<cfif Mvista EQ 1>
	<cfquery name="rsProductos" datasource="sifinterfaces">
	<!--- fechavoucher --->
		select *, 'CP' as Modulo
		from PrevIntComprasEnc enc 
   		inner join PrevIntComprasDet det on enc.i_folio=det.i_folio
		where mensajeError ='ok'
         and enc.i_empresa_prop=#varCodICTS#
	</cfquery>
	<cfset btnMostrar = "Mostrar">
</cfif>

<cfif Mvista EQ 2>
	<cfquery name="rsProductos" datasource="sifinterfaces">
	<!--- fechavoucher --->
		select distinct acct_ref_num as orden,Documento as documento,acct_num as Nsocio, 
						cmdty_code as producto, max(title_tran_date) as fechavoucher, 
						trade_num as vouchernum, Total as importe, price_curr_code as moneda, tipo_modulo as modulo, 
						tipo_transaccion as tipotransaccion
		from nofactProdPMI a1
		where MensajeError is null
		and sessionid=#session.monitoreo.sessionid#
		group by sessionid,Documento,cmdty_code
	</cfquery>
	<cfset btnMostrar = "Ocultar">
</cfif>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsProductos#"/>
	<cfinvokeargument name="cortes" value=""/>
	<cfinvokeargument name="desplegar" value="orden, documento, Nsocio, producto, fechavoucher, vouchernum, modulo, tipotransaccion, importe, moneda"/>
	<cfinvokeargument name="etiquetas" value="Contrato, Documento, Socio, Producto, Fecha Propiedad, No.Trade, Módulo, Tipo Trans., Importe, Moneda"/>
	<cfinvokeargument name="formatos" value="S,S,S,S,D,S,S,S,M,S"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N,N,N,N"/>
	<cfinvokeargument name="align" value="left,left,left,left,left,left,left,left,right,right"/>
	<cfinvokeargument name="lineaRoja" value=""/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath( GetBaseTemplatePath())#?ModoV=#Mvista#&CodICTS=#varCodICTS#" />
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="formName" value=""/>
	<cfinvokeargument name="PageIndex" value="1"/>
<!---	<cfinvokeargument name="botones" value="Aplicar,Imprimir,Errores(#varErrores#),Regresar,#btnMostrar#_Doctos._Costo_Parcial_rev_ICTS">--->
	<cfinvokeargument name="botones" value="Aplicar,Errores(#varErrores#),Regresar">
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="showEmptyListMsg" value="True"/>
	<cfinvokeargument name="EmptyListMsg" value="No existen registros a procesar"/>
	<cfinvokeargument name="Keys" value=""/>
	<cfinvokeargument name="Navegacion" value="ModoV=#Mvista#&CodICTS=#varCodICTS#"/>
</cfinvoke>
	<script language="JavaScript" type="text/javascript">
		function funcAplicar()
		{
			<cfoutput>
				var #toScript(Mvista, "jVista")#;
			</cfoutput>
			if (jVista == "2")
			{
				if (confirm('Esta a punto de aplicar Documentos con Costo Parcial rev. ICTS. No se podran volver a generar desde la Interfaz ¿Esta seguro de aplicar?'))
					{<!---document.formwait.style.display = '';--->
					return true;}
				else
					{return false;}
			}
			else
			{
				if (confirm('¿Confirma aplicar los Documentos?, El proceso puede tardar algunos Momentos'))
					{<!---document.formwait.style.display = '';--->
					return true;}
				else
					{return false;}
			}
		}
	</script>

