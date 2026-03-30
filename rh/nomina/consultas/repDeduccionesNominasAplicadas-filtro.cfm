<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeDeduccionesNominasAplicadas" Default="Reporte de deducciones n&oacute;minas aplicadas" returnvariable="LB_ReporteDeDeduccionesNominasAplicadas"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" XmlFile="/rh/generales.xml"returnvariable="BTN_Consultar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Debeselecionarunperiodoymes" Default="Debe seleccionar un periodo y mes" returnvariable="MSG_Debeselecionarunperiodoymes"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaRige" Default="Fecha Rige" returnvariable="LB_FechaRige"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaVence" Default="Fecha Vence" returnvariable="LB_FechaVence"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Fecha" Default="Las fechas son requeridas" returnvariable="MSG_Fecha"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Deduccion" Default="Deducci&oacute;n" returnvariable="LB_Deduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Deduccion" Default="Deducción" returnvariable="MSG_Deduccion"/>

	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" Default="Periodo" returnvariable="LB_Periodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" Default="Mes" returnvariable="LB_Mes"/>

<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<cfquery name="rsTipoDeduccion" datasource="#Session.DSN#">
	select TDid, TDcodigo, TDdescripcion 
	from TDeduccion 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReporteDeDeduccionesNominasAplicadas#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">		
		<form name="form1" method="post" action="repDeduccionesNominasAplicadas-form.cfm">
		<cfoutput>
		<table width="89%" cellpadding="3" cellspacing="0" align="center" border="0">			
			<td align="right" width="272"><cf_translate  key="LB_TipoFiltro">Tipo de filtro</cf_translate>:&nbsp;</td>
				<td width="238"><input type="radio" checked onclick="javascript:mostrarTR(1);"  name="Tfiltro" value="1" />
			  <cf_translate  key="RAD_Periodo">Periodo</cf_translate></td>
				<td width="317" >
					<input onclick="javascript:mostrarTR(2);" type="radio" name="Tfiltro" value="2" />
			  <cf_translate  key="RAD_RangodeFechas">Rango de Fechas</cf_translate></td>
				</tr>
					
			<tr  id="TR_Periodo">
				<td width="272" align="right"><b>#LB_Periodo#:&nbsp;</b></td>
				<td width="238"><select name="periodo">
					<option value=""></option>
					<cfloop index="i" from="-5" to="0">
						<cfset vn_anno = year(DateAdd("yyyy", i, now()))>
						<option value="#vn_anno#">#vn_anno#</option>
					</cfloop>
			  </select></td>
			  <cfset paso = 1>	
			</tr>
				
			<tr id="TR_Mes">
				<td align="right"><b>#LB_Mes#:&nbsp;</b></td>
				<td><select name="mes">	<option value=""></option>
					<cfloop query="rsMeses">
						<option value="#rsMeses.Pvalor#">#rsMeses.Pdescripcion#</option>
					</cfloop>
					</select>
			</tr>
			<tr id="TR_FechaDesde" style="display:none">
				<td nowrap align="right"> <strong>#LB_FechaRige#:&nbsp;</strong></td>
				<td><cf_sifcalendario form="form1" tabindex="1" name="FechaDesde"></td>
				<cfset paso = 2>
			</tr>

			<tr id="TR_FechaHasta" style="display:none">
				<td nowrap align="right"> <strong>#LB_FechaVence#:&nbsp;</strong></td>
				<td><cf_sifcalendario form="form1" tabindex="1" name="FechaHasta"></td>
			</tr>
		  </tr>
			<tr>
				<td align="right"><b>#LB_Deduccion#:&nbsp;</b></td>
				<td>
					<!---		
					select name="Deduccion" tabindex="1" >
					<cfloop query="rsTipoDeduccion">
					<option value="#rsTipoDeduccion.TDid#"> #rsTipoDeduccion.TDdescripcion# </option>
					</cfloop>
					</select>
					--->
					<cf_rhtipodeduccion size="60">
				</td>
			</tr>
			<tr>				
				<td colspan="4" align="center">
					<input type="submit" name="btnConsultar" value="#BTN_Consultar#" class="BTNAplicar"></td>
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
	<cfoutput>
	
	objForm.periodo.required = true;
	objForm.periodo.description = '#LB_Periodo#';
	objForm.mes.required = true;
	objForm.mes.description = '#LB_Mes#'

	function mostrarTR(opcion){
		var TR_FechaDesde = document.getElementById("TR_FechaDesde");
		var TR_FechaHasta = document.getElementById("TR_FechaHasta");
		var TR_Periodo	  = document.getElementById("TR_Periodo");
		var TR_Mes	 	  = document.getElementById("TR_Mes");

		switch(opcion){
			case 1:{
				document.form1.FechaDesde.value = '';
				document.form1.FechaHasta.value = '';
				TR_Periodo.style.display = "";
				TR_Mes.style.display = "";
				TR_FechaDesde.style.display  = "none";
				TR_FechaHasta.style.display  = "none";

				objForm.FechaHasta.required = false;
				objForm.FechaDesde.required = false;
				
				objForm.periodo.required = true;
				objForm.periodo.description = '#LB_Periodo#';
				objForm.mes.required = true;
				objForm.mes.description = '#LB_Mes#'
		}
			break;
			case 2:{
				document.form1.periodo.value = ''; 
				document.form1.mes.value 	 = '';
				TR_Periodo.style.display = "none";
				TR_Mes.style.display = "none";
				TR_FechaDesde.style.display  = "";
				TR_FechaHasta.style.display  = "";
	
				objForm.periodo.required 	= false;
				objForm.mes.required 		= false;

				objForm.FechaHasta.required = true;
				objForm.FechaHasta.description = '#LB_FechaRige#';
				objForm.FechaDesde.required = true;
				objForm.FechaDesde.description = '#LB_FechaVence#';
			}
			break;
		}
	}		
	objForm.TDid.required = true;
	objForm.TDid.description = "#MSG_Deduccion#";
		
	</cfoutput>	
</script>
