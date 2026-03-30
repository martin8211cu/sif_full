<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteImpuestoEstatalSobreNomina" Default="Reporte Impuesto Estatal Sobre n&oacute;mina" returnvariable="LB_ReporteImpuestoEstatalSobreNomina"/>


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" XmlFile="/rh/generales.xml"returnvariable="BTN_Consultar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Debeselecionarunperiodoymes" Default="Debe seleccionar un periodo y mes" returnvariable="MSG_Debeselecionarunperiodoymes"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DebeDigitarUnValorEntre0Y100" Default="Debe digitar un valor entre 0 y 100" returnvariable="MSG_DebeDigitarUnValorEntre0Y100"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaRige" Default="Fecha Rige" returnvariable="LB_FechaRige"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaVence" Default="Fecha Vence" returnvariable="LB_FechaVence"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Fecha" Default="Las fechas son requeridas" returnvariable="MSG_Fecha"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Deduccion" Default="Deducci&oacute;n" returnvariable="LB_Deduccion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Deduccion" Default="Deducción" returnvariable="MSG_Deduccion"/>


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" Default="Periodo" returnvariable="LB_Periodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mes" Default="Mes" returnvariable="LB_Mes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_GrupoOficina" Default="Grupo de oficinas" returnvariable="LB_GrupoOficina"/>



<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<cfquery name="rsRegistro" datasource="#session.dsn#">
	select o.Ocodigo, o.Odescripcion from oficinas o where o.Ecodigo = #session.Ecodigo# and o.Onumpatronal is not null
</cfquery>

<cfquery name="rsGrupoOf" datasource="#session.dsn#">
	select GOcodigo,GOnombre from AnexoGOficina where Ecodigo = #session.Ecodigo#
</cfquery>

<!---<cfquery name="rsTipoDeduccion" datasource="#Session.DSN#">
	select TDid, TDcodigo, TDdescripcion
	from TDeduccion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>--->


<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReporteImpuestoEstatalSobreNomina#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<form name="form1" method="post" action="repISNNominasAplicadas-form.cfm">
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
				<td width="272" align="right">#LB_Periodo#:</td>
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
				<td align="right">#LB_Mes#:</td>
				<td><select name="mes">	<option value=""></option>
					<cfloop query="rsMeses">
						<option value="#rsMeses.Pvalor#">#rsMeses.Pdescripcion#</option>
					</cfloop>
					</select>
			</tr>
			<tr id="TR_FechaDesde" style="display:none">
				<td nowrap align="right"> #LB_FechaRige#:</td>
				<td><cf_sifcalendario form="form1" tabindex="1" name="FechaDesde"></td>
				<cfset paso = 2>
			</tr>

			<tr id="TR_FechaHasta" style="display:none">
				<td nowrap align="right"> #LB_FechaVence#: </td>
				<td><cf_sifcalendario form="form1" tabindex="1" name="FechaHasta"></td>
			</tr>
		  </tr>
			<tr>
                <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Tipo_de_Nomina">Tipo de nomina:</cf_translate></td>
                <td nowrap>
                    <!--- Tipos de Nómina --->
                    <cf_rhtiponominaCombo index="0" onchange="changeCalculo" combo="True" todas="False">
                </td>
			</tr>
			<tr>
				<td align="right" width="272"><cf_translate  key="LB_TipoFiltro">Tipo de consulta</cf_translate>:&nbsp;</td>
				<td width="238"><input type="radio" checked onclick="javascript:mostrarTRC(1);"  name="Tconsulta" value="1" />
					<cf_translate  key="RAD_Oficina">Oficina</cf_translate></td>
			   <td width="317" >
				   <input  type="radio" name="Tconsulta" onclick="javascript:mostrarTRC(2);" value="2" />
					 <cf_translate  key="RAD_GrupoOficinas">Grupo de oficinas</cf_translate></td>
			</tr>
            <tr id="TR_Oficina">
				<td nowrap align="right">
					Oficina:&nbsp;
				</td>
				<td>
					<cfoutput>
						<select name="codOf" id="codOf" onchange="Archivo();">
							<option value="0">-- Seleccione una opci&oacute;n --</option>
							<cfloop query="rsRegistro">
							 	<option value="#Ocodigo#" ><cf_translate key="CMB_RegistrPatronalOficina">#Odescripcion#</cf_translate></option>
							</cfloop>
						</select>
					</cfoutput>
				</td>
			</tr>
			<tr id="TR_GrupoOficinas" style="display:none">
				<td nowrap align="right">
				  #LB_GrupoOficina#:&nbsp;
				</td>
				<td>
				  <cfoutput>
					<select name="codGrupoOf" id="codGrupoOf">
						<option value="">-- Seleccione una opci&oacute;n</option>
						<cfloop query="rsGrupoOf">
							<option value="#GOcodigo#">#GOnombre#</option>
						</cfloop>
					</select>
				  </cfoutput>
				</td>
			</tr>
			<tr>
				<td align="right" width="272"><cf_translate  key="LB_TipoAgrupacion">Agrupar por</cf_translate>:&nbsp;</td>
				<td width="238"><input type="radio" checked   name="TAgrupacion" value="1" />
					<cf_translate  key="RAD_AEmpleado">Empleado</cf_translate></td>
				<td width="317" >
					 <input  type="radio" name="TAgrupacion"  value="2" />
					  <cf_translate  key="RAD_AOficina">Oficina</cf_translate></td>	
			</tr>
			<tr>
				<td align="right" width="272"><cf_translate  key="LB_CalculoEspecial">Aplica calculo especial</cf_translate>&nbsp;</td>
				<td><input type="checkbox" name="TCalculoEspecial" /> </td>
			</tr>
            <tr>
                <td align="right" nowrap class="fileLabel"><cf_translate key="LB_PorcentajeISN">Porcentaje ISN:</cf_translate></td>
                <td><input 	name="PorceISN"
                        onFocus="this.value=qf(this); this.select();"
                        onBlur="javascript: fm(this,2);"
                        onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
                        style="text-align: right;"
                        type="text"
                        value="#LSNumberFormat(0.00,"999.99")#"
                        size="8" maxlength="6">%</td>
			</tr>
			<tr>
				<td colspan="4" align="center"><input type="submit" name="btnConsultar" value="#BTN_Consultar#" class="BTNAplicar"></td>
			</tr>
			<tr></tr>
		</table>
		<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
		<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
		</cfoutput>
		</form>
		<cf_qforms> <!--- Siempre debe de ir al final despues del </form> --->
	<cf_web_portlet_end>
<cf_templatefooter>


<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>



<script type="text/javascript" language="javascript1.2">
	<cfoutput>

	objForm.periodo.required = true;
	objForm.periodo.description = '#LB_Periodo#';
	objForm.mes.required = true;
	objForm.mes.description = '#LB_Mes#';

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

	function mostrarTRC(opcion){
		switch(opcion){
			case 1:{
				TR_Oficina.style.display = "";
				TR_GrupoOficinas.style.display = "none";
				document.getElementById("codGrupoOf").value="";
				objForm.codGrupoOf.required = false;
			}
			break;
			case 2:{
				TR_Oficina.style.display = "none";
				TR_GrupoOficinas.style.display = "";
				document.getElementById("codOf").value="0";
				objForm.codGrupoOf.required = true;
				objForm.codGrupoOf.description ='#LB_GrupoOficina#';
			}
			break;
		}	
	}
	</cfoutput>
</script>
