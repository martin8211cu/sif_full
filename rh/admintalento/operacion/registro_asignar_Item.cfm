<cfif isdefined("url.SEL") and len(trim(url.SEL)) gt 0 and not isdefined("form.SEL")  >
	<cfset form.SEL = url.SEL>
</cfif>
<cfif isdefined("url.RHRSid") and len(trim(url.RHRSid)) gt 0 and not isdefined("form.RHRSid")  >
	<cfset form.RHRSid = url.RHRSid>
</cfif>
<cfif isdefined("url.RHIEid") and len(trim(url.RHIEid)) gt 0 and not isdefined("form.RHIEid")  >
	<cfset form.RHIEid = url.RHIEid>
</cfif>

<cfset modo = "ALTA">
<cfset navegacion = "&SEL=2">
<cfset navegacion = navegacion & "&RHRSid=" & Form.RHRSid>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Eliminar_Registro"
	Default="Eliminar Registro"
	returnvariable="LB_Eliminar_Registro"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaInicio"
	Default="Fecha Inicio"
	returnvariable="LB_FechaInicio"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaFinalizacion"
	Default="Fecha Finalización"
	returnvariable="LB_FechaFinalizacion"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado a Evaluar"
	returnvariable="LB_Empleado"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	returnvariable="LB_Codigo"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	returnvariable="LB_Descripcion"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_VerComportamiento"
	Default="Ver comportamientos de la habilidad"
	returnvariable="LB_VerComportamiento"/>		
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Eliminar_Registro"
	Default="Eliminar Habilidades"
	returnvariable="LB_Eliminar_Registro"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Agregar_habilidades_seleccionadas"
	Default="Agregar Habilidades seleccionadas"
	returnvariable="LB_Agregar_habilidades_seleccionadas"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Modificar_Registro"
	Default="Modificar Registro"
	returnvariable="LB_Modificar_Registro"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Parametrizacion"
	Default="Parametrizaci&oacute;n"
	returnvariable="LB_Parametrizacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleados_a_Evaluar"
	Default="Empleados a Evaluar"
	returnvariable="LB_Empleados_a_Evaluar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Comportamiento"
	Default="Comportamientos asociados a la habilidad seleccionada"
	returnvariable="LB_Comportamiento"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Habilidades"
	Default="Habilidades"
	returnvariable="LB_Habilidades"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Objetivo"
	Default="Objetivo"
	returnvariable="LB_Objetivo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Objetivo_a_Evaluar"
	Default="Objetivos a evaluar"
	returnvariable="LB_Objetivo_a_Evaluar"/>		
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_El_porcentaje_debe_ser_mayor_a_cero"
	Default="La meta debe ser mayor a cero"
	returnvariable="LB_El_porcentaje_debe_ser_mayor_a_cero"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_El_porcentaje_debe_ser_menor_a_cien"
	Default="La meta debe ser menor a cien"
	returnvariable="LB_El_porcentaje_debe_ser_menor_a_cien"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Meta"
	Default="Meta"
	returnvariable="LB_Meta"/>
<cfquery name="rstipo" datasource="#Session.DSN#">
	select RHRStipo
	from RHRelacionSeguimiento
	where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
</cfquery>
<cfquery name="rsEvaluado" datasource="#Session.DSN#">
	select  a.RHEid,
			a.DEid,
			a.RHRSid,
			nt.NTIdescripcion,
			de.DEidentificacion,
			rp.RHPpuesto,
			{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as empleado
	from RHEvaluados a
	inner join DatosEmpleado de
		on a.Ecodigo = de.Ecodigo
		and a.DEid = de.DEid
	inner join NTipoIdentificacion nt
		on de.NTIcodigo = nt.NTIcodigo	
	inner join LineaTiempo lt
		on de.DEid = lt.DEid
		and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">  between LTdesde and  LThasta	
	inner join RHPlazas rp
		on lt.RHPid = rp.RHPid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">							
</cfquery>
<cfif isdefined("form.RHIEid") and len(trim(form.RHIEid))>
	<cfquery name="rsRHItemEvaluar" datasource="#Session.DSN#">
		select 
			RHIEid, 
			RHOSid, 
			RHIEfinicio, 
			RHIEffin, 
			RHIEporcentaje,
			ts_rversion
		from RHItemEvaluar
		where RHIEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIEid#">
	</cfquery>
	<cfset modo = "CAMBIO">
	
</cfif>
<style type="text/css">
	.Completoline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000			
		}
</style>
<cfoutput>
	<form style="margin:0" name="form1" method="post" action="asignar_Item_sql.cfm" >
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
			<tr>
				<td>
					<fieldset><legend>#LB_Parametrizacion#</legend>
					<table width="100%" border="0" cellpadding="1" cellspacing="1">
						<cfif rsEvaluado.recordCount GT 0>
							<tr>
								<td  width="10%">
									<b>#rsEvaluado.NTIdescripcion#:</b>								</td>
								<td>
									#rsEvaluado.DEidentificacion#								</td>
								<td width="10%" nowrap="nowrap"><b><cf_translate  key="LB_Empleado">Empleado</cf_translate>:</b></td>
								<td>
									#rsEvaluado.empleado#	
									<input type="hidden" name="DEid"   	    id="DEid"      value="#rsEvaluado.DEid#">
									<input type="hidden" name="RHRStipo"    id="RHRStipo"  value="#rstipo.RHRStipo#">
									<input type="hidden" name="RHEid"       id="RHEid"     value="#rsEvaluado.RHEid#">
									<input type="hidden" name="SEL"   	    id="SEL"       value="#form.SEL#">
									<input type="hidden" name="RHRSid"   	id="RHRSid"    value="#form.RHRSid#">
									<input type="hidden" name="RHIEid"   	id="RHIEid"    value="<cfif isdefined("form.RHIEid") and len(trim(form.RHIEid))>#form.RHIEid#</cfif>">
								</td>
							</tr>
						<cfelse>
							<tr>
								<td colspan="2" align="center" style="color:RED">
									<cf_translate  key="LB_Para_agregar_los_objetivos_o_conocimientos_es_necesario_indicar_el_empleado_a_evaluar_en_el_paso_1">Para agregar los objetivos o conocimientos  <br />es necesario indicar el empleado a evaluar en el paso 1 </cf_translate>								</td>	
							</tr>
						</cfif>	
					</table>
				</td>
			</tr>
			<cfif rsEvaluado.recordCount GT 0>
				<cfif isdefined("rstipo") and len(trim(rstipo.RHRStipo)) and rstipo.RHRStipo eq 'C'>
					<tr>
						<td colspan="3" align="center">
							<cf_botones  values="Regresar,Siguiente">				
						</td>
					</tr> 
					<tr>
						<td>
							<fieldset><legend>#LB_Habilidades#</legend>
							<table width="100%" border="0" cellpadding="1" cellspacing="1">
								<tr>
									<td valign="top" width="48%" class="Completoline" align="center">
										<b><cf_translate  key="LB_Para_Asignar">Para Asignar</cf_translate></b>
										 &nbsp;<br>
										<cf_dbfunction name="to_char" args="a.RHHid" returnvariable="Lvar_to_char_RHHid">
										
										<cfquery name="rsListaHabilidades" datasource="#session.DSN#">
											select a.RHHid,
											SEL=2,RHRSid=#form.RHRSid#,
											{fn concat('<a href=''javascript: verItem(',{fn concat(#Lvar_to_char_RHHid#,{fn concat(',',{fn concat('1);''>',{fn concat(b.RHHcodigo,'</a>')})})})})} as RHHcodigo,
											{fn concat('<a href=''javascript: verItem(',{fn concat(#Lvar_to_char_RHHid#,{fn concat(',',{fn concat('1);''>',{fn concat(b.RHHdescripcion,'</a>')})})})})} as RHHdescripcion
											from RHHabilidadesPuesto a 
											inner join RHHabilidades b
												on a.RHHid = b.RHHid
											where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and  a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEvaluado.RHPpuesto#">
											and   a.RHHid in (select 	x.RHHid 
																		from  RHComportamiento x  
																		where x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
											and not exists (select 		1 
																		from  RHItemEvaluar z  
																		where z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																		and  a.RHHid = z.RHHid 
																		and z.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvaluado.RHEid#">)
											order by b.RHHcodigo desc
										</cfquery>
										
										<cfinvoke 
											component="rh.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet">
												<cfinvokeargument name="query" value="#rsListaHabilidades#"/>
												<cfinvokeargument name="desplegar" value="RHHcodigo,RHHdescripcion"/>
												<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
												<cfinvokeargument name="formatos" value="V,V"/>
												<cfinvokeargument name="align" value="left,left"/>
												<cfinvokeargument name="ajustar" value="S,S"/>
												<cfinvokeargument name="showEmptyListMsg" value="true"/>
												<cfinvokeargument name="keys" value="RHHid"/>
												<cfinvokeargument name="irA" value="registro_evaluacion.cfm"/>
												<cfinvokeargument name="incluyeForm" value="true"/>	
												<cfinvokeargument name="PageIndex" value="1"/>
												<cfinvokeargument name="checkboxes" value="S"/>
												<cfinvokeargument name="MaxRows" value="10"/>
												<cfinvokeargument name="navegacion" value="#navegacion#"/>
												<cfinvokeargument name="showLink" value="false"/>
											</cfinvoke>									</td>
									<td  width="2%" align="center" valign="middle">
										&nbsp;
										<img  	style="cursor:pointer"
											alt= "#LB_Agregar_habilidades_seleccionadas#" 
											onclick="javascript:agregarComportamientos();" 
											src="/cfmx/rh/imagenes/all.gif" border="0">
										&nbsp;									
									</td>
									<td valign="top" class="Completoline"  align="center">
										<b><cf_translate  key="LB_Para_Evaluar">Para Evaluar</cf_translate></b>
										 &nbsp;<br>
										<cf_dbfunction name="to_char" args="a.RHIEid" returnvariable="Lvar_to_char_RHIEid">
										<cf_dbfunction name="to_char" args="a.RHHid" returnvariable="Lvar_to_char_RHHid">
										<cfquery name="rsListaHabilidades" datasource="#session.DSN#">
											select a.RHHid,a.RHIEid,SEL=2,RHRSid=#form.RHRSid#,
											{fn concat('<a  href=''javascript: verItem(',{fn concat(#Lvar_to_char_RHHid#,{fn concat(',',{fn concat('1);''>',{fn concat(b.RHHcodigo,'</a>')})})})})} as RHHcodigo,
											{fn concat('<a href=''javascript: verItem(',{fn concat(#Lvar_to_char_RHHid#,{fn concat(',',{fn concat('1);''>',{fn concat(b.RHHdescripcion,'</a>')})})})})} as RHHdescripcion,
											'<a href="javascript: EliminarComportamientos(''' || #Lvar_to_char_RHIEid# || ''',0);"><img alt=''#LB_Eliminar_Registro#'' src=''/cfmx/rh/imagenes/Borrar01_S.gif'' border=''0''></a>'  as Eliminar
											from RHItemEvaluar a
											inner join RHHabilidades b
												on a.RHHid = b.RHHid
											where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and   a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvaluado.RHEid#">
											order by b.RHHcodigo desc
										</cfquery>
										<cfinvoke 
											component="rh.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet">
												<cfinvokeargument name="query" value="#rsListaHabilidades#"/>
												<cfinvokeargument name="desplegar" value="RHHcodigo,RHHdescripcion,Eliminar"/>
												<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,&nbsp;"/>
												<cfinvokeargument name="formatos" value="V,V,V"/>
												<cfinvokeargument name="align" value="left,left,Center"/>
												<cfinvokeargument name="ajustar" value="S,S,S"/>
												<cfinvokeargument name="showEmptyListMsg" value="true"/>
												<cfinvokeargument name="keys" value="RHIEid"/>
												<cfinvokeargument name="irA" value="registro_evaluacion.cfm"/>
												<cfinvokeargument name="incluyeForm" value="true"/>	
												<cfinvokeargument name="PageIndex" value="1"/>
												<cfinvokeargument name="MaxRows" value="10"/>
												<cfinvokeargument name="navegacion" value="#navegacion#"/>
												<cfinvokeargument name="showLink" value="false"/>
											</cfinvoke>									</td>
								</tr>
								<tr>
									<td colspan="3">
										<li><font color="##0000FF"><cf_translate  key="LB_x">Para ver los comportamientos asociaciados hacer click sobre la habilidad</cf_translate></font></li>									</td>
								</tr>
							</table>
							</fieldset>	
						</td>
					</tr>
				<cfelse>
					<tr>
						<td>
							<fieldset><legend>#LB_Objetivo#</legend>
							<table width="100%" border="0" cellpadding="1" cellspacing="1">
								<tr>
									<td width="20%"><b><cf_translate  key="LB_Objetivo">Objetivo</cf_translate></b></td>
									<td width="20%" >
										<cfif isdefined("rsRHItemEvaluar.RHOSid") and len(trim(rsRHItemEvaluar.RHOSid))>
											<cfquery name="rsObjetivo" datasource="#session.DSN#">
												select RHOScodigo,RHOStexto 
												from RHObjetivosSeguimiento 
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												and RHOSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHItemEvaluar.RHOSid#">
											</cfquery>
											#rsObjetivo.RHOScodigo#
											<input type="hidden" name="RHOSid"   	    id="RHOSid"      value="#rsRHItemEvaluar.RHOSid#">
										<cfelse>
											<cf_conlis
												Campos="RHOSid,RHOScodigo"
												Desplegables="N,S"
												Modificables="N,S"
												Size="0,10"
												tabindex="1"
												Title="Lista de Objetivos"
												Tabla="RHObjetivosSeguimiento a,RHTipoObjetivo b "
												Columnas="b.RHTOdescripcion,a.RHOSid,a.RHOScodigo,a.RHOStexto,a.RHOSporcentaje,a.RHOSpeso"
												Filtro=" a.Ecodigo = #Session.Ecodigo#  and  a.RHTOid = b.RHTOid and a.RHOSid not in (select x.RHOSid from RHItemEvaluar x where  x.RHOSid = a.RHOSid and x.RHEid = #rsEvaluado.RHEid#)"
												Desplegar="RHOScodigo,RHOStexto"
												Etiquetas="#LB_Codigo#,#LB_Objetivo#"
												filtrar_por="RHOScodigo,RHOStexto"
												Formatos="S,S"
												Align="left,left"
												form="form1"
												Cortes="RHTOdescripcion"
												Asignar="RHOSid,RHOScodigo,RHOStexto"
												Asignarformatos="S,S,S"/>
										</cfif>
									</td>	
									<td rowspan="3">
											<textarea  readonly="readonly" name="RHOStexto" id="RHOStexto" tabindex="1" rows="4" style="width: 100%"><cfif isdefined("rsObjetivo.RHOStexto") and len(trim(rsObjetivo.RHOStexto))>#rsObjetivo.RHOStexto#</cfif></textarea>
									</td>
																	
								</tr>
								<tr>
									<td ><b><cf_translate  key="LB_FechaInicio">Fecha Inicio</cf_translate></b></td>
									<td>
										<cfif isdefined("rsRHItemEvaluar.RHIEfinicio") and len(trim(rsRHItemEvaluar.RHIEfinicio))>
											<cf_sifcalendario name="RHIEfinicio" value="#LSDateformat(rsRHItemEvaluar.RHIEfinicio,'dd/mm/yyyy')#"  tabindex="1">
										<cfelse>
											<cf_sifcalendario name="RHIEfinicio" value="#LSDateFormat(rs_evaluacion_header.RHRSinicio,'dd/mm/yyyy')#"  tabindex="1">
										</cfif>
									</td>									
								</tr>
								<tr>
									<td><b><cf_translate  key="LB_FechaFinaliza">Fecha Finalizaci&oacute;n</cf_translate></b></td>
									<td>
										<cfif isdefined("rsRHItemEvaluar.RHIEffin") and len(trim(rsRHItemEvaluar.RHIEffin))>
											<cf_sifcalendario name="RHIEffin" value="#LSDateformat(rsRHItemEvaluar.RHIEffin,'dd/mm/yyyy')#"  tabindex="1">
										<cfelse>
											<cf_sifcalendario name="RHIEffin" value=""  tabindex="1">
										</cfif>									
									</td>									
								</tr>
								<tr>
									<td ><b><cf_translate  key="LB_Meta">Meta</cf_translate></b></td>
									<td>
										<input  style="text-align: right;" 
										name="RHIEporcentaje" 
										type="text" 
										id="RHIEporcentaje"  
										tabindex="1"
										onBlur="javascript: fm(this,2);"  
										onFocus="javascript:this.value=qf(this); this.select();"  
										onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
										size="6" maxlength="6"
										value="<cfif isdefined("rsRHItemEvaluar.RHIEporcentaje") and len(trim(rsRHItemEvaluar.RHIEporcentaje))>#LSNumberFormat(rsRHItemEvaluar.RHIEporcentaje,',.00')#<cfelse>0.00</cfif>">%										
									</td>									
								</tr>
								<tr>
									<td colspan="3" align="center">
											<cf_botones modo="#modo#" include="Regresar,Siguiente">
									</td>
								</tr> 
							</table>
							</fieldset>						
						</td>
					</tr>
					<cfset ts = "">
					<cfif isdefined("rsRHItemEvaluar") and rsRHItemEvaluar.RecordCount>
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
							artimestamp="#rsRHItemEvaluar.ts_rversion#" returnvariable="ts">
						</cfinvoke>
					</cfif>
					<input type="hidden" name="ts_rversion" value="#ts#">
				</cfif>
			</cfif>
		</table> 
	</form>
	<cfif rsEvaluado.recordCount GT 0>
		<cfif isdefined("rstipo") and len(trim(rstipo.RHRStipo)) and rstipo.RHRStipo eq 'C'>
				<fieldset><legend>#LB_Comportamiento#</legend>
		<cfelse>
				<fieldset><legend>#LB_Objetivo_a_Evaluar#</legend>
		</cfif>
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
			<tr>
				<td valign="top" align="center">
				<cfif isdefined("rstipo") and len(trim(rstipo.RHRStipo)) and rstipo.RHRStipo eq 'C'>
						<iframe  
						id="INFO" 
						name="MOD_INFO" 
						marginheight="0" 
						marginwidth="0" 
						frameborder="0" 
						height="200px"
						width="100%"  
						style="border:none"  scrolling="auto" 
						src="" ></iframe>				
				<cfelse>
					<div align="center" style=" width:98%; height:200px; border:none; overflow:auto; display:block; padding: 2 2 2 2;" > 
						<cfquery name="rsLista" datasource="#session.DSN#">
							select a.RHIEid,c.RHTOdescripcion,b.RHOScodigo,b.RHOStexto,SEL=2,RHRSid=#form.RHRSid#,a.RHIEfinicio,a.RHIEffin,a.RHIEporcentaje  
							from RHItemEvaluar a
							inner join RHObjetivosSeguimiento b 
								on a.RHOSid = b.RHOSid	
							inner  join RHTipoObjetivo c
								on b.RHTOid = c.RHTOid
							where a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEvaluado.RHEid#"> 
							and a.RHOSid is not null
							and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							order by c.RHTOdescripcion,b.RHOScodigo
						</cfquery>
						<cfinvoke 
						component="rh.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="RHOScodigo,RHOStexto,RHIEfinicio,RHIEffin,RHIEporcentaje"/>
							<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Objetivo#,#LB_FechaInicio#,#LB_FechaFinalizacion#,#LB_Meta#&nbsp;%"/>
							<cfinvokeargument name="formatos" value="V,V,D,D,M"/>
							<cfinvokeargument name="align" value="left,left,Center,Center,Right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="Cortes" value="RHTOdescripcion"/>
							<cfinvokeargument name="irA" value="registro_evaluacion.cfm"/>
							<cfinvokeargument name="keys" value="RHIEid"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							</cfinvoke>						
					</div>					
				</cfif>
					
							
				</td>
			</tr>
		</table>
		</fieldset>
	</cfif>	
</cfoutput>

<cfif isdefined("rstipo") and len(trim(rstipo.RHRStipo)) and rstipo.RHRStipo neq 'C'>
	<cf_qforms>
</cfif>
<script language="javascript" type="text/javascript">
	<cfif isdefined("rstipo") and len(trim(rstipo.RHRStipo)) and rstipo.RHRStipo eq 'C'>
		function verItem(llave,tipo){
			// tipo = 1 Comportamiento  , 2 Objetivo
			var LLAVE		= llave;
			var TIPO		= tipo;
			params = "?LLAVE="+LLAVE+"&TIPO="+TIPO;
			var frame = document.getElementById("INFO");
			frame.src = "VerItem.cfm"+params;
		}
		function EliminarComportamientos(llave,nada){
			document.form1.RHIEid.value = llave;
			document.form1.submit();
		}

		function agregarComportamientos(){
			if(validacheck())
				document.form1.submit();
		}
		
		function validacheck() {
			var valida = true;
			if (document.form1.chk) {
				if (document.form1.chk.value) {
					if (!document.form1.chk.checked){
						valida = false;
					}	
				} else {
					valida = false;
					for (var i=0; i<document.form1.chk.length; i++) {
						if (document.form1.chk[i].checked)  valida = true;
					}
				}
			}
			if(!valida){
				alert('Debe seleccionar al menos una habilidad');
			}
			return valida;
		}
		
	<cfelse>
		
		
		<cfoutput>
			function Porcentaje_valida(){
				var Cantidad = new Number(this.value)	
				if ( Cantidad <= 0){
					this.error = "#LB_El_porcentaje_debe_ser_mayor_a_cero#";
				}
				if ( Cantidad > 100){
					this.error = "#LB_El_porcentaje_debe_ser_menor_a_cien#";
				}		
			}


		
			objForm.RHOSid.required        		= true;
			objForm.RHOSid.description     		= "#LB_Objetivo#";
			objForm.RHIEfinicio.required        = true;
			objForm.RHIEfinicio.description     = "#LB_FechaInicio#";	
			objForm.RHIEffin.required        	= true;
			objForm.RHIEffin.description     	= "#LB_FechaFinalizacion#";
			objForm.RHIEporcentaje.description     		= "#LB_Meta#";
			_addValidator("isPorcentaje", Porcentaje_valida);
			objForm.RHIEporcentaje.validatePorcentaje();	
			objForm.RHIEporcentaje.required        		= true;

			
		</cfoutput>
		function habilitarValidacion(){
			objForm.RHOSid.required    		= true;
			objForm.RHIEfinicio.required	= true;
			objForm.RHIEffin.required   	= true;
			objForm.RHIEporcentaje.required	= true;
		}
		function deshabilitarValidacion(){
			objForm.RHOSid.required    		= false;
			objForm.RHIEfinicio.required	= false;
			objForm.RHIEffin.required   	= false;
			document.form1.RHIEporcentaje.value = 1;
			objForm.RHIEporcentaje.required	= false;
		}	
	</cfif>
	function funcSiguiente(){
		<cfif isdefined("rstipo") and len(trim(rstipo.RHRStipo)) and rstipo.RHRStipo neq 'C'>
			deshabilitarValidacion();
		</cfif>
		document.form1.submit();
	}
	function funcRegresar(){
		<cfif isdefined("rstipo") and len(trim(rstipo.RHRStipo)) and rstipo.RHRStipo neq 'C'>
			deshabilitarValidacion();
		</cfif>
		document.form1.submit();
	}
	
</script>