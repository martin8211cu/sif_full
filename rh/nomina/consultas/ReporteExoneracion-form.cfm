<!--- Etiquetas de Traducción --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="JS_PeriodoInicial" Default="Periodo Inicial" 	returnvariable="JS_PeriodoInicial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="JS_MesInicial" Default="Mes Inicial" 	returnvariable="JS_MesInicial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="JS_PeriodoFinal" Default="Periodo Final" 	returnvariable="JS_PeriodoFinal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="JS_MesFinal" Default="Mes Final" 	returnvariable="JS_MesFinal"/>
<!--- Formulario de Filtro por 1)periodos / mes, desde / hasta (REQUERIDOS) y 2)Empleado (OPCIONAL) --->
<cfoutput>
	<form method="post" name="form1" action="ReporteExoneracion-sql.cfm">
		<table width="1%" cellpadding="0" cellspacing="2" align="center">
			<tr id="periodoinicial">
				<td nowrap align="right"><strong><cf_translate  key="LB_PeriodoMesInicial">Periodo /Mes Inicial</cf_translate>:&nbsp;</strong></td>
				<td><cf_rhperiodos name="periodo_inicial">
				<cf_meses name="mes_inicial">
				<span style="font-size='9px';color='red'">* **</span></td>
			</tr>
			<tr id="periodofinal">
				<td nowrap align="right"><strong><cf_translate  key="LB_PeriodoMesFinal">Periodo /Mes Final</cf_translate>:&nbsp;</strong></td>
				<td><cf_rhperiodos name="periodo_final">
				<cf_meses name="mes_final">
				<span style="font-size='9px';color='red'">* **</span></td>
			</tr>
			<tr>
				<td colspan="3"><input type="checkbox" name="chkHistorico" id="chkHistorico" checked onclick="javascript: Verificar();">&nbsp;N&oacute;minas hist&oacute;ricas</td>
			</tr>
			<tr id="chktiponomina">				  
			  	<td colspan="3"><input type="radio" name="radio" id="radio1" value="1" checked="checked" >&nbsp;Por tipo de n&oacute;mina</td>
			</tr>
			<tr id="chktipocalendario">				  
			  	<td colspan="3"><input type="radio"  name="radio" id="radio2" value="2">&nbsp;Por calendario de pago</td>
			</tr>

			<tr id="tiponomina"> 
				<td><strong>Tipo de N&oacute;mina&nbsp;:&nbsp;</strong></td>
				<td>
					<cf_rhtiponomina form="form1" AgregarenLista="true">
				<td>
		  	</tr>
		  	
		  	<tr id="calendariopago" style="display:none">
				<td><strong>Calendario Pago&nbsp;:&nbsp;</strong></td>
				<td id="calendarioHistorico">
					
					<cf_rhcalendariopagos form="form1" index="2" historicos="true" tcodigo="true" AgregarenLista="true"> <span style="font-size='9px';color='red'">* </span>
				<td>
				<td id="calendarioActual" style="display:none">
					<cf_rhcalendariopagos form="form1" index="21" historicos="false" tcodigo="true" AgregarenLista="true"> <span style="font-size='9px';color='red'">* </span>
				<td>
			</tr>
			
			<tr>
				<td align="right"><strong><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</strong></td>
				<td colspan="3"><cf_rhempleado></td>
			</tr>
			<tr>
				<td colspan="4">
					<p style="font-size='9px';color='red'">* <cf_translate  key="LB_requeridos">requeridos</cf_translate>.
					<br>** <cf_translate  key="LB_deben_pertenecer_a_la_misma_tabla_de_renta">deben pertenecer a la misma tabla de renta</cf_translate>.</p>
				</td>
			</tr>

			
		</table>
		<!--- <cf_botones values="Registro"> --->
		<center>
			<input class="btnNormal" type="submit" name="Consultar" onclick="javascript:return funcConsultar();" value="Consultar" />  
			<input class="btnExportar" type="submit" name="ExportarExcel" onclick="javascript:return funcConsultar();" value="Exportar a Excel" />  
			<input class="btnExportar" type="submit" name="ExportarPDF"  onclick="javascript:return funcConsultar();" value="Exportar a PDF" /> 
				
		</center>
	</form>
</cfoutput>
<!--- Valida que sean requeridos los periodos / mes, desde / hasta --->
<cf_qforms>
	<cf_qformsrequiredfield args="periodo_inicial, #JS_PeriodoInicial#">
	<cf_qformsrequiredfield args="mes_inicial, #JS_MesInicial#">
	<cf_qformsrequiredfield args="periodo_final, #JS_PeriodoFinal#">
	<cf_qformsrequiredfield args="mes_final, #JS_MesFinal#">
</cf_qforms>

<script language="JavaScript" type="text/javascript">


	function funcConsultar(){
		objForm.CPid2.required=false;
		objForm.CPid21.required=false;
		if ($("input[name=radio]:checked").val() == 2){
			if($("#chkHistorico").prop('checked') ){id=2;}else{id=21;}		
			if($("#CPid"+id).val()=='' && $("#ListaTcodigoCalendario"+id).length==0){
				objForm["CPid"+id].required=true;
			}
		} 
	}



	$(document).ready(function() {
		objForm.CPid2.description='Calendario de pago';
		objForm.CPid21.description='Calendario de pago';
		$("#radio1").click(function() {
				$("#periodoinicial").show();
				$("#periodofinal").show();
				$("#tiponomina").show();
				$("#calendariopago").hide();
		});


		
		$("#radio2").click(function() {
				$("#periodoinicial").hide();
				$("#periodofinal").hide();
				$("#tiponomina").hide();
				$("#calendariopago").show(); 
		});
		
	});
	function Verificar(){
		if(document.getElementById("chkHistorico").checked==false){
				document.getElementById("calendarioHistorico").style.display='none'
				document.getElementById("calendarioActual").style.display=''; 
		}else{
			document.getElementById("calendarioHistorico").style.display=''
			document.getElementById("calendarioActual").style.display='none'; 

		}
	}

</script> 
