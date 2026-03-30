<!---<cf_dump var = "#form#">--->
<cfset navegacion = "RHPTUEid=" & Form.RHPTUEid>
<cfset navegacion = navegacion & "&tab=4">

<!--- Consultas --->
<cfquery name="rsRHPTUEt4" datasource="#Session.DSN#">
	select a.RHPTUEid, a.RHPTUEcodigo, a.RHPTUEdescripcion, a.Ecodigo, b.Edescripcion, a.FechaDesde, a.FechaHasta 
	from RHPTUE a
		inner join Empresas b 
		on a.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
</cfquery>

<cfquery name="rsValidarEmpresas" datasource="#session.DSN#">
	select Ecodigo from RHPTUD 
    where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
    group by Ecodigo
</cfquery>

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
	Key="MSG_No_se_Encontraron_Registros_para_la_Accion_Masiva"
	Default="No se Encontraron Registros para la Accion Masiva"	
	returnvariable="MSG_No_se_Encontraron_Registros_para_la_Accion_Masiva"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Anterior"
	Default="Anterior"
	returnvariable="BTN_Anterior"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Generar_Acciones"
	Default="Generar Acciones"
	returnvariable="BTN_Generar_Acciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Siguiente"
	Default="Siguiente"
	returnvariable="BTN_Siguiente"/>

<cfoutput>
<form name="formT4" method="post" style="margin: 0;" action="PTU-sql.cfm">
	<input name="RHPTUEid_4" type="hidden" id="RHPTUEid" value="<cfif isdefined("form.RHPTUEid")>#form.RHPTUEid#</cfif>" />
    <input name="tab" id="tab" type="hidden" value="4" />
	<table width="90%" border="0" cellspacing="0" cellpadding="1" align="center">
		<tr>
			<td colspan="4">
				<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
					<tr>
						<td width="19%" nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Detalle_Accion">Detalle PTU</cf_translate>:</div></td>
						<td width="81%" nowrap >#rsRHPTUEt4.RHPTUEcodigo# - #rsRHPTUEt4.RHPTUEdescripcion#</td>
					</tr>
					<tr>
						<td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Fecha_Desde">Fecha Desde</cf_translate>:</div></td>
						<td nowrap >#LSDateFormat(rsRHPTUEt4.FechaDesde,'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Fecha_Hasta">Fecha Hasta</cf_translate>:</div></td>
						<td nowrap >#LSDateFormat(rsRHPTUEt4.FechaHasta,'dd/mm/yyyy')#</td>
					</tr>
                    <!---SML. Inicio Modificacion para agregar dias al trabajador--->
                    <tr>
						<td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Empleado">Empleado</cf_translate>:</div></td>
						<td nowrap><!---<cf_rhempleado tabindex="1">---><input type="hidden" name="DEid4" id="DEid" value="">
                                    <input type="text" name="DEidentificacion4" id="DEidentificacion" value="" size="10" onBlur="javascript: funcTraerEmpleado(this.value);">
										<input type="text" name="Nombre4" id="Nombre" value="" size="40" disabled>
										<a href="javascript: doConlisEmpleados();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de empleados" name="imagen" width="18" height="14" border="0" align="absmiddle"></a></td>
					</tr>
                    <tr>
						<td nowrap class="fileLabel" align="right"><cf_translate key="LB_CantidadDias">Cantidad Dias</cf_translate>:</td>
						<td nowrap><input type="text" name="CantidadDias" id="CantidadDias" value="0" size="10"><input type="submit" name="btnAgregarDias" id="btnAgregarDias" value="Agregar Dias" /></td>
					</tr>
                    <!---SML. Final Modificacion para agregar dias al trabajador--->
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
				<cfset columnas="DEid,DEidentificacion, Nombre, RHPTUEMISPTRetencionPTU, RHPTUEMNetaRecibir, Justificar, Consulta">
                <cfset desplegar="DEidentificacion, Nombre, RHPTUEMISPTRetencionPTU, RHPTUEMNetaRecibir, Justificar, Consulta">
                <cfset etiquetas="#LB_Identificacion#,#LB_Nombre_Empleado#, Retención PTU, PTU Neta, Reconocido, Consultar">
                <cfset formatos="S,S,M,M,G,G">
                <cfset align="left,left,right,right,center,center">
                <cfset ajustar="S,S,S,S,S,S">
                <cfset ValuesArray = ArrayNew(1)>
                <cfset ArrayAppend(ValuesArray, "b.DEidentificacion")>
                <cfset ArrayAppend(ValuesArray, "{fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) }")>
                <cfset ArrayAppend(ValuesArray, "")>
                <cfset ArrayAppend(ValuesArray, "")>
                <cfset filtrar_por4=ValuesArray>

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
                            {fn concat(rtrim(g.Oficodigo),{fn concat(' - ',rtrim(g.Odescripcion))})} as Oficina,
                            case when a.RHPTUEMreconocido = 1
								 then {fn concat({fn concat({fn concat('<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif'' onClick="javascript:return funcJustificar(', '''')}, <cf_dbfunction name="to_char" args="a.RHPTUEMid"> )}, ''');">') }
								 else {fn concat({fn concat({fn concat('<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif'' onClick="javascript:return funcJustificar(', '''')}, <cf_dbfunction name="to_char" args="a.RHPTUEMid"> )}, ''');">') }
							end as Justificar,
							{fn concat({fn concat({fn concat('<img border=''0'' src=''/cfmx/rh/imagenes/iedit.gif'' onClick="javascript:return funcInformacion(', '''')}, <cf_dbfunction name="to_char" args="a.RHPTUEMid"> )}, ''');">') } as Consulta,
                            c.RHPTUEEstado,
                            a.RHPTUEMNetaRecibir,
                            a.RHPTUEMISPTRetencionPTU
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
						<cfinvokeargument name="formName" value="formT4"/>
						<cfinvokeargument name="align" value="#align#"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="ajustar" value="#ajustar#"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="filtrar_por_array" value="#filtrar_por4#"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="emptylistmsg" value=" --- #MSG_No_registros_de_Calculo_del_PTU# ---"/>
						<cfinvokeargument name="keys" value="RHPTUEMid"/>
						<cfinvokeargument name="ira" value="PTU.cfm"/>
						<cfinvokeargument name="maxrows" value="10"/>
                        <cfinvokeargument name="showlink" value="false"/>
                        <cfinvokeargument name="PageIndex" value="T4"/>						
				</cfinvoke>
                
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
        <tr>
        	<td colspan="4" align="center">
            	<cfif rsLista.RHPTUEEstado eq 0>
	                <input name="btnCerrar" value="Cerrar Calculo PTU" type="submit" onclick="return funcCerrar();" /> 
                <cfelse>
                	&nbsp;
                </cfif>
            	
            </td>
        </tr>
	</table>
    <iframe id="fr_empleados" name="fr_empleados" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>
</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	<!--- Variables --->
	var popUpWinSN = 0;
	var _RHPTUEid = document.formT4.RHPTUEid.value;

	function funcJustificar(id) {
		var width = 700;
		var height = 200;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfif rsLista.RHPTUEEstado eq 0> <!--- solo se puede reconocer o no si el PTU está abierto --->
			<cfoutput>
			var nuevo = window.open('PTU-Justificar.cfm?RHPTUEMid='+id+'&RHPTUEid='+_RHPTUEid,'Justificacion','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			nuevo.focus();
			document.formT4.nosubmit = true;
			return false;	
		</cfif>
	}
	
	function funcInformacion(id) {
		popUpWinSN = open('PTU-Consultar.cfm?RHPTUEMid='+id+'&RHPTUEid='+_RHPTUEid, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=800,left=250,top=100,screenX=250,screenY=100');
		document.formT4.nosubmit = true;
		return false;
	}
	
	function funcFiltrar(){
		document.formT4.RHPTUEid.value = _RHPTUEid;
		return true;
	}
	function funcCerrar(){
		if (confirm('¿Está seguro que todos los datos relacionados de este PTU estan correcctos y que desea cerrar este PTU para dejarlo listo para la Relación de Cálculo?')){
			return true;
			}else{
			return false;
			}
		}

	function doConlisEmpleados(){
		var params = '';
		params = params + '?po_form=formT4';
 		<cfif isdefined("rsRHPTUEt4") and rsRHPTUEt4.RecordCount NEQ 0 and len(trim(rsRHPTUEt4.FechaDesde)) and len(trim(rsRHPTUEt4.FechaHasta))>
			<cfoutput>
				params = params + '&pd_acciondesde=#LSDateFormat(rsRHPTUEt4.FechaDesde,"dd/mm/yyyy")#&pd_accionhasta=#LSDateFormat(rsRHPTUEt4.FechaHasta,"dd/mm/yyyy")#';
			</cfoutput>
		</cfif>
		<cfif isdefined('rsValidarEmpresas') and rsValidarEmpresas.RecordCount GT 1>
			<cfoutput>
				params = params + '&Empresa=#ValueList(rsValidarEmpresas.Ecodigo)#';
			</cfoutput>
		</cfif>
		popUpWindow("/cfmx/rh/nomina/masiva/ConlisEmpleadosAccionMasiva.cfm"+params,200,180,650,400);		
	}
	
	function funcTraerEmpleado(prn_DEidentificacion){
		var params = '';
		if (prn_DEidentificacion!=''){	
			<cfif isdefined("rsRHPTUEt4") and rsRHPTUEt4.RecordCount NEQ 0 and len(trim(rsRHPTUEt4.FechaDesde)) and len(trim(rsRHPTUEt4.FechaHasta))>
				<cfoutput>
					params = params + '&pd_acciondesde=#LSDateFormat(rsRHPTUEt4.FechaDesde,"dd/mm/yyyy")#&pd_accionhasta=#LSDateFormat(rsRHPTUEt4.FechaHasta,"dd/mm/yyyy")#';
				</cfoutput>
			</cfif>
			<cfif isdefined('rsValidarEmpresas') and rsValidarEmpresas.RecordCount GT 1>
				<cfoutput>
					params = params + '&Empresa=#ValueList(rsValidarEmpresas.Ecodigo)#';
				</cfoutput>
			</cfif>
	   		document.getElementById("fr_empleados").src = '/cfmx/rh/nomina/masiva/SQLTraeEmpleadosAccionMasiva.cfm?DEidentificacion='+prn_DEidentificacion+'&po_form=formT4'+params;
	  	}
	 	else{
	   		document.formT4.DEid.value = '';
			document.formT4.DEidentificacion.value = '';
	   		document.formT4.Nombre.value = '';
	  	}
	}
</script>
