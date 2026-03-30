<cfquery name="getContE" datasource="#Session.DSN#">
select ERepositorio from Empresa
where Ereferencia = #Session.Ecodigo#
</cfquery>

<cfset totalFiles = 0>
<cfset succesFiles = 0>
<cfset totalFilesExitosos = 0>
<cfset totalFilesNoExitosos = 0>
<cfset totalPagos = 0>
<cfset totalRepetidos = 0>
<cfset totalPagosRealizados = 0>
<cfset tabla = "">
<cfset armaTabla = "">



<cfset arrErros=ArrayNew(1)>
<cfset arrIdDocumento=ArrayNew(1)>
<cfset arrRespuesta=ArrayNew(1)>
<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio NEQ "1">
	<cfset ArrayAppend(arrErros, "No hay un repositorio de CFDI configurado")>
<cfelse>
	<cfset controles=StructNew()>

	<cfif isdefined("form.AFimagen")>


		<cfset controles["file0"]="#form.AFimagen#">
		<cfset controles["name0"]="#form.AFnombre#">

	<cfelse>
		<cfset vtfiles = 0>
		<cfset vtnames = 0>		
	
		<cfloop collection="#form#" item="vArch">
			<cfif Left(vArch,4) EQ "file">

				

				<cfset vtfiles = vtfiles +1>
				<cfset vFil = "file#vtfiles-1#">
				<!--- <cfdump var="#vFil#"> --->
				
				<cfset controles["file#vtfiles-1#"]="#form[vFil]#">
			</cfif>
			<cfif Left(vArch,4) EQ "name">
				<cfset vtnames = vtnames +1>
				<cfset vNam = "name#vtnames-1#">
				<!--- <cfdump var="#vNam#"> --->
				<cfset controles["name#vtnames-1#"]="#form[vNam]#">
			</cfif>
		</cfloop>
	</cfif>
	<cfloop collection="#controles#" item="vArchivo">
		<cfif Left(vArchivo,4) EQ "file">
			<!--- <cf_dump var="#controles#"> --->
			<cfset totalFiles = totalFiles +1>
			<cfset vFile = "name#Mid(vArchivo,5,Len(vArchivo)-4)#">
			<cfset vExt = "#Right(controles[vFile],3)#">
			<cfif Ucase(vExt) EQ "XML">
				<cfset paso="true">

				<cftry>
					<cfset strXML = StructNew()>
					<cfset strXML.SubTotal=0>
					<cfset strXML.Impuesto=0>
					<cfset strXML.RFCemisor="">
					<cfset strXML.Tipo = "">

					<CFFILE ACTION="READ" FILE="#controles[vArchivo]#" VARIABLE="xmlCode">
		            <CFSET archXML = XmlParse(xmlCode)>


					<cfset strXML.Tipo = archXML.Comprobante.XmlAttributes.tipoDeComprobante>



					<cftry>
						<cfset strXML.NombreEmisor=archXML.Comprobante.Emisor.XmlAttributes.nombre>
					<cfcatch type="any">

					</cfcatch>
					</cftry>

					  <cfif isdefined("archXML.Comprobante.Complemento.Pagos.Pago.DoctoRelacionado.XmlAttributes.Folio") AND isdefined("archXML.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.UUID")>

					  	<cfset totalFilesExitosos = totalFilesExitosos+1>
					  	<cfelse>
					  		<cfset totalFilesNoExitosos = totalFilesNoExitosos+1>
		               	</cfif>

					<cfset strXML.UUID = archXML.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.UUID>
					<cfset strXML.Total=archXML.Comprobante.XmlAttributes.total>

					<!--- Moneda --->
					<cftry>
						<cfif isdefined("archXML.Comprobante.XmlAttributes.Moneda")>
							<cfset vMoneda=archXML.Comprobante.XmlAttributes.Moneda>
							<cfif uCase(vMoneda) EQ "MXN" or uCase(vMoneda) EQ "MXP">
								<cfset vMoneda="MXP">
								<cfquery name="getMoneda" datasource="#Session.DSN#">
									select m.Mcodigo, m.Mnombre, m.Miso4217
									from Monedas m
									where upper(ltrim(rtrim(m.Miso4217))) = upper('#trim(vMoneda)#')
								</cfquery>
								<cfset vMcodigo = #getMoneda.Mcodigo#>
							<cfelse>
								<cfquery name="getMoneda" datasource="#Session.DSN#">
									select m.Mcodigo, m.Mnombre, m.Miso4217
									from Monedas m
									where upper(ltrim(rtrim(m.Miso4217))) = upper('#trim(vMoneda)#')
								</cfquery>
								<cfif isdefined("getMoneda.Mcodigo") and  getMoneda.Mcodigo NEQ '' >
									<cfset vMcodigo = #getMoneda.Mcodigo#>
								<cfelse>
									<cfset vMcodigo = -1>
								</cfif>
							</cfif>
						<cfelse>
							<cfset vMcodigo = -1>
						</cfif>
					<cfcatch type="any">

						<cfset vMcodigo = -1>
					</cfcatch>
					</cftry>
					<!--- Tipo de Cambio --->
					<cftry>
						<cfif isdefined("archXML.Comprobante.XmlAttributes.TipoCambio")>
							<cfset vTipoCambio=archXML.Comprobante.XmlAttributes.TipoCambio>
							<cfif vTipoCambio EQ 0><cfset vTipoCambio = "1.00"></cfif>
						<cfelse>
							<cfset vTipoCambio="1.00">
						</cfif>
					<cfcatch type="any">
						<cfset vTipoCambio="1.00">
					</cfcatch>
					</cftry>

					<cfset strXML.Mcodigo=vMcodigo>
					<cfset strXML.TipoCambio=vTipoCambio>

					<cfset strXML.RFCemisor=archXML.Comprobante.Emisor.XmlAttributes.rfc>

					<cftry>
					<cfset strXML.NombreReceptor=archXML.Comprobante.Receptor.XmlAttributes.nombre>
					<cfcatch type="any">

					</cfcatch>
					</cftry>
					<cfset strXML.RFCreceptor=archXML.Comprobante.Receptor.XmlAttributes.rfc>

		            <cfset ECalleNodes = xmlSearch(archXML,'/cfdi:Comprobante/cfdi:Emisor/cfdi:DomicilioFiscal')>
		            <cfif arraylen(ECalleNodes) GT 0>
						<cftry>
							<cfset strXML.PaisEmisor=archXML.Comprobante.Emisor.DomicilioFiscal.XmlAttributes.pais>
			                <cfset strXML.DireccionEmisor="Calle: #archXML.Comprobante.Emisor.DomicilioFiscal.XmlAttributes.calle#">
			                <cfset strXML.DireccionEmisor="#strXML.DireccionEmisor# No.: #archXML.Comprobante.Emisor.DomicilioFiscal.XmlAttributes.noExterior#">
			                <cfset strXML.DireccionEmisor="#strXML.DireccionEmisor# Colonia: #archXML.Comprobante.Emisor.DomicilioFiscal.XmlAttributes.colonia#">
			                <cfset strXML.DireccionEmisor="#strXML.DireccionEmisor# CP: #archXML.Comprobante.Emisor.DomicilioFiscal.XmlAttributes.codigoPostal#">
			                <cfset strXML.DireccionEmisor="#strXML.DireccionEmisor# Delegcion o Muncipio: #archXML.Comprobante.Emisor.DomicilioFiscal.XmlAttributes.municipio#">
						<cfcatch type="any">
							<cfset strXML.Impuesto = 0>

						</cfcatch>
						</cftry>
		            </cfif>

                     
		            	<cfif isdefined("form.PagosMultiples")>

		                <cfif isdefined("archXML.Comprobante.Complemento.Pagos.Pago.DoctoRelacionado.XmlAttributes.Folio")>

                            
		            	<cfset PagosNodes = xmlSearch(archXML,'/cfdi:Comprobante/cfdi:Complemento/pago10:Pagos/pago10:Pago/pago10:DoctoRelacionado ')>
					<cfset strXML.SubTotal=0>
					<cfset aPagos = ArrayNew(1)>
					<cfloop from="1" to="#arraylen(PagosNodes)#" index="i">
						<cfset stPagos = StructNew()>
					   	<cfset PagosXML = xmlparse(PagosNodes[i])>
						<cfset currentrow = i>
						  <cflog text="#PagosXML.DoctoRelacionado.XmlAttributes.IdDocumento#" type='information' file='myAppLog'>
					      <cflog text="#PagosXML.DoctoRelacionado.XmlAttributes.ImpPagado#" type='information' file='myAppLog'>
					      <cflog text="#strXML.RFCemisor#" type='information' file='myAppLog'>
					      <cflog text="#strXML.RFCreceptor#" type='information' file='myAppLog'>
					      <cflog text="#strXML.UUID# " type='information' file='myAppLog'>



					      <cftry>
						<cfstoredproc 
					    dataSource = "#Session.DSN#"
					    procedure = PagoFacturas>
					   <cfprocparam value="#strXML.RFCemisor#" cfsqltype="CF_SQL_VARCHAR">
					   <cfprocparam value="#strXML.RFCreceptor#" cfsqltype="CF_SQL_VARCHAR">
					   <cfprocparam value="#PagosXML.DoctoRelacionado.XmlAttributes.IdDocumento#"  cfsqltype="CF_SQL_VARCHAR">
					   <cfprocparam value="#strXML.UUID#" cfsqltype="CF_SQL_VARCHAR">
					   <cfprocparam value="#PagosXML.DoctoRelacionado.XmlAttributes.ImpPagado#"  cfsqltype="CF_SQL_MONEY">
					   	 <cfprocparam value="#Session.Ecodigo#"  cfsqltype="CF_SQL_INTEGER">
					   	<cfprocparam  variable="resultado" cfsqltype="CF_SQL_VARCHAR" type="out" >
					   	<cfprocparam  variable="documento" cfsqltype="CF_SQL_VARCHAR" type="out" >

					   



					      	</cfstoredproc>

							
					      	
						<cfcatch type="any">
							<cfdump var="Error al aejecutar el procedimiento">

						</cfcatch>

						</cftry>
						      <cfset totalPagos = totalPagos+1>

							<cfset ArrayAppend(arrIdDocumento,"#strXML.UUID#")>
						<cfif "#resultado#" eq 'EX'>
						       <cfset ArrayAppend(arrRespuesta, "R")>

						    </cfif>
						<cfif "#resultado#" eq 'SI'>
						       <cfset ArrayAppend(arrRespuesta, "S")>

						    </cfif>
						<cfif "#resultado#" eq 'NO'>
						       <cfset ArrayAppend(arrRespuesta, "N")>

						    </cfif>

				
					      

					</cfloop>	
						<cfset armaTabla =armaTabla & 
					'<tr>
        <td>'& controles[vFile] &'</td>
         <td>'&'SI</td>
          <td>'&"#documento#"&'</td>
         <td>  <table class="table  table-striped " > <tr>' >
						
					
						
					<cfloop from="1" to="#ArrayLen(arrRespuesta)#" index="m">

						<cfif #arrRespuesta[m]# eq 'S'>
							<cfset armaTabla =armaTabla & '<tr><td>'&arrIdDocumento[m]&'<td></tr>' >
					
				       </cfif>
			
				
		
		           </cfloop>
		           


		           	<cfset armaTabla =armaTabla & '</tr> </table></td>
         <td>  <table class="table  table-striped " >     <tr>'>
		        
		           <cfloop from="1" to="#ArrayLen(arrRespuesta)#" index="x">

						<cfif #arrRespuesta[x]# eq 'R'>
							<cfset armaTabla =armaTabla & '<tr><td>'&arrIdDocumento[x]&'<td></tr>' >
					
				       </cfif>
			
				
		
		           
		           </cfloop>
		           <cfset armaTabla =armaTabla & '</tr> </table></td>
         <td>  <table class="table  table-striped " >     <tr>'>
        
		           <cfloop from="1" to="#ArrayLen(arrRespuesta)#" index="r">

						<cfif #arrRespuesta[r]# eq 'N'>
							<cfset armaTabla =armaTabla & '<tr><td>'&arrIdDocumento[r]&'<td></tr>' >
					
				       </cfif>

		           </cfloop>
		           	<cfset armaTabla =armaTabla & '</tr> </table></td>
      </tr>' >
					
		
		<cfset arrIdDocumento=ArrayNew(1)>
<cfset arrRespuesta=ArrayNew(1)>

				
		            <cfset strXML.Pagos = 0>
		            <cfelse>
		            	<cfset totalFilesExitosos = totalFilesExitosos+1>
						<cfset strXML.Pagos = 1>
							<cfset armaTabla =armaTabla & 
					'<tr>
        <td>'& controles[vFile] &'</td>
         <td>'&'NO</td>
         <td>  <table class="table  table-striped " > <tr> <tr><td><td></tr></tr> </table></td>
         <td>  <table class="table  table-striped " >     <tr> <tr><td><td></tr></tr> </table></td>
         <td>  <table class="table  table-striped " >     <tr> <tr> <tr><td><td></tr></tr> </table></td>' >

					</cfif>
		            
		            




                     </cfif>



					<cfset ConceptoNodes = xmlSearch(archXML,'/cfdi:Comprobante/cfdi:Conceptos/cfdi:Concepto')>
					<cfset strXML.SubTotal=0>
					<cfset aConceptos = ArrayNew(1)>
					<cfloop from="1" to="#arraylen(ConceptoNodes)#" index="i">
						<cfset stConcepto = StructNew()>
					   	<cfset ConceptoXML = xmlparse(ConceptoNodes[i])>
						<cfset currentrow = i>
					    <cfset stConcepto.Cantidad = "#ConceptoXML.Concepto.XmlAttributes.cantidad#">
					    <cfset stConcepto.Descripcion = "#ConceptoXML.Concepto.XmlAttributes.descripcion#">
					    <cfset stConcepto.Importe = "#LSParseNumber(ConceptoXML.Concepto.XmlAttributes.importe)#">
					    <cfset strXML.SubTotal= strXML.SubTotal + stConcepto.Importe>
					    <cfset arrayappend(aConceptos ,stConcepto)>
					</cfloop>
		            <cfset strXML.Conceptos = aConceptos>

					<cfset EImpuestos = xmlSearch(archXML,'/cfdi:Comprobante/cfdi:Impuestos')>
					<cfif arraylen(EImpuestos) GT 0>
						<cftry>
							<cfset strXML.Impuesto = LSParseNumber(archXML.Comprobante.Impuestos.XmlAttributes.totalImpuestosTrasladados)>
						<cfcatch type="any">
							<cfset strXML.Impuesto = 0>

						</cfcatch>
						</cftry>
					<cfelse>
						<cfset strXML.Impuesto = 0>
					</cfif>


	            <cfcatch>
		            <cfset ArrayAppend(arrErros, "#controles[vFile]# : El  archivo no  es un CFDI v&aacute;lido")>
		            	<cfset armaTabla =armaTabla & 
					'<tr>
        <td>'& controles[vFile] &'</td>
         <td>'&'NO</td>
         <td>  <table class="table  table-striped " > <tr> <tr><td><td></tr></tr> </table></td>
         <td>  <table class="table  table-striped " >     <tr> <tr><td><td></tr></tr> </table></td>
         <td>  <table class="table  table-striped " >     <tr> <tr> <tr><td><td></tr></tr> </table></td>' >




					<!--- <cfset ArrayAppend(arrErros,cfcatch.message)> --->
		            <cfset paso="false">
	            </cfcatch>
		        </cftry>
			<cfelse>
				<cfset ArrayAppend(arrErros, "#controles[vFile]# : El archivo no es un XML")>

			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfoutput>
<cfif "#totalFilesExitosos#" gt 0>


		<cfoutput>

			
			<input type="hidden" id="Guardar" name="Guardar" value="Guardar">
			<input type="hidden" id="hTotales" name="hTotales" value="#totalFiles#" >
			<input type="hidden" id="hExitosos" name="hExitosos" value="#totalFilesExitosos#">
			<input type="hidden" id="hFallaron" name="hFallaron" value='#totalFilesNoExitosos#'>
			<input type="hidden" id="hBaseTotal" name="hBaseTotal" value="#totalPagos#">
			<input type="hidden" id="hBaseRepetidos" name="hBaseRepetidos" value="#totalRepetidos#">
			<input type="hidden" id="hBaseRealizados" name="hBaseRealizados" value="#totalPagosRealizados#">


			<div class="container" >  
  <table class="table table-bordered table-striped " >
    <thead>
      <tr>
        <th>Nombre del xml</th>
        <th>Tipo Pago</th>
        <th>Nombre del Documento</th>
        <th>Pagos Realizados</th>
        <th>Pagos Repetidos</th>
        <th>Pagos No Realizados</th>
      </tr>
    </thead>
    <tbody>
     #armaTabla#

    </tbody>
  </table>
</div>


       
	   </cfoutput>


	<cfelse>
<cfif arraylen(arrErros) EQ 0>

	<!--- <table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center">
				<cfif strXML.Mcodigo EQ "-1">
					<b>No se pudo obtener la Informacion de la Moneda del CFDI</b>
				</cfif>
			</td>
		</tr>
	</table> --->
	<input type="hidden" id="hUUID" name="hUUID" value="#strXML.UUID#">
	<input type="hidden" id="hMontoTotal" name="hMontoTotal" value="#strXML.Total#">
	<input type="hidden" id="hMcodigo" name="hMcodigo" value="#strXML.Mcodigo#">
	<input type="hidden" id="hTipoCambio" name="hTipoCambio" value="#strXML.TipoCambio#">
		

	<script language="javascript" type="text/javascript">
     

		parent.loadFromIfr();
	</script>
<cfelse>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center">
				<b>Errores</b>
			</td>
		</tr>
		<cfloop from="1" to="#ArrayLen(arrErros)#" index="i">
			<cfoutput>
				<tr
				<cfif i MOD 2>
					bgcolor="##E8E8E8"
				<cfelse>
					bgcolor="white"
				</cfif>
				>
				<td>
					#arrErros[i]#
				</td>
				</tr>
			</cfoutput>
		</cfloop>
	</table>
</cfif>
</cfif>
</cfoutput>




