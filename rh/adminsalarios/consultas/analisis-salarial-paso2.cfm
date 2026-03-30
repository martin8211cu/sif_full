<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_CODIGO" Default="C&oacute;digo" returnvariable="LB_CODIGO" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_DESCRIPCION" Default="Descripci&oacute;n" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_DeseaEliminarLosConceptosDePagoSeleccionados" Default="Desea eliminar los conceptos de pago seleccionados?" returnvariable="MSG_DeseaEliminarLosConceptosDePagoSeleccionados" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" Default="Debe seleccionar al menos un registro para relizar esta acción."	 returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined('url.RHASid') and not isdefined('form.RHASid')>
	<cfset form.RHASid = url.RHASid>
</cfif>
<cfif isdefined('url.EEid') and not isdefined('form.EEid')>
	<cfset form.EEid = url.EEid>
</cfif>
<cfif isdefined('url.modo')>
	<cfset modo = url.modo>
</cfif>


<cfquery name="rsLista" datasource="#Session.DSN#">
	select a.RHASid, a.CIid, rtrim(b.CIcodigo) as CIcodigo, b.CIdescripcion
	from RHASalarialIncidentes a
		inner join CIncidentes b
			on b.CIid = a.CIid
	where a.RHASid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHASid#">
	order by b.CIcodigo, b.CIdescripcion
</cfquery>

<cfoutput>
	<form name="form1" method="post" action="analisis-salarial-sql.cfm" style="margin: 0;">
		<input name="chkLista" type="hidden" value="" />
		<cfinclude template="analisis-salarial-hiddens.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="60">&nbsp;</td>
			<td align="right" class="fileLabel" nowrap>Concepto de Pago:&nbsp;</td>
			<td>
				<cf_rhCIncidentes ExcluirTipo="3" IncluirChk="S" submit="true">
			</td>
		    <td align="right">
				<input name="chkTodos" type="checkbox" id="chkTodos" value="1" onClick="javascript: changeTodos(this.form)">
			</td>
		    <td><strong>Incluir todos los Conceptos de Pago</strong></td>
		    <td align="center">
				<input type="submit" name="btnAgregar"  value="Agregar">
			</td>
		  </tr>
		  <tr><td colspan="6">&nbsp;</td></tr>
		</table>
		<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td align="right">
					<label><strong><cf_translate key="LB_SeleccionarTodos">Seleccionar Todos</cf_translate></strong></label>
					<input type="checkbox" name="chkTodosP" value="" onClick="javascript: funcChequeaTodos();" <cfif isdefined("form.Todos") and form.Todos EQ 1>checked</cfif>>
				</td>
			</tr>
		  <tr>
			<td>
				<cfset filtro = ''>
				<cfset navegacion = ''>
				<cfset filtro = filtro & ' and RHASid =' & Form.RHASid>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "paso=2">
				<cfif isdefined("Form.RHASid") and Len(Trim(Form.RHASid)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHASid=" & Form.RHASid>
				</cfif>
				<cfif isdefined("Form.EEid") and Len(Trim(Form.EEid)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EEid=" & Form.EEid>
				</cfif>
				<cfif isdefined("modo") and Len(Trim(modo)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "modo=" & modo>
				</cfif>
				<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaEduRet">
						<cfinvokeargument name="tabla" value=" RHASalarialIncidentes a
																inner join CIncidentes b
																	on b.CIid = a.CIid"/>
						<cfinvokeargument name="columnas" value="a.CIid,CIcodigo, CIdescripcion, #form.paso# as paso"/>
						<cfinvokeargument name="desplegar" value="CIcodigo, CIdescripcion"/>
						<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
						<cfinvokeargument name="formatos" value="S,S"/>
						<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by CIcodigo, CIdescripcion"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="analisis-salarial-sqlpaso2.cfm"/>
						<cfinvokeargument name="formName" value="listaConceptos"/>
						<cfinvokeargument name="MaxRows" value="15"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="formName" value="form1"/>
						<cfinvokeargument name="checkboxes" value="D"/>
						<cfinvokeargument name="keys" value="CIid"/>
						<cfinvokeargument name="showlink" value="no"/>
					</cfinvoke>
			</td>
		  </tr>
		  <tr><td>&nbsp;</td></tr>
		  <tr>
			<td align="center">
 				<input type="submit" name="btnAnterior" class="btnAnterior"
					value="Anterior" onClick="javascript: funcAnterior2(this.form,#Form.paso#); ">
				<input type="submit" name="btnEliminar" class="btnEliminar"
					value="Eliminar" onClick="javascript: funcEliminar2(this.form, #Form.paso#); ">
				<input type="submit" name="btnSiguiente" class="btnSiguiente"
					value="Siguiente" onClick="javascript: funcSiguiente2(this.form, #Form.paso#); ">
 			</td>
		  </tr>
		  <tr><td>&nbsp;</td></tr>
		</table>
	</form>

</cfoutput>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");


	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.CIid.required = true;
	objForm.CIid.description = "Concepto de Pago";

	changeTodos(document.form1);
	
	function funcAnterior2(){
		document.form1.paso.value = 1;
		document.form1.submit();
	}
	function funcSiguiente2(){
		document.form1.paso.value = 3;
		document.form1.submit();
	}
	function funcEliminar2(){
		if (hayMarcados() && confirm('<cfoutput>#MSG_DeseaEliminarLosConceptosDePagoSeleccionados#</cfoutput>')){
			document.form1.submit();
		}else{
			return false;
		}
	}
	
	function Eliminar(c, v) {
		if (confirm("Está seguro de que desea eliminar el concepto de pago " + v + " de este reporte?")) {
			document.listaConceptos.CIid_Del.value = c;
			document.listaConceptos.submit();
		}
	}

	function changeTodos(f) {
		if (f.chkTodos.checked) {
			objForm.CIid.required = false;
		} else {
			objForm.CIid.required = true;
		}
	}
	
	function hayMarcados(){
		var form = document.form1;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (form.chk.checked)
					result = true;
			}
		}
		if (!result) alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion#</cfoutput>');
		return result;
	}
	function funcChequeaTodos(){
		var c = document.form1.chkTodosP;
		if (document.form1.chk) {
			if (document.form1.chk.value) {
				if (!document.form1.chk.disabled) { 
					document.form1.chk.checked = c.checked;
				}
			} else {
				for (var counter = 0; counter < document.form1.chk.length; counter++) {
					if (!document.form1.chk[counter].disabled) {
						document.form1.chk[counter].checked = c.checked;
					}
				}
			}
		}
	}
</script>
