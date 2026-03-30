<!---GENERALES--->
<!---<cf_dump var="#form#">--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Itinerario" default = "Itinerario" returnvariable="BTN_Itinerario" 
xmlfile = "solicitudesAnticipoDet_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CuentaFinanciera" default = "Cuenta Financiera" returnvariable="LB_CuentaFinanciera" 
xmlfile = "solicitudesAnticipoDet_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoSolicitado" default = "Monto Solicitado" returnvariable="LB_MontoSolicitado" 
xmlfile = "solicitudesAnticipoDet_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Concepto" default = "Concepto" returnvariable="LB_Concepto" 
xmlfile = "solicitudesAnticipoDet_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Anticipo" default = "Anticipo" returnvariable="LB_Anticipo" 
xmlfile = "solicitudesAnticipoDet_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ListaConceptosGastos" default = "Lista de Conceptos de Gastos" 
returnvariable="LB_ListaConceptosGastos" xmlfile = "solicitudesAnticipoDet_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Plantilla" default = "Template" 
returnvariable="LB_Plantilla" xmlfile = "solicitudesAnticipoDet_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Viatico" default = "Viatico" 
returnvariable="LB_Viatico" xmlfile = "solicitudesAnticipoDet_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Inicio" default = "Inicio" 
returnvariable="LB_Inicio" xmlfile = "solicitudesAnticipoDet_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_PlanCompras" default = "Plan de Compras" 
returnvariable="BTN_PlanCompras" xmlfile = "solicitudesAnticipoDet_form.xml"/>

<cfset btnNamePlanCompras="PlanCompras">
<cfset btnValuePlanCompras= "Plan de Compras">

<cfif isdefined('url.mensaje')>
	<script language="javascript">
		alert("El GECcomplemento que contiene ese concepto no concuerda con ninguna cuenta financiera");
	</script>
</cfif>

<cfif isdefined('url.GEAid') and not isdefined('form.GEAid')>
	<cfparam name="form.GEAid" default="#url.GEAid#">
</cfif>


<cfif isdefined('url.GEADid') and not isdefined('form.GEADid')>
	<cfparam name="form.GEADid" default="#url.GEADid#">
</cfif>

<cfif isdefined('form.GEADid') and len(trim(form.GEADid))>
	<cfset modoDep = 'CAMBIO'>
<cfelse>
	<cfset modoDep = 'ALTA'>
</cfif>

<!---Formulado por en parametros generales--->
<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarParametroPlanCom=1> <!---1 equivale a plan de compras en parametros generales--->

<!--- Tipo Gasto--->
<cfquery datasource="#Session.DSN#" name="rsID_tipo_gasto">
	select 
		GETdescripcion,
		GETid
	from GEtipoGasto
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cfif modoDep NEQ 'ALTA'>
<!---PRINCIPAL--->
		<cfquery datasource="#session.dsn#" name="rsFormAntD">
			select
				GEAid,
				CFcuenta,
				GEADmonto,
				GECid,
				GEPVid,
				GEADtipocambio,
				GEADmontoviatico,
				McodigoPlantilla
				<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>
					,PCGDid
				</cfif>
                ,FPAEid
            	,CFComplemento
			from GEanticipoDet
			where GEADid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEADid#">
		</cfquery>
<cfif isdefined ('form.Concepto')>
	<cfquery datasource="#session.dsn#" name="rsTipo">
		select GETid 
		from  
		GEconceptoGasto 
		where GECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Concepto#">
	</cfquery>
<cfelse>
<cfquery datasource="#session.dsn#" name="rsTipo">
		select GETid 
		from  
		GEconceptoGasto 
		where GECid=(select GECid from GEanticipoDet where GEADid=#form.GEADid#)
	</cfquery>
	</cfif>
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
	<cfif modoDep eq "ALTA">
	and c.GETid= (
						select 
							min(GETid)
						from GEtipoGasto
						where Ecodigo = #session.Ecodigo#
						)
		<cfif modo neq "ALTA">
		and (
			select count(1)
			  from GEanticipoDet
			 where GEAid = #form.GEAid#
			   and GECid = c.GECid
			) = 0
		</cfif>				 
	<cfelse>
		and c.GETid = #rsTipo.GETid#
	</cfif>				 
</cfquery>

<!---QUERYS PARA EL CAMBIO Y PARA LA CUENTA FINANCIERA--->
<cf_dbfunction name="to_char" args="ant.GEAnumero" returnvariable="LvarNumero">
<cf_dbfunction name="to_char_currency" args="ant.GEAtotalOri" returnvariable="LvarMonto">
<cfquery datasource="#session.dsn#" name="listaDetAnt">
		select
			a.GEAid,
			ant.GECid,
			<cf_dbfunction name="concat" args="'#LB_Anticipo# ';#PreserveSingleQuotes(LvarNumero)#;': ';m.Miso4217;' ';#PreserveSingleQuotes(LvarMonto)#" delimiters=";"> as Anticipo,
			a.GEADid,
			a.GECid  as Concepto,
			a.CFcuenta, f.CFformato,
			a.GEADmonto,
			a.GEPVid,
			a.GEADfechaini,
			a.GEADfechafin,
			b.GECdescripcion,
			gep.GEPVdescripcion,
			gep.GECVid,
			gec.GECVdescripcion
		from GEanticipoDet a
			inner join GEanticipo ant
				inner join Monedas m on m.Mcodigo = ant.Mcodigo
				on ant.GEAid = a.GEAid
			inner join CFinanciera f
				on f.CFcuenta = a.CFcuenta
			inner join GEconceptoGasto b
				on b.GECid=a.GECid	
			left outer join GEPlantillaViaticos gep
				on a.GEPVid=gep.GEPVid     		
			left outer join GEClasificacionViaticos gec
				on gep.GECVid=gec.GECVid    	
	<cfif LvarSAporComision>
		where ant.GECid=#form.GECid_comision#
		  and ant.GEAestado = 0 
		order by a.GEAid
	<cfelse>
		where a.GEAid=#form.GEAid#
	</cfif>
</cfquery>


<cfquery name="rsTipoCambio" datasource="#session.dsn#">
	select distinct  GEADtipocambio, McodigoPlantilla
    from GEanticipoDet a
			inner join GEanticipo ant
				on ant.GEAid = a.GEAid
	<cfif LvarSAporComision>
		where ant.GECid=#form.GECid_comision#
	<cfelse>
		where a.GEAid=#form.GEAid#
	</cfif>
	and  a.GEADtipocambio<>1
</cfquery>
	
<script language="javascript" type="text/javascript">
<!-- 
//Browser Support Code
function ajaxFunction1_ComboConceptoDet(){
	var ajaxRequest1;  // The variable that makes Ajax possible!
	var vID_tipo_gasto1 ='';
	var vmodoD1 ='';
	vID_tipo_gasto1 = document.formAntD.Tipo1.value;
	vmodoD1 = document.formAntD.modoDep.value;
	try{
		// Opera 8.0+, Firefox, Safari
		ajaxRequest1 = new XMLHttpRequest();
	} catch (e){
		// Internet Explorer Browsers
		try{
			ajaxRequest1 = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try{
				ajaxRequest1 = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e){
				// Something went wrong
				alert("Your browser broke!");
				return false;
			}
		}
	}

	<cfif  modo NEQ 'ALTA'>
		<cfset LvarGEAid = "GEAid=#form.GEAid#&">
	<cfelse>
		<cfset LvarGEAid = "">
	</cfif>
	<cfoutput>
	ajaxRequest1.open("GET", '/cfmx/sif/tesoreria/GestionEmpleados/ComboConcepto.cfm?#LvarGEAid#GETid='+vID_tipo_gasto1+'&modoD='+vmodoD1, false);
	</cfoutput>
	ajaxRequest1.send(null);
	document.getElementById("contenedor_Concepto1").innerHTML = ajaxRequest1.responseText;
}

<!---function ajaxFunction1_ComboConceptoDet(GECid){
	var ajaxRequest1;  // The variable that makes Ajax possible!
	var vID_tipo_gasto1 ='';
	var vmodoD1 ='';
	vID_tipo_gasto1 = document.formAntD.Tipo1.value;
	vmodoD1 = document.formAntD.modoDep.value;
	try{
		// Opera 8.0+, Firefox, Safari
		ajaxRequest1 = new XMLHttpRequest();
	} catch (e){
		// Internet Explorer Browsers
		try{
			ajaxRequest1 = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try{
				ajaxRequest1 = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e){
				// Something went wrong
				alert("Your browser broke!");
				return false;
			}
		}
	}
	
	<cfif  modo NEQ 'ALTA'>
		<cfset LvarGEAid = "GEAid=#form.GEAid#&">
	<cfelse>
		<cfset LvarGEAid = "">
	</cfif>
	<cfoutput>
	ajaxRequest1.open("GET", '/cfmx/sif/tesoreria/GestionEmpleados/ComboConcepto.cfm?#LvarGEAid#GETid='+vID_tipo_gasto1+'&GECid='+GECid+'&modoD='+vmodoD1, false);
	</cfoutput>
	ajaxRequest1.send(null);
	document.getElementById("contenedor_Concepto1").innerHTML = ajaxRequest1.responseText;
}
--->
 function LimpiaConcepto()
		 {
			 document.formAntD.GECdescripcion.value= '';    
			 document.formAntD.Concepto.value= '';    
		 }

//funcion que asigna los valores que vienen cuando se escoje el popup de plan de compras
	function fnAsignarValores(GETid,GECid,cuenta,LvarPCGDid,monto){
		document.formAntD.CFcuenta.value = cuenta;
		document.formAntD.PCGDid.value = LvarPCGDid;
		document.formAntD.Tipo1.value = GETid;
		document.formAntD.ConceptoGasto.value = GECid;
		document.formAntD.MontoDet.value = monto;
		
		ajaxFunction1_ComboConceptoDet(GECid);
		//para q me refresque el campo del monto calculado
		calcularMonto();
	}
	
//-->
</script>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td valign="top" width="50%">
<table width="100%" align="left" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="2"><hr></td>						
		</tr><tr>
			<td align="left" valign="top" width="80%">
			<cfset LvarNavegacion="">
			<cfif LvarSAporComision>
				<cfset LvarNavegacion="&GECid=#form.GECid_comision#">
				<cfset LvarCortes = "Anticipo">
				<cfset LvarDesplegar = "CFformato,GEADmonto,GECdescripcion">
				<cfset LvarEtiquetas = "#LB_CuentaFinanciera#, #LB_MontoSolicitado#, #LB_Concepto#">
			<cfelse>
				<cfset LvarCortes = "">
				<cfset LvarDesplegar = "CFformato,GEADmonto,GECdescripcion,GEPVdescripcion,GECVdescripcion,GEADfechaini,GEADfechafin">
				<cfset LvarEtiquetas = "#LB_CuentaFinanciera#, #LB_MontoSolicitado#,#LB_Concepto#, #LB_Plantilla#, #LB_Viatico#, #LB_Inicio#, Final">
			</cfif>
			<cfif isdefined("form.GEAid")>
				<cfset LvarNavegacion=LvarNavegacion & "&GEAid=#form.GEAid#">
			</cfif>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
					query="#listaDetAnt#"
					Cortes="#LvarCortes#"
					desplegar="#LvarDesplegar#"
					etiquetas="#LvarEtiquetas#"
					formatos="S,M,S,S,S,D,D"
					align="left,right,left,left,left,left,left"
					ira="#LvarSAporEmpleadoCFM#"
					showEmptyListMsg="yes"
					keys="GEADid"
					maxRows="20"
					formName="formAntDLista"
					PageIndex="1"
					navegacion="#LvarNavegacion#"
					checkboxes="Y" />
			</td>
			<td align="left" valign="top" width="20%"></td></tr>
	</table>
	</td>
	


<td valign="top" width="50%">
<cfif modo EQ "ALTA">
</td></tr></table>
<cfreturn>
</cfif>
<cfoutput>
	<form action="solicitudesAnticipo_sql.cfm?tipo=#LvarSAporEmpleadoSQL#" onsubmit="return validaDet(this);" method="post" name="formAntD" id="formAntD">
	<input type="hidden" name="modoDep" id="modoDep"  value="#modoDep#" />
	<input type="hidden" name="GEAid" id="GEAid" value="<cfif isdefined('form.GEAid')>#form.GEAid#</cfif>"/>
	<input type="hidden" name="GEADid" id="GEADid" value="<cfif isdefined('form.GEADid')>#form.GEADid#</cfif>"/>
	<input type="hidden" name="CFid" id="CFid" value="<cfif isdefined('LvarCFid')>#LvarCFid#</cfif>"/>
	<input type="hidden" name="tcDeConversion" id="tcDeConversion" value=""/>
	<!---CFcuenta y ConceptoGasto se usa cuando es por plan de compras y se le da valor con el pop up--->
	<input type="hidden" name="CFcuenta" id="CFcuenta" value="<cfif isdefined('rsFormAntD.CFcuenta')>#rsFormAntD.CFcuenta#</cfif>">
	<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>
		<input type="hidden" name="ConceptoGasto" id="ConceptoGasto" value="">
		<input type="hidden" name="PCGDid" id="PCGDid" value="">
	</cfif>

	
<table width="100%" align="right" cellpadding="0" border="0">
		<tr>
			<td colspan="2" valign="top"><hr></td>						
		</tr>
		<!--- Tipo Gasto--->
		<tr>
			<td nowrap="nowrap" align="right"  valign="top"><strong><cf_translate key=LB_TipoGasto>Tipo Gasto</cf_translate>:&nbsp; </strong> </td>
			<td>
				<select name="Tipo1" onchange="LimpiaConcepto();" <cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>disabled="disabled"</cfif> <cfif modoDep neq "ALTA">disabled="disabled"</cfif> >  
					<cfif rsID_tipo_gasto.RecordCount>
						<cfloop query="rsID_tipo_gasto">
							<option value="#rsID_tipo_gasto.GETid#"<cfif modoDep neq "ALTA" and rsID_tipo_gasto.GETid  eq rsTipo.GETid>selected="selected"</cfif>>#rsID_tipo_gasto.GETdescripcion#</option>
						</cfloop>
					</cfif>
				</select>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
<!---Concepto_gasto--->
			<tr>
				<td nowrap="nowrap" align="right"><strong><cf_translate key=LB_ConceptoGasto>Concepto de Gasto</cf_translate>:</strong> </td>
				<td colspan="8" nowrap="nowrap" align="left">
					 <cfset valuesArrayCG = ArrayNew(1)>
                     <cfset LvarModificable = false>
					 <cfif isdefined("rsFormAntD.GECid") and len(trim(rsFormAntD.GECid))>
						<cfquery datasource="#Session.DSN#" name="rsCG">
							select 
                            GECid,							
							GECdescripcion
							from GEconceptoGasto			
							where GECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormAntD.GECid#">
						</cfquery>	                       			
						<cfset ArrayAppend(valuesArrayCG, rsCG.GECid)>
						<cfset ArrayAppend(valuesArrayCG, rsCG.GECdescripcion)>
						<cfset LvarModificable = true>
                      </cfif>                      
					 	<cfparam name="LvarAnticipo" default="#form.GEAid#" type="numeric">
                 	<div id="contenedor_Concepto">
						 <cf_conlis      
                                campos = "Concepto,GECdescripcion"
                                desplegables = "N,S"
                                modificables = "N,N"
                                size = "4,20"
                                valuesArray="#valuesArrayCG#"
                                title="#LB_ListaConceptosGastos#"
                                tabla="GEconceptoGasto c
                                         inner join GEtipoGasto t
                                       on  c.GETid = t.GETid"                                       
                                columnas=" c.GECdescripcion,
                                           c.GECid as Concepto,
                                           c.GETid,
                                           c.GECcomplemento"               
                                filtro="Ecodigo = #session.Ecodigo#
                                        and c.GETid = $Tipo1,numeric$
										and (
											select count(1)
											  from GEanticipoDet
											 where GEAid=#LvarAnticipo#
											   and GECid = c.GECid
											) = 0
										"                                                           
                                desplegar="GECdescripcion"
                                etiquetas=""
                                formatos="S"
                                readonly="#LvarModificable#"
                                align="left,left"
                                form="formAntD"
                                asignar="Concepto,GECdescripcion"
                                showEmptyListMsg="true"
                                EmptyListMsg="-- No existen Conceptos --"
                                tabindex="3"
                                top="100"
                                left="400"
                                width="600"
                                height="500"
                                asignarformatos="S"> 
                      </div>
				</td>
			</tr>
        <!--- Actividad Empresarial --->
		<cfquery name="rsActividad" datasource="#session.DSN#">
			Select Coalesce(Pvalor,'N') as Pvalor 
			  from Parametros 
			 where Pcodigo = 2200 
			   and Mcodigo = 'CG'
			   and Ecodigo = #session.Ecodigo# 
		</cfquery>
		<cfif rsActividad.Pvalor eq 'S'<!--- and rsFormularPor.Pvalor eq 0--->>
			<cfset idActividad = "">
			<cfset valores = "">
			<cfset lvarReadonly = false>
			<cfif modoDep NEQ "ALTA">
				<cfset idActividad = rsFormAntD.FPAEid>
				<cfset valores = rsFormAntD.CFComplemento>
				<cfset lvarReadonly = true>
			</cfif>
			<tr>
			<td valign="top" align="right"><strong>Actividad Empresarial:&nbsp;</strong></td>
			<td valign="top"><cf_ActividadEmpresa etiqueta="" idActividad="#idActividad#" valores="#valores#" name="CFComplemento" nameId="FPAEid" formname="formAntD" Readonly="#lvarReadonly#"></td>
			</tr>
		</cfif>	

	<!---Moneda--->
			<tr>
				<td valign="top" align="right"><strong><cf_translate key=LB_MonedaDetalle>Moneda detalle</cf_translate>:&nbsp;</strong></td>
				<td valign="top">
					<cfif  modoDep NEQ 'ALTA'>
						<cfquery name="rsMoneda" datasource="#session.DSN#">
							select 
									Mcodigo
									, Mnombre
							from Monedas 
							where Ecodigo=#session.Ecodigo#
							and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormAntD.McodigoPlantilla#">
						</cfquery>
						
						<cfset LvarMnombreSP = rsMoneda.Mnombre>
						
						<cfif rsForm.GEAtotalOri GT 0>
							<cf_sifmonedas onChange="asignaTCdet();calcularMonto();"  form="formAntD"  Mcodigo="McodigoOriD" query="#rsMoneda#" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="2" habilita="S">
						<cfelse>
							<cf_sifmonedas onChange="asignaTCdet();calcularMonto();"  form="formAntD"  Mcodigo="McodigoOriD" query="#rsMoneda#" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="2">
						</cfif>
					<cfelse>
						<cf_sifmonedas onChange="asignaTCdet();calcularMonto();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" form="formAntD"  Mcodigo="McodigoOriD"  tabindex="2" query="#rsForm#" >
					</cfif>   
				</td>
			</tr>
			
			<!---Tipo de cambio--->
			<tr>
				<td valign="top" align="right"><strong><cf_translate key=LB_TipoCambio>Tipo de Cambio</cf_translate>:&nbsp;</strong></td>
				<td valign="top">
					<input name="GEAmanualDet" 
						id="GEAmanualDet"
						size="17"
						maxlength="10" readonly="true"
						value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsForm.GEAmanual,",0.0000")#</cfif>"
						style="text-align:right;" 
						onfocus="this.value=qf(this); this.select();" 
						tabindex="1" />
				</td>
			</tr>	
				   
<!---MONTO detalle--->
		<tr>
			<td align="right" nowrap><strong><cf_translate key=LB_MontoDetalle>Monto detalle</cf_translate>:&nbsp; </strong></td>
			<cfset valor_monto = 0 >
				<cfif modoDep neq 'ALTA'>
					<cfset valor_monto = LSNumberFormat(abs(rsFormAntD.GEADmontoviatico),"0.00") >
					<td><cf_inputNumber name="MontoDet" value="#valor_monto#" size="17" enteros="13" decimales="2"  onChange="calcularMonto();"></td> 
				<cfelse>
					<td><cf_inputNumber name="MontoDet" value="0.00" size="17" enteros="13" decimales="2" onChange="calcularMonto();"></td>
				</cfif>
		</tr>
<!---MONTO calculado encabezado--->
		<tr>
			<td align="right" nowrap><strong><cf_translate key=LB_MontoAnticipo>Monto Anticipo</cf_translate>:&nbsp; </strong></td>
			<cfset valor_montoCalculado = 0 >
				<cfif modoDep neq 'ALTA'>
					<cfset valor_montoCalculado = LSNumberFormat(abs(rsFormAntD.GEADmonto),"0.00") >
					<td><cf_inputNumber name="MontoDetCalculado" value="#valor_montoCalculado#" size="17" enteros="13" decimales="2"   readonly="true"> #rsForm.Miso4217#s</td>
				<cfelse>
					<td><cf_inputNumber name="MontoDetCalculado" value="0.00" size="17" enteros="13" decimales="2" readonly="true"> #rsForm.Miso4217#s</td>
				</cfif>
		</tr>	
<!--- BOTONES--->			
		<tr>
			<td colspan="4" class="formButtons">
				<cf_botones sufijo='Det' modo='#modoDep#' tabindex="2" exclude="">		
			</td>
		</tr>
		<cfif rsUsaPlanCuentas.Pvalor neq LvarParametroPlanCom>
			<tr><td>&nbsp;</td></tr>
		<cfelse>
			<tr>
				<td colspan="2" align="center">
					<cfoutput><input type="button"  name="btnPlan"  value="#BTN_PlanCompras#" tabindex="1" onClick="PlanCompras()" ></cfoutput>
					<input type="hidden"  name="LvarParametroPlanCom"  value="">
				</td>
			</tr>
		</cfif>	
		<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom and modoDep neq 'ALTA'>
				<cfquery name="rsPCGDid" datasource="#session.dsn#">
					select PCGDid from GEanticipoDet 
						where GEADid=#form.GEADid#
				</cfquery>
				<cfquery name="rsMontoOriginal" datasource="#session.dsn#">
					select PCGDautorizado from PCGDplanCompras 
						where PCGDid=#rsPCGDid.PCGDid#
				</cfquery>
				<input type="hidden"  name="LvarParametroPlanCom"  value="#LvarParametroPlanCom#">
				<input type="hidden"  name="MontoOriginal"  value="#rsMontoOriginal.PCGDautorizado#">
				<input type="hidden" name="PCGDid" id="PCGDid" value="#rsFormAntD.PCGDid#">
		</cfif>
	</table>
	</form>
	</td>
	</tr>
</table>
<iframe name="verifica_Concepto" id="verifC" marginheight="0" marginwidth="0" frameborder="" height="0" width="0" scrolling="auto"></iframe>

</cfoutput>
<script language="javascript">
	function verificaConcep(id){
		var uno= document.formAntD.Concepto.value
		var tc=document.form1.GEAmanual.value
		document.getElementById('verifC').src = 'verificaConcepto.cfm?Concepto='+uno+'&monto='+id+'&dir='+2+'&tc='+tc+'';
	}
</script>
<script type="text/javascript">
	function validaDet(formulario)	{
		formulario.MontoDet.value = qf(formulario.MontoDet);	
		formulario.MontoDetCalculado.value = qf(formulario.MontoDetCalculado);

		if (!btnSelectedDet('NuevoDet',document.formDet) && !btnSelectedDet('BajaDet',document.formDet))
		{
			var error_input = null;;
			var error_msg = '';
			
			if (formulario.Concepto.value == "") 
			{
				error_msg += "\n - El concepto no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.Concepto;
			}	
			if (formulario.MontoDet.value == "") 
			{
				error_msg += "\n - El Monto no puede quedar en blanco.";
				if (error_input == null) error_input = formulario.MontoDet;
			}		
			
			else if (parseFloat(formulario.MontoDet.value) <= 0)
			{
				error_msg += "\n - El monto solicitado debe ser mayor que cero.";
				if (error_input == null) error_input = formulario.MontoDet;
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
		formulario.Concepto.disabled = false;
		formulario.GEAmanualDet.disabled = false;
return true;
	}
	
function PlanCompras(){
	var Lvartipo = 'S';
	var LvarCFid = document.form1.CFid.value;
	var LvarGEAid=document.form1.GEAid.value;
	var LvarfechaPago=document.form1.GEAfechaPagar.value
		
	if((Lvartipo != '') && (LvarCFid != '')&& (LvarGEAid != ''))
	{
		window.open('popUp-planDeCompras.cfm?tipo='+Lvartipo+'&GEAid='+LvarGEAid+'&fechaPago='+LvarfechaPago+'&CFid='+LvarCFid,'popup','width=1000,height=500,left=200,top=50,scrollbars=yes');
	}
	else
	{
	 alert("Falta el Tipo en el detalle o el Id del Centro Funcional ");
	}  
}
	//asigna el tc del detalle cuando cambio la moneda
	function asignaTCdet() {	
		if (document.formAntD.McodigoOriD.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {		
			document.formAntD.GEAmanualDet.value='1.0000';		
			document.formAntD.GEAmanualDet.disabled = true;
		}
		else if (document.formAntD.McodigoOriD.value == "<cfoutput>#rsForm.Mcodigo#</cfoutput>") {		
			<cfoutput>
			document.formAntD.GEAmanualDet.value='#numberFormat(rsForm.GEAmanual,",9.0000")#';		
			</cfoutput>
			document.formAntD.GEAmanualDet.disabled = true;
		}
		else
		{
			document.formAntD.GEAmanualDet.value = fm(document.formAntD.TC.value,4);<!---Asigna TC--->
			document.formAntD.GEAmanualDet.disabled = false;
			document.formAntD.GEAmanualDet.readOnly = false;
	
			<cfwddx action="cfml2js" input="#rsTipoCambio#" topLevelVariable="TCambio"> 
			//Verificar si existe en el recordset
			var nRows = TCambio.getRowCount();
			if(nRows > 0){
				for(row = 0; row < nRows; ++row){
					if (TCambio.getField(row, "McodigoPlantilla") == document.formAntD.McodigoOriD.value){
						document.formAntD.GEAmanualDet.value = fm(TCambio.getField(row, "GEADtipocambio"),4);
						break;				
					}
				}
			}
		}
	}
	document.formAntD.GEAmanualDet.value='1.0000';					
	//esta funcion es la q genera el tag sifmonedas. y me carga el tipo de cambio sin el onchange
	validatcMcodigoOriD();
	asignaTCdet();
	
	// calcula en monto en la moneda del encabezado	
	function calcularMonto(){
		//guarda el tipo de cambio entre las monedas y a la vez lo guarda en base de datos por si se utiliza mas adelante
		var TCdet	= parseFloat(qf(document.formAntD.GEAmanualDet.value));
		var TCenc	= parseFloat(qf(document.form1.GEAmanual.value));
		var tcDeConversion=1;
		var MtoDet	= parseFloat(qf(document.formAntD.MontoDet.value));

		if (TCdet == TCenc) 
		{
			document.formAntD.tcDeConversion.value	 = "1";
			document.formAntD.MontoDetCalculado.value= fm(document.formAntD.MontoDet.value,2);
		}
		else
		{
			tcDeConversion = TCdet / TCenc;
			document.formAntD.tcDeConversion.value	 = tcDeConversion;
			document.formAntD.MontoDetCalculado.value= Math.round(MtoDet * tcDeConversion * 100.0)/100.0;
			document.formAntD.MontoDetCalculado.value= fm(document.formAntD.MontoDetCalculado.value,2);
		}
	}
	
	


</script>
