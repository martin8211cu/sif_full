<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReportedeAccionesMasivas" Default="Reporte de Acciones Masivas" returnvariable="LB_ReportedeAccionesMasivas"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" XmlFile="/rh/generales.xml"returnvariable="BTN_Consultar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaRige" Default="Fecha Desde" returnvariable="LB_FechaRige"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaVence" Default="Fecha Hasta" returnvariable="LB_FechaVence"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Deduccion" Default="Deducci&oacute;n" returnvariable="LB_Deduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Deduccion" Default="Deducción" returnvariable="MSG_Deduccion"/>
	
<cfinvoke component="sif.Componentes.Translate"	method="Translate" Key="MSG_Tipo_de_accion_masiva"	Default="Tipo de acción masiva"	returnvariable="MSG_Tipo_de_accion_masiva"/>

<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="LB_Formato"	Default="Formato"		returnvariable="LB_Formato"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="MSG_DebeSeleccionarUnPuestoParaConsultar"	Default="Debe Seleccionar Un Tipo de Accion Masivo a Consultar"		returnvariable="MSG_DebeSeleccionarUnPuestoParaConsultar"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate"	Key="MSG_Descripcion"	Default="Descripción"		returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate"	Key="MSG_Codigo"Default="Código" returnvariable="MSG_Codigo"/>


<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReportedeAccionesMasivas#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">		
		<form name="form1" method="post" action="repMasivas-form.cfm" onSubmit="return Valida()">
		<cfoutput>
		<table width="89%" cellpadding="3" cellspacing="0" align="center" border="0">			
			<tr id="TR_FechaDesde">
				<td nowrap align="right"> <strong>#LB_FechaRige#:&nbsp;</strong></td>
				<td><cf_sifcalendario form="form1" tabindex="1" name="FechaDesde"></td>
				<cfset paso = 2>
			</tr>

			<tr id="TR_FechaHasta">
				<td nowrap align="right"> <strong>#LB_FechaVence#:&nbsp;</strong></td>
				<td><cf_sifcalendario form="form1" tabindex="1" name="FechaHasta"></td>
			</tr>
		  </tr>
			<tr>
				<td align="right"><b>#MSG_Tipo_de_accion_masiva#:&nbsp;</b></td>
				<td>
					<cfset valuesArray = ArrayNew(1)>
					<cf_conlis title="#MSG_Tipo_de_accion_masiva#" tabindex="1"
					campos = "RHTAid, RHTAcodigo, RHTAdescripcion, RHTid, PCid, RHTAcomportamiento, RHTAaplicaauto, RHTAcempresa, RHTActiponomina, RHTAcregimenv, RHTAcoficina, RHTAcdepto, RHTAcplaza, RHTAcpuesto, RHTAccomp, RHTAcsalariofijo, RHTAccatpaso, RHTAcjornada, RHTAidliquida, RHTAevaluacion, RHTAnotaminima, RHTAperiodos, RHTAfutilizap, RHTpfijo" 
					desplegables = "N,S,S,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N" 
					modificables = "N,S,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N" 
					size = "0,10,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
					valuesArray="#valuesArray#" 
					tabla="RHTAccionMasiva a
							inner join RHTipoAccion b
								on b.RHTid = a.RHTid"
					columnas="a.RHTAid, rtrim(a.RHTAcodigo) as RHTAcodigo, a.RHTAdescripcion, a.RHTid, a.PCid, a.RHTAcomportamiento, a.RHTAaplicaauto, a.RHTAcempresa, a.RHTActiponomina, a.RHTAcregimenv, a.RHTAcoficina, a.RHTAcdepto, a.RHTAcplaza, a.RHTAcpuesto, a.RHTAccomp, a.RHTAcsalariofijo, a.RHTAccatpaso, a.RHTAcjornada, a.RHTAidliquida, a.RHTAevaluacion, a.RHTAnotaminima, a.RHTAperiodos, a.RHTAfutilizap, b.RHTpfijo"
					filtro="a.Ecodigo=#Session.Ecodigo# 
							order by a.RHTAcodigo"
					desplegar="RHTAcodigo, RHTAdescripcion"
					filtrar_por="a.RHTAcodigo, a.RHTAdescripcion"
					etiquetas="#MSG_Codigo#, #MSG_Descripcion#"
					formatos=""
					align="left,left"
					asignar="RHTAid, RHTAcodigo, RHTAdescripcion, RHTid, PCid, RHTAcomportamiento, RHTAaplicaauto, RHTAcempresa, RHTActiponomina, RHTAcregimenv, RHTAcoficina, RHTAcdepto, RHTAcplaza, RHTAcpuesto, RHTAccomp, RHTAcsalariofijo, RHTAccatpaso, RHTAcjornada, RHTAidliquida, RHTAevaluacion, RHTAnotaminima, RHTAperiodos, RHTAfutilizap, RHTpfijo"
					asignarformatos="S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S"
					showEmptyListMsg="true"
					funcion="mostrarCampos"
					debug="false">				</td>
			</tr>
			<tr>
			<td align="right">
					<cfif isdefined('bandera')>
						&nbsp;
					<cfelse>
					<strong>#LB_Formato#:&nbsp;</strong>
					<td>
					<select name="formato" tabindex="1" <!---onchange="javascript: document.form1.submit();"--->>
<!---						<option value="HTML" <cfif isdefined('formato') and formato EQ 'HTML'>selected</cfif>>HTML</option>--->
						<option value="txt" <cfif isdefined('formato') and formato EQ 'txt'>selected</cfif>>Texto</option>
						<option value="FlashPaper" <cfif isdefined('formato') and formato EQ 'FlashPaper'>selected</cfif>>FlashPaper</option>
						<option value="pdf" <cfif isdefined('formato') and formato EQ 'pdf'>selected</cfif>>Adobe PDF</option>
					</select>
					</cfif>
					</td>
			</td>
			</tr>
			<tr>				
				<td colspan="4" align="center">
					<input type="submit" tabindex="1" name="btnConsultar" value="#BTN_Consultar#" class="BTNAplicar"></td>
			</tr>		
			<tr></tr>				
		</table>	
		<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
		<input type="hidden" name="TDidlist" id="TDidlist" value="" tabindex="1">
		<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
		</cfoutput>
		</form>
		<cf_qforms> <!--- Siempre debe de ir al final despues del </form> --->
	<cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript" language="javascript1.2">

	function Valida(){		
		if(document.form1.RHTAcodigo.value == ''){
			alert("<cfoutput>#MSG_DebeSeleccionarUnPuestoParaConsultar#</cfoutput>");
			return false;
		}
	}
	<cfoutput>
	objForm.FechaHasta.required = true;
	objForm.FechaHasta.description = '#LB_FechaRige#';
	objForm.FechaDesde.required = true;
	objForm.FechaDesde.description = '#LB_FechaVence#';
	objForm.Formato.required = true;
	objForm.Formato.description = '#LB_Formato#'
	</cfoutput>	
</script>
