<!----==================== TRADUCCION ================= ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre_Empleado"
	Default="Nombre Empleado"
	returnvariable="LB_Nombre_Empleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Reconocido"
	Default="Reconocido"
	returnvariable="LB_Reconocido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Consultar"
	Default="Consultar"
	returnvariable="LB_Consultar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Eliminar"
	Default="Eliminar"
	returnvariable="LB_Eliminar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_No_registros_de_Calculo_del_PTU"
	Default="No hay registros de Calculo del PTU"
	returnvariable="MSG_No_registros_de_Calculo_del_PTU"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Anterior"
	Default="Anterior"
	returnvariable="BTN_Anterior"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Calcular_PTU"
	Default="Calcular PTU"
	returnvariable="BTN_Calcular_PTU"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Siguiente"
	Default="Siguiente"
	returnvariable="BTN_Siguiente"/>

<cfset navegacion = "RHPTUEid=" & Form.RHPTUEid>
<cfset navegacion = navegacion & "&tab=3">

<!--- Consultas --->
<cfquery name="rsRHPTUEt3" datasource="#Session.DSN#">
	select a.RHPTUEid, a.RHPTUEcodigo, a.RHPTUEdescripcion, a.Ecodigo, b.Edescripcion, a.FechaDesde, a.FechaHasta
	from RHPTUE a
		inner join Empresas b
		on a.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
</cfquery>

<cfquery name="rsEmpleados" datasource="#Session.DSN#">
	select RHPTUEMSueldoAnual, DEid, Ecodigo
	from RHPTUEMpleados rht
    where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
    order by RHPTUEMSueldoAnual desc
</cfquery>

<!---<cf_dump var= "#rsEmpleados#">--->

<cfset validacion = 0>
<cfset SueldoAnual = 0 >
<cfset idEmpresa = session.Ecodigo>
<cfloop query="rsEmpleados">
	<cfquery name="rsEmpleadosDos" datasource="#Session.DSN#">
    	select top 1 Tcodigo
		   from DLaboralesEmpleado
	                   where DEid = #rsEmpleados.DEid#
	                		and Ecodigo = #rsEmpleados.Ecodigo#
		   order by DLfechaaplic desc
     </cfquery>
	<cfset idEmpleado = #rsEmpleados.DEid#>
    <cfset idEmpresa = #rsEmpleados.Ecodigo#>
     <cfif rsEmpleadosDos.Tcodigo EQ '02' and validacion EQ 0>
     	<cfset validacion = 1>
        <cfset SueldoAnual = #rsEmpleados.RHPTUEMSueldoAnual#>
     <cfelseif rsEmpleadosDos.Tcodigo EQ '03' and validacion EQ 0>
        <cfset SueldoAnual = 0>
	 <cfelse>
	 	<cfset idEmpleado = -1>
     </cfif>
</cfloop>

    <cfif SueldoAnual EQ ''>
    <cfset SueldoAnual = 0 >
	</cfif>

	<cfset SueldoAnualNS = (#SueldoAnual# * 1.2)>

	<cfquery name="rsEmpleadosAlto" datasource="#Session.DSN#">
    	select DEidentificacion + ' ' + '-' + ' ' + DEnombre + ' ' + DEapellido1 + ' ' + DEapellido2 as Nombre
		from DatosEmpleado where Ecodigo = #idEmpresa#
        	and DEid in (#idEmpleado#)
     </cfquery>

<cfoutput>
<!---<cf_dump var = "#form#">--->
<form name="formD2" method="post" style="margin: 0;" action="PTU-sql.cfm">
	<input name="RHPTUEid_3" type="hidden" id = "RHPTUEid" value="<cfif isdefined("form.RHPTUEid")>#form.RHPTUEid#</cfif>" />
    <input name="SueldoAnual" type="hidden" value="#SueldoAnual#" />
    <input name="SueldoAnualNS" type="hidden" value="#SueldoAnualNS#" />
    <input name="tab" type="hidden" value="3" />
	<table width="90%" border="0" cellspacing="0" cellpadding="1" align="center">
		<tr>
			<td colspan="4">
				<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
					<tr>
						<td width="19%" nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Detalle_Accion">Detalle PTU</cf_translate>:</div></td>
						<td width="81%" nowrap >#rsRHPTUEt3.RHPTUEcodigo# - #rsRHPTUEt3.RHPTUEdescripcion#</td>
					</tr>
					<tr>
						<td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Fecha_Desde">Fecha Desde</cf_translate>:</div></td>
						<td nowrap >#LSDateFormat(rsRHPTUEt3.FechaDesde,'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Empleado">Empleado</cf_translate>:</div></td>
						<td nowrap>#rsEmpleadosAlto.Nombre#</td>
					</tr>
                    <tr>
						<td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_MontoAnual">Monto Anual Máximo Sindicalizado</cf_translate>:</div></td>
						<td nowrap >#LSCurrencyFormat(SueldoAnual)#</td>
					</tr>
                    <tr>
						<td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_MontoAnual">Monto Anual Máximo No Sindicalizado</cf_translate>:</div></td>
						<td nowrap >#LSCurrencyFormat(SueldoAnualNS)#</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4">
				<fieldset style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20" align="center">
						<tr>
							<td class="fileLabel">&nbsp;<cf_translate key="LB_Lista_de_empleados">LISTA DE EMPLEADOS</cf_translate></td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
		<tr>

			<td colspan="4">
            	<cfquery name="rsEmpresas" datasource="#session.DSN#">
                	select distinct b.Ecodigo
								from RHPTUD a
									inner join Empresas b
									on a.Ecodigo = b.Ecodigo
								where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
                                	and CFid is null
                                    and Dcodigo is null
                                    and Ocodigo is null
                                    and RHPcodigo is null
                                    and DEid is null
                </cfquery>
               <!--- <cf_dump var = "#rsEmpresas#">--->
				<cfset columnas="DEid,DEidentificacion, Nombre">
                <cfset desplegar="DEidentificacion, Nombre">
                <cfset etiquetas="#LB_Identificacion#,#LB_Nombre_Empleado#">
                <cfset formatos="S,S">
                <cfset align="left,left">
                <cfset ajustar="S,S">
                <cfset ValuesArray = ArrayNew(1)>
                <cfset ArrayAppend(ValuesArray, "b.DEidentificacion")>
                <cfset ArrayAppend(ValuesArray, "{fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) }")>
                <cfset ArrayAppend(ValuesArray, "")>
                <cfset ArrayAppend(ValuesArray, "")>
                <cfset filtrar_por=ValuesArray>

				<cfquery name="rsLista" datasource="#session.DSN#" >
	                select
                            a.RHPTUEMid,
                            a.DEid,
                            b.DEidentificacion,
                            a.RHPTUEid,
                            a.Ecodigo,
                            a.FechaDesde,
                            a.FechaHasta,
                            a.Dcodigo,
                            a.RHPcodigo,
                            a.Ocodigo,
                            a.RHPTUEMfecha,
                            a.BMUsucodigo,
                            {fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) }  as Nombre,
                            c.RHPTUEdescripcion,
                            {fn concat(rtrim(e.Deptocodigo),{fn concat(' - ',rtrim(e.Ddescripcion))})} as Depto,
                            rtrim(f.RHPdescpuesto) as RHPdescpuesto, coalesce(ltrim(rtrim(f.RHPcodigoext)),ltrim(rtrim(f.RHPcodigo))) as RHPcodigoext,
                            {fn concat(rtrim(g.Oficodigo),{fn concat(' - ',rtrim(g.Odescripcion))})} as Oficina
					from RHPTUEMpleados a
						inner join RHPTUE c
							on a.RHPTUEid = c.RHPTUEid
						left outer join DatosEmpleado b
							on a.DEid = b.DEid
						left outer join Departamentos e
							on a.Dcodigo = e.Dcodigo
							and a.Ecodigo = e.Ecodigo
						left outer join RHPuestos f
							on a.RHPcodigo = f.RHPcodigo
							and a.Ecodigo = f.Ecodigo
						left outer join Oficinas g
							on a.Ocodigo = g.Ocodigo
							and a.Ecodigo = g.Ecodigo
					where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
						<cfif isdefined('rsEmpresas') and rsEmpresas.RecordCount GT 0>
						and a.Ecodigo in (#ValueList(rsEmpresas.Ecodigo)#)
                        <cfelse>
                        and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        </cfif>
						<cfif isdefined("form.FILTRO_DEIDENTIFICACION") and len(trim(form.FILTRO_DEIDENTIFICACION))>
							and upper(b.DEidentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.FILTRO_DEIDENTIFICACION)#%">
						</cfif>
						<cfif isdefined("form.FILTRO_NOMBRE") and len(trim(form.FILTRO_NOMBRE))>
							and upper({fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) } ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.FILTRO_NOMBRE)#%">
						</cfif>
				</cfquery>

				<cfinvoke
					component="rh.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="#desplegar#"/>
						<cfinvokeargument name="etiquetas" value="#etiquetas#"/>
						<cfinvokeargument name="formatos" value="#formatos#"/>
						<cfinvokeargument name="columnas" value="#columnas#"/>
						<cfinvokeargument name="incluyeForm" value="false"/>
						<cfinvokeargument name="formName" value="formD2"/>
						<cfinvokeargument name="align" value="#align#"/>
						<cfinvokeargument name="checkboxes" value="S"/>
						<cfinvokeargument name="ajustar" value="#ajustar#"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="filtrar_por_array" value="#filtrar_por#"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="emptylistmsg" value=" --- #MSG_No_registros_de_Calculo_del_PTU# ---"/>
						<cfinvokeargument name="keys" value="RHPTUEMid"/>
						<cfinvokeargument name="ira" value="PTU.cfm"/>
						<cfinvokeargument name="maxrows" value="10"/>
                        <cfinvokeargument name="showlink" value="false"/>

				</cfinvoke>
			</td>
		</tr>
	</table>
	<table width="90%" border="0" cellspacing="0" cellpadding="1" align="center">
		<tr>
			<td colspan="4">
				<cf_botones names="btnEliminar,btnCalcular" values="#LB_Eliminar#,#BTN_Calcular_PTU#">
			</td>
		</tr>
	</table>
	</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	<!--- Variables --->
	var popUpWinSN = 0;
	var _RHPTUEid = document.formD2.RHPTUEid.value;

	function funcbtnEliminar(a) {
	//alert (document.lista.DEid.value)
		var form = document.formD2;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
					//document.formD2.LvarChk.value=document.lista.DEid.value
						result = true;
										}
			}
			else{
				if (form.chk.checked)
				//document.formD2.LvarChk.value=document.lista.DEid.value
					result = true;
			}
		}
		if (!result) {alert("Debe marcar al menos un registro");}
		return result;
	}

	function funcFiltrar(){
		document.formD2.RHPTUEid.value = _RHPTUEid;
		return true;
	}
</script>