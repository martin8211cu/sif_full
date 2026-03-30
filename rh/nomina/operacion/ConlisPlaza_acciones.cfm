<html>
<head>
<title><cf_translate key="LB_ListaDePlazas">Lista de Plazas</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
</head>
<body>

<cfset LvarEmpresa = Session.Ecodigo>
<cfset Lvarvfyplz = 0>
<cfset LvarfechaAcc = LSDateFormat(Now(), 'dd/mm/yyyy')>
<cfset LvarfechafinAcc = '01/01/6100'>

<cfif isdefined ('url.index') and len(trim(url.index)) gt 0>
	<cfset Lvarid=ltrim(rtrim(url.index))>
<cfelse>
	<cfset Lvarid=''>
</cfif>
<cfset navegacion = ''>

<cfif isdefined("Url.RHPcodigo") and not isdefined("Form.RHPcodigo")>
	<cfparam name="Form.RHPcodigo" default="#Url.RHPcodigo#">
</cfif>
<cfif isdefined("Url.RHPdescripcion") and not isdefined("Form.RHPdescripcion")>
	<cfparam name="Form.RHPdescripcion" default="#Url.RHPdescripcion#">
</cfif>
<cfif isdefined("Url.f_Ocodigo") and not isdefined("Form.f_Ocodigo")>
	<cfparam name="Form.f_Ocodigo" default="#Url.f_Ocodigo#">
</cfif>
<cfif isdefined("Url.f_Dcodigo") and not isdefined("Form.f_Dcodigo")>
	<cfparam name="Form.f_Dcodigo" default="#Url.f_Dcodigo#">
</cfif>
<cfif isdefined("Url.f_RHPcodigo") and not isdefined("Form.f_RHPcodigo")>
	<cfparam name="Form.f_RHPcodigo" default="#Url.f_RHPcodigo#">
</cfif>
<cfif isdefined("Url.f_RHPcodigoext") and not isdefined("Form.f_RHPcodigoext")>
	<cfparam name="Form.f_RHPcodigoext" default="#Url.f_RHPcodigoext#">
</cfif>
<cfif isdefined("Url.btnFiltrar") and not isdefined("Form.btnFiltrar")>
	<cfparam name="Form.btnFiltrar" default="#Url.btnFiltrar#">
</cfif>

<cfif isdefined("Url.empresa") and not isdefined("Form.empresa")>
	<cfset LvarEmpresa = Url.empresa>
<cfelseif isdefined("Form.empresa")>
	<cfset LvarEmpresa = Form.empresa>
</cfif>

<!--- Parámetro para verificar el porcentaje de la plaza --->
<cfif isdefined("Url.vfyplz") and not isdefined("Form.vfyplz")>
	<cfset Lvarvfyplz = Url.vfyplz>
<cfelseif isdefined("Form.vfyplz")>
	<cfset Lvarvfyplz = Form.vfyplz>
</cfif>

<!--- Parámetro de fecha de vigencia para verificar el porcentaje de la plaza --->
<cfif isdefined("Url.fechaAcc") and not isdefined("Form.fechaAcc")>
	<cfset LvarfechaAcc = Url.fechaAcc>
<cfelseif isdefined("Form.fechaAcc")>
	<cfset LvarfechaAcc = Form.fechaAcc>
</cfif>
<!---Parametro de fecha hasta de la accion para hacer validacion solicitada por Lizandro Villalobos---->
<cfif isdefined("Url.fechafinAcc") and len(trim(Url.fechafinAcc))>
	<cfset LvarfechafinAcc = Url.fechafinAcc>
</cfif>

<!---Parametro del ID del empleado ----->
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset form.DEid = Url.DEid>
</cfif>

<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
		<cfif isdefined("form.Ocodigo") and len(trim("Form.Ocodigo")) and not isdefined("url.MO")>
			and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ocodigo#">
		</cfif>
	order by Odescripcion
</cfquery>
<cfquery name="rsDeptos" datasource="#Session.DSN#">
	select Dcodigo, Ddescripcion
	from Departamentos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
	order by Ddescripcion
</cfquery>

<!----========================== TRADUCCION =============================--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Debe_seleccionar_al_menos_un_filtro"
	default="Debe seleccionar al menos un filtro"
	returnvariable="MSG_Debe_seleccionar_al_menos_un_filtro"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Lista_de_Plazas_Presupuestarias"
	default="Lista de Plazas Presupuestarias"
	returnvariable="LB_Lista_de_Plazas_Presupuestarias"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Codigo"
	default="C&oacute;digo"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Descripcion"
	default="Descripci&oacute;n"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_No_se_encontraron_registros"
	default="No se encontraron registros"
	returnvariable="LB_No_se_encontraron_registros"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Lista_de_Puestos_Presupuestarios"
	default="Lista de Puestos Presupuestarios"
	returnvariable="LB_Lista_de_Puestos_Presupuestarios"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Centro_Funcional"
	default="Centro Funcional"
	returnvariable="LB_Centro_Funcional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Oficina"
	default="Oficina"
	returnvariable="LB_Oficina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Depto"
	default="Depto"
	returnvariable="LB_Depto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Plaza"
	default="Plaza"
	returnvariable="LB_Plaza"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Puesto"
	default="Puesto"
	returnvariable="LB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_No_se_encontro_la_plaza_o_la_misma_se_encuentra_ocupada"
	default="No se encontró la(s) plaza(s) o la(s) misma(s) se encuentra ocupada(s)"
	returnvariable="LB_No_se_encontro_la_plaza_o_la_misma_se_encuentra_ocupada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Seleccione_los_filtros_para_la_lista"
	default="Seleccione los filtros para la lista"
	returnvariable="LB_Seleccione_los_filtros_para_la_lista"/>


<!--- Recibe form, conexion, atrRHPcodigo, atrRHPdescripcion, atrRHPid, RHPpuesto, Dcodigo, Ocodigo --->
<script language="JavaScript" type="text/javascript">
function Asignar(RHPid, RHPPid, RHPPcodigo, RHPPdescripcion, Ocodigo, Odescripcion, Dcodigo, Ddescripcion, CFuncional, RHCid1, RHCcodigo1, RHCdescripcion1, RHTTid1,
 RHTTcodigo, RHTTdescripcion, RHMPPid1, RHMPPcodigo1, RHMPPdescripcion1, RHCcodigo1, RHCdescripcion1, RHPpuesto, RHPpuestoext, RHPdescpuesto, Disponible, RHMPnegociado){
	if (window.opener != null) {
		<cfoutput>
		//Plaza presupuestaria
		window.opener.document.#Url.form#.RHPPcodigo.value = RHPPcodigo;
		window.opener.document.#Url.form#.RHPPdescripcion.value = RHPPdescripcion;
		window.opener.document.#Url.form#.RHPPid.value = RHPPid;
		//Plaza de RH
		window.opener.document.#Url.form#.RHPid.value = RHPid;
		//Oficina
		window.opener.document.#Url.form#.Ocodigo.value = Ocodigo;
		window.opener.document.#Url.form#.Odescripcion.value = Odescripcion;
		//Departamento
		window.opener.document.#Url.form#.Dcodigo.value = Dcodigo;
		window.opener.document.#Url.form#.Ddescripcion.value = Ddescripcion;
		//Puesto de RH
		window.opener.document.#Url.form#.RHPcodigo.value = RHPpuesto;
		window.opener.document.#Url.form#.RHPcodigoext.value = RHPpuestoext;
		window.opener.document.#Url.form#.RHPdescpuesto.value = RHPdescpuesto;
		//Centro funcional
		window.opener.document.#Url.form#.CFuncional.value = CFuncional;
	<cfoutput>
		<cfif isdefined("url.usaEstructuraSalarial")>
			<!--- var conlispuesto = window.opener.document.getElementById("imgRHMPPcodigo");
			var conliscategoria = window.opener.document.getElementById("imgRHCcodigo1");
			if (conliscategoria){}
			else{
			var conliscategoria = window.opener.document.getElementById("imgRHCcodigo");
			}	--->
			<!--- conlispuesto.style.display = 'none';
			conliscategoria.style.display = 'none'; --->
			window.opener.document.#Url.form#.RHTTid#Lvarid#.value = RHTTid1;
			window.opener.document.#Url.form#.RHTTcodigo#Lvarid#.value = RHTTcodigo;
			window.opener.document.#Url.form#.RHTTdescripcion#Lvarid#.value = RHTTdescripcion;
			window.opener.document.#Url.form#.RHCid#Lvarid#.value = RHCid1;
			window.opener.document.#Url.form#.RHCcodigo#Lvarid#.disabled = true;
			window.opener.document.#Url.form#.RHCcodigo#Lvarid#.value = RHCcodigo1;
			window.opener.document.#Url.form#.RHCdescripcion#Lvarid#.value = RHCdescripcion1;
			window.opener.document.#Url.form#.RHMPPid#Lvarid#.value = RHMPPid1;
			window.opener.document.#Url.form#.RHMPPcodigo#Lvarid#.disabled = true;
			window.opener.document.#Url.form#.RHMPPcodigo#Lvarid#.value = RHMPPcodigo1;
			window.opener.document.#Url.form#.RHMPPcodigo#Lvarid#.disabled = true;
			window.opener.document.#Url.form#.RHMPPdescripcion#Lvarid#.value = RHMPPdescripcion1;
		</cfif>
	</cfoutput>

		<cfif isdefined("url.usaEstructuraSalarial") and isdefined("url.PuedeModificar")>
			var conlispuesto = window.opener.document.getElementById("imgRHMPPcodigo");
			var conliscategoria = window.opener.document.getElementById("imgRHCcodigo");
			//Puesto presupuestario
			window.opener.document.#Url.form#.RHMPPid1.value = RHMPPid1;
			//Salario negociado
			if (RHMPnegociado == 'N' && RHTTid != '' && RHMPPid != '' && RHCid != ''){
				//Tabla
				window.opener.document.#Url.form#.RHTTid.disabled = true;
				//Puesto Presup
				<!--- conlispuesto.style.display = 'none';			 --->
				window.opener.document.#Url.form#.RHMPPcodigo.disabled = true;
				//Categoria
				conliscategoria.style.display = 'none';
				window.opener.document.#Url.form#.RHCcodigo.disabled = true;
			}
			else{
				//Tabla
				window.opener.document.#Url.form#.RHTTid.disabled = false;
				//Puesto Presup
				<!--- conlispuesto.style.display = ''; --->
				window.opener.document.#Url.form#.RHMPPcodigo.disabled = false;
				//Categoria
				<!--- conliscategoria.style.display = ''; --->
				window.opener.document.#Url.form#.RHCcodigo.disabled = false;
			}

			//Tabla salarial
			window.opener.document.#Url.form#.RHTTid.value = RHTTid1;
			//Puesto presupuestario
			window.opener.document.#Url.form#.RHMPPcodigo.value = RHMPPcodigo1;
			window.opener.document.#Url.form#.RHMPPdescripcion.value = RHMPPdescripcion1;
			//Categoria
			window.opener.document.#Url.form#.RHCid.value = RHCid1;
			window.opener.document.#Url.form#.RHCcodigo.value = RHCcodigo1;
			window.opener.document.#Url.form#.RHCdescripcion.value = RHCdescripcion1;
		</cfif>


		if (window.opener.document.#url.form#.LTporcplaza) {
			<cfif Lvarvfyplz EQ 0>
			if (Disponible > 0) {
				window.opener.document.#url.form#.LTporcplaza.value = fm(Disponible, 2);
			} else {
				window.opener.document.#url.form#.LTporcplaza.value = "0.00";
			}
			<cfelse>
				window.opener.document.#url.form#.LTporcplaza.value = "100.00";
			</cfif>
		}
		</cfoutput>
		window.close();
	}
}
function funcValida(){
	if (document.filtroEmpleado.CFid.value == '' && document.filtroEmpleado.f_Ocodigo.value == '' &&
		document.filtroEmpleado.f_Dcodigo.value == '' && document.filtroEmpleado.RHPPid.value == '' &&
		document.filtroEmpleado.RHMPPid.value == '' && document.filtroEmpleado.f_RHPcodigo.value == '' ){
		<cfoutput>alert("#MSG_Debe_seleccionar_al_menos_un_filtro#")</cfoutput>;
		return false;
	}
	return true;
}
</script>

<cfset navegacion = "empresa=" & LvarEmpresa & "&vfyplz=" & Lvarvfyplz & "&fechaAcc=" & LvarfechaAcc & "&DEid=" & form.DEid  & "&fechafinAcc=" & LvarfechafinAcc>
<cfif isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigo=" & Form.RHPcodigo>
</cfif>
<cfif isdefined("Form.RHPdescripcion") and Len(Trim(Form.RHPdescripcion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPdescripcion=" & Form.RHPdescripcion>
</cfif>
<cfif isdefined("Form.f_Ocodigo") and Len(Trim(Form.f_Ocodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f_Ocodigo=" & Form.f_Ocodigo>
</cfif>
<cfif isdefined("Form.f_Dcodigo") and Len(Trim(Form.f_Dcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f_Dcodigo=" & Form.f_Dcodigo>
</cfif>
<cfif isdefined("Form.f_RHPcodigo") and Len(Trim(Form.f_RHPcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f_RHPcodigo=" & Form.f_RHPcodigo>
</cfif>
<cfif isdefined("Form.f_RHPcodigoext") and Len(Trim(Form.f_RHPcodigoext)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f_RHPcodigoext=" & Form.f_RHPcodigoext>
</cfif>
<cfif isdefined("Form.btnFiltrar") and Len(Trim(Form.btnFiltrar)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "btnFiltrar=" & Form.btnFiltrar>
</cfif>

<!---Buscar los valores de los conlises ----->
<cfset va_PlazaP = ArrayNew(1)>
<cfset va_PuestoP = ArrayNew(1)>
<cfset va_PlazaRH = ArrayNew(1)>
<!----Plaza Presupuestaria ----->
<cfif isdefined("form.RHPPid") and len(trim(form.RHPPid))>
	<cfquery name="rsPlazaP" datasource="#session.DSN#">
		select RHPPid, RHPPcodigo, RHPPdescripcion
		from RHPlazaPresupuestaria
		where RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPPid#">
	</cfquery>
	<cfif rsPlazaP.RecordCount NEQ 0>
		<cfset ArrayAppend(va_PlazaP, rsPlazaP.RHPPid)>
		<cfset ArrayAppend(va_PlazaP, rsPlazaP.RHPPcodigo)>
		<cfset ArrayAppend(va_PlazaP, rsPlazaP.RHPPdescripcion)>
	</cfif>
</cfif>
<!----Puesto Presupuestaria ----->
<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
	<cfquery name="rsPuestoP" datasource="#session.DSN#">
		select RHMPPid, RHMPPcodigo, RHMPPdescripcion
		from RHMaestroPuestoP
		where RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
	</cfquery>
	<cfif rsPuestoP.RecordCount NEQ 0>
		<cfset ArrayAppend(va_PuestoP, rsPuestoP.RHMPPid)>
		<cfset ArrayAppend(va_PuestoP, rsPuestoP.RHMPPcodigo)>
		<cfset ArrayAppend(va_PuestoP, rsPuestoP.RHMPPdescripcion)>
	</cfif>
</cfif>
<!----Plaza RH ----->
<cfif isdefined("form.RHPid") and len(trim(form.RHPid))>
	<cfquery name="rsPlazaRH" datasource="#session.DSN#">
		select RHPid, RHPcodigo, RHPdescripcion
		from RHPlazas
		where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPid#">
	</cfquery>
	<cfif rsPlazaRH.RecordCount NEQ 0>
		<cfset ArrayAppend(va_PlazaRH, rsPlazaRH.RHPid)>
		<cfset ArrayAppend(va_PlazaRH, rsPlazaRH.RHPcodigo)>
		<cfset ArrayAppend(va_PlazaRH, rsPlazaRH.RHPdescripcion)>
	</cfif>
</cfif>
<!---Puesto de RH ---->
<cfif isdefined("form.f_RHPcodigo") and len(trim(f_RHPcodigo))>
	<cfquery name="rsPuestoRH" datasource="#session.DSN#">
		select RHPcodigo as f_RHPcodigo,
		 coalesce(ltrim(rtrim(RHPcodigoext)),ltrim(rtrim(RHPcodigo))) as f_RHPcodigoext,
		 RHPdescpuesto as f_RHPdescpuesto
		from RHPuestos
		where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.f_RHPcodigo#">
	</cfquery>
</cfif>

<cfoutput>
<br>
<table width="98%" border="0" cellpadding="1" cellspacing="0" align="center">
	<tr>
		<td align="center"><strong><cf_translate key="LB_ListaDePlazas">Lista de Plazas</cf_translate></strong></td>
	</tr>
	<tr><td>
		<form name="filtroEmpleado" method="post" onSubmit="javascript: return funcValida();">
		<input type="hidden" name="empresa" value="#LvarEmpresa#">
		<input type="hidden" name="vfyplz" value="#Lvarvfyplz#">
		<input type="hidden" name="fechaAcc" value="#LvarfechaAcc#">
		<input type="hidden" name="DEid" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
		<table width="98%" border="0" cellpadding="1" cellspacing="0" class="areaFiltro" align="center">
          <tr>
            <td width="30%" nowrap><strong><cf_translate key="LB_Centro_Funcional">Centro Funcional</cf_translate></strong></td>
            <td width="32%" ><strong><cf_translate key="LB_Oficina">Oficina</cf_translate></strong></td>
            <td width="27%" ><strong><cf_translate key="LB_Departamento">Departamento</cf_translate></strong></td>
          </tr>
          <tr>
            <td><cf_rhcfuncional form="filtroEmpleado" tabindex="1" size="20"> </td>
            <td><select name="f_Ocodigo" id="f_Ocodigo">
                <option value=""><cf_translate key="CMB_Todos">--- Todos ---</cf_translate></option>
                <cfloop query="rsOficinas">
                  <option value="#rsOficinas.Ocodigo#" <cfif isdefined("form.f_Ocodigo") and len(trim(form.f_Ocodigo)) and rsOficinas.Ocodigo EQ form.f_Ocodigo>selected</cfif>>#rsOficinas.Odescripcion#</option>
                </cfloop>
              </select>
            </td>
            <td><select name="f_Dcodigo" id="f_Dcodigo">
                <option value=""><cf_translate key="CMB_Todos">--- Todos ---</cf_translate></option>
                <cfloop query="rsDeptos">
                  <option value="#rsDeptos.Dcodigo#" <cfif isdefined("form.f_Dcodigo") and len(trim(form.f_Dcodigo)) and rsDeptos.Dcodigo EQ form.f_Dcodigo>selected</cfif>>#rsDeptos.Ddescripcion#</option>
                </cfloop>
              </select>
            </td>
            <td rowspan="2" width="11%" align="center" valign="middle"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
            </td>
          </tr>
          <tr>
            <td width="30%" ><strong><cf_translate key="LB_Plaza">Plaza</cf_translate></strong></td>
            <td width="32%" ><strong><cf_translate key="LB_Puesto">Puesto</cf_translate></strong></td>
            <td width="27%" ><strong><cf_translate key="LB_Puesto_RH">Puesto RH</cf_translate></strong></td>
          </tr>
          <tr>
            <td><cf_conlis
						campos="RHPPid, RHPPcodigo, RHPPdescripcion"
						asignar="RHPPid, RHPPcodigo, RHPPdescripcion"
						valuesarray="#va_PlazaP#"
						size="0,10,20"
						desplegables="N,S,S"
						modificables="N,S,N"
						title="#LB_Lista_de_Plazas_Presupuestarias#"
						tabla="RHPlazaPresupuestaria "
						columnas="RHPPid, RHPPcodigo, RHPPdescripcion"
						filtro="Ecodigo = #LvarEmpresa#"
						filtrar_por="RHPPcodigo, RHPPdescripcion"
						desplegar="RHPPcodigo, RHPPdescripcion"
						etiquetas="#LB_Codigo#,#LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						asignarformatos="S,S,S"
						form="filtroEmpleado"
						showemptylistmsg="true"
						emptylistmsg=" --- #LB_No_se_encontraron_registros# --- "
					/> </td>
            <td><cf_conlis
						campos="RHMPPid, RHMPPcodigo, RHMPPdescripcion"
						asignar="RHMPPid, RHMPPcodigo, RHMPPdescripcion"
						valuesarray="#va_PuestoP#"
						size="0,8,25"
						desplegables="N,S,S"
						modificables="N,S,N"
						title="#LB_Lista_de_Puestos_Presupuestarios#"
						tabla="RHMaestroPuestoP "
						columnas="RHMPPid, RHMPPcodigo, RHMPPdescripcion"
						filtro="Ecodigo = #LvarEmpresa# "
						filtrar_por="RHMPPcodigo, RHMPPdescripcion"
						desplegar="RHMPPcodigo, RHMPPdescripcion"
						etiquetas="#LB_Codigo#,#LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						asignarformatos="S,S,S"
						form="filtroEmpleado"
						showemptylistmsg="true"
						emptylistmsg=" ---#LB_No_se_encontraron_registros# --- "
					/> </td>
            <td><cfif isdefined("form.f_RHPcodigo") and len(trim(f_RHPcodigo))>
                <cf_rhpuesto name="f_RHPcodigo" nameExt="f_RHPcodigoext"  desc="f_RHPdescpuesto" empresa="#LvarEmpresa#" size="20" form="filtroEmpleado" query="#rsPuestoRH#">
                <cfelse>
                <cf_rhpuesto name="f_RHPcodigo" nameExt="f_RHPcodigoext" desc="f_RHPdescpuesto" empresa="#LvarEmpresa#" size="20" form="filtroEmpleado">
              </cfif>
            </td>
          </tr>
        </table>
		</form>
	</td></tr>
</cfoutput>
  <cfif isdefined("form.btnFiltrar")>
    <cfquery name="rsPlazas" datasource="#Session.DSN#">
		select ltp.RHPPid,
				pp.RHPPdescripcion,
				ltrim(rtrim(pp.RHPPcodigo)) as RHPPcodigo,
				ltrim(rtrim(ca.RHCcodigo)) as RHCcodigo1,
				ca.RHCdescripcion as RHCdescripcion1,
				ltp.RHCid as RHCid1,
				ltp.RHTTid as RHTTid1,
				ltp.RHMPPid as RHMPPid1,
				ts.RHTTdescripcion,
				ts.RHTTcodigo,
				ltp.RHPid,
				ltrim(rtrim(a.RHPcodigo)) as RHPcodigo,
				{fn concat(ltrim(rtrim(a.RHPcodigo)),{fn concat(' - ',a.RHPdescripcion)})} as RHPdescripcion,
				ltrim(rtrim(a.RHPpuesto)) as RHPpuestoPlaza,
				ltrim(rtrim(b.RHPcodigo)) as RHPpuesto,
				coalesce(ltrim(rtrim(b.RHPcodigoext)),ltrim(rtrim(b.RHPcodigo))) as RHPpuestoext,
				cf.CFid,
				{fn concat(ltrim(rtrim(cf.CFcodigo)),{fn concat(' - ',ltrim(rtrim(cf.CFdescripcion)))} )} as CFuncional,
				cf.Ocodigo,
				c.Odescripcion,
				cf.Dcodigo,
				d.Ddescripcion,
				ltrim(rtrim(mp.RHMPPcodigo)) as RHMPPcodigo1,
				ltp.RHMPnegociado,
				mp.RHMPPdescripcion as RHMPPdescripcion1,
				b.RHPdescpuesto,
				(select 100.00 - coalesce(sum(z.LTporcplaza), 0.00)
				from LineaTiempo z
				where a.RHPid = z.RHPid
					and a.Ecodigo = z.Ecodigo
					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(LvarfechaAcc)#">
						 between z.LTdesde and z.LThasta
				 ) as Disponible

		from RHLineaTiempoPlaza ltp

			inner join CFuncional cf
				on ltp.CFidautorizado = cf.CFid

				inner join Oficinas c
					on cf.Ocodigo = c.Ocodigo
					and cf.Ecodigo = c.Ecodigo

				inner join Departamentos d
					on cf.Dcodigo = d.Dcodigo
					and cf.Ecodigo = d.Ecodigo

			left outer join RHTTablaSalarial ts
				on ltp.RHTTid = ts.RHTTid
				and ts.Ecodigo=#session.Ecodigo#

			left outer join RHCategoria ca
				on ltp.RHCid = ca.RHCid

			inner join RHPlazas a
				ON ltp.RHPPid = a.RHPPid
				and a.RHPactiva = 1

				left outer join RHPuestos b
					on a.RHPpuesto = b.RHPcodigo
					and a.Ecodigo = b.Ecodigo
					<!----and b.RHMPPid = ltp.RHMPPid		-- Puestos de RH que pertenezcan al puesto presupuestario de la plaza----->

			inner join RHPlazaPresupuestaria pp
				on ltp.RHPPid = pp.RHPPid

				left outer join RHMaestroPuestoP mp
					on ltp.RHMPPid = mp.RHMPPid

		where <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(LvarfechaAcc)#">
				between RHLTPfdesde and RHLTPfhasta
			and ltp.RHMPestadoplaza = 'A'
			and ltp.Ecodigo = #session.Ecodigo#

			<cfif isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo)) NEQ 0>
			  and upper(a.RHPcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.RHPcodigo)#%">
			</cfif>
			<cfif isdefined("Form.RHPdescripcion") and Len(Trim(Form.RHPdescripcion)) NEQ 0>
			  and upper(a.RHPdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.RHPdescripcion)#%">
			</cfif>
			<cfif isdefined("Form.f_Ocodigo") and Len(Trim(Form.f_Ocodigo)) NEQ 0>
			  and cf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.f_Ocodigo#">
			</cfif>
			<cfif isdefined("Form.f_Dcodigo") and Len(Trim(Form.f_Dcodigo)) NEQ 0>
			  and cf.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.f_Dcodigo#">
			</cfif>
			<cfif isdefined("Form.f_RHPcodigo") and Len(Trim(Form.f_RHPcodigo)) NEQ 0>
			  <!----and a.RHPpuesto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.f_RHPcodigo)#">---->
			  and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.f_RHPcodigo)#">
			</cfif>
			<cfif isdefined("Form.CFid") and Len(Trim(Form.CFid)) NEQ 0>
			  and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
			</cfif>
			<cfif isdefined("Form.RHPPid") and Len(Trim(Form.RHPPid)) NEQ 0>
			  and ltp.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPPid#">
			</cfif>
			<cfif isdefined("Form.RHMPPid") and Len(Trim(Form.RHMPPid)) NEQ 0>
			  and ltp.RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHMPPid#">
			</cfif>
			<cfif isdefined("Form.RHPid") and Len(Trim(Form.RHPid)) NEQ 0>
			  and ltp.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPid#">
			</cfif>
			<cfif Lvarvfyplz EQ 0>
				and (exists  (  select 1
								from LineaTiempo lt
								where a.RHPid = lt.RHPid
									and a.Ecodigo = lt.Ecodigo
									and ((<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(LvarfechaAcc)#"> between lt.LTdesde and lt.LThasta)
										   )
										having coalesce(sum(lt.LTporcplaza), 0) < 100
										)
                     or exists  (  select 1
								from LineaTiempo lt
								where a.RHPid = lt.RHPid
									and a.Ecodigo = lt.Ecodigo
									and ((<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(LvarfechafinAcc)#"> between lt.LTdesde and lt.LThasta))
										having coalesce(sum(lt.LTporcplaza), 0) < 100
										)
					/*Verifica que la ocupacion de la plaza sea del empleado y en la fecha de la accion*/
					or  exists	( select 1
								from LineaTiempo lt
								where a.RHPid = lt.RHPid
									and a.Ecodigo = lt.Ecodigo
									and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
									<!---===========  ANTERIOR ===========
									and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(LvarfechaAcc)#">
										between lt.LTdesde and lt.LThasta
									)----->
									and ((<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(LvarfechaAcc)#"> between lt.LTdesde and lt.LThasta)
										   or
										   (<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(LvarfechafinAcc)#"> between lt.LTdesde and lt.LThasta))
										)
					)
					and (select 100.00 - coalesce(sum(z.LTporcplaza), 0.00)
						from LineaTiempo z
						where a.RHPid = z.RHPid
						and a.Ecodigo = z.Ecodigo
						and getdate() between z.LTdesde and z.LThasta
						) > 0
			</cfif>
    </cfquery>

    <cfif ISDEFINED("CGI.QUERY_STRING")>
      <cfset QueryString_lista='&'&CGI.QUERY_STRING>
      <cfelse>
      <cfset QueryString_lista="">
    </cfif>
    <cfset tempPos=ListContainsNoCase(QueryString_lista,"RHPcodigo=","&")>
	<cfif tempPos NEQ 0>
      <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
    </cfif>
    <cfset tempPos=ListContainsNoCase(QueryString_lista,"RHPdescripcion=","&")>
	<cfif tempPos NEQ 0>
      <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
    </cfif>
    <cfset tempPos=ListContainsNoCase(QueryString_lista,"f_RHPcodigo=","&")>
	<cfif tempPos NEQ 0>
      <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
    </cfif>
    <cfif tempPos NEQ 0>
      <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
    </cfif>
	<tr><td align="center">
		<cfinvoke
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaEduRet">
		  <cfinvokeargument name="query" value="#rsPlazas#"/>
		  <cfinvokeargument name="desplegar" value="CFuncional, Odescripcion, Ddescripcion, RHPPdescripcion, RHPdescpuesto"/>
		  <cfinvokeargument name="etiquetas" value="#LB_Centro_Funcional#, #LB_Oficina#, #LB_Depto#, #LB_Plaza#, #LB_Puesto#"/>
		  <cfinvokeargument name="formatos" value=""/>
		  <cfinvokeargument name="align" value="left, left, left, left, left"/>
		  <cfinvokeargument name="ajustar" value=""/>
		  <cfinvokeargument name="irA" value="ConlisPlaza_acciones.cfm"/>
		  <cfinvokeargument name="formName" value="listaPlaza"/>
		  <cfinvokeargument name="MaxRows" value="12"/>
		  <cfinvokeargument name="funcion" value="Asignar"/>
		  <cfinvokeargument name="fparams" value="RHPid, RHPPid, RHPPcodigo, RHPPdescripcion, Ocodigo, Odescripcion, Dcodigo, Ddescripcion, CFuncional, RHCid1,
		  											RHCcodigo1, RHCdescripcion1, RHTTid1, RHTTcodigo, RHTTdescripcion, RHMPPid1, RHMPPcodigo1, RHMPPdescripcion1, RHCcodigo1,
													RHCdescripcion1, RHPpuesto, RHPpuestoext,RHPdescpuesto, Disponible, RHMPnegociado,"/>
		  <cfinvokeargument name="navegacion" value="#navegacion#"/>
		  <cfinvokeargument name="debug" value="N"/>
		  <cfinvokeargument name="showEmptyListMsg" value="yes"/>
		  <cfinvokeargument name="EmptyListMsg" value="---- #LB_No_se_encontro_la_plaza_o_la_misma_se_encuentra_ocupada# ----"/>
		  <cfinvokeargument name="QueryString_lista" value="#QueryString_lista#"/>
		</cfinvoke>
   </tr></td>
    <cfelse>
		<tr>
		  <td align="center"><strong>--- <cfoutput>#LB_Seleccione_los_filtros_para_la_lista#</cfoutput> ---</strong></td>
		</tr>
  	</cfif>
</table>
</body>
</html>