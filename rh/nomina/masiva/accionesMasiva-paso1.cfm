<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select rtrim(Tcodigo) as Tcodigo, Tdescripcion
	from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Tdescripcion
</cfquery>

<cfquery name="rsRegimenVacaciones" datasource="#Session.DSN#">
	select RVid, Descripcion
	from RegimenVacaciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Descripcion
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion 
	from Oficinas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Odescripcion
</cfquery>

<cfquery name="rsDeptos" datasource="#Session.DSN#">
	select Dcodigo, Ddescripcion 
	from Departamentos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Ddescripcion
</cfquery>

<cfquery name="rsJornadas" datasource="#Session.DSN#">
	select 	RHJid, 
			{fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion 
	from RHJornadas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Descripcion
</cfquery>

<!----================= TRADUCCION ======================----->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Guardar_y_Continuar"
	Default="Guardar y Continuar"
	returnvariable="BTN_Guardar_y_Continuar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Eliminar"
	Default="Eliminar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Eliminar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Siguiente"
	Default="Siguiente"
	returnvariable="BTN_Siguiente"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_de_que_desea_eliminar_la_accion_masiva"
	Default="¿Está seguro de que desea eliminar la acción masiva?"	
	returnvariable="LB_Esta_seguro_de_que_desea_eliminar_la_accion_masiva"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Tipo_de_accion_masiva"
	Default="Tipo de acción masiva"	
	returnvariable="MSG_Tipo_de_accion_masiva"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"	
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"	
	returnvariable="MSG_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha_Rige"
	Default="Fecha Rige"	
	returnvariable="MSG_Fecha_Rige"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha_Vence"
	Default="Fecha Vence"	
	returnvariable="MSG_Fecha_Vence"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Tipo_de_Nomina"
	Default="Tipo de Nómina"	
	returnvariable="MSG_Tipo_de_Nomina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Regimen_de_Vacaciones"
	Default="Régimen de Vacaciones"	
	returnvariable="MSG_Regimen_de_Vacaciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Oficina"
	Default="Oficina"	
	returnvariable="MSG_Oficina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Departamento"
	Default="Departamento"	
	returnvariable="MSG_Departamento"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Puesto"
	Default="Puesto"	
	returnvariable="MSG_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Porcentaje_de_Plaza"
	Default="Porcentaje de Plaza"	
	returnvariable="MSG_Porcentaje_de_Plaza"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Porcentaje_de_Salario_Fijo"
	Default="Porcentaje de Salario Fijo"	
	returnvariable="MSG_Porcentaje_de_Salario_Fijo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Jornada"
	Default="Jornada"	
	returnvariable="MSG_Jornada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Categoria_Puesto"
	Default="Categoría Puesto"	
	returnvariable="MSG_Categoria_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipos_de_Accion_Masiva"
	Default="Tipos de Acci&oacute;n Masiva"	
	returnvariable="LB_Tipos_de_Accion_Masiva"/>
	
<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="javascript" type="text/javascript">
	function mostrarCampos() {
		var b = document.getElementById("trTipoNomina");
		var c = document.getElementById("trRegimen");
		var d = document.getElementById("trOficina");
		var e = document.getElementById("trDepto");
		var f = document.getElementById("trPuesto");
		var h = document.getElementById("trPorcPlaza");
		var i = document.getElementById("trPorcSal");
		var j = document.getElementById("trJornada");
		var k1 = document.getElementById("trTipoTabla");
		var k2 = document.getElementById("trCategoria");
		var k3 = document.getElementById("trPuestoCat");
		var l = document.getElementById("trLiquidacion");

		// Tipo de Nómina
		if (document.form1.RHTActiponomina.value == '1') {
			if (b) b.style.display = '';
		} else {
			if (b) b.style.display = 'none';
		}
		// Regimen de Vacaciones
		if (document.form1.RHTAcregimenv.value == '1') {
			if (c) c.style.display = '';
		} else {
			if (c) c.style.display = 'none';
		}
		// Oficina
		if (document.form1.RHTAcoficina.value == '1') {
			if (d) d.style.display = '';
		} else {
			if (d) d.style.display = 'none';
		}
		// Departamento
		if (document.form1.RHTAcdepto.value == '1') {
			if (e) e.style.display = '';
		} else {
			if (e) e.style.display = 'none';
		}
		// Puesto
		if (document.form1.RHTAcpuesto.value == '1') {
			if (f) f.style.display = '';
		} else {
			if (f) f.style.display = 'none';
		}
		// Porcentaje de Plaza
		if (document.form1.RHTAcplaza.value == '1') {
			if (h) h.style.display = '';
		} else {
			if (h) h.style.display = 'none';
		}
		// Porcentaje de Salario Fijo
		if (document.form1.RHTAcsalariofijo.value == '1') {
			if (i) i.style.display = '';
		} else {
			if (i) i.style.display = 'none';
		}
		// Jornada
		if (document.form1.RHTAcjornada.value == '1') {
			if (j) j.style.display = '';
		} else {
			if (j) j.style.display = 'none';
		}
		// Categoría del Puesto
		if (document.form1.RHTAccatpaso.value == '1') {
			if (k1) k1.style.display = '';
			if (k2) k2.style.display = '';
			if (k3) k3.style.display = '';
		} else {
			if (k1) k1.style.display = 'none';
			if (k2) k2.style.display = 'none';
			if (k3) k3.style.display = 'none';
		}
		// Permite Liquidacion
		if (document.form1.RHTAidliquida.value == '1') {
			if (l) l.style.display = '';
		} else {
			if (l) l.style.display = 'none';
		}
		validarCampos();
	}
	
	function funcbtnEliminar() {
		<cfoutput>
		return (confirm('#LB_Esta_seguro_de_que_desea_eliminar_la_accion_masiva#'));
		</cfoutput>
	}
</script>

<cfoutput>
	<form name="form1" method="post" style="margin: 0;" action="accionesMasiva-sql.cfm">
	<cfinclude template="accionesMasiva-hiddens.cfm">
	<table width="85%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
	  <tr>
		<td width="40%" height="22" class="fileLabel" nowrap><cf_translate key="LB_Tipo_de_accion_masiva">Tipo de Acci&oacute;n Masiva</cf_translate></td>
		<td height="22" nowrap>
			<cfset valuesArray = ArrayNew(1)>
			<cfif modo EQ "CAMBIO">
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAid)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAcodigo)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAdescripcion)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTid)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.PCid)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAcomportamiento)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAaplicaauto)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAcempresa)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTActiponomina)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAcregimenv)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAcoficina)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAcdepto)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAcplaza)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAcpuesto)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAccomp)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAcsalariofijo)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAccatpaso)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAcjornada)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAidliquida)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAevaluacion)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAnotaminima)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAperiodos)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTAfutilizap)>
				<cfset ArrayAppend(valuesArray, rsDatosAccion.RHTpfijo)>
			</cfif>
			<cf_conlis title="#LB_Tipos_de_Accion_Masiva#"
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
				debug="false">
		</td>
	  </tr>
	  <tr>
		<td height="22" class="fileLabel" nowrap><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
		<td height="22" nowrap>
			<input type="text" name="RHAcodigo" size="10" maxlength="5" value="<cfif modo EQ "CAMBIO">#HTMLEditFormat(rsDatosAccion.RHAcodigo)#</cfif>" />
		</td>
	  </tr>
	  <tr>
		<td height="22" class="fileLabel" nowrap><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
		<td height="22" nowrap>
			<input type="text" name="RHAdescripcion" size="30" maxlength="80" value="<cfif modo EQ "CAMBIO">#HTMLEditFormat(rsDatosAccion.RHAdescripcion)#</cfif>" />
		</td>
	  </tr>
	  <tr>
		<td height="22" class="fileLabel" nowrap><cf_translate key="LB_Fecha_Rige">Fecha Rige</cf_translate></td>
		<td height="22" nowrap>
			<cfset fdesde = "">
			<cfif modo EQ "CAMBIO">
				<cfset fdesde = LSDateFormat(rsDatosAccion.RHAfdesde, 'dd/mm/yyyy')>
			</cfif>
			<cf_sifcalendario form="form1" name="RHAfdesde" value="#fdesde#">
		</td>
	  </tr>
	  <tr id="trFechaVence">
		<td height="22" class="fileLabel" nowrap><cf_translate key="LB_Fecha_Vence">Fecha Vence</cf_translate></td>
		<td height="22" nowrap>
			<cfset fhasta = "">
			<cfif modo EQ "CAMBIO">
				<cfset fhasta = LSDateFormat(rsDatosAccion.RHAfhasta, 'dd/mm/yyyy')>
			</cfif>
			<cf_sifcalendario form="form1" name="RHAfhasta" value="#fhasta#">
		</td>
	  </tr>
	  <tr id="trTipoNomina"<cfif not (modo EQ "CAMBIO" and rsDatosAccion.RHTActiponomina EQ 1)> style="display: none;"</cfif>>
		<td class="fileLabel" width="47%" height="22" nowrap><cf_translate key="LB_Tipo_de_nomina">Tipo de N&oacute;mina</cf_translate></td>
		<td height="22" nowrap>
			<cfoutput>
				<cfif not (modo EQ "CAMBIO" and rsDatosAccion.RHTAcregimenv EQ 1)>
					<cf_rhtiponominaCombo index="0" todas="False">
				<cfelse>	
					<cf_rhtiponominaCombo index="0" query="#rsDatosAccion#" todas="False">
				</cfif>
			</cfoutput>
			<!---<select name="Tcodigo">
			  <cfloop query="rsTiposNomina">
				<option value="#rsTiposNomina.Tcodigo#"<cfif modo EQ "CAMBIO" and rsDatosAccion.Tcodigo EQ rsTiposNomina.Tcodigo> selected</cfif>>#rsTiposNomina.Tdescripcion#</option>
			  </cfloop>
			</select>--->
		</td>
	  </tr>
	  <tr id="trRegimen"<cfif not (modo EQ "CAMBIO" and rsDatosAccion.RHTAcregimenv EQ 1)> style="display: none;"</cfif>>
		<td class="fileLabel" height="22" nowrap><cf_translate key="LB_Regimen_de_vacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
		<td height="22" nowrap>
			<select name="RVid">
			  <cfloop query="rsRegimenVacaciones">
				<option value="#rsRegimenVacaciones.RVid#"<cfif modo EQ "CAMBIO" and rsDatosAccion.RVid EQ rsRegimenVacaciones.RVid> selected</cfif>>#rsRegimenVacaciones.Descripcion#</option>
			  </cfloop>
			</select>
		</td>
	  </tr>
	  <tr id="trOficina"<cfif not (modo EQ "CAMBIO" and rsDatosAccion.RHTAcoficina EQ 1)> style="display: none;"</cfif>>
		<td class="fileLabel" height="22" nowrap><cf_translate key="LB_Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate></td>
		<td height="22" nowrap>
			<select name="Ocodigo" id="Ocodigo">
			  <cfloop query="rsOficinas"> 
				<option value="#rsOficinas.Ocodigo#"<cfif modo EQ "CAMBIO" and rsDatosAccion.Ocodigo EQ rsOficinas.Ocodigo> selected</cfif>>#rsOficinas.Odescripcion#</option>
			  </cfloop> 
			</select>
		</td>
	  </tr>
	  <tr id="trDepto"<cfif not (modo EQ "CAMBIO" and rsDatosAccion.RHTAcdepto EQ 1)> style="display: none;"</cfif>>
		<td class="fileLabel" height="22" nowrap><cf_translate key="LB_Departamento">Departamento</cf_translate></td>
		<td height="22" nowrap>
			<select name="Dcodigo" id="Dcodigo">
			  <cfloop query="rsDeptos"> 
				<option value="#rsDeptos.Dcodigo#"<cfif modo EQ "CAMBIO" and rsDatosAccion.Dcodigo EQ rsDeptos.Dcodigo> selected</cfif>>#rsDeptos.Ddescripcion#</option>
			  </cfloop>
			</select>			
		</td>
		</tr>
	  <tr id="trPuesto"<cfif not (modo EQ "CAMBIO" and rsDatosAccion.RHTAcpuesto EQ 1)> style="display: none;"</cfif>>
		<td class="fileLabel" height="22" nowrap><cf_translate key="LB_Puesto">Puesto</cf_translate></td>
		<td height="22" nowrap>
			<cfif modo EQ "CAMBIO" and Len(Trim(rsDatosAccion.RHPcodigo))>
				<cfquery name="rsPuesto" datasource="#Session.DSN#">
					select x.RHPcodigo, 
								 x.RHPdescpuesto,
								 coalesce(ltrim(rtrim(x.RHPcodigoext)),ltrim(rtrim(x.RHPcodigo))) as RHPcodigoext
					from RHPuestos x
					where x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and x.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDatosAccion.RHPcodigo#">
				</cfquery>
				<cf_rhpuesto name="RHPcodigo" desc="RHPdescpuesto" empresa="#Session.Ecodigo#" query="#rsPuesto#">
			<cfelse>
				<cf_rhpuesto name="RHPcodigo" desc="RHPdescpuesto" empresa="#Session.Ecodigo#">
			</cfif>
		</td>
		</tr>
	  <tr id="trPorcPlaza"<cfif not (modo EQ "CAMBIO" and rsDatosAccion.RHTAcplaza EQ 1)> style="display: none;"</cfif>>
		<td class="fileLabel" height="22" nowrap><cf_translate key="LB_Porcentaje_de_Plaza">Porcentaje de Plaza</cf_translate></td>
		<td height="22" nowrap>
			<input name="RHAporc" type="text" size="8" maxlength="6"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ "CAMBIO" and Len(Trim(rsDatosAccion.RHAporc))>#LSNumberFormat(rsDatosAccion.RHAporc, ',9.00')#<cfelse>100.00</cfif>"> %
		</td>
	  </tr>
	  <tr id="trPorcSal"<cfif not (modo EQ "CAMBIO" and rsDatosAccion.RHTAcsalariofijo EQ 1)> style="display: none;"</cfif>>
		<td class="fileLabel" height="22" nowrap><cf_translate key="LB_Porcentaje_de_Salario_Fijo">Porcentaje de Salario Fijo</cf_translate></td>
		<td height="22" nowrap>
			<input name="RHAporcsal" type="text" size="8" maxlength="6" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ "CAMBIO" and Len(Trim(rsDatosAccion.RHAporcsal))>#LSNumberFormat(rsDatosAccion.RHAporcsal, ',9.00')#<cfelse>100.00</cfif>"> %
		</td>
	  </tr>
	  <tr id="trJornada"<cfif not (modo EQ "CAMBIO" and rsDatosAccion.RHTAcjornada EQ 1)> style="display: none;"</cfif>>
		<td class="fileLabel" height="22" nowrap><cf_translate key="LB_Jornada">Jornada</cf_translate></td>
		<td height="22" nowrap>
			<select name="RHJid" id="RHJid">
			  <cfloop query="rsJornadas">
				<option value="#rsJornadas.RHJid#"<cfif modo EQ "CAMBIO" and rsDatosAccion.RHJid EQ rsJornadas.RHJid> selected</cfif>>#rsJornadas.Descripcion#</option>
			  </cfloop> 
			</select>
		</td>
	  </tr>

	<cfif modo EQ "CAMBIO" and Len(Trim(rsDatosAccion.RHCPlinea))>
	  <cf_rhcategoriapuesto form="form1" query="#rsDatosAccion#" ocultar="#not (modo EQ 'CAMBIO' and rsDatosAccion.RHTAccatpaso EQ 1)#" incluyeTabla="false">
	<cfelse>
	  <cf_rhcategoriapuesto form="form1" ocultar="#not (modo EQ 'CAMBIO' and rsDatosAccion.RHTAccatpaso EQ 1)#" incluyeTabla="false">
	</cfif>

	  <tr id="trLiquidacion"<cfif not (modo EQ "CAMBIO" and rsDatosAccion.RHTAidliquida EQ 1)> style="display: none;"</cfif>>
		<td class="fileLabel" height="22" nowrap><cf_translate key="LB_Permite_liquidacion">Permite Liquidaci&oacute;n</cf_translate></td>
		<td height="22" nowrap>
			<input type="checkbox" name="RHAidliquida" value="1"<cfif modo EQ "CAMBIO" and rsDatosAccion.RHAidliquida EQ 1> checked<cfelseif modo EQ "ALTA"> checked</cfif>/>
		</td>
	  </tr>
	  <tr>
	  	<td colspan="2">&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="2" align="center">			
			<cfif modo EQ "CAMBIO">
				<cf_botones names="btnGuardar,btnEliminar,btnSiguiente" values="#BTN_Guardar_y_Continuar# >>,#BTN_Eliminar#,#BTN_Siguiente# >>">
			<cfelse>
				<!----<cf_botones names="btnGuardar,btnSiguiente" values="Guardar y Continuar >>,Siguiente >>">---->
				<cf_botones names="btnGuardar" values="#BTN_Guardar_y_Continuar# >>">
			</cfif>
		</td>
	  </tr>
	  <tr>
	  	<td colspan="2">&nbsp;</td>
	  </tr>
	</table>
	</form>
</cfoutput>

<cf_qforms>
<script language="javascript" type="text/javascript">
	<cfoutput>
	objForm.RHTAcodigo.required = true;
	objForm.RHTAcodigo.description = "#MSG_Tipo_de_accion_masiva#";
	objForm.RHAcodigo.required = true;
	objForm.RHAcodigo.description = "#MSG_Codigo#";
	objForm.RHAdescripcion.required = true;
	objForm.RHAdescripcion.description = "#MSG_Descripcion#";
	objForm.RHAfdesde.required = true;
	objForm.RHAfdesde.description = "#MSG_Fecha_Rige#";
	objForm.RHAfhasta.required = false;
	objForm.RHAfhasta.description = "#MSG_Fecha_Vence#";

	objForm.Tcodigo.description = "#MSG_Tipo_de_Nomina#";
	objForm.RVid.description = "#MSG_Regimen_de_Vacaciones#";
	objForm.Ocodigo.description = "#MSG_Oficina#";
	objForm.Dcodigo.description = "#MSG_Departamento#";
	objForm.RHPcodigo.description = "#MSG_Puesto#";
	objForm.RHAporc.description = "#MSG_Porcentaje_de_Plaza#";
	objForm.RHAporcsal.description = "#MSG_Porcentaje_de_Salario_Fijo#";
	objForm.RHJid.description = "#MSG_Jornada#";
	objForm.RHCdescripcion.description = "#MSG_Categoria_Puesto#";
	</cfoutput>

	function validarCampos() {
		objForm.Tcodigo.required = (document.form1.RHTActiponomina.value == '1');
		objForm.RVid.required = (document.form1.RHTAcregimenv.value == '1');
		objForm.Ocodigo.required = (document.form1.RHTAcoficina.value == '1');
		objForm.Dcodigo.required = (document.form1.RHTAcdepto.value == '1');
		objForm.RHPcodigo.required = (document.form1.RHTAcpuesto.value == '1');
		objForm.RHAporc.required = (document.form1.RHTAcplaza.value == '1');
		objForm.RHAporcsal.required = (document.form1.RHTAcsalariofijo.value == '1');
		objForm.RHJid.required = (document.form1.RHTAcjornada.value == '1');
		objForm.RHCdescripcion.required = (document.form1.RHTAccatpaso.value == '1');
		objForm.RHAfhasta.required = (document.form1.RHTpfijo.value == '1');
	}
	
	<cfif modo EQ "CAMBIO">
		validarCampos();
	</cfif>
	
	function funcbtnSiguiente(){
		document.form1.paso.value = "2";
	}		
</script>
