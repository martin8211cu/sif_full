<!--- VARIABLES DE TRADUCCION --->
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
<!--- FIN VARIABLES TRADUCCION --->
<cfset navegacion = "RHAid=" & Form.RHAid & "&paso=" & Form.paso>
<cfset Form.paso = 5>
<!--- Consultas --->
<cfquery name="rsAccionesMasiva" datasource="#Session.DSN#">
	select a.RHTAid, a.RHAid, a.RHAcodigo, a.RHAdescripcion, a.Ecodigo, b.Edescripcion, a.RHAfdesde, a.RHAfhasta
	from RHAccionesMasiva a
		inner join Empresas b 
		on a.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
</cfquery>


<cfoutput>
<form name="form1" method="post" style="margin: 0;" action="accionesMasiva-sql.cfm">
	<table width="90%" border="0" cellspacing="0" cellpadding="1" align="center">
		<tr>
			<td colspan="4">
				<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
					<tr>
						<td width="19%" nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Detalle_Accion">Detalle Accion</cf_translate>:</div></td>
						<td width="81%" nowrap >#rsAccionesMasiva.RHAcodigo# - #rsAccionesMasiva.RHAdescripcion#</td>
					</tr>
					<tr>
						<td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Fecha_Desde">Fecha Desde</cf_translate>:</div></td>
						<td nowrap >#LSDateFormat(rsAccionesMasiva.RHAfdesde,'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Fecha_Hasta">Fecha Hasta</cf_translate>:</div></td>
						<td nowrap >#LSDateFormat(rsAccionesMasiva.RHAfhasta,'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td nowrap align="right"><input name="chkTipoAplicacion" type="checkbox" checked="checked" /></td>
						<td nowrap class="fileLabel"><div align="left"><cf_translate key="LB_Aplica_todas_plazas">Aplica para todas las plazas</cf_translate></div></td>
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
				<cfif rsDatosAccion.RHTAevaluacion EQ 1>
					<cfset columnas="DEid,DEidentificacion, Nombre, RHEAMevaluacion, Justificar, Informe">
					<cfset desplegar="DEidentificacion, Nombre, RHEAMevaluacion, Justificar, Informe">
					<cfset etiquetas="Identificaci&oacute;n, Nombre Empleado, Evaluacion, Reconocido, Consultar ">
					<cfset formatos="S,S,S,G,G">
					<cfset align="left,left,right,center,center">
					<cfset ajustar="S,S,S,S,S">
					<cfset ValuesArray = ArrayNew(1)>
					<cfset ArrayAppend(ValuesArray, "b.DEidentificacion")>
					<cfset ArrayAppend(ValuesArray, "{fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) }")>
					<cfset ArrayAppend(ValuesArray, "a.RHEAMevaluacion")>
					<cfset ArrayAppend(ValuesArray, "")>
					<cfset filtrar_por=ValuesArray>
					<!----<cfset filtrar_por="b.DEidentificacion,{fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) },a.RHEAMevaluacion,'',''">--->
				<cfelse>
					<cfset columnas="DEid,DEidentificacion, Nombre, RHEAMevaluacion, Justificar, Informe">
					<cfset desplegar="DEidentificacion, Nombre, Justificar, Informe ">
					<cfset etiquetas="#LB_Identificacion#,#LB_Nombre_Empleado#, #LB_Reconocido#, #LB_Consultar#">
					<cfset formatos="S,S,G,G">
					<cfset align="left,left,center,center">
					<cfset ajustar="S,S,S,S">
					<cfset ValuesArray = ArrayNew(1)>
					<cfset ArrayAppend(ValuesArray, "b.DEidentificacion")>
					<cfset ArrayAppend(ValuesArray, "{fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) }")>
					<cfset ArrayAppend(ValuesArray, "")>
					<cfset ArrayAppend(ValuesArray, "")>
					<cfset filtrar_por=ValuesArray>
					<!----<cfset filtrar_por="b.DEidentificacion,rtrim(b.DEnombre)||' '||rtrim(b.DEapellido1)||' '||rtrim(b.DEapellido2),'',''">----->
				</cfif>

				<cfquery name="rsLista" datasource="#session.DSN#" >
					select 	a.RHEAMid,
							a.DEid, b.DEidentificacion,
							{fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) }  as Nombre,
							c.RHAdescripcion, 
							a.RHCPlinea, 
							a.Ecodigo, 
							a.RHAfhasta, 
							a.RHAfdesde, 								
							a.Dcodigo, 
							{fn concat(rtrim(e.Deptocodigo),{fn concat(' - ',rtrim(e.Ddescripcion))})} as Depto,
							a.RHPcodigo, rtrim(f.RHPdescpuesto) as RHPdescpuesto, coalesce(ltrim(rtrim(f.RHPcodigoext)),ltrim(rtrim(f.RHPcodigo))) as RHPcodigoext,
							a.RHAporc, 
							a.Ocodigo, 
							{fn concat(rtrim(g.Oficodigo),{fn concat(' - ',rtrim(g.Odescripcion))})} as Oficina,
							a.RVid, h.Descripcion,
							a.Tcodigo, i.Tdescripcion, 
							a.RHEAMreconocido, 
							a.RHEAMjustificacion, 
							a.RHEAMusuarior, 
							a.RHEAMfecha, 
							a.RHEAMrevaluado, 
							a.RHEAMevaluacion, 
							a.RHEAMfuevaluacion,
							case when a.RHEAMreconocido = 1
								 then {fn concat({fn concat({fn concat('<img border=''0'' src=''/cfmx/rh/imagenes/checked.gif'' onClick="javascript:return funcJustificar(', '''')}, <cf_dbfunction name="to_char" args="a.RHEAMid"> )}, ''');">') }
								 else {fn concat({fn concat({fn concat('<img border=''0'' src=''/cfmx/rh/imagenes/unchecked.gif'' onClick="javascript:return funcJustificar(', '''')}, <cf_dbfunction name="to_char" args="a.RHEAMid"> )}, ''');">') }
							end as Justificar,
							{fn concat({fn concat({fn concat('<img border=''0'' src=''/cfmx/rh/imagenes/iedit.gif'' onClick="javascript:return funcInformacion(', '''')}, <cf_dbfunction name="to_char" args="a.RHEAMid"> )}, ''');">') } as Informe					
					from RHEmpleadosAccionMasiva a
						inner join RHAccionesMasiva c
							on a.RHAid = c.RHAid
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
						left outer join RegimenVacaciones h
							on a.RVid = h.RVid
							and a.Ecodigo = h.Ecodigo
						left outer join TiposNomina i
							on a.Tcodigo = i.Tcodigo
							and a.Ecodigo = i.Ecodigo
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#"> 
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						<cfif isdefined("form.FILTRO_DEIDENTIFICACION") and len(trim(form.FILTRO_DEIDENTIFICACION))>
							and upper(b.DEidentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.FILTRO_DEIDENTIFICACION)#%">
						</cfif>
						<cfif isdefined("form.FILTRO_NOMBRE") and len(trim(form.FILTRO_NOMBRE))>
							and upper({fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) } ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.FILTRO_NOMBRE)#%">
						</cfif>
						order by b.DEidentificacion
				</cfquery>
				<!---En caso de que el tipo de accion que estoy manejando sea tipo anualidad--->
				<cfquery name="Anua" datasource="#session.dsn#">
					select RHTAanualidad 
					from RHAccionesMasiva a
						inner join RHTAccionMasiva b
						on b.RHTAid=a.RHTAid
					where RHAid=#form.RHAid#
				</cfquery>
				
				<cfif Anua.RHTAanualidad eq 0>
					<cfset LvarChk='S'>
				<cfelse>
					<cfset LvarChk='N'>
				</cfif>
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
						<cfinvokeargument name="formName" value="form1"/>						
						<cfinvokeargument name="align" value="#align#"/>
						<cfinvokeargument name="checkboxes" value="#LvarChk#"/>						
						<cfinvokeargument name="ajustar" value="#ajustar#"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>	
						<cfinvokeargument name="filtrar_por_array" value="#filtrar_por#"/>	
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>												
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="emptylistmsg" value=" --- #MSG_No_se_Encontraron_Registros_para_la_Accion_Masiva# ---"/>
						<cfinvokeargument name="keys" value="RHEAMid"/>
						<cfinvokeargument name="ira" value="#CurrentPage#"/>
						<cfinvokeargument name="maxrows" value="10"/>						
				</cfinvoke>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
	</table>
	
	
		<cfinclude template="accionesMasiva-hiddens.cfm">	
		<table width="90%" border="0" cellspacing="0" cellpadding="1" align="center">
			<tr>
				<td colspan="4">
                	<cfif rsLista.recordCount GT 0>
                    	<cf_botones names="btnRegresar,btnEliminar,btnGenerar,btnSiguiente" values="<< #BTN_Anterior#,#LB_Eliminar#,#BTN_Generar_Acciones#,#BTN_Siguiente# >>">
                    <cfelse>
                    	<cf_botones names="btnRegresar,btnSiguiente" values="<< #BTN_Anterior#,#BTN_Siguiente# >>">
                    </cfif>
					
				</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
		</table>
	</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	<!--- Variables --->
	var popUpWinSN = 0;
	var _paso  = document.form1.paso.value;
	var _RHAid = document.form1.RHAid.value;

	function funcJustificar(id) {
		var width = 700;
		var height = 200;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfoutput>
		var nuevo = window.open('accionesMasiva-Justificar.cfm?RHEAMid='+id+'&RHAid='+_RHAid,'Justificacion','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		nuevo.focus();
		document.form1.nosubmit = true;
		return false;	
	}
	
	function funcInformacion(id) {
		popUpWinSN = open('accionesMasiva-Consultar.cfm?RHEAMid='+id+'&RHAid='+_RHAid, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=600,height=600,left=250,top=100,screenX=250,screenY=100');
		document.form1.nosubmit = true;
		return false;
	}
	
	function funcbtnEliminar(a) {
	//alert (document.lista.DEid.value)
		var form = document.form1;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
					//document.form1.LvarChk.value=document.lista.DEid.value
						result = true;
										}
			}
			else{
				if (form.chk.checked)
				//document.form1.LvarChk.value=document.lista.DEid.value
					result = true;
			}
		}

		
		if (!result) {alert("Debe marcar al menos un registro");}
		return result;
		
	}
	
/*	function este(a){
		if (document.lista.chk.checked=true){
		alert (a)}
		else{alert('no')}
	}*/
	function func	(){
		document.form1.PASO.value = _paso;
		document.form1.RHAID.value = _RHAid;
		return true;
	}
	
	function funcbtnRegresar(){
		document.form1.paso.value = "4";
	}
	
	function funcbtnSiguiente(){
		document.form1.paso.value = "6";
	}		
	

</script>
