<cfset t = createObject("component", "sif.Componentes.Translate")> 
<cfset LB_TipoFiltro = t.translate('LB_TipoFiltro','Tipo de filtro','/rh/generales.xml')/> 

<cfoutput>
<form action="ReporteExcepcionesPlazaCalendarioPago-sql.cfm" method="post" name="form1">
	<table width="100%" border="0" cellpadding="1" cellspacing="1" class="areaFiltro" align="center"> 
		<!--- Tipo de Filtro --->
		<tr>
	        <td nowrap="nowrap" align="right"><strong>#LB_TipoFiltro#:</strong></td>
	        <td align="left">
	            <select name="TipoFiltro" id="TipoFiltro" onchange="seleccionaFiltro()">
	                <option value="CP">Por Calendarios de Pago</option>
	                <option value="P">Por Plazas</option>
	                <option value="CFD">Centro Funcional y Dependencias</option>
	            </select>  
	        </td>
	    </tr> 
		<!--- Tipo de Nomina --->	
	    <tr class="filtro">
	        <td nowrap="nowrap" align="right"><strong>Tipo de N&oacute;mina:</strong></td>
           	<td align="left"> 
            	<cf_rhtiponominacombo form="form1" tabindex="1">
           	</td>
	    </tr> 
		<!--- Fecha desde --->
	  	<tr class="filtro">
			<td align="right"><strong>Fecha Desde:</strong></td>
			<td align="left">
				<cf_sifcalendario form="form1" value="" name="Fdesde" tabindex="1">
			</td>
		</tr>
		<!--- Fecha hasta --->
		<tr class="filtro">
			<td align="right"><strong>Fecha Hasta:</strong></td>
			<td align="left">
				<cf_sifcalendario form="form1" value="" name="Fhasta" tabindex="1">
			</td>
		</tr>
		
<!--- 		<tr  class="filtro2" valign="baseline">
			<td nowrap align="right">Actividad Empresarial:</td>
			<td align="left">		
        		<cf_ActividadEmpresa etiqueta="" formname="form1" tabindex="1">
			</td>
		</tr> --->
		<tr class="filtro3">
			<td align="right" nowrap>
				<strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong>
			</td>
			<td align="left" colspan="3">
				<cf_rhcfuncional form="form1" tabindex="1">
			</td>
		</tr>
		<tr class="filtro3">
			<td align="right" nowrap><input type="checkbox" name="dependencias" id="dependencias" tabindex="1"></td>
			<td align="left">
				<label for="dependencias" style="font-style:normal; font-variant:normal; font-weight:normal">
					<cf_translate key="LB_Incluir_Dependencias">Incluir Dependencias</cf_translate>&nbsp;
				</label>
			</td>
		</tr>
		<!--- Plazas --->
		<tr class="filtro2">
			<td align="right"><strong>Plaza</strong></td>
			<td align = "left">
				<cf_conlis
			       form="form1"
			       title="Lista de Plazas"
			       campos = "RHPid2,RHPcodigo2,RHPdescripcion2"
			       desplegables = "N,S,S"
			       modificables = "N,S,N"
			       size = "0,15,40"
			       columnas="a.RHPid as RHPid2,a.RHPcodigo as RHPcodigo2,a.RHPdescripcion as RHPdescripcion2"
			       tabla="RHPlazas a
			       inner join RHLineaTiempoPlaza ltp
			        on ltp.RHPid = a.RHPid"
			       desplegar="RHPcodigo2, RHPdescripcion2"
			       etiquetas="Código,Descripción"
			       formatos="S,S"
			       align="left,left"
			       asignar="RHPid2,RHPcodigo2,RHPdescripcion2"
			       filtrar_por="RHPcodigo,RHPdescripcion"
			       asignarformatos="S,S,S">
			</td>
		</tr>
		<!--- Botones --->
		<tr>
			<td colspan="4" align="center"> 
				<input name="btnConsultar" type="submit" value="Consultar">
				<input type="reset" name="Reset" value="Limpiar"> 
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<script type="text/javascript">
		//$('.filtro').hide();
		$('.filtro2').hide();
		$('.filtro22').hide();
		$('.filtro3').hide();
	function seleccionaFiltro()
	{
		var tipoFiltro = document.getElementById("TipoFiltro").value;
		if(tipoFiltro == "CP") {
			$('.filtro2').hide();
			$('.filtro3').hide();
			$('.filtro').show();
		} 
		if(tipoFiltro == "P") {
			$('.filtro').hide();
			$('.filtro3').hide();
			$('.filtro2').show();	
		}
		if(tipoFiltro == "CFD") {
			$('.filtro').hide();
			$('.filtro2').show();
			$('.filtro3').show();
		}
	}
</script>