<!---
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
<cf_templatecss>
</head>

<body style="margin:0">
<script language="javascript" type="text/javascript" src="../../../../sif/js/utilesMonto.js">//</script>
<cfset modo = 'ALTA'>

<cfif isdefined('url.id_requisito') and not isdefined('form.id_requisito')>
	<cfparam name="form.id_requisito" default="#url.id_requisito#">
</cfif>
<cfif isdefined('url.RHRCfdesde') and not isdefined('form.RHRCfdesde')>
	<cfparam name="form.RHRCfdesde" default="#url.RHRCfdesde#">
</cfif>
<cfif isdefined('url.id_agenda') and not isdefined('form.id_agenda')>
	<cfparam name="form.id_agenda" default="#url.id_agenda#">
</cfif>

<cfquery name="rsAgendas" datasource="#session.tramites.dsn#">
	Select id_requisito,nombre_requisito,tpr.id_tiposerv, id_agenda, (rtrim(codigo_agenda) || ' - ' || rtrim(ubicacion) || ' - ' || rtrim(nombre_agenda)) as agenda
	from TPRequisito tpr
		inner join TPTipoServicio ts
			on ts.id_tiposerv=tpr.id_tiposerv
	
		inner join TPAgenda tpa
			on tpa.id_tiposerv=ts.id_tiposerv
				and getDate() between tpa.vigente_desde and tpa.vigente_hasta
	where es_cita = 1
	order by id_requisito
</cfquery>

<cfif isdefined('rsAgendas') and rsAgendas.recordCount GT 0>
	<cfquery name="rsReq" dbtype="query">
		select distinct id_requisito,nombre_requisito
		from rsAgendas
		order by nombre_requisito
	</cfquery>
	<cfquery name="rsDetReq" datasource="#session.tramites.dsn#">
		select id_requisito,id_dato,nombre_dato,tipo_dato,lista_valores
		from TPDatoRequisito
		where id_requisito=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReq.id_requisito#">
		order by nombre_dato	
	</cfquery>	
</cfif>

<cfif isdefined('form.id_agenda') and form.id_agenda NEQ ''
	and  isdefined('form.id_requisito') and form.id_requisito NEQ ''
	and  isdefined('form.RHRCfdesde') and form.RHRCfdesde NEQ ''>
	
	<cfquery name="rsPersonasReqBASE" datasource="#session.tramites.dsn#">
		select  id_dato,valor,tp.id_persona,identificacion_persona,(nombre || ' ' || apellido1|| ' ' || apellido2) as nombrePer
		from TPCita tpc
			inner join TPPersona tp
				on tp.id_persona=tpc.id_persona
		
			inner join TPRequisito tpr
				on tpr.id_requisito=tpc.id_requisito
		
		
			inner join TPHorario tph
				on tph.id_requisito=tpr.id_requisito
					and tph.id_horario=tpc.id_horario
					
			inner join TPAgenda tpa
				on tpa.id_agenda=tph.id_agenda
					and tpa.id_tiposerv=tpr.id_tiposerv


			left outer join TPExpediente ex
				on ex.id_persona=tp.id_persona
					and ex.id_requisito=tpr.id_requisito

			left outer join TPDatoExpediente de
				on de.id_expediente=ex.id_expediente					
		
		where fecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" 	 value="#LSParseDateTime(form.RHRCfdesde)#">
			and fecha < <cfqueryparam cfsqltype="cf_sql_timestamp" 	 value="#DateAdd('d', 1, LSParseDateTime(form.RHRCfdesde))#">
			and tpc.id_requisito=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
			and tpa.id_agenda=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agenda#">
	</cfquery>
	
	<cfif isdefined('rsPersonasReqBASE') and rsPersonasReqBASE.recordCount GT 0>
		<cfquery name="rsPersonasReq" dbtype="query">
			select distinct id_persona,identificacion_persona,nombrePer
			from rsPersonasReqBASE
			order by nombrePer
		</cfquery>
		
		<cfquery name="rsPersonasValores" dbtype="query">
			select id_dato,valor,id_persona
			from rsPersonasReqBASE
			order by nombrePer
		</cfquery>		
	</cfif>
	
	<cfquery name="rsRequisitoBase" datasource="#session.tramites.dsn#" >
		select 
			id_dato
			, tpd.id_requisito
			, codigo_dato
			, nombre_dato
			, tipo_dato
			, lista_valores
			, es_encabezado
		from TPDatoRequisito tpd
		
		inner join TPRequisito tpr
			on tpr.id_requisito=tpd.id_requisito
		
		where tpd.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
	</cfquery>	

	<cfif isdefined('rsRequisitoBase') and rsRequisitoBase.recordCount GT 0>
		<cfquery name="rsReqEncab" dbtype="query">
			select *
			from rsRequisitoBase
			where es_encabezado = 1
		</cfquery>
		<cfquery name="rsReqLista" dbtype="query">
			select *
			from rsRequisitoBase
			where es_encabezado = 0		
		</cfquery>
	</cfif>
</cfif>

<cfoutput>
	<table border="0" width="540" align="center">
		<tr>
			<td>
			<form action="reg_agenda-sql.cfm" method="post" name="formExped" onSubmit="javascript: return valida(this);">		
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="20%" align="right"><strong>Fecha:</strong></td>
				<td width="3%">
					
				</td>
				<td width="77%">
					<cfif isdefined('form.RHRCfdesde') and form.RHRCfdesde NEQ ''>
						<cf_sifcalendario form="formExped" name="RHRCfdesde" onBlur="changeFecha(this);" value="#LSDateFormat(form.RHRCfdesde,'dd/mm/yyyy')#" tabindex="1">
					<cfelse>
						<cf_sifcalendario form="formExped" name="RHRCfdesde" onBlur="changeFecha(this);" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">	
					</cfif>
					<input type="hidden" name="RHRCfdesde_tmp" value="<cfif isdefined('form.RHRCfdesde') and form.RHRCfdesde NEQ ''>#form.RHRCfdesde#</cfif>">										
				</td>
				</tr>
			  <tr>
				<td align="right"><strong>Requisito:</strong></td>
				<td>&nbsp;</td>
				<td>
					<select name="id_requisito" id="id_requisito" onChange="javascript: CargaAgenda(this.value,<cfif isdefined('form.id_agenda') and form.id_agenda NEQ ''>#form.id_agenda#<cfelse>'*'</cfif>);">
						<cfif isdefined('rsReq') and rsReq.recordCount GT 0>
							<cfloop query="rsReq">
								<option value="#rsReq.id_requisito#" <cfif isdefined('form.id_requisito') and form.id_requisito EQ rsReq.id_requisito> selected</cfif>>#rsReq.nombre_requisito#</option>
							</cfloop>
						</cfif>
					</select>
					<input type="hidden" name="id_requisito_tmp" value="<cfif isdefined('form.id_requisito') and form.id_requisito NEQ ''>#form.id_requisito#</cfif>">					
				</td>
				</tr>						
			  <tr>
				<td align="right"><strong>Agenda:</strong></td>
				<td>&nbsp;</td>
				<td>
					<select name="id_agenda" id="id_agen" onChange="javascript: CambioAgenda(this.value);">
					</select>
					<input type="hidden" name="id_agenda_tmp" value="<cfif isdefined('form.id_agenda') and form.id_agenda NEQ ''>#form.id_agenda#</cfif>">
				</td>
				</tr>		
				<cfif (isdefined('rsPersonasReq') and rsPersonasReq.recordCount GT 0) 
						and (isdefined('rsReqEncab') and rsReqEncab.recordCount GT 0)>
					
					<cfloop query="rsReqEncab">
						<cfif isdefined('rsPersonasValores') and rsPersonasValores.recordCount GT 0>
							<cfquery name="rsPerVal" dbtype="query">
								select *
								from rsPersonasValores
								where id_dato = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReqEncab.id_dato#">
							</cfquery>
						</cfif>
					
						<tr>
							<td align="right" nowrap><strong>#rsReqEncab.nombre_dato#:</strong></td>
							<td>&nbsp;</td>
							<td>
								<!--- check --->
								<cfif rsReqEncab.tipo_dato eq 'B' >
									<input type="checkbox" name="datoGlobal_#rsReqEncab.id_dato#" 
										<cfif isdefined('rsPerVal') and rsPerVal.recordCount GT 0
											and rsPerVal.valor NEQ '' and rsPerVal.valor EQ 1>
												checked
										</cfif>
									>
								<!--- string --->
								<cfelseif rsReqEncab.tipo_dato eq 'S' > 
									<cfif len(trim(rsReqEncab.lista_valores))>
										<select name="datoGlobal_#rsReqEncab.id_dato#">
											<option value="">-seleccionar-</option>
											<cfloop list="#rsReqEncab.lista_valores#" index="lvalor">
												<option value="#lvalor#" 
													<cfif isdefined('rsPerVal') and rsPerVal.recordCount GT 0
														and rsPerVal.valor NEQ '' and rsPerVal.valor EQ lvalor>												
															selected
													</cfif>
													>#lvalor#</option>
											</cfloop>
										</select>
									<cfelse>
										<input type="text" name="datoGlobal_#rsReqEncab.id_dato#" 
											<cfif isdefined('rsPerVal') and rsPerVal.recordCount GT 0
												and rsPerVal.valor NEQ ''>
													value="#trim(rsPerVal.valor)#"
											</cfif>										
										size="30" maxlength="100" onFocus="this.select();" >
									</cfif>
								<!--- float, numeric --->
								<cfelse>
									<cfif len(trim(rsReqEncab.lista_valores))>
										<select name="datoGlobal_#rsReqEncab.id_dato#">
											<option value="">-seleccionar-</option>
											<cfloop list="#rsReqEncab.lista_valores#" index="valor">
												<option value="#valor#" 
													<cfif isdefined('rsPerVal') and rsPerVal.recordCount GT 0
														and rsPerVal.valor NEQ '' and rsPerVal.valor EQ lvalor>			
															selected
													</cfif>												
												>#valor#</option>
											</cfloop>
										</select>
									<cfelse>
										<input type="text" name="datoGlobal_#rsReqEncab.id_dato#" 
											<cfif isdefined('rsPerVal') and rsPerVal.recordCount GT 0
												and rsPerVal.valor NEQ ''>			
													value="#trim(rsPerVal.valor)#"
											</cfif>										
											size="12" maxlength="12" style="text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
									</cfif>
								</cfif>							
							</td>
						</tr>		  
					</cfloop>
				</cfif>
			</table>
				
			  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
					  <td width="19%">&nbsp;</td>
					  <td width="67%">&nbsp;</td>
					  <td width="14%">&nbsp;</td>
					</tr>
					<tr>
					  <td colspan="3">
					  <cfif isdefined('rsPersonasReq') and rsPersonasReq.recordCount GT 0>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr bgcolor="##EBEBEB">
									<td align="center"><strong>C&eacute;dula</strong></td>
									<td><strong>Nombre</strong></td>
									<cfif isdefined('rsReqLista') and rsReqLista.recordCount GT 0>
										<cfloop query="rsReqLista">
											<td><strong>#rsReqLista.nombre_dato#</strong></td>
										</cfloop>
									</cfif>						
								</tr>
								<tr>
									<td width="19%">&nbsp;</td>
									<td width="67%">&nbsp;</td>
									<cfif isdefined('rsReqLista') and rsReqLista.recordCount GT 0>
										<cfloop query="rsReqLista">
											<td>&nbsp;</td>
										</cfloop>
									</cfif>		
								</tr>			
								
								
								
								
								<cfloop query="rsPersonasReq" >	
									<cfset codPersona = rsPersonasReq.id_persona>	
									<tr class=<cfif rsPersonasReq.CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='listaPar';">							
										<td align="center">#rsPersonasReq.identificacion_persona#&nbsp;&nbsp;</td>
										<td>#rsPersonasReq.nombrePer#&nbsp;&nbsp;</td>
	 									<cfif isdefined('rsReqLista') and rsReqLista.recordCount GT 0>
											<cfloop query="rsReqLista">
												<cfif isdefined('rsPersonasValores') and rsPersonasValores.recordCount GT 0>
													<cfquery name="rsPerVal" dbtype="query">
														select valor
														from rsPersonasValores
														where id_dato = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReqLista.id_dato#">
															and id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#codPersona#">
													</cfquery>
												</cfif>														
												<td>
													<!--- check --->
													<cfif rsReqLista.tipo_dato eq 'B' >
														<input type="checkbox" name="dato_#codPersona#_#rsReqLista.id_dato#" 
															<cfif isdefined('rsPerVal') and rsPerVal.recordCount GT 0
																and rsPerVal.valor NEQ '' and rsPerVal.valor EQ 1>
																	checked
															</cfif>														
														>
													<!--- string --->
													<cfelseif rsReqLista.tipo_dato eq 'S' > 
														<cfif len(trim(rsReqLista.lista_valores))>
															<select name="dato_#codPersona#_#rsReqLista.id_dato#">
																<option value="">-seleccionar-</option>
																<cfloop list="#rsReqLista.lista_valores#" index="lvalor">
																	<option value="#lvalor#" 
																		<cfif isdefined('rsPerVal') and rsPerVal.recordCount GT 0
																			and rsPerVal.valor NEQ '' and rsPerVal.valor EQ lvalor>
																				selected
																		</cfif>
																	>#lvalor#</option>
																</cfloop>
															</select>
														<cfelse>
															<input type="text" name="dato_#codPersona#_#rsReqLista.id_dato#" 
																<cfif isdefined('rsPerVal') and rsPerVal.recordCount GT 0
																	and rsPerVal.valor NEQ ''>
																		value="#trim(rsPerVal.valor)#"
																</cfif>															
															size="30" maxlength="100" onFocus="this.select();" >
														</cfif>
													<!--- float, numeric --->
													<cfelse>
														<cfif len(trim(rsReqLista.lista_valores))>
															<select name="dato_#codPersona#_#rsReqLista.id_dato#">
																<option value="">-seleccionar-</option>
																<cfloop list="#rsReqLista.lista_valores#" index="valor">
																	<option value="#valor#" 
																		<cfif isdefined('rsPerVal') and rsPerVal.recordCount GT 0
																			and rsPerVal.valor NEQ '' and rsPerVal.valor EQ lvalor>
																				selected
																		</cfif>																	
																	>#valor#</option>
																</cfloop>
															</select>
														<cfelse>
															<input type="text" name="dato_#codPersona#_#rsReqLista.id_dato#" 
																<cfif isdefined('rsPerVal') and rsPerVal.recordCount GT 0
																	and rsPerVal.valor NEQ ''>
																		value="#trim(rsPerVal.valor)#"
																</cfif>																
															size="12" maxlength="12" style="text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
														</cfif>
													</cfif>
												</td>
											</cfloop>

										</cfif>
									</tr>								
								</cfloop>
							</table>
						</cfif>
					  </td>
					</tr>		
					<tr>
					  <td width="19%">&nbsp;</td>
					  <td width="67%">&nbsp;</td>
					  <td width="14%">&nbsp;</td>
					</tr>
					<cfif (isdefined('rsPersonasReq') and rsPersonasReq.recordCount GT 0) and 
						(isdefined('rsReqEncab') and rsReqEncab.recordCount GT 0)>
							<tr>
							  <td colspan="3" align="center"><input name="btnGuardar" type="submit" id="btnGuardar" value="Guardar"></td>
							</tr>						
					</cfif>
			  </table>
			  </form>
			</td>
		</tr>
	</table>
</cfoutput>
</body>
</html>

<script language="javascript" type="text/javascript">
	function CargaAgenda(valor,agenda){
		var form = document.formExped;
		var combo = form.id_agen;
		var hayAgendas = false;
				
		// borrar combo de agendas
		var opcion = combo.firstChild;
		while (opcion != null) {
			var siguiente = opcion.nextSibling;
			combo.removeChild(opcion);
			opcion = siguiente;
		}

		<cfoutput query="rsAgendas">
			var tmp = #rsAgendas.id_requisito# ;
			if ( valor != '' && tmp != '' && parseFloat(valor) == parseFloat(tmp) ) {
				opcion = document.createElement("OPTION");
				opcion.value = '#trim(rsAgendas.id_agenda)#';
				
				var texto = document.createTextNode('#rsAgendas.agenda#');
				opcion.appendChild(texto)
				if ('#rsAgendas.id_agenda#' == agenda) {
					opcion.setAttribute("selected","selected")
				}
				combo.appendChild(opcion)
				hayAgendas = true;
			}
		</cfoutput>
		
		if(hayAgendas)
			CambioAgenda(document.formExped.id_agenda.value);
	}
	
	function valida(f){
		if(f.RHRCfdesde.value == ''){
			alert('Error, la fecha es requerida');
			return false;
		}
		if(f.id_requisito.value == ''){
			alert('Error, el requisito es requerido');
			return false;
		}
		if(f.id_agenda.value == ''){
			alert('Error, la agenda es requerida');
			return false;
		}
		

		<cfif (isdefined('rsPersonasReq') and rsPersonasReq.recordCount GT 0) and (isdefined('rsReqEncab') and rsReqEncab.recordCount GT 0)>
			<cfoutput query="rsReqEncab">
				if(eval("f.datoGlobal_#rsReqEncab.id_dato#.value == ''")){		
					alert("Error, el campo '#rsReqEncab.nombre_dato#' es requerido");
					eval("f.datoGlobal_#rsReqEncab.id_dato#.focus();");
					return false;
				}	
			</cfoutput>
		</cfif>				
		
		<cfif (isdefined('rsPersonasReq') and rsPersonasReq.recordCount GT 0) and (isdefined('rsReqLista') and rsReqLista.recordCount GT 0)>
			<cfloop query="rsPersonasReq">
				<cfset codPersonaJS = rsPersonasReq.id_persona>
				<cfoutput query="rsReqLista">
					if(eval("f.dato_#codPersonaJS#_#rsReqLista.id_dato#.value == ''")){		
						alert("Error, el campo '#rsReqLista.nombre_dato#' es requerido");
						eval("f.dato_#codPersonaJS#_#rsReqLista.id_dato#.focus();");
						return false;
					}	
				</cfoutput>
			</cfloop>			
		</cfif>		
		
		return true;
	}
	
	function CambioAgenda(valor){
		var varAgenda_tmp = document.formExped.id_agenda_tmp.value;
		var varReq_tmp = document.formExped.id_requisito_tmp.value;
				
		
		if((valor != '' && valor != varAgenda_tmp) ||
			(document.formExped.id_requisito.value != '' && document.formExped.id_requisito.value != varReq_tmp)){
			document.formExped.submit();
		}
	}
	
	function changeFecha(fecha){
		if(fecha.value != document.formExped.RHRCfdesde_tmp.value){
			if(onblurdatetime(fecha)){
				document.formExped.submit();
			}
		}
	}
	
	<cfif isdefined('form.id_agenda') and form.id_agenda NEQ ''>
		CargaAgenda(document.formExped.id_requisito.value,'<cfoutput>#form.id_agenda#</cfoutput>');
	<cfelse>
		CargaAgenda(document.formExped.id_requisito.value,'');
	</cfif>
</script>


--->
