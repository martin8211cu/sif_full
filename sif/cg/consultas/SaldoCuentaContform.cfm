<cfinvoke key="BTN_Agregar" 			default="Agregar" 			returnvariable="BTN_Agregar" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="BTN_Limpiar" 			default="Limpiar" 			returnvariable="BTN_Limpiar" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="BTN_Procesar" 			default="Procesar" 			returnvariable="BTN_Procesar" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_Empresa" 			default="Empresa" 			returnvariable="LB_Empresa" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_Oficina" 			default="Oficina" 			returnvariable="LB_Oficina" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_MesIni" 			default="Mes Inicial" 			returnvariable="LB_MesIni" 				component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>
<cfinvoke key="LB_MesFin" 			default="Mes Final" 			returnvariable="LB_MesFin" 				component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>
<cfinvoke key="LB_ConsultaSaldos" default="Consulta de los saldos contables para una cuenta" 
returnvariable="LB_ConsultaSaldos" component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>
<cfinvoke key="LB_ConsultaRangoCuentas" default="Consulta de los saldos contables para un rango de cuentas" 
returnvariable="LB_ConsultaRangoCuentas" component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>
<cfinvoke key="LB_ConsultaListaCuentas" default="Consulta de los saldos contables para una lista de cuentas" 
returnvariable="LB_ConsultaListaCuentas" component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>

<cfinvoke key="Msg_CmpCtaContReq" default="- El campo cuenta contable  es requerido.\n" 
returnvariable="Msg_CmpCtaContReq" component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>
<cfinvoke key="Msg_CtaIniyFin" default="- Para este tipo de reporte es necesario tener una cuenta inicial y otro final.\n" 
returnvariable="Msg_CtaIniyFin" component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>
<cfinvoke key="Msg_CtaAgregada" default="- Para este tipo de reporte es necesario tener al menos una cuenta agregada.\n" 
returnvariable="Msg_CtaAgregada" component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>
<cfinvoke key="Msg_CmpIniReq" default="- El campo mes inicial  es requerido.\n" 
returnvariable="Msg_CmpIniReq" component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>
<cfinvoke key="Msg_CmpFinReq" default="- El campo mes final es requerido.\n" 
returnvariable="Msg_CmpFinReq" component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>
<cfinvoke key="Msg_SigErrores" default="Se presentaron los siguientes errores:\n" 
returnvariable="Msg_SigErrores" component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>

<cfif  isDefined("url.Archivo")>
	<cfset Form.Archivo = url.Archivo>
</cfif>
<cfif not isDefined("Form.Archivo")>
	<cfset Form.Archivo = 'N'>
</cfif>

<cfquery name="rsAno" datasource="#Session.DSN#">
	SELECT distinct Speriodo 
	FROM CGPeriodosProcesados
	where Ecodigo = #Session.Ecodigo#
	order by Speriodo desc	
</cfquery>

<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Oficodigo, Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo = #session.Ecodigo#
	order by Oficodigo, Odescripcion
</cfquery>
<cfquery name="rsGE" datasource="#session.DSN#">
	select ge.GEid, ge.GEnombre
	from AnexoGEmpresa ge
		join AnexoGEmpresaDet gd
			on ge.GEid = gd.GEid
	where ge.CEcodigo = #session.CEcodigo#
	  and gd.Ecodigo = #session.Ecodigo#
	order by ge.GEnombre
</cfquery>
<cfquery name="rsGO" datasource="#session.DSN#">
	select GOid, GOnombre
	from AnexoGOficina
	where Ecodigo = #session.Ecodigo#
	order by GOnombre
</cfquery>

<cfquery name="rsMes" datasource="#Session.DSN#">
	select a.Speriodo, a.Smes, b.VSdesc as SmesDes
	from CGPeriodosProcesados a
		inner join VSidioma b on
			<cf_dbfunction name='to_char' args='a.Smes'> = b.VSvalor
		inner join Idiomas c on
			b.Iid = c.Iid
	where a.Ecodigo = #session.Ecodigo#
		and c.Icodigo = '#Session.Idioma#'
		and b.VSgrupo = 1
	order by a.Speriodo, a.Smes
</cfquery>

<cfset VCEcodigo = #Session.CEcodigo#>

<cfquery name="rsNiveles" datasource="#Session.DSN#">
select Max(A.PCNid) as Nmax
from PCNivelMascara A, PCEMascaras B
where A.PCEMid = B.PCEMid
  and B.CEcodigo = #VCEcodigo#
</cfquery>

<cfset VNmax = rsNiveles.Nmax>
<cfif VNmax LT 3 or len(trim(rsNiveles.Nmax)) EQ 0>
	<cfset VNmax = 6>
</cfif>

<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select  a.Cconcepto, Cdescripcion
	from ConceptoContableE a
	where a.Ecodigo = #Session.Ecodigo#
	  and   not exists ( select 1 
			     from UsuarioConceptoContableE b 
			     where a.Ecodigo = #Session.Ecodigo#
	  and   a.Cconcepto = b.Cconcepto
	  and   a.Ecodigo   = b.Ecodigo)
	UNION
	select a.Cconcepto, Cdescripcion 
	from ConceptoContableE a,UsuarioConceptoContableE b
	where a.Ecodigo   = #Session.Ecodigo#
	  and a.Cconcepto = b.Cconcepto
	  and a.Ecodigo   = b.Ecodigo
	  and Usucodigo   = #session.CEcodigo#	
       Order by 1
</cfquery>


<cfset H_ACTUAL = Hour(Now())>
<cfset T_ACTUAL = "AM">
<cfif H_ACTUAL gt 12>
	<cfset H_ACTUAL = H_ACTUAL - 12>
	<cfset T_ACTUAL = "PM">
</cfif>
<cfset M_ACTUAL = Minute(Now())>

<cfoutput>
<form method="post" action="GenerarReporte.cfm" name="form1"  onSubmit="return validar();"  style="MARGIN:0;">
	
	<table width="100%" border="0" cellspacing="2" cellpadding="2" >
		<tr>
			<td align="center" colspan="4" nowrap bgcolor="##CCCCCC"><strong><cf_translate key=LB_TipoReporte>Tipo de Reporte</cf_translate></strong></td>
		</tr>	

		<tr>
			<td width="14%"><strong><cf_translate key=LB_TipoReporte>Tipo de Reporte</cf_translate> :</strong></td>
			<td  colspan="3">
				<select name="ID_REPORTE" tabindex="1" onchange="javascript:  MostrarBoton()">
					<option value="1"><cf_translate key=LB_UnaCuenta>Una Cuenta Contables</cf_translate></option>
					<option value="2"><cf_translate key=LB_RangoCuenta>Un Rango de Cuentas Contables</cf_translate></option>
					<option value="3"><cf_translate key=LB_ListaCuenta>Una Lista de Cuentas Contables</cf_translate></option>
				</select>
			</td>
		</tr>
		<tr id="ID_PROG">
		<td><strong><cf_translate key=LB_HoraEjecucion>Hora de ejecuci&oacute;n</cf_translate>:</strong></td>
		<td>
		<select id="HORA" name="HORA" tabindex="1">
		<cfloop from="1" to="12" index="H">
		<cfif H LT 10>
		<option value="#H#" <cfif H EQ H_ACTUAL>selected</cfif>>0#H#</option>
		<cfelse>	
		<option value="#H#" <cfif H EQ H_ACTUAL>selected</cfif>>#H#</option>
		</cfif>
		</cfloop>
		</select>
		
		<select id="MINUTOS"  name="MINUTOS" tabindex="1">
		<cfloop from="0" to="59" index="M">
		<cfif M LT 10>
		<option value="#M#" <cfif M EQ M_ACTUAL>selected</cfif>>0#M#</option>
		<cfelse>	
		<option value="#M#" <cfif M EQ M_ACTUAL>selected</cfif>>#M#</option>
		</cfif>
		</cfloop>
		</select>
		
		<select  id="PMAM" name="PMAM" tabindex="1">
		<option value="AM" <cfif "AM" EQ T_ACTUAL>selected</cfif>>AM</option>
		<option value="PM" <cfif "PM" EQ T_ACTUAL>selected</cfif>>PM</option>
		</select>
		</td>
		
		</tr>		
		<tr>
			<td></td>
			<td colspan="3">
				<INPUT 	TYPE="textbox" 
					NAME="AYUDA" 
					VALUE="" 
					SIZE="100" 
					readonly="yes"
					tabindex="-1"
					style=" font-size:12;  border: medium none; text-align:left; size:auto;"
				>		
			</td>
		</tr>
		
		<tr>
			<td align="center" colspan="4" nowrap bgcolor="##CCCCCC"><strong><cf_translate key=LB_CuentaContable>Cuenta Contable</cf_translate></strong></td>
		</tr>
		<tr>
			<td  colspan="4"  nowrap="nowrap">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" >
					<tr>
					<td width="14%"  ><strong><cf_translate key=LB_CuentaContable>Cuenta Contable</cf_translate>:</strong></td>

					<td width="3%">
						<input type="text" name="Cmayor" maxlength="4" size="4" 
						onBlur=	"javascript:CargarCajas(this.value)" value="" tabindex="1">				
					</td>	
					<td width="48%">	
						<iframe marginheight="0"
						marginwidth="0" 
						scrolling="no" 
						name="cuentasIframe" 
						id="cuentasIframe" 
						width="100%" 
						height="20"
						frameborder="0"></iframe>
					</td>	
					<td width="35%" >						
						<input 	type="button"  
								id="AGRE" 
								name="AGRE"
								value="#BTN_Agregar#"
								tabindex="1"
								onClick="javascript:if (window.fnNuevaCuentaContable) fnNuevaCuentaContable();" 
						style="display:none">
					</td>
					</tr>
				</table>
				<BR>
				<table width="50%" align="center" id="tblcuenta" cellpadding="0" cellspacing="0" border="0" >
					<tr><td></td></tr>
				</table>
			</td>

		</tr>
		<tr>
			<td align="center" colspan="4" nowrap bgcolor="##CCCCCC"><strong><cf_translate key=LB_CriteriosFiltro>Criterios para Filtrar</cf_translate></strong></td>
		</tr>			
		<tr>
			<td><strong><cf_translate key=LB_NivelDetalle>Nivel Detalle</cf_translate>:</strong></td>
			<td width="24%">
				<select name="nivelDet" size="1" id="nivel" tabindex="1">
				  <cfloop index="i" from="0" to="#VNmax#">
					<option value="#i#">#i#</option>
				  </cfloop>
				</select>			
			</td>

			<cfif Form.Archivo eq 'N'>

				<td width="14%"><strong><cf_translate key=LB_NivelTotal>Nivel Total</cf_translate>:</strong></td>
				<td width="48%" >
					<select name="nivelTot" size="1" id="nivel" tabindex="1">
					  <cfloop index="i" from="0" to="#VNmax#">
					  	<option value="#i#">#i#</option>
					  </cfloop>
					</select>				  
				</td>	
			<cfelse>
				<td colspan="2"><input type="hidden" name="nivelTot" value="0">&nbsp;</td>
			</cfif>

		</tr>
		<tr>
			<td><strong><cf_translate key=LB_OficinaEmpresa>Oficina/Empresa</cf_translate>:</strong></td>
			<td>
				<select name="ubicacion" style="width:200px" tabindex="1">
					<optgroup label="#LB_Empresa#">
					<option value="" <cfif isdefined("form.ubicacion") and  Len(form.ubicacion) EQ 0> selected</cfif>> #HTMLEditFormat(session.Enombre)#</option>
					</optgroup>
					<cfif rsGE.RecordCount>
					  <optgroup label="Grupo de Empresas">
					  <cfloop query="rsGE">
						<option value="ge,#rsGE.GEid#" <cfif isdefined("form.ubicacion") and form.ubicacion eq 'ge,' & rsGE.GEid>selected</cfif> > #HTMLEditFormat(rsGE.GEnombre)#</option>
					  </cfloop>
					  </optgroup>
					</cfif>
					<optgroup label="#LB_Oficina#">
					<cfloop query="rsOficinas">
					  <option value="of,#rsOficinas.Ocodigo#"  <cfif isdefined("form.ubicacion") and form.ubicacion eq 'of,' & rsOficinas.Ocodigo>selected</cfif> >
						#rsOficinas.Oficodigo# - #HTMLEditFormat(rsOficinas.Odescripcion)#</option>
					</cfloop>
					</optgroup>
					<cfif rsGO.RecordCount>
					  <optgroup label="<cf_translate key=LB_GrupoOficinas>Grupo de Oficinas</cf_translate>">
					  <cfloop query="rsGO">
						<option value="go,#rsGO.GOid#"  <cfif isdefined("form.ubicacion") and form.ubicacion eq 'go,' & rsGO.GOid>selected</cfif> > #HTMLEditFormat(rsGO.GOnombre)#</option>
					  </cfloop>
					  </optgroup>
					</cfif>
				 </select>
			</td>	


			<td width="14%"><strong><cf_translate key=LB_TipoImpresion>Tipo de Impresi&oacute;n</cf_translate> :</strong></td>
			<td>
				<select name="TipoFormato"  <cfif Form.Archivo eq 'S'>onChange="ACTIVAMESES()"</cfif>tabindex="1">
					<cfif Form.Archivo eq 'N'>
						<option value="4"><cf_translate key=LB_Resumido>Resumido</cf_translate></option>
						<option value="2"><cf_translate key=LB_DetalladoMes>Detallado por Mes</cf_translate></option>
						<option value="3"><cf_translate key=LB_DetalladoAsiento>Detallado por Asiento</cf_translate></option>
						<option value="1"><cf_translate key=LB_DetalladoConsecutivo>Detallado por Consecutivo</cf_translate></option>
					<cfelse>
						<option value="1">Saldos acumulados</option>
						<option value="2">Saldos del periodo</option>
						<option value="3">Movimientos del mes</option>
						<option value="4">Movimientos asiento del mes</option>
						<option value="5">Movimientos asiento consecutivo del mes</option>					
					</cfif>	
				</select>
			</td>
		</tr>
		<tr>
			<td ><strong><cf_translate key=LB_Periodo>A&ntilde;o</cf_translate>:</strong></td>
			<td  >
				<select name="Periodos" onChange="javascript:cambiar_meses(this);" tabindex="1">
					<cfloop query="rsAno"> 
						<option value="#rsAno.Speriodo#">#rsAno.Speriodo#</option>
					</cfloop>
				</select>		
			</td>
			<td >&nbsp;</td>
			<td>&nbsp;
				
			</td>			
		</tr>		
		<tr>
			<td>
				<strong>
				<INPUT  tabindex="-1" 
					ONFOCUS="this.blur();" 
					NAME="ETQINI" 
					ID  ="ETQINI" 
					VALUE="#LB_MesIni#:" 
					size="15"  
					style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
				>	
				</strong>
			</td>
			<td>
				<select name="MesInicial" id="MesInicial" tabindex="1">
					<option value="">-- seleccionar --</option>
				</select>
			</td>
			<td>
				<strong>
				<INPUT  tabindex="-1" 
					ONFOCUS="this.blur();" 
					NAME="ETQFIN" 
					ID  ="ETQFIN" 
					VALUE="#LB_MesFin#:" 
					size="15"  
					style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
				>	
				</strong>
			</td>
			<td>
				<select name="MesFinal" id="MesFinal" tabindex="1">
					<option value="">-- seleccionar --</option>
				</select>
			</td>
		</tr>

		<cfif Form.Archivo eq 'N'>

			<tr>
				<td align="center" colspan="4" nowrap bgcolor="##CCCCCC"><strong><cf_translate key=LB_AsientoContableLista>Listas de Asientos Contables</cf_translate></strong></td>
			</tr>	

			<tr>
				<td colspan=4>
				
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width=100%>
							<strong><cf_translate key=LB_AsientoContable>Asiento Contable</cf_translate>:</strong>&nbsp;&nbsp;&nbsp;&nbsp;
							<select  name="Cconcepto" tabindex="1">
								<cfloop query="rsConceptos"> 
									<option  value="#rsConceptos.Cconcepto#">#rsConceptos.Cdescripcion#</option>
								</cfloop>
							</select>
							&nbsp;&nbsp;
		
							<input 	type="button"  
								id="AGREAST" 
								name="AGREAST" 
								value="+"
								tabindex="1"
								onClick="javascript:if (window.fnNuevoAsientoContable) fnNuevoAsientoContable();"					        
								>
						</td>
					</tr>
					</table>
					<br>
					<table width="50%" border="0" cellpadding="0" cellspacing="0" id="tblasiento">
						<tr><td></td></tr>
					</table>
				</td>
			</tr>


			<tr>
				<td colspan="4"><hr></td>
			</tr>
			<tr>
				<td colspan="4" valign="bottom">
				  <input tabindex="1" type="checkbox" name="ID_incsucursal" id="ID_incsucursal">
				  &nbsp;<label for="ID_incsucursal"><cf_translate key=LB_IncluirOficina>Incluir Oficina</cf_translate></label>
				   &nbsp;&nbsp;
				 <input tabindex="1" type="checkbox" name="ID_NoIncluir" id="ID_NoIncluir">
				&nbsp;<label for="ID_NoIncluir"><cf_translate key=LB_CuentasEnCero>No incluir cuentas con movimientos mensuales en cero</cf_translate></label>  
				&nbsp;&nbsp;
				<input tabindex="1" type="checkbox" name="chkAstCierre" id="chkAstCierre">
				&nbsp;<label for="ID_NoIncluir"><cf_translate key=LB_AsientosCierre>Incluir asientos de cierre</cf_translate></label>
				</td>
			</tr> 
		</cfif>

		<tr>  
			<td   align="center" colspan="4">
				<input type="submit" name="Reporte" value="#BTN_Procesar#" id="Procesar" onClick="" tabindex="1">
				<input type="reset" name="Limpiar"  onClick="javascript: if (window.OcultarCeldas) return OcultarCeldas();"value="#BTN_Limpiar#" tabindex="1">
				<input type="hidden"   name="LastOneCuenta" id="LastOneCuenta" value="ListaNon">
				<input type="hidden" name="LastOneAsiento" id="LastOneAsiento" value="ListaNon">
			</td>
		</tr> 
	</table>
	<input type="hidden" name="CtaFinal" value="">
	<input type="hidden" name="CuentasADD" value="0">
	<input type="hidden" name="PROGRAMADO" value="#Form.Archivo#">


</form>
<input type="image" id="imgDel"src="../../imagenes/Borrar01_S.gif"  title="Eliminar" style="display:none;" tabindex="1">

</cfoutput>
<script language="JavaScript1.2">
	/*********************************************************************************************************/
	document.form1.ID_REPORTE.focus();
	function LimpiaCajas()
	{
		//Para limpiar las cajas luego de agregar la cuenta
		CargarCajas(document.form1.AGRE.value)
	}

	/*********************************************************************************************************/
	function cambio_MESINI(obj){
		var form = obj.form;
		var combo = form.MesInicial;
		combo.length = 0;
		var i = 0;
		<cfoutput query="rsMes">
			var tmp = #rsMes.Speriodo# ;
			if ( obj.value != '' && tmp != '' && parseFloat(obj.value) == parseFloat(tmp) ) {
				combo.length++;
				combo.options[i].text = '#rsMes.SmesDes#';
				combo.options[i].value = '#rsMes.Smes#';
				i++;
			}
		</cfoutput>
	}
	/*********************************************************************************************************/
	function cambio_MESFIN(obj){
		var form = obj.form;
		var combo = form.MesFinal;
		combo.length = 0;
		var i = 0;
		<cfoutput query="rsMes">
			var tmp = #rsMes.Speriodo# ;
			if ( obj.value != '' && tmp != '' && parseFloat(obj.value) == parseFloat(tmp) ) {
				combo.length++;
				combo.options[i].text = '#rsMes.SmesDes#';
				combo.options[i].value = '#rsMes.Smes#';
				i++;
			}
		</cfoutput>
	}
	/*********************************************************************************************************/
	function cambiar_meses(obj){
		cambio_MESINI(obj);
		cambio_MESFIN(obj);
	}
	/*********************************************************************************************************/
	function CargarCajas(Cmayor) {
		if (document.form1.Cmayor.value != '') {
			var a = '0000' + document.form1.Cmayor.value;
			a = a.substr(a.length-4, 4);
			document.form1.Cmayor.value = a;
		}
		var fr = document.getElementById("cuentasIframe");
		fr.src = "/cfmx/sif/Utiles/generacajas2.cfm?Cmayor="+document.form1.Cmayor.value+"&MODO=ALTA&TipoCuenta=C"
	}
	/*********************************************************************************************************/
	function FrameFunction() {
		// RetornaCuenta2() es máscara completa, rellena con comodín
		if(window.parent.cuentasIframe.RetornaCuenta2){
			window.parent.cuentasIframe.RetornaCuenta2();
		}
	}	
	/*********************************************************************************************************/
	function doConlisReglasN1() {
		var width = 850;
		var height = 480;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var params = '?f=form1&p1=PCRref&p2=PCRref_text';
		var nuevo = window.open('/cfmx/sif/Utiles/ConlisReglasN1.cfm'+params,'Reglas','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
		if (nuevo) nuevo.focus();
	}	
	/*********************************************************************************************************/
	<cfoutput>
	function validar() {
		var errores = "";
		switch (document.form1.ID_REPORTE.value){
			case '1' :
				FrameFunction();
				var cuenta		 = document.form1.CtaFinal.value	
				var vectorcuenta = cuenta.split('-');
				var p1 = "";
				for(i=0;i < vectorcuenta.length;i++) {
					if(vectorcuenta[i].length > 0)
						p1 = p1 + vectorcuenta[i] + '-';
				}
				p1 = p1.substring(0,p1.length-1)
				
				document.form1.CtaFinal.value = p1;
	
				if (document.form1.CtaFinal.value.length == 0) {
					errores = errores + '#Msg_CmpCtaContReq#';
				}	
			break;
			case '2' :
				cantidad = new Number(document.form1.CuentasADD.value);
				if(cantidad < 2 ){
					errores = errores + '#Msg_CtaIniyFin#';
				}				
			break;
			case '3' :
				cantidad = new Number(document.form1.CuentasADD.value);
				if(cantidad < 1 ){
					errores = errores + '#Msg_CtaAgregada#';
				}				
			break;
		}

		
		if (document.form1.MesInicial.value.length == 0) {
			errores = errores + '#Msg_CmpIniReq#';
		}
		if (document.form1.MesFinal.value.length == 0) {
			errores = errores + '#Msg_CmpFinReq#';
		}
		if (errores != "") {
			alert('#Msg_SigErrores#' + errores);
			return false;
		}	
		
		document.form1.Procesar.disabled = true;
		
	}	
	</cfoutput>
	/*********************************************************************************************************/
	function Precarga() {
		cambiar_meses(document.form1.Periodos)
	}
	Precarga() ;
	/*********************************************************************************************************/
	function MostrarProg() {
		var ID_PROG = document.getElementById("ID_PROG");
        if(document.form1.PROGRAMADO.value == 'S'){
			ID_PROG.style.display = ''
		}
		else{
			ID_PROG.style.display = 'none';
		}
	}
	MostrarProg();

	/*********************************************************************************************************/
	function MostrarBoton() {
		switch (document.form1.ID_REPORTE.value){
			case '1' :
				document.form1.AYUDA.value = "<cfoutput>#LB_ConsultaSaldos#</cfoutput>";
			break;
			case '2' :
				document.form1.AYUDA.value = "<cfoutput>#LB_ConsultaRangoCuentas#</cfoutput>";
			break;
			case '3' :
				document.form1.AYUDA.value = "<cfoutput>#LB_ConsultaListaCuentas#</cfoutput>";
			break;
		}
		var AGRE = document.getElementById("AGRE");
        if(document.form1.ID_REPORTE.value != '1'){
			AGRE.style.display = ''
		}
		else{
			AGRE.style.display = 'none';
		}
	}
	MostrarBoton();

	/********************************************************************************************************/
	function fnNuevoAsientoContable() 
	{
		var LvarTable = document.getElementById("tblasiento");
		var LvarTbody = LvarTable.tBodies[0];
		var LvarTR    = document.createElement("TR");
		var Lclass 	= document.form1.LastOneAsiento;
		var p1 		= document.form1.Cconcepto.options[document.form1.Cconcepto.selectedIndex].value.toString(); // Cdigo
		var p2 		= document.form1.Cconcepto.options[document.form1.Cconcepto.selectedIndex].text;

		
		// Valida no agregar vacos
		if (p1=="") {
			return;
		}	  
		
		// Valida no agregar repetidos
		if (existeCodigoAsieCont(p1)) {
			alert('El Asiento Contable ya fue agregado.');
			return;
		}
		// Agrega Columna 0
		sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "AsieContidList");
	  	
		// Agrega Columna 1
		sbAgregaTdText  (LvarTR, Lclass.value, p1 + ' - ' + p2);
		// Agrega Evento de borrado en Columna 2
		sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "left");
		if (document.all) {
			GvarNewTD.attachEvent ("onclick", sbEliminarTR);
		}
		else {
			GvarNewTD.addEventListener ("click", sbEliminarTR, false);
		}

		// Nombra el TR
		LvarTR.name = "XXXXX";

		// Agrega el TR al Tbody
		LvarTbody.appendChild(LvarTR);
	  
		if (Lclass.value=="ListaNon") {
			Lclass.value="ListaPar";
		}
		else {
			Lclass.value="ListaNon";
		}
	}

	// Función que valida que no exista el código en la lista
	function existeCodigoAsieCont(v) 
	{
		var LvarTable = document.getElementById("tblasiento");
		
		for (var i=0; i<LvarTable.rows.length; i++)
		{
			var value = new String(fnTdValue(LvarTable.rows[i]));
			var data = value.split('|');
		
			if (data[0] == v) {
				return true;
			}
		}
		return false;
	}
	
	/********************************************************************************************************/
	function fnNuevaCuentaContable()	{	
		var LvarTable 	= document.getElementById("tblcuenta");
		var LvarTbody 	= LvarTable.tBodies[0];
		var LvarTR    	= document.createElement("TR");
		var Lclass 		= document.form1.LastOneCuenta;
		FrameFunction();
		var cuenta		 = document.form1.CtaFinal.value	
		var vectorcuenta = cuenta.split('-');
		var p1 = "";
		for(i=0;i < vectorcuenta.length;i++) {
			if(vectorcuenta[i].length > 0)
				p1 = p1 + vectorcuenta[i] + '-';
		}
		p1 = p1.substring(0,p1.length-1) 

		if (p1=="") {
			return;
		}	

		if (existeCodigoCuenta(p1)) {
			alert('La Cuenta Contable ya fue agregada.');
			return;
		}

		if(document.form1.ID_REPORTE.value == '2' && p1.indexOf('_',0) > -1){
			LimpiaCajas();
			alert('Para este tipo de reporte no se pueden utilizar comodines');
			return;
		}

		sbAgregaTdInput (LvarTR, Lclass.value, p1, "hidden", "CuentaidList");
		sbAgregaTdText  (LvarTR, Lclass.value, p1);
		sbAgregaTdImage (LvarTR, Lclass.value, "imgDel", "right");
		if (document.all) {
			GvarNewTD.attachEvent ("onclick", sbEliminarTR);
		}
		else {
			GvarNewTD.addEventListener ("click", sbEliminarTR, false);
		}
		LvarTR.name = "XXXXX";
		LvarTbody.appendChild(LvarTR);
		if (Lclass.value=="ListaNon") {
			Lclass.value="ListaPar";
		}
		else {
			Lclass.value="ListaNon";
		}
		var cant = new Number(document.form1.CuentasADD.value);
		cant = cant + 1;
		document.form1.CuentasADD.value = cant;

		if(document.form1.ID_REPORTE.value == '2' && cant >= 2)
		{
			document.form1.AGRE.disabled 	= true;		
		}	
				
		LimpiaCajas();
	}	
	/*********************************************************************************************************/
	function existeCodigoCuenta(v){
		var LvarTable = document.getElementById("tblcuenta");
		for (var i=0; i<LvarTable.rows.length; i++){
			var value = new String(fnTdValue(LvarTable.rows[i]));
			var data = value.split('|');
			if (data[0] == v) {
				return true;
			}
		}
		return false;
	}
	/*********************************************************************************************************/
	function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName){
		var LvarTD    = document.createElement("TD");
		var LvarInp   = document.createElement("INPUT");
		LvarInp.type = LprmType;
		if (LprmName != "") {
			LvarInp.name = LprmName;
		}
		
		if (LprmValue != "") {
			LvarInp.value = LprmValue +"|" 
			+ document.form1.nivelDet.value +"|"		 
			+ document.form1.nivelTot.value;

		} 

		LvarTD.appendChild(LvarInp);
		if (LprmClass!="") { 
			LvarTD.className = LprmClass;
		}
		GvarNewTD = LvarTD;
		LprmTR.appendChild(LvarTD);
	}
	/*********************************************************************************************************/
	function sbAgregaTdText (LprmTR, LprmClass, LprmValue){
		var LvarTD    = document.createElement("TD");
		var LvarTxt   = document.createTextNode(LprmValue);
		LvarTD.appendChild(LvarTxt);
		if (LprmClass!="") {
			LvarTD.className = LprmClass;
		}
		GvarNewTD = LvarTD;
		LvarTD.noWrap = true;
		LprmTR.appendChild(LvarTD);
	}
	/*********************************************************************************************************/
	function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre, align){
		var LvarTDimg 	= document.createElement("TD");
		var LvarImg 	= document.getElementById(LprmNombre).cloneNode(true);
		LvarImg.style.display="";
		LvarImg.align=align;
		LvarTDimg.appendChild(LvarImg);
		if (LprmClass != "") {
			LvarTDimg.className = LprmClass;
		}
		GvarNewTD = LvarTDimg;
		LprmTR.appendChild(LvarTDimg);
	}
	/*********************************************************************************************************/
	function sbEliminarTR(e){
		var LvarTR;
		if (document.all) {
			LvarTR = e.srcElement;
		}
		else {
			LvarTR = e.currentTarget;
		}
		while (LvarTR.name != "XXXXX") {
			LvarTR = LvarTR.parentNode;
		}
		LvarTR.parentNode.removeChild(LvarTR);
		var cant = new Number(document.form1.CuentasADD.value);
		cant = cant -1;
		document.form1.CuentasADD.value = cant;
        if(document.form1.ID_REPORTE.value == '2' && cant < 2){
			document.form1.AGRE.disabled 	= false;		
		}		
	}
	/*********************************************************************************************************/
	function fnTdValue(LprmNode){
		var LvarNode = LprmNode;
		while (LvarNode.hasChildNodes()) {
			LvarNode = LvarNode.firstChild;
			if (document.all == null) {
				if (!LvarNode.firstChild && LvarNode.nextSibling != null && LvarNode.nextSibling.hasChildNodes()) {
					LvarNode = LvarNode.nextSibling;
				}
			}
		}
		if (LvarNode.value) {
			return LvarNode.value;
		} 
		else {
			return LvarNode.nodeValue;
		}
	}
	/*********************************************************************************************************/
	function ACTIVAMESES(){
		var ETQINI  	= document.getElementById("ETQINI");
		var ETQFIN  	= document.getElementById("ETQFIN");
		var MesInicial  = document.getElementById("MesInicial");
		var MesFinal  	= document.getElementById("MesFinal");
		switch(document.form1.TipoFormato.value) {
			case '1': {
					ETQFIN.style.visibility='hidden';
					MesFinal.style.visibility='hidden';
					MesInicial.style.visibility='visible';
					ETQINI.style.visibility='visible';		
					
					document.form1.ETQINI.value ='Mes:';
				break;
			}
			case '2': {
					ETQINI.style.visibility='hidden';
					ETQFIN.style.visibility='hidden';
					MesInicial.style.visibility='hidden';
					MesFinal.style.visibility='hidden';
				break;
			}
			case '3': {
					ETQFIN.style.visibility='visible';
					MesFinal.style.visibility='visible';
					MesInicial.style.visibility='visible';
					ETQINI.style.visibility='visible';	
					document.form1.ETQINI.value ='Mes Inicial:';
				break;
			}
			case '4': {
					ETQFIN.style.visibility='visible';
					MesFinal.style.visibility='visible';
					MesInicial.style.visibility='visible';
					ETQINI.style.visibility='visible';	
					document.form1.ETQINI.value ='Mes Inicial:';
				break;
			}		
			case '5': {
					ETQFIN.style.visibility='visible';
					MesFinal.style.visibility='visible';
					MesInicial.style.visibility='visible';
					ETQINI.style.visibility='visible';	
					document.form1.ETQINI.value ='Mes Inicial:';
				break;
			}									
		}	
	}
	<cfif Form.Archivo eq 'S'>
		ACTIVAMESES()
	</cfif>	
	
	
</script>
