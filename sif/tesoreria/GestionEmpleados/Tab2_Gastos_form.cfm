<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDocumentosLiquidacion" Default="Lista de Documentos en la Liquidacion" returnvariable="LB_ListaDocumentosLiquidacion" xmlfile = "Tab2_Gastos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Documento" Default="Documento" returnvariable="LB_Documento" xmlfile = "Tab2_Gastos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="Identificaci&oacute;n" returnvariable="LB_Identificacion" xmlfile = "Tab2_Gastos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Proveedor" Default="Proveedor" returnvariable="LB_Proveedor" xmlfile = "Tab2_Gastos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RevisaDatos" Default="Por favor revise los siguiente datos"
returnvariable="LB_RevisaDatos" xmlfile = "Tab2_Gastos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CampoDocumento" Default="El número de documento no puede quedar en blanco" returnvariable="LB_CampoDocumento" xmlfile = "Tab2_Gastos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CampoProveedor" Default="El Proveedor del Servicio no puede quedar en blanco" returnvariable="LB_CampoProveedor" xmlfile = "Tab2_Gastos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CamposConceptoTipo" Default="El concepto y tipo de gastos no pueden quedar en blanco" returnvariable="LB_CamposConceptoTipo" xmlfile = "Tab2_Gastos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CampoDescripcion" Default="La Descripci&oacute;n no puede quedar en blanco" returnvariable="LB_CampoDescripcion" xmlfile = "Tab2_Gastos_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CampoMontoDoc" Default="El Monto del Documento no puede quedar en blanco"
returnvariable="LB_CampoMontoDoc" xmlfile = "Tab2_Gastos_form.xml"/>


<cfset btnNamePlanCompras="PlanCompras">
<cfset btnValuePlanCompras= "Plan de Compras">
<!---Formulado por en parametros generales--->
<cfquery name="rsSQL" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarConPlanCompras = (rsSQL.Pvalor eq 1)>

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

<cfquery name="rsGstoMonTCE" datasource="#session.DSN#">
      Select Coalesce(Pvalor,'0') as Pvalor
       from Parametros
       where Pcodigo = 1230
         and Mcodigo = 'GE'
         and Ecodigo = #session.Ecodigo#
</cfquery>
<!--- JARR Permite Registrar Retenciones --->
<cfquery name="rsGEret" datasource="#session.DSN#">
      Select Coalesce(Pvalor,'0') as Pvalor
       from Parametros
       where Pcodigo = 1234
         and Mcodigo = 'GE'
         and Ecodigo = #session.Ecodigo#
</cfquery>

<cfif rsForm.GELtipoPago eq "CCH" AND isdefined("rsGEret") and rsGEret.Pvalor EQ 0>
	<cfset LvarDigitarRetencion = "none">
	<cfset LvarDigitarTCE = "none">
<cfelse>
	<cfset LvarDigitarRetencion = "">
	<cfset LvarDigitarTCE = "">
</cfif>

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

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select e.Mcodigo, m.Miso4217
	from Empresas e
		inner join Monedas m on m.Mcodigo = e.Mcodigo
	where e.Ecodigo = #Session.Ecodigo#
</cfquery>

<!--- Moneda Liquidacion --->
<cfquery name="rsMonedaLiquidacion" datasource="#Session.DSN#">
	select m.Miso4217,GELtipoCambio
	from GEliquidacion l
		inner join Monedas m on m.Mcodigo = l.Mcodigo
	where l.GELid=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
</cfquery>

<cfset LvarTotalLineas	= 0>
<cfset LvarTotalPagado  = 0>
<cfset LvarTotalTCE		= 0>
<cfif modoD EQ 'CAMBIO'>
    <cfif isdefined('url.GELGid') and isdefined('url.modoN')>
		<cfset varGELGid = #url.GELGid#>
		<cfelse>
		<cfset varGELGid = #form.GELGid#>
	</cfif>
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
				dl.GECid, dl.Icodigo,
				dl.ts_rversion,
				dl.SNcodigo, dl.TESBid,
				dl.Rcodigo,
                dl.FPAEid,
            	dl.CFComplemento,
				GELGimpNCFOri,
                GELGreferencia
		from GEliquidacionGasto dl
			left join CFuncional cf
			  on cf.CFid = dl.CFid
		where dl.GELid=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
		  and dl.GELGid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#varGELGid#">
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

<!--- Tipo y Concepto Gasto--->
<cfquery datasource="#Session.DSN#" name="rsSQL">
	select count(1) as cantidad
	  from GEliquidacionAnts a
	 where a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
</cfquery>
<cfset LvarHayAnts = rsSQL.cantidad GT 0>
<cfquery datasource="#Session.DSN#" name="rsTipoGasto">
	select GETid, GETdescripcion
	  from GEtipoGasto
	 where Ecodigo = #session.Ecodigo#
</cfquery>

<cfif modoD EQ "CAMBIO" AND rsFormDet.Icodigo NEQ "">
	<cfquery datasource="#session.dsn#" name="rsID_concepto_gasto">
		select	Icodigo as GECid, -1 as GETid,
				Idescripcion as  GECdescripcion,
				'' as GECcomplemento
		  from Impuestos
		 where Ecodigo = #session.Ecodigo#
		   and Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFormDet.Icodigo#">
	</cfquery>
<cfelse>
	<cfquery datasource="#Session.DSN#" name="rsID_concepto_gasto">
		select 	c.GECid, c.GETid,
				(RTRIM(LTRIM(GECconcepto)) + ' - ' + RTRIM(LTRIM(GECdescripcion))) AS GECdescripcion,
				c.GECcomplemento
		  from GEconceptoGasto c
			inner join GEtipoGasto t
				on c.GETid = t.GETid
		where Ecodigo = #session.Ecodigo#
		<cfif modoD eq "ALTA" and LvarHayAnts>
			and (
					select count(1)
					  from GEliquidacionAnts a
					  	inner join GEanticipoDet b
							 on b.GEAid = a.GEAid
							and b.GEADid=a.GEADid
					 where a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
					   and b.GECid = c.GECid
				) > 0
		<cfelseif modoD eq "ALTA">
			and c.GETid = <cfif rsTipoGasto.GETid EQ "">0<cfelse>#rsTipoGasto.GETid#</cfif>
		<cfelse>
			and c.GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDet.GECid#">
		</cfif>
		order by c.GETid
	</cfquery>
</cfif>

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

<!--- JARR QUERY IMPUESTOS --->
<cfquery name="rsImpuestos" datasource="#Session.DSN#">
		select
            Idescripcion as GECdescripcion,
            Icodigo		 as GECid
        from Impuestos
        where Ecodigo = #session.Ecodigo#
          and Icreditofiscal = 1
          and Icompuesto = 0
</cfquery>

<script language="javascript" type="text/javascript">
<!--
//Browser Support Code
function ComboConceptoChange(GECid)
{
<cfif LvarDigitarImpNCF EQ "">
	if (GECid == "-1")
	{
		document.getElementById('DigitarImpNCF_1').style.display = 'none';
		document.getElementById('DigitarImpNCF_2').style.display = 'none';
		document.getElementById('DigitarImpNCF_3').style.display = 'none';
		document.getElementById('DigitarImpNCF_4').style.display = 'none';
		document.formDet.GELGimpNCFOri.value	= '0.00';
		document.formDet.GELGnoAutOri.value		= '0.00';
		document.formDet.GELGnoAutOri.readOnly	= true;
		document.formDet.GELGnoAutOri.style.border = "solid 1px #CCCCCC";
		CambiaMontoD();
	}
	else
	{
		document.getElementById('DigitarImpNCF_1').style.display = '';
		document.getElementById('DigitarImpNCF_2').style.display = '';
		document.getElementById('DigitarImpNCF_3').style.display = '';
		document.getElementById('DigitarImpNCF_4').style.display = '';
		document.formDet.GELGnoAutOri.readOnly	= false;
		document.formDet.GELGnoAutOri.style.border = "inset 2px #EBE9ED";
		document.formDet.GELGnoAutOri.style.borderRight = "solid 1px #CCCCCC";
		document.formDet.GELGnoAutOri.style.borderBottom = "solid 1px #CCCCCC";
	}
</cfif>
	return;
}
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
			<cfif LvarConPlanCompras>
				<input type="hidden" name="CFcuenta" id="CFcuenta" value="">
				<input type="hidden" name="ConceptoGasto" id="ConceptoGasto" value="">
				<input type="hidden" name="PCGDid" id="PCGDid" value="">
			</cfif>
			<table align="center" summary="Tabla de entrada" width="100%" border="0">
              <tr>
                <!--- Nmero de Documento--->
                <td align="right" valign="top" colspan="colspan"><strong><cf_translate key = LB_NumDoc xmlfile = "Tab2_Gastos_form.xml">N&uacute;m. Doc</cf_translate>:</strong></td>
                <td valign="top" align="left">
				<table cellpadding="0" cellspacing="0"><tr>
					<td>
						<input type="text" name="GELGnumeroDoc" id="GELGnumeroDoc"
						value="<cfif modoD NEQ 'ALTA'>#trim(rsFormDet.GELGnumeroDoc)#</cfif>" tabindex="1" onblur="javascript: getDocumentoViejo(this.value);">
					</td>
					<td>
						<cf_dbfunction name="date_format" args="GELGfecha,DD/MM/YYYY" returnvariable="LvarFecha">
						<cf_conlis
							Campos="GELGid_X"
							tabindex="-1"
							values=""
							Desplegables="N"
							Modificables="N"
							Size="0"
							Title="#LB_ListaDocumentosLiquidacion#"
							Tabla="GEliquidacionGasto lg left join SNegocios sn on sn.Ecodigo=lg.Ecodigo and sn.SNcodigo=lg.SNcodigo
								left join (
								select GELGnumeroDoc GELGnumeroDocA ,TimbreFiscal, rt.Ecodigo, rt.ID_Documento
								from CERepoTMP rt
								inner join GEliquidacionGasto glg on rt.ID_Linea = glg.GELGid
								inner join GEliquidacion gl on gl.GELid = glg.GELid
								where rt.Origen = 'TSGS'
								) rep
									on lg.GELGnumeroDoc = rep.GELGnumeroDocA
									and lg.Ecodigo = rep.Ecodigo  and rep.ID_Documento = lg.GELid"
							Columnas="distinct
										GELGnumeroDoc, #LvarFecha# as GELGfecha, sn.SNcodigo,SNnumero,TESBid,GELGproveedor,GELGproveedorId, lg.Mcodigo, GELGtipoCambio, Rcodigo,
										1 as GELGid_X, TimbreFiscal"
							Desplegar="GELGnumeroDoc, GELGproveedorId, GELGproveedor"
							Etiquetas="#LB_Documento#, #LB_Identificacion#, #LB_Proveedor#"
							filtro="GELid=#form.GELid# order by 1,2"
							Formatos="S,S,S"
							Align="left,left,left"
							funcion="DocumentoViejo"
							Fparams="GELGnumeroDoc, GELGfecha, SNcodigo,SNnumero,TESBid,GELGproveedor,GELGproveedorId, Mcodigo, GELGtipoCambio, Rcodigo, TimbreFiscal"
						/>
					</td></tr></table>
                </td>
                <!--- Fecha --->
                <td valign="top" nowrap align="right" width="200px"><strong><cf_translate key = LB_FechaFactura xmlfile = "Tab2_Gastos_form.xml">Fecha Factura</cf_translate>:&nbsp;</strong> </td>
                <td valign="top" align="left"><cfset fechadoc = LSDateFormat(Now(),'dd/mm/yyyy')>
                    <cfif modoD NEQ 'ALTA'>
                      <cfset fechadoc = LSDateFormat(rsFormDet.GELGfecha,'dd/mm/yyyy') >
                    </cfif>
                    <cf_sifcalendario form="formDet" value="#fechadoc#" name="GELGfecha" tabindex="1">
                </td>
              </tr>
              <tr>
                <!--- Proveedor de servicio--->
                <td align="right" nowrap="nowrap">
					<select name="TipoProveedor" id="TipoProveedor" onchange="
							document.getElementById('tdProveedor').style.display	= (this.value == 'SN')?'':'none';
							document.getElementById('tdBeneficiario').style.display	= (this.value == 'B')?'':'none';
						"
					>
						<option value="SN" <cfif modoD EQ "CAMBIO" and rsFormDet.SNcodigo NEQ "">selected</cfif>><cf_translate key = LB_SocioNegocio xmlfile = "Tab2_Gastos_form.xml">Socio Negocio</cf_translate></option>
						<option value="B"  <cfif modoD EQ "CAMBIO" and rsFormDet.TESBid NEQ "">selected</cfif>><cf_translate key = LB_Beneficiario xmlfile = "Tab2_Gastos_form.xml">Beneficiario</cf_translate></option>
					</select>:
				</td>
                   <td id="tdProveedor" valign="top" align="left" nowrap="nowrap" colspan="9"
				   		<cfif modoD EQ 'CAMBIO' and rsFormDet.SNcodigo EQ "">style="display:none;"</cfif>
				   >
                     <cfif modoD neq 'ALTA'>
					  <cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P" size="55" frame="frame1" form="formDet" idquery="#rsFormDet.SNcodigo#">
					 <cfelse>
					 <cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P" size="55" frame="frame1" form="formDet">
					 </cfif>
    			   </td>
                   <td id="tdBeneficiario" valign="top" align="left" nowrap="nowrap" colspan="9"
				   		<cfif modoD EQ 'ALTA' or rsFormDet.SNcodigo NEQ "">style="display:none;"</cfif>
				   >
						<cfif modoD NEQ 'ALTA'>
							<cf_tesbeneficiarios form="formDet" tabindex="1" TESBidValue="#rsFormDet.TESBid#" TESBid="TESBid">
						<cfelse>
							<cf_tesbeneficiarios form="formDet" tabindex="1">
						</cfif>
    			   </td>
              </tr>
               <!--- Referencia --->
                <td align="right" nowrap="nowrap"><strong><cf_translate key = LB_Referencia xmlfile = "Tab2_Gastos_form.xml">Referencia</cf_translate>:</strong>&nbsp;</td>
                   <td valign="top"colspan="4"><input type="text" name="GELGreferencia" id="GELGreferencia" value="<cfif modoD NEQ 'ALTA'>#rsFormDet.GELGreferencia#</cfif>" size="60" maxlength="65" tabindex="1" /></td>
              </tr>
              <tr>
                <!--- Tipo Gasto--->
				<cfquery datasource="#Session.DSN#" name="rsSQL">
					select count(1) as cantidad
					  from GEliquidacionAnts a
					 where a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
				</cfquery>
                <td nowrap="nowrap" align="right"><strong><cf_translate key = LB_TipoGasto xmlfile = "Tab2_Gastos_form.xml">Tipo Gasto</cf_translate></strong>: </td>
                <td>
				<input type="hidden" name="GETid" value="#rsID_concepto_gasto.GETid#"/>
				<cfif modoD EQ "ALTA" AND LvarConPlanCompras>
					<select name="Tipo" id="tipo" disabled>
						<option value="">(<cf_translate key = LB_PlanCompras xmlfile = "Tab2_Gastos_form.xml">Plan de Compras</cf_translate>)</option>
					</select>
				<cfelseif modoD EQ "ALTA">
					<select name="Tipo" id="tipo" onchange="limpiar()" tabindex="1">
					<cfif LvarHayAnts>
						<option value="0">(<cf_translate key = LB_Anticipos xmlfile = "Tab2_Gastos_form.xml">Anticipos</cf_translate>)</option>
					</cfif>
					<cfloop query="rsTipoGasto">
						<option value="#rsTipoGasto.GETid#">#rsTipoGasto.GETdescripcion#</option>
					</cfloop>
						<option value="-1">(<cf_translate key = LB_ImpuestoCreditoFiscal xmlfile = "Tab2_Gastos_form.xml">Impuestos Crédito Fiscal</cf_translate>)</option>
					</select>
				<cfelse>
					<select name="Tipo" id="tipo" tabindex="1" disabled>
					<cfloop query="rsTipoGasto">
						<cfif rsTipoGasto.GETid eq rsID_concepto_gasto.GETid>
						<option value="#rsTipoGasto.GETid#" selected>#rsTipoGasto.GETdescripcion#</option>
						</cfif>
					</cfloop>
					<cfif rsID_concepto_gasto.GETid EQ -1>
						<option value="-1">(<cf_translate key = LB_ImpuestoCreditoFiscal xmlfile = "Tab2_Gastos_form.xml">Impuestos Crédito Fiscal</cf_translate>)</option>
					</cfif>
					</select>
				</cfif>
                </td>

                <!--- Concepto del Gasto--->

              <tr>
                    <td nowrap="nowrap" align="right"><strong><cf_translate key = LB_ConceptoGasto xmlfile = "Tab2_Gastos_form.xml">Concepto de Gasto</cf_translate>:</strong> </td>
                    <td colspan="8" nowrap="nowrap" align="left">

                        <cfif modoD EQ "ALTA" AND LvarConPlanCompras>
                            <select name="Concepto" id="Concepto" disabled>
								<option value="">(<cf_translate key = LB_PlanCompras xmlfile = "Tab2_Gastos_form.xml">Plan de Compras</cf_translate>)</option>
							</select>
                        <cfelseif modoD EQ "ALTA">
                            <input id="GECdescripcion" type="text" title="GECdescripcion" alt="GECdescripcion" readonly="" tabindex="-1" size="20" value="" name="GECdescripcion" style="font-size:-1px;">
                        	<a id="img_formDet_Concepto" tabindex="-1" href="javascript:ConceptoGastos();">
                            	<img width="18" height="14" border="0" align="absmiddle" name="Concepto" alt="Conceptos de Gastos" src="/cfmx/sif/imagenes/Description.gif">
                            </a>
                            <input id="Concepto" type="hidden" alt="Concepto" value="" name="Concepto">
                        <cfelse>
                        	<input id="GECdescripcion" type="text" title="GECdescripcion" alt="GECdescripcion" readonly="true" tabindex="-1" size="30" value="#rsID_concepto_gasto.GECdescripcion#" name="GECdescripcion" style="font-size:-1px;">
                        	<input id="Concepto" type="hidden" alt="Concepto" value="#rsID_concepto_gasto.GECid#" name="Concepto">
                        </cfif>

                    </td>

              </tr>
				#fnActividadEmpresarial()#
              <tr>
                <!--- Descripcion--->
                <td valign="top" align="right" nowrap="nowrap"><strong><cf_translate key = LB_Descripcion xmlfile = "Tab2_Gastos_form.xml">Descripci&oacute;n</cf_translate>:</strong> </td>
                <td valign="top"colspan="4"><input type="text" name="GELGdescripcion" id="GELGdescripcion" value="<cfif modoD NEQ 'ALTA'>#trim(rsFormDet.GELGdescripcion)#</cfif>"
							size="60" maxlength="65"
							tabindex="1" />
                </td>
              </tr>
			  <tr>
                <!--- Moneda documento --->
                <td valign="top" align="right"><strong><cf_translate key = LB_MonedaDoc xmlfile = "Tab2_Gastos_form.xml">Moneda Doc</cf_translate>:</strong></td>
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
									<cf_sifmonedas onChange="asignaTCDet('S');" valueTC="#rsFormDet.GELGtipoCambio#"
												form="formDet" Mcodigo="McodigoDet" query="#rsMoneda#"
												FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1" habilita="S">
								<cfelse>
									<cf_sifmonedas onChange="asignaTCDet('S');" valueTC="#rsFormDet.GELGtipoCambio#"
												form="formDet" Mcodigo="McodigoDet" query="#rsMoneda#"
												FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1">
								</cfif>
							<cfelse>
								<cfset LvarM_Doc = "">
								<cf_sifmonedas onChange="asignaTCDet('S');" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"
										form="formDet" Mcodigo="McodigoDet"  tabindex="1" query="#rsForm#">
						  </cfif>
						</td>
						<td nowrap>
						<!--- Tipo Cambio --->
							<strong><cf_translate key = LB_TipoCambio xmlfile = "Tab2_Gastos_form.xml">TC</cf_translate>:&nbsp;</strong>
							<cfif modoD NEQ 'ALTA'>
								<cfset LvarMonto = rsFormDet.GELGtipoCambio>
							<cfelse>
								<cfset LvarMonto = 0>
							</cfif>
                            <cf_inputNumber name="GELGtipoCambio" value="#LvarMonto#" size="11" enteros="6" decimales="4" onchange="CambiaTipoD()" onfocus="GvarFocus='TC';" tabindex="1">
							<input name="M_TC" style="border:none; background:inherit; font-size:9px;" size="5" value="#rsMonedaLocal.Miso4217#s" readonly="true" tabindex="-1"/>

                            <!---<input name="GELGtipoCambio"  type="hidden" id="GELGtipoCambio" value="#LvarMonto#"/>--->
						<!--- Factor de Conversin--->
							<strong><cf_translate key = LB_FactorConversion xmlfile = "Tab2_Gastos_form.xml">FC</cf_translate>:&nbsp;</strong>
							<cfif modoD NEQ 'ALTA'>
								<cfset LvarMonto = rsFormDet.GELGtipoCambio<!---/rsMonedaLiquidacion.GELtipoCambio--->>
							<cfelse>
								<cfset LvarMonto = 0>
							</cfif>
		                    <cf_inputNumber name="factor" value="100" size="11" enteros="6" decimales="4" onchange="CambiaFactorD()" onfocus="GvarFocus='FC';" tabindex="1">
                            <input name="M_FC" style="border:none; background:inherit; font-size:9px;" size="10" value="<cfif modoD EQ "CAMBIO">#rsMonedaLiquidacion.Miso4217#s/#rsFormDet.Miso4217#</cfif>" readonly="true" tabindex="-1"/>
						</td>
					</tr>
				</table></td>
			</tr>
			<!---- Montos ---->
			<cfif modoD EQ "ALTA">
				<cfset LvarMontoOri 	= 0>
				<cfset LvarNoAutOri 	= 0>
				<cfset LvarTotalOri 	= 0>
				<cfset LvarImpuesOri	= 0>
				<cfset LvarSinImpOri	= 0>
			<cfelse>
				<cfif rsFormDet.GELGmontoOri EQ 0 AND rsFormDet.GELGtotalOri NEQ 0>
					<cfset LvarMontoOri = rsFormDet.GELGtotalOri>
				<cfelse>
					<cfset LvarMontoOri	= rsFormDet.GELGmontoOri>
				</cfif>
				<cfset LvarNoAutOri		= LvarMontoOri - rsFormDet.GELGtotalOri>
				<cfset LvarImpuesOri	= rsFormDet.GELGimpNCFOri>
				<cfset LvarSinImpOri	= LvarMontoOri - LvarImpuesOri>

				<cfset LvarTotalOri		= rsFormDet.GELGtotalOri>
			</cfif>
			<tr>
                <!--- Monto del Documento --->
                <td valign="top"  align="right">
					<input style="width:1px; visibility:hidden">
					<strong><cf_translate key = LB_MontoDoc xmlfile = "Tab2_Gastos_form.xml">Monto Doc</cf_translate>:</strong>
				</td>
                <td valign="top" colspan="3" rowspan="3" nowrap="nowrap">
					<table border="0" cellpadding="1" cellspacing="0">
						<tr>
							<td nowrap>
								<cf_inputNumber name="GELGsinImpOri" value="#LvarSinImpOri#" size="15" id="monto" enteros="13" decimales="2" tabindex="1" onChange="if(this.value=='')this.value='0.00';CambiaMontoD();" onfocus="GvarFocus='MD';" >
								<input name="M_Doc1" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
							</td>
							<td align="right" nowrap style="display:#LvarDigitarImpNCF#" id="DigitarImpNCF_1">
								<strong><cf_translate key = LB_ImpuestoNoCF xmlfile = "Tab2_Gastos_form.xml">Impuesto no CF</cf_translate>:&nbsp;</strong>
							</td>
							<td nowrap style="display:#LvarDigitarImpNCF#" id="DigitarImpNCF_2">
								<cf_inputNumber name="GELGimpNCFOri" value="#LvarImpuesOri#" size="15" id="monto" enteros="13" decimales="2" tabindex="1" onChange="if(this.value=='')this.value='0.00';CambiaMontoD();" onfocus="GvarFocus='MD';" >
								<input name="M_Doc1b" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
							</td>
							<td align="right" nowrap style="display:#LvarDigitarImpNCF#" id="DigitarImpNCF_3">
								<strong><cf_translate key = LB_TotalDoc xmlfile = "Tab2_Gastos_form.xml">Total Doc </cf_translate>:&nbsp;</strong>
							</td>
							<td nowrap style="display:#LvarDigitarImpNCF#" id="DigitarImpNCF_4">
								<cf_inputNumber name="GELGmontoOri" value="#LvarMontoOri#" size="15" id="monto" enteros="13" decimales="2" tabindex="1" onChange="if(this.value=='')this.value='0.00';CambiaMontoD();" onfocus="GvarFocus='MD';" readonly>
								<input name="M_Doc1c" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
							</td>
						</tr>
						<tr>
							<td nowrap>
								<cf_inputNumber name="GELGnoAutOri" value="#LvarNoAutOri#" size="15" id="monto" enteros="13" decimales="2" tabindex="1" onChange="if(this.value=='')this.value='0.00';CambiaMontoD();" onfocus="GvarFocus='MD';" readonly="#ModoD EQ "CAMBIO" AND rsFormDet.Icodigo NEQ ""#">
								<input name="M_Doc2" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
							</td>
							<td align="right" nowrap style="width:110px">
								<!---Monto del Documento Autorizado--->
								<strong><cf_translate key = LB_Autorizado xmlfile = "Tab2_Gastos_form.xml">Autorizado</cf_translate>:&nbsp;</strong>
							</td>
							<td nowrap>
								<cf_inputNumber name="GELGtotalOri" value="#LvarTotalOri#" size="15" enteros="13" decimales="2" readonly="true">
								<input name="M_Doc3" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
							</td>
							<td align="right" nowrap>
								<strong><cf_translate key = LB_AutorizadoLiq xmlfile = "Tab2_Gastos_form.xml">Autorizado LIQ</cf_translate>:&nbsp;</strong>
							</td>
							<td nowrap>
								<cfif  modoD NEQ 'ALTA'>
									<cfset LvarMonto = NumberFormat(rsFormDet.GELGtotal,",0.00")>
								<cfelse>
									<cfset LvarMonto = "0.00">
								</cfif>
								<cf_inputNumber name="GELGtotal" size="15" enteros="13" decimales="2" readonly="true">
								<input style="border:none; background:inherit; font-size:9px;" size="5" value="#rsMonedaLiquidacion.Miso4217#s" readonly="true" tabindex="-1">
							</td>
						</tr>
						<tr style="display:#LvarDigitarRetencion#;">
							<td colspan="6" style="font-size:3px; border-bottom:solid 1px ##CCCCCC;">&nbsp;

							</td>
						</tr>
						<cfif isdefined("rsGEret") and rsGEret.Pvalor EQ 1>
						<tr style="display:#LvarDigitarRetencion#">
							<td >
								<select name="Rcodigo" tabindex="1" id="PorcRetenc" onchange="CambiaMontoD();" style="width:140px;" 
								<cfif rsForm.GELtipoPago eq "CCH" AND isdefined("rsGEret") and rsGEret.Pvalor EQ 0>
								disabled
								</cfif>
									>
							  <option value="-1" >-- <cf_translate key = LB_SinRetencion xmlfile = "Tab2_Gastos_form.xml">Sin Retenciones</cf_translate> --</option>
							  <!--- JARR  --->
							  <cfloop query="rsRetenciones">
							    <option value="#rsRetenciones.Rcodigo#"
									<cfif modoD NEQ "ALTA" and rsRetenciones.Rcodigo EQ rsFormDet.Rcodigo>selected</cfif>>#rsRetenciones.Rdescripcion#</option>
						      </cfloop>
					      </select></td>
							<td align="right" nowrap>
								<strong><cf_translate key = LB_MontoDoc xmlfile = "Tab2_Gastos_form.xml">Monto Doc</cf_translate>:&nbsp;</strong>
							</td>
							<td nowrap>
								<cf_inputNumber name="TotalRetenc" size="15" enteros="13" decimales="2" readonly="true">
								<input name="M_Doc4" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
							</td>
							<td align="right" nowrap>
								<strong><cf_translate key = LB_RetencionLiq xmlfile = "Tab2_Gastos_form.xml">Retención LIQ</cf_translate>:&nbsp;</strong>
							</td>
							<td nowrap>
								<cf_inputNumber name="MontoRetencionAnti" size="15" enteros="13" decimales="2" readonly="true">
								<input style="border:none; background:inherit; font-size:9px;" size="5" value="#rsMonedaLiquidacion.Miso4217#s" readonly="true" tabindex="-1">
							</td>
						</tr>
						</cfif>
						<!--- <tr style="display:#LvarDigitarRetencion#;">
							<td colspan="6" style="font-size:3px; border-bottom:solid 1px ##CCCCCC;">&nbsp;

							</td>
						</tr> --->
						
					</table>
				</td>
			</tr>
			<tr>
                <!--- Monto del Documento No Autorizado --->
				<td valign="top" align="right" nowrap>
					<input style="width:1px; visibility:hidden; font-size:8px;">
					<strong><cf_translate key = LB_NoAutorizado xmlfile = "Tab2_Gastos_form.xml">No Autorizado</cf_translate>:</strong>
				</td>
			</tr>
			
			<cfif isdefined("rsGEret") and rsGEret.Pvalor EQ 1>
			<tr>
				<!------Retencion------>
				<td valign="top" align="right" style="display:#LvarDigitarRetencion#">
					<input style="width:1px; visibility:hidden">
					<strong><cf_translate key = LB_Retencion xmlfile = "Tab2_Gastos_form.xml">Retención</cf_translate>:</strong>
				</td>
			</tr>
			</cfif>

			<tr id="trUUIDC" style="display:">
				<td align="right">
					<input style="width:1px; visibility:hidden">
					<strong><cf_translate key = LB_Retencion xmlfile = "Tab2_Gastos_form.xml">Timbre Fiscal</cf_translate>:</strong>
				</td>
				<td >
					<cfif modoD EQ 'CAMBIO'>
						<cf_sifComprobanteFiscal Origen="TSGS" click = "CambioDet" form="formDet" IDdocumento="#rsForm.GELid#" IDlinea="#rsFormDet.GELGid#" nombre="Timbre" Documento="#trim(rsFormDet.GELGnumeroDoc)#">
					<cfelse>
						<cf_sifComprobanteFiscal Origen="TSGS" form="formDet" nombre="Timbre" modo="alta">
					</cfif>
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
				select cb.CBid as CBid_TCE, CBcodigo, Miso4217, m.Mcodigo,
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
					select cb.CBid as CBid_TCE, CBcodigo, Miso4217, m.Mcodigo,
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

			<div style="display:#LvarDigitarTCE#">
			<tr>
				<td colspan="6" style="font-size:2px; border-bottom:solid 1px ##CCCCCC">&nbsp;

				</td>
			</tr>
			<tr>
				<td align="right" nowrap>
					<strong><cf_translate key = LB_Retencion xmlfile = "Tab2_Gastos_form.xml">Pago con TCE</cf_translate>:</strong>
				</td>
				<td valign="top" colspan="4" nowrap>
						<!-----TCE------->
						<cfset LvarM_TCE = "">
						<select name="CBid_TCE" style="width:220px;"
								<!---onblur="CambiaTCE(1);"--->
								onchange="CambiaTCE(2);"
								tabindex="1"
						>
							<option value="-1">(N/A)</option>
						<cfloop query="rsCB_TCE">
							<option value="#rsCB_TCE.CBid_TCE#|#rsCB_TCE.Mcodigo#|#rsCB_TCE.Miso4217#|#rsCB_TCE.TC#"
								<cfif rsTCEs.CBid_TCE EQ rsCB_TCE.CBid_TCE>
									selected
									<cfset LvarM_TCE = "#rsCB_TCE.Miso4217#s">
								</cfif>
							>#rsCB_TCE.CBcodigo# #rsCB_TCE.Miso4217#</option>
						</cfloop>
						</select>&nbsp;
						<!--- Tipo Cambio --->
							<strong><cf_translate key = LB_TipoCambio xmlfile = "Tab2_Gastos_form.xml">TC</cf_translate>:&nbsp;</strong>
							<cfif modoD NEQ'ALTA'>
								<cfset LvarMonto = rsTCEs.GELTtipoCambio>
							<cfelse>
								<cfset LvarMonto = 0>
							</cfif>

		                    <cf_inputNumber name="GELTtipoCambio" value="#LvarMonto#" size="11" enteros="6" decimales="4"
											<!---onblur="CambiaTCE(1);"---> onchange="CambiaTCE(1);"
											tabindex="1"
											><input style="border:none; background:inherit; font-size:9px;" size="5" value="#rsMonedaLocal.Miso4217#s" readonly="true" tabindex="-1"/>

						<!--- Factor de Conversin--->
							<strong><cf_translate key = LB_FactorConversion xmlfile = "Tab2_Gastos_form.xml">FC</cf_translate>:&nbsp;</strong>
							<cfif modoD NEQ'ALTA'>
								<cfset LvarMonto = 0>
							<cfelse>
								<cfset LvarMonto = 0>
							</cfif>
		                    <cf_inputNumber name="GELT_FC" value="#LvarMonto#" size="11" enteros="6" decimales="4"
											<!---onblur="CambiaTCE(1);"---> onchange="CambiaTCE(3);"
											tabindex="1"
											><input name="M_FC_TCE" style="border:none; background:inherit; font-size:9px;" size="10" value="<cfif modoD EQ "CAMBIO">#rsMonedaLiquidacion.Miso4217#s/#rsFormDet.Miso4217#</cfif>" readonly="true" tabindex="-1"/>
				</td>
			</tr>
			<tr id="TR_TCE1" <cfif rsTCEs.CBid_TCE EQ "">style="display:none" </cfif>>
				<td align="right" nowrap>
					<strong><cf_translate key = LB_TotalFactura xmlfile = "Tab2_Gastos_form.xml">Total Factura</cf_translate>:</strong>
				</td>
				<td>
                    <cf_inputNumber name="TotalPagado" value="#LvarTotalPagado+LvarMontoOri#" size="15" enteros="13" decimales="2" readonly="true">
					<input name="M_Doc6" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
				</td>
				<td align="right" nowrap>
					<strong><cf_translate key = LB_MaximoPago xmlfile = "Tab2_Gastos_form.xml">Maximo Pago</cf_translate>:</strong>
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
					<strong><cf_translate key = LB_Voucher xmlfile = "Tab2_Gastos_form.xml">Voucher</cf_translate>:</strong>
				</td>
				<td nowrap="nowrap">
					<input type="text" name="GELTreferencia" id="GELTreferencia" <!---onfocus="CambiaTCE(1);"---> size="20" maxlength="20" tabindex="1" value="#rsTCEs.GELTreferencia#"/>
				</td>
				<td align="right" nowrap>
					<strong><cf_translate key = LB_MontoPago xmlfile = "Tab2_Gastos_form.xml">Monto Pago</cf_translate>:</strong>
				</td>
				<td nowrap="nowrap">
                    <cf_inputNumber name="GELTmontoOri" value="#rsTCEs.GELTmontoOri#" onchange="CambiaTCE(1);" <!---onfocus="CambiaTCE(1);"---> size="15" enteros="13" decimales="2" tabindex="1">
					<input name="M_Doc5" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_Doc#" readonly="true" tabindex="-1"/>
				</td>
			</tr>
			<tr id="TR_TCE3" <cfif rsTCEs.CBid_TCE EQ "">style="display:none" </cfif>>
				<td align="right" nowrap="nowrap">
					<strong><cf_translate key = LB_MontoLiq xmlfile = "Tab2_Gastos_form.xml">Monto LIQ</cf_translate>:</strong>
				</td>
				<td nowrap="nowrap">
                	<!---<input name="GELTmonto"  type="hidden" id="GELTmonto" value="#rsTCEs.GELTmonto#"/>--->

                    <cf_inputNumber name="GELTmonto" value="#rsTCEs.GELTmonto#" size="15" enteros="13" decimales="2" readonly="true">
					<input style="border:none; background:inherit; font-size:9px;" size="10"
                    value="#rsMonedaLiquidacion.Miso4217#s" readonly="true" tabindex="-1"/>
				</td>
				<td align="right" nowrap="nowrap">
					<strong><cf_translate key = LB_TipoCambio xmlfile = "Tab2_Gastos_form.xml">TC</cf_translate>:&nbsp;</strong>
				</td>
				<td nowrap="nowrap">
                	<!---SML ((#rsCB_TCE.Miso4217# * #rsTCEs.GELTmontoTCE#)/#rsTCEs.GELTmontoOri#)--->
					<cf_inputNumber name="TC_TCE" value="" size="15" enteros="13" decimales="4" readonly="true">
                    <input style="border:none; background:inherit; font-size:9px;" size="5" value="#rsMonedaLocal.Miso4217#s" readonly="true" tabindex="-1"/>
				</td>
			</tr>
            <tr id="TR_TCE4" <cfif rsTCEs.CBid_TCE EQ "">style="display:none" </cfif>>
				<td align="right" nowrap="nowrap">

				</td>
				<td nowrap="nowrap">

				</td>
				<td align="right" nowrap="nowrap">
					<strong><cf_translate key = LB_MontoTCE xmlfile = "Tab2_Gastos_form.xml">Monto TCE</cf_translate>:</strong>
				</td>
				<td nowrap="nowrap">
				<cfif rsGstoMonTCE.pvalor eq 0>
                    <cf_inputNumber name="GELTmontoTCE" value="#rsTCEs.GELTmontoTCE#" size="15" enteros="13" decimales="2" readonly="true">
                <cfelse>
					<cf_inputNumber name="GELTmontoTCE" value="#rsTCEs.GELTmontoTCE#" size="15" enteros="13" decimales="2" readonly="false" onchange="CambiaTipoCambio()">
                </cfif>
					<input name="M_TCE" style="border:none; background:inherit; font-size:9px;" size="5" value="#LvarM_TCE#" readonly="true"  tabindex="-1"/>
				</td>
			</tr>
			</div>
			<tr>
				<td colspan="4" class="formButtons">
					<cf_botones sufijo='Det' modo='#modoD#'  tabindex="1" include="Regresar" includevalues="Lista Gastos">
				</td>
			</tr>
			<cfif LvarConPlanCompras>
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
var GvarFocus = "1";
function funcAltaDet()
{
	document.formDet.GELTmontoTCE.disabled=false;
}
function funcCambioDet()
{
	<!---alert('MIRA Funcion CambiaDet');--->
	if (GvarFocus == 'TC')
		CambiaTipoD();
	else if (GvarFocus == 'FC')
		CambiaFactorD();
	else if (GvarFocus == 'MD')
		CambiaMontoD();
	<!---else
		CambiaTCE(1);--->

	if (GvarFocus == "")
		return true;
	GvarFocus = "";
	window.setTimeout("document.formDet.CambioDet.click();",100);
	document.formDet.GELTmontoTCE.disabled=false;
	<!---alert('MIRA Funcion CambiaDet Monto TCE ' + document.formDet.GELTmontoTCE.value);--->
	return false;
}

function CambiaTipoD(m){
        Rcodigo = document.formDet.Rcodigo.value;
		monto=document.formDet.GELGtotalOri.value;
		tipo=document.formDet.GELGtipoCambio.value;
		moneda = document.formDet.McodigoDet.value;
		id_liqui=document.formDet.GELid.value;
		fecha=document.formDet.GELGfecha.value;
		<!---alert('MIRA CambiaTipoD: TC ' + tipo);--->
		document.getElementById('monedax1').src = 'CambiaMLiquidcfm?&Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'&tipo='+tipo+'&Monto='+monto+'&Rcodigo='+encodeURIComponent(Rcodigo)+'';
	}

function CambiaMontoD(m){

		LvarGELGsinImpOri=parseFloat(qf(document.formDet.GELGsinImpOri.value));
		LvarGELGimpNCFOri=parseFloat(qf(document.formDet.GELGimpNCFOri.value));
		if (isNaN(LvarGELGsinImpOri)) LvarGELGsinImpOri = 0;
		if (isNaN(LvarGELGimpNCFOri)) LvarGELGimpNCFOri = 0;
		montoOri=LvarGELGsinImpOri + LvarGELGimpNCFOri;
		LvarGELGnoAutOri=parseFloat(qf(document.formDet.GELGnoAutOri.value));
		if (isNaN(LvarGELGnoAutOri)) LvarGELGnoAutOri = 0;

		if (montoOri < LvarGELGnoAutOri)
		{
			document.formDet.GELGnoAutOri.value = document.formDet.GELGmontoOri.value;
			LvarGELGnoAutOri = montoOri;
		}
		document.formDet.GELGmontoOri.value = redondear(montoOri,2);
		montoOri = montoOri - LvarGELGnoAutOri;
		document.formDet.GELGtotalOri.value = redondear(montoOri,2);

		tipo=document.formDet.GELGtipoCambio.value;
		moneda = document.formDet.McodigoDet.value;
		id_liqui=document.formDet.GELid.value;
		fecha=document.formDet.GELGfecha.value;
	    Rcodigo = document.formDet.Rcodigo.value;
		<!---alert('MIRA CambiaMontoD: TC ' + tipo);
		alert('MIRA CambiaMontoD: MontoTCE ' + document.formDet.GELTmontoTCE.value);--->
		document.getElementById('monedax1').src = 'CambiaMLiquid.cfm?Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'&tipo='+tipo+'&Monto='+montoOri+'&Rcodigo='+encodeURIComponent(Rcodigo)+'';
}



//window.setTimeout("CambiaTCE(0);",100);
function CambiaTCE(tc)
{
	<!---alert('MIRA Variable ' + tc);--->
	LvarMoneda_DOC = document.formDet.M_Doc1.value.substring(0,3);
	LvarTCE 	= document.formDet.CBid_TCE.value;
	LvarTC_TCE_RO	= false	;
	LvarMontoDoc = qf(document.formDet.GELGmontoOri.value);

	if (LvarMontoDoc == "" || LvarMontoDoc == 0)
		LvarMontoDoc = 0;
	else
		LvarMontoDoc = parseFloat(LvarMontoDoc);

	LvarMontoRet = qf(document.formDet.TotalRetenc.value);
	if (LvarMontoRet == "" || LvarMontoRet == 0)
		LvarMontoRet = 0;
	else
		LvarMontoRet = parseFloat(LvarMontoRet);

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
		document.getElementById('TR_TCE4').style.display='none';
	}
	else
	{
		document.getElementById('TR_TCE1').style.display='';
		document.getElementById('TR_TCE2').style.display='';
		document.getElementById('TR_TCE3').style.display='';
		document.getElementById('TR_TCE4').style.display='';

		// 0=CBid, 1=Mcodigo, 2=Miso4217, 3=TC
		LvarMoneda_TCE	= LvarTCE.split("|")[2];
		varMoneda_TCE	= LvarTCE.split("|")[3];

		LvarMonto = qf(document.formDet.GELTmontoOri.value);
		if (LvarMonto == "" || LvarMonto == 0)
			LvarMonto = 0;
		else
			LvarMonto = parseFloat(LvarMonto);

		LvarTC_DOC = qf(document.formDet.GELGtipoCambio.value);
		if (LvarTC_DOC == "" || LvarTC_DOC == 0)
			LvarTC_DOC = 1;
		else
			LvarTC_DOC = parseFloat(LvarTC_DOC);

		LvarFC_DOC = qf(document.formDet.factor.value);

		if (LvarFC_DOC == "" || LvarFC_DOC == 0)
			LvarFC_DOC = 1;
		else
			LvarFC_DOC = parseFloat(LvarFC_DOC);

		if ('#rsMonedaLiquidacion.Miso4217#' == LvarMoneda_DOC)
		{
			LvarFC_DOC	= 1;
		}

		LvarFC_TCE = document.formDet.GELT_FC.value;
		if (LvarFC_TCE == "" || LvarFC_TCE == 0)
			LvarFC_TCE = 1;
		else
			LvarFC_TCE = parseFloat(LvarFC_TCE);

		if (LvarMoneda_TCE == '#rsMonedaLocal.Miso4217#')
		{
			LvarTC_TCE	= 1;
			LvarFC_TCE	= LvarTC_TCE / LvarTC_DOC;
			LvarTC_TCE_RO	= true;
		}
		else if (LvarMoneda_TCE == LvarMoneda_DOC)
		{
			LvarTC_TCE	= LvarTC_DOC;
			LvarFC_TCE	= LvarTC_TCE / LvarTC_DOC;
			LvarTC_TCE_RO	= true;
		}
		else if (LvarMoneda_TCE == '#rsMonedaLiquidacion.Miso4217#')
		{
			LvarTC_TCE	= #rsForm.GELtipoCambio#;
			LvarFC_TCE	= LvarTC_TCE / LvarTC_DOC;
			LvarTC_TCE_RO	= true;
		}
		else if (tc == 2)	// Cambia TCE
		{
			LvarTC_TCE	= LvarTCE.split("|")[3];
			LvarFC_TCE	= LvarTC_TCE / LvarTC_DOC;
			LvarTC_TCE_RO	= false;
		}
		else if (tc == 1)	// Cambia FC
		{
			LvarTC_TCE	= LvarFC_TCE * LvarTC_DOC;
			LvarTC_TCE_RO	= false;
		}
		else				// Cambia TC u otro dato
		{
			LvarTC_TCE	= document.formDet.GELTtipoCambio.value;
			LvarFC_TCE	= LvarTC_TCE / LvarTC_DOC;
			LvarTC_TCE_RO	= false;
		}

		LvarGELT_Mori = document.formDet.GELTmontoOri.value;
		LvarGELT_Mliq = document.formDet.GELTmonto.value;

		document.formDet.GELTtipoCambio.disabled = LvarTC_TCE_RO;
		document.formDet.GELT_FC.disabled = LvarTC_TCE_RO;

		if (tc > 0) {
		document.formDet.GELTtipoCambio.value = redondear(LvarTC_TCE,4);
		document.formDet.GELT_FC.value = redondear(LvarFC_TCE,4);
		document.formDet.M_FC_TCE.value = LvarMoneda_TCE + "s/" + LvarMoneda_DOC;
		document.formDet.M_TCE.value = LvarMoneda_TCE + "s";

		if ('#rsMonedaLiquidacion.Miso4217#' == LvarMoneda_TCE)	<!----Moneda Tarjeta Igual a Moneda Gasto --->
			document.formDet.GELTmonto.value	= redondear(LvarMonto * LvarTC_DOC / #rsMonedaLiquidacion.GELtipoCambio#,2);
		else
			document.formDet.GELTmonto.value = redondear(LvarMonto * LvarTC_DOC / #rsMonedaLiquidacion.GELtipoCambio# ,2);

		if (LvarFC_TCE == "" || LvarFC_TCE == 0)
			document.formDet.GELTmontoTCE.value = "";
		else
			document.formDet.GELTmontoTCE.value = redondear(LvarMonto / LvarFC_TCE,2);
		}

		if (LvarFC_TCE == 1)
			document.formDet.GELTmontoTCE.disabled = true;
		else
			document.formDet.GELTmontoTCE.disabled = false;



		if (LvarMonto != '')
		{
				<cfif isdefined('rsTCEs.GELTmontoTCE') and rsTCEs.GELTmontoTCE NEQ ''>
					if (cambMonD == 0)
					document.formDet.TC_TCE.value = (((#rsTCEs.GELTmontoTCE#) * (LvarTC_TCE)) / LvarMonto);
				<cfelse>
					<!---redondear(((LvarMoneda_TCE * LvarMontoTCE)/LvarMonto),4) ;--->
					document.formDet.TC_TCE.value = LvarTC_DOC; <!---(((LvarMonto * LvarTC_DOC / #rsMonedaLiquidacion.GELtipoCambio#)) / LvarMonto);--->
				</cfif>
		}
		else
			document.formDet.TC_TCE.value =  "";

	}
	<!---alert('MIRA CambiaTCE:' + document.formDet.GELTmontoTCE.disabled);--->


	document.formDet.TotalPagado.value	= redondear(#LvarTotalPagado# + LvarMontoDoc - LvarMontoRet,2) ;
	document.formDet.MaximoPagar.value	= redondear(#LvarTotalPagado-LvarTotalTCE# + LvarMontoDoc - LvarMontoRet,2) ;
}

function CambiaTipoCambio(tc)
{
	LvarMonto = qf(document.formDet.GELTmontoOri.value);
	LvarMontoTCE = qf(document.formDet.GELTmontoTCE.value);
	LvarTCE 	= document.formDet.CBid_TCE.value;
	LvarTC_DOC = qf(document.formDet.GELGtipoCambio.value);
	LvarFC_DOC = qf(document.formDet.factor.value);
	LvarMoneda_DOC = document.formDet.M_Doc1.value.substring(0,3);
	LvarTCE 	= document.formDet.CBid_TCE.value;

	if (LvarFC_DOC == "" || LvarFC_DOC == 0)
		LvarFC_DOC = 1;
	else
		LvarFC_DOC = parseFloat(LvarFC_DOC);

	if ('#rsMonedaLiquidacion.Miso4217#' == LvarMoneda_DOC)
	{
		LvarFC_DOC	= 1;
	}

	if (LvarMonto == "" || LvarMonto == 0)
	{
		document.formDet.GELTmontoTCE.value = 0;
		return;
	}
	if (LvarMontoTCE != "" && LvarMontoTCE != 0)
	{
		document.formDet.GELT_FC.value = redondear(LvarMonto/LvarMontoTCE,4);
	}
	<!--- El tipo de Cambio del Documento de Gasto No cambia --->
<!---	if (LvarMonto != "" && LvarMonto != 0)
	{
		document.formDet.GELGtipoCambio.value = redondear(LvarMontoTCE/LvarMonto,4);

	}--->

	LvarTC_DET = redondear(LvarMontoTCE/LvarMonto,4);

	<!--- El factor del Documento de Gasto No cambia --->
<!---	if ('#rsMonedaLiquidacion.Miso4217#' == LvarMoneda_DOC)
	{
		document.formDet.factor.value    = "#Numberformat(1,",9.0000")#";
	}
	else
	{
		document.formDet.factor.value    = redondear(LvarTC_DET/LvarTC_DOC,4);
	}
--->
	if ('#rsMonedaLiquidacion.Miso4217#' == LvarMoneda_DOC)
		document.formDet.GELTmonto.value = redondear(LvarMonto,2);
	else
		document.formDet.GELTmonto.value = redondear(LvarMonto * (LvarTC_DOC / #rsMonedaLiquidacion.GELtipoCambio#) ,2);<!---redondear(LvarMonto * LvarFC_DOC ,2);--->

	LvarMoneda_TCE	= LvarTCE.split("|")[3];

	document.formDet.TC_TCE.value = redondear(((LvarMoneda_TCE * LvarMontoTCE)/LvarMonto),4) ;
	<!---if ('#rsMonedaLiquidacion.Miso4217#' == LvarMoneda_TCE)
		document.formDet.GELTmonto1.value	= document.formDet.GELTmontoTCE.value;
	else
		document.formDet.GELTmonto1.value	= document.formDet.GELTmonto.value;--->

	<!---alert('MIRA CambiaTipoCambio: 2');--->
/*	LvarMoneda_TCE	= LvarTCE.split("|")[2];
	if ('#rsMonedaLocal.Miso4217#' == LvarMoneda_TCE)
		document.formDet.GELTmonto.value = LvarMontoTCE;
*/
}

function CambiaFactorD(m){
        Rcodigo = document.formDet.Rcodigo.value;
		tipo=document.formDet.GELGtipoCambio.value;
		monto=document.formDet.GELGtotalOri.value;
		moneda = document.formDet.McodigoDet.value;
		id_liqui=document.formDet.GELid.value;
		fecha=document.formDet.GELGfecha.value;
		factor=document.formDet.factor.value;
		<!---alert('MIRA CambiaFactorD: TC ' + tipo);--->
		document.getElementById('monedax1').src = 'CambiaMLiquid.cfm?Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'&tipo='+tipo+' &Monto='+monto+'&factor='+factor+'&Rcodigo='+encodeURIComponent(Rcodigo)+'';
}

function getDocumentoViejo(valor)
{
	id_liqui=document.formDet.GELid.value;
	$.ajax({
	   	type: 'POST',
		url:'/cfmx/sif/tesoreria/GestionEmpleados/obtenerDatos.cfm',
		data: "action=getDocmunento&origen=TSGS&GELGnumeroDoc="+valor+"&GELid="+id_liqui,
		success: function(results) {
			try{
				var obj = eval('(' + results+ ')');
				var arr = obj.DATA[0];
				GELGnumeroDoc = arr[0];
				GELGfecha = arr[1];
				SNcodigo = arr[2];
				SNnumero = arr[3];
				TESBid = arr[4];
				GELGproveedor = arr[5];
				GELGproveedorId = arr[6];
				Mcodigo = arr[7];
				GELGtipoCambio = arr[8];
				Rcodigo = arr[9];
				TimbreFiscal = arr[10];
				document.formDet.GELGnumeroDoc.value	= GELGnumeroDoc;
				document.formDet.GELGfecha.value		= GELGfecha;
				if (SNcodigo != "")
				{
					document.formDet.TipoProveedor.selectedIndex = 0;
					document.formDet.SNcodigo.value		= SNcodigo;
					document.formDet.SNnumero.value		= SNnumero;
					document.formDet.SNnombre.value		= GELGproveedor;
					document.getElementById('tdProveedor').style.display	= '';
					document.getElementById('tdBeneficiario').style.display	= 'none';
				}
				else
				{
					document.formDet.TipoProveedor.selectedIndex = 1;
					document.formDet.TESBid.value				= TESBid;
					document.formDet.TESBeneficiarioId.value	= "hola";
					document.formDet.TESBeneficiario.value		= GELGproveedor;
					document.getElementById('tdProveedor').style.display	= 'none';
					document.getElementById('tdBeneficiario').style.display	= '';
				}
				var LvarCombo = document.formDet.McodigoDet;
				for(var i = 0; i < LvarCombo.options.length; i++)
				{
					if (LvarCombo.options[i].value == Mcodigo)
					{
						LvarCombo.options[i].selected = true;
						break;
					}
				}
				LvarCombo.disabled = true;
				document.formDet.GELGtipoCambio.value = GELGtipoCambio;
				var LvarCombo = document.formDet.Rcodigo;
				for(var i = 0; i < LvarCombo.options.length; i++)
				{
					if (LvarCombo.options[i].value == Rcodigo)
					{
						LvarCombo.options[i].selected = true;
						break;
					}
				}
				//CambiaMontoD();
				document.formDet.GELGnumeroDoc.disabled 	= true;
				document.formDet.GELGfecha.disabled 		= true;
				document.formDet.TipoProveedor.disabled 	= true;
				document.formDet.SNnumero.disabled 			= true;
				document.formDet.SNnombre.disabled 			= true;
				document.formDet.TESBeneficiarioId.disabled = true;
				document.formDet.TESBeneficiario.disabled 	= true;
				document.formDet.McodigoDet.disabled 		= true;
				document.formDet.GELGtipoCambio.disabled 	= true;
				document.formDet.Rcodigo.disabled 			= true;
				if(TimbreFiscal != ""){
					document.getElementById('ce_refimagen').style.display = 'none';
					document.getElementById('Timbre').value = TimbreFiscal;
				}
				else{
					document.getElementById('ce_refimagen').style.display = '';
					document.getElementById('Timbre').style = '';
				}
			}catch(e){
				console.log(e.message);
			}
		},
	    error: function() {
	        console.log('Cannot retrieve data.');
	    }
	});
}
function DocumentoViejo(GELGnumeroDoc, GELGfecha, SNcodigo,SNnumero,TESBid,GELGproveedor,GELGproveedorId, Mcodigo, GELGtipoCambio, Rcodigo,TimbreFiscal)
{
	document.formDet.GELGnumeroDoc.value	= GELGnumeroDoc;
	document.formDet.GELGfecha.value		= GELGfecha;
	if (SNcodigo != "")
	{
		document.formDet.TipoProveedor.selectedIndex = 0;
		document.formDet.SNcodigo.value		= SNcodigo;
		document.formDet.SNnumero.value		= SNnumero;
		document.formDet.SNnombre.value		= GELGproveedor;
		document.getElementById('tdProveedor').style.display	= '';
		document.getElementById('tdBeneficiario').style.display	= 'none';
	}
	else
	{
		document.formDet.TipoProveedor.selectedIndex = 1;
		document.formDet.TESBid.value				= TESBid;
		document.formDet.TESBeneficiarioId.value	= "hola";
		document.formDet.TESBeneficiario.value		= GELGproveedor;
		document.getElementById('tdProveedor').style.display	= 'none';
		document.getElementById('tdBeneficiario').style.display	= '';
	}
	var LvarCombo = document.formDet.McodigoDet;
	for(var i = 0; i < LvarCombo.options.length; i++)
	{
		if (LvarCombo.options[i].value == Mcodigo)
		{
			LvarCombo.options[i].selected = true;
			break;
		}
	}
	LvarCombo.disabled = true;
	document.formDet.GELGtipoCambio.value = GELGtipoCambio;
	var LvarCombo = document.formDet.Rcodigo;
	for(var i = 0; i < LvarCombo.options.length; i++)
	{
		if (LvarCombo.options[i].value == Rcodigo)
		{
			LvarCombo.options[i].selected = true;
			break;
		}
	}
	CambiaMontoD();

	document.formDet.GELGnumeroDoc.disabled 	= true;
	document.formDet.GELGfecha.disabled 		= true;
	document.formDet.TipoProveedor.disabled 	= true;
	document.formDet.SNnumero.disabled 			= true;
	document.formDet.SNnombre.disabled 			= true;
	document.formDet.TESBeneficiarioId.disabled = true;
	document.formDet.TESBeneficiario.disabled 	= true;
	document.formDet.McodigoDet.disabled 		= true;
	document.formDet.GELGtipoCambio.disabled 	= true;
	document.formDet.Rcodigo.disabled 			= true;
	if(TimbreFiscal != ""){
		document.getElementById('ce_refimagen').style.display = 'none';
		document.getElementById('Timbre').value = TimbreFiscal;
	}
	else{
		document.getElementById('ce_refimagen').style.display = '';
		document.getElementById('Timbre').style = '';
	}
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
			<!---alert('Validando Detalles');--->
			var error_input = null;
			var error_msg = '';
			if (formulario.GELGnumeroDoc.value == "")
			{
				error_msg += "\n - #LB_CampoDocumento#.";
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
			if (formulario.TipoProveedor.value == "SN" && formulario.SNcodigo.value == "")
			{
				error_msg += "\n - #LB_CampoProveedor#.";
				if (error_input == null) error_input = formulario.GELGproveedor;
			}
			if (formulario.TipoProveedor.value == "B" && formulario.TESBid.value == "")
			{
				error_msg += "\n - #LB_CampoProveedor#.";
				if (error_input == null) error_input = formulario.GELGproveedor;
			}
			<cfif modoD EQ "alta">
			if (formulario.GECdescripcion.value == "")
			{
				error_msg += "\n - #LB_CamposConceptoTipo#.";
				if (error_input == null) error_input = formulario.Concepto;
			}
			</cfif>
			if (formulario.GELGdescripcion.value == "")
			{
				error_msg += "\n - #LB_CampoDescripcion#.";
				if (error_input == null) error_input = formulario.GELGdescripcion;
			}

			if ((formulario.GELGsinImpOri.value == "") || (formulario.GELGsinImpOri.value == "0.00"))
			{
				error_msg += "\n - #LB_CampoMontoDoc#.";
				if (error_input == null) error_input = formulario.GELGtotalOri;
			}

			if (formulario.GELGtotalOri.value < 0)
			{
				error_msg += "\n - El Monto Autorizado del Documento debe ser mayor o igual a cero.";
				if (error_input == null) error_input = formulario.GELGtotalOri;
			}


			if (parseFloat(formulario.GELGtotal.value) < 0)
			{
				error_msg += "\n - El monto en moneda del anticipo debe ser mayor o igual que cero.";
				if (error_input == null) error_input = formulario.GELGtotalOri;
			}
			else if (parseFloat(formulario.GELGtotalOri.value) < 0)
			{
				error_msg += "\n - El monto autorizado debe ser mayor o igual que cero.";
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
				alert("#LB_RevisaDatos#:"+error_msg);
				try
				{
					error_input.focus();
				}
				catch(e)
				{}

				return false;
			}
			<!---alert('Termina Validando Detalles');
			alert('MIRA TCE: ' + document.formDet.GELTmonto.value);--->
		}

		formulario.GELGimpNCFOri.value=qf(formulario.GELGimpNCFOri);
		formulario.GELGtotalOri.value=qf(formulario.GELGtotalOri);
		formulario.GELGtotal.value=qf(formulario.GELGtotal);

		if(formulario.GELGtipoCambio.disabled)
			formulario.GELGtipoCambio.disabled = false;
		formulario.factor.disabled = false;
		formulario.GELGtotal.disabled = false;
		document.formDet.GELTtipoCambio.disabled = false;
		document.formDet.GELTmontoTCE.disabled = false;
		document.formDet.GELT_FC.disabled = false;

		document.formDet.GELGnumeroDoc.disabled 	= false;
		document.formDet.GELGfecha.disabled 		= false;
		document.formDet.TipoProveedor.disabled 	= false;
		document.formDet.SNnumero.disabled 			= false;
		document.formDet.SNnombre.disabled 			= false;
		document.formDet.TESBeneficiarioId.disabled = false;
		document.formDet.TESBeneficiario.disabled 	= false;
		document.formDet.McodigoDet.disabled 		= false;
		document.formDet.GELGtipoCambio.disabled 	= false;
		document.formDet.Rcodigo.disabled 			= false;

		return true;
	}
/* aqu asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
function asignaTCDet(varCH) {
	if (document.formDet.McodigoDet.value == "#rsMonedaLocal.Mcodigo#") {
        Rcodigo = document.formDet.Rcodigo.value;
		monto=document.formDet.GELGtotalOri.value;
		formatCurrency(document.formDet.TC,2);
		document.formDet.GELGtipoCambio.disabled = true;
		moneda = document.formDet.McodigoDet.value;
		id_liqui=document.formDet.GELid.value;
		fecha=document.formDet.GELGfecha.value;
		tipo=document.formDet.GELGtipoCambio.value;
		cambMonD = 0;
		<!---alert('MIRA asignaTCDet: TC 1 ' + tipo);--->
		document.getElementById('monedax1').src = 'CambiaMLiquid.cfm?Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'&tipo='+tipo+'&Monto='+monto+'&Rcodigo='+encodeURIComponent(Rcodigo)+'&CambMonD='+cambMonD+'';
	}

	else {
		Rcodigo = document.formDet.Rcodigo.value;
		monto=document.formDet.GELGtotalOri.value;
		cambMonD = 0;
		<!---alert('MIRA asignaTCDet Original: TC ' + document.formDet.GELGtipoCambio.value);--->
		if (varCH == 'S') {
			document.formDet.GELGtipoCambio.disabled = false;
			var estado = document.formDet.GELGtipoCambio.disabled;
			document.formDet.GELGtipoCambio.disabled = false;
			document.formDet.GELGtipoCambio.value = '';
			document.formDet.GELGtipoCambio.disabled = estado;
			cambMonD = 1;
		}
		moneda = document.formDet.McodigoDet.value;
		id_liqui=document.formDet.GELid.value;
		fecha=document.formDet.GELGfecha.value;
		tipo=document.formDet.GELGtipoCambio.value;
		<!---alert('MIRA asignaTCDet: TC 2 ' + tipo);--->
		document.getElementById('monedax1').src = 'CambiaMLiquid.cfm?Mcodigo='+moneda+'&ID_l='+id_liqui+'&Fecha='+fecha+'&tipo='+tipo+'&Monto='+monto+'&Rcodigo='+encodeURIComponent(Rcodigo)+'&CambMonD='+cambMonD+'';
		<!---CambiaTCE(1);--->
		<!---CambiaTipoCambio();--->
	}


}

<cfif modoD NEQ 'CAMBIO'>
	document.formDet.GELGtipoCambio.value='1.0000';
</cfif>
asignaTCDet('N');

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
function limpiar(){
	document.formDet.GECdescripcion.value = "";
}
//Llama el conlis
function ConceptoGastos() {
	var vID_tipo_gasto ='';
	var vmodoD ='';
	vID_tipo_gasto = document.formDet.tipo.value;
	vmodoD = document.formDet.modoD.value;
	vID_liquidacion=document.formDet.GELid.value;
	popUpWindowIns("/cfmx/sif/tesoreria/GestionEmpleados/ConceptoGastos.cfm?GETid="+vID_tipo_gasto+"&modoD="+vmodoD+"&GELid="+vID_liquidacion+"&formulario=formDet",window.screen.width*0.20 ,window.screen.height*0.20,window.screen.width*0.60 ,window.screen.height*0.60);
}

var popUpWinIns = 0;
function popUpWindowIns(URLStr, left, top, width, height){
	if(popUpWinIns){
		if(!popUpWinIns.closed) popUpWinIns.close();
	}
	popUpWinIns = open(URLStr, 'popUpWinIns', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,scrolling=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function funcCambioDet(){
	<!---document.getElementById("formDet").action = "LiquidacionAnticipos.cfm?tab=2&tipo=#LvarSAporEmpleadoSQL#"--->
	<!---document.getElementById("formDet").submit();--->
}

	</script>
<script>
	!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
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
