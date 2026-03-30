<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Importar Pagos en Oxxo" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default="Selecciones un archivo para importar" returnvariable="LB_Archivo"/>

<cfset CRCPagosExt = "crc.Componentes.pago.CRCImporadorPagos">
<cfset CRCPagosExt = createObject("component","#CRCPagosExt#")>

<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<div align="center">
			<form name="form1" action="#" onsubmit="return validate(this);" method="post" enctype="multipart/form-data">
				<cfset PagosMetadata = CRCPagosExt.getPagoExtMetadata(true,session.dsn,session.ecodigo)>
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
				<input type="submit" value="Upload" name="submit">
			</form>

			<cfif isdefined('form.FILETOUPLOAD')>
				<cfset importe = true>
				<cftry>

					<!---
						Patron de digestion
						Ex. 
							[1]          [2]				[3]	   [4]			[5]							[6]						[7]
							1 ,La Rosita TRC            ,20180307,16:10,1200095362018031030000000,0000000000000000000000000,0000000005434.90

							[1] 1 							Tipo de linea
							[2] La Rosita TRC				Nombre del Cliente que realiza
							[3] 20180307					Fecha del Pago
							[4] 16:10						Hora del Pago
							[5] 1200095362018031030000000	Referencia del pago (Mismo numero generado en "CRCBarcodeGenerator.cfc - CreateBarcodeOxxoD")
									12							[2 Digitos]  Identificador del servicio
									000953644					[7 Digitos] Cuenta del Distribuidor
									20180310					[8 Digitos]  Fecha Limite
									3							[1 Digitos]  Digito Verificador
									0000000						[N Digitos]  Completar a 25 digitos
							[6] 0000000000000000000000000	Desconocido
							[7] 0000000005434.90			Monto del Pago
					--->

					<cfscript>
						montoTotal = 0;
						pagos =  [];
						myfile = FileOpen(form.FILETOUPLOAD, "read"); 
						while(NOT FileisEOF(myfile)) { 
							x = FileReadLine(myfile);
							
							line = ListToArray(x,',');
							if (ArrayLen(line) == 7 && line[1] != 2){ 
								pago = StructNew();
								pago.nombreUsuario = line[2];
								pago.fecha  = CreateDateTime(left(line[3],4), mid(line[3],5,2), mid(line[3],7,2), left(line[4],2), mid(line[4],4,2)  );
								pago.cuenta = mid(line[5],3,7);
								pago.monto  = LSParseNumber(line[7]); 
								arrayAppend(pagos, pago);
							}
							if (ArrayLen(line) == 7 && line[1] == 2){ 
								montoTotal  = LSParseNumber(line[7]); 
							}
							
						} 
						FileClose(myfile); 
					</cfscript>	
					
				<cfcatch>
					<cfset importe = false>
					<cfthrow message = "Archivo da&ntilde;ado, no se puede cargar.">
				</cfcatch>
				</cftry>
				<!---
				<cfdump var="#form#">
				<cfdump var="#pagos#" >
				--->
				<cfset result = CRCPagosExt.ImportarPagosExternos(pagos,form,montoTotal,"Oxxo")>
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
	function validate(form) {
		if(document.form1.CFcodigo.value == ''){ alert("Debe seleccionar un Centro Funcional"); return false;}

		return confirm("Esta seguro de que quiere importar estos pagos?");
	}

	function soloNumeros(e){
		var keynum = window.event ? window.event.keyCode : e.which;
		if ((keynum == 8) || (keynum == 46))
		return true;
		
		return /\d/.test(String.fromCharCode(keynum));
	}

</script>
