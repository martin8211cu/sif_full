<cfset navegacion = "&PASO=1">
<cf_navegacion name="SNcodigo_F">
<cf_navegacion name="McodigoOri_F">
<cf_navegacion name="Dfechavenc_D">
<cf_navegacion name="Dfechavenc_F">
<cf_navegacion name="Beneficiario_F">
<cf_navegacion name="Documento_F">

<cfset montoSolicitado = 0>
<cfif isDefined("Form.montoPagoSolicitado") and Trim(Form.montoPagoSolicitado) NEQ "">
  <cfset montoSolicitado = Form.montoPagoSolicitado>
</cfif>

<cfquery name="rsGetTransacciones" datasource="#session.DSN#">
	SELECT RTRIM(LTRIM(COALESCE(CPTcodigo, ''))) AS CPTcodigo,
	       RTRIM(LTRIM(COALESCE(CPTdescripcion, ''))) AS CPTdescripcion
	FROM CPTransacciones
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  AND CPTtipo = 'C'
	ORDER BY CPTcodigo
</cfquery>
<cfset titulo = 'Lista de Documentos de CxP a Seleccionar'>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
<div id="loader"></div>
	<table width="100%" border="0" cellspacing="6">
	  <tr>
		<td width="50%" valign="top">
			<form name="formFiltro" method="post" action="solicitudesCP.cfm"style="margin: '0' ">
				<input type="hidden" name="PASO" value="1">
				<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
				  <tr>
					<td width="17%" nowrap align="right"><strong>Socio Negocios:</strong></td>
					<td width="32%">
						<cfif isdefined('form.SNcodigo_F') and len(trim(form.SNcodigo_F))>
							<cf_sifsociosnegocios2 form="formFiltro" SNnombre='SNnombre_F' SNcodigo='SNcodigo_F' idquery="#form.SNcodigo_F#" tabindex="1">
						<cfelse>
							<cf_sifsociosnegocios2 form="formFiltro" SNnombre='SNnombre_F' SNcodigo='SNcodigo_F' tabindex="1">
						</cfif>
					</td>
					<td width="14%" nowrap align="right" valign="middle"><strong>Vencimiento Desde:</strong></td>
					<td width="13%" nowrap valign="middle">
                    	<cfset fechadocd = ''>
						<cfif isdefined('form.Dfechavenc_D') and len(trim(form.Dfechavenc_D))>
							<cfset fechadocd = LSDateFormat(form.Dfechavenc_D,'dd/mm/yyyy') >
						</cfif>
						<cf_sifcalendario form="formFiltro" value="#fechadocd#" name="Dfechavenc_D" tabindex="1">
					</td>
					<td width="24%" rowspan="2" nowrap align="center" valign="middle">
						<cf_botones tabindex="2"
									include="Filtrar"
									includevalues="Filtrar"
									exclude="Cambio,Baja,Nuevo,Alta,Limpiar">
					</td>
				  </tr>
                  <tr>
                  	<td width="17%" nowrap align="right"><strong>Documento:</strong></td>
                    <td width="32%">
                    	<cfparam name="form.Documento_F" default="">
						<input name="Documento_F" value="<cfoutput>#form.Documento_F#</cfoutput>" size="30" maxlength="20" tabindex="1">
                    </td>
					<td width="14%" nowrap align="right" valign="middle"><strong>Vencimiento Hasta:</strong></td>
					<td width="13%" nowrap valign="middle">
                    	<cfset fechadoc = ''>
						<cfif isdefined('form.Dfechavenc_F') and len(trim(form.Dfechavenc_F))>
							<cfset fechadoc = LSDateFormat(form.Dfechavenc_F,'dd/mm/yyyy') >
						</cfif>
						<cf_sifcalendario form="formFiltro" value="#fechadoc#" name="Dfechavenc_F" tabindex="1">
					</td>
                  </tr>
				  <tr>
					<td width="17%" nowrap align="right"><strong>Nombre Socio:</strong></td>
					<td width="32%">
						<cfparam name="form.Beneficiario_F" default="">
						<input name="Beneficiario_F" value="<cfoutput>#form.Beneficiario_F#</cfoutput>" size="60" tabindex="1">
					</td>
					<td width="14%" nowrap align="right" valign="middle"><strong>Moneda:</strong></td>
					<td width="13%" nowrap valign="middle">
						<cfquery name="rsMonedas" datasource="#session.DSN#">
							select distinct Mcodigo, (select min(Mnombre) from Monedas m2 where m.Mcodigo=m2.Mcodigo) as Mnombre
							  from Monedas m
							  where m.Ecodigo = #session.Ecodigo#
						</cfquery>

						<select name="McodigoOri_F" tabindex="1">
							<option value="">(Todas las monedas)</option>
							<cfoutput query="rsMonedas">
								<option value="#Mcodigo#" <cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F)) and form.McodigoOri_F EQ Mcodigo>selected</cfif>>#Mnombre#</option>
							</cfoutput>
						</select>
					</td>
				  </tr>
				  <tr>
					  <td align="right"><strong>Transacción:&nbsp;</strong></td>
					  <td align="left">
						  <select id="cboTransaccion" name="cboTransaccion" default="-1">
							  <option value="-1">--- Seleccione ---</option>
							  <cfloop query="#rsGetTransacciones#">
								  <cfoutput>
									  <cfif isDefined("form.cboTransaccion") AND #form.cboTransaccion# eq #rsGetTransacciones.CPTcodigo#>
										  <option value="#rsGetTransacciones.CPTcodigo#" selected="true">#rsGetTransacciones.CPTcodigo# - #rsGetTransacciones.CPTdescripcion#</option>
									  <cfelse>
									  	  <option value="#rsGetTransacciones.CPTcodigo#">#rsGetTransacciones.CPTcodigo# - #rsGetTransacciones.CPTdescripcion#</option>
									  </cfif>
							      </cfoutput>
							  </cfloop>
						  </select>
                      </td>
					  <td align="right"><strong>Ordenar por fecha de vencimiento:&nbsp;</strong></td>
						<td align="left" colspan="4">
						<input type="Checkbox" id = "OrdenFechaVencimiento" name="OrdenFechaVencimiento"
						<cfif isDefined("form.OrdenFechaVencimiento")> checked </cfif>
						>
					  </td>
				  </tr>
					<tr>
						<td>
							<strong>Fecha de Pago Solicitada:</strong>&nbsp;
						</td>
						<td>
							<cf_navegacion name="FechaPago_SP" session="SP" default="" navegacion="">
							<cf_sifcalendario form="formFiltro" value="#form.FechaPago_SP#" name="FechaPago_F" tabindex="1">
						
							&nbsp;&nbsp;(en blanco toma la Fecha de Vencimiento)
						</td>
						<td align="right"> 
							<strong>Oficina:</strong>&nbsp;
						</td>
						<td>
							<cfif isdefined("form.Ocodigo") and form.Ocodigo NEQ -1>	
				                <cf_sifoficinas form="formFiltro" id="#form.Ocodigo#">
				            <cfelse>
				                <cf_sifoficinas form="formFiltro">
				            </cfif>
						</td>

					</tr>
					<tr>
					  <td>
							<strong>Monto Pago solicitado:</strong> 
						</td>
						<td>
						    <!---<input type = "text" id = "montoPagoSolicitado" name = "montoPagoSolicitado"
								    value = "<cfoutput>#form.montoPagoSolicitado#</cfoutput>"/>--->
								<cf_monto decimales="0" size="15" maxlength="15" name="montoPagoSolicitado" 
								    value="#montoSolicitado#">
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<input name="chkTodos" id = "chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
							<label for="chkTodos"><cf_translate key = LB_SeleccionaTodos>Seleccionar Todos</cf_translate></label>
					  	</td>
					</tr>
				</table>
			</form>

			<cfif isdefined("Form.SNcodigo_F") and Len(Trim(Form.SNcodigo_F)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNcodigo_F=" & Form.SNcodigo_F>
			</cfif>
			<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F)) and form.McodigoOri_F NEQ '-1'>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "McodigoOri_F=" & Form.McodigoOri_F>
			</cfif>
            <cfif isdefined("Form.Dfechavenc_D") and Len(Trim(Form.Dfechavenc_D)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Dfechavenc_D=" & Form.Dfechavenc_D>
			</cfif>
			<cfif isdefined("Form.Dfechavenc_F") and Len(Trim(Form.Dfechavenc_F)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Dfechavenc_F=" & Form.Dfechavenc_F>
			</cfif>
            <cfif isdefined("Form.Documento_F") and Len(Trim(Form.Documento_F)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Documento_F=" & Form.Documento_F>
			</cfif>
			<cfif isdefined("Form.Beneficiario_F") and Len(Trim(Form.Beneficiario_F)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Beneficiario_F=" & Form.Beneficiario_F>
			</cfif>

			<cfquery datasource="#session.dsn#" name="lista">
				Select
					IDdocumento,
					Ddocumento as numero,
                    tt.CPTcodigo as referencia,
					sn.SNcodigo,
					SNnombre,
					Dfechavenc,
					m.Mcodigo,
					Mnombre,
					Dfecha,
					EDsaldo-TESDPaprobadoPendiente as Monto,
					''  as FechaPago_SP,
					isnull(o.Odescripcion,'') as Odescripcion
				from EDocumentosCP ed
					left outer join Oficinas o
						on o.Ocodigo= ed.Ocodigo
						and o.Ecodigo=ed.Ecodigo
				  	inner join CPTransacciones tt
						 on tt.Ecodigo 		= ed.Ecodigo
						and tt.CPTcodigo 	= ed.CPTcodigo
					inner join SNegocios sn
						on sn.SNcodigo=ed.SNcodigo
							and sn.Ecodigo=ed.Ecodigo
					inner join Monedas m
						on m.Mcodigo=ed.Mcodigo
				where ed.Ecodigo = #session.Ecodigo#
				  and tt.CPTtipo = 'C'
				    <!--- SE AGREGA FILTRO POR REFERENCIA --->
				    <cfif isdefined('form.cboTransaccion') and #cboTransaccion# neq -1>
						and tt.CPTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboTransaccion#">
					</cfif>
					<cfif isdefined('form.SNcodigo_F') and len(trim(form.SNcodigo_F))>
						and sn.SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo_F#">
					</cfif>
                    <cfif isdefined('form.Dfechavenc_D') and len(trim(form.Dfechavenc_D))>
						<cfparam name="form.Dfechavenc_D" default="#DateFormat(now(),'DD/MM/YYYY')#">
						and Dfechavenc >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.Dfechavenc_D)#">
					</cfif>
					<cfif isdefined('form.Dfechavenc_F') and len(trim(form.Dfechavenc_F))>
						<cfparam name="form.Dfechavenc_F" default="#DateFormat(now(),'DD/MM/YYYY')#">
						and Dfechavenc <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.Dfechavenc_F)#">
					</cfif>
                    <cfif isdefined('form.Documento_F') and len(trim(form.Documento_F))>
						and upper(Ddocumento) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(UCASE(form.Documento_F))#%">
					</cfif>
					<cfif isdefined('form.Beneficiario_F') and len(trim(form.Beneficiario_F))>
						and upper(SNnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(form.Beneficiario_F))#%">
					</cfif>
					<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F)) and form.McodigoOri_F NEQ '-1'>
						and m.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri_F#">
					</cfif>
					<cfif isdefined('form.Ocodigo') and len(trim(form.Ocodigo)) and form.Ocodigo NEQ '-1'>
						and ed.Ocodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
					</cfif>
					and (EDsaldo - TESDPaprobadoPendiente) > 0
					and <!--- Que el documento no esté En preparacion SP o enviada a aprobacion SP --->
						(
                            Select count(1)
                              from TESdetallePago dp
                             where dp.EcodigoOri		= ed.Ecodigo
							   and dp.TESDPtipoDocumento = 1
                               and dp.TESDPidDocumento 	= ed.IDdocumento
                               and dp.TESDPestado 		in (0,1)
                        ) = 0
				    Order by
				        <cfif isDefined("form.OrdenFechaVencimiento")
								    or montoSolicitado GT 0>
				            Dfechavenc asc
				            <cfelse>
				            sn.SNnombre,m.Mcodigo
				        </cfif>
			</cfquery>

			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#lista#"
				desplegar="numero,referencia,SNnombre,Odescripcion,Dfecha,Dfechavenc,Mnombre,Monto"
				etiquetas="Num.Documento,Referencia, Socio Negocio,Oficina,Fecha de<br>Factura, Fecha<BR>Vencimiento, Moneda, Saldo Vence"
				formatos="S,S,S,S,D,D,S,M"
				align="left,left,left,left,center,center,right,right"
				ira="solicitudesCP_sql.cfm"
				form_method="post"
				showLink="no"
				showEmptyListMsg="yes"
				keys="IDdocumento"
				checkboxes="S"
				maxRows="500"
				formName="formListaAsel"
				botones="Seleccionar,Siguiente,Lista_Solicitudes"
				navegacion="#navegacion#"
			/>
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	</table>
	<script language="javascript" type="text/javascript">
		$(document).ready(function(){
				var montoPago = $("#montoPagoSolicitado").val();
				if(parseFloat(montoPago) > 0) {
					  MarcarMontoSolicitado(true, montoPago);
				}
				else{
					  MarcarMontoSolicitado(false, 0);
				}
		});
	</script>
	<cf_web_portlet_end>
<script language="javascript" type="text/javascript">
	<!--- document.getElementById("loader").style.display = "none"; --->
	function funcLista_Solicitudes(){
		location.href='solicitudesCP.cfm?PASO=0';
		return false;
	}

  function MarcarMontoSolicitado(status, monto){
			if(status) {
				  var allTotalSelected = 0;
				  for(counter = 0; counter < document.formListaAsel.chk.length; counter++) {
						  var parentTR = document.formListaAsel.chk[counter].parentElement.parentElement;
						  var childTD = $(parentTR).find("td.pStyle_Monto");
						  var totalRow = $.trim(childTD.text()).replace(',', '');
							allTotalSelected += parseFloat(totalRow);
							//console.log(totalRow + " : " + allTotalSelected);
							if(allTotalSelected <= monto){
							    document.formListaAsel.chk[counter].checked = true;
							}
							else{
								counter = document.formListaAsel.chk.length;
								break;
							}
			 	  }
			}
			else {
					for (var counter = 0; counter < document.formListaAsel.chk.length; counter++) {
						if((document.formListaAsel.chk[counter].checked) && (!document.formListaAsel.chk[counter].disabled)) {  
								document.formListaAsel.chk[counter].checked = false;
						}
					}
			}
	}

	function Marcar(c) {
		if (c.checked) {
			for (counter = 0; counter < document.formListaAsel.chk.length; counter++)
			{
				if ((!document.formListaAsel.chk[counter].checked) && (!document.formListaAsel.chk[counter].disabled))
					{  document.formListaAsel.chk[counter].checked = true;}
			}
			if ((counter==0)  && (!document.formListaAsel.chk.disabled)) {
				document.formListaAsel.chk.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.formListaAsel.chk.length; counter++)
			{
				if ((document.formListaAsel.chk[counter].checked) && (!document.formListaAsel.chk[counter].disabled))
					{  document.formListaAsel.chk[counter].checked = false;}
			};
			if ((counter==0) && (!document.formListaAsel.chk.disabled)) {
				document.formListaAsel.chk.checked = false;
			}
		};
	}
	function funcSeleccionar()
	{
		document.getElementById("FechaPago_SP").value = document.getElementById("FechaPago_F").value
	}

	function funcSiguiente()
	{
		document.getElementById("FechaPago_SP").value = document.getElementById("FechaPago_F").value
	}
	document.formFiltro.SNnumero.focus();
</script>