<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Importar Pagos en Banco" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default="Selecciones un archivo para importar" returnvariable="LB_Archivo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Caja" Default="Caja" returnvariable="LB_Caja"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tarjeta" Default="Tarjeta" returnvariable="LB_Tarjeta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Zona" Default="Zona" returnvariable="LB_Zona"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CFuncional" Default="C. Funcional" returnvariable="LB_CFuncional"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Transaccion" Default="Transaccion" returnvariable="LB_Transaccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Moneda" Default="Moneda" returnvariable="LB_Moneda"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoCambio" Default="Tipo de Cambio" returnvariable="LB_TipoCambio"/>

<cfset CRCPagosExt = "crc.Componentes.pago.CRCImporadorPagos">
<cfset CRCPagosExt = createObject("component","#CRCPagosExt#")>

<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<div align="center">
			<form name="form1" action="#" method="post" enctype="multipart/form-data">
				<!--- Tag para loading --->
				<cf_loadingSIF>
				<cfset PagosMetadata = CRCPagosExt.getPagoExtMetadata(true,session.dsn,session.ecodigo, true)>
				<cfoutput>#PagosMetadata#</cfoutput>
				<br>
				<table>
					<tr>
						<td align="right"><cfoutput>#LB_Archivo#:&nbsp;</cfoutput> </td>
						<td >
							<input type="file" name="fileToUpload" id="fileToUpload" <!--- accept="text/plain, .txt" ---> required>
						</td>
					</tr>
				</table>
				<br/>
				<input type="submit" value="Upload" name="submit" onclick="return validate();">
			</form>

			<cfif isdefined('form.FILETOUPLOAD')>
				<cfset importe = true>
				<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
				<cfset val = objParams.GetParametroInfo('30300101').Valor>
				
				<cfif val eq ""><cfthrow message = "No se ha definido el Banco para Importar Pagos"></cfif>
				
				<cfif isDefined('form.esReferenciado')>
					<cfset cfcParser = createObject("component","crc.cobros.operacion.ImportarBancos.importaPagos")>
					<cfset _pagos = cfcParser.importaReferenciados(form.FILETOUPLOAD)>
				<cfelseif isDefined('form.noEsReferenciado')>
					<cfset cfcParser = createObject("component","crc.cobros.operacion.ImportarBancos.importaPagos")>
					<cfset cfcParser.importaNoReferenciados(form.FILETOUPLOAD, form)>
					<script>
						alert("Datos guardados correctamente");
						window.location.href='ImportarPagoBanco.cfm';
					</script>
					<cfabort>
				<cfelse>
					<cfset cfcParser = createObject("component","crc.cobros.operacion.ImportarBancos.importadores.#val#")>
					<cftry>
						<cfset _pagos = cfcParser.ParseFile(form.FILETOUPLOAD)>
					<cfcatch type="Convenio_Invalido">
						<cfset importe = false>
						<cfthrow message = "#cfcatch.message#">
					</cfcatch>
					<cfcatch type="any">
						<cfset importe = false>
						<cf_errorcode code = "0001" detail = "#cfcatch.detail#" msg = "Archivo da&ntilde;ado, no se puede cargar.">
					</cfcatch>
					</cftry>
				</cfif>

				<!---
				<cfdump var="#form#">
				<cfdump var="#pagos#" >
				--->
				
				<cfset result = CRCPagosExt.ImportarPagosExternos(_pagos.pagos, form, _pagos.montoTotal)>
				<cfset errores = listToArray(result,'¬')>
				<cfif arrayLen(errores) gt 0>
					<cfoutput>
						<div>
							<cfset tdstyle = "text-align: left; padding: 8px; border-bottom: 1px solid ##ddd; background-color: white;">
							<cfset thstyle = "#tdstyle# background-color: ##0C869C; color: white;">
							<table style="border-collapse: collapse; width: 70%;">
							<font size="5" color="red"> Reporte de Errores:</font>
							<font size="2" color="blue"><br>Todas las transacciones fueron aplicadas, salvo<br>las siguientes (pendientes de aplicar manualmente): </font>
								<tr>
									<th style="#thstyle#">Linea de Archivo</th>
									<th style="#thstyle#">Codigo</th>
									<th style="#thstyle#">No. Documento Creado</th>
									<th style="#thstyle#">Detalle de Error</th>
								</tr>
								<cfloop array="#errores#" item="it" index="id">
									<cfset error = listToArray(errores[id],'~') >
									<cfif ArrayLen(error) eq 4>
										<tr>
											<td style="#tdstyle#">#error[1]#</td>
											<td style="#tdstyle#">#error[2]#</td>
											<td style="#tdstyle#">#error[3]#</td>
											<td style="#tdstyle#">#error[4]#</td>
										</tr>
									</cfif>
								</cfloop>
							</table>
							<br>
						</div>
					</cfoutput>
				<cfelse>
					<cfoutput>
						<div>
							<font size="5" color="green"> Importacion completa</font>
							<font size="2" color="blue"><br>Todas las transacciones fueron aplicadas </font>
							<br>
						</div>
					</cfoutput>
				</cfif>

				<cfif importe>
					<script>
						alert("Fin de la Importacion");
					</script>
				</cfif>
				
			</cfif>


		</div>
	<cf_web_portlet_end>
<cf_templatefooter>

<script>
	$( document ).ready(function() {
		hideLoading();
	});
	function validate(form) {
		if(document.form1.CFcodigo.value == ''){ alert("Debe seleccionar un Centro Funcional"); return false;}
		
		if(confirm("Esta seguro de que quiere importar estos pagos?")){
			showLoading();
			return true;
		}else{
			return false;
		}
	}
	function referenciados(referenciado){
		if(referenciado == 1 && document.form1.noEsReferenciado.checked == true){
			document.form1.noEsReferenciado.checked = false;
		}
		else if(referenciado == 0 && document.form1.esReferenciado.checked == true){
			document.form1.esReferenciado.checked = false;
		}
	}

	function soloNumeros(e){
		var keynum = window.event ? window.event.keyCode : e.which;
		if ((keynum == 8) || (keynum == 46))
		return true;
		
		return /\d/.test(String.fromCharCode(keynum));
	}

</script>
