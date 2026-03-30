<cfif isDefined("url.MaxRows") and len(Trim(url.MaxRows)) gt 0>
	<cfset form.MaxRows = url.MaxRows>
</cfif>
<cfparam name="Form.MaxRows" default="15">
<cfquery name="rsSNegocios" datasource="#session.dsn#">
	select SNcodigo  ,  SNid , SNnumero              
	from SNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
</cfquery> 

<cfquery name="rsDocumentosTab1" datasource="#session.dsn#">
    select 
        d.CCTcodigo as TipoDocumento, 
        d.Ddocumento as Documento, 
        d.Dfecha as Fecha, 
        d.Dvencimiento as Vencimiento, 
        m.Miso4217 as Moneda,
        case when t.CCTtipo = 'D' then d.Dsaldo else d.Dsaldo * -1 end as Saldo
    from Documentos d
        inner join CCTransacciones t
            on t.Ecodigo = d.Ecodigo
            and t.CCTcodigo = d.CCTcodigo
        inner join Monedas m
            on m.Ecodigo = d.Ecodigo
            and m.Mcodigo = d.Mcodigo
    where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
    <cfif isdefined("Form.SNcodigo") and Form.SNcodigo NEQ -1  and len(trim(Form.SNcodigo)) NEQ 0>
        and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
    </cfif>
        and d.Dsaldo <> 0
    order by Dvencimiento, Ddocumento
</cfquery> 


<cfif isdefined('form.MaxRows') and form.MaxRows EQ ''>
	<cfset Form.MaxRows = 15>
</cfif>



<form action="LibTranPV-sql.cfm" method="post" name="form1">
	<input type="hidden" name="tab" value="1">	
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			 <table width="25%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top" nowrap  colspan="2"> 
						<cfinclude template="/sif/cc/MenuCC-barGraph-v2.cfm">
					</td>
					
			  </tr>
			</table>
		</td>
		<td valign="top" nowrap  align="center">
		<cfset navegacion = "SNcodigo=#form.SNcodigo#&maxrows=#form.maxrows#">

		<cfinvoke 
			component="sif.Componentes.pListas" 
			method="pListaQuery" 
			query="#rsDocumentosTab1#"
			desplegar="TipoDocumento, Documento, Fecha, Vencimiento, Moneda, Saldo"
			etiquetas="Tipo Doc, Documento, Fecha, Vencimiento, Moneda, Saldo"
			formatos="S,S,D,D,S,M"
			align="left, left, left, left, left, right"
			checkboxes="N"
			showLink="false"
			incluyeForm="false"
			formName="form1"
			nuevo="LibTranPV.cfm"
			ira="LibTranPV.cfm"
			botones="Agregar"
			keys="Documento" 
			maxrows="#Form.MaxRows#"
			navegacion="#Navegacion#"/>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<fieldset><legend><strong>Detalle de la Liberaci&oacute;n de la Transacci&oacute;n</strong></legend>
			<cfoutput>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="50%" valign="top">
							<cf_web_portlet_start border="true" titulo="Origenes de la factura" skin="info1">
								<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
									<tr>
										<td><strong>C&oacute;digo de la caja:</strong></td>
										<td>
											<!--- <input name="FAM01COD" type="text" maxlength="4" onFocus="this.select();"> --->
											<cf_sifcajasPV name="FAM01CODD" Ocodigo="Ocodigo2" form="form1" FAM01COD="FAM01COD" tabindex="1">
										</td>
									</tr>
									<tr>
										<td nowrap>
											<strong>No. de Transacci&oacute;n:</strong>
										</td>
										<td>
											<input name="FAX01NTR" type="text" maxlength="10" onFocus="this.select();" tabindex="1">
										</td>
									</tr>
									<tr>
										<td><strong>Transacci&oacute;n Externa:</strong></td>
										<td>
											<input name="FAX01NTE" type="text" maxlength="5" onFocus="this.select();" tabindex="1">
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
										<td >
											<input name="MontoMax" type="text" maxlength="18" align="right" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur()}};" tabindex="1"> 
										</td></tr>
									<tr>
										<td align="right"><strong>Moneda:</strong></td>
										<td>													
											<select name="Mcodigo" tabindex="1">
												<cfif isdefined('rsMonedas') and rsMonedas.recordCount GT 0>
													<cfloop query="rsMonedas">
														<option value="#Mcodigo#">(#Miso4217#)&nbsp;#Mnombre#</option>
													</cfloop>
												</cfif>
											</select>
										</td>
									</tr>
									<tr>
										<td  nowrap>
											<strong>Motivo:</strong>
											<!--- <textarea name="_Motivo" cols="80" rows="1" wrap="virtual" width="80"></textarea> --->
										</td>
										<td>
										<input name="Motivo" type="text" size="60"  tabindex="1" value="" maxlength="255" onFocus="this.select();">
										  <cfif isdefined("rsSNegocios") and rsSNegocios.SNcodigo NEQ -1  and len(trim(rsSNegocios.SNcodigo)) NEQ 0>
											  <input name="SNcodigoconsultado" type="hidden" value="#rsSNegocios.SNcodigo#" tabindex="0">
										  </cfif>
										  <cfif isdefined("rsSNegocios") and len(trim(rsSNegocios.SNid)) NEQ 0>
											<input type="hidden" name = "SNid" value="#rsSNegocios.SNid#" tabindex="0">
										  </cfif>
										  <!--- <cfif isdefined("rsSNegocios") and len(trim(rsSNegocios.SNnumero)) NEQ 0>
											<input type="hidden" name = "SNnumero" value="#rsSNegocios.SNnumero#" tabindex="0">
										  </cfif> --->
										</td>
									</tr>
								</table>
							<cf_web_portlet_end>
						</td>
					</tr>
					<tr align="center" valign="top">
						
						<td colspan="2"><input name="btnGrabar" type="submit" value="Grabar" onClick="javascript: return valida();" tabindex="1"></td>
					</tr>
				</table>
			</cfoutput>
		</fieldset>
			
			
		</td>
	</tr>
</table>
</form>
<cf_qforms form="form1" objForm="objForm">
<script language="javascript" type="text/javascript">
	function valida(){
		
		if ( new Number(qf(document.form1.MontoMax.value)) > 0){
			document.form1.MontoMax.value = qf(document.form1.MontoMax.value);
			
		}
		else {
			alert('El Monto no puede estar vacio y debe ser mayor que cero');
			document.form1.MontoMax.value = '';
			return false;
		}
		if (document.form1.FAX01NTE.value == ''){
			objForm.FAM01CODD.required = true;
			objForm.FAM01CODD.description = "Código de Caja";
			objForm.FAX01NTR.required = true;
			objForm.FAX01NTR.description = "Número de Transacción";
			objForm.FAX01NTE.required = false;
			objForm.FAX01NTE.description = "Transacción Externa";
		}
		else if(document.form1.FAM01CODD.value == '' || document.form1.FAX01NTR.value == '') {
			
			objForm.FAX01NTE.required = true;
			objForm.FAM01CODD.required = false;
			objForm.FAX01NTR.required = false;
		}
		return true;
	}
	function deshabilitaValidacion() {
		objForm.FAX01NTE.required = false;
	}

    function funcConsulta() {
		
		deshabilitaValidacion();
		
		return true;		
	}
	
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description = "Moneda";
	objForm.Motivo.required = true;
	objForm.Motivo.description = "Motivo";
	
</script>
 