<cfif isdefined("Form.CILResul")>
	<cfset Form.CILcodigo = Form.CILResul>
</cfif>
<cfif isdefined("Url.CILResul") and not isdefined("Form.CILcodigo")>
	<cfset Form.CILcodigo = Url.CILResul>
</cfif>
<cfif isdefined("Url.Extra") and not isdefined("Form.CIEextraordinario")>
	<cfset Form.CIEextraordinario = Url.Extra>
</cfif>


<cfif isdefined("form.CIEcodigo_lista")>
	<cfset Form.CIEcodigo = form.CIEcodigo_lista>
</cfif>
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif not isdefined("Form.modoDet")>
	<cfset modoDet = "ALTA">
</cfif>
<cfif isdefined("Form.CILcodigo") and len(trim(Form.CILcodigo)) neq 0 and not isdefined("form.btnNuevoE")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
	<cfset modoDet="ALTA">
</cfif>

<cfif isdefined("Form.CIEcodigo") and len(trim(Form.CIEcodigo)) neq 0>
	<cfset modoDet="CAMBIO">
</cfif>
<cfif isdefined("Form.btnNuevoE") >
	<cfset modo="ALTA">
	<cfset modoDet="ALTA">
</cfif>

<!--- Consultas --->
<cfif modo EQ "ALTA">
	<cfquery datasource="#Session.DSN#" name="rsCicloLectivo">	
			select convert(varchar,b.CILcodigo) as CILcodigo, rtrim(ltrim(b.CILnombre)) as CILnombre,
			rtrim(ltrim(CILcicloLectivo)) as CILcicloLectivo, 
			CILtipoCalificacion, 
			convert(varchar,b.CILpuntosMax) as CILpuntosMax,
			convert(varchar,b.CILunidadMin) as CILunidadMin,
			convert(varchar,b.CILredondeo) as CILredondeo,
			convert(varchar,b.TEcodigo) as TEcodigo,
			convert(varchar,b.TRcodigo) as TRcodigo,
			convert(varchar,b.PEVcodigo) as PEVcodigo,
			CLTcicloEvaluacion,
			CILtipoCicloDuracion,
			convert(varchar,b.CILhorasLeccion) as CILhorasLeccion,
			TTcodigoMatricula, TTcodigoCurso,
			b.ts_rversion
			from CicloLectivo b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	</cfquery>
</cfif>

<cfif modo NEQ "ALTA">
	<!--- 1. Form Encabezado --->
	<cfquery datasource="#Session.DSN#" name="rsCicloLectivo">
		select convert(varchar,b.CILcodigo) as CILcodigo, rtrim(b.CILnombre) as CILnombre,
			CILcicloLectivo, CLTcicloEvaluacion, CILciclos, CILtipoCalificacion, 
			convert(varchar,b.CILpuntosMax) as CILpuntosMax,
			convert(varchar,b.CILunidadMin) as CILunidadMin,
			convert(varchar,b.CILredondeo) as CILredondeo,
			convert(varchar,b.TEcodigo) as TEcodigo,
			convert(varchar,b.TRcodigo) as TRcodigo,
			convert(varchar,b.PEVcodigo) as PEVcodigo,
			CLTcicloEvaluacion,
			CILtipoCicloDuracion,
			convert(varchar,b.CILhorasLeccion) as CILhorasLeccion,
			TTcodigoMatricula, TTcodigoCurso,
			b.ts_rversion
			from CicloLectivo b
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
		  and b.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#"> 
	</cfquery>

	<cfif modoDet NEQ "ALTA">
		<cfquery datasource="#Session.DSN#" name="rsCicloEvaluacion">
			select 	convert(varchar, b.CIEcodigo) as CIEcodigo,
					convert(varchar, b.CILcodigo) as CILcodigo,
				   	b.CIEnombre,
					b.CIEcorto,
				   	convert(varchar,b.CIEsemanas) as CIEsemanas, 
					convert(varchar,b.CIEvacaciones) as CIEvacaciones, 
				 	b.CIEextraordinario,
					b.CIEsecuencia,
					b.ts_rversion
			from CicloLectivo a, CicloEvaluacion b
			where a.CILcodigo  = b.CILcodigo
			  and b.CIEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIEcodigo#">
			  and b.CILcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CILcodigo#">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
		</cfquery>
	
	</cfif>
</cfif>

<cfquery datasource="#Session.DSN#" name="rsTarifasMatricula">
	Select 	convert(varchar,TTcodigo) as TTcodigoMatricula,
				TTnombre
	from TarifasTipo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	and TTtipo = 1
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsTarifasCurso">
	Select 	convert(varchar,TTcodigo) as TTcodigoCurso,
				TTnombre
	from TarifasTipo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	and TTtipo = 2
</cfquery>
<cfquery datasource="#Session.DSN#" name="rsTablaEvaluacion">
	Select 	convert(varchar,TEcodigo) as TEcodigo,
				TEnombre, TEtipo, ts_rversion
	from TablaEvaluacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
</cfquery>
<cfquery datasource="#Session.DSN#" name="rsCicloLectivoTipo">
	Select CLTcicloEvaluacion , Ecodigo , CLTciclos , CLTsemanas, CLTvacaciones, ts_rversion       
	from CicloLectivoTipo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	order by CLTciclos desc
</cfquery>
<cfquery datasource="#Session.DSN#" name="rsTablaResultado">
	Select 	convert(varchar,TRcodigo) as TRcodigo,
				TRnombre,  ts_rversion
	from TablaResultado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
</cfquery>
<cfquery datasource="#Session.DSN#" name="rsPlanEvaluacion">
	Select 	convert(varchar,PEVcodigo) as PEVcodigo,
				substring(PEVnombre,1,50) as PEVnombre,  ts_rversion
	from PlanEvaluacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
</cfquery>

<cf_templatecss>
<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function irALista() {
		location.href = "CicloLectivo.cfm";
	}
</script>
<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
	botonActual = "";

	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
</script>
<script type="text/javascript">
	function validar() {
		if (new Number(document.form1.CILciclos.value) <  new Number(document.form1.numCiclos.value)) {
			alert("El numero de ciclos que usted digitó, es menor al actual, perderá la última información digitada!!!");
			if (!confirm("Esta seguro (a) que desea continuar ?")) {
				document.form1.CILciclos.value = document.form1.numCiclos.value;
			}
		}	 
	}
</script>

<link href="/cfmx/educ/css/educ.css" rel="stylesheet" type="text/css">
<cf_templatecss>
<form name="form1" method="post" action="CicloLectivo_SQL.cfm" >
    <input name="CILcodigo" id="CILcodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#Form.CILcodigo#</cfoutput></cfif>" type="hidden">
	<input name="numCiclos" id="numCiclos" value="<cfif modo NEQ "ALTA"><cfoutput>#rsCicloLectivo.CILciclos#</cfoutput></cfif>" type="hidden">
  <table width="100%" border="0">
    <tr> 
      <td <cfif modo NEQ "ALTA">colspan="2" </cfif>class="tituloMantenimiento">
	  	<cfif modo EQ "ALTA">
			Nuevo <cfelse>Modificar 
		</cfif>
        Tipo de Ciclo Lectivo</td>
    </tr>
    <tr> 
      <td align="center" <cfif modo NEQ "ALTA">colspan="2" </cfif>valign="top"> 
        <table width="98%" cellpadding="2" cellspacing="2" border="0">
          <tr> 
            <td align="left" nowrap>Tipo de Per&iacute;odo Evaluaci&oacute;n</td>
            <td align="left" nowrap> <cfif modo NEQ 'ALTA'>
                <cfoutput> 
                  <!--- <option value="#rsCicloLectivo.CLTcicloEvaluacion#">#rsCicloLectivo.CLTcicloEvaluacion#</option> --->
                  <b> 
                  <input name="CLTcicloEvaluacion" type="text" class="cajasinbordebn" id="CLTcicloEvaluacion" style="text-align:left" tabindex="-1" value="#rsCicloLectivo.CLTcicloEvaluacion#" size="30" readonly="">
                  </b> </cfoutput> 
                <cfelse>
                <select name="CLTcicloEvaluacion"  id="CLTcicloEvaluacion" onChange="javascript: cambioCicloEvaluacion(this);">
                  <cfoutput query="rsCicloLectivoTipo"> 
                    <option value="#rsCicloLectivoTipo.CLTcicloEvaluacion#" <cfif modo NEQ 'ALTA' and rsCicloLectivoTipo.CLTcicloEvaluacion EQ rsCicloLectivo.CLTcicloEvaluacion>selected</cfif>>#rsCicloLectivoTipo.CLTcicloEvaluacion#</option>
                  </cfoutput> 
                </select>
              </cfif> </td>
          </tr>
          <tr> 
            <td align="left" nowrap>Nombre Tipo Ciclo Lectivo</td>
            <td align="left" nowrap> <input name="CILnombre" type="text" id="CILnombre" size="40" tabindex="1" maxlength="100" onFocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsCicloLectivo.CILnombre#</cfoutput></cfif>"></td>
          </tr>
          <tr> 
            <td width="10%" align="left" nowrap> Etiqueta Ciclo Lectivo</td>
            <td width="39%" align="left" nowrap><input name="CILcicloLectivo" type="text" id="CILcicloLectivo" size="16" tabindex="1" maxlength="15" onFocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsCicloLectivo.CILcicloLectivo#</cfoutput><cfelse>Año Lectivo</cfif>"></td>
          </tr>
          <tr> 
            <td width="10%" align="left" nowrap> <input name="Label_CILciclos" type="text" class="cajasinbordeb" id="Label_CILciclos" style="text-align:left" tabindex="-1" value="Cuatrimestres por Ciclo Lectivo" size="30" readonly=""></td>
            <td width="39%" align="left" nowrap><input name="CILciclos" type="text" id="CILciclos" tabindex="3" size="6" maxlength="6"  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsCicloLectivo.CILciclos#</cfoutput><cfelse>2</cfif>" style="text-align: right;" onBlur="javascript:  validar();"  onFocus="javascript: this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"> 
              <input name="CLTsemanas" type="hidden" id="CLTsemanas" value=""> 
              <input name="CLTvacaciones" type="hidden" id="CLTvacaciones" value=""> 
            </td>
          </tr>
          <tr> 
            <td colspan="7" align="center" nowrap> <strong>Parámetros default 
              para las Materias cursadas en el Tipo de Ciclo Lectivo</strong></td>
          </tr>
          <tr> 
            <td align="left" nowrap>Los Cursos duran</td>
            <td align="left" nowrap> <select name="CILtipoCicloDuracion">
                <option value="E" <cfif rsCicloLectivo.CILtipoCicloDuracion EQ "E">SELECTED</cfif>>Solo 
                un Periodo Evaluacion</option>
                <option value="L" <cfif rsCicloLectivo.CILtipoCicloDuracion EQ "L">SELECTED</cfif>>Todo 
                el Ciclo Lectivo</option>
              </select> </td>
          </tr>
          <tr> 
            <td align="left" nowrap>Aprobación del Curso</td>
            <td align="left" nowrap> <select name="TRcodigo" >
                <cfoutput query="rsTablaResultado"> 
                  <option value="#rsTablaResultado.TRcodigo#" <cfif rsTablaResultado.TRcodigo EQ rsCicloLectivo.TRcodigo>selected</cfif>>#rsTablaResultado.TRnombre# 
                  </option>
                </cfoutput> </select> </td>
          </tr>
          <tr> 
            <td align="left" nowrap>Plan de Evaluaci&oacute;n</td>
            <td align="left" nowrap><select name="PEVcodigo" >
                <cfoutput query="rsPlanEvaluacion"> 
                  <option value="#rsPlanEvaluacion.PEVcodigo#" <cfif rsPlanEvaluacion.PEVcodigo EQ rsCicloLectivo.PEVcodigo>selected</cfif>>#rsPlanEvaluacion.PEVnombre# 
                  </option>
                </cfoutput> </select></td>
          </tr>
          <tr> 
            <td align="left" nowrap>Tipo Calificaci&oacute;n</td>
            <td align="left" nowrap> <select name="CILtipoCalificacion" id="CILtipoCalificacion" tabindex="1" onChange="javascript: cambioTipoCalificacion(this);">
                <option value="1" <cfif modo NEQ 'ALTA' and #rsCicloLectivo.CILtipoCalificacion# EQ 1>selected</cfif>>Porcentaje</option>
                <option value="2" <cfif modo NEQ 'ALTA' and #rsCicloLectivo.CILtipoCalificacion# EQ 2>selected</cfif>>Puntaje</option>
                <option value="T" <cfif modo NEQ 'ALTA' and #rsCicloLectivo.CILtipoCalificacion# EQ 'T'>selected</cfif>>Tabla 
                de Evaluación</option>
              </select></td>
          </tr>
		  <tr > 
            <td align="left" nowrap>&nbsp;</td>
            <td colspan="4" height="25" align="left" nowrap><div style="display: ; margin: 0; "  id="verTipoCalifica">Puntaje 
                M&aacute;ximo 
                <input name="CILpuntosMax" type="text" id="CILpuntosMax" tabindex="3" size="6" maxlength="6"  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsCicloLectivo.CILpuntosMax#</cfoutput></cfif>" style="text-align: right;" onBlur="javascript:fm(this,0); "  onFocus="javascript: this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
                Unidad M&iacute;nima 
                <input name="CILunidadMin" type="text" id="CILunidadMin" tabindex="3" size="6" maxlength="6"  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsCicloLectivo.CILunidadMin#</cfoutput></cfif>" style="text-align: right;" onBlur="javascript:fm(this,2);"  onFocus="javascript: this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
                Redondeo 
                <select name="CILredondeo" id="CILredondeo" tabindex="1">
                  <option value="0" <cfif modo NEQ 'ALTA' and #rsCicloLectivo.CILredondeo# EQ 0>selected</cfif>>Al 
                  más cercano</option>
                  <option value="0.499" <cfif modo NEQ 'ALTA' and #rsCicloLectivo.CILredondeo# EQ 0.499>selected</cfif>>Hacia 
                  arriba</option>
                  <option value="-0.499" <cfif modo NEQ 'ALTA' and #rsCicloLectivo.CILredondeo# EQ -0.499>selected</cfif>>Hacia 
                  abajo</option>
                </select>
              </div>
              <div style="display: ; margin: 0;" id="verTablaEval"> Tabla de Evaluaci&oacute;n 
                <select name="TEcodigo" >
                  <cfoutput query="rsTablaEvaluacion"> 
                    <option value="#rsTablaEvaluacion.TEcodigo#" <cfif rsTablaEvaluacion.TEcodigo EQ rsCicloLectivo.TEcodigo>selected</cfif>>#rsTablaEvaluacion.TEnombre# 
                    </option>
                  </cfoutput> 
                </select>
              </div></td>
          </tr>
          <tr> 
            <td align="left" nowrap>Tipo Tarifa para Matrícula</td>
            <td align="left" nowrap> 
				<select name="TTcodigoMatricula" >
                  <cfoutput query="rsTarifasMatricula"> 
                    <option value="#TTcodigoMatricula#" <cfif modo NEQ 'ALTA' and TTcodigoMatricula EQ rsCicloLectivo.TTcodigoMatricula>selected</cfif>>#TTnombre# 
                    </option>
                  </cfoutput> 
                </select>
			</td>
          </tr>
          <tr> 
            <td align="left" nowrap>Tipo Tarifa por Curso</td>
            <td align="left" nowrap> 
				<select name="TTcodigoCurso" >
                  <cfoutput query="rsTarifasCurso"> 
                    <option value="#TTcodigoCurso#" <cfif modo NEQ 'ALTA' and TTcodigoCurso EQ rsCicloLectivo.TTcodigoCurso>selected</cfif>>#TTnombre# 
                    </option>
                  </cfoutput> 
                </select>
			</td>
          </tr>
        </table>
	  </td>
	</tr>
    <tr> 
      	<td nowrap <cfif modo NEQ "ALTA">colspan="2" </cfif>align="center"> 
			<cfif modo EQ "ALTA">
				<input type="submit" name="btnAgregarE" tabindex="1" value="Agregar" onClick="javascript: setBtn(this); habilitarValidacion();"> 
			<cfelseif modo NEQ "ALTA">
				<input type="submit" name="btnCambiarE" tabindex="1" value="Modificar Ciclo Lectivo" onClick="javascript: setBtn(this); deshabilitarDetalle(); habilitarValidacion(); " >
				<input type="submit" name="btnBorrarE" tabindex="1" value="Borrar Ciclo Lectivo" onClick="javascript: setBtn(this); deshabilitarDetalle(); deshabilitarValidacion(); return confirm('¿Esta seguro(a) que desea borrar este Ciclo Lectivo?')" > 
				<input type="submit" name="btnNuevoE" tabindex="1" value="Nuevo Ciclo Lectivo" onClick="javascript: setBtn(this); deshabilitarDetalle(); deshabilitarValidacion();" >
			</cfif>
			<input type="button" name="btnLista"  tabindex="1" value="Lista de Ciclos Lectivos" onClick="javascript: irALista();">
			&nbsp;&nbsp;&nbsp;
        <!--- <input type="hidden" name="CILpuntosMax" value="">
			<input type="hidden" name="CILunidadMin" value="">
			<input type="hidden" name="CILredondeo" value=""> --->
      </td>
    </tr>
	<cfif modo NEQ "ALTA">
	<tr>
		<td colspan="2"><hr>
		
		</td>
	</tr>
	<tr>
		<td width="70%" valign="top">
			<cfset ts = "">	
			<cfif modo neq "ALTA">
            <cfinvoke 
					component="educ.componentes.DButils"
					method="toTimeStamp"
					returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rsCicloLectivo.ts_rversion#"/>
				</cfinvoke>
			</cfif>
			<input type="hidden" name="timestampE" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
			<cfinvoke 
			 component="educ.componentes.pListas"
			 method="pListaEdu"
			 returnvariable="pListaPlan">
				<cfinvokeargument name="tabla" value="CicloLectivo a, CicloEvaluacion b"/>
				<cfinvokeargument name="columnas" value="substring(b.CIEnombre,1,50) as CIEnombre_lista, convert(varchar,b.CILcodigo) as CILResul, convert(varchar,b.CIEcodigo) as CIEcodigo_lista, convert(varchar,b.CIEsemanas)+' + ' +convert(varchar,b.CIEvacaciones) as semanas, b.CIEextraordinario as Extra, rtrim(ltrim(CIEcorto)) as CIEcorto, CIEsecuencia "/>
				<cfinvokeargument name="desplegar" value="CIEnombre_lista, CIEcorto, semanas, Extra "/>
				<cfinvokeargument name="etiquetas" value="Período Evaluación, Nombre corto, Semanas, Extraordinario"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="a.CILcodigo = #form.CILcodigo# and a.CILcodigo = b.CILcodigo order by b.CIEsecuencia"/>
				<cfinvokeargument name="align" value="left,center,center,center"/>
				<cfinvokeargument name="ajustar" value="N,N,N,N"/>,
				<cfinvokeargument name="irA" value="CicloLectivo.cfm"/>
				<cfinvokeargument name="incluyeForm" value="false"/>
				<cfinvokeargument name="formName" value="form1"/>
				<cfinvokeargument name="debug" value="N"/>
			</cfinvoke>
		</td>
		<td width="30%" valign="top" style="padding-left: 10px">
			<cfif modoDet NEQ "ALTA">
				<table border="0" width="100%" cellpadding="2" cellspacing="2">
					<tr align="center"> 
						<td  colspan="2" class="tituloMantenimiento" > 
							<cfset ts = "">	
							
								<cfinvoke 
									component="educ.componentes.DButils"
									method="toTimeStamp"
									returnvariable="ts">
									<cfinvokeargument name="arTimeStamp" value="#rsCicloEvaluacion.ts_rversion#"/>
								</cfinvoke>
							
							<input type="hidden" name="timestampD" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
							<cfif modoDet EQ "ALTA">
								Nuevo
							<cfelse>
								Modificar 
							</cfif>
							Período
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>Nombre Período:</td>
						<td nowrap> 
							<cfoutput>
								<input name="CIEnombre"  tabindex="2" onFocus="this.select()" type="text"  value="<cfif modoDet NEQ 'ALTA'>#rsCicloEvaluacion.CIEnombre#</cfif>"  size="30" maxlength="30">
								<input type="hidden" name="CIEcodigo" value="<cfif isdefined("form.CIEcodigo") and len(trim(form.CIEcodigo)) neq 0>#form.CIEcodigo#</cfif>">
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>Nombre Corto:</td>
						<td nowrap>
							<cfoutput>
								<input name="CIEcorto_text"  tabindex="2"  onFocus="this.select()" type="text"  value="<cfif modoDet NEQ 'ALTA'>#rsCicloEvaluacion.CIEcorto#</cfif>" size="10" maxlength="5">
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>Semanas lectivas:</td>
						<td nowrap>
							<input name="CIEsemanas"  tabindex="2" type="text"  value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsCicloEvaluacion.CIEsemanas#</cfoutput></cfif>" size="10" maxlength="10"  onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>Semanas vacaciones:</td>
						<td nowrap>
							<input name="CIEvacaciones"  tabindex="2" type="text"  value="<cfif modoDet NEQ 'ALTA'><cfoutput>#rsCicloEvaluacion.CIEvacaciones#</cfoutput></cfif>" size="10" maxlength="10"  onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>Extraordinario:</td>
						<td nowrap><input name="CIEextraordinario" type="checkbox" id="CIEextraordinario" value="1" <cfif modo NEQ 'ALTA' and rsCicloEvaluacion.CIEextraordinario EQ '1'>checked<cfelseif modo EQ 'ALTA'>checked</cfif>>
</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" align="center" nowrap>
							<cfif modoDet EQ "ALTA">
								<!--- <input type="submit" name="btnAgregarD" tabindex="4" value="Agregar Rango" onClick="javascript: setBtn(this); habilitarDetalle(); habilitarValidacion(); " > --->
							<cfelseif modoDet NEQ "ALTA">
								<input type="submit" name="btnCambiarD" tabindex="4" value="Modificar Período" onClick="javascript: setBtn(this); habilitarDetalle(); habilitarValidacion();" > 
								<!---<input type="submit" name="btnBorrarD" tabindex="4" value="Eliminar Rango" onClick="javascript: setBtn(this); deshabilitarValidacion(); deshabilitarDetalle(); return confirm('¿Esta seguro(a) que desea borrar esta Ocurrencia?')" > 
								<input type="submit" name="btnNuevoD" tabindex="4" value="Nuevo Rango" onClick="javascript: setBtn(this); deshabilitarValidacion(); deshabilitarDetalle();" >
								--->
							</cfif>
						</td>
					</tr>
				</table>
			</cfif>			
		</td>
    </tr>
	</cfif>
  </table>
</form>

<script language="JavaScript" type="text/javascript">
	/*function valida(obj){
		if ((obj.value >= 0.01) &&  (obj.value <= 99.99)) 
			return true
		else
		{
			alert('El valor debe ser mayor que 0.01 y menor o igual que 99.99' );
			return false
		}
	}
	*/
	function inicio(){
		var obj = document.getElementById("CILtipoCalificacion");
		cambioTipoCalificacion(obj);
		
		var obj1 = document.getElementById("CLTcicloEvaluacion");
		cambioCicloEvaluacion(obj1);
	}
	
	function cambioTipoCalificacion(obj){
		var connverTipoCalifica 	= document.getElementById("verTipoCalifica");
		var connverTablaEval 	= document.getElementById("verTablaEval");
		
		if(obj.value == '1'){
			document.form1.CILpuntosMax.value = 100;
			document.form1.CILunidadMin.value = 0.01;
			document.form1.CILredondeo.value = "0";
		}
			
		if(obj.value == '2')
			connverTipoCalifica.style.display = "";
		else
			connverTipoCalifica.style.display = "none";
		if(obj.value == 'T')
			connverTablaEval.style.display = "";
		else
			connverTablaEval.style.display = "none";
	}
	
	function cambioCicloEvaluacion(obj){
	  var conCicloEvaluacion = obj.value;
	  var conVocal = conCicloEvaluacion.substring(conCicloEvaluacion.length-1).toUpperCase();
	  conVocal = (conVocal == "A" || conVocal == "E" || conVocal == "I" || conVocal == "O" || conVocal == "U" );
	  var conPlural = conCicloEvaluacion + (conVocal ? "s" : "es");
	  
	  document.getElementById("Label_CILciclos").value = conPlural + " por Ciclo Lectivo";
	  <cfif modo EQ "ALTA">
	    document.getElementById("CILciclos").value = GvarCicloLectivoTipo[conCicloEvaluacion][0];
	    document.getElementById("CILnombre").value = document.getElementById("CILcicloLectivo").value + " en " + conPlural;
	  </cfif>
	  document.getElementById("CLTsemanas").value = GvarCicloLectivoTipo[conCicloEvaluacion][1];
	  document.getElementById("CLTvacaciones").value = GvarCicloLectivoTipo[conCicloEvaluacion][2];
	}

	var GvarCicloLectivoTipo = new Object();
    <cfoutput query="rsCicloLectivoTipo">
		GvarCicloLectivoTipo["#rsCicloLectivoTipo.CLTcicloEvaluacion#"] = new Array("#rsCicloLectivoTipo.CLTciclos#","#rsCicloLectivoTipo.CLTsemanas#","#rsCicloLectivoTipo.CLTvacaciones#");
    </cfoutput>
	inicio();
</script>		  
<script language="JavaScript">
	//Rodolfo Jiménez Jara, SOIN,14/10/2003
	
	function deshabilitarValidacion() {
		objForm.CILnombre.required = false;
		objForm.CILcicloLectivo.required = false;
		objForm.CLTcicloEvaluacion.required = false;
		objForm.CILciclos.required = false;
		objForm.CILpuntosMax.required = false;
		objForm.CILunidadMin.required = false;
		objForm.CILredondeo.required = false;
		objForm.TEcodigo.required = false;
		objForm.TRcodigo.required = false;
		objForm.PEVcodigo.required = false;
		objForm.TTcodigoMatricula.required = false;
		objForm.TTcodigoCurso.required = false;
		//objForm.CILhorasLeccion.required = false;				
	}
	
	function habilitarValidacion() {
		//alert(objForm.obj.CILtipoCalificacion.value);
		objForm.CILnombre.required = true;
		objForm.CILcicloLectivo.required = true;
		objForm.CLTcicloEvaluacion.required = true;
		objForm.CILciclos.required = true;
		if (objForm.obj.CILtipoCalificacion.value == '2') {
			objForm.CILpuntosMax.required = true;
			//objForm.obj.CILpuntosMax.value == objForm.obj.CILpuntosMax_text.value;
			objForm.CILunidadMin.required = true;
			//objForm.obj.CILunidadMin.value == objForm.obj.CILunidadMin_text.value;
			objForm.CILredondeo.required = true;
			//objForm.obj.CILredondeo.value == objForm.obj.CILredondeo_text.value;
		}	
		else if (objForm.obj.CILtipoCalificacion.value == 'T')	{
			objForm.TEcodigo.required = true;
		}
		objForm.TRcodigo.required = true;
		objForm.PEVcodigo.required = true;
		objForm.TTcodigoMatricula.required = true;
		objForm.TTcodigoCurso.required = true;
		//objForm.CILhorasLeccion.required = true;		
	}	
	
	function deshabilitarDetalle() {
		<cfif modoDet EQ "ALTA">
			objForm.CILnombre.required = false;
		</cfif>
		
		<cfif modoDet NEQ "ALTA">
			objForm.CIEsemanas.required = false;
			objForm.CIEvacaciones.required = false;
			objForm.CIEextraordinario.required = false;
		</cfif>
	}

	function habilitarDetalle() {
		<cfif modoDet EQ "ALTA">
			objForm.CILnombre.required = true;
		</cfif>
		//objForm.CIEsemanas.required = true;
		//objForm.CIEextraordinario.required = true;
	}
	
	function __isValida() {	
		//alert(this.obj.form.ExisteTEVequivalente.value);
		if ((new Number(this.obj.form.CILunidadMin.value >= 0.01) && new Number(this.obj.form.CILunidadMin.value) <= 99.99)){
				return true;
		}else{
			this.error = "Valor incorrecto, debe ser mayor que 0.01 y menor o igual que 99.99!";
		}			
 	}
	function __isValidaHorProm() {	
		if(this.value != ''){
			if ((new Number(this.value) >= 0.1) && (new Number(this.value) <= 24)){
					return true;
			}else{
				this.error = "Valor incorrecto, debe ser mayor o igual que 0.1 y menor o igual que 24!";
				this.focus();
			}			
		}
 	}
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isValida", __isValida);
	_addValidator("isValidaHorProm", __isValidaHorProm);	
	objForm = new qForm("form1");

	<cfif modo EQ "ALTA">
		objForm.CILnombre.required = true;
		objForm.CILnombre.description = "Descripción";
		objForm.CILunidadMin.validateValida();
	<cfelseif modo NEQ "ALTA">
		objForm.CILnombre.required = true;
		objForm.CILnombre.description = "Nombre del ciclo lectivo";
		<cfif modoDet EQ "ALTA">
			objForm.CILnombre.required = true;
			objForm.CILnombre.description = "Nombre del ciclo lectivo";
		<cfelseif modoDet NEQ "ALTA">
			objForm.CIEsemanas.required = true;
			objForm.CIEsemanas.description = "Semanas lectivas";
			objForm.CIEvacaciones.required = true;
			objForm.CIEvacaciones.description = "Semanas de vacaciones";
			//objForm.CIEextraordinario.required = true;
			//objForm.CIEextraordinario.description = "extraordinario";
		</cfif>		 
	</cfif>
	objForm.TTcodigoMatricula.required = true;
	objForm.TTcodigoMatricula.description = "Tipo de Tarifa para Matricula";	
	objForm.TTcodigoCurso.required = true;
	objForm.TTcodigoCurso.description = "Tipo de Tarifa para Curso";	

	//objForm.CILhorasLeccion.required = true;
	//objForm.CILhorasLeccion.description = "Horas Promedio por Lección";	
	//objForm.CILhorasLeccion.validateValidaHorProm();
		
</script>