<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Url.fCFdescripcion") and not isdefined("Form.fCFdescripcion")>
	<cfset Form.fCFdescripcion = Url.fCFdescripcion>
</cfif>
<cfif isdefined("Url.fGenMarcas") and not isdefined("Form.fGenMarcas")>
	<cfset Form.fGenMarcas = Url.fGenMarcas>
</cfif>
<cfif isdefined("Url.fGenIncidencias") and not isdefined("Form.fGenIncidencias")>
	<cfset Form.fGenIncidencias = Url.fGenIncidencias>
</cfif>

<cfif isdefined("Form.fCFdescripcion") and Len(Trim(Form.fCFdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and upper(b.CFdescripcion) like '%" & Ucase(Form.fCFdescripcion) & "%'">
	<cfset navegacion = Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCFdescripcion=" & Form.fCFdescripcion>
</cfif>
<cfif isdefined("Form.fGenMarcas") and Len(Trim(Form.fGenMarcas)) NEQ 0>
	<cfset filtro = filtro & " and convert(varchar, a.RHPMfproceso, 103) = '" & Form.fGenMarcas & "'">
	<cfset navegacion = Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fGenMarcas=" & Form.fGenMarcas>
</cfif>
<cfif isdefined("Form.fGenIncidencias") and Len(Trim(Form.fGenIncidencias)) NEQ 0>
	<cfset filtro = filtro & " and convert(varchar, a.RHPMfcierre, 103) = '" & Form.fGenIncidencias & "'">
	<cfset navegacion = Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fGenIncidencias=" & Form.fGenIncidencias>
</cfif>

<!-----================= TRADUCCION ===================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Desea_aplicar_las_incidencias_generadas_por_las_marcas_de_control"
	Default="¿Desea aplicar las incidencias generadas por las marcas de control?"	
	returnvariable="MSG_Desea_aplicar_las_incidencias_generadas_por_las_marcas_de_control"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Desea_hacer_cambios_masivos"
	Default="¿Desea hacer cambios masivos?"	
	returnvariable="MSG_Desea_hacer_cambios_masivos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_de_Corte"
	Default="Fecha de Corte"	
	returnvariable="LB_Fecha_de_Corte"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado"
	Default="Estado"	
	returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Justificacion_Masiva"
	Default="Justificación Masiva"	
	returnvariable="LB_Justificacion_Masiva"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Aplicar"
	Default="Aplicar"	
	returnvariable="LB_Aplicar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Generar_Lotes_de_Marcas"
	Default="Generar Lotes de Marcas"
	returnvariable="BTN_Generar_Lotes_de_Marcas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cerrado"
	Default="Cerrado"	
	returnvariable="LB_Cerrado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Marcas_Pendientes_de_Revisar"
	Default="Marcas Pendientes de Revisar"	
	returnvariable="LB_Marcas_Pendientes_de_Revisar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Pendiente_de_Aplicar"
	Default="Pendiente de Aplicar"	
	returnvariable="LB_Pendiente_de_Aplicar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_No_hay_Marcas_de_Reloj"
	Default="No hay Marcas de Reloj"	
	returnvariable="LB_No_hay_Marcas_de_Reloj"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_No_hay_Marcas_de_Control"
	Default="No hay Marcas de Control"	
	returnvariable="LB_No_hay_Marcas_de_Control"/>


<script language="javascript" type="text/javascript">
	<cfoutput>
	function limpiar() {
		document.filtro.fCFdescripcion.value = "";
		document.filtro.fGenMarcas.value = "";
//		document.filtro.fGenIncidencias.value = "";
	}
	
	function ProcesarBatch() {
		var width = 450;
		var height = 100;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var nuevo = window.open('/cfmx/rh/marcas/operacion/GenerarMarcas.cfm','GeneracionMarcas','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}

	function AplicarInc(batch) {
		if (confirm("#MSG_Desea_aplicar_las_incidencias_generadas_por_las_marcas_de_control#")) {
			document.goMarca2.RHPMid.value = batch;
			document.goMarca2.submit();
		}
	}
	function AplicaMasiva(batch) {
		if (confirm("#MSG_Desea_hacer_cambios_masivos#")) {
		
			var dir = '/cfmx/rh/marcas/operacion/AplicacionMasiva.cfm?RHPMid='+ batch;
			var width = 600;
			var height = 250;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			var nuevo = window.open(dir,'AplicacionMasiva','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			nuevo.focus();
		}
	}
	
	function funcNuevo() {
		document.frmMarcasLotes.action = 'ProcesamientoMarcas.cfm';
	}
	</cfoutput>
</script>

<form name="goMarca3" method="post" action="AplicacionMasiva.cfm" style="margin: 0; ">
	<input type="hidden" name="RHPMid" value="">
</form>

<form name="goMarca2" method="post" action="AplicarIncidencias-SQL.cfm" style="margin: 0; ">
	<input type="hidden" name="RHPMid" value="">
</form>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top">
			<form style="margin: 0" name="filtro" method="post" action="ProcesamientoMarcas.cfm">
				<cfoutput>
				<table border="0" width="100%" class="areaFiltro">
				  <tr> 
					<td nowrap><cf_translate key="LB_Centro_Funcional">Centro Funcional</cf_translate></td>
					<td nowrap><cf_translate key="LB_Fecha_de_Corte">Fecha de Corte</cf_translate></td>
					<!--- <td nowrap>Fecha de Cierre </td> --->
					<td nowrap>&nbsp;</td>
				  </tr>
				  <tr> 
					<td nowrap>
						<input type="text" name="fCFdescripcion" value="<cfif isdefined("form.fCFdescripcion") and len(trim(form.fCFdescripcion)) gt 0 >#form.fCFdescripcion#</cfif>" size="30" maxlength="50" onFocus="javascript:this.select();" >
					</td>
					<td nowrap>
						<cfif isdefined("Form.fGenMarcas")>
							<cfset fecha = Form.fGenMarcas>
							<cfelse>
							<cfset fecha = "">
						</cfif>
						<cf_sifcalendario form="filtro" value="#fecha#" name="fGenMarcas">
					</td>
					<!---
					<td nowrap>
						<cfif isdefined("Form.fGenIncidencias")>
							<cfset fecha = Form.fGenIncidencias>
							<cfelse>
							<cfset fecha = "">
						</cfif>
						<cf_sifcalendario form="filtro" value="#fecha#" name="fGenIncidencias">
					</td>
					--->
					<td nowrap>
						<input type="submit" name="Filtrar" value="#BTN_Filtrar#">
						<input type="button" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: limpiar();">
					</td>
				  </tr>
				</table>
				</cfoutput>
			  </form>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<cfquery name="rslista" datasource="#session.DSN#">
				select 	a.RHPMid,b.CFdescripcion as CFid, a.RHPMfproceso, a.RHPMfcierre,
						case when exists (select 1 from RMarcas x where x.RHPMid = a.RHPMid and x.RMmarcaproces = 0) then
							{fn concat({fn concat({fn concat('<img border=''0'' src=''/cfmx/rh/imagenes/MasterDetail.gif'' onClick="javascript: ProcesarBatch(', '''')}, <cf_dbfunction name="to_char" args="a.RHPMid"> )}, ''');">') } 
						else 
							'&nbsp;'
						end as GeneraMarcasA,
						case when exists (select 1 from RHControlMarcas y where y.RHPMid = a.RHPMid) and (select RHUMjmasiva from RHUsuariosMarcas d where d.Usucodigo = #session.Usucodigo# and d.CFid = a.CFid)=1 then
							{fn concat({fn concat({fn concat('<img border=''0'' src=''/cfmx/rh/imagenes/MasterDetail.gif'' onClick="javascript: AplicaMasiva(', '''')}, <cf_dbfunction name="to_char" args="a.RHPMid"> )}, ''');">') }  
						else 
							'&nbsp;' 
						end as AprobMasiva,
						case when a.RHPMfcierre is null and exists (select 1 from RHControlMarcas y where y.RHPMid = a.RHPMid) and not exists (select 1 from RHControlMarcas y where y.RHPMid = a.RHPMid and y.RHCMinconsistencia = 1) then
							{fn concat({fn concat({fn concat('<img border=''0'' src=''/cfmx/rh/imagenes/MasterDetail.gif'' onClick="javascript: AplicarInc(', '''')}, <cf_dbfunction name="to_char" args="a.RHPMid"> )}, ''');">') }  
						else 
							'&nbsp;'
						end as AplicaIncidencias,
						case 	when a.RHPMfcierre is not null then '#LB_Cerrado#' 
							  	when exists (select 1 from RHControlMarcas y where y.RHPMid = a.RHPMid and y.RHCMinconsistencia = 1) then 
									'#LB_Marcas_Pendientes_de_Revisar#' 
							  	when exists (select 1 from RHControlMarcas y where y.RHPMid = a.RHPMid and y.RHCMinconsistencia = 0) then 
									'#LB_Pendiente_de_Aplicar#' 
							  	when not exists (select 1 from RMarcas y where y.RHPMid = a.RHPMid) then 
									'#LB_No_hay_Marcas_de_Reloj#' 
							  	when not exists (select 1 from RHControlMarcas y where y.RHPMid = a.RHPMid) then 
									'#LB_No_hay_Marcas_de_Control#' 
						else 
							'&nbsp;' 
						end as Estado
			
				from RHProcesamientoMarcas a, CFuncional b, RHUsuariosMarcas c
				where a.Ecodigo = #Session.Ecodigo#
					and a.Ecodigo = b.Ecodigo
					and a.CFid = b.CFid
					and a.Ecodigo = c.Ecodigo
					and a.CFid = c.CFid
					and c.Usucodigo = #Session.Usucodigo#
					and (c.RHUMtmarcas = 1 or c.RHUMgincidencias = 1)
					and a.RHPMfcierre is null
					and 0 < (select count(1)
									from RHJornadas e, RHControlMarcas d
									where 
										 d.BMUsucodigo=#Session.Usucodigo#	
										and d.RHPMid = a.RHPMid
										and d.RHJid = e.RHJid
										and e.RHJjsemanal = 0 )						
					order by   b.CFdescripcion,a.RHPMfproceso desc, a.RHPMfcierre desc
			</cfquery>
			<cfinvoke
				Component= "rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaEmpl">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="RHPMfproceso, Estado, AprobMasiva,AplicaIncidencias"/>
					<cfinvokeargument name="etiquetas" value="#LB_Fecha_de_Corte#, #LB_Estado#, #LB_Justificacion_Masiva#, #LB_Aplicar#"/>
					<cfinvokeargument name="formatos" value="D, V, IMG, IMG"/>
					<cfinvokeargument name="align" value="center, left, center, center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value="Marcas.cfm"/>
					<cfinvokeargument name="keys" value="RHPMid"/>
					<cfinvokeargument name="formName" value="frmMarcasLotes"/>
					<cfinvokeargument name="maxRows" value="15"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="PageIndex" value="1"/>
					<cfinvokeargument name="cortes" value="CFid"/>
			</cfinvoke>
			<!----
			<cfdump var="#t#">
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="RHProcesamientoMarcas a, CFuncional b, RHUsuariosMarcas c"/>
				<cfinvokeargument name="columnas" value="a.RHPMid,b.CFdescripcion as CFid, a.RHPMfproceso, a.RHPMfcierre,
														 case when exists (select 1 from RMarcas x where x.RHPMid = a.RHPMid and x.RMmarcaproces = 0) then '<a href=''javascript: ProcesarBatch(' || convert(varchar, a.RHPMid) || ');''><img src=''/cfmx/rh/imagenes/MasterDetail.gif'' border=''0''></a>' else '&nbsp;' end as GeneraMarcas,
														 case when exists (select 1 from RHControlMarcas y where y.RHPMid = a.RHPMid) and (select RHUMjmasiva from RHUsuariosMarcas d where d.Usucodigo = #session.Usucodigo# and d.CFid = a.CFid)=1 then '<a href=''javascript: AplicaMasiva(' || convert(varchar, a.RHPMid) || ');''><img src=''/cfmx/rh/imagenes/MasterDetail.gif'' border=''0''></a>' else '&nbsp;' end as AprobMasiva,
														 case when a.RHPMfcierre is null and exists (select 1 from RHControlMarcas y where y.RHPMid = a.RHPMid) and not exists (select 1 from RHControlMarcas y where y.RHPMid = a.RHPMid and y.RHCMinconsistencia = 1) then '<a href=''javascript: AplicarInc(' || convert(varchar, a.RHPMid) || ');''><img src=''/cfmx/rh/imagenes/MasterDetail.gif'' border=''0''></a>' else '&nbsp;' end as AplicaIncidencias,
														 case when a.RHPMfcierre is not null then 'Cerrado' 
														 	  when exists (select 1 from RHControlMarcas y where y.RHPMid = a.RHPMid and y.RHCMinconsistencia = 1) then 'Marcas Pendientes de Revisar' 
														 	  when exists (select 1 from RHControlMarcas y where y.RHPMid = a.RHPMid and y.RHCMinconsistencia = 0) then 'Pendiente de Aplicar' 
															  when not exists (select 1 from RMarcas y where y.RHPMid = a.RHPMid) then 'No hay Marcas de Reloj' 
															  when not exists (select 1 from RHControlMarcas y where y.RHPMid = a.RHPMid) then 'No hay Marcas de Control' 
															  else '&nbsp;' end as Estado
														 "/>
				<cfinvokeargument name="desplegar" value="RHPMfproceso, Estado, AprobMasiva,AplicaIncidencias"/>
				<cfinvokeargument name="etiquetas" value="Fecha de Corte, Estado, Justificación Masiva,Aplicar"/>
				<cfinvokeargument name="formatos" value="D, V, IMG, IMG"/>
				<cfinvokeargument name="filtro" value="	a.Ecodigo = #Session.Ecodigo#
														and a.Ecodigo = b.Ecodigo
														and a.CFid = b.CFid
														and a.Ecodigo = c.Ecodigo
														and a.CFid = c.CFid
														and c.Usucodigo = #Session.Usucodigo#
														and (c.RHUMtmarcas = 1 or c.RHUMgincidencias = 1)
														and a.RHPMfcierre is null
														and 0 < (select count(1)
																		from RHJornadas e, RHControlMarcas d
																		where 
																			 d.BMUsucodigo=#Session.Usucodigo#	
																			and d.RHPMid = a.RHPMid
																			and d.RHJid = e.RHJid
																			and e.RHJjsemanal = 0 )	
														#filtro#
														order by   b.CFdescripcion,a.RHPMfproceso desc, a.RHPMfcierre desc
														"/><!---  --->
				<cfinvokeargument name="align" value="center, left, center, center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="Marcas.cfm"/>
				<cfinvokeargument name="keys" value="RHPMid"/>
				<cfinvokeargument name="formName" value="frmMarcasLotes"/>
				<cfinvokeargument name="maxRows" value="15"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="PageIndex" value="1"/>
				<cfinvokeargument name="cortes" value="CFid"/>
			</cfinvoke>
			---->			
		</td>
	</tr>
	<tr>
	  <td align="center" valign="top">
		  <form name="form1" method="post" action="">
			<cfoutput><input name="btnGenerar" type="button" id="btnGenerar" value="#BTN_Generar_Lotes_de_Marcas#" onClick="javascript: ProcesarBatch();"></cfoutput>
		  </form>
	  </td>
  	</tr>
	<tr>
	  <td align="center" valign="top">&nbsp;</td>
  </tr>
</table>

