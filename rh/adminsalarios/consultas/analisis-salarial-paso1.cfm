
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
		
		function changeAplica(f) {
			switch (f.RHASaplicar.value) {
				case '0': 
					f.RHASnumper.value = '';
					f.RHASnumper.disabled = true;
					objForm.RHASnumper.required = false;
					break;
				case '1': 
					f.RHASnumper.disabled = false;
					objForm.RHASnumper.required = true;
					break;
				default:
			}
		}
		
	<cfif modo EQ "CAMBIO">
		function funcEliminar(desc) {
			if (confirm('Está seguro de que desea eliminar el reporte de análisis de proyección salarial: '+desc+'?')) {
				return true;
			} else {
				return false;
			}
		}
	<cfelse>
		function doConlisReportes() {
			var width = 650;
			var height = 450;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			var params = '';
			var nuevo = window.open('analisis-salarial-conlisReportes.cfm'+params,'conlisASalarial','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
			nuevo.focus();
			return false;
		}
	</cfif>
	</script>

	<form name="form1" method="post" action="analisis-salarial-sql.cfm" style="margin: 0;">
		<cfinclude template="analisis-salarial-hiddens.cfm">
		<cfif modo EQ "ALTA">
			<input type="hidden" name="RHASid_Rec" value="">
		</cfif>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td class="fileLabel" align="right" nowrap>Descripci&oacute;n: </td>
			<td colspan="3" nowrap>
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
					columnas="distinct Efecha, b.EEid, b.Eid, b.ETid, f.Mcodigo, d.EEnombre, c.Edescripcion, e.ETdescripcion, f.Mnombre"
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
			<td colspan="3" nowrap>
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
			<td class="fileLabel" align="right" nowrap>Aplica a:</td>
			<td nowrap>
				<select name="RHASaplicar" id="RHASaplicar" onChange="javascript: changeAplica(this.form);">
					<option value="0"<cfif modo EQ "CAMBIO" and rsDatosASalarial.RHASaplicar EQ 0> selected</cfif>>Mensual</option>
					<option value="1"<cfif modo EQ "CAMBIO" and rsDatosASalarial.RHASaplicar EQ 1> selected</cfif>>Por Per&iacute;odo</option>
				</select>
			</td>
			<td class="fileLabel" align="right" nowrap>No. Per&iacute;odos:</td>
			<td nowrap>
				<input name="RHASnumper" id="RHASnumper" type="text" size="8" maxlength="6" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ "CAMBIO" and Len(Trim(rsDatosASalarial.RHASnumper))>#LSNumberFormat(rsDatosASalarial.RHASnumper,'9')#</cfif>">
			</td>
			<td class="fileLabel" align="right" nowrap>Tipo de Organizaci&oacute;n: </td>
			<td nowrap>
				<input type="hidden" name="ETid" id="ETid" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.ETid#</cfif>">
                <input type="text" name="ETdescripcion" id="ETdescripcion" size="40" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.ETdescripcion#</cfif>" style="border: none;" tabindex="-1" readonly>
            </td>
		  </tr>
		  <tr>
			<td align="right" nowrap>
				<input name="NoSalario" type="checkbox" id="NoSalario" value="1"<cfif modo EQ "CAMBIO" and rsDatosASalarial.NoSalario EQ 1> checked</cfif>>
				&nbsp;
			</td>
			<td colspan="3" nowrap><strong>No Incluir Salario Base</strong></td>
			<td class="fileLabel" align="right" nowrap>Moneda:</td>
			<td nowrap><input type="hidden" name="Mcodigo" id="Mcodigo" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.Mcodigo#</cfif>">
                <input type="text" name="Mnombre" id="Mnombre" size="40" value="<cfif modo EQ "CAMBIO">#rsDatosASalarial.Mnombre#</cfif>" style="border: none;" tabindex="-1" readonly>
            </td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td colspan="3">&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr align="center">
			<td colspan="6">
				<input type="submit" name="btnGuardar"  value="Guardar" class="btnGuardar">
				<cfif modo EQ "CAMBIO">
					<input type="submit" name="btnEliminar"  value="Eliminar" onClick="javascript: return funcEliminar('#JSStringFormat(rsDatosASalarial.RHASdescripcion)#'); " class="btnEliminar">
					<input type="submit" name="btnSiguiente"  value="Siguiente" class="btnSiguiente" onClick="javascript: return funcSiguiente(this.form, #Form.paso#); " >
				<cfelse>
					<input type="submit" name="btnRecuperar"  value="Recuperar" onClick="javascript: return doConlisReportes(); " class="btnRefresh">
				</cfif>
			</td>
		  </tr>
		  <tr align="center">
			<td colspan="6">&nbsp;</td>
		  </tr>
		</table>
	</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.Edescripcion.required = true;
	objForm.Edescripcion.description = "Encuesta";
	objForm.RHASdescripcion.required = true;
	objForm.RHASdescripcion.description = "Descripción";
	objForm.RHASref.required = true;
	objForm.RHASref.description = "Fecha a Evaluar";
	objForm.RHASnumper.description = "Número de Períodos";

	changeAplica(document.form1);
</script>
