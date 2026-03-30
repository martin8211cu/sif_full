<!--- MODO --->
<cfset modocambio = isdefined("form.CVid") and len(form.CVid) and form.CVid>
<!--- CONSULTAS --->
<cfinclude template="../../Utiles/sifConcat.cfm">
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
	and CPPestado in (0,1)
	order by CPPfechaHasta desc, CPPfechaDesde desc
</cfquery>
<cfquery name="rsVersiones" datasource="#Session.dsn#">
  select p.CPPid, p.CPPestado, p.CPPfechaDesde, 
  		(
			select count(1) 
			  from CVersion v
			 where v.Ecodigo 	= p.Ecodigo
			   and v.CPPid 		= p.CPPid
			   and v.CVtipo = '1'
		) as CantidadVersiones_1,
  		(
			select count(1) 
			  from CVersion v
			 where v.Ecodigo 	= p.Ecodigo
			   and v.CPPid 		= p.CPPid
			   and v.CVtipo = '2'
		) as CantidadVersiones_2
	from CPresupuestoPeriodo p
	where p.Ecodigo 	= #session.Ecodigo#
	  
  order by p.CPPid, p.CPPestado, p.CPPfechaDesde
</cfquery>
<cfif modocambio>
	<cfquery name="qry_cv" datasource="#Session.dsn#">
		select Ecodigo, CVid, CVtipo, CVdescripcion, CPPid, CVaprobada, CVestado, ts_rversion
		from CVersion
		where Ecodigo = #session.ecodigo#
		and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
	</cfquery>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#qry_cv.ts_rversion#" returnvariable="ts">
<cfelse>
	<script language="javascript">
		var LvarVersiones = new Object();
		<cfoutput query="rsVersiones">
		LvarVersiones["#CPPid#"] = new Array();
		LvarVersiones["#CPPid#"][1] = "#fnDescripcion (CPPid, 1, CPPfechaDesde, CantidadVersiones_1)#";
		LvarVersiones["#CPPid#"][2] = "#fnDescripcion (CPPid, 2, CPPfechaDesde, CantidadVersiones_2)#";
		</cfoutput>
	</script>
</cfif>
<cffunction name="fnDescripcion" returntype="string" output="false">
	<cfargument name="CPPid"		type="numeric"	required="yes">
	<cfargument name="Tipo"			type="numeric"	required="yes">
	<cfargument name="Fecha"		type="date"		required="yes">
	<cfargument name="Cantidad"		type="numeric"	required="yes">

	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfset LvarVersion = Arguments.Cantidad + 1>
	
	<cfloop condition="true">
		<cfif LvarVersion GT 1000>
			<cfset LvarVer = "V.#right('0000' & (LvarVersion),4)#">
		<cfelse>
			<cfset LvarVer = "V.#right('000' & (LvarVersion),3)#">
		</cfif>
		<cfquery name="rsSQL" datasource="#Session.dsn#">
			select count(1) as cantidad
			  from CVersion v
			 where v.Ecodigo 		= #session.Ecodigo#
			   and v.CPPid 			= #Arguments.CPPid#
			   and v.CVtipo 		= '#Arguments.tipo#'
			   and v.CVdescripcion #_Cat# ' ' like '%#LvarVer# %'
		</cfquery>
		<cfif rsSQL.cantidad EQ 0>
			<cfif Arguments.Tipo EQ 1>
				<cfreturn "Aprobación Presupuesto Ordinario #dateFormat(Arguments.Fecha,'YYYY-MM')# #LvarVer#">
			<cfelse>
				<cfreturn "Modificación Presupuesto Extraordinario #dateFormat(Arguments.Fecha,'YYYY-MM')# #LvarVer#">
			</cfif>
		</cfif>
		<cfset LvarVersion = LvarVersion + 1>
	</cfloop>
</cffunction>
<!--- JAVASCRIPT --->
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	<!--//
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
	//-->
</script>
<!--- FORM --->
<table width="99%"align="center" border="0" cellspacing="0" cellpadding="0" summary="Control de Versiones de Presupuesto">
  <tr><td>&nbsp;</td></tr>
	<tr><td class="subTitulo" align="center">Control de Versiones de Presupuesto</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
    <td valign="top" align="center">
			<form action="/cfmx/sif/presupuesto/versiones/versiones_sql.cfm" method="post" name="form1" onSubmit="javascript:if (window._finalize) return _finalize();">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="50%" nowrap><div align="right"><strong>Tipo&nbsp;:&nbsp;</strong></div></td>
						<td width="50%">
						  <select name="CVtipo" accesskey="1" tabindex="1" id="CVtipo" onChange="javascript:changeCPP(this.value);" <cfif modocambio>disabled</cfif>>
						    <option value="1" <cfif (isDefined("qry_cv.CVtipo") AND 1 EQ qry_cv.CVtipo)>selected</cfif>>Formulación de Aprobación Presupuesto Ordinario</option>
						    <option value="2" <cfif (isDefined("qry_cv.CVtipo") AND 2 EQ qry_cv.CVtipo)>selected</cfif>>Formulación de Modificación Presupuesto Extraordinario</option>
				      </select></td>
					</tr>
					<tr>
						<td nowrap><div align="right"><strong>Per&iacute;odo&nbsp;:&nbsp;</strong></div></td>
						<td>
							<div id="_cpp1" style="display:none;">
								<cfif modocambio>
									<cf_cboCPPid CPPid="CPPid1" value="#qry_cv.CPPid#" disabled="true"
										onChange="document.form1.CPPid.value=this.value;" CPPestado="" tabindex="2" order="asc">
								<cfelse>
									<cf_cboCPPid CPPid="CPPid1"
										onChange="document.form1.CPPid.value=this.value;document.form1.CVdescripcion.value = LvarVersiones[this.value][1];" CPPestado="10" tabindex="2" order="asc">
								</cfif>
							</div>
							<div id="_cpp2" style="display:none;">
								<cfif modocambio>
									<cf_cboCPPid CPPid="CPPid2" value="#qry_cv.CPPid#"  disabled="true"
										onChange="document.form1.CPPid.value=this.value;" CPPestado="" tabindex="2">
								<cfelse>
									<cf_cboCPPid CPPid="CPPid2"
										onChange="document.form1.CPPid.value=this.value;document.form1.CVdescripcion.value = LvarVersiones[this.value][2];" CPPestado="1" tabindex="2">
								</cfif>
							</div>
						</td>
					</tr>
					<tr>
						<td nowrap><div align="right"><strong>Descripci&oacute;n&nbsp;:&nbsp;</strong></div></td>
						<td>
					  <input type="text" name="CVdescripcion" accesskey="3" tabindex="3" id="CVdescripcion" size="80" maxlength="80" value="<cfif isdefined("qry_cv.CVdescripcion")><cfoutput>#qry_cv.CVdescripcion#</cfoutput></cfif>"></td>
					</tr>
					<tr>
						<td nowrap><div align="right"><strong>Etapa&nbsp;:&nbsp;</strong></div></td>
						<td>
								<select name="CVestado" id="CVestado">
									<option value="0" <cfif isdefined("qry_cv.CVestado") and qry_cv.CVestado EQ 0>selected</cfif>>Formulación de Versión Base</option>
									<option value="1" <cfif isdefined("qry_cv.CVestado") and qry_cv.CVestado EQ 1>selected</cfif>>Formulación de Versión de Usuario</option>
									<option value="2" <cfif isdefined("qry_cv.CVestado") and qry_cv.CVestado EQ 2>selected</cfif>>Formulación de Versión Final</option>
								</select>
					</tr>
					<cfif not modocambio>
					<tr>
						<td nowrap><div align="right"><strong>Tipo de Carga:&nbsp;</strong></div></td>
						<td>
							<input type="hidden" name="TipoCarga" id="TipoCarga" value="0">
							<div id="_ori1" style="display:none;">
								<select name="ori1" id="ori1" onChange="javascript:document.form1.TipoCarga.value=this.value;">
									<option value="0">Solo Cargar Cuentas de Mayor Existentes</option>
								</select>
							</div>
							<div id="_ori2" style="display:none;">
								<select name="ori2" id="ori2" onChange="javascript:document.form1.TipoCarga.value=this.value;">
									<option value="0">Solo Cargar Cuentas de Mayor Existentes</option>
									<option value="1">Cargar Montos ya Aprobados durante Período</option>
								</select>
							</div>
						</td>
					</tr>
					</cfif>
				</table>
				<br>
			<cfif session.versiones.formular EQ "V">
				<cfif modocambio>
					<cfif qry_cv.CVaprobada EQ 1>
						<cf_botones modocambio="#modocambio#" tabindex="4" exclude="Baja,Cambio" include="btnRegresar" includevalues="Regresar">
					<cfelse>
						<cf_botones modocambio="#modocambio#" tabindex="4" include="btnRecargar, btnRegresar" includevalues="Recargar Mayores,Regresar">					
					</cfif>
				<cfelse>
					<cf_botones modocambio="#modocambio#" tabindex="4" include="btnRegresar" includevalues="Regresar">
				</cfif>
			<cfelse>
				<cf_botones tabindex="4" values="Regresar">
			</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif isdefined("ts")><cfoutput>#ts#</cfoutput></cfif>">
				<input type="hidden" name="CPPid" value="<cfif isdefined("qry_cv.CPPid")><cfoutput>#qry_cv.CPPid#</cfoutput><cfelseif isdefined("form.CPPid1")><cfoutput>#form.CPPid1#</cfoutput><cfelseif isdefined("form.CPPid2")><cfoutput>#form.CPPid2#</cfoutput></cfif>">
				<input type="hidden" name="CVid" value="<cfif isdefined("qry_cv.CVid")><cfoutput>#qry_cv.CVid#</cfoutput></cfif>">
			</form>
			
		</td>
  </tr>
	<tr><td>&nbsp;</td></tr>
</table>
<!--- QFORMS --->
<script language="javascript" type="text/javascript">
	function funcLimpiar(){
		changeCPP(1);
	}
	
	<!--//
	//Creación, inicilización y definición del objeto Qforms
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
	objForm.CVtipo.description = "#JSStringFormat('Tipo')#";
	objForm.CPPid1.description = "#JSStringFormat('Período')#";
	objForm.CPPid2.description = "#JSStringFormat('Período')#";
	objForm.CVdescripcion.description = "#JSStringFormat('Descripción')#";
	</cfoutput>
	function habilitarValidacion(){
		objForm.optional('CPPid1,CPPid2');
		objForm.required(objForm.CVtipo.getValue()==1?'CVtipo,CPPid1,CVdescripcion':'CVtipo,CPPid2,CVdescripcion');
	}
	function changeCPP(cual){
		var lcpp1 = document.getElementById('_cpp1');
		var lcpp2 = document.getElementById('_cpp2');
		var lcual = cual!=null?cual:document.form1.CVtipo.value;
		lcpp1.style.display = lcual==1?'':'none';
		lcpp2.style.display = lcual==2?'':'none';
		document.form1.CPPid.value = lcual==1?document.form1.CPPid1.value:document.form1.CPPid2.value;
		<cfif NOT modocambio>
		if (document.form1.CPPid.value == "")
			document.form1.CVdescripcion.value = "";
		else
			document.form1.CVdescripcion.value = LvarVersiones[document.form1.CPPid.value][lcual];
		var lori1 = document.getElementById('_ori1');
		var lori2 = document.getElementById('_ori2');
		lori1.style.display = lcual==1?'':'none';
		lori2.style.display = lcual==2?'':'none';
		document.form1.TipoCarga.value = lcual==1?document.form1.ori1.value:document.form1.ori2.value;
		</cfif>
	}	
	function _finalize(){
	}
	function _initialize(){
		changeCPP();
		<cfif not modocambio>
		objForm.CVtipo.obj.focus();
		</cfif>
	}
	_initialize();
	//-->
</script>
