﻿<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DeseaEliminarLaRelacion"
	Default="Desea eliminar la relación"
	returnvariable="LB_DeseaEliminarLaRelacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Precaucionestarelaciontiene"
	Default="Precaución: esta relación tiene"
	returnvariable="LB_Precaucionestarelaciontiene"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_empleadosDeseaEliminarla?"
	Default="empleados. ¿Desea eliminarla?"
	returnvariable="LB_empleadosDeseaEliminarla"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NoHaAsignadoEmpleadosEnEstaRelacionDeseaAplicarlaDeTodosModos"
	Default="No ha asignado empleados en esta relación. ¿Desea aplicarla de todos modos?"
	returnvariable="LB_NoHaAsignadoEmpleadosEnEstaRelacionDeseaAplicarlaDeTodosModos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DeseaAplicarLaRelacion"
	Default="Desea aplicar la relación"
	returnvariable="LB_DeseaAplicarLaRelacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDeSolicitud"
	Default="Fecha de solicitud"
	returnvariable="LB_FechaDeSolicitud"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CursoSolicitado"
	Default="Curso solicitado"
	returnvariable="LB_CursoSolicitado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Institucion"
	Default="Instituci&oacute;n"
	returnvariable="LB_Institucion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Inicio"
	Default="Inicio"
	returnvariable="LB_Inicio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SeleccionarCurso"
	Default="Seleccionar Curso"
	returnvariable="LB_SeleccionarCurso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SolicitadoPor"
	Default="Solicitado por"
	returnvariable="LB_SolicitadoPor"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Observaciones"
	Default="Observaciones"
	returnvariable="LB_Observaciones"/>


<!--- FIN VARIABLES DE TRADUCCION --->

﻿<cfif isdefined("form.RHRCid") and len(trim(form.RHRCid)) gt 0>
	<cfset Form.modo='CAMBIO'>
</cfif>
<!--- Consultas en modo Cambio --->
<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select rc.RHRCid, rc.Ecodigo, rc.RHRCdescripcion, rc.RHRCfecha, rc.Usucodigosol, rc.DEidsol,
			rc.CFidsol, rc.RHRCestado, rc.Mcodigo, rc.RHCid, rc.RHRCjustificacion, rc.ts_rversion,
			ia.RHIAnombre,
			m.Mnombre,
			c.RHCfdesde,
			c.RHCfhasta
		from RHRelacionCap rc
			left join RHCursos c
				on c.RHCid = rc.RHCid
			left join RHInstitucionesA ia
				on ia.RHIAid = c.RHIAid
			left join RHMateria m
				on m.Mcodigo = rc.Mcodigo
		where rc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and rc.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
	</cfquery>

	<cfif rsForm.RecordCount lte 0>
		<cfset form.RHRCid = "">
		<cfset modo='ALTA'><!--- regresa a modo alta para evitar errores --->
	</cfif>
</cfif>
<cfif modo neq 'ALTA'>	
	<cfquery name="s_emp" datasource="#session.dsn#">
		select  {fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombre
		from DatosEmpleado de
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.DEidsol#" null="#Len(rsForm.DEidsol) eq 0#">
	</cfquery>
	<cfif s_emp.RecordCount Is 0 or Len(Trim(s_emp.nombre)) Is 0>
		<cfquery name="s_emp" datasource="asp">
			select 
			{fn concat({fn concat({fn concat({fn concat(de.Pnombre , ' ' )}, de.Papellido1 )}, ' ' )}, de.Papellido2 )} as nombre
			from Usuario u join DatosPersonales de
				on u.datos_personales = de.datos_personales
			where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Usucodigosol#" null="#Len(rsForm.Usucodigosol) eq 0#">
		</cfquery>
	</cfif>
	<cfquery name="s_cfn" datasource="#session.dsn#">
		select
		{fn concat(CFcodigo,{fn concat(' - ' ,CFdescripcion)})}  as nombre
		from CFuncional 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFidsol#" null="#Len(rsForm.CFidsol) eq 0#">
	</cfquery>

	<cfquery name="rsResultados" datasource="#session.dsn#">
		select count(1) as Cont
		from RHDRelacionCap
		where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
	</cfquery>
</cfif>
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="javascript1.2" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	function funcLimpiar(){
		document.form1.reset();
		//mostrarTabla(<cfif modo neq 'AlTA' and isdefined("rsForm.RHEEtipoeval") and rsForm.RHEEtipoeval eq 'T'>true<cfelse>false</cfif>);
	}
	function funcBaja(){
		return confirm(
		<cfif isdefined("rsResultados") and rsResultados.Cont gt 0>
			'<cfoutput>#LB_Precaucionestarelaciontiene#</cfoutput> <cfoutput>#rsResultados.Cont#</cfoutput> <cfoutput>#LB_empleadosDeseaEliminarla#</cfoutput>'
		<cfelse>
			'¿<cfoutput>#LB_DeseaEliminarLaRelacion#</cfoutput>?'
		</cfif>
		);
	}
<cfif request.autogestion eq 0 or soy_jefe>
	function funcSiguiente(){
		document.form1.SEL.value = "2";
		document.form1.action = "index.cfm";
		return true;
	}
</cfif>
<cfif request.autogestion eq 1>
	function funcAplicar(){
		<cfif soy_jefe and IsDefined('rsResultados.Cont') And rsResultados.Cont eq 0>
		return confirm ( '<cfoutput>#LB_NoHaAsignadoEmpleadosEnEstaRelacionDeseaAplicarlaDeTodosModos#</cfoutput>' );
		<cfelse>
		return confirm ( '¿<cfoutput>#LB_DeseaAplicarLaRelacion#</cfoutput>?' );
		</cfif>
	}
</cfif>
	function funcAlta(){
		<cfif request.autogestion eq 0 or soy_jefe>
		document.form1.params.value = "?SEL=2";
		</cfif>
		return true;
	}
</script>
<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
<div id="layercursos" style="position:absolute; left:500px; top:160px; width:490px; height:492px; z-index:1; border:1px solid black; <cfif Not IsDefined('url.curso')>display:none;</cfif>">
<iframe src="cursos.cfm" name="grupos" width="490" height="490" frameborder="0" scrolling="no" style="margin:0;border:2px solid blue "></iframe>
</div>
<form action="index_sql.cfm" method="post" name="form1">
	<cfoutput>
		<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="4">
	  	<tr>
		    <td rowspan="12">&nbsp;</td>
			<td colspan="3">&nbsp;</td>
		    <td rowspan="12">&nbsp;</td>
		</tr>
		<tr>
			<td width="15%" valign="middle" nowrap><strong>#LB_Descripcion#</strong></td>
			<td colspan="2" valign="middle" width="50%">
				<cfif modo neq 'AlTA' and isdefined("rsForm.RHRCdescripcion") and len(trim(rsForm.RHRCdescripcion)) gt 0>
					<input name="RHRCdescripcion" type="text" value="#rsForm.RHRCdescripcion#" size="50" maxlength="100" tabindex="1">
				<cfelse>
					<input name="RHRCdescripcion" type="text" value="" size="50" maxlength="100" tabindex="1">
				</cfif>
			</td>
		</tr>
	  	<tr>
		  	<td colspan="1" valign="middle" nowrap><strong>#LB_FechaDeSolicitud#</strong></td>
			<td colspan="2" valign="middle">
				<cfif modo neq 'AlTA' and isdefined("rsForm.RHRCfecha") and len(trim(rsForm.RHRCfecha)) gt 0>
					<cf_sifcalendario name="RHRCfecha" value="#LSDateFormat(rsForm.RHRCfecha,'dd/mm/yyyy')#" tabindex="1">
				<cfelse>
					<cf_sifcalendario name="RHRCfecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
				</cfif>
			</td>
	  	</tr>
		<tr>
			<td colspan="1" valign="middle"><strong>#LB_CursoSolicitado#</strong></td>
			<td colspan="2" valign="middle">
				<input type="hidden" name="RHCid" id="RHCid" value="<cfif modo neq 'ALTA'><cfoutput>#HTMLEditFormat(rsForm.RHCid)#</cfoutput></cfif>">
				<input type="hidden" name="Mcodigo" id="Mcodigo" value="<cfif modo neq 'ALTA'><cfoutput>#HTMLEditFormat(rsForm.Mcodigo)#</cfoutput></cfif>">
				<input name="Mnombre" type="text" id="Mnombre" value="<cfif modo neq 'ALTA'><cfoutput>#HTMLEditFormat(rsForm.Mnombre)#</cfoutput></cfif>" size="50" readonly>
			</td>
		</tr>
		<cfif request.autogestion eq 0>
			<tr>
				<td colspan="1" valign="middle">#LB_Institucion#</td>
				<td colspan="2" valign="middle"><input name="RHIAnombre" type="text" id="RHIAnombre" value="<cfif modo neq 'ALTA'><cfoutput>#HTMLEditFormat(rsForm.RHIAnombre)#</cfoutput></cfif>" size="50" readonly></td>
			</tr>
			<tr>
				<td colspan="1" valign="middle">#LB_Inicio#</td>
				<td colspan="2" valign="middle"><input name="RHCfdesde" type="text" id="RHCfdesde" value="<cfif modo neq 'ALTA'><cfoutput>#LSDateFormat(rsForm.RHCfdesde,'DD/MM/YYYY')#</cfoutput></cfif>" size="50" readonly></td>
			</tr>
		</cfif>
		<tr>
		    <td colspan="1" valign="middle">&nbsp;</td>
		    <td colspan="2" valign="middle"><input type="button" name="buscar" id="buscar" value="#LB_SeleccionarCurso# >>" onClick="mostrarGrupos()"></td>
		</tr>
		<cfif modo neq 'ALTA'>
			<tr>
				<td colspan="1" valign="top"><strong>#LB_SolicitadoPor#</strong></td>
				<td colspan="2" valign="top">
					#HTMLEditFormat(s_emp.nombre)#<br>
					#HTMLEditFormat(s_cfn.nombre)#
				</td>
			</tr>
		</cfif>
		<tr>
			<td colspan="1" valign="middle"><strong>#LB_Observaciones# </strong></td>
			<td colspan="2" valign="middle">&nbsp;</td>
		</tr>
		<tr>
	    	<td colspan="4" valign="middle">
			<textarea style="font-family:Arial, Helvetica, sans-serif" name="RHRCjustificacion" cols="90" rows="4" id="RHRCjustificacion"><cfif modo neq 'ALTA'><cfoutput>#HTMLEditFormat(rsForm.RHRCjustificacion)#</cfoutput></cfif></textarea>
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td colspan="4" align="center" valign="middle">
				<input type="hidden" name="SEL" value="">
				<input type="hidden" name="params" value="">
				<cfif modo neq 'AlTA' and isdefined("rsForm.RHRCid") and len(trim(rsForm.RHRCid)) gt 0>
					<input type="hidden" name="RHRCid" value="#rsForm.RHRCid#">
					<input type="hidden" name="RHRCestado" value="#rsForm.RHRCestado#">
				</cfif>
				<cfif modo neq 'ALTA' and isdefined("rsForm.ts_rversion")>
					<cfset ts = "">
					<cfinvoke 
						component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
				</cfif>
				<cfif modo EQ "ALTA">
					<cf_botones values="Limpiar, Agregar" names="Limpiar,Alta" nbspbefore="4" nbspafter="4" tabindex="3">
				<cfelse>
					<cfif request.autogestion eq 0>
						<cf_botones values="Eliminar,Modificar,Siguiente >>" names="Baja,Cambio,Siguiente" nbspbefore="4" nbspafter="4" tabindex="3">
					<cfelseif soy_jefe>
						<cf_botones values="Eliminar,Modificar,Aplicar,Siguiente >>" names="Baja,Cambio,Aplicar,Siguiente" nbspbefore="4" nbspafter="4" tabindex="3">
					<cfelse>
						<cf_botones values="Eliminar,Modificar,Aplicar" names="Baja,Cambio,Aplicar" nbspbefore="4" nbspafter="4" tabindex="3">
					</cfif>
				</cfif>
			</td>
		</tr>
	</table>
</cfoutput>
</form>
﻿﻿<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElValorPara"
	Default="El valor para "
	returnvariable="MSG_ElValorPara"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeContenerSolamenteCaracteresAlfanumericosYLosSiguientesSimbolos"
	Default="debe contener solamente caracteres alfanuméricos,\n y los siguientes símbolos"
	returnvariable="MSG_DebeContenerSolamenteCaracteresAlfanumericosYLosSiguientesSimbolos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Curso"
	Default="Curso"
	returnvariable="LB_Curso"/>
﻿﻿<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDesde"
	Default="Fecha desde"
	returnvariable="LB_FechaDesde"/>
﻿﻿<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descr"
	Default="Descripción"
	returnvariable="LB_Descr"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<script language="javascript1.2" type="text/javascript">
	//inicializa el form
	funcLimpiar()
	qFormAPI.errorColor = "#FFFFCC";
	function _Field_isAlfaNumerico()
	{
		var validchars=" áéíóúabcdefghijklmnñopqrstuvwxyz1234567890/*-+.:,;{}[]|°!$&()=?";
		var tmp="";
		var string = this.value;
		var lc=string.toLowerCase();
		for(var i=0;i<string.length;i++) {
			if(validchars.indexOf(lc.charAt(i))!=-1)tmp+=string.charAt(i);
		}
		if (tmp.length!=this.value.length)
		{
			this.error="<cfoutput>#MSG_ElValorPara#</cfoutput> "+this.description+" <cfoutput>#MSG_DebeContenerSolamenteCaracteresAlfanumericosYLosSiguientesSimbolos#</cfoutput>: (/*-+.:,;{}[]|°!$&()=?).";
		}
	}
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	var objForm = new qForm("form1");
	//objForm.RHPcodigo.description = "Puesto";
	<cfoutput>
	objForm.RHCid.description = "#LB_Curso#";
	objForm.RHRCfecha.description = "#LB_FechaDesde#";
	objForm.RHRCdescripcion.description = "#LB_Descr#";
	objForm.RHRCdescripcion.validateAlfaNumerico();
	//objForm.RHEEtipoeval.description = "Tipo de Evaluación";
	//objForm.TEcodigo.description = "Tabla de Evaluación";
	//objForm.RHPcodigo.required = true;
	objForm.RHCid.required = true;
	objForm.RHRCfecha.required = true;
	objForm.RHRCdescripcion.required = true;
	//objForm.TEcodigo.required = (objForm.RHEEtipoeval.getValue()=='T');
</cfoutput>
	function mostrarGrupos(){
		var width = 600;
		var height = 550;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		window.open('cursos.cfm',"cursos",'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,height='+height+',width='+width+',left='+left+',top='+top);
		<!--- var lyr = document.getElementById?document.getElementById('layercursos'):document.all.layercursos;
		if(lyr.style.display=="none") {
			lyr.style.display="block";
			document.form1.buscar.value = '<< Seleccionar Curso';
		}else{
			lyr.style.display="none";
			document.form1.buscar.value = 'Seleccionar Curso >>';
		} --->
		
	}
	objForm.RHRCdescripcion.obj.focus();
	function seleccionar_curso(RHCid,Mcodigo,Mnombre,RHIAnombre,RHCfdesde,RHCfhasta,RHCcupo,disponible){
		document.form1.RHCid.value = RHCid;
		document.form1.Mcodigo.value = Mcodigo;
		document.form1.Mnombre.value = Mnombre;
		if(document.form1.RHIAnombre)document.form1.RHIAnombre.value = RHIAnombre;
		if(document.form1.RHCfdesde) document.form1.RHCfdesde.value = RHCfdesde;
		mostrarGrupos();	
	}
	function cancelar_curso(){
		mostrarGrupos();	
	}
</script>
