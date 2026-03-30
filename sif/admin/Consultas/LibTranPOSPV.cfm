<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif isDefined("url.MaxRows") and len(Trim(url.MaxRows)) gt 0>
	<cfset form.MaxRows = url.MaxRows>
</cfif>
<cfparam name="Form.MaxRows" default="15">

<cfif isdefined('form.MaxRows') and form.MaxRows EQ ''>
	<cfset Form.MaxRows = 15>
</cfif>

<cfif isdefined("Url.SNcodigo") and len(trim(Url.SNcodigo))>
	<cfparam name="Form.SNcodigo" default="#Url.SNcodigo#">
</cfif>


<cfif isdefined('form.FAX01NTR') and form.FAX01NTR NEQ ''>
	<cfquery name="rsDocumento" datasource="#session.dsn#">
		 select F.Oficodigo #_Cat# ' - ' #_Cat# F.Odescripcion  as descOficina,
			E.FAM01CODD,
			E.FAM01CODD #_Cat# ' - ' #_Cat# E.FAM01DES	as descripcioncaja,
			C.CDCtipo			as tipoidentif,	
			C.CDCidentificacion	#_Cat# ' - ' #_Cat# C.CDCnombre	as nombreCliente,
			G.Miso4217		#_Cat# ' - ' #_Cat# G.Mnombre		as descripcionmoneda,
			D.Mcodigo,
			D.FAX01FEC		as fechafactura,
			D.FAX01TIP		as tipofactura, 
			D.FAX01NTR		as Transaccion, 
			D.FAX01NTE,
			D.Mcodigo,
			case when 
					D.FAX01TIP in ('1','4') then (select sum(FAX04TOT) 
										 from FAX004 fd 
										 where fd.FAM01COD = D.FAM01COD 
											 and fd.FAX01NTR = D.FAX01NTR) 
					else D.FAX01TOT
			end 				as subtotal,
			D.FAX01MDT		as MontoDes,
			D.FAX01MIT		as MontoImpu,
			D.FAX01TOT		as Total, 
			A.SNnumero,
			A.SNid,
			A.SNcodigo,
			ltrim(rtrim(E.FAM01COD)) as  FAM01COD
		from 	SNegocios A
			inner join  FACSnegocios B
				on  B.Ecodigo = A.Ecodigo 
					and  B.SNcodigo = A.SNcodigo
			inner join ClientesDetallistasCorp C
				on C.CDCcodigo = B.CDCcodigo
			inner join FAX001 D
				on D.CDCcodigo = C.CDCcodigo
			inner join FAM001 E
				on D.FAM01COD = E.FAM01COD
					and D.Ecodigo = E.Ecodigo 
			inner join  Oficinas F
				on F.Ocodigo = D.Ocodigo
					and F.Ecodigo = D.Ecodigo 
			inner join Monedas G
				  on G.Mcodigo = D.Mcodigo
				and G.Ecodigo = D.Ecodigo 
			 where  A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and A.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
				and D.FAX01NTR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAX01NTR#">
	</cfquery>
	 <cfquery name="rsDocumentoDet" datasource="#session.dsn#">
		select FAX01NTR as ntr, FAX04LIN as linea, FAX04DES  
		from FAX004
		where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and FAX01NTR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAX01NTR#">
	</cfquery> 
</cfif>


<form action="LibTranPV.cfm" method="post" name="form1">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr >
  	<td width="25%" valign="top">

			<input type="hidden" name="FALiberaCreditoID" value="">
			<cfquery name="rsFATran" datasource="#session.dsn#">
				select C.FAX01NTR ,rtrim(ltrim(C.FAM01COD)) as FAM01COD, F.FAM01CODD,  C.FAX01FEC,  D.SNnombre, E.Odescripcion, B.SNcodigo, 2 as tab
				from ClientesDetallistasCorp A, FACSnegocios B, FAX001 C, SNegocios D, Oficinas E, FAM001 F
				where  B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined("form.SNcodigoconsultado") and len(trim(form.SNcodigoconsultado))>
						and B.SNcodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoconsultado#">
					<cfelseif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))> 	
						and B.SNcodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
					</cfif>
					and A.CDCcodigo =  C.CDCcodigo
					and A.CDCcodigo = B.CDCcodigo
					and B.Ecodigo = D.Ecodigo
					and B.SNcodigo = D.SNcodigo
					and C.Ecodigo = E.Ecodigo
					and C.Ocodigo = E.Ocodigo
					and C.Ecodigo = F.Ecodigo
					and C.FAM01COD = F.FAM01COD
					and C.FAX01STA in ('P','G')
			</cfquery>
							
			<cfset navegacion = "SNcodigo=#form.SNcodigo#&maxrows=#form.maxrows#">
		   <cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaPVRet">
			 <cfinvokeargument name="query" value="#rsFATran#"/>
			 <cfinvokeargument name="desplegar" value="FAX01NTR, FAM01CODD, FAX01FEC"/>
			 <cfinvokeargument name="etiquetas" value="No Transacción,Caja, Fecha Factura"/>
			 <cfinvokeargument name="formatos" value="S,S,D"/>
			 <cfinvokeargument name="align" value="left,left,right"/>
			 <cfinvokeargument name="ajustar" value="N"/>
			 <cfinvokeargument name="MaxRows" value="10"/>
			 <cfinvokeargument name="incluyeform" value="false">
 			 <cfinvokeargument name="formname" value="form1">
			 <cfinvokeargument name="irA" value="LibTranPV.cfm"/>
			  <cfinvokeargument name="showLink" value="true">
			 <cfinvokeargument name="showEmptyListMsg" value="true">
			 <cfinvokeargument name="EmptyListMsg" value="*** NO SE HA REGISTRADO NINGUNA TRANSACCION ***">
			 <cfinvokeargument name="navegacion" value="#navegacion#">
		</cfinvoke>
				
		
	</td>
	<td width="75%">
	
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<fieldset><legend><strong>Encabezado de la factura</strong></legend>
						
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  
								<tr>
									<td width="50%" valign="top">
										<cf_web_portlet_start border="true" titulo="Origenes de la factura" skin="info1">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td><strong>Oficina:</strong></td>
													<td><input name="descOficina" type="text" size="50"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.descOficina#</cfif>"></td>
												</tr>
												<tr>
													<td>
														<strong>Caja:</strong>
													</td>
													<td>
														<input name="descripcioncaja" type="text" size="50"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.descripcioncaja#</cfif>">
													</td>
												</tr>
												<tr>
													<td><strong>Cliente:</strong></td>
													<td>
														<input name="nombreCliente" type="text" size="50"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.nombreCliente#</cfif>">
													</td>
												</tr>
												<tr>
													<td><strong>Moneda:</strong></td>
													<td>													
														<input name="descripcionmoneda" type="text" size="50"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.descripcionmoneda#</cfif>">
													</td>
												</tr>
											</table>
										<cf_web_portlet_end>
									</td>
									<td width="50%" valign="top">
										<cf_web_portlet_start border="true" titulo="Montos de la factura" skin="info1">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td align="right"><strong>Subtotal:</strong></td>
													<td ><input name="subtotal" type="text" align="right" size="25"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#LSNumberFormat(rsDocumento.subtotal,',9.00')#</cfif>"></td>
												</tr>
												<tr>
													<td align="right">
														<strong>Descuento:</strong>
													</td>
													<td >
														<input name="MontoDes" type="text"  align="right" size="25"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#LSNumberFormat(rsDocumento.MontoDes,',9.00')#</cfif>">
													</td>
												</tr>
												<tr>
													<td align="right"><strong>Impuesto:</strong></td>
													<td ><input name="MontoImpu" type="text" align="right" size="25"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#LSNumberFormat(rsDocumento.MontoImpu,',9.00')#</cfif>"></td>
												</tr>
												<tr>
													<td align="right"><strong>Neto:</strong></td>
													<td ><input name="Total" type="text"  align="right" size="25"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#LSNumberFormat(rsDocumento.Total,',9.00')#</cfif>"></td>
												</tr>
											</table>
										<cf_web_portlet_end>	
									</td>
								</tr>
							</table>
					</fieldset>
				</td>
			</tr>
			<cfif isdefined('form.FAX01NTR') and form.FAX01NTR NEQ ''>
				<tr>
					<td>
						<fieldset><legend><strong>Detalle de la factura</strong></legend>
							<cf_web_portlet_start border="true" titulo="L&iacute;neas del Documento" skin="info1">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>
											<cfset navegacion = "SNcodigo=#form.SNcodigo#&maxrows=#form.maxrows#">
											   <cfinvoke 
												 component="sif.Componentes.pListas"
												 method="pListaQuery"
												 returnvariable="pListaPVRet2">
												 <cfinvokeargument name="query" value="#rsDocumentoDet#"/>
												 <cfinvokeargument name="desplegar" value="linea, FAX04DES "/>
												 <cfinvokeargument name="etiquetas" value="No Línea, Descripción"/>
												 <cfinvokeargument name="formatos" value="S,S"/>
												 <cfinvokeargument name="align" value="left,left"/>
												 <cfinvokeargument name="ajustar" value="N,N"/>
												 <cfinvokeargument name="MaxRows" value="10"/>
												 <cfinvokeargument name="incluyeform" value="false">
												 <!---  <cfinvokeargument name="formname" value="form1">  --->
												 <cfinvokeargument name="irA" value=""/>
												  <cfinvokeargument name="showLink" value="false">
												 <cfinvokeargument name="showEmptyListMsg" value="true">
												 <cfinvokeargument name="EmptyListMsg" value="*** NO HAY LINEAS DE DETALLE***">
												 <cfinvokeargument name="navegacion" value="#navegacion#">
											</cfinvoke>
										</td>
									</tr>
								</table>
							<cf_web_portlet_end>	
						</fieldset>
					</td>
				</tr>
			</cfif>
		</table>
		</cfoutput>
	  </td>
	</tr>
</table>
</form>
<form action="LibTranPV-sql.cfm" method="post" name="form3">
	<input type="hidden" name="tab" value="2">
	<fieldset><legend><strong>Detalle de la Liberaci&oacute;n de la Transacci&oacute;n</strong></legend>
		<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="50%" valign="top">
						<cfif isdefined('form.FAX01NTR') and form.FAX01NTR NEQ ''>
							<input type="hidden" name = "SNid" value="#rsDocumento.SNid#">
							<input type="hidden" name = "SNcodigoconsultado" value="#rsDocumento.SNcodigo#">
							<input type="hidden" name = "SNnumero" value="#rsDocumento.SNnumero#">
						</cfif>
						<cf_web_portlet_start border="true" titulo="Origenes de la factura" skin="info1">
							<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
								<tr>
									<td><strong>C&oacute;digo de la caja:</strong></td>
									<td>
										<input name="_FAM01CODD" type="text" maxlength="4"  class="cajasinbordeb" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.FAM01CODD#</cfif>">
										<input type="hidden" name = "FAM01COD" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#trim(rsDocumento.FAM01COD)#</cfif>">
										
									</td>
								</tr>
								<tr>
									<td>
										<strong>No. de Transacci&oacute;n:</strong>
									</td>
									<td>
										<input name="_FAX01NTR" type="text" maxlength="10" class="cajasinbordeb"  align="middle"  value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.Transaccion#</cfif>">
										<input name="FAX01NTR" type="hidden" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.Transaccion#</cfif>">
									</td>
								</tr>
								<tr>
									<td><strong>Transacci&oacute;n Externa:</strong></td>
									<td>
										<input name="_FAX01NTE" type="text" maxlength="5" class="cajasinbordeb" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.FAX01NTE#</cfif>">
										<input name="FAX01NTE" type="hidden" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.FAX01NTE#</cfif>">
									</td>
								</tr>
								
							</table>
						<cf_web_portlet_end>
					</td>
					<td width="50%" valign="top">
						<cf_web_portlet_start border="true" titulo="Montos" skin="info1">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="right"><strong>Monto: </strong></td>
									<td ><input name="_MontoMax" type="text" maxlength="18"  align="right" class="cajasinbordeb" readonly="true"  
									value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#LSNumberFormat(rsDocumento.Total,',9.00')#</cfif>">									    
									  <input name="MontoMax" type="hidden" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#LSNumberFormat(rsDocumento.Total,',9.00')#</cfif>"></td></tr>
								<tr>
									<td align="right"><strong>Moneda:</strong></td>
									<td>													
										<input name="descripcionmoneda" type="text" size="25"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.descripcionmoneda#</cfif>">
									<input name="Mcodigo" type="hidden" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.Mcodigo#</cfif>">
									 
									</td>
								</tr>
								<tr>
									<td  nowrap>
										<strong>Motivo:</strong>
									</td>
									<td><input name="Motivo" type="text" size="80" maxlength="255"  tabindex="-1" value="" onFocus="this.select();"></td>
								</tr>
							</table>
						<cf_web_portlet_end>
					</td>
				</tr>
				<tr align="center" valign="top">
					
					<td colspan="2"><input name="btnGrabar" type="submit" value="Grabar" onClick="javascript: return validaMon();"></td>
				</tr>
			</table>
		</cfoutput>
	</fieldset>
</form>

<cf_qforms form="form3" objForm="objForm">
<script language="javascript" type="text/javascript">
	function validaMon(){
		
		if ( new Number(qf(document.form3.MontoMax.value)) > 0){
			document.form3.MontoMax.value = qf(document.form3.MontoMax.value);
			return true;
		}
		else {
			alert('Por favor seleccione un documento.');
			document.form3.MontoMax.value = '';
			return false;
		}
	}
	objForm.Motivo.required = true;
	objForm.Motivo.description = "Motivo de la Liberación";
</script>