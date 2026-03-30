
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_ListaDeEncuestas" Default="Lista de Encuestas" returnvariable="LB_ListaDeEncuestas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Encuesta" Default="Encuesta" returnvariable="LB_Encuesta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Moneda" Default="Moneda" returnvariable="LB_Moneda" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Empresa" Default="Empresa" returnvariable="LB_Empresa" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_TipoDeOrganizacion" Default="Tipo de Organizaci&oacute;n" returnvariable="LB_TipoDeOrganizacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="MSG_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfoutput>
	<script src="/cfmx/rh/js/utilesMonto.js"></script>
	<script src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="javascript" type="text/javascript">
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");

		function doConlisEncuestas() {
			var width = 650;
			var height = 450;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			var params = '?f=form1&p1=EEid&p2=Eid&p3=ETid&p4=Mcodigo&p5=EEnombre&p6=Edescripcion&p7=ETdescripcion&p8=Mnombre';
			var nuevo = window.open('analisis-salarial-conlisEncuestas.cfm'+params,'conlisASalarial','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
			nuevo.focus();
		}
		
		function doConlisValoraciones() {
			var width = 650;
			var height = 450;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			var params = '?f=form1&p1=HYERVid&p2=HYERVdescripcion';
			var nuevo = window.open('analisis-salarial2-conlisValoraciones.cfm'+params,'conlisASalarial','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
			nuevo.focus();
		}
		
		function doConlisEscalas() {
			var width = 650;
			var height = 450;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			var params = '?f=form1&p1=ESid&p2=EscalaSalarial';
			var nuevo = window.open('analisis-salarial2-conlisEscalas.cfm'+params,'conlisASalarial','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
			nuevo.focus();
		}
		
		function validar(f) {
			<!--- f.obj.RHASporcentaje.value = qf(f.obj.RHASporcentaje.value); --->
			return true;
		}
		
	<cfif modo EQ "CAMBIO">
		function funcEliminar(desc) {
			if (confirm('Está seguro de que desea eliminar el reporte de análisis de dispersión salarial: '+desc+'?')) {
				inhabilitarValidaciones();
				return true;
			} else {
				return false;
			}
		}
	<cfelse>
		function doConlisReportes() {
			var width = 700;
			var height = 450;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			var params = '';
			var nuevo = window.open('analisis-salarial2-conlisReportes.cfm'+params,'conlisASalarial','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
			nuevo.focus();
			return false;
		}
	</cfif>
	</script>

	<form name="form1" method="post" action="analisis-salarial2-sql.cfm" style="margin: 0;" onSubmit="javascript: return validar(this);">
		<cfinclude template="analisis-salarial2-hiddens.cfm">
		<cfif modo EQ "ALTA">
			<input type="hidden" name="RHASid_Rec" value="">
		</cfif>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td class="fileLabel" align="right" nowrap>Descripci&oacute;n: </td>
			<td nowrap>
				<input type="text" name="RHASdescripcion" id="RHASdescripcion" size="40" maxlength="80" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.RHASdescripcion#</cfif>">
			</td>
			<td class="fileLabel" width="20%" align="right" nowrap>Encuesta: </td>
			<td width="30%" nowrap>
				<cfset valoresEncuesta = ArrayNew(1)>	<!---Valores de la encuesta--->
				<cfif isdefined('rsDatosASalarial')>
				<cfset ArrayAppend(valoresEncuesta, rsDatosASalarial.Edescripcion)>
				</cfif>
				<cf_conlis 
					campos="Edescripcion"
					asignar="Eid,EEid,ETid, Edescripcion,EEnombre, ETdescripcion, Mnombre,Mcodigo"
					size="30"
					desplegables="S"
					modificables="N"						
					title="#LB_ListaDeEncuestas#"
					tabla="RHEncuestadora a
							inner join EncuestaSalarios b
							   on b.EEid = a.EEid
							inner join Encuesta c
							   on c.Eid = b.Eid
							inner join EncuestaEmpresa d
							   on d.EEid = a.EEid
							inner join EmpresaOrganizacion e
							   on e.ETid = a.ETid
							inner join Monedas f
							   on f.Mcodigo = b.Moneda"
					columnas="distinct b.EEid, b.Eid, b.ETid, f.Mcodigo, d.EEnombre, c.Edescripcion, e.ETdescripcion, f.Mnombre"
					filtro="a.Ecodigo = #Session.Ecodigo# order by Efecha desc"
					filtrar_por="EEnombre, Edescripcion, ETdescripcion, Mnombre"
					desplegar="EEnombre, Edescripcion, ETdescripcion, Mnombre"
					etiquetas="#LB_Empresa#, #LB_Encuesta#, #LB_TipoDeOrganizacion#, #LB_Moneda#"
					formatos="S,S,S,S"
					align="left,left,left,left"								
					asignarFormatos="S,S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoSeEncontraronRegistros# --- "
					tabindex="1"
					valuesArray="#valoresEncuesta#"
					width="750"
					height="300"
					left="125"
				/>
				<input type="hidden" name="Eid" id="Eid" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.Eid#</cfif>">
			</td>
		  </tr>
		  <tr>
			<td class="fileLabel" align="right" nowrap>Fecha a Evaluar: </td>
			<td nowrap>
				<cfif modo EQ "CAMBIO">
					<cfset fecharef = LSDateFormat(rsDatosASalarial.RHASref, 'dd/mm/yyyy')>
				<cfelse>
					<cfset fecharef = LSDateFormat(Now(), 'dd/mm/yyyy')>
				</cfif>
				<cf_sifcalendario form="form1" name="RHASref" value="#fecharef#">
			</td>
			<td class="fileLabel" align="right" nowrap>Empresa Encuestadora: </td>
			<td width="30%" nowrap>
				<input type="hidden" name="EEid" id="EEid" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.EEid#</cfif>">
                <input type="text" name="EEnombre" id="EEnombre" size="40" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.EEnombre#</cfif>" style="border: none;" tabindex="-1" readonly>
            </td>
		  </tr>
		  <tr>
			<td class="fileLabel" align="right" nowrap>Escala Salarial HAY:</td>
		    <td nowrap>
				<input type="hidden" name="ESid" id="ESid" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.ESid#</cfif>">
				<input type="text" name="EscalaSalarial" id="EscalaSalarial" size="40" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.EscalaSalarial#</cfif>" tabindex="-1" readonly>
				<a href="javascript: doConlisEscalas();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Escalas" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>
			</td>
			<td class="fileLabel" align="right" nowrap>Tipo de Organizaci&oacute;n: </td>
			<td nowrap>
				<input type="hidden" name="ETid" id="ETid" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.ETid#</cfif>">
                <input type="text" name="ETdescripcion" id="ETdescripcion" size="40" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.ETdescripcion#</cfif>" style="border: none;" tabindex="-1" readonly>
            </td>
		  </tr>
		  <tr>
		     <td class="fileLabel" align="right" nowrap>&nbsp;<!--- Porc. Tendencia a Evaluar: ---></td>
		    <td nowrap>&nbsp;
				<!--- <input name="RHASporcentaje" type="text" size="8" maxlength="6" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ "CAMBIO" and Len(Trim(rsDatosASalarial.RHASporcentaje))>#LSNumberFormat(rsDatosASalarial.RHASporcentaje, '9.00')#<cfelse>0.00</cfif>"> % --->
			</td>
			<td class="fileLabel" align="right" nowrap>Moneda:</td>
			<td nowrap>
				<input type="hidden" name="Mcodigo" id="Mcodigo" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.Mcodigo#</cfif>">
                <input type="text" name="Mnombre" id="Mnombre" size="40" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.Mnombre#</cfif>" style="border: none;" tabindex="-1" readonly>
            </td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr align="center">
			<td colspan="4">
				<input type="submit" name="btnGuardar"  value="Guardar" class="btnGuardar">
				<cfif modo EQ "CAMBIO">
					<input type="submit" name="btnEliminar" value="Eliminar"  class="btnEliminar" onClick="javascript: return funcEliminar('#JSStringFormat(rsDatosASalarial.RHASdescripcion)#'); ">
					<input type="submit" name="btnSiguiente" value="Siguiente"  class="btnSiguiente" onClick="javascript: return funcSiguiente(this.form, #Form.paso#); ">
				<cfelse>
					<input type="submit" name="btnRecuperar"  value="Recuperar" onClick="javascript: return doConlisReportes(); " class="btnRefresh">
				</cfif>
			</td>
		  </tr>
		  <tr align="center">
			<td colspan="4">&nbsp;</td>
		  </tr>
		</table>
	</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	function __isNotCero() {
		if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
			this.error = "El campo " + this.description + " no puede ser cero!";
		}
	}

	// Valida que sea un porcentaje válido
	function __isPorcentaje() {
		if (this.required && (new Number(qf(this.value)) > 100.00)) {
			this.error = "El campo " + this.description + " no puede ser mayor a cien!";
		}
	}
	
	function inhabilitarValidaciones() {
		objForm.RHASdescripcion.required = false;
		objForm.RHASref.required = false;
		objForm.EscalaSalarial.required = false;
		<!--- objForm.RHASporcentaje.required = false; --->
		objForm.Edescripcion.required = false;
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isNotCero", __isNotCero);
	_addValidator("isPorcentaje", __isPorcentaje);
	
	objForm.RHASdescripcion.required = true;
	objForm.RHASdescripcion.description = "Descripción";
	objForm.RHASref.required = true;
	objForm.RHASref.description = "Fecha a Evaluar";
	objForm.EscalaSalarial.required = true;
	objForm.EscalaSalarial.description = "Escala Salarial";
	<!--- objForm.RHASporcentaje.required = true;
	objForm.RHASporcentaje.description = "Porcentaje de Tendencia a Evaluar"; 
	objForm.RHASporcentaje.validateNotCero();
	objForm.RHASporcentaje.validatePorcentaje();--->
	objForm.Edescripcion.required = true;
	objForm.Edescripcion.description = "Encuesta";
</script>
