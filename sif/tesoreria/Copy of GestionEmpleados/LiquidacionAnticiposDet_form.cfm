<cfset btnNamePlanCompras="PlanCompras">
<cfset btnValuePlanCompras= "Plan de Compras">
<!---Formulado por en parametros generales--->
<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarParametroPlanCom=1> <!---1 equivale a plan de compras en parametros generales--->

<cfif isdefined('url.GELGid')> 
	<cfparam name="form.GELGid" default="#url.GELGid#">
</cfif>
<cfif isdefined('form.GELGid')>
<cfparam name="form.GELGid" default="#form.GELGid#">
</cfif>

<cfif isdefined('form.GELGid') and len(trim(form.GELGid))>
	<cfset modoD = 'CAMBIO'>
<cfelse>
	<cfset modoD = 'ALTA'>
</cfif>
<cfset LvarTipoDocumento = 7>


<!--- Tipo Gasto--->
<cfquery datasource="#Session.DSN#" name="rsID_tipo_gasto">
	select 
		GETdescripcion,
		GETid
	from GEtipoGasto
	where Ecodigo = #session.Ecodigo#
</cfquery>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select e.Mcodigo, m.Miso4217
	from Empresas e 
		inner join Monedas m on m.Mcodigo = e.Mcodigo
	where e.Ecodigo = #Session.Ecodigo#	
</cfquery>

<!--- Moneda Liquidacion --->
<cfquery name="rsMonedaLiquidacion" datasource="#Session.DSN#">
	select m.Miso4217
	from GEliquidacion l
		inner join Monedas m on m.Mcodigo = l.Mcodigo
	where l.GELid=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
</cfquery>

<cfset LvarTotalLineas	= 0>
<cfset LvarTotalPagado  = 0>
<cfset LvarTotalTCE		= 0>
<cfif modoD EQ 'CAMBIO'>
	<cfquery datasource="#session.dsn#" name="rsFormDet">
		Select 	dl.GELGid,
				dl.GELGnumeroDoc,
				dl.GELGdescripcion, 
				dl.CFcuenta, 
				dl.GELGmontoOri, dl.GELGtotalOri, dl.GELGtotalRetOri, 
				dl.GELGmonto, dl.GELGtotal, dl.GELGtotalRet, 
				dl.GELGfecha,
				dl.Mcodigo, (select Miso4217 from Monedas where Mcodigo=dl.Mcodigo) as Miso4217,
				dl.GELGtipoCambio,
				dl.GELGproveedor,
				dl.GECid,
				dl.ts_rversion,
				dl.SNcodigo,
				dl.Rcodigo,
                dl.FPAEid,
            	dl.CFComplemento
		from GEliquidacionGasto dl
			left join CFuncional cf
			  on cf.CFid = dl.CFid
		where dl.GELid=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		  and dl.GELGid=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
	</cfquery>
	
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select 	count(1) as cantidad,
				coalesce(sum(g.GELGmontoOri - g.GELGtotalRetOri),0) as totalPagado,
				coalesce(sum(t.GELTmontoOri),0) as totalTCE
		  from GEliquidacionGasto g
		  	left join GEliquidacionTCE t
				 on t.GELid		= g.GELid
				and t.GELGid = g.GELGid
		 where g.GELid=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		   and g.GELGid<>  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
		   and g.GELGnumeroDoc = '#rsFormDet.GELGnumeroDoc#'
		   and g.GELGproveedor = '#rsFormDet.GELGproveedor#'
	</cfquery>
	<cfset LvarTotalLineas	= rsSQL.cantidad>
	<cfset LvarTotalPagado  = rsSQL.totalPagado>
	<cfset LvarTotalTCE		= rsSQL.totalTCE>

	<cfquery datasource="#session.dsn#" name="rsTipo">
		select GETid, GECid 
		from  
		GEconceptoGasto 
		where GECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDet.GECid#">
	</cfquery>
	<!------ Socio de negocio ------>
	<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
		select SNid, SNcodigo, SNidentificacion, SNnombre, SNcuentacxp,Cdescripcion
		from SNegocios a left outer join CContables b
		  on a.Ecodigo = b.Ecodigo  and 
			  a.SNcuentacxp = b.Ccuenta
		where a.Ecodigo = #Session.Ecodigo#
		  <cfif isdefined('rsFormDet.SNid')>
		  and SNcodigo = #rsFormDet.SNid#
		  </cfif>
	</cfquery>
</cfif>


<!--- SQL selecciona el concepto asociado a una liquidacion--->
		<cfquery datasource="#Session.DSN#" name="rsID_concepto_gasto">
			select 
				c.GECdescripcion,
				c.GECid,
				c.GETid,
				c.GECcomplemento
			from GEconceptoGasto c
				inner join GEtipoGasto t
				on  c.GETid = t.GETid
			where Ecodigo = #session.Ecodigo#
				<cfif modoD eq "ALTA">
				and c.GETid= (
									select 
										min(GETid)
									from GEtipoGasto
									where Ecodigo = #session.Ecodigo#
									)
				<cfelse>
				and c.GETid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipo.GETid#">
			</cfif>
		</cfquery>

<!--- SQL FIN--->
	<cfquery datasource="#Session.DSN#" name="rsconcepto">
		select distinct
			c.GECdescripcion,
			c.GECid,
			c.GETid,
			c.GECcomplemento
		  from GEliquidacionAnts a
			inner join GEanticipoDet b
				inner join GEconceptoGasto c
					 on c.GECid= b.GECid
				 on b.GEAid = a.GEAid
				 and b.GEADid=a.GEADid
		 where a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>


<!---QUERYS PARA EL CAMBIO Y PARA LA CUENTA FINANCIERA--->
	<cfquery datasource="#session.dsn#" name="listaDetiq">
			select
				a.GELid,
				a.GELGid,
				a.GECid,
				a.CFcuenta,
				a.GELGtotalOri,
				b.GECdescripcion
			from GEliquidacionGasto a
				inner join GEconceptoGasto b
				on b.GECid=a.GECid			
			where GELid=#form.GELid#
	</cfquery>
<!-----QUERY DE  RETENCIONES ------>	
	<cfquery name="rsRetenciones" datasource="#Session.DSN#">
			select Rcodigo, Rdescripcion 
			from Retenciones 
			where Ecodigo = #Session.Ecodigo#
			order by Rdescripcion
	</cfquery>
<script language="javascript" type="text/javascript">
<!-- 
//Browser Support Code
function ajaxFunction_ComboConcepto(GECid){
	var ajaxRequest;  // The variable that makes Ajax possible!
	var vID_tipo_gasto ='';
	var vmodoD ='';
	vID_tipo_gasto = document.formDet.tipo.value;
	vmodoD = document.formDet.modoD.value;
	vID_liquidacion=document.formDet.GELid.value;
	try{
		// Opera 8.0+, Firefox, Safari
		ajaxRequest = new XMLHttpRequest();
	} catch (e){
		// Internet Explorer Browsers
		try{
			ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try{
				ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e){
				// Something went wrong
				alert("Your browser broke!");
				return false;
			}
		}
	}

	ajaxRequest.open("GET", '/cfmx/sif/tesoreria/GestionEmpleados/ComboConcepto.cfm?GETid='+vID_tipo_gasto+'&modoD='+vmodoD+'&GELid='+vID_liquidacion, false);
	ajaxRequest.send(null);
	document.getElementById("contenedor_Concepto").innerHTML = ajaxRequest.responseText;
	if(GECid)
		document.getElementById('Concepto').value = GECid;
}

//funcion que asigna los valores que vienen cuando se escoje el popup de plan de compras
function fnAsignarValores(GETid,GECid,cuenta,LvarPCGDid){
    document.formDet.CFcuenta.value = cuenta;
	document.formDet.PCGDid.value = LvarPCGDid;
	document.formDet.tipo.value = GETid;
	document.formDet.ConceptoGasto.value = GECid;
	ajaxFunction_ComboConcepto(GECid);
}
//-->
</script>

<cfoutput>
	<form action="LiquidacionAnticipos_sql.cfm?tipo=#LvarSAporEmpleadoSQL#" onsubmit="return validaDet(this);" method="post" name="formDet" id="formDet"
	/>
			<input type="hidden" name="modoD" value="#modoD#">
			<input type="hidden" name="GELid" value="<cfif isdefined('form.GELid')>#form.GELid#</cfif>">
			<input type="hidden" name="GELnumero" value="<cfif isdefined('form.GELnumero')>#rsForm.GELnumero#</cfif>">	
			<input type="hidden" name="GELGid" value="<cfif isdefined('form.GELGid')>#form.GELGid#</cfif>">
			<!---CFcuenta y ConceptoGasto se usa cuando es por plan de compras y se le da valor con el pop up--->
			<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>
				<input type="hidden" name="CFcuenta" id="CFcuenta" value="">
				<input type="hidden" name="ConceptoGasto" id="ConceptoGasto" value="">
				<input type="hidden" name="PCGDid" id="PCGDid" value="">
			</cfif>
			<table align="center" summary="Tabla de entrada" width="100%" border="0">
              <tr>
                <!--- Nmero de Documento--->
                <td align="right" valign="top" colspan="colspan"><strong>N&uacute;m. Doc:</strong></td>
                <td valign="top" align="left">
				<input type="text" name="GELGnumeroDoc" id="GELGnumeroDoc" value="<cfif modoD NEQ 'ALTA'>#trim(rsFormDet.GELGnumeroDoc)#</cfif>"
				tabindex="1">
                </td>
                <!--- Fecha --->
                <td valign="top" nowrap align="right"><strong>Fecha Factura:&nbsp;</strong> </td>
                <td valign="top" align="left"><cfset fechadoc = LSDateFormat(Now(),'dd/mm/yyyy')>
                    <cfif modoD NEQ 'ALTA'>
                      <cfset fechadoc = LSDateFormat(rsFormDet.GELGfecha,'dd/mm/yyyy') >
                    </cfif>
                    <cf_sifcalendario form="formDet" value="#fechadoc#" name="GELGfecha" tabindex="1">
                </td>
              </tr>
              <tr>
                <!--- Proveedor de servicio--->
                <td align="right" nowrap="nowrap"><strong>Proveedor:</strong></td>
                   <td valign="top" align="left" nowrap="nowrap" colspan="8"><!---<input type="text" name="GELGproveedor" id="GELGproveedor" value="<cfif modoD NEQ 'ALTA'>#trim(rsFormDet.GELGproveedor)#</cfif>" size="60" maxlength="100" tabindex="1"/>--->
                     <cfif modoD neq 'ALTA'>
					  <cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P" size="55" frame="frame1" form="formDet" idquery="#rsFormDet.SNcodigo#">         
					 <cfelse>
					 <cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P" size="55" frame="frame1" form="formDet">         
					 </cfif>
    			   </td>
              </tr>
              <tr>
                <!--- Tipo Gasto--->
				<cfquery datasource="#Session.DSN#" name="rsSQL">
					select count(1) as cantidad
					  from GEliquidacionAnts a
					 where a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
				</cfquery>
                <td nowrap="nowrap" align="right"><strong>Tipo Gasto:</strong></td>
                <td><select name="Tipo" id="tipo" onchange="ajaxFunction_ComboConcepto();" tabindex="1" <cfif modoD neq "ALTA">disabled="disabled"</cfif> <cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>disabled="disabled"</cfif>>
						<cfif rsID_tipo_gasto.RecordCount>
							<cfif rsSQL.cantidad GT 0>
								<cfset LvarTipoGasto=0>
								<option value="#LvarTipoGasto#"><cfif rsUsaPlanCuentas.Pvalor neq LvarParametroPlanCom>(Anticipos)</cfif></option>
							</cfif>	
						  <cfloop query="rsID_tipo_gasto">
							<option value="#rsID_tipo_gasto.GETid#"<cfif modoD neq "ALTA" and rsID_tipo_gasto.GETid  eq rsTipo.GETid>selected="selected"</cfif>>#rsID_tipo_gasto.GETdescripcion# </option>
						  </cfloop>
						</cfif>	
                  </select>
                </td>
				
                <!--- Concepto del Gasto--->
                <td nowrap="nowrap" align="right"><strong>Concepto Gasto </strong>: </td>
                <td><span id="contenedor_Concepto">
                  <select name="Concepto" id="Concepto" tabindex="1" <cfif modoD neq "ALTA"> disabled="disabled"</cfif> <cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>disabled="disabled"</cfif>>
                   <cfif rsUsaPlanCuentas.Pvalor neq LvarParametroPlanCom>
					   <cfif isdefined("rsID_concepto_gasto") and rsID_concepto_gasto.recordcount gt 0 and NOT isdefined ("LvarTipoGasto")>
						  <cfloop query="rsID_concepto_gasto">
							<option value="#rsID_concepto_gasto.GECid#"<cfif modoD neq "ALTA" and rsID_concepto_gasto.GECid  eq rsFormDet.GECid>selected="selected"</cfif>>#rsID_concepto_gasto.GECdescripcion# </option>
						  </cfloop>
					   <cfelse>
							<cfif isdefined ("LvarTipoGasto")>
								<cfloop query="rsconcepto">
									<option value="#rsconcepto.GECid#"selected="selected">#rsconcepto.GECdescripcion#
									</option>
								</cfloop>
							</cfif>
					   </cfif>
				   <cfelse>
						<option value=""<cfif modoD neq "ALTA" and rsID_concepto_gasto.GECid  eq rsFormDet.GECid> selected="selected"</cfif>><cfif modoD neq "ALTA"> #rsID_concepto_gasto.GECdescripcion#</cfif></option>	
				   </cfif>
                  </select>
                </span> </td>
              </tr>
			#fnActividadEmpresarial()#
              <tr>
                <!--- Descripcion--->
                <td valign="top" align="right" nowrap="nowrap"><strong>Descripci&oacute;n:</strong> </td>
                <td valign="top"colspan="4"><input type="text" name="GELGdescripcion" id="GELGdescripcion" value="<cfif modoD NEQ 'ALTA'>#trim(rsFormDet.GELGdescripcion)#</cfif>"
							size="60" maxlength="65"
							tabindex="1" />
                </td>
              </tr>
			  <tr>
                <!--- Moneda documento --->
                <td valign="top" align="right"><strong>Moneda Doc:</strong></td>
				<td valign="top" colspan="4" nowrap>
				<table cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top" colspan="">
							<cfif  modoD NEQ 'ALTA'>
								<cfset LvarM_Doc = "#rsFormDet.Miso4217#s">
								<cfquery name="rsMoneda" datasource="#session.DSN#">
								  select Mcodigo, Mnombre
								  from Monedas
								  where Mcodigo=
								  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDet.Mcodigo#">
								  and Ecodigo=
								  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								</cfquery>
								<cfif rsForm.GELtotalGastos GT 0>
									<cf_sifmonedas onChange="asignaTCDet();" valueTC="#rsFormDet.GELGtipoCambio#" 	
												form="formDet" Mcodigo="McodigoDet" query="#rsMoneda#" 
												FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1" habilita="S">
								<cfelse>
									<cf_sifmonedas onChange="asignaTCDet();" valueTC="#rsFormDet.GELGtipoCambio#" 
												form="formDet" Mcodigo="McodigoDet" query="#rsMoneda#" 
												FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1">
								</cfif>
							<cfelse>
								<cfset LvarM_Doc = "">
								<cf_sifmonedas onChange="asignaTCDet();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" 
										form="formDet" Mcodigo="McodigoDet"  tabindex="1">
						  </cfif>
						</td>
						<td nowrap>
						<!--- Tipo Cambio --->
							<strong>TC:&nbsp;</strong>
							<cfif modoD NEQ'ALTA'>
								<cfset LvarMonto = rsFormDet.GELGtipoCambio>
							<cfelse>
								<cfset LvarMonto = 0>
							</cfif>
		                    <cf_inputNumber name="GELGtipoCambio" value="#LvarMonto#" size="11" enteros="6" decimales="4" 
											onchange="CambiaTipoD()"
											><input name="M_TC" style="border:none; background:inherit; font-size:9px;" size="5" value="#rsMonedaLocal.Miso4217#s" readonly="true" tabindex="-1"/>
						<!--- Factor de Conversin--->
							<strong>FC:&nbsp;</strong>
							<cfif modoD NEQ 'ALTA'>
								<cfset LvarMonto = rsFormDet.GELGtipoCambio>
							<cfelse>
								<cfset LvarMonto = 0>
							</cfif>
		                    <cf_inputNumber name="factor" value="#LvarMonto#" size="11" enteros="6" decimales="6" 
											onchange="CambiaFactorD()"
											><input name="M_FC" style="border:none; background:inherit; font-size:9px;" size="10" value="<cfif modoD EQ "CAMBIO">#rsMonedaLiquidacion.Miso4217#s/#rsFormDet.Miso4217#</cfif>" readonly="true" tabindex="-1"/>
						</td>
					</tr>
				</table></td>
			</tr>
			<!---- Montos ---->
			<cfif modoD EQ "ALTA">
				<cfset LvarMontoOri = 0>
				<cfset LvarNoAutOri = 0>
				<cfset LvarTotalOri = 0>
			<cfelse>
				<cfset LvarMontoOri = rsFormDet.GELGmontoOri>
				<cfset LvarNoAutOri = rsFormDet.GELGmontoOri - rsFormDet.GELGtotalOri>
				<cfset LvarTotalOri = rsFormDet.GELGtotalOri>
			</cfif>
			<tr>
                <!--- Monto del Documento --->
                <td valign="top" align="right"><strong>Monto Doc:</strong></td>
                <td valign="top">
                    <cf_inputNumber name="GELGmontoOri" value="#LvarMontoOri#" size="15" id="monto" enteros="13" decimales="2" tabindex="1" onChange="CambiaMontoD();">
					<input name="M_Doc1" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
                </td>
				<td align="right" nowrap>
					<strong>No Autorizado:</strong>
				</td>
				<td>
                    <cf_inputNumber name="GELGnoAutOri" value="#LvarNoAutOri#" size="15" id="monto" enteros="13" decimales="2" tabindex="1" onChange="CambiaMontoD();">
					<input name="M_Doc2" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
				</td>
			</tr>
 			<!---Monto en Moneda del Anticipo--->
			<tr>			
				<td align="right">
					<strong>Autorizado:</strong>
				</td>
				<td>
                    <cf_inputNumber name="GELGtotalOri" value="#LvarTotalOri#" size="15" enteros="13" decimales="2" readonly="true">
					<input name="M_Doc3" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
	
					<!------Retencion------>
				</td>				
				<td align="right">
					<select name="Rcodigo" tabindex="1" id="PorcRetenc" onchange="CambiaMontoD();" style="width:130px;">
					<option value="-1" >-- Sin Retención --</option>
					<cfloop query="rsRetenciones">
						<option value="#rsRetenciones.Rcodigo#" 
								<cfif modoD NEQ "ALTA" and rsRetenciones.Rcodigo EQ rsFormDet.Rcodigo>selected</cfif>>#rsRetenciones.Rdescripcion# </option>
					</cfloop>
					</select>
				</td>				
				<td>
                    <cf_inputNumber name="TotalRetenc" size="15" enteros="13" decimales="2" readonly="true">
					<input name="M_Doc4" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
				</td>
			</tr>
			<!---Monto en Moneda del Anticipo--->
			<tr>			
				<td align="right" nowrap>
					<strong>Autorizado LIQ:</strong>
				</td>
				<td>
					<cfif  modoD NEQ 'ALTA'>
						<cfset LvarMonto = NumberFormat(rsFormDet.GELGtotal,",0.00")>
					<cfelse>
						<cfset LvarMonto = "0.00">
					</cfif>
                    <cf_inputNumber name="GELGtotal" size="15" enteros="13" decimales="2" readonly="true">
					<input style="border:none; background:inherit; font-size:9px;" size="10" value="#rsMonedaLiquidacion.Miso4217#s" readonly="true"/>
				</td>
				<!-----Retencion Moneda del Anticipo------->	
				<td align="right">
					<strong>Retención LIQ:</strong>
				</td>
				<td nowrap="nowrap">
                    <cf_inputNumber name="MontoRetencionAnti" size="15" enteros="13" decimales="2" readonly="true">
					<input style="border:none; background:inherit; font-size:9px;" size="10" value="#rsMonedaLiquidacion.Miso4217#s" readonly="true"/>
				</td>
			</tr>
<!------------------------------------------------------------------------------------------------------------------------->
			<!---TCE--->
			<cfquery name="rsTCEs" datasource="#session.dsn#">
				select CBid_TCE, GELTreferencia, GELTmontoOri, GELTmonto, GELTtipoCambio, GELTmontoTCE
				  from GEliquidacionTCE
				<cfif modoD EQ 'CAMBIO'>
				 where GELid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
				   and GELGid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELGid#">
				<cfelse>
				 where GELGid	= -1
				</cfif>
			</cfquery>

			<cfquery name="rsCB_TCE" datasource="#session.dsn#">
				select cb.CBid as CBid_TCE, CBcodigo, Miso4217,
						coalesce((
							select TCventa
							  from Htipocambio
							where Ecodigo = #session.Ecodigo#
							  and Mcodigo=m.Mcodigo
							  and Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							  and Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						),1) as TC
				  from CBTarjetaCredito tce
				  	inner join CuentasBancos cb
						on cb.CBTCid = tce.CBTCid
					inner join Monedas m
						on m.Mcodigo = cb.Mcodigo
					inner join CBStatusTarjetaCredito s
						on s.CBSTid = tce.CBSTid
						and s.CBSTActiva = 1
				 where tce.DEid = #rsForm.DEid#
				<cfif LvarSAporComision>
					UNION
					select cb.CBid as CBid_TCE, CBcodigo, Miso4217,
						coalesce((
							select TCventa
							  from Htipocambio
							where Ecodigo = #session.Ecodigo#
							  and Mcodigo=m.Mcodigo
							  and Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							  and Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						),1) as TC
					  from GEcomisionTCEs ctce
						inner join CuentasBancos cb
							on cb.CBid = ctce.CBid_TCE
						inner join CBTarjetaCredito tce
							on tce.CBTCid = cb.CBTCid
						inner join Monedas m
							on m.Mcodigo = cb.Mcodigo
						inner join CBStatusTarjetaCredito s
							on s.CBSTid = tce.CBSTid
							and s.CBSTActiva = 1
					 where ctce.GECid = #form.GECid_comision#
				</cfif>					 
			</cfquery>
			<tr>			
				<td colspan="6" style="font-size:2px; border-bottom:solid 1px ##CCCCCC">&nbsp;
				
				</td>
			</tr>
			<tr>			
				<td align="right" nowrap>
					<strong>Pago con TCE:</strong>
				</td>
				<td valign="top" colspan="4" nowrap>
						<!-----TCE------->	
						<cfset LvarM_TCE = "">
						<select name="CBid_TCE" style="width:220px;"
								onblur="CambiaTCE(0);"
								onchange="CambiaTCE(1);"
								tabindex="1"
						>
							<option value="-1">(N/A)</option>
						<cfloop query="rsCB_TCE">
							<option value="#rsCB_TCE.CBid_TCE#|#rsCB_TCE.Miso4217#|#rsCB_TCE.TC#"
								<cfif rsTCEs.CBid_TCE EQ rsCB_TCE.CBid_TCE>
									selected
									<cfset LvarM_TCE = "#rsCB_TCE.Miso4217#s">
								</cfif>
							>#rsCB_TCE.CBcodigo# #rsCB_TCE.Miso4217#</option>
						</cfloop>
						</select>&nbsp;
						<!--- Tipo Cambio --->
							<strong>TC:&nbsp;</strong>
							<cfif modoD NEQ'ALTA'>
								<cfset LvarMonto = rsTCEs.GELTtipoCambio>
							<cfelse>
								<cfset LvarMonto = 0>
							</cfif>
		                    <cf_inputNumber name="GELTtipoCambio" value="#LvarMonto#" size="11" enteros="6" decimales="4" 
											onblur="CambiaTCE(0);" onchange="CambiaTCE(0);" 
											tabindex="1"											
											><input style="border:none; background:inherit; font-size:9px;" size="5" value="#rsMonedaLocal.Miso4217#s" readonly="true"/>
						<!--- Factor de Conversin--->
							<strong>FC:&nbsp;</strong>
							<cfif modoD NEQ'ALTA'>
								<cfset LvarMonto = 0>
							<cfelse>
								<cfset LvarMonto = 0>
							</cfif>
		                    <cf_inputNumber name="GELT_FC" value="#LvarMonto#" size="11" enteros="6" decimales="6" 
											onblur="CambiaTCE(0);" onchange="CambiaTCE(2);" 
											tabindex="1"
											><input name="M_FC_TCE" style="border:none; background:inherit; font-size:9px;" size="10" value="<cfif modoD EQ "CAMBIO">#rsMonedaLiquidacion.Miso4217#s/#rsFormDet.Miso4217#</cfif>" readonly="true" tabindex="-1"/>
				</td>
			</tr>
			<tr id="TR_TCE1" <cfif rsTCEs.CBid_TCE EQ "">style="display:none" </cfif>>
				<td align="right" nowrap>
					<strong>Total Factura:</strong>
				</td>
				<td>
                    <cf_inputNumber name="TotalPagado" value="#LvarTotalPagado+LvarMontoOri#" size="15" enteros="13" decimales="2" readonly="true">
					<input name="M_Doc6" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
				</td>
				<td align="right" nowrap>
					<strong>Maximo Pago:</strong>
				</td>
				<td>
					<cfset LvarPago = rsTCEs.GELTmontoOri>
					<cfif LvarPago EQ ""><cfset LvarPago = 0></cfif>
                    <cf_inputNumber name="MaximoPagar" value="#LvarTotalPagado+LvarMontoOri-LvarTotalTCE#" size="15" enteros="13" decimales="2" readonly="true">
					<input name="M_Doc6" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
				</td>
			</tr>
			<tr id="TR_TCE2" <cfif rsTCEs.CBid_TCE EQ "">style="display:none" </cfif>>
				<td align="right" nowrap="nowrap">
					<strong>Voucher:</strong>
				</td>
				<td nowrap="nowrap">
					<input type="text" name="GELTreferencia" id="GELTreferencia" onfocus="CambiaTCE(0);" size="20" tabindex="1" value="#rsTCEs.GELTreferencia#"/>
				</td>
				<td align="right" nowrap>
					<strong>Monto Pago:</strong>
				</td>
				<td nowrap="nowrap">
                    <cf_inputNumber name="GELTmontoOri" value="#rsTCEs.GELTmontoOri#" onchange="CambiaTCE(0);" onfocus="CambiaTCE(0);" size="15" enteros="13" decimales="2" tabindex="1">
					<input name="M_Doc5" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
				</td>
			</tr>
			<tr id="TR_TCE3" <cfif rsTCEs.CBid_TCE EQ "">style="display:none" </cfif>>
				<td align="right" nowrap="nowrap">
					<strong>Monto LIQ:</strong>
				</td>
				<td nowrap="nowrap">
                    <cf_inputNumber name="GELTmonto" value="#rsTCEs.GELTmonto#" size="15" enteros="13" decimales="2" readonly="true">
					<input style="border:none; background:inherit; font-size:9px;" size="10" value="#rsMonedaLiquidacion.Miso4217#s" readonly="true" tabindex="-1"/>
				</td>
				<td align="right" nowrap="nowrap">
					<strong>Monto TCE:</strong>
				</td>
				<td nowrap="nowrap">
                    <cf_inputNumber name="GELTmontoTCE" value="#rsTCEs.GELTmontoTCE#" size="15" enteros="13" decimales="2" readonly="true">
					<input name="M_TCE" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_TCE#" readonly="true" tabindex="-1"/>
				</td>
			</tr>
			
			
			<tr>
				<td colspan="4" class="formButtons">
					<cf_botones sufijo='Det' modo='#modoD#'  tabindex="1" include="Regresar" includevalues="Lista Gastos">
				</td>					
			</tr>
			<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>
			<tr>
				<td colspan="4" align="center">
					<input type="button"  name="btnPlan"  value="Plan de Compras" tabindex="1" onClick="PlanCompras()" >
					<input type="hidden"  name="LvarParametroPlanCom"  value="">
				</td>
			</tr>
			<cfquery name="rsCFid" datasource="#session.dsn#">
				select CFid from GEliquidacion where GELid=#form.GELid#
			</cfquery>
			<input type="hidden"  name="CFid"  value="#rsCFid.CFid#">
		</cfif>	
<iframe name="monedax1" id="monedax1" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
<iframe name="retencionX" id="retencionX" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
            </table>
			<cfif modoD NEQ 'ALTA'>			
				<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#rsFormDet.ts_rversion#" returnvariable="ts">				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfif>
			
</form>
</cfoutput>
<cfoutput>

<!--- MONEDAS--->
<script language="javascript">
function funcCambioDet(){
		CambiaTCE(0);
	}

function CambiaTipoD(m){
        Rcodigo = document.formDet.Rcodigo.value;
		monto=document.formDet.GELGtotalOri.value;
		tipo=document.formDet.GELGtipoCambio.value;
		moneda = document.formDet.McodigoDet.value;
		id_liqui=document.formDet.GELid.value;
		fecha=document.formDet.GELGfecha.value;
		document.getElementById('monedax1').src = 'CambiaMLiquid.cfm?Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'&tipo='+tipo+'&Monto='+monto+'&Rcodigo='+encodeURIComponent(Rcodigo)+'';
	}
	
function CambiaMontoD(m){
     
		montoOri=parseFloat(qf(document.formDet.GELGmontoOri.value));
		noAutOri=parseFloat(qf(document.formDet.GELGnoAutOri.value));
		if (montoOri < noAutOri)
		{
			document.formDet.GELGnoAutOri.value = document.formDet.GELGmontoOri.value;
			noAutOri = montoOri;
		}
		document.formDet.GELGtotalOri.value = fm(montoOri - noAutOri,2);

		tipo=document.formDet.GELGtipoCambio.value;
		moneda = document.formDet.McodigoDet.value;
		id_liqui=document.formDet.GELid.value;
		fecha=document.formDet.GELGfecha.value;
	    Rcodigo = document.formDet.Rcodigo.value;
		document.getElementById('monedax1').src = 'CambiaMLiquid.cfm?Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'&tipo='+tipo+'&Monto='+montoOri+'&Rcodigo='+encodeURIComponent(Rcodigo)+'';
		CambiaTCE(0);
		<!---MontoRetenc();--->
}

CambiaTCE(0);	
function CambiaTCE(tc)
{
	LvarDoc_Cod = document.formDet.M_Doc1.value.substring(0,3);
	LvarTCE 	= document.formDet.CBid_TCE.value;
	LvarTCE_TC_RO	= false	;

	LvarMontoDoc = qf(document.formDet.GELGmontoOri.value);
	if (LvarMontoDoc == "" || LvarMontoDoc == 0)
		LvarMontoDoc = 0;
	else
		LvarMontoDoc = parseFloat(LvarMontoDoc);

	if (document.formDet.CBid_TCE.selectedIndex == 0)
	{
		document.formDet.GELTtipoCambio.disabled = true;
		document.formDet.GELT_FC.disabled = true;
	
		document.formDet.GELTtipoCambio.value = "";
		document.formDet.GELT_FC.value = "";
		
		document.formDet.M_FC_TCE.value = "";
		document.formDet.M_TCE.value = "";
		
		document.formDet.GELTmonto.value	= "";
		document.formDet.GELTmontoTCE.value = "";
		
		document.getElementById('TR_TCE1').style.display='none';
		document.getElementById('TR_TCE2').style.display='none';
		document.getElementById('TR_TCE3').style.display='none';
	}
	else
	{
		document.getElementById('TR_TCE1').style.display='';
		document.getElementById('TR_TCE2').style.display='';
		document.getElementById('TR_TCE3').style.display='';

		LvarTCE_Cod	= LvarTCE.split("|")[1];

		LvarMonto = qf(document.formDet.GELTmontoOri.value);
		if (LvarMonto == "" || LvarMonto == 0)
			LvarMonto = 0;
		else
			LvarMonto = parseFloat(LvarMonto);

		LvarDOC_TC = qf(document.formDet.GELGtipoCambio.value);
		if (LvarDOC_TC == "" || LvarDOC_TC == 0)
			LvarDOC_TC = 1;
		else
			LvarDOC_TC = parseFloat(LvarDOC_TC);

		LvarDOC_FC = qf(document.formDet.factor.value);
		if (LvarDOC_FC == "" || LvarDOC_FC == 0)
			LvarDOC_FC = 1;
		else
			LvarDOC_FC = parseFloat(LvarDOC_FC);

		LvarTCE_FC = document.formDet.GELT_FC.value;
		if (LvarTCE_FC == "" || LvarTCE_FC == 0)
			LvarTCE_FC = 1;
		else
			LvarTCE_FC = parseFloat(LvarTCE_FC);

		LvarTCE_FC = document.formDet.GELT_FC.value;
		if (LvarTCE_FC == "" || LvarTCE_FC == 0)
			LvarTCE_FC = 1;
		else
			LvarTCE_FC = parseFloat(LvarTCE_FC);

		if (LvarTCE_Cod == '#rsMonedaLocal.Miso4217#')
		{
			LvarTCE_TC	= 1;
			LvarTCE_FC	= LvarTCE_TC / LvarDOC_TC;
			LvarTCE_TC_RO	= true;
		}
		else if (LvarTCE_Cod == '#rsMonedaLiquidacion.Miso4217#')
		{
			LvarTCE_TC	= #rsForm.GELtipoCambio#;
			LvarTCE_FC	= LvarTCE_TC / LvarDOC_TC;
			LvarTCE_TC_RO	= true;
		}
		else if (LvarTCE_Cod == LvarDoc_Cod)
		{
			LvarTCE_TC	= LvarDOC_TC;
			LvarTCE_FC	= LvarTCE_TC / LvarDOC_TC;
			LvarTCE_TC_RO	= true;
		}
		else if (tc == 1)	// Cambia TCE
		{
			LvarTCE_TC	= LvarTCE.split("|")[2];
			LvarTCE_FC	= LvarTCE_TC / LvarDOC_TC;
			LvarTCE_TC_RO	= false;
		}
		else if (tc == 2)	// Cambia FC
		{
			LvarTCE_TC	= LvarTCE_FC * LvarDOC_TC;
			LvarTCE_TC_RO	= false;
		}
		else				// Cambia TC u otro dato
		{
			LvarTCE_TC	= document.formDet.GELTtipoCambio.value;
			LvarTCE_FC	= LvarTCE_TC / LvarDOC_TC;
			LvarTCE_TC_RO	= false;
		}
		LvarGELT_Mori = document.formDet.GELTmontoOri.value;
		LvarGELT_Mliq = document.formDet.GELTmonto.value;

		document.formDet.GELTtipoCambio.disabled = LvarTCE_TC_RO;
		document.formDet.GELT_FC.disabled = LvarTCE_TC_RO;
	
		document.formDet.GELTtipoCambio.value = fm(LvarTCE_TC,4)	;
		document.formDet.GELT_FC.value = fm(LvarTCE_FC,6);
		
		document.formDet.M_FC_TCE.value = LvarTCE_Cod + "s/" + LvarDoc_Cod;
		document.formDet.M_TCE.value = LvarTCE_Cod + "s";
		
		document.formDet.GELTmonto.value	= fm(LvarMonto * LvarDOC_FC,2) ;
		if (LvarTCE_FC == "" || LvarTCE_FC == 0)
			document.formDet.GELTmontoTCE.value = "";
		else
			document.formDet.GELTmontoTCE.value = fm(LvarMonto / LvarTCE_FC,2);

	}
	document.formDet.TotalPagado.value	= fm(#LvarTotalPagado# + LvarMontoDoc,2) ;
	document.formDet.MaximoPagar.value	= fm(#LvarTotalPagado-LvarTotalTCE# + LvarMontoDoc,2) ;
}

function CambiaFactorD(m){
        Rcodigo = document.formDet.Rcodigo.value;
		tipo=document.formDet.GELGtipoCambio.value;
		monto=document.formDet.GELGtotalOri.value;
		moneda = document.formDet.McodigoDet.value;
		id_liqui=document.formDet.GELid.value;
		fecha=document.formDet.GELGfecha.value;
		factor=document.formDet.factor.value;
		document.getElementById('monedax1').src = 'CambiaMLiquid.cfm?Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'&tipo='+tipo+'&Monto='+monto+'&factor='+factor+'&Rcodigo='+encodeURIComponent(Rcodigo)+'';
}
</script>

<!--- VALIDACIONE DEL FORMULARIO--->
<script language="javascript">

	function validaDet(formulario)	
	{
		
	  <!--- objForm.SNcodigo.required = true;
		objForm.SNcodigo.description = "Proveedor";
		alert(formulario.GELGnumeroDoc.value);
			 alert("value");--->
			 
		
		   document.formDet.TotalRetenc.disabled=false;
		   document.formDet.MontoRetencionAnti.disabled=false;
		   document.formDet.GELGtotal.disabled=false;
		   document.formDet.GELGtipoCambio.disabled=false;
		  <!--- document.formDet.tipo.disabled=false;
		   document.formDet.Concepto.disabled=false;--->
		   
		if (!btnSelectedDet('NuevoDet',document.formDet) && !btnSelectedDet('BajaDet',document.formDet)  && !btnSelectedDet('RegresarDet',document.formDet))
		{
			var error_input = null;
			var error_msg = '';
			if (formulario.GELGnumeroDoc.value == "") 
			{
				error_msg += "\n - El número de documento no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.GELGnumeroDoc;
			}
			if (formulario.GELGfecha.value == "") 
			{
				error_msg += "\n - La fecha no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.GELGfecha;
			}
			if (formulario.McodigoDet.value == "") {
				error_msg += "\n - La Moneda no puede quedar en blanco.";
				error_input = formulario.McodigoDet;
			}
			if (formulario.SNcodigo.value == "") 
			{
				error_msg += "\n - El Proveedor del Servicio no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.GELGproveedor;
			}
			<cfif modoD EQ "alta">
			if (formulario.Concepto.value == "") 
			{
				error_msg += "\n - El concepto y tipo de gastos no pueden quedar en blanco.";
				if (error_input == null) error_input = formulario.Concepto;
			}
			</cfif>
			if (formulario.GELGdescripcion.value == "") 
			{
				error_msg += "\n - La descripcin no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.GELGdescripcion;
			}
			if (formulario.GELGtotalOri.value == "") 
			{
				error_msg += "\n - El Monto no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.GELGtotalOri;
			}	
				
			
			 if (parseFloat(formulario.GELGtotal.value) <= 0)
			{
				error_msg += "\n - El monto en moneda del anticipo debe ser mayor que cero.";
				if (error_input == null) error_input = formulario.GELGtotalOri;
			}
			else if (parseFloat(formulario.GELGtotalOri.value) <= 0)
			{
				error_msg += "\n - El monto autorizado debe ser mayor que cero.";
				if (error_input == null) error_input = formulario.GELGtotalOri;
			}

			if (document.formDet.CBid_TCE.selectedIndex != 0)
			{
				if (document.formDet.GELTreferencia.value == "") 
				{
					error_msg += "\n - Referencia de TCE no puede quedar en blanco.";
					if (error_input == null) error_input = document.formDet.GELTreferencia;
				}	
				
				if (document.formDet.GELTmontoOri.value == "") 
				{
					error_msg += "\n - Monto Pago por TCE no puede quedar en blanco.";
					if (error_input == null) error_input = document.formDet.GELTmontoOri;
				}	
				else if (document.formDet.GELTmontoOri.value == "0.00") 
				{
					error_msg += "\n - Monto Pago por TCE no puede quedar en cero.";
					if (error_input == null) error_input = document.formDet.GELTmontoOri;
				}	
				else if (parseFloat(qf(document.formDet.GELTmontoOri.value)) > parseFloat(qf(document.formDet.MaximoPagar.value))) 
				{
					error_msg += "\n - Monto Pago por TCE no puede ser mayor a " + document.formDet.MaximoPagar.value + " " + document.formDet.M_Doc1.value + ".";
					if (error_input == null) error_input = document.formDet.GELTmontoOri;
				}	
			}
			
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				try 
				{
					error_input.focus();
				} 
				catch(e) 
				{}
				
				return false;
			}
							
		}
		formulario.GELGtotalOri.value=qf(formulario.GELGtotalOri);
		formulario.GELGtotal.value=qf(formulario.GELGtotal);
		if(formulario.GELGtipoCambio.disabled)
		formulario.GELGtipoCambio.disabled = false;
		formulario.factor.disabled = false;
		formulario.GELGtotal.disabled = false;
		document.formDet.GELTtipoCambio.disabled = false;
		document.formDet.GELT_FC.disabled = false;
		return true;
	}
/* aqu asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
function asignaTCDet() {      
	if (document.formDet.McodigoDet.value == "#rsMonedaLocal.Mcodigo#") {
        Rcodigo = document.formDet.Rcodigo.value;
		monto=document.formDet.GELGtotalOri.value;
		formatCurrency(document.formDet.TC,2);
		document.formDet.GELGtipoCambio.disabled = true;
		moneda = document.formDet.McodigoDet.value;
		id_liqui=document.formDet.GELid.value;
		fecha=document.formDet.GELGfecha.value;
		tipo=document.formDet.GELGtipoCambio.value;
		document.getElementById('monedax1').src = 'CambiaMLiquid.cfm?Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'&tipo='+tipo+'&Monto='+monto+'&Rcodigo='+encodeURIComponent(Rcodigo)+'';
	}                 

	else
        Rcodigo = document.formDet.Rcodigo.value;
		monto=document.formDet.GELGtotalOri.value;
		document.formDet.GELGtipoCambio.disabled = false;
		var estado = document.formDet.GELGtipoCambio.disabled;
		document.formDet.GELGtipoCambio.disabled = false;
		document.formDet.GELGtipoCambio.value = fm(document.formDet.TC.value,4);
		document.formDet.GELGtipoCambio.disabled = estado;
		moneda = document.formDet.McodigoDet.value;
		id_liqui=document.formDet.GELid.value;
		fecha=document.formDet.GELGfecha.value;
		tipo=document.formDet.GELGtipoCambio.value;
		document.getElementById('monedax1').src = 'CambiaMLiquid.cfm?Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'&tipo='+tipo+'&Monto='+monto+'&Rcodigo='+encodeURIComponent(Rcodigo)+'';
}
document.formDet.GELGtipoCambio.value='1.0000';
asignaTCDet();

<!--- function MontoRetenc()
{   
   var valor = 0; 
 if(document.formDet.GELGtotalOri.value != ''&& document.formDet.Rcodigo.value != '' && document.formDet.Rcodigo.value != -1)
 {
	var monto   = document.formDet.GELGtotalOri.value;
	var Rcodigo = document.formDet.Rcodigo.value
	document.getElementById('retencionX').src = 'CambiaMretencion.cfm?Rcodigo='+Rcodigo+'&monto='+monto+'';
 }
 else
  {
   document.getElementById("montoRetenc").value = 0;
   }
} --->
function PlanCompras()
{
	var Lvartipo = 'S';
	var LvarCFid = document.form1.CFid.value;
	var LvarGELid=document.form1.GELid.value;
	var LvarGELfecha=document.form1.GELfecha.value;
		
	if((Lvartipo != '') && (LvarCFid != '')&& (LvarGELid != ''))
	{
		window.open('LiquidacionPopUp-planDeCompras.cfm?tipo='+Lvartipo+'&GELid='+LvarGELid+'&CFid='+LvarCFid+'&GELfecha='+LvarGELfecha,'popup','width=1000,height=500,left=200,top=50,scrollbars=yes');
	}
	else
	{
	 alert("Falta el Tipo en el detalle o el Id del Centro Funcional ");
	}  
}

	</script>
</cfoutput>
<cffunction name="fnActividadEmpresarial" output="true">
	<!----- Actividad Empresarial ------->
	<!---►►Actividad Empresarial (N-No se usa AE, S-Se usa Actividad Empresarial)◄◄--->
	<cfquery name="rsActividad" datasource="#session.DSN#">
		  Select Coalesce(Pvalor,'0') as Pvalor 
		   from Parametros 
		   where Pcodigo = 2200 
			 and Mcodigo = 'CG'
			 and Ecodigo = #session.Ecodigo# 
	</cfquery>
	<cfif rsActividad.Pvalor eq 'S'<!--- and rsFormularPor.Pvalor eq 0--->>
		  <cfset idActividad = "">
		  <cfset valores = "">
		  <cfset lvarReadonly = false>
		  <cfif modoD NEQ "ALTA">
				<cfset idActividad = rsFormDet.FPAEid>
				<cfset valores = rsFormDet.CFComplemento>
				<cfset lvarReadonly = false>
		  </cfif>	
		<tr>
			<td align="right"><strong>Act.Empresarial:</strong></td>
			<td colspan="3">
				<cf_ActividadEmpresa etiqueta="" idActividad="#idActividad#" valores="#valores#" name="CFComplemento" nameId="FPAEid" formname="formDet">
			</td>
		</tr>
	</cfif>
</cffunction>
