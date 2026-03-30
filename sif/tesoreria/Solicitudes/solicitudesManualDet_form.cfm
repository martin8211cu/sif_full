<cfinvoke key="MSG_NecesarioConceptoParaDistribucion" default="Es necesario definir un concepto cuando se elije una distribucion"	returnvariable="MSG_NecesarioConceptoParaDistribucion"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaDocto" default="El Número de Documento no puede quedar en blanco"	returnvariable="MSG_ValidaDocto"	method="Translate" component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaDescripcion" default="La Descripción no puede quedar en blanco"	returnvariable="MSG_ValidaDescripcion"	method="Translate" component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaReferencia" default="La Referencia no puede quedar en blanco"	returnvariable="MSG_ValidaReferencia"	method="Translate" component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaPagosTerceros" default="El Concepto de Pagos a Terceros no puede quedar en blanco"	returnvariable="MSG_ValidaPagosTerceros"	method="Translate" component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaCtaFinanciera" default="La Cuenta Financiera no puede quedar en blanco"	returnvariable="MSG_ValidaCtaFinanciera"	method="Translate" component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaCF" default="El Centro Funcional no puede quedar en blanco"	returnvariable="MSG_ValidaCF"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaMontoSolicitado" default="El monto solicitado no puede quedar en blanco"	returnvariable="MSG_ValidaMontoSolicitado"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaMontoSolicitMayorCero" default="El monto solicitado debe ser mayor que cero"	returnvariable="MSG_ValidaMontoSolicitMayorCero"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaMontoMenorSaldoSuficiencia" default="El monto solicitado debe ser menor que el saldo de la suficiencia"	returnvariable="MSG_ValidaMontoMenorSaldoSuficiencia"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ReviseDatos" default="Por favor revise los siguiente datos"	returnvariable="MSG_ReviseDatos"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>


<!---??Actividad Empresarial (N-No se usa Actividad Empresarial, S-Se usa Actividad Empresarial)??--->
<cfquery name="rsActividad" datasource="#session.DSN#">
  Select Coalesce(Pvalor,'N') as Pvalor
   from Parametros
   where Pcodigo = 2200
     and Mcodigo = 'CG'
     and Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsSQL" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=1216
</cfquery>
<cfif rsSQL.Pvalor eq 1>
	<cfset LvarDigitarImpNCF = "">
<cfelse>
	<cfset LvarDigitarImpNCF = "none">
</cfif>

<cfif isdefined("LvarPorCFuncional")>
	<cfset LvarTipoDocumento = 5>
	<cfset LvarSufijoForm = "CF">
<cfelse>
	<cfset LvarTipoDocumento = 0>
	<cfset LvarSufijoForm = "">
</cfif>
<cfif isdefined("LvarFiltroPorUsuario") and #LvarFiltroPorUsuario#>
	<cfset LvarTipoDocumento = 5>
	<cfset LvarSufijoForm = "CFusuario">
</cfif>

<cfif isdefined('url.TESDPid') and not isdefined('form.TESDPid')>
	<cfparam name="form.TESDPid" default="#url.TESDPid#">
</cfif>
<cfparam name="form.TESDPid" default="">
<cfif isdefined('form.TESDPid') and len(trim(form.TESDPid))>
	<cfset modoD = 'CAMBIO'>
<cfelse>
	<cfset modoD = 'ALTA'>
</cfif>

<cfset btnNameSuf="Suficiencia">
<cfset btnValueSuf= "Suficiencia">

<!---Query General --->
<!--- Impuestos generales --->
<cfquery name="rsImpuestosG" datasource="#session.dsn#">
	select Icodigo, Idescripcion, c.CFcuenta, rtrim(c.CFformato) as CFformato
	from Impuestos i
		inner join CFinanciera c
			on c.Ecodigo = i.Ecodigo
	where i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and i.Icompuesto		= 0
	  and i.Icreditofiscal	= 1
	  <!--- Solo Impuestos Simples porque SP manual no maneja detalle de impuestos al generar contabilidad --->
	  and Icompuesto = 0
	  and c.CFcuenta = (select min(CFcuenta) from CFinanciera cf where cf.Ccuenta = coalesce(i.CcuentaCxPAcred,i.Ccuenta))	 
	  <!--- Solo credito fiscal puro porque solo se digita total y la parte no credito fiscal no se distribuye en las lineas
			cuando se maneje Compuestos en SP manual, solo pueden ser credito fiscal puro, porque la parte no credito fiscal se debe distribuir entre las lineas
			tanto en SP manual como en GE.Liq
	  and (
			select count(1)
			  from DImpuestos
			 where Ecodigo = i.Ecodigo
			   and Icodigo = i.Icodigo
			   and DIcreditofiscal = 0
		) = 0
	 --->
</cfquery>

<!---- Solo impuestos --->
<cfquery name="rsImpuestos" datasource="#session.dsn#">
	select Icodigo, Idescripcion, c.CFcuenta, rtrim(c.CFformato) as CFformato
	from Impuestos i
		inner join CFinanciera c
			on c.Ecodigo = i.Ecodigo
	where i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and i.Icompuesto		= 0
	  and i.Icreditofiscal	= 1
	  <!--- Solo Impuestos Simples porque SP manual no maneja detalle de impuestos al generar contabilidad --->
	  and Icompuesto = 0
	  and c.CFcuenta = (select min(CFcuenta) from CFinanciera cf where cf.Ccuenta = coalesce(i.CcuentaCxPAcred,i.Ccuenta))
	  and (i.ieps != 1 or  i.ieps is null)
	  <!--- Solo credito fiscal puro porque solo se digita total y la parte no credito fiscal no se distribuye en las lineas
			cuando se maneje Compuestos en SP manual, solo pueden ser credito fiscal puro, porque la parte no credito fiscal se debe distribuir entre las lineas
			tanto en SP manual como en GE.Liq
	  and (
			select count(1)
			  from DImpuestos
			 where Ecodigo = i.Ecodigo
			   and Icodigo = i.Icodigo
			   and DIcreditofiscal = 0
		) = 0
	 --->
</cfquery>


<cfquery name="rsImpIeps" datasource="#session.dsn#">
	select Icodigo, Idescripcion, c.CFcuenta, rtrim(c.CFformato) as CFformato
	from Impuestos i
		inner join CFinanciera c
			on c.Ecodigo = i.Ecodigo
	where i.ieps = 1	  
	  and i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and i.Icompuesto		= 0
	  and i.Icreditofiscal	= 1
	  <!--- Solo Impuestos Simples porque SP manual no maneja detalle de impuestos al generar contabilidad --->
	  and Icompuesto = 0
	  and c.CFcuenta = (select min(CFcuenta) from CFinanciera cf where cf.Ccuenta = coalesce(i.CcuentaCxPAcred,i.Ccuenta))
	  <!--- Solo credito fiscal puro porque solo se digita total y la parte no credito fiscal no se distribuye en las lineas
			cuando se maneje Compuestos en SP manual, solo pueden ser credito fiscal puro, porque la parte no credito fiscal se debe distribuir entre las lineas
			tanto en SP manual como en GE.Liq
	  and (
			select count(1)
			  from DImpuestos
			 where Ecodigo = i.Ecodigo
			   and Icodigo = i.Icodigo
			   and DIcreditofiscal = 0
		) = 0
	 --->
</cfquery>

<!---???Consulta la existencia de distribuciones para la empresa???--->
<cfquery datasource="#session.DSN#" name="rsDistribucion">
select
       CPDCid,
       CPDCcodigo,
       CPDCdescripcion,
       CPDCactivo,
       CPDCporcTotal
   from CPDistribucionCostos
		where Ecodigo=#session.Ecodigo#
		and CPDCactivo=1
        and Validada = 1
</cfquery>

<cfif modoD NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="rsFormDet">
		Select dp.TESDPid, edp.TESSPnumero, dp.TESDPdocumentoOri,
               case
					when dp.CPDCid IS NOT NULL and dp.CPDClinea IS NOT NULL then
                    (
                        select sum(TESDPmontoSolicitadoOri)
                        from TESdetallePago
                        where TESSPid= dp.TESSPid
                        and CPDClinea= dp.CPDClinea
                     )
					else dp.TESDPmontoSolicitadoOri
    	       end as TESDPmontoSolicitadoOri,
			   dp.TESDPimpNCFOri,
               dp.TESDPdescripcion,
			   dp.CFcuentaDB,
			   dp.TESDPdocumentoOri, dp.TESDPreferenciaOri, dp.TESRPTCid,
			   dp.CFid, cf.CFcodigo, cf.CFdescripcion, Icodigo,
			   dp.ts_rversion,dp.Cid, dp.CPDCid, dp.TESDPespecificacuenta,
			   dp.CPDDid,
               dp.FPAEid,
               dp.CFComplemento,
			   dp.SNcodigoOri
		from TESdetallePago dp
		inner join TESsolicitudPago edp
			on dp.TESSPid = edp.TESSPid
		left join CFuncional cf
			  on cf.CFid = dp.CFid
		where dp.EcodigoOri = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and dp.TESSPid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
		  and dp.TESDPid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESDPid#">
	</cfquery>
<!--- <cf_dump var="#rsFormDet#"> --->
	<!--- Cuenta Contable --->
	<cfif rsFormDet.recordcount and rsFormDet.CFcuentaDB neq ''>
		<cfquery name="rsCuentasDet" datasource="#Session.DSN#">
			select Ccuenta, CFcuenta, CFformato, CFdescripcion, Cmayor, CFmovimiento
			  from CFinanciera
			 where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDet.CFcuentaDB#">
		</cfquery>
	</cfif>
</cfif>

<cfset LvarEsDistribucion 	= isdefined("rsFormDet.CPDCid") AND rsFormDet.CPDCid NEQ "">
<cfset LvarEsSuficiencia 	= isdefined ('rsFormDet.CPDDid') and len(trim(rsFormDet.CPDDid))>

<cfif LvarEsSuficiencia>
	<cfquery name="rsSuficiencia" datasource="#Session.DSN#">
		select 	CPDEnumeroDocumento,
				CPDEdescripcion,
				CPDDsaldo
		  from CPDocumentoD d
		  	inner join CPDocumentoE e
				on e.CPDEid = d.CPDEid
		 where d.CPDDid = #rsFormDet.CPDDid#
	</cfquery>
</cfif>

<cfoutput>

	<script language="JavaScript" src="../../js/utilesMonto.js"></script>
	<script type='text/javascript' src='/cfmx/cfide/scripts/wddx.js'></script>
	<script language="JavaScript">
		var LvarImpuestosCFcuenta	= new Array(0,#ValueList(rsImpuestos.CFcuenta)#);
		//var LvarImpuestosCFformato	= new Array('',#QuotedValueList(rsImpuestosG.CFformato)#);
		var LvarImpuestosCFcuenta2	= new Array(0,#ValueList(rsImpIeps.CFcuenta)#);		

		
	</script>

	<cfoutput>
	<form action="solicitudesManual#LvarSufijoForm#_sql.cfm" onsubmit="return validaDet(this);" method="post" name="formDet" id="formDet">
			<input type="hidden" name="McodigoOri" 		value="#rsForm.McodigoOri#">
			<input type="hidden" name="TESSPid" 		value="#rsForm.TESSPid#">
			<input type="hidden" name="TESSPnumero" 	value="#rsForm.TESSPnumero#">
			<input type="hidden" name="TESSPfechaPagar" value="#rsForm.TESSPfechaPagar#">

			<table align="center" summary="Tabla de entrada" border="0">
                <cfif isdefined("LvarPorCFuncional") AND rsDistribucion.recordCount GT 0 AND modoD EQ 'ALTA'>
					<tr>
						<td valign="top" align="right" nowrap><strong><cf_translate key=LB_DistCF>Distribución x CF</cf_translate>:</strong></td>
						<td>
						 <select tabindex="-1" name="CPDCid" onchange="javascript:CF_disabled(this.value!='');">
								  <option value="" >-- N/A --</option>
							<cfloop query="rsDistribucion">
								<cfif modoD EQ 'ALTA'>
									<option value="#rsDistribucion.CPDCid#">#rsDistribucion.CPDCcodigo# - #rsDistribucion.CPDCdescripcion#</option>
								<cfelse>
									<option disabled="disabled" value="#rsDistribucion.CPDCid#" <cfif rsFormDet.CPDCid eq rsDistribucion.CPDCid>selected</cfif> >#rsDistribucion.CPDCcodigo# - #rsDistribucion.CPDCdescripcion#</option>
								</cfif>
							</cfloop>
						</select>
						</td>
					</tr>
                <cfelseif LvarEsDistribucion>
					<tr>
						<td valign="top" align="right" nowrap></td>
						<td>
							<strong style="background-color:##999999">
							Distribucion x CF:
							#rsDistribucion.CPDCcodigo# - #rsDistribucion.CPDCdescripcion#
							<input type="hidden" name="CPDCid" value="#rsFormDet.CPDCid#">
							</strong>
						</td>
					</tr>
				<cfelse>
					<tr style="display:none"><td><input type="hidden" name="CPDCid" value=""></td></tr>
                </cfif>
                <cfif LvarEsSuficiencia>
					<tr>
						<td valign="top" align="right" nowrap></td>
						<td>
							<strong style="background-color:##999999">
							<cfif rsForm.TESSPtipoCambioOriManual NEQ "" and rsForm.TESSPtipoCambioOriManual NEQ "0" and rsForm.TESSPtipoCambioOriManual NEQ "1">
								<cfset LvarSaldoSuf = round(100*rsSuficiencia.CPDDsaldo/rsForm.TESSPtipoCambioOriManual)/100>
							<cfelse>
								<cfset LvarSaldoSuf = rsSuficiencia.CPDDsaldo>
							</cfif>
							Suficiencia Num. #rsSuficiencia.CPDEnumeroDocumento#: #rsSuficiencia.CPDEdescripcion#<BR>Saldo&nbsp;#numberFormat(LvarSaldoSuf,",0.00")#
							<input type="hidden" name="CPDDid" value="#rsFormDet.CPDDid#">
							</strong>
						</td>
					</tr>
				</cfif>
				<cfif rsForm.TESBid NEQ "">
				<tr>
					<td valign="top" align="right"><strong><cf_translate key=LB_Proveedor>Proveedor</cf_translate>:</strong></td>
					<td valign="top">
					<cfif modoD NEQ 'ALTA'>
						<cf_sifsociosnegocios2 form="formDet" SNcodigo='SNcodigoOri' idquery="#rsFormDet.SNcodigoOri#" tabindex="1" modificable="#LvarModificable#">
					<cfelse>
						<cf_sifsociosnegocios2 form="formDet" SNcodigo='SNcodigoOri' SNtiposocio="P"  tabindex="1">
					</cfif>
					</td>
					</td>
				</tr>
				</cfif>
				<tr>
					<td valign="top" align="right"><strong><cf_translate key=LB_Documento>Documento</cf_translate>:</strong></td>
					<td valign="top">
						<table border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td>
										<input type="text" name="TESDPdocumentoOri" id="TESDPdocumentoOri" value="<cfif modoD NEQ 'ALTA'>#trim(rsFormDet.TESDPdocumentoOri)#</cfif>" tabindex="1" onKeyUp="return maximaLongitud(this,20)" <cfif modoD NEQ 'ALTA'>readonly="true"</cfif> >
									</td>
									<td>
										<cf_conlis
											Campos="TESDPid"
											tabindex="-1"
											values=""
											Desplegables="N"
											Modificables="N"
											Size="0"
											Title="Documentos"
											Tabla="TESdetallePago dp
											 	 LEFT OUTER JOIN CFinanciera cf
											 	 ON cf.CFcuenta = dp.CFcuentaDB
											 	 AND cf.Ecodigo=dp.EcodigoOri
											 	 LEFT OUTER JOIN CFuncional cfn
											 	 INNER JOIN Oficinas o
											 	 ON o.Ecodigo = cfn.Ecodigo
											 	 AND o.Ocodigo = cfn.Ocodigo
											 	 ON cfn.CFid=dp.CFid
											 	 LEFT OUTER JOIN Conceptos cc
											 	 ON cc.Cid = dp.Cid
											 	 LEFT JOIN (SELECT DISTINCT Documento,TimbreFiscal FROM CERepoTMP WHERE Origen = 'TES' and Ecodigo = #Session.Ecodigo# ) rt
											 	 ON rt.Documento = dp.TESDPdocumentoOri"
											Columnas="TESDPdocumentoOri, TESDPdescripcion, Ccodigo, TESDPmontoSolicitadoOri, TESDPid,TimbreFiscal"
											Desplegar="TESDPdocumentoOri, TESDPdescripcion, Ccodigo, TESDPmontoSolicitadoOri"
											Etiquetas="Documento, Descripcion, Servicio, Monto Solicitado"
											filtro="EcodigoOri=#session.Ecodigo# AND TESSPid= #form.TESSPid# ORDER BY TESDPdocumentoOri"
											Formatos="S,S,S,M"
											Align="left,left,left,left"
											funcion="numDocumento"
											Fparams="TESDPdocumentoOri,TimbreFiscal"
										/>
									</td>
									<td>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong><cf_translate key=LB_Referencia>Referencia</cf_translate>:&nbsp;</strong>
										<input type="text" name="TESDPreferenciaOri" id="TESDPreferenciaOri" value="<cfif modoD NEQ 'ALTA'>#trim(rsFormDet.TESDPreferenciaOri)#</cfif>"	size="25"tabindex="1"
							<cfif modoD NEQ 'ALTA'>readonly="true"</cfif> onKeyUp="return maximaLongitud(this,25)">
									</td>
								</tr>
							</table>


					</td>
				</tr>
				<cfset LvarTESDPdescripcion = "">
				<cfif modoD NEQ 'ALTA'>
					<cfset LvarTESDPdescripcion = #trim(rsFormDet.TESDPdescripcion)#>
				</cfif>
				<tr>
					<td valign="top" align="right" nowrap><strong><cf_translate key=LB_Impuesto>Impuesto</cf_translate>:</strong></td>
					<td valign="top">
						<select name="Icodigo" tabindex="1"  <cfif LvarEsSuficiencia>disabled="disabled"</cfif> onChange="
							var val = 0;	
								if (this.value == '')
								{
									this.form.TESDPdescripcion.readOnly = false;
									this.form.TESDPdescripcion.style.border='2px inset ##CCCCCC';
									this.form.TESDPdescripcion.style.borderBottom='1px solid ##CCCCCC';
									this.form.TESDPdescripcion.style.borderRight='1px solid ##CCCCCC';
									this.form.CmayorDet.readOnly	= false;
									this.form.CformatoDet.readOnly	= false;
									this.form.TESDPdescripcion.tabIndex	= 1;
									this.form.CmayorDet.tabIndex	= 1;
									this.form.CformatoDet.tabIndex	= 1;
                                    this.form.Cid.readOnly			= false;
									this.form.Ccodigo.readOnly		= false;
                                    this.form.Ccodigo.disabled		= false;
                                    this.form.chkEspecificarcuenta.disabled= false;
									EspeciCuenta();
                                    if (document.formDet.CPDCid)
                                    	this.form.CPDCid.disabled= false;
									<cfif LvarDigitarImpNCF EQ "">
									document.getElementById('DigitarImpNCF_1').style.display = '';
									document.getElementById('DigitarImpNCF_2').style.display = '';
									</cfif>

                                    Concepto_disabled(false);
                                    limpiaC(val);

								}
								else
								{
									this.form.TESDPdescripcion.readOnly = true;
									this.form.TESDPdescripcion.style.border='solid 1px ##CCCCCC';

									this.form.CmayorDet.readOnly	= true;
									this.form.CformatoDet.readOnly	= true;
                                    this.form.Cid.readOnly			= true;
									this.form.Ccodigo.readOnly		= true;
                                    this.form.Ccodigo.disabled		= true;
                                    this.form.chkEspecificarcuenta.disabled= true;
                                    if (document.formDet.CPDCid)
                                    	this.form.CPDCid.disabled= true;
									this.form.TESDPdescripcion.tabIndex	= -1;
									this.form.CmayorDet.tabIndex	= -1;
									this.form.CformatoDet.tabIndex	= -1;

									this.form.TESDPdescripcion.value = this.options[this.selectedIndex].text;
									
									
									if(LvarImpuestosCFcuenta[this.selectedIndex] != undefined){									
									this.form.CFcuentaDBd.value	= LvarImpuestosCFcuenta[this.selectedIndex];
									}else
									{	
									  if(LvarImpuestosCFcuenta2[this.selectedIndex] != undefined){
										this.form.CFcuentaDBd.value	= LvarImpuestosCFcuenta2[this.selectedIndex];
										}	
									}	
									
									pintarCF();
									//this.form.CmayorDet.value	= LvarImpuestosCFformato[this.selectedIndex].substring(0,4);
									//this.form.CformatoDet.value	= LvarImpuestosCFformato[this.selectedIndex].substring(5); 	
									

									<cfif LvarDigitarImpNCF EQ "">
									document.getElementById('DigitarImpNCF_1').style.display = 'none';
									document.getElementById('DigitarImpNCF_2').style.display = 'none';
									this.form.TESDPimpNCFOri.value	= '0.00';
									sbMontoChange();
									</cfif>

                                    Concepto_disabled(true);
								}
								">
							<option value="" >- <cf_translate key=LB_NoImpCreditoFiscal>No es Impuesto Credito Fiscal</cf_translate> -</option>
							<cfloop query="rsImpuestos">
								<option value="#rsImpuestos.Icodigo#" <cfif modoD NEQ 'ALTA' and rsFormDet.Icodigo eq rsImpuestos.Icodigo >selected <cfset LvarTESDPdescripcion = #trim(rsImpuestos.Idescripcion)#></cfif>>#HTMLEditFormat(rsImpuestos.Idescripcion)#</option>
							</cfloop>

								<option value="" >- <cf_translate key=LB_NoImpCreditoFiscal>---IEPS---</cf_translate> -</option>
							<cfloop query="rsImpIeps">
								<option value="#rsImpIeps.Icodigo#" <cfif modoD NEQ 'ALTA' and rsFormDet.Icodigo eq rsImpIeps.Icodigo >selected <cfset LvarTESDPdescripcion = #trim(rsImpIeps.Idescripcion)#></cfif>>#HTMLEditFormat(rsImpIeps.Idescripcion)#</option>
							</cfloop>	
						</select>
					</td>
				</tr>
                <cfset LvarIcodigoTab = "1">
				<cfset LvarIcodigoReadonly = "false">
                <cfif isdefined("rsFormDet.Icodigo") and rsFormDet.Icodigo NEQ "">
                    <cfset LvarIcodigoTab = "-1">
                    <cfset LvarIcodigoReadonly = "true">
                </cfif>
                <tr>
                	<td valign="top" align="right"><strong><cf_translate key=LB_Concepto>Concepto</cf_translate>:</strong></td>
                	<td>
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td  id="concepto">
                                    <cfif modoD neq 'ALTA' and len(trim(rsFormDet.Cid))>
                                        <cfquery name="rsConcepto" datasource="#session.DSN#">
                                            select Cid, Ccodigo, Cdescripcion
                                            from Conceptos
                                            where Ecodigo = #Session.Ecodigo#
                                            and Cid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDet.Cid#">
                                            order by Ccodigo
                                        </cfquery>
                                        <cf_sifconceptos form="formDet" query=#rsConcepto# size="22"  tabindex="1" readonly="#LvarEsSuficiencia#">
                                    <cfelse>
                                        <cf_sifconceptos form="formDet" size="22" tabindex="1" >
                                    </cfif>
                                </td>
                                <td valign="top" align="right">
                                    <!--- Especifica cuenta--->
                                    &nbsp;&nbsp;
                                    <strong><cf_translate key=LB_EspecificaCta>Especifica Cuenta</cf_translate>:&nbsp;</strong>
                                </td>
                                <td>
									<input type="checkbox" name="chkEspecificarcuenta" id="chkEspecificarcuenta" onclick="EspeciCuenta();" tabindex="-1"
                                    <cfif modoD neq 'ALTA' and rsFormDet.TESDPespecificacuenta eq 1> checked="checked" </cfif> <cfif LvarEsSuficiencia>disabled="disabled"</cfif> >
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <cfif LvarEsSuficiencia>
                	<cfset LvarIcodigoReadonly=true>
                </cfif>
				<cfif isdefined("LvarPorCFuncional")>
				<tr>
					<td valign="top" align="right" nowrap><strong><cf_translate key=LB_CF>Centro Funcional</cf_translate>:</strong></td>
					<td valign="top">
						<cfif modoD NEQ "ALTA" and isdefined('rsFormDet') and rsFormDet.recordCount GT 0>
							<cf_rhcfuncionalCxP form="formDet" size="40" query="#rsFormDet#" readonly="#LvarEsSuficiencia#"
								titulo="Seleccione el Centro Funcional Responsable" tabindex="1"
								>
						<cfelse>
							<cf_rhcfuncionalCxP form="formDet" size="40"
								titulo="Seleccione el Centro Funcional Responsable" tabindex="1"
								>
						</cfif>
					</td>
				</tr>
              <cfif rsActividad.Pvalor eq 'S'>
              	<tr>
                	<td valign="top" align="right" nowrap><strong><cf_translate key=LB_ActEmpresarial>Act. Empresarial</cf_translate>:</strong></td>
                    <td valign="top">
                    	<cfif modoD NEQ "ALTA" and isdefined('rsFormDet') and rsFormDet.recordCount GT 0>
                        	<cf_ActividadEmpresa etiqueta="" funcion="fnCambioCuenta" idActividad="#rsFormDet.FPAEid#" valores="#rsFormDet.CFComplemento#" formName="formDet">
                        <cfelse>
                           	<cf_ActividadEmpresa etiqueta="" funcion="fnCambioCuenta" formName="formDet">
                        </cfif>
                    </td>
                </tr>
       		  </cfif>
				<tr>
					<td valign="top" align="right" nowrap><strong><cf_translate key=LB_CtaFinanciera>Cta. Financiera</cf_translate>:</strong></td>
					<td valign="top">
						<cfif modoD NEQ "ALTA" and isdefined('rsCuentasDet') and rsCuentasDet.recordCount GT 0>
							<cf_cuentas Cdescripcion="CdescripcionDet" Cformato="CformatoDet" form="formDet" Cmayor="CmayorDet" CFcuenta="CFcuentaDBd" query="#rsCuentasDet#" tabindex="#LvarIcodigoTab#" readonly="#LvarIcodigoReadonly#" igualTabFormato="S">
						<cfelse>
							<cf_cuentas Cdescripcion="CdescripcionDet" Cformato="CformatoDet" form="formDet" Cmayor="CmayorDet" CFcuenta="CFcuentaDBd" tabindex="#LvarIcodigoTab#" readonly="#LvarIcodigoReadonly#" igualTabFormato="S">
						</cfif>
					</td>
				</tr>
			<cfelse>
				<tr>
					<td valign="top" align="right" nowrap><strong><cf_translate key=LB_CtaFinanciera>Cta. Financiera</cf_translate>:</strong></td>
					<td valign="top">
						<cfif modoD NEQ "ALTA" and isdefined('rsCuentasDet') and rsCuentasDet.recordCount GT 0>
							<cf_cuentas Cdescripcion="CdescripcionDet" Cformato="CformatoDet" form="formDet" Cmayor="CmayorDet" CFcuenta="CFcuentaDBd" tabindex="#LvarIcodigoTab#" readonly="#LvarIcodigoReadonly#" igualTabFormato="S" query="#rsCuentasDet#" CFid="#rsForm.CFid#" >
						<cfelse>
							<cf_cuentas Cdescripcion="CdescripcionDet" Cformato="CformatoDet" form="formDet" Cmayor="CmayorDet" CFcuenta="CFcuentaDBd" tabindex="#LvarIcodigoTab#" readonly="#LvarIcodigoReadonly#" igualTabFormato="S" CFid="#rsForm.CFid#" >
						</cfif>
					</td>
				</tr>
			</cfif>

				<tr>
					<td valign="top" align="right"><strong><cf_translate key=LB_Descripcion>Descripción</cf_translate>:</strong></td>
					<td valign="top">
						<input type="text" name="TESDPdescripcion" id="TESDPdescripcion" value="#LvarTESDPdescripcion#"
							size="80" maxlength="80"
							<cfset LvarIcodigoTab = "1">
							<cfset LvarIcodigoReadonly = "false">
							<cfif isdefined("rsFormDet.Icodigo") and rsFormDet.Icodigo NEQ "">
								readonly style="border:solid 1px ##CCCCCC;"
								<cfset LvarIcodigoTab = "-1">
								<cfset LvarIcodigoReadonly = "true">
							</cfif>
							tabindex="#LvarIcodigoTab#"
						>
					</td>
				</tr>
				<tr>
					<td valign="top" align="right"><strong><cf_translate key=LB_PagoTerceros>Pago Terceros</cf_translate>:</strong></td>
					<td valign="top">
						<cfif modoD NEQ 'ALTA'>
							<cf_cboTESRPTCid query="#rsFormDet#" SNid="#rsForm.SNid#" TESBid="#rsForm.TESBid#" tabindex="1">
						<cfelse>
							<cf_cboTESRPTCid SNid="#rsForm.SNid#" TESBid="#rsForm.TESBid#" tabindex="1">
						</cfif>
					</td>
				</tr>
				<tr>
					<td valign="top" align="right" nowrap><strong><cf_translate key=LB_TipoMov>Tipo Movimiento</cf_translate>:</strong></td>
					<td valign="top">
						<select name="TIPODBCR" tabindex="2" <cfif LvarEsSuficiencia>disabled="disabled"</cfif>>
							<option value="+1"><cf_translate key=LB_DebitoPagoNormal>Débito (Pago Normal)</cf_translate></option>
							<option value="-1" <cfif  modoD NEQ 'ALTA' AND rsFormDet.TESDPmontoSolicitadoOri LT 0> selected</cfif>><cf_translate key=LB_CreditoGanancia>Crédito (Ganancia)</cf_translate></option>
						</select>
					</td>
				</tr>
				<tr>
					<td valign="top" align="right"><strong><cf_translate key=LB_Monto>Monto</cf_translate>: </strong></td>
					<td valign="top">
						<cfif  modoD NEQ 'ALTA'>
							<cfset LvarValue="#replace(rsFormDet.TESDPmontoSolicitadoOri-rsFormDet.TESDPimpNCFOri,"-","")#">
						<cfelse>
							<cfset LvarValue="0.00">
						</cfif>
						<cf_inputnumber	name="MontoSinImpNCFOri" value="#LvarValue#"
										form="formDet" enteros="15" decimales="2" tabindex="2"
										onchange="sbMontoChange();"
						>
						<cfif isdefined("LvarMnombreSP")>
							#LvarMnombreSP#
						</cfif>
					</td>
				</tr>
			<!--- <cfif modoD NEQ "ALTA"> --->
				<cfquery name="getContE" datasource="#Session.DSN#">
					select ERepositorio from Empresa
					where Ereferencia = #Session.Ecodigo#
				</cfquery>
				<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
	            <tr id="trUUID" style="display:"><cfif isdefined('Form.EDDocumento')><cfset Documento=Form.EDdocumento></cfif>
	              <td align="right"   nowrap="nowrap" valign="top"><strong>Timbre Fiscal:&nbsp;</strong></td>
	              <!--- <cf_dump var="#rsFormDet.TESSPnumero#"> --->
	              <td >
		              	<cfif modoD NEQ "ALTA">
							<cf_sifComprobanteFiscal Origen="TES" irA="solicitudesManual.cfm" form="formDet" IDdocumento="#form.TESSPid#" IDlinea="#form.TESDPid#" nombre="Timbre" Documento="#rsFormDet.TESDPdocumentoOri#">
						<cfelse>
							<cf_sifComprobanteFiscal Origen="TES" form="formDet" nombre="Timbre" modo="alta">
						</cfif>
	              </td>
	            </tr>
	            </cfif>
            <!--- </cfif> --->
				<cfif modoD NEQ 'ALTA' and rsFormDet.Icodigo NEQ "">
					<cfset LvarDigitarImpNCF = "none">
				</cfif>

				<tr style="display:#LvarDigitarImpNCF#;" id="DigitarImpNCF_1">
					<td valign="top" align="right"><strong><cf_translate key=LB_ImpNoCF>Impuesto No CF</cf_translate>: </strong></td>
					<td valign="top">
						<cfif  modoD NEQ 'ALTA'>
							<cfset LvarValue="#replace(rsFormDet.TESDPimpNCFOri,"-","")#">
						<cfelse>
							<cfset LvarValue="0.00">
						</cfif>
						<cf_inputnumber	name="TESDPimpNCFOri" value="#LvarValue#"
										form="formDet" enteros="15" decimales="2" tabindex="2"
										onchange="sbMontoChange();"
						>
						<cfif isdefined("LvarMnombreSP")>
							#LvarMnombreSP#
						</cfif>
					</td>
				</tr>
				<tr style="display:#LvarDigitarImpNCF#;" id="DigitarImpNCF_2">
					<td valign="top" align="right"><strong><cf_translate key=LB_Total>Total</cf_translate>: </strong></td>
					<td valign="top">
						<cfif  modoD NEQ 'ALTA'>
							<cfset LvarValue="#replace(rsFormDet.TESDPmontoSolicitadoOri,"-","")#">
						<cfelse>
							<cfset LvarValue="0.00">
						</cfif>
						<cf_inputnumber	name="TESDPmontoSolicitadoOri" value="#LvarValue#"
										form="formDet" enteros="15" decimales="2" tabindex="2"
										readonly
						>
						<cfif isdefined("LvarMnombreSP")>
							#LvarMnombreSP#
						</cfif>
					</td>
				</tr>

				<tr>
					<td valign="top" align="right">&nbsp;</td>
					<td valign="top">&nbsp;</td>
				</tr>
			<cfif NOT isdefined("form.chkCancelados")>
				<tr>
					<td colspan="4" class="formButtons" nowrap="nowrap" align="center">
       					 <cf_botones modo="#modod#" includevalues="#btnValueSuf#" include="#btnNameSuf#" sufijo='Det' tabindex="2">
					</td>
				</tr>
			</cfif>
			</table>
			<cfif modoD NEQ 'ALTA'>
				<input type="hidden" name="TESDPid" value="#rsFormDet.TESDPid#">

				<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#rsFormDet.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfif>
		</cfoutput>
	</form>
	<iframe id="ifrGenCuenta" style="display:none"></iframe>
	  <script type="text/javascript">
	<!--
		function sbMontoChange()
		{
			var LvarMontoSinImpNCFOri	= parseFloat(qf(document.formDet.MontoSinImpNCFOri.value));
			var LvarTESDPimpNCFOri	= parseFloat(qf(document.formDet.TESDPimpNCFOri.value));
			document.formDet.TESDPmontoSolicitadoOri.value = fm(LvarMontoSinImpNCFOri+LvarTESDPimpNCFOri,2);
		}

		function validaDet(formulario)	{
			if (!btnSelectedDet('NuevoDet',document.formDet) && !btnSelectedDet('BajaDet',document.formDet)){
				var error_input = null;;
				var error_msg = '';

			<cfif isdefined("LvarPorCFuncional")>

				if (formulario.CPDCid.value != "" && formulario.Cid.value=="")
				{
					error_msg += "\n - #MSG_NecesarioConceptoParaDistribucion#";
					if (error_input == null) error_input = formulario.Cid;
				}

			</cfif>

				if (formulario.TESDPdocumentoOri.value == "")
				{
					error_msg += "\n - #MSG_ValidaDocto#.";
					if (error_input == null) error_input = formulario.TESDPdocumentoOri;
				}

				if (formulario.TESDPdescripcion.value == "")
				{
					error_msg += "\n - #MSG_ValidaDescripcion#.";
					if (error_input == null) error_input = formulario.TESDPdescripcion;
				}
				if (formulario.TESDPreferenciaOri.value == "")
				{
					error_msg += "\n - #MSG_ValidaReferencia#.";
					if (error_input == null) error_input = formulario.TESDPreferenciaOri;
				}

				if (formulario.TESRPTCid.value == "")
				{
					error_msg += "\n - #MSG_ValidaPagosTerceros#.";
					if (error_input == null) error_input = formulario.TESRPTCid;
				}
				if (formulario.CFcuentaDBd.value == "" && formulario.CPDCid.value == "")
				{
					error_msg += "\n - #MSG_ValidaCtaFinanciera#.";
					if (error_input == null) error_input = formulario.CFcuentaDBd;
				}
			<cfif isdefined("LvarPorCFuncional")>
				if (formulario.CFcodigo.value == "" && formulario.CPDCid.value == "")
				{
					error_msg += "\n - #MSG_ValidaCF#.";
					if (error_input == null) error_input = formulario.CFcodigo;
				}
			</cfif>
				if (formulario.TESDPmontoSolicitadoOri.value == "")
				{
					error_msg += "\n - #MSG_ValidaMontoSolicitado#.";
					if (error_input == null) error_input = formulario.TESDPmontoSolicitadoOri;
				}
				else if (parseFloat(formulario.TESDPmontoSolicitadoOri.value) <= 0)
				{
					error_msg += "\n - #MSG_ValidaMontoSolicitMayorCero#.";
					if (error_input == null) error_input = formulario.TESDPmontoSolicitadoOri;
				}
			<cfif LvarEsSuficiencia>
				else if (parseFloat(formulario.TESDPmontoSolicitadoOri.value) > #LvarSaldoSuf#)
				{
					error_msg += "\n - #MSG_ValidaMontoMenorSaldoSuficiencia#.";
					if (error_input == null) error_input = formulario.TESDPmontoSolicitadoOri;
				}
			</cfif>


				// Validacion terminada
				if (error_msg.length != "") {
					alert("#MSG_ReviseDatos#:"+error_msg);
					try
					{
						error_input.focus();
					}
					catch(e)
					{}

					return false;
				}

			}

			formulario.TESDPmontoSolicitadoOri.value = qf(formulario.TESDPmontoSolicitadoOri);
			formulario.TESDPimpNCFOri.value = qf(formulario.TESDPimpNCFOri);

			return true;
		}

	//-->

		function maximaLongitud(texto,maxlong) {
		var tecla, in_value, out_value;
			if (texto.value.length > maxlong) {
				in_value = texto.value;
				out_value = in_value.substring(0,maxlong);
				texto.value = out_value;
				return false;
			}
			return true;
		}
		document.formDet.TESDPdocumentoOri.focus();

		function limpiaC(val){
			if(val == 0){
				document.formDet.CFcuentaDBd.readOnly	= true;
				document.formDet.CmayorDet.readOnly	= true;
				document.formDet.CformatoDet.readOnly	= true;
				document.formDet.TESDPdescripcion.readOnly	= true;

				document.formDet.CFcuentaDBd.value = "";
				document.formDet.CmayorDet.value	= "";
				document.formDet.CformatoDet.value	= "";
				document.formDet.TESDPdescripcion.value = ""; 
			}
			if(val == 1){
				document.formDet.CFcuentaDBd.readOnly	= true;
				document.formDet.CmayorDet.readOnly	= true;
				document.formDet.CformatoDet.readOnly	= true;
	
				document.formDet.CFcuentaDBd.value = "";
				document.formDet.CmayorDet.value	= "";
				document.formDet.CformatoDet.value	= "";
				
			}

		}

		function pintarCF(){
		var id = document.formDet.Icodigo.value;
			
	<cfif isdefined('rsImpuestosG')>		
		<cfwddx action="cfml2js" input="#rsImpuestosG#" topLevelVariable="rsjIeps">

		var nRows = rsjIeps.getRowCount();
		var val = 1;
		if (nRows > 0) {
				for (row = 0; row < nRows; ++row) {
		  			if (rsjIeps.getField(row, "Icodigo") == id){

		  				//Evaluamos si se tiene cuenta de formato	
				  			if(rsjIeps.getField(row, "CFformato").substring(0,4) != ""){
				  			 	val = 2;
				  			}
		  					  
		  					  document.formDet.CmayorDet.readonly = false;
		  					  document.formDet.CformatoDet.readonly = false;
		  					  document.formDet.CmayorDet.disabled = false;
		  					  document.formDet.CformatoDet.disabled = false;
		  					  document.formDet.CFcuentaDBd.value = rsjIeps.getField(row, "CFcuenta"); 			  					  			
		  					  document.formDet.CmayorDet.value	= rsjIeps.getField(row, "CFformato").substring(0,4);
							  document.formDet.CformatoDet.value = rsjIeps.getField(row, "CFformato").substring(5); 	
					 	 	  	
					 	 }
		  			   }
		  			}
	</cfif>	

				 limpiaC(val);
		}


		function Concepto_disabled(x)
		{
				if (document.getElementById("imgCcodigo"))
				{
					document.getElementById("imgCcodigo").style.visibility = x?"hidden":"visible";
				}
				document.formDet.Cid.disabled =x;
				document.formDet.Ccodigo.disabled =x;
		}

		function img_Ccuenta_disabled(x)
		{
				if (document.getElementById("img_Ccuenta"))
				{
					document.getElementById("img_Ccuenta").style.visibility = x?"hidden":"visible";
				}
				document.formDet.CmayorDet.readOnly = x;
				document.formDet.CformatoDet.readOnly = x;
		}

		function CF_disabled(x)
		{
			if (document.getElementById("imagenCxP"))
				document.getElementById("imagenCxP").style.visibility = x?"hidden":"visible";
			img_Ccuenta_disabled(x);
			document.formDet.CmayorDet.disabled =x;
			document.formDet.CFcuentaDBd.disabled =x;
			document.formDet.CformatoDet.disabled =x;
		<cfif isdefined("LvarPorCFuncional")>
			document.formDet.CFid.disabled =x;
			document.formDet.CFcodigo.disabled =x;
		</cfif>
			document.formDet.Icodigo.disabled = (document.formDet.CPDDid) ? true : false;
		}

		function EspeciCuenta()
		{
			if (document.formDet.chkEspecificarcuenta.checked)
			{
				//Concepto_disabled(true);
				img_Ccuenta_disabled(false);
				/*document.formDet.Cid.value ="";
				document.formDet.Ccodigo.value ="";
				document.formDet.Cdescripcion.value ="";
				al parecer no hay que limpiarlo */


			}
			else
			{
				//Concepto_disabled(false);
				img_Ccuenta_disabled(true);

				fnCambioCuenta();
			}
		}

		function funcCFcodigo()
		{
			if (document.formDet.chkEspecificarcuenta.checked)
				return;

			fnCambioCuenta();
		}
		function funcCcodigo()
		{
			document.formDet.TESDPdescripcion.value= document.formDet.Cdescripcion.value;

			if (document.formDet.chkEspecificarcuenta.checked)
				return;

			fnCambioCuenta();
		}
		function fnCambioCuenta()
		{
			<cfif isdefined("rsForm.SNid") and len(trim(#rsForm.SNid#))>
				var SNid=#rsForm.SNid#;
			<cfelse>
				var SNid=-1;
			</cfif>

			<cfif isdefined("LvarPorCFuncional")>

				var CFid=document.formDet.CFid.value;
				if (document.formDet.Cid.value != '' & document.formDet.CFcodigo.value != '')
				{
				fnSetCuenta("","","","");
				<cfoutput>
				<cfif rsActividad.Pvalor eq 'S'>
					lvarActividad = document.formDet.actividad.value;
				<cfelse>
					lvarActividad = "";
				</cfif>
				document.getElementById("ifrGenCuenta").src= "solicitudesManual#LvarSufijoForm#_sql.cfm?SP=GENCF&tipoItem=S&Cid=" + document.formDet.Cid.value + "&SNid=" + SNid + "&CFid="+CFid+"&actividad="+lvarActividad;
				</cfoutput>
				}

			<cfelse>
				var CFid =#session.Tesoreria.CFid#;
				if (document.formDet.Cid.value != '')
				{
				fnSetCuenta("","","","");
				<cfoutput>
				document.getElementById("ifrGenCuenta").src= "solicitudesManual#LvarSufijoForm#_sql.cfm?SP=GENCF&tipoItem=S&Cid=" + document.formDet.Cid.value + "&SNid=" + SNid + "&CFid="+CFid;
				</cfoutput>
				}

			</cfif>


		}
		function fnSetCuenta(cf,c,f,d)
		{

			if (document.formDet.CmayorDet)
			{
				document.formDet.CFcuentaDBd.value=cf;
				document.formDet.CmayorDet.value=f.substr(0,4);
				document.formDet.CformatoDet.value= f.substr(5);
				document.formDet.CdescripcionDet.value=d;
			}
			LvarEcodigo_CcuentaD = <cfoutput>#session.Ecodigo#</cfoutput>;

		}


		//Llama el conlis
		function funcSuficienciaDet() {
			var params ="";
			var TESSPid=document.form1.TESSPid.value;

			popUpWindowIns("/cfmx/sif/tesoreria/Solicitudes/popUp-suficiencia.cfm?TESSPid="+TESSPid+"&LvarTipoDocumento="+#LvarTipoDocumento#,window.screen.width*0.05 ,window.screen.height*0.05,window.screen.width*0.90 ,window.screen.height*0.90);
			return false;
		}

		var popUpWinIns = 0;
		function popUpWindowIns(URLStr, left, top, width, height){
			if(popUpWinIns){
				if(!popUpWinIns.closed) popUpWinIns.close();
			}
			popUpWinIns = open(URLStr, 'popUpWinIns', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,scrolling=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		}

		function numDocumento(TESDPdocumentoOri,TimbreFiscal){
			document.formDet.TESDPdocumentoOri.value= TESDPdocumentoOri;
			// queda deshabilitado el campo
			//document.formDet.TESDPdocumentoOri.readonly= true;

			if(TimbreFiscal != ""){
				document.getElementById('trUUID').style.display = '';
				document.getElementById('Timbre').value = TimbreFiscal;
				document.getElementById('ce_refimagen').style.display = 'none';
			}
			else{
				document.getElementById('trUUID').style.display = '';
				document.getElementById('ce_refimagen').style.display = '';
			}
		}

		<cfoutput>
		<cfif modoD NEQ 'ALTA'>
			<cfif len(trim(#rsFormDet.Icodigo#))>
				Concepto_disabled(true);
                document.formDet.chkEspecificarcuenta.disabled= true;
				if (document.formDet.CPDCid)
					document.formDet.CPDCid.disabled= true;

			</cfif>
		</cfif>

		<cfif LvarEsSuficiencia>
			Concepto_disabled(true);
			CF_disabled(true);
		<cfelseif LvarEsDistribucion>
			CF_disabled(true);
		</cfif>


		</cfoutput>

	</script>
</cfoutput>