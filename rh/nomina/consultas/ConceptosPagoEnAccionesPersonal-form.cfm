<!--- Modified with Notepad --->
<cfsilent>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_TipodeNomina"
		Default="Tipo de Nmina"
		returnvariable="JSMSG_TipodeNomina"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_Nomina"
		Default="Nmina"
		returnvariable="JSMSG_Nomina"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_Moneda"
		Default="Moneda"
		returnvariable="JSMSG_Moneda"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_TipoCambio"
		Default="Tipo de Cambio"
		returnvariable="JSMSG_TipoCambio"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_El_campo"
		Default="El campo"
		returnvariable="JSMSG_El_campo"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_es_requerido"
		Default="es requerido"
		returnvariable="JSMSG_es_requerido"/> 
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="JSMSG_La_lista_de_Nominas_es_requerida"
		Default="La lista de N&oacute;minas es requerida"
		returnvariable="JSMSG_La_lista_de_Nominas_es_requerida"/> 
	<cfquery name="rsMonedas" datasource="#session.dsn#">
		select Mcodigo
			, Mnombre
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
	</cfquery>
	<cfquery name="rsMonLoc" datasource="#session.dsn#">
		select Mcodigo
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">	
	</cfquery>	
	<cfquery name="rsTiposNominas" datasource="#session.dsn#">
		select Tcodigo, Tdescripcion 
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">	
	</cfquery>	
</cfsilent>
<cfoutput>
<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
<form name="form1" method="post" action="#Gvar_action#" style="margin:0;">
	<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
	<input type="hidden" name="CPidlist1" id="CPidlist1" value="" tabindex="1">
	<input type="hidden" name="CPidlist2" id="CPidlist2" value="" tabindex="1">
	<table width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr><td colspan="3">&nbsp;</td></tr>
		<tr>
			<td colspan="1%">&nbsp;</td>
			<td colspan="20%">
				<input name="TipoNomina" id="TipoNomina" type="checkbox" tabindex="1" onclick="javascript: Verificar();">
				<label for="TipoNomina" style="font-style:normal;font-weight:normal"><strong><cf_translate  key="LB_NominasHistoricas">N&oacute;minas Históricas</cf_translate></strong></label>
			</td>
			<td colspan="70%">&nbsp;</td>
		</tr>
		
		<tr>
			<td colspan="1%">&nbsp;</td>
			<td colspan="90%" align="left" colspan="2"><input type="checkbox" name="chkUtilizarFiltro" id="chkUtilizarFiltro" onclick="javascript:utilizarFechas(this);" /><b><i><cf_translate key="LB_Utilizar_Rango_de_Fechas" xmlFile="/rh/generales.xml">Utilizar Rango de Fechas</cf_translate></i></b></td>
		</tr>
	
		<!---- filtro pot fechas---->
		<tr>
			<td>&nbsp;</td>
			<td colspan="2">
				<table id="divFiltroFechas" style="display:none">
					<tr>
						<td align="left"> <strong><cf_translate  key="LB_Fecha_Desde"  xmlFile="/rh/generales.xml">Fecha Desde</cf_translate> :&nbsp;</strong></td>
						<td align="left"> <cf_sifcalendario form="form1" value="#LSDateFormat(Now(), "DD/MM/YYYY")#"  name="Filtro_FechaDesde"> </td>
					</tr>	
					<tr>
						<td  align="left"> <strong><cf_translate  key="LB_Fecha_Hasta"  xmlFile="/rh/generales.xml">Fecha Hasta</cf_translate> :&nbsp;</strong></td>
						<td  align="left"><cf_sifcalendario form="form1" value="#LSDateFormat(Now(), "DD/MM/YYYY")#"  name="Filtro_FechaHasta"></td>
					</tr>
					<tr>
						<td  align="left"> <strong><cf_translate  key="LB_Tipo_Nomina"  xmlFile="/rh/generales.xml">Tipo Nómina</cf_translate> :&nbsp;</strong></td>
						<td  align="left"> <cf_rhtiponomina form="form1" index="10" agregarEnLista="true"></td>
					</tr>
				</table>	
			</td>
		</tr>
		<!--- fin de filtro por fechas--->
		
		<tr id="NAplicadas">
			<td>&nbsp;</td>
			<td  align="right" nowrap="nowrap"> <strong><cf_translate  key="LB_Nomina">Nómina</cf_translate> :&nbsp;</strong></td>
			<td>
				<table>
					<tr>
						<td>
							<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" index="1" tabindex="1" pintaRCDescripcion="true" AgregarEnLista="true">
						</td>
					</tr>
				</table>			
			</td>
		</tr>
		<tr id="NNoAplicadas" style="display:none">
			<td>&nbsp;</td>
			<td  align="right" nowrap="nowrap"> <strong><cf_translate  key="LB_Nomina">Nómina</cf_translate> :&nbsp;</strong></td>
			<td>
				<table>
					<tr>
						<td>
							<cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true" index="2" tabindex="1" pintaRCDescripcion="true" AgregarEnLista="true">
						</td>
					</tr>
				</table>			
			</td>

		</tr>

		<!--- filtro tipo Accion--->
		<tr>
			<td>&nbsp;</td>
			<td  align="right" nowrap="nowrap"> <strong><cf_translate  key="LB_Tipo_Accion">Tipo Acción</cf_translate> :&nbsp;</strong></td>
			<td>
				<table>
					<tr>
						<td>
						<!--- filtro extra---->
							<cfset listaRHTid='0'>
							<cfquery datasource="#session.dsn#" name="listaAccion">
								select distinct ca.RHTid
								from ConceptosTipoAccion ca
									inner join RHTipoAccion rh
										on ca.RHTid = rh.RHTid
								where rh.Ecodigo = #session.Ecodigo#
							</cfquery>
							<cfif listaAccion.recordcount>
								<cfset listaRHTid = valueList(listaAccion.RHTid)>
							</cfif>
							<cf_rhtipoaccion form="form1" index="1" tabindex="1" AgregarEnLista="true" filtroExtra="a.RHTid in (#listaRHTid#)">
						</td>
					</tr>
				</table>			
			</td>
		</tr>

		<!--- filtro Tipo incidencias--->
		<tr>
			<td>&nbsp;</td>
			<td  align="right" nowrap="nowrap"> <strong><cf_translate  key="LB_Concepto_Pago">Concepto Pago</cf_translate> :&nbsp;</strong></td>
			<td>
				<table>
					<tr>
						<td>
							<!--- filtro extra---->
								<cfset listaCIid='0'>
								<cfquery datasource="#session.dsn#" name="listaConceptos">
									select distinct ca.CIid
									from ConceptosTipoAccion ca
										inner join RHTipoAccion rh
											on ca.RHTid = rh.RHTid
									where rh.Ecodigo = #session.Ecodigo#
								</cfquery>
								<cfif listaConceptos.recordcount>
									<cfset listaCIid = valueList(listaConceptos.CIid)>
								</cfif>
							<cf_rhcincidentes form="form1" index="1" tabindex="1" AgregarEnLista="true" filtroExtra="CIid in (#listaCIid#)">
						</td>
					</tr>
				</table>			
			</td>
		</tr>
		
		<!--- filtro tipo Empleado--->
		<tr>
			<td>&nbsp;</td>
			<td  align="right" nowrap="nowrap"> <strong><cf_translate  key="LB_Empleado">Empleado</cf_translate> :&nbsp;</strong></td>
			<td>
				<table>
					<tr>
						<td>
							<cf_rhempleado form="form1" index="1" tabindex="1" AgregarEnLista="true" >
						</td>
					</tr>
				</table>			
			</td>
		</tr>
		
		<!--- check de agrupado por relacion de calculo--->
		<tr>
			<td align="left" colspan="2">
			<td align="left" colspan="1">
			<input name="chkAgruparRC" id="chkAgruparRC" type="checkbox"  >
				<label for="chkAgrupar" style="font-style:normal; font-variant:normal; font-weight:normal">
					<cf_translate key="LB_AgruparPorCentroFuncional">Agrupar por Relación de Cálculo</cf_translate>
				</label>
			</td>
		</tr>	
		
		<!--- botones---->
		<tr>
			<td colspan="3">
				<table align="center">
					<tr>
						<td align="right"><cf_botones values="Generar" tabindex="1"></td>
						<td align="left"><input class="btnPublicar" type="submit" name="ExportarExcel" value="Exportar a Excel" /></td>
					</tr>
				</table>			
			</td>
		</tr>
		
	
				
	</table>
</form>
<script language="javascript" type="text/javascript">
	function Verificar(){
		if(document.getElementById("chkUtilizarFiltro").checked==false){
				if (document.getElementById("TipoNomina").checked == true){
					document.getElementById("NAplicadas").style.display=''
					document.getElementById("NNoAplicadas").style.display='none'; 
					document.getElementById("ListaCalendarios1").style.display='';
					document.getElementById("ListaCalendarios2").style.display='none';
					document.form1.Tcodigo1.value = '';
					document.form1.Tdescripcion1.value = '';
					document.form1.CPid1.value = '';
					document.form1.CPcodigo1.value = '';
					document.form1.CPdescripcion1.value = '';
					<cfif FindNoCase('SA',Gvar_action) GT 0>	
						document.getElementById("tdMonedas").style.display='none'; 
						document.getElementById("tdTipoCambio").style.display='none'; 
					</cfif>
					}
				else{
					document.getElementById("NAplicadas").style.display='none'
					document.getElementById("NNoAplicadas").style.display=''; 
					document.getElementById("ListaCalendarios1").style.display='none';
					document.getElementById("ListaCalendarios2").style.display='';
					document.form1.Tcodigo2.value = '';
					document.form1.Tdescripcion2.value = '';
					document.form1.CPid2.value = '';
					document.form1.CPcodigo2.value = '';
					document.form1.CPdescripcion2.value = '';
					<cfif FindNoCase('SA',Gvar_action) GT 0>
						document.getElementById("tdMonedas").style.display=''; 
						document.getElementById("tdTipoCambio").style.display=''; 
						document.form1.Mcodigo.value="#rsMonLoc.Mcodigo#";
						setTipoCambio();
					</cfif>
				}
		}
	}
	Verificar();
	/*validar el formulario 1*/
	function _validateForm1(){
		if (!objForm._allowSubmitOnError) {
			if(document.getElementById("chkUtilizarFiltro").checked==false){
					if (document.getElementById("TipoNomina").checked == true){
						if (!checkLista('ListaTcodigoCalendario1')) objForm.CPidlist1.throwError("#JSMSG_La_lista_de_Nominas_es_requerida#");
					} else {
						if (!checkLista('ListaTcodigoCalendario2')) objForm.CPidlist2.throwError("#JSMSG_La_lista_de_Nominas_es_requerida#");
					}	
			}	
		}
	}
	
	function _submitForm1(){
	}
	
	function utilizarFechas(e){
		if(e.checked){
			document.getElementById("NNoAplicadas").style.display='none';
			document.getElementById("NAplicadas").style.display='none'; 
			document.getElementById("divFiltroFechas").style.display=''; 
			deshabilitarValidacion();
		}
		else{
			document.getElementById("divFiltroFechas").style.display='none'; 
			Verificar();
		}
	}	
	
	function checkLista(e){
		var valores='';
			try{
				valores=document.getElementById(e).value ;
			}catch(err){}	
		if(valores==''){
			return false;
		}
		else{
			return true;
		}
	}
	
</script>
</cfoutput>
<cf_qforms onValidate="_validateForm1" onSubmit="_submitForm1">
