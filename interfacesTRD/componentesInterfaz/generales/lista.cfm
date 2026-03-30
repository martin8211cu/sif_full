<!--- ABG. 
		CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
		04 DE NOVIEMBRE DE 2008 --->
<cfparam name="modo_errores" default="">

<!--- Etiqueta para Indicar al Usuario la empresa que se esta ejecutando --->
<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset varCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset varCodICTS = form.CodICTS>
</cfif>	
<cfquery name="rsNombre" datasource="preicts">
	select min(acct_full_name) as acct_full_name
	from account
	where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
</cfquery>

<cfset etiquetaT = titulo & " #rsNombre.acct_full_name#">

<cfinclude template="lista-query.cfm">
<style type="text/css">
	input.factor {
		text-align:right;
		width:60px;
	}
</style>
<cfset MostrarFactor = (modo_errores neq "1") and (directorio is "swaps-nofact")>
<cfset MostrarCobertura =  (directorio is "swaps-nofact" or directorio is "swaps-fact")>

	<cf_templateheader title="#titulo#">
	<cf_web_portlet_start titulo="#etiquetaT#">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<form action="index.cfm" style="margin:0"  name="lista">
	<cfoutput>
	<input type="hidden" name="modo_errores" value="#HTMLEditFormat(modo_errores)#" />
	<input type="hidden" name="CodICTS" value="#varCodICTS#"/>
	</cfoutput>
	
	<table align="center" border="0" cellspacing="1" cellpadding="2" width="100%">
		<tr>
			<td class="tituloListas" align="left" valign="bottom">&nbsp;</td>
			<td class="tituloListas" align="left" valign="bottom"><strong >Contrato</strong></td>
			<td class="tituloListas" align="left" valign="bottom"><strong >Documento</strong></td>
			<cfif MostrarCobertura>
			<td class="tituloListas" align="right" valign="bottom"><strong >Cobertura</strong></td>
			</cfif>
			<td class="tituloListas" align="left" valign="bottom"><strong >Socio</strong></td>
			<td class="tituloListas" align="left" valign="bottom"><strong >Prod/Cpto</strong></td>
			<td class="tituloListas" align="left" valign="bottom"><strong >Fecha Documento</strong></td>
			<td class="tituloListas" align="left" valign="bottom"><strong >No.Trade</strong></td>
			<cfif MostrarFactor>
			<td class="tituloListas" align="right" valign="bottom"><strong >Factor</strong></td>
			</cfif>
			<td class="tituloListas" align="right" valign="bottom"><strong >Importe</strong></td>
			<cfif MostrarFactor>
			<td class="tituloListas" align="right" valign="bottom"><strong >Calculado</strong></td>
			</cfif>
			<td class="tituloListas" align="right" valign="bottom"><strong >Iva</strong></td>
			<td align="right" valign="bottom" class="tituloListas"><strong>Ret</strong></td>
			<td class="tituloListas" align="left" valign="bottom"><strong >Moneda</strong></td>
			<td class="tituloListas" align="left" valign="bottom"><strong >Módulo</strong></td>
			<td class="tituloListas" align="left" valign="bottom"><strong >Tipo Trans.</strong></td>
			<cfif modo_errores is "1"> 
			<td class="tituloListas" align="left" valign="bottom"><strong >Error</strong></td>
			</cfif>
		</tr>
		
		<cfoutput query="rsProductos" startrow="#StartRow#" maxrows="#PageSize#">
		<cfset className=ListGetAt('listaPar,listaNon', (CurrentRow Mod 2) + 1)>
		<tr class="#className#" onmouseover="this.className='#className#Sel';"
		onmouseout="this.className='#className#';" style="cursor:default">
			<td class="tituloListas" align="left" valign="top" style="vertical-align:text-top">#CurrentRow#.</td>
			<td align="left" valign="top" nowrap>#HTMLEditFormat(ContractNo)#</td>
			<td align="left" valign="top" nowrap>#HTMLEditFormat(Documento)#</td>
			<cfif MostrarCobertura>
			<td align="left" valign="top" nowrap>#HTMLEditFormat(cobertura)#</td>
			</cfif>
			<td align="left" valign="top" nowrap>#HTMLEditFormat(NumeroSocio)#</td>
			<td align="left" valign="top" nowrap>#HTMLEditFormat(CodigoItem)#</td>
			<td align="left" valign="top" nowrap>#DateFormat(FechaDocumento, 'dd/mm/yyyy')#</td>
			<td align="left" valign="top" nowrap>#HTMLEditFormat(VoucherNo)#</td>
			<cfif MostrarFactor>
			<td align="right" valign="top" nowrap>
			<cf_inputNumber name="factor#CurrentRow#"  value="#NumberFormat(factor, '0.0000')#"
				enteros="4" decimales="4" negativos="false" comas="yes"
				onchange="multiplicar(this, '#NumberFormat(PrecioTotal, ',0.00')#', #CurrentRow#)" >			</td>
			</cfif>
			<td align="right" valign="top" nowrap>#NumberFormat(PrecioTotal, ',0.00')#</td>
			<cfif MostrarFactor>
			<td align="right" valign="top" nowrap id="calculado#CurrentRow#">#NumberFormat(calculado, ',0.00')#</td>
			</cfif>
			<td align="right" valign="top" nowrap>#HTMLEditFormat(CodigoImpuesto)#</td>
			<td align="right" valign="top" nowrap>#HTMLEditFormat(CodigoRetencion)#</td>
			<td align="center" valign="top" nowrap>#HTMLEditFormat(CodigoMoneda)#</td>
			<td align="left" valign="top" nowrap>#HTMLEditFormat(Modulo)#</td>
			<td align="left" valign="top" nowrap>#HTMLEditFormat(CodigoTransacion)#</td>
			<cfif modo_errores is "1"> 
			<td align="left" valign="top">#HTMLEditFormat(MensajeError)#</td>
			</cfif>
		</tr>
		</cfoutput>
		<tr><td colspan="11" align="center">&nbsp;</td></tr>
		<tr><td colspan="11" align="center">
<cfoutput>

<cfif rsProductos.RecordCount is 0>
	<strong><cfif modo_errores is '1'>
		- No hay registros de error -
	<cfelse>
		- No hay registros por aplicar -
	</cfif></strong>
<cfelse>
<table border="0"><tr>
	<td><a href="javascript:navegar(1)">
	<img src="../../../sif/imagenes/First.gif" width="18" height="13" border="0" alt="Inicio"  /></a></td>
	<td><a href="javascript:navegar(#Max(1, StartRow - PageSize) #)">
	<img src="../../../sif/imagenes/Previous.gif" width="14" height="13" border="0" alt="Anterior" /></a></td>
	
	<td valign="middle" >
	[
	# NumberFormat( StartRow )#
	-
	#NumberFormat( Min ( StartRow + PageSize - 1, rsProductos.RecordCount))#
	/
	#NumberFormat(rsProductos.RecordCount)#
	]	</td>
	
	<td><a href="javascript:navegar(#Min(rsProductos.RecordCount, StartRow + PageSize)#)">
	<img src="../../../sif/imagenes/Next.gif" width="14" height="13" border="0" alt="Siguiente" /></a></td>
	<td><a href="javascript:navegar(#Max(1,rsProductos.RecordCount - rsProductos.RecordCount Mod PageSize + 1)#)">
	<img src="../../../sif/imagenes/Last.gif" width="18" height="13" border="0" alt="Final" /></a></td>
	</tr></table>
</cfif>
</cfoutput>
		</td>
		</tr>
		<tr><td colspan="11" align="center">&nbsp;</td></tr>
		<tr><td colspan="11" align="center">
			<cfif modo_errores is '1'>
				<cf_botones Values="Aplicar,Imprimir,Lista">
			<cfelse>
				<cfif rsCantidadErrores.cant is 0>
					<cfset errorText = 'no hay'>
				<cfelse>
					<!--- No poner separador decimal porque lo separa en dos botones --->
					<cfset errorText = NumberFormat(rsCantidadErrores.cant, '0')>
				</cfif>
				<cfif MostrarFactor>
					<cf_botones Names="btnGuardarFactor,btnAplicar,btnImprimir,btnErrores,btnRegresar"
						Values="Guardar,Aplicar,Imprimir,Errores (#errorText#),Regresar">
				<cfelse>
					<cf_botones Names="btnAplicar,btnImprimir,btnErrores,btnRegresar"
						Values="Aplicar,Imprimir,Errores (#errorText#),Regresar">
				</cfif>
			</cfif>
		</td></tr>
		</table>
	</form>
	<cf_web_portlet_end>
	
<script type="text/javascript">

	document.datos = {
		<cfoutput query="rsProductos" startrow="#StartRow#" maxrows="#PageSize#">
		r#CurrentRow#:{
			factor:'#NumberFormat(factor, ',0.0000')#',
			ID:'#NumberFormat(ID, '0')#',
			Consecutivo:'#NumberFormat(Consecutivo, '0')#'
			},
		</cfoutput>
		fin:0
	};
	
<cfoutput>
	function multiplicar(txtFactor, precioTotal, CurrentRow) {
		var sFactor = txtFactor.value.replace(/,/g,'');
		var sTotal = precioTotal.replace(/,/g,'');
		var factor = parseFloat(sFactor);
		var precioTotal = parseFloat(sTotal);
		var destino = document.getElementById('calculado' + CurrentRow);
		var resultado = (factor*precioTotal);
		destino.innerHTML = fm(resultado, 2);
		//?document.modificados.push(CurrentRow);
	}
	
	function funcbtnGuardarFactor(){
		guardar();
		return false;
	}
	
	function guardar() {
		var modificado = new Array();
		for (var i = #StartRow#; i <= #Min(StartRow + PageSize - 1, rsProductos.RecordCount)#; i++) {
			if (document.lista['factor'+i]) {
				// existe, procede la comparación
				if (document.datos['r'+i].factor != document.lista['factor'+i].value &&
					document.datos['r'+i].Consecutivo != -1 <!--- es -1 cuando no hay PMIINT_ID10 --->
					) {
					modificado.push(
						document.datos['r'+i].ID + '/' +
						document.datos['r'+i].Consecutivo + '/' +
						document.lista['factor'+i].value.replace(/,/g,'')
						);
				}
			}
		}
		window.open('index.cfm?CodICTS=#varCodICTS#&botonsel=btnGuardarFactor&StartRow=#StartRow#&modo_errores=#modo_errores#&modificado=' + escape(modificado.join()), 'frguardar' );
		return modificado.length;
	}
	
	function navegar(n){
	<cfif modo_errores neq '1'>
		location.href = 'index.cfm?CodICTS=#varCodICTS#&botonsel=btnLista&StartRow=' + n;
	<cfelse>
		location.href = 'index.cfm?CodICTS=#varCodICTS#&botonsel=btnErrores&StartRow=' + n;
	</cfif>
	}
	
</cfoutput>

	window.onbeforeunload = function(oEvent) {
		if(!oEvent)
			oEvent = window.event;
		if (guardar()) {
			oEvent.returnValue = "El factor se ha guardado automáticamente. Presione OK";
			//return("El factor se ha guardado automáticamente. Presione OK");
		}
	}
</script>
<script type="text/javascript" src="../../../sif/js/utilesMonto.js"></script>

	<iframe name="frguardar" src="about:blank" width="800" height="300" style="display:none">
	</iframe>
	
	<cf_templatefooter>
