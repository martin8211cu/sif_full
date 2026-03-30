
<!--- <cfif isdefined('url.CFpk') and not isdefined('form.CFpk')>
	<cfparam name="form.CFpk" default="#url.CFpk#">
</cfif>

<cfif isdefined("Form.CFpk")and len(trim(Form.CFpk))NEQ 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>
--->

<cfset lvarEcodigos = session.Ecodigo>
<!--- Verifica si esta activa la Probeduria Corporativa --->
<cfquery name="rsEmpresaProv" datasource="#session.DSN#">
    select distinct epc.EPCempresaAdmin
    from DProveduriaCorporativa dpc
        inner join EProveduriaCorporativa epc
            on epc.EPCid = dpc.EPCid
    where DPCecodigo = #session.Ecodigo#
</cfquery>
<cfloop query="rsEmpresaProv">
	<cfquery name="rsProvCorp" datasource="#session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = #rsEmpresaProv.EPCempresaAdmin#
        and Pcodigo=5100
    </cfquery>
	<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
		<cfset lvarEcodigos = ValueList(rsEmpresaProv.EPCempresaAdmin)>
	</cfif>
</cfloop>

<!--- Verifica integracion con RH --->
<cfquery name="rsIntegracion" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
	  and Pcodigo=520
</cfquery>
<!--- Verifica si requiere del Centro Fu --->
<cfquery name="rsRequiereCF" datasource="#Session.DSN#">
	select Pvalor as RequiereCF
	from RHParametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 400
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select
			CFid,
			<cf_dbfunction name="to_char" args="CFid" datasource="#session.dsn#"> as CFpk,
			Ecodigo,
			CFpath,
			CFcodigo,
			Dcodigo,
			Ocodigo,
			CFcorporativo,
			<cf_dbfunction name="to_char" args="RHPid" datasource="#session.dsn#"> as RHPid,
			CFdescripcion,
			CFidresp,
			<cf_dbfunction name="to_char" args="CFidresp" datasource="#session.dsn#"> as CFpkresp,

			CFcuentaaf,
			CFcuentaaf as CFcuentaafform,
			'' as CFcuentaafdesc,
			'' as CFcuentaafcuenta,

			CFcuentaingreso,
			CFcuentaingreso as CFINformato,
			'' as CFINdescripcion,

			CFcuentac,
			CFcuentac as Cformato,
			'' as Cdescripcion,
			'' as Ccuenta,

			CFcuentainventario,
			CFcuentainventario as CFCIformato,
			'' as CFCIdescripcion,

			CFcuentainversion,
			CFcuentainversion as CFAFformato,
			'' as CFAFdescripcion,

			CFcuentagastoretaf, CFcuentaingresoretaf, CFcuentaobras, CFcuentaPatri,

			coalesce(CFuresponsable,0) as CFuresponsable,
			coalesce(CFuaprobado,0) as CFuaprobado,
			coalesce(CFcomprador,0) as CFcomprador,
			coalesce(CFautoccontrato,0) as CFautoccontrato,
			CFpath,
			CFestado,
            FPAEid,
            CFComplemento,
			ts_rversion,
            CFACTransitoria,
			CFcuentatransitoria,
			CFComplementoCtaGastoCS
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
	</cfquery>

	<cfquery name="rsFormGas" datasource="#Session.DSN#">
		select CFcuentac,
				CFcuentac as Cformato,
				'' as Cdescripcion,
				'' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
	</cfquery>

	<cfquery name="rsFormING" datasource="#Session.DSN#">
		select CFcuentaingreso as CFcuentac,
			   CFcuentaingreso as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
	</cfquery>

	<cfquery name="rsFormCI" datasource="#Session.DSN#">
		select CFcuentainventario as CFcuentac,
			   CFcuentainventario as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
	</cfquery>

	<cfquery name="rsFormAF" datasource="#Session.DSN#">
		select CFcuentainversion as CFcuentac,
			   CFcuentainversion as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
	</cfquery>

	<cfquery name="rsActivoFijo" datasource="#Session.DSN#">
		select CFcuentaaf as CFcuentac,
			   CFcuentaaf as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
	</cfquery>

	<cfquery name="rsRetiroGasto" datasource="#Session.DSN#">
		select CFcuentagastoretaf as CFcuentac,
			   CFcuentagastoretaf as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
	</cfquery>

	<cfquery name="rsRetiroIngreso" datasource="#Session.DSN#">
		select CFcuentaingresoretaf as CFcuentac,
			   CFcuentaingresoretaf as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
	</cfquery>

	<cfquery name="rsObras" datasource="#Session.DSN#">
		select CFcuentaobras as CFcuentac,
			   CFcuentaobras as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
	</cfquery>

	<cfquery name="rsPatrimonio" datasource="#Session.DSN#">
		select CFcuentaPatri as CFcuentac,
			   CFcuentaPatri as Cformato,
			   '' as Cdescripcion,
			   '' as Ccuenta
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
	</cfquery>

	<!---<cfquery name="rsCFComplementoCtaGastoCS" datasource="#Session.DSN#">
		select CFComplementoCtaGastoCS as CFCCtaGastoCS
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
	</cfquery>--->

	<!--- Crear los tres querys segun la cuenta, ajusta los alias y ya --->

	<cfquery name="rsNombreCMC" datasource="#Session.DSN#">
		select CMCnombre
		from CMCompradores
		where Ecodigo in(<cfqueryparam cfsqltype="cf_sql_integer" value="#lvarEcodigos#" list="yes">)
		and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFcomprador#">
	</cfquery>

	<cfquery name="rsNombreCMC2" datasource="#Session.DSN#">
		select CMCnombre
		from CMCompradores
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFautoccontrato#">
	</cfquery>

<!---
	<cfif rsForm.RecordCount GT 0 and len(trim(rsForm.CFpkresp)) GT 0>

		<cfquery name="rsNombreCF" datasource="#Session.DSN#">
			select CFid as CFpkresp, CFcodigo as CFcodigoresp, CFdescripcion as CFdescripcionresp from CFuncional
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFpkresp#">
		</cfquery>

		<cfset tieneJefe = true>
	<cfelse>
		<cfset tieneJefe = false>
	</cfif>
--->

	<cfset vCFpkresp = 0 >
	<cfif rsForm.RecordCount GT 0 and len(trim(rsForm.CFpkresp)) GT 0>
		<cfset tieneJefe = true>
		<cfset vCFpkresp = rsForm.CFpkresp >
	<cfelse>
		<cfset tieneJefe = false>
	</cfif>
	<cfquery name="rsNombreCF" datasource="#Session.DSN#">
		select CFid as CFpkresp, CFcodigo as CFcodigoresp, CFdescripcion as CFdescripcionresp from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCFpkresp#">
	</cfquery>

	<!--- Verifica si hay plazas para este centro funcional --->
	<cfquery name="rsPlazasCF" datasource="#Session.DSN#">
		select count(1) as valor
		from RHPlazas p, LineaTiempo lt
		where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
		  and p.RHPid = lt.RHPid
		  and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">  between lt.LTdesde and lt.LThasta
	</cfquery>

	<cfif Len(Trim(rsForm.RHPid)) GT 0 >
		<cfquery name="rsNombrePlazaResponsable" datasource="#Session.DSN#">
			select RHPcodigo, RHPdescripcion from RHPlazas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.RHPid#">
		</cfquery>
	</cfif>
</cfif>

<!---*******************************************************************************  --->

<cfif modo eq "ALTA" and isdefined("Form.CFpk_papa") and len(trim(Form.CFpk_papa))neq 0>

	<cfquery name="rsForm_alta" datasource="#Session.DSN#">
		select
			<cf_dbfunction name="to_char" args="CFid" datasource="#session.dsn#"> as CFpk,
			Ecodigo,
			CFpath,
			CFcodigo,
			Dcodigo,
			Ocodigo,
			CFcorporativo,
			<cf_dbfunction name="to_char" args="RHPid" datasource="#session.dsn#"> as RHPid,
			CFdescripcion,
			<cf_dbfunction name="to_char" args="CFidresp" datasource="#session.dsn#"> as CFpkresp,

			CFcuentaaf,
			CFcuentaaf as CFcuentaafform, 	<!---Formato de cta de activos--->
			'' as CFcuentaafdesc,			<!---Descripcion de cta de activos--->
			'' as CFcuentaafcuenta,			<!---Cuenta de cta de activos--->

			CFcuentaingreso,
			CFcuentaingreso as CFINformato,
			'' as CFINdescripcion,

			CFcuentac,
			CFcuentac as Cformato,
			'' as Cdescripcion,
			'' as Ccuenta,

			CFcuentainventario,
			CFcuentainventario as CFCIformato,
			'' as CFCIdescripcion,

			CFcuentainversion,
			CFcuentainversion as CFAFformato,
			'' as CFAFdescripcion,

			coalesce(CFuresponsable,0) as CFuresponsable,
			coalesce(CFuaprobado,0) as CFuaprobado,
			coalesce(CFcomprador,0) as CFcomprador,
			coalesce(CFautoccontrato,0) as CFautoccontrato,
			ts_rversion
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk_papa#">
	</cfquery>

		<cfif rsForm_alta.RecordCount GT 0 and len(trim(rsForm_alta.CFpkresp)) GT 0>

			<cfquery name="rsNombreCF_alta" datasource="#Session.DSN#">
				select CFid as CFpkresp, CFcodigo as CFcodigoresp, CFdescripcion as CFdescripcionresp from CFuncional
				where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm_alta.CFpkresp#">
			</cfquery>

			<cfset tieneJefe = true>

		<cfelse>
			<cfset tieneJefe = false>
		</cfif>


</cfif>

<!--- ********************************************************************************** --->




<!--- Departamentos--->
<cfquery name="rsDepartamentos" datasource="#session.DSN#">
	select Dcodigo, Ddescripcion,Deptocodigo
	from Departamentos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Deptocodigo
</cfquery>

<!--- Oficinas --->
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Ocodigo, Odescripcion,Oficodigo
	from Oficinas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Oficodigo
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SePresentaronLosSiguientesErrores"
	Default="Se presentaron los siguientes errores"
	returnvariable="MSG_SePresentaronLosSiguientesErrores"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCodigoDelCentroFuncionalEsRequerido"
	Default="El código del centro funcional es requerido"
	returnvariable="MSG_ElCodigoDelCentroFuncionalEsRequerido"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCentroFuncionalResponsableEsRequerido"
	Default="El centro funcional Responsable es requerido"
	returnvariable="MSG_ElCentroFuncionalResponsableEsRequerido"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LaDescripcionDelCentroFuncionalEsRequerida"
	Default="La descripción del centro funcional es requerida"
	returnvariable="MSG_LaDescripcionDelCentroFuncionalEsRequerida"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LaOficinaEsRequerida"
	Default="La oficina es requerida"
	returnvariable="MSG_LaOficinaEsRequerida"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElDepartamentoEsRequerido"
	Default="El departamento es requerido"
	returnvariable="MSG_ElDepartamentoEsRequerido"/>


<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_EMPLEADO"
						Default="Empleado(a)"
						returnvariable="MSG_EMPLEADO"/>


<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_ENCARGADONOASIGNADO"
						Default="No hay encargado asignado"
						returnvariable="MSG_ENCARGADONOASIGNADO"/>

<script language="JavaScript1.2" >
function regresa()
{
	location.href ="/cfmx/sif/ad/catalogos/CFuncional.cfm";
}

var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisResponsables() {
		popUpWindow("/cfmx/rh/Utiles/ConlisCFuncional.cfm?form=form1&id=CFpkresp&name=CFpkrespnom",250,200,400,300);
	}

	function doConlisCompradores() {
		popUpWindow("ConlisCompradores.cfm?formulario=form1&CMCid=CFcomprador&desc=CMCnombre",250,200,600,500);
	}
	function doConlisCompradores2() {
		popUpWindow("ConlisCompradores.cfm?formulario=form1&CMCid=CFautoccontrato&desc=CMCnombre2",250,200,600,500);
	}

	var boton = "";
	function setBtn(button){
		boton = button.name;
	}

	function valida(form){
		var mensaje = "<cfoutput>#MSG_SePresentaronLosSiguientesErrores#</cfoutput>:\n\n";
		var salir = false;
		if ( boton != 'Eliminar' && boton != 'Nuevo' && boton != 'Exportar' && boton!='Importar' && boton != 'Reporte' /*&& boton != 'btnRegresar'*/){
			if (!salir && form.CFcodigo.value == ""){
				mensaje = mensaje + "<cfoutput>#MSG_ElCodigoDelCentroFuncionalEsRequerido#</cfoutput>.\n";
				salir = true;
			}
			if (!salir && form.CFdescripcion.value == ""){
				mensaje = mensaje + "<cfoutput>#MSG_LaDescripcionDelCentroFuncionalEsRequerida#</cfoutput>.\n";
				salir = true;
			}
		<cfif NOT (modo NEQ "ALTA" AND isdefined("rsCFraiz") and rsCFraiz.CFid EQ rsForm.CFpk)>
			if (!salir && form.CFpkresp.value == ""){
				mensaje = mensaje + "<cfoutput>#MSG_ElCentroFuncionalResponsableEsRequerido#</cfoutput>.\n";
				salir = true;
			}
		</cfif>
			if (!salir && form.Ocodigo.value == ""){
				mensaje = mensaje + "<cfoutput>#MSG_LaOficinaEsRequerida#</cfoutput>.\n";
				salir = true;
			}
			if (!salir && form.Dcodigo.value == ""){
				mensaje = mensaje + "<cfoutput>#MSG_ElDepartamentoEsRequerido#</cfoutput>.\n";
				salir = true;
			}

			/* =========================================== */
			/* FUNCION PARA ARMAR LOS DATOS DE LAS CUENTAS */
			if (window.FrameFunction) FrameFunction();
			/* =========================================== */


			if (salir) alert(mensaje);
			return !salir;
		}
		return true;
	}
</script>

<cfset pintarPlaza = false >
<cfif isdefined("validaPresupuesto") and (validaPresupuesto.recordcount gt 0 and trim(validaPresupuesto.Pvalor) eq 1) >
	<cfset pintarPlaza = true >
</cfif>

<form action="SQLCFuncional.cfm" method="post" name="form1" onSubmit="javascript: return valida(this);">
  	<cfoutput>
		<cfif modo neq 'ALTA'>
			<input type="hidden" name="CFpath" value="#trim(rsForm.CFpath)#">
		</cfif>

 	<center>
	<table border="0" cellspacing="1" cellpadding="0">
			<tr>
				<td align="left"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:</td>
				<td  valign="middle" nowrap>
					<input name="CFcodigo" type="text" id="CFcodigo"
						value="<cfif modo NEQ "ALTA">#trim(rsForm.CFcodigo)#</cfif>"
						size="12" maxlength="10" tabindex="1" onFocus="javascript:this.select();">				</td>
			</tr>

			<tr>
				<td align="left"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:</td>
				<td  valign="middle">
					<input name="CFdescripcion" type="text" id="CFdescripcion" size="40" maxlength="60"
						   value="<cfif modo NEQ "ALTA">#HTMLEditFormat(rsForm.CFdescripcion)#</cfif>" tabindex="1"
						   onFocus="javascript:this.select();">
					<input type="hidden" name="CFpk" value="<cfif modo NEQ "ALTA">#rsForm.CFpk#</cfif>">				</td>
			</tr>

			<tr>
				<td align="left"><cf_translate key="LB_Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate>:</td>
				<td valign="middle">
					<cfif modo NEQ "ALTA" and rsPlazasCF.valor GT 0>
						<cfset descripcion = "">
						<cfloop query="rsOficinas">
							 <cfif rsForm.Ocodigo EQ rsOficinas.Ocodigo ><cfset descripcion = rsOficinas.Odescripcion> <cfset cod= rsOficinas.Oficodigo></cfif>
						</cfloop>
						<input type="hidden" name="Ocodigo" value="#rsForm.Ocodigo#">
						#cod# - #descripcion#
						<label></label>
					<cfelse>
						<select name="Ocodigo" tabindex="1" >
							<cfloop query="rsOficinas">
								<option value="#rsOficinas.Ocodigo#" <cfif modo neq 'ALTA' and (rsForm.Ocodigo eq rsOficinas.Ocodigo) >
										selected</cfif> >
									#rsOficinas.Oficodigo# - #rsOficinas.Odescripcion#								</option>
							</cfloop>
						</select>
					</cfif>				</td>
			</tr>

			<tr>
			<td align="left"><cf_translate key="LB_Departamento" XmlFile="/rh/generales.xml">Departamento</cf_translate>:</td>
				<td valign="middle">
					<cfif modo NEQ "ALTA" and rsPlazasCF.valor GT 0>
						<cfset descripcion = "">
						<cfloop query="rsDepartamentos">
							 <cfif rsForm.Dcodigo EQ rsDepartamentos.Dcodigo ><cfset descripcion = rsDepartamentos.Ddescripcion ></cfif>				 				</cfloop>
						<input type="hidden" name="Dcodigo" value="#rsForm.Dcodigo#">
						<label></label>
					<cfelse>
						<select name="Dcodigo" tabindex="1">
							<cfloop query="rsDepartamentos">
								<option value="#rsDepartamentos.Dcodigo#"
										<cfif modo neq 'ALTA' and (rsForm.Dcodigo eq rsDepartamentos.Dcodigo) >selected</cfif> >
									#rsDepartamentos.Deptocodigo# - #rsDepartamentos.Ddescripcion#								</option>
							</cfloop>
						</select>
					</cfif>				</td>
			</tr>
			<tr>
				<td align="left"><cf_translate key="LB_CentroResponsable">Centro responsable</cf_translate>:</td>
				<td  valign="middle" nowrap>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_SeleccioneElCentroFuncionalResponsable"
						Default="Seleccione el Centro Funcional Responsable"
						returnvariable="MSG_SeleccioneElCentroFuncionalResponsable"/>

					<cfif modo NEQ "ALTA" AND isdefined("rsCFraiz") and rsCFraiz.CFid EQ rsForm.CFpk>
						<cfif isdefined("es_corporativo") and es_corporativo >
							<cf_translate key="LB_PrimerNivel">PRIMER NIVEL</cf_translate> <input type="hidden" name="CFpkresp" value="">
						<cfelse>
							<cf_rhcfuncionalcorp tabindex="1" form="form1" size="30" id="CFpkresp" name="CFcodigoresp" desc="CFdescripcionresp"
														titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" query="#rsNombreCF#" >
						</cfif>

					<cfelseif modo neq 'ALTA' and tieneJefe>
						<cf_rhcfuncional tabindex="1" form="form1" size="30" id="CFpkresp" name="CFcodigoresp" desc="CFdescripcionresp"
							titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" excluir="#Form.CFpk#" query="#rsNombreCF#" >
					<cfelseif modo neq 'ALTA'>
						<cf_rhcfuncional tabindex="1" form="form1" size="30" id="CFpkresp" name="CFcodigoresp" desc="CFdescripcionresp"
							titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" excluir="#Form.CFpk#" >

					<cfelseif modo eq 'ALTA' and isdefined("tieneJefe") and tieneJefe>
						<!---
						<cf_rhcfuncional form="form1" size="30" id="CFpkresp" name="CFcodigoresp" desc="CFdescripcionresp"
							titulo="Seleccione el Centro Funcional Responsable" excluir="#Form.CFpk_papa#" query="#rsNombreCF_alta#" >
							--->
						<!--- [02/01/2006] : Si agrego un CF nuevo (A) e inmediatamente agrego un CF nuevo (B) y quiero asignar como padre
								   de B a A, este conlis que esta comentado nunca me muestra el regitro A. Por eso se quitan los parametros
								   excluir y query.
						--->
						<cf_rhcfuncional tabindex="1" form="form1" size="30" id="CFpkresp" name="CFcodigoresp" desc="CFdescripcionresp"
							titulo="#MSG_SeleccioneElCentroFuncionalResponsable#">

					<cfelse>
						<cf_rhcfuncional tabindex="1" form="form1" size="30" id="CFpkresp" name="CFcodigoresp" desc="CFdescripcionresp"
							titulo="#MSG_SeleccioneElCentroFuncionalResponsable#" excluir="-1">
					</cfif>
					<!---
					<input name="RHPid" type="hidden" id="RHPid"
						   value="<cfif isDefined("Form.RHPid") and Len(Trim(rsForm.RHPid)) GT 0 >#rsForm.RHPid#</cfif>">--->			  </td>
			</tr>

			<cfif not pintarPlaza >
			<tr>
				<td align="left">
					<cfif modo NEQ "ALTA" and Len(Trim(rsForm.RHPid)) GT 0 >
						<cf_translate key="LB_PlazaResponsable">Plaza responsable</cf_translate>:
					</cfif>				</td>
				<td valign="middle">
					<label>


					<!---  permite obtener el nombre del encargado de la plaza --->

					<cfif isdefined("Form.CFpk") and len(trim(#Form.CFpk#)) GT 0>
						<cf_dbfunction name="OP_concat"	args=""  datasource="#session.DSN#" returnvariable="_cat" >
					<!--- permite obtener el encargado del centro funcional a partir de la plaza asignada--->


						<cfquery name="rsResponsable" datasource="#session.DSN#">
							select de.DEnombre #_cat# ' '#_cat# de.DEapellido1 #_cat# ' '#_cat# de.DEapellido2 as nombre
							from LineaTiempo lt inner join DatosEmpleado de on lt.DEid=de.DEid
							where  RHPid=(select RHPid from CFuncional
							where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#"> )
							and  <cf_dbfunction name="today"	datasource="#session.DSN#"> between lt.LTdesde and lt.LThasta
						</cfquery>

						<cfset varNombreEncargado="#MSG_EncargadoNoAsignado#">

						<cfif len(trim(rsResponsable.nombre)) GT 0 and rsResponsable.RecordCount gt 0>
						<cfset varNombreEncargado="">
							<cfloop query="rsResponsable">
								<cfset varNombreEncargado=varNombreEncargado  &"- " &"#nombre#">
							</cfloop>
						</cfif>

					</cfif>
					<!--- fin del proceso obtencion de nombre a partir de la plaza encargada--->


						<cfif modo NEQ "ALTA" and Len(Trim(rsForm.RHPid)) GT 0 >

								#rsNombrePlazaResponsable.RHPcodigo# - #rsNombrePlazaResponsable.RHPdescripcion# <cfif isdefined("Form.CFpk") and len(trim(#Form.CFpk#)) GT 0> <br />#MSG_EMPLEADO#: #varNombreEncargado# </cfif>

						</cfif>
					</label>				</td>
			</tr>
			</cfif>

			<cfif pintarPlaza >
				<tr>
					<td ><cf_translate key="RAD_PlazaResponsable">Plaza responsable</cf_translate>:</td>
					<td >
							<cfset datos = arraynew(1) >
							<cfset datos[1] = '' >
							<cfset datos[2] = '' >
							<cfset datos[3] = '' >
							<cfif modo neq 'ALTA' and len(trim(rsForm.RHPid)) >
								<cfquery name="plaza" datasource="#session.DSN#">
									select RHPid, RHPcodigo, RHPdescripcion
									from RHPlazas
									where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.RHPid#">
									and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								</cfquery>
								<cfset datos[1] = plaza.RHPid >
								<cfset datos[2] = trim(plaza.RHPcodigo) >
								<cfset datos[3] = trim(plaza.RHPdescripcion) >
							</cfif>

							<table cellpadding="0" cellspacing="0">
								<tr>
									<td><input type="radio" name="radioResponsable" value="P" <cfif (modo eq 'ALTA') or (isdefined("rsForm") and len(trim(rsForm.RHPid))) or (isdefined("rsForm") and len(trim(rsForm.RHPid)) eq 0 and rsForm.CFuresponsable eq 0 )>checked="checked"</cfif> /></td>
									<td>
										<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="LB_Codigo"
											Default="C&oacute;digo"
											XmlFile="/rh/generales.xml"
											returnvariable="LB_Codigo"/>
										<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="LB_Descripcion"
											Default="Descripci&oacute;n"
											XmlFile="/rh/generales.xml"
											returnvariable="LB_Descripcion"/>
										<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="LB_NoSeEncontraronPlazas"
											Default="No se encontraron Plazas"
											returnvariable="LB_NoSeEncontraronPlazas"/>
										<cf_conlis
											campos="RHPid, RHPcodigo, RHPdescripcion"
											desplegables="N,S,S"
											modificables="N,S,N"
											size="0,10,35"
											title="Lista de Plazas"
											tabla="RHPlazas"
											columnas="RHPid, RHPcodigo, RHPdescripcion"
											filtro="Ecodigo=#SESSION.ECODIGO# and RHPactiva=1 order by RHPcodigo"
											desplegar="RHPcodigo, RHPdescripcion"
											filtrar_por="RHPcodigo, RHPdescripcion"
											etiquetas="#LB_Codigo#, #LB_Descripcion#"
											formatos="S,S"
											align="left,left"
											asignar="RHPid, RHPcodigo, RHPdescripcion"
											asignarformatos="S, S, S"
											showEmptyListMsg="true"
											EmptyListMsg="#LB_NoSeEncontraronPlazas#"
											valuesarray="#datos#">									</td>
									<td>
										<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="LB_LimpiarPlazaResponsable"
											Default="Limpiar Plaza Responsable"
											returnvariable="LB_LimpiarPlazaResponsable"/>
										<img style="cursor:hand; " src="/cfmx/rh/imagenes/delete.small.png"
										   alt="#LB_LimpiarPlazaResponsable#" name="imagenLimpiarPR" width="16" height="16"
										   border="0" align="absmiddle"
										   onClick="javascript: document.form1.RHPid.value = ''; document.form1.RHPcodigo.value = '';document.form1.RHPdescripcion.value = '';">									</td>
								</tr>
							</table>					</td>
				</tr>
			</cfif>

			<!---<cfif rsIntegracion.RecordCount gt 0 and rsIntegracion.Pvalor eq 'N'>--->
				<tr>
					<td nowrap align="left"><cf_translate key="RAD_UsuarioResponsable">Usuario responsable</cf_translate>:</td>
					<td nowrap valign="middle">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<cfif pintarPlaza><td width="1%"><input type="radio" name="radioResponsable" value="U" <cfif isdefined("rsForm") and len(trim(rsForm.CFuresponsable)) and rsForm.CFuresponsable neq 0>checked="checked"</cfif> /></td></cfif>
								<td width="1%">
									<cfif modo neq 'ALTA'>
										<cf_sifusuarioe idusuario="#rsForm.CFuresponsable#" Usucodigo="CFuresponsable" size="48" tabindex="1">
									<cfelse>
										<cf_sifusuarioe usucodigo="CFuresponsable" size="48" tabindex="1">
									</cfif>
								</td>
								<td>&nbsp;
										<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="LB_LimpiarUsuarioResponsable"
											Default="Limpiar Usuario Responsable"
											returnvariable="LB_LimpiarUsuarioResponsable"/>

									<img style="cursor:hand; " src="/cfmx/rh/imagenes/delete.small.png"
										   alt="#LB_LimpiarUsuarioResponsable#" name="imagenLimpiarUR"
										   border="0" align="absmiddle"
										   onClick="javascript: document.form1.CFuresponsable.value = ''; document.form1.Nombre.value = '';">								</td>
							</tr>
						</table>					</td>
				</tr>
                <!---<Usuario aprobado>--->
      			<tr>
					<td nowrap align="left"><cf_translate key="RAD_Usuarioaprobado">Usuario aprobado</cf_translate>:</td>
					<td nowrap valign="middle">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<cfif pintarPlaza><td width="0%"><input type="radio" name="radioaprobado" value="U" <cfif isdefined("rsForm") and len(trim(rsForm.CFuaprobado)) and rsForm.CFuaprobado neq 0>checked="checked"</cfif> /></td></cfif>
								<td width="0%">
									<cfif modo neq 'ALTA'>
										<cf_sifusuarioa idusuario="#rsForm.CFuaprobado#" Usucodigo="CFuaprobado" size="48" tabindex="1" nombre="Nombre2">
									<cfelse>
										<cf_sifusuarioa usucodigo="CFuaprobado" size="48" tabindex="1" nombre="Nombre2">
									</cfif>
								</td>
								<td>&nbsp;
										<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="LB_LimpiarUsuarioAprovado"
											Default="Limpiar Usuario Aprovado"
											returnvariable="LB_LimpiarUsuarioAprovado"/>

									<img src="/cfmx/rh/imagenes/delete.small.png"
										style="cursor:hand; "
										alt="#LB_LimpiarUsuarioResponsable#"
										name="imagenLimpiarUA"
										width="16"
										height="16"
										border="0" align="absmiddle"
										onClick="javascript: document.form1.CFuaprobado.value = ''; document.form1.Nombre2.value = '';">
															</td>
							</tr>
						</table>					</td>
				</tr>
			<!---</cfif>--->

			<tr>
			<td align="left"><cf_translate key="LB_Comprador">Comprador</cf_translate>:</td>
			<td  valign="middle" nowrap>
				<input name="CMCnombre" type="text"
					   value="<cfif modo NEQ "ALTA" and isDefined("rsNombreCMC") >#rsNombreCMC.CMCnombre#</cfif>"
					   id="CMCnombre" size="48" maxlength="80" readonly tabindex="-1" onFocus="javascript:this.select();">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_ListaDeCompradores"
						Default="Lista de Compradores"
						returnvariable="LB_ListaDeCompradores"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_LimpiarCompradorAsignado"
						Default="Limpiar Comprador asignado"
						returnvariable="LB_LimpiarCompradorAsignado"/>

					<img src="/cfmx/rh/imagenes/Description.gif" style="cursor:hand;" alt="#LB_ListaDeCompradores#" name="imagen" width="18"
						 height="14" border="0" align="absmiddle" onClick="javascript:doConlisCompradores();">
					<img src="/cfmx/rh/imagenes/delete.small.png" style="cursor:hand;" alt="#LB_LimpiarCompradorAsignado#" name="imagenLimpiarCE" 					 width="16" height="16" border="0" align="absmiddle"
						 onClick="javascript: document.form1.CMCnombre.value = ''; document.form1.CFcomprador.value = '';">
				<input name="CFcomprador" type="hidden" id="CFcomprador" value="<cfif modo NEQ "ALTA">#rsForm.CFcomprador#</cfif>">			</td>
			</tr>
			<!--- Valida que el parametro: "Multiples Contratos" en Parametros Adicionales
			en el modulo de Compras este activado--->
			<cfquery name="verifica_Parametro" datasource="#session.dsn#">
				select 1 from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 730
				and Pvalor = '1'
			</cfquery>
			<cfif verifica_Parametro.recordcount GT 0 >
			<tr>
			  <td nowrap align="left"><p><cf_translate key="LB_AutorizadorDeOCDeContratos">Autorizador de OC <br>de Contratos</cf_translate>:</td>
			  <td  valign="middle">
			  	<input name="CMCnombre2" type="text"
					   value="<cfif modo NEQ "ALTA" and isDefined("rsNombreCMC2") >#rsNombreCMC2.CMCnombre#</cfif>"
					   id="CMCnombre2" size="48" maxlength="80" readonly tabindex="-1" onFocus="javascript:this.select();">
					<img src="/cfmx/rh/imagenes/Description.gif" style="cursor:hand;" alt="#LB_ListaDeCompradores#" name="imagen" width="18"
						 height="14" border="0" align="absmiddle" onClick="javascript:doConlisCompradores2();">
					<img src="/cfmx/rh/imagenes/delete.small.png" style="cursor:hand;" alt="#LB_LimpiarCompradorAsignado#" name="imagenLimpiarCE"
							width="16" height="16" border="0" align="absmiddle"
						 onClick="javascript: document.form1.CMCnombre2.value = ''; document.form1.CFautoccontrato.value = '';">
				<input name="CFautoccontrato" type="hidden" id="CFautoccontrato" value="<cfif modo NEQ "ALTA">#rsForm.CFautoccontrato#</cfif>">				</td>
			</tr>
			</cfif>

			<!--- 	[04/01/2006]
					El bit de corporativo solo aplica cuando se trabaja con la empresa corporativa.
			--->
			<cfif isdefined("es_corporativo") and es_corporativo >
				<tr>
				  <td align="left"><cf_translate key="CHK_Corporativo">Corporativo</cf_translate>:</td>
				  <td valign="middle"><input type="checkbox" name="CFcorporativo" value="CFcorporativo" <cfif modo NEQ "ALTA" and rsForm.CFcorporativo>checked</cfif>></td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				</tr>
			</cfif>

			<tr>
				<td>Activo :</td>
				<td><input type="checkbox" name="CFestado" <cfif modo EQ "ALTA" or rsForm.CFestado eq 1>checked</cfif>>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2" align="center" nowrap="nowrap" >
					<cfif modo EQ "ALTA" or isDefined("Form.Nuevo")>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Agregar"
						Default="Agregar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Agregar"/>

						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Limpiar"
						Default="Limpiar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Limpiar"/>
						<cf_botones names="Alta,Limpiar" values="#BTN_Agregar#,#BTN_Limpiar#" tabindex="3" functions="javascript: setBtn(this),javascript: setBtn(this)">

					<cfelse>


						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Modificar"
						Default="Modificar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Modificar"/>

						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Eliminar"
						Default="Eliminar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Eliminar"/>

						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MGS_DeseaEliminarEsteRegistro"
						XmlFile="/rh/generales.xml"
						Default="Desea eliminar este Registro?"
						returnvariable="MGS_DeseaEliminarEsteRegistro"/>

						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Nuevo"
						Default="Nuevo"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Nuevo"/>

						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Exportar"
						Default="Exportar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Exportar"/>

						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Importar"
						Default="Importar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Importar"/>

						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Reporte"
						Default="Reporte"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Reporte"/>
						<script language="JavaScript1.2" >
							function funcCambio(){
								setBtn(this);
							}
							function funcBaja(){
								setBtn(this);
								return confirm('¿<cfoutput>#MGS_DeseaEliminarEsteRegistro#</cfoutput>');
							}
							function funcNuevo() {
								setBtn(this);
							}
							function funcExportar() {
								setBtn(this);
							}
						</script>

						<cf_botones names="Cambio,Baja,Nuevo,Exportar"
						values="#BTN_Modificar#,#BTN_Eliminar#,#BTN_Nuevo#,#BTN_Exportar#"
						tabindex="3" >
					</cfif>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Regresar"
						Default="Regresar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Regresar"/>
						<cf_botones names="Regresar" values="#BTN_Regresar#" tabindex="3" functions="javascript: regresa();">
						<!---<input type="button" name="Regresar" value="#BTN_Regresar#" tabindex="3" onClick="javascript: regresa();">	--->			</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
	 </center>
		<cfset ts = "">
		<cfif modo NEQ "ALTA">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">

  </cfoutput>

<cfif modo EQ 'Alta'>
	</form>
</cfif>
<script language="JavaScript1.2">
	try{
	document.form1.CFcodigo.focus();
	} catch(e) {
	}
</script>
