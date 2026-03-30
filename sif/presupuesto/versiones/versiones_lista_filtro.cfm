<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfquery name="qry_cpp" datasource="#Session.dsn#">
		select CPPid, 
		   CPPtipoPeriodo, 
		   CPPfechaDesde, 
		   CPPfechaHasta, 
		   CPPfechaUltmodif, 
		   CPPestado,
		   ((case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end) #_Cat# ': ' #_Cat# 
		   <cf_dbfunction name="to_char" args="CPPfechaDesde" datasource="#session.dsn#"> #_Cat# ' - ' #_Cat#
		   <cf_dbfunction name="to_char" args="CPPfechaHasta" datasource="#session.dsn#"> ) as Descripcion		   
	from CPresupuestoPeriodo
	where Ecodigo = #Session.Ecodigo#
	order by CPPfechaHasta desc, CPPfechaDesde desc
</cfquery>
<form action="/cfmx/sif/presupuesto/versiones/versionesComun.cfm" method="post" name="formFiltro">
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
  <tr>
    <td align="center">
			<label for="FCVtipo"><strong>Tipo&nbsp;:&nbsp;</strong></label>
			<select name="FCVtipo" accesskey="1" tabindex="1" id="FCVtipo" onChange="javascript:document.formFiltro.submit();">
				<option value="0" >Todos</option>
				<option value="1" <cfif (isDefined("form.FCVtipo") AND 1 EQ form.FCVtipo)>selected</cfif>>Formulación de Aprobación Presupuesto Ordinario</option>
				<option value="2" <cfif (isDefined("form.FCVtipo") AND 2 EQ form.FCVtipo)>selected</cfif>>Formulación de Modificación Presupuesto Extraordinario</option>
			</select>
		</td>
		<td>
			<div id="_cpp1" style="display:none;">
				<label for="FCPPid1"><strong>Per&iacute;odo&nbsp;:&nbsp;</strong></label>
				<select name="FCPPid1" accesskey="2" tabindex="2" id="FCPPid1" onChange="javascript:document.formFiltro.FCPPid.value=this.value;this.form.submit()">
					<option value="0" >Todos</option>
					<cfoutput query="qry_cpp">
						<cfif qry_cpp.CPPestado eq 0>
						<option value="#qry_cpp.CPPid#" <cfif (isDefined("form.FCPPid") AND qry_cpp.CPPid EQ form.FCPPid)>selected</cfif>>#qry_cpp.Descripcion#</option>
						</cfif>
					</cfoutput>
				</select>
			</div>
			<div id="_cpp2" style="display:none;">
				<label for="FCPPid2"><strong>Per&iacute;odo&nbsp;:&nbsp;</strong></label>
				<select name="FCPPid2" accesskey="2" tabindex="2" id="FCPPid2" onChange="javascript:document.formFiltro.FCPPid.value=this.value;this.form.submit()">
					<option value="0" >Todos</option>
					<cfoutput query="qry_cpp">
						<cfif qry_cpp.CPPestado eq 1>
						<option value="#qry_cpp.CPPid#" <cfif (isDefined("form.FCPPid") AND qry_cpp.CPPid EQ form.FCPPid)>selected</cfif>>#qry_cpp.Descripcion#</option>
						</cfif>
					</cfoutput>
				</select>
			</div>
		</td>
		<td><input type="hidden" name="FCPPid" value="<cfif isdefined("qry_cv.CPPid")><cfoutput>#qry_cv.CPPid#</cfoutput></cfif>"></td>
  </tr>
</table>
</form>
<script language="javascript" type="text/javascript">
	<!--//
	function changeCPP(cual){
		var lcpp1 = document.getElementById('_cpp1');
		var lcpp2 = document.getElementById('_cpp2');
		var lcual = cual!=null?cual:document.formFiltro.FCVtipo.value;
		lcpp1.style.display = lcual==1?'':'none';
		lcpp2.style.display = lcual==2?'':'none';
		document.formFiltro.FCPPid.value = lcual==1?document.formFiltro.FCPPid1.value:document.formFiltro.FCPPid2.value;
	}
	changeCPP();
	//-->
</script>