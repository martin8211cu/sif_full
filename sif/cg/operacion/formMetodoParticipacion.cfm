<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DetallesMetodoParticipacion" default="Detalles de Método de Participación" returnvariable="LB_DetallesMetodoParticipacion" xmlfile="formMetodoParticipacion.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PreFactura" default="Pre-Factura" returnvariable="LB_PreFactura" xmlfile="formMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Estatus" default="Estatus" returnvariable="LB_Estatus" xmlfile="formMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Socio" default="Socio" returnvariable="LB_Socio"
xmlfile="formMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n"
returnvariable="LB_Descripcion" xmlfile="formMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SeleccioneUna" default="Seleccione Una" returnvariable="LB_SeleccioneUna" xmlfile="formMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Vendedor" default="Vendedor" returnvariable="LB_Vendedor" xmlfile="formMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Oficina" default="Oficina" returnvariable="LB_Oficina" xmlfile="formMetodoParticipacion.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_OrdenCompra" default="Orden de Compra" returnvariable="LB_OrdenCompra" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Observaciones" default="Observaciones" returnvariable="LB_Observaciones" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TransaccionPreFactura" default="Transacci&oacute;n Pre - Facturas" returnvariable="LB_TransaccionPreFactura" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TipoCambio" default="Tipo Cambio" returnvariable="LB_TipoCambio" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descuento" default="Descuento" returnvariable="LB_Descuento" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DiasVigencia" default="D&iacute;as de Vigencia" returnvariable="LB_DiasVigencia" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Impuesto" default="Impuesto" returnvariable="LB_Impuesto" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Total" default="Total" returnvariable="LB_Total" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Imprimir" default="Imprimir" returnvariable="BTN_Imprimir" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Regresar" default="Regresar" returnvariable="BTN_Regresar" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Pendiente" default="Pendiente" returnvariable="LB_Pendiente" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Estimada" default="Estimada" returnvariable="LB_Estimada" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Anulada" default="Anulada" returnvariable="LB_Anulada" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Terminada" default="Terminada" returnvariable="LB_Terminada" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Vencida" default="Vencida" returnvariable="LB_Vencida" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DeseaEliminarEstaCotizacion" default="¿Desea eliminar esta cotizaci&oacute;n?" returnvariable="MSG_DeseaEliminarEstaCotizacion" xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Retencion" default="Retenci&oacute;n al Pagar" returnvariable="LB_Retencion"
xmlfile="formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SinRetencion" default="Sin Retenci&oacute;n" returnvariable="LB_SinRetencion" xmlfile="formMetodoParticipacion.xml">

<!--- Cual va a ser el tipo de cambio. Actualmente por defecto va a ser de tipo 'V' de venta,
	pero tambien existe el tipo 'C' de Compra (<cfset TC = "TCcompra">)--->
<cfset TC = "TCventa">
<cfset regresa = "MetodoParticipacion.cfm">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfif isdefined('url.MetParId') and not isdefined('form.MetParId')>
	<cfparam name="form.MetParId" default="#url.MetParId#">
</cfif>

<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>



<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js">//</script>

<cfset modo = 'ALTA'>

<!--- Query de lista de Socios --->
 <cfquery name="rsListaSoc" datasource="#session.DSN#">
	select sn.SNnombre, snmp.Ecodigo, snmp.SNid,snmp.FormatoCuentaC,snmp.FormatoCuentaD
	from SNMetodoParticipacion snmp
	inner join SNegocios sn on snmp.Ecodigo=sn.Ecodigo and snmp.SNid=sn.SNid
     where sn.Ecodigo=#session.Ecodigo#
</cfquery>

<cfquery name="rsSocio" datasource="#session.DSN#">
 		Select SNcodigo as SNid from SNegocios
		where Ecodigo= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and SNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsListaSoc.SNid#">
</cfquery>

<cfif  isdefined('form.MetParId') and len(trim(form.MetParId))>
	<cfset modo = 'CAMBIO'>
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery name="VerificaDetalle" datasource="#Session.DSN#">
		select 1 from DMetPar
		where Ecodigo= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and  MetParID = <cfqueryparam value="#Form.MetParID#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfquery name="rsForm" datasource="#session.DSN#">
 		Select * from EMetPar emp
        left join DMetPar dmp on emp.MetParID=dmp.MetParID and emp.Ecodigo=dmp.Ecodigo
		where emp.Ecodigo= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and emp.MetParID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParID#">
	</cfquery>


</cfif> <!--- TERMINA MODO CAMBIO--->

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	Select Mcodigo,Mnombre,Miso4217
	from Monedas m
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="TCsug" datasource="#Session.DSN#">
	select tc.Mcodigo, tc.TCcompra, tc.TCventa
	from Htipocambio tc
	where tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  and tc.Hfecha <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	  and tc.Hfechah >  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
</cfquery>


<style type="text/css">
<!--
.style1 {
	font-size: 16px;
	font-weight: bold;
}
-->
</style>

<script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>
<cfoutput>
<form name="form1" method="post" action="SQLMetodoParticipacion.cfm" style="margin: '0'" onSubmit="
var er= '';

if(form1.SNCODIGO.value == '-1' || form1.SNCODIGO.value == -1){
 er = er + '\n - Se debe indicar el Socio';
}

if(form1.Descripcion.value == '' || form1.Descripcion.value == null){
 er = er + '\n - Se debe indicar la Descripcion';
}

if(form1.Documento.value == '' || form1.Documento.value == null){
 er = er + '\n - Se debe indicar el Documento';
}

if(er != ''){
alert('Se presentaron los Siguientes Errores: \n' + er);
return false;
}else
{
return true;
}

">

	<table width="100%"  border="0" cellpadding="0" cellspacing="0">

		<tr>
        	<td align="right"><strong>#LB_Socio#:</strong></td>
			<td>
				<cfif modo NEQ "ALTA" and isdefined('rsSocio.SNid') and LEN(trim(rsSocio.SNid))>
                   	<cf_sifsociosnegocios2 tabindex="1" SNtiposocio="C"  size="55" idquery="#rsSocio.SNid#" modificable = "false">
                <cfelseif isdefined('form.SNid') and LEN(trim(form.SNid))>
                	<cf_sifsociosnegocios2 tabindex="1" SNtiposocio="C"  size="55" idquery="#form.SNid#">
	        	<cfelse>
	        	<!---  Este codigo comentado es la forma en como se invocaba antes los socios --->
               <!---  <cf_sifsociosnegocios2 tabindex="1" SNtiposocio="C" size="55" frame="frame2"> --->

                   	<select name="SNid">
					<option value="-1" <cfif isdefined('form.SNnombreU') and form.SNnombreU EQ '-1'> selected</cfif>>&nbsp;</option>
					<cfif isdefined('rsListaSoc') and rsListaSoc.recordCount GT 0>
						<cfloop query="rsListaSoc">
							<option value="#SNid#" <cfif isdefined("Form.SNid") AND Form.SNid EQ rsListaSoc.SNnombre> selected</cfif>>#SNnombre#</option>
						</cfloop>
					</cfif>
				</select>

	       	    </cfif>
			</td>
           	<td  align="right"><strong>#LB_Fecha#:</strong></td>
			<td>
				<cfif isdefined('rsForm.Fecha')>
					<cfset LvarFecha = rsForm.Fecha>
				<cfelse>
					<cfset LvarFecha = now()>
				</cfif>
				<cf_sifcalendario tabindex="5" form="form1" value="#DateFormat(LvarFecha,'dd/mm/yyyy')#" name="FechaCalculoMetPar">
		  	</td>
        </tr>

        <tr>  	<td>&nbsp;  </td>  </tr>
        <tr>

           <!--- <td align="right"><strong>#LB_Moneda#:</strong></td>
			<td>
            	<select <cfif isdefined('VerificaDetalle') and VerificaDetalle.recordCount GT 0> disabled</cfif> name="Mcodigo" onChange="javascript:cambioMoneda(this);" tabindex="7">
					<cfif isdefined('rsMonedas') and rsMonedas.recordCount GT 0>
						<cfloop query="rsMonedas">
							<option value="#Mcodigo#" <cfif modo NEQ 'ALTA' and rsForm.Mcodigo EQ rsMonedas.Mcodigo> selected </cfif>>(#Miso4217#)&nbsp;#Mnombre#</option>
						</cfloop>
					</cfif>
				</select>
			</td>--->
		</tr>
         </tr>

        <!--- <tr>
         	<td colspan="4">&nbsp;  </td>
		    <td rowspan="8" align="right" valign="top">
				<cfif modo NEQ 'ALTA'>
					<table width="70%"  border="0">
					  <tr>
						<td>
							<fieldset><legend><strong>Totales</strong></legend>
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td align="right"><strong>#LB_Descuento#:</strong></td>
										<td >
											<input name="Descuento2" readonly="true" type="text" id="Descuento2" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rsForm.Descuento,',9.00')#"</cfif> style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="13">
										</td>
									</tr>
									<tr>
										<td align="right"><strong>#LB_Impuesto#:</strong></td>
										<td >
											<input name="Impuesto2" readonly="true" type="text" id="Impuesto2" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rsForm.Impuesto,',9.00')#"</cfif> style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="16">
										</td>
									</tr>
									<tr>
										<td align="right"><strong>#LB_Total#:</strong></td>
										<td >
											<input readonly="true" name="Total2" type="text" id="Total2" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rsForm.Total,',9.00')#"</cfif> style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="17">
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					  </tr>
					</table>
				<cfelse>
					&nbsp;
				</cfif>
			</td>
		</tr>--->
			<tr>
			<td align="right"><strong>#LB_Descripcion#:</strong></td>

			<td nowrap="nowrap"><input name="Descripcion" type="text" id="Descripcion" <cfif modo NEQ 'Alta'> value="#rsForm.Descripcion#"<cfelseif modo EQ "ALTA" and isdefined('form.Descripcion') and LEN(trim(form.Descripcion))>value="#rsForm.Descripcion#" <cfelse>value=""</cfif> style="text-align: right" size="20" maxlength="20" tabindex="4" onFocus="this.value=qf(this); this.select();"   >


            </td>
            <td align="right"><strong>#LB_Documento#:</strong></td>


			<td nowrap="nowrap"><input name="Documento" type="text" id="Documento"  <cfif modo NEQ 'Alta'>value="#rsForm.Documento#"<cfelseif modo EQ "ALTA" and isdefined('form.Documento') and LEN(trim(form.Documento))>value="#rsForm.Documento#" <cfelse>value=""</cfif> style="text-align: right" size="20" maxlength="20" tabindex="4">

            </td>
		</tr>
		<tr><td>&nbsp; </td> </tr>

        <tr>  	<td>&nbsp;  </td>  </tr>

        <tr>
			<td colspan="5" align="center">
			<cfif modo neq 'ALTA'  >
				<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
				<input type="hidden" name="MetParID" value="#rsForm.MetParID#">

                <cf_botones tabindex='12' modo='CAMBIO'  Regresar="#regresa#">
			<cfelse>
                <cf_botones tabindex='12' modo='ALTA' Regresar="#regresa#">
			</cfif>

		</td>
	</tr>
	</table>
</form>
</cfoutput>

<cfif modo neq 'ALTA'>
	<table width="100%"  border="0">
 		<tr>
			<td class="tituloListas"><cfoutput>#LB_DetallesMetodoParticipacion#</cfoutput></td>
	  	</tr>
	  	<tr>
			<td>
				<cfinclude template="Det-formMetodoParticipacion.cfm">
			</td>
	  	</tr>
	  	<tr>
			<td>
				<cfinclude template="Det-listaMetodoParticipacion.cfm">
			</td>
	  	</tr>
	</table>
</cfif>


<cf_qforms form="form1" objForm="objForm">
	<script language="javascript" type="text/javascript">


		function cambioMoneda(cb){
			if (cb.value == <cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>){
				document.form1.TipoCambio.value = "1.00";

				document.form1.TipoCambio.disabled = true;
			}else{
				<cfwddx action="cfml2js" input="#TCsug#" topLevelVariable="rsTCsug">

				//Verificar si existe en el recordset
				var nRows = rsTCsug.getRowCount();
				if (nRows > 0) {
					for (row = 0; row < nRows; ++row) {
						if (rsTCsug.getField(row, "Mcodigo") == cb.value) {
							document.form1.TipoCambio.value = rsTCsug.getField(row, "<cfoutput>#TC#</cfoutput>");
							document.form1.TipoCambio.disabled = false;
							row = nRows;
						}else{
							document.form1.TipoCambio.value = "0.00";
						}
					}
				}else{
					document.form1.TipoCambio.value = "0.00";
				}
			}
		}

		function sugerirTClocal() {
			if (document.form1.Mcodigo.value == <cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>){
				document.form1.TipoCambio.value = "1.00";
				document.form1.TipoCambio.disabled = true;
			}
		}

<!--- Averiguar para que sierve esta funcion ABG --->
		function validaMon(){

			document.form1.TipoCambio.value = qf(document.form1.TipoCambio.value);

			<cfif modo neq 'ALTA'>

				document.form1.TipoCambio.disabled = false;
				document.form1.Mcodigo.disabled = false;

			</cfif>



			return true;
		}

		function deshabilitaValidacion() {

			objForm.Ocodigo.required = false;
			objForm.SNcodigo.required = false;
			objForm.Mcodigo.required = false;

			objForm.TipoCambio.required = false;

		}

		function funcBaja() {
			if(!confirm('<cfoutput>#MSG_DeseaEliminarEstaCotizacion#</cfoutput>')){
				return false;
			}
			deshabilitaValidacion();
			return true;
		}

		function CambioTipoPago(){
			if(document.form1.TipoPago[0].checked) {
				document.form1.vencimiento.value = 0;
				document.form1.vencimiento.disabled = true;
			}
			else {
			document.form1.vencimiento.disabled = false;
			}
		}

		<!---function funcSNnumero(){
			document.form1.SNDirec.value = 'valor';
			document.form1.action = 'MetodoParticipacion.cfm';
			document.form1.submit();--->

		}
	// Validaciones para los campos de % no sean mayores a 100


	objForm.SNcodigo.required = true;
	objForm.SNcodigo.description = "<cfoutput>#LB_Socio#</cfoutput>";

	sugerirTClocal();
	cambioMoneda(document.form1.Mcodigo);
	CambioTipoPago();
</script>