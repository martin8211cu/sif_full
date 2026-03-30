<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_Desde" Default="Fecha Desde" returnvariable="LB_Fecha_Desde"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha_Hasta" Default="Fecha Hasta" returnvariable="LB_Fecha_Hasta"/>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
	<cfquery datasource="#session.dsn#" name="rsReportesDinamicos">
		select RHRDEid,RHRDEcodigo,RHRDEdescripcion
		from RHReportesDinamicoE
		where CEcodigo = #session.CEcodigo#
	</cfquery>
<cfoutput>
<body>
<cfif rsReportesDinamicos.recordcount eq 0>
<cf_web_portlet_start border="true" titulo="Reporte No Configurado" skin="#session.preferences.skin#" >
 <table width="100%" border="0" cellspacing="1" cellpadding="1" style="margin:0">
 	<tr>
		<td>
		<p>
		<b>No existen Reportes Configurados para esta Corporaci&oacute;n</b>
		<br><br>Por favor Configure un Reporte en <b>Recursos Humanos -> Par&aacute;metros RH -> Reportes Din&aacute;micos</b>
		</p>
		</td>
	</tr>
 </table>
	<cf_web_portlet_end>
<cfabort>
</cfif>
<form  name="form1" style="margin:0" action="ConsultaRepDinamicos-sql.cfm" method="post" onSubmit="javascript:return validarSubmit();">
	<center>
	<table width="10px" align="center" border="0" cellspacing="1" cellpadding="1" style="margin:0">
		  <tr>
			<td align="left" nowrap colspan="2">
			<table>
				  <tr>
				  <td><strong>Reporte:&nbsp;</strong></td>
				  	<td>
					<select name="RHRDEid" id="RHRDEid">
						<cfloop query="rsReportesDinamicos">
							<option value="#RHRDEid#">#RHRDEcodigo# - #RHRDEdescripcion#</option>
						</cfloop>
					</select>
					</td>
				  </tr>

				  <tr>
				  	<td><strong>Corporativo:&nbsp;</strong></td>
				  	<td colspan="10"><input type="checkbox" name="chkCorporativo" id="chkCorporativo">&nbsp;Corporativo</td>
				  </tr>

				  <!--- consulta historica --->
				  <tr>
				  	<td colspan="10"><input type="checkbox" name="chkHistorico" id="chkHistorico" checked>&nbsp;Utilizar N&oacute;minas Hist&oacute;ricas</td>
				  </tr>

				  <!-------- radios para las consultas que no son corporativas------>
				  <tr id="DIVporNomina">
				  	<td colspan="10"><input type="radio" name="radio" id="radio1" value="1" checked="checked">&nbsp;Por N&oacute;mina</td>
				  </tr>
				  <tr id="DIVporCalendario">
				  	<td colspan="10"><input type="radio"  name="radio" id="radio2" value="2">&nbsp;Por Calendario de Pago</td>
				  </tr>

				  <tr id="DIVtipoNomina">
					<td><strong>Tipo N&oacute;mina&nbsp;:&nbsp;</strong></td>
					<td>
						<cf_rhtiponomina form="form1" agregarEnLista="true">
					<td>
				  </tr>
				  <tr id="DIVporNominaTipo">
				  	<td><strong>Tipo de calendario:&nbsp;</strong></td>
				  	<td colspan="10">
				  		<select name="CPtipo">
				  			<option value="">-- Todos --</option>
				  			<option value="0">Normal</option>
				  			<option value="1">Especial</option>
				  			<option value="2">Anticipo</option>
				  			<option value="5">Liquidación</option>
				  		</select>
				  	</td>
				  </tr>

				  <tr id="DIVcalendarioPagos" style="display:none">
					<td><strong>Calendario Pago&nbsp;:&nbsp;</strong></td>
					<td id="calendarioHistorico">
						<cf_rhcalendariopagos form="form1" index="2" historicos="true" tcodigo="true" agregarEnLista="true">
					<td>
					<td id="calendarioActual" style="display:none">
						<cf_rhcalendariopagos form="form1" index="21" historicos="false" tcodigo="true" agregarEnLista="true">
					<td>
				  </tr>

				  <tr>
				  <td><strong>Empleado:&nbsp;</strong></td>
				  	<td colspan="10">
						<cf_rhempleado agregarEnLista="true">
					</td>
				  </tr>

				  <tr id="DIVfechas">
				  	<td colspan="10">
					<table>
					<td align="left" nowrap><strong>#LB_Fecha_Desde#&nbsp;:&nbsp;</strong></td>
					<td align="left" nowrap><cf_sifcalendario name="FechaDesde" id="FechaDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>
					<td colspan="10">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td align="left" nowrap ><strong>#LB_Fecha_Hasta#&nbsp;:&nbsp;</strong></td>
					<td align="left" nowrap ><cf_sifcalendario name="FechaHasta" id="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>
					</table>
					</td>
				  </tr>
				<tr>
					<td colspan="10">
						<b>Agrupamiento:</b><select name="cmdAgrupado" id="cmdAgrupado">
							<option value=""></option>
						</select><input class="btnNormal" type="button" name="addAgrupado"  id="addAgrupado" onClick="AgregarAgrupado();"   value="+" />
					</td>
				</tr>
				<tr>
					<td colspan="10">
						<table id="ListaAgrupado">
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="10" nowrap>
						<b>Mostrar conteo:</b>
						<input type="checkbox" name="ChkMostrarConteo"  id="ChkMostrarConteo" />
					</td>
				</tr>
				  <tr><td colspan="10">&nbsp;&nbsp;</td></tr>
			 </table>
			</td>
		 </tr>
	</table>
	</center>
	<input name="ECid" id="ECid" type="hidden" value="" size="40" maxlength="40"  tabindex="1">
	<center>
	<input class="btnNormal" type="submit" name="Consultar" value="Consultar" />
	<input class="btnExportar" type="submit" name="ExportarExcel" value="Exportar a Excel" />
	<input class="btnExportar" type="submit" name="ExportarPDF" value="Exportar a PDF" />
	<input class="btnLimpiar"  type="button" name="Limpiar" value="Limpiar" onClick="javascript: document.form1.reset();" />
	</center>
</form>

</body>
</cfoutput>

<script language="JavaScript" type="text/javascript">

		function validarSubmit(){
			if(   $("#radio2").is(':checked')==false && ( $("#FechaDesde").val()=="" || $("#FechaHasta").val()=="" )   ){
				alert("Debe indicar fecha validas");
				return false;
			}
			else{
				return true;
			}
		}


	$(document).ready(function() {

		function CambiarNominas(obj){
			var nomina= document.getElementById("Nomina");
				if(obj.checked){
					nomina.value="1";
				}else{
					nomina.value="0";
				}
				document.form1.action = "";
				document.form1.submit();
		}

		$("#chkCorporativo").click(function() {
		   if($(this).is(':checked')) {
				$("#DIVtipoNomina").hide();
				$("#DIVcalendarioPagos").hide();
				$("#DIVporNomina").hide();
				$("#DIVporNominaTipo").hide();

				$("#DIVporCalendario").hide();
				$("#DIVfechas").show();
		   }
		   else{
				$("#DIVporNomina").show();
				$("#DIVporNominaTipo").show();
				$("#DIVporCalendario").show();
				$("#radio1").click();
		   }
		});

		$("#radio1").click(function() {
				$("#DIVtipoNomina").show();
				$("#DIVfechas").show();
				$("#DIVcalendarioPagos").hide();
		});

		$("#radio2").click(function() {
				$("#DIVfechas").hide();
				$("#DIVtipoNomina").hide();
				$("#DIVcalendarioPagos").show();
		});

		if($("#radio2").is(":checked")){
			$("#radio2").click();
		}


		$("#RHRDEid").change(
				function () {
					ActualizarCombo($(this));
				}
		);


		function ActualizarCombo(elemento){

			$('input.GroupBy').each(function() {
				$(this).parent().remove();
			});

			if($(elemento).val() != ''){

			$.ajax({
				url: "/cfmx/rh/admin/catalogos/RepDinamicos.cfc"
			  , type: "get"
			  , dataType: "json"
			  ,async :false
			  , data: {
				  method: "GetOpcionesFiltrado"
				, RHRDEid: $(elemento).val()
				 }
			  , success: function (data){
				var html = '';
				$.each(data, function(i, item) {
					html =html+ '<option value="' + item.Tipo + '">' + item.Descripcion + '</option>';
				})
					$("#cmdAgrupado").find('option').remove();
					$("#cmdAgrupado").append(html);
			  }
			  // this runs if an error
			  , error: function (xhr, textStatus, errorThrown){
				// show error
					$("#cmdAgrupado").find('option').remove();
			  }
			});

			}
			else{
				$("#cmdAgrupado").find('option').remove();
			}
		}

		ActualizarCombo($("#RHRDEid"));

		$("#chkHistorico").on("change", function(){
			changeNominas(this);
		});

		changeNominas($("#chkHistorico"));

	});

	function AgregarAgrupado(){
			var existe = 0;
			var valorActual = $("#cmdAgrupado").val();
			var textValorActual = $("#cmdAgrupado option:selected").text();

			if($('#ListaAgrupado').length){
				$('input.GroupBy').each(function() {
					if(valorActual == $(this).val()){ existe=1;}
				});
			}
			if(existe == 1){
				alert("Ya agrego este Agrupamiento");
			}
			else{
				if(valorActual == ''){
					alert("Debe un Agrupamiento");
				}
				else{
				   $('#ListaAgrupado').append("<tr><td nowrap='nowrap'><input type='hidden' id='GroupBy' class='GroupBy' name='GroupBy' value='"+valorActual+"'>"+ textValorActual + "<img src='/cfmx/plantillas/Sapiens/css/images/btnEliminar.gif' onclick='QuitarElemento(this)' ></td></tr>");
				}
			}
	}

	function QuitarElemento(elemento){
		$(elemento).parent().parent().remove();
	}

	function changeNominas (chknom) {
		if ($(chknom).is(":checked") ){
			$("#calendarioHistorico").show();
			$("#calendarioActual").hide();
		} else {
			$("#calendarioActual").show();
			$("#calendarioHistorico").hide();
			$("#calendarioHistorico").next().hide();
		}
	}
</script>
