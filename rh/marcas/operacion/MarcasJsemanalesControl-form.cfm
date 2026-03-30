  <!--- <cfdump var="#form#">
<cfdump var="#url#">  --->

<cfquery name="rsAutoriza" datasource="#session.DSN#">
		Select Pvalor
		from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="510">
</cfquery>

<cfif isdefined("Form.RHCMid") and Len(Trim(Form.RHCMid))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif isdefined("Form.NombreEmpl") and Len(Trim(Form.NombreEmpl))>
	<cfset Form.PageNum = 1>
	<cfset Form.StartRow = 1>
</cfif>
	
<!--- Verificacion de si el usuario actual tiene derechos para generar marcas --->
<cfquery name="rsPermisoGenMarca" datasource="#Session.DSN#">
	select 1
	from DatosEmpleado a, LineaTiempo lt, RHPlazas r, RHProcesamientoMarcas b, RHUsuariosMarcas um
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.Ecodigo = lt.Ecodigo
	and a.DEid = lt.DEid
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
	and lt.Ecodigo = r.Ecodigo
	and lt.RHPid = r.RHPid
	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and b.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and b.Ecodigo = r.Ecodigo
	and b.CFid = r.CFid
	and b.Ecodigo = um.Ecodigo
	and b.CFid = um.CFid
	and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and um.RHUMtmarcas = 1
</cfquery>
<!--- Verificacion de si el usuario actual tiene derechos para generar incidencias --->
<cfquery name="rsPermisoGenIncidencia" datasource="#Session.DSN#">
	select 1
	from DatosEmpleado a, LineaTiempo lt, RHPlazas r, RHProcesamientoMarcas b, RHUsuariosMarcas um
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.Ecodigo = lt.Ecodigo
	and a.DEid = lt.DEid
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
	and lt.Ecodigo = r.Ecodigo
	and lt.RHPid = r.RHPid
	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and b.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and b.Ecodigo = r.Ecodigo
	and b.CFid = r.CFid
	and b.Ecodigo = um.Ecodigo
	and b.CFid = um.CFid
	and um.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	and um.RHUMgincidencias = 1
</cfquery>

<cfif rsPermisoGenMarca.recordCount GT 0 or rsPermisoGenIncidencia.recordCount GT 0>
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select a.DEid, 
			   a.NTIcodigo, 
			   a.DEidentificacion, 
			   a.DEnombre, 
			   a.DEapellido1, 
			   a.DEapellido2, 
			   n.NTIdescripcion
		from DatosEmpleado a, NTipoIdentificacion n
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and a.NTIcodigo = n.NTIcodigo
	</cfquery>
	<cfquery name="rsAccionesSeguir" datasource="#Session.DSN#">
		select RHASid, {fn concat(rtrim(RHAScodigo),{fn concat(' - ',RHASdescripcion)})} as Descripcion
		from RHAccionesSeguir
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by RHAScodigo
	</cfquery>
	<cfif modo EQ "CAMBIO">
		<cfquery name="rsMarca" datasource="#Session.DSN#">
			select a.RHCMid, a.RHPMid, a.RHASid, a.DEid, a.RHCMfregistro, a.RHCMfcapturada, a.RHCMtiempoefect, a.RHJid, 
				   a.RHCMhoraentrada, a.RHCMhorasalida, a.RHCMhoraentradac, a.RHCMhorasalidac, a.RHCMusuario, 
				   a.RHCMjustificacion, a.RHCMusuarioautor, isnull(a.RHCMhorasadicautor, 0.00) as RHCMhorasadicautor, coalesce(a.RHCMhorasrebajar, 0.00) as RHCMhorasrebajar, a.RHCMdialibre, 
				   a.RHCMinconsistencia, a.BMUsucodigo, a.BMfecha, a.BMfmod, a.ts_rversion,
				   case when datepart(hh, a.RHCMhoraentradac) > 12 then datepart(hh, a.RHCMhoraentradac) - 12 when datepart(hh, a.RHCMhoraentradac) = 0 then 12 else datepart(hh, a.RHCMhoraentradac) end as hentrada,
				   datepart(mi, a.RHCMhoraentradac) as mentrada,
				   case when datepart(hh, a.RHCMhoraentradac) < 12 then 'AM' else 'PM' end as tentrada,
				   case when datepart(hh, a.RHCMhorasalidac) > 12 then datepart(hh, a.RHCMhorasalidac) - 12 when datepart(hh, a.RHCMhorasalidac) = 0 then 12 else datepart(hh, a.RHCMhorasalidac) end as hsalida,
				   datepart(mi, a.RHCMhorasalidac) as msalida,
				   case when datepart(hh, a.RHCMhorasalidac) < 12 then 'AM' else 'PM' end as tsalida,
				   b.RHJdescripcion,
				   (case when c.RHASid is not null then 
				   		{fn concat(rtrim(c.RHAScodigo),{fn concat(' - ',c.RHASdescripcion)})}
					else '' end) as AccionSeguir
			from RHControlMarcas a
				inner join RHJornadas b
					on a.RHJid = b.RHJid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				left outer join RHAccionesSeguir c
					on a.RHASid = c.RHASid
					and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
			and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		</cfquery>
	
		<cfquery name="rsDetalleMarcaPos" datasource="#Session.DSN#">
			select count(1) as cant, coalesce(sum(RHDMhorasautor), 0.00) as total
			from RHDetalleIncidencias a, CIncidentes b
			where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
			and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
			and a.CIid = b.CIid
			and b.CInegativo = 1
		</cfquery>
		
		<cfquery name="rsDetalleMarcaNeg" datasource="#Session.DSN#">
			select count(1) as cant, coalesce(sum(RHDMhorasautor), 0.00) as total
			from RHDetalleIncidencias a, CIncidentes b
			where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
			and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
			and a.CIid = b.CIid
			and b.CInegativo = -1
		</cfquery>
	</cfif>
	
	<cfset filtro = "">
	
    <cfif rsPermisoGenMarca.recordCount GT 0>
	<SCRIPT language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
	<SCRIPT language="javascript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
	<script language="javascript" type="text/javascript">
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
	</script>
	</cfif>
	
	<!---====================== TRADUCCION =========================--->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Usted_no_tiene_permisos_para_generar_Incidencias"
		Default="Usted no tiene permisos para generar Incidencias"	
		returnvariable="MSG_Usted_no_tiene_permisos_para_generar_Incidencias"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Fecha"
		Default="Fecha"	
		returnvariable="LB_Fecha"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Hora_Entrada"
		Default="Hora Entrada"	
		returnvariable="LB_Hora_Entrada"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Hora_Salida"
		Default="Hora Salida"	
		returnvariable="LB_Hora_Salida"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Jornada"
		Default="Jornada"	
		returnvariable="LB_Jornada"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Inconsistencia"
		Default="Inconsistencia"	
		returnvariable="LB_Inconsistencia"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Incidencias"
		Default="Incidencias"	
		returnvariable="LB_Incidencias"/>
		
	<script language="javascript" type="text/javascript">
		function ProcesarMarca(proc, marca, emp, hAut, hReb) {
			var horasAut = 0;
			var horasReb = 0;			
			if(hAut != '')
				horasAut = hAut;
			if(hReb != '')
				horasReb = hReb;
			<cfif rsPermisoGenIncidencia.recordCount GT 0>
				document.goIncidencia.RHPMid.value = proc;
				document.goIncidencia.RHCMid.value = marca;
				document.goIncidencia.DEid.value = emp;
				document.goIncidencia.showDetail.value = "1";
				document.goIncidencia.horasAdic.value = horasAut;
				document.goIncidencia.horasRebaj.value = horasReb;
	
				document.goIncidencia.submit();
			<cfelse>
				<cfoutput>
				alert('#MSG_Usted_no_tiene_permisos_para_generar_Incidencias#');
				</cfoutput>
			</cfif>
		}
	</script>

	<form name="goIncidencia" method="post" action="MarcasJsemanales.cfm" style="margin: 0; ">
		<input type="hidden" name="RHPMid" value="">
		<input type="hidden" name="RHCMid" value="">
		<input type="hidden" name="DEid" value="">
		<input type="hidden" name="showDetail" value="1">
		<input type="hidden" name="GenDetalle" value="1">
		<input type="hidden" name="horasAdic" value="">
		<input type="hidden" name="horasRebaj" value="">		
	</form>
	
	<cfoutput>
		<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
			<td>
				<cfinclude template="../../expediente/consultas/frame-infoEmpleado.cfm">
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="50%" valign="top" style="padding-right: 10px; ">
						<cfset vsImagen = "<a href=javascript:ProcesarMarca(">
						<cfquery name="rsLista" datasource="#session.DSN#">
							select a.RHCMfcapturada as Fecha, a.RHCMid, a.DEid, a.RHCMhoraentradac as HoraEntrada, a.RHCMhorasalidac as HoraSalida, 
									b.RHJdescripcion,a.RHPMid,
									'<img border=''0'' src=''/cfmx/rh/imagenes/' + (case RHCMinconsistencia when 0 then 'un' else null end) + 'checked.gif''>' as Inconsistencia, 
									case when a.RHCMinconsistencia = 0 and (a.RHCMhorasadicautor > 0 or a.RHCMhorasrebajar > 0)then 
										<!---'<a href=''javascript: ProcesarMarca(' || convert(varchar, a.RHPMid) || ', ' || convert(varchar, a.RHCMid) || ', ' || convert(varchar, a.DEid) || ', ' || convert(varchar, a.RHCMhorasadicautor) || ', ' || convert(varchar, a.RHCMhorasrebajar) || ');''><img src=''/cfmx/rh/imagenes/MasterDetail.gif'' border=''0''></a>' ---->
										{fn concat({
													fn concat({
																fn concat('#vsImagen#', ''''
																)}, 
																{fn concat( <cf_dbfunction name="to_char" args="a.RHPMid">,
																	{fn concat(''',''', 
																				{fn concat( <cf_dbfunction name="to_char" args="a.RHCMid">,
																					{fn concat(''',''',
																						{fn concat( <cf_dbfunction name="to_char" args="a.DEid">,
																							{fn concat(''',''',
																								{fn concat( <cf_dbfunction name="to_char" args="a.RHCMhorasadicautor">,
																									{fn concat(''',''', <cf_dbfunction name="to_char" args="a.RHCMhorasrebajar">)}
																								)}
																							)}
																						)}
																					)}
																				)}
																	)}
																)}
																
													)}, ''');><img src=''/cfmx/rh/imagenes/MasterDetail.gif'' border=''0''></a>'
										) }
								else
								 '&nbsp;' 
								end as GeneraIncidencias
							from RHControlMarcas a, RHJornadas b
							where  a.RHPMid = #Form.RHPMid# 
								and a.DEid = #Form.DEid#
								and a.RHJid = b.RHJid
								and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								#filtro# 
							order by a.RHCMfcapturada, RHCMhoraentradac, RHCMhorasalidac
						</cfquery>
						
						<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaEmpl">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="Fecha, HoraEntrada, HoraSalida, RHJdescripcion, Inconsistencia, GeneraIncidencias"/>
							<cfinvokeargument name="etiquetas" value="#LB_Fecha#, #LB_Hora_Entrada#, #LB_Hora_Salida#, #LB_Jornada#, #LB_Inconsistencia#, #LB_Incidencias#"/>
							<cfinvokeargument name="formatos" value="D, H, H, V, V, V"/>
							<cfinvokeargument name="formName" value="listaMarcas"/>	
							<cfinvokeargument name="align" value="center, center, center, left, center, center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="MarcasJsemanales.cfm"/>
							<cfinvokeargument name="keys" value="RHCMid"/>
							<cfinvokeargument name="maxRows" value="0"/>
							<cfinvokeargument name="PageIndex" value="3"/>							
						</cfinvoke>
					</td>
					<td width="50%" valign="top">
					  <cfif rsPermisoGenMarca.recordCount GT 0>
							<form name="form1" method="post" action="MarcasJsemanales-SQL.cfm" onSubmit="javascript: return validarInconsistencia(this);">
								<cfif isdefined("Form.RHPMid") and Len(Trim(Form.RHPMid))>
								  <input type="hidden" name="RHPMid" value="<cfoutput>#Form.RHPMid#</cfoutput>">
								</cfif>
								<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
								  <input type="hidden" name="DEid" value="<cfoutput>#Form.DEid#</cfoutput>">
								</cfif>
								<cfif isdefined("Form.RHCMid") and Len(Trim(Form.RHCMid))>
								  <input type="hidden" name="RHCMid" value="<cfoutput>#Form.RHCMid#</cfoutput>">
								</cfif>
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
								  <tr>
									<td  colspan="2" class="tituloAlterno"  align="center" nowrap>
										<cfif modo EQ 'CAMBIO'><cf_translate key="LB_Modificar_Marca">Modificar Marca</cf_translate><cfelse><cf_translate key="LB_Agregar_Marca">Agregar Marca</cf_translate></cfif> 
									</td>
								  </tr>
								  <tr>
									<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Fecha_de_Captura">Fecha de Captura:</cf_translate></td>
									<td nowrap>
										<cfif modo EQ "CAMBIO">
											<cfset fcapturada = LSDateFormat(rsMarca.RHCMfcapturada, 'dd/mm/yyyy')>
										<cfelse>
											<cfset fcapturada = "">
										</cfif>
										<cf_sifcalendario form="form1" name="RHCMfcapturada" value="#fcapturada#">
									</td>
									
								  </tr>
								  <tr>
									<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Hora_Entrada">Hora Entrada:</cf_translate></td>
									<td nowrap>
										<select name='RHCMhoraentradac1'>
										  <cfloop index="i" from="1" to="12">
											<option value="#i#"<cfif modo EQ "CAMBIO" and rsMarca.hentrada EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1>0</cfif>#i#</option>
										  </cfloop>
										</select> :
										<select name='RHCMhoraentradac2'>
										  <cfloop index="i" from="0" to="59">
											<option value="#i#"<cfif modo EQ "CAMBIO" and rsMarca.mentrada EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1>0</cfif>#i#</option>
										  </cfloop>
										</select>
										<select name="RHCMhoraentradac3">
											<option value="AM"<cfif modo EQ "CAMBIO" and rsMarca.tentrada EQ 'AM'> selected</cfif>>AM</option>
											<option value="PM"<cfif modo EQ "CAMBIO" and rsMarca.tentrada EQ 'PM'> selected</cfif>>PM</option>
										</select>
									</td>
									
								  </tr>
								  <tr>
									<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Hora_Salida">Hora Salida:</cf_translate></td>
									<td nowrap>
										<select name='RHCMhorasalidac1'>
										  <cfloop index="i" from="1" to="12">
											<option value="#i#"<cfif modo EQ "CAMBIO" and rsMarca.hsalida EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1>0</cfif>#i#</option>
										  </cfloop>
										</select> :
										<select name='RHCMhorasalidac2'>
										  <cfloop index="i" from="0" to="59">
											<option value="#i#"<cfif modo EQ "CAMBIO" and rsMarca.msalida EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1>0</cfif>#i#</option>
										  </cfloop>
										</select>
										<select name="RHCMhorasalidac3">
											<option value="AM"<cfif modo EQ "CAMBIO" and rsMarca.tsalida EQ 'AM'> selected</cfif>>AM</option>
											<option value="PM"<cfif modo EQ "CAMBIO" and rsMarca.tsalida EQ 'PM'> selected</cfif>>PM</option>
										</select>
									</td>
									
								  </tr>
								  <tr>
								  <td class="fileLabel" align="right" nowrap><cfif modo EQ 'CAMBIO' and Len(Trim(rsMarca.RHCMfregistro))><cf_translate key="LB_Fecha_de_Marca">Fecha de Marca:</cf_translate><cfelse>&nbsp;</cfif></td>
									<td nowrap><cfif modo EQ 'CAMBIO' and Len(Trim(rsMarca.RHCMfregistro))>#LSDateFormat(rsMarca.RHCMfregistro, 'dd/mm/yyyy')#<cfelse>&nbsp;</cfif></td>
								  </tr>
								  <tr><td class="fileLabel" align="right" nowrap><cfif modo EQ 'CAMBIO' and Len(Trim(rsMarca.RHCMhoraentrada))><cf_translate key="LB_Marca_Entrada">Marca Entrada:</cf_translate><cfelse>&nbsp;</cfif></td>
									<td nowrap><cfif modo EQ 'CAMBIO' and Len(Trim(rsMarca.RHCMhoraentrada))>#LSTimeFormat(rsMarca.RHCMhoraentrada, 'hh:mm tt')#<cfelse>&nbsp;</cfif></td></tr>
								  
								    <tr><td class="fileLabel" align="right" nowrap><cfif modo EQ 'CAMBIO' and Len(Trim(rsMarca.RHCMhorasalida))><cf_translate key="LB_Marca_Salida">Marca Salida:</cf_translate><cfelse>&nbsp;</cfif></td>
									<td nowrap><cfif modo EQ 'CAMBIO' and Len(Trim(rsMarca.RHCMhorasalida))>#LSTimeFormat(rsMarca.RHCMhorasalida, 'hh:mm tt')#<cfelse>&nbsp;</cfif></td>
									</tr>
								  <cfif modo EQ 'CAMBIO'>
								  <tr>
									<td align="right" nowrap class="fileLabel">#LB_Jornada#:</td>
									<td nowrap>#rsMarca.RHJdescripcion#</td>
								  </tr>
								  </cfif>
								  <tr>
									<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Horas_Adicionales">Horas Adicionales:</cf_translate></td>
									<td nowrap>
										<input name="RHCMhorasadicautor" type="text" size="5" maxlength="5" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ 'CAMBIO' and Len(Trim(rsMarca.RHCMhorasadicautor)) NEQ 0>#LSNumberFormat(rsMarca.RHCMhorasadicautor, '9.00')#<cfelse>0.00</cfif>">
									</td>
									
								  </tr>
								  <tr>
									<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Horas_a_Rebajar">Horas a Rebajar:</cf_translate></td>
									<td nowrap>
									  <input name="RHCMhorasrebajar" type="text" id="RHCMhorasrebajar" size="5" maxlength="5" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ 'CAMBIO' and Len(Trim(rsMarca.RHCMhorasrebajar)) NEQ 0>#LSNumberFormat(rsMarca.RHCMhorasrebajar, '9.00')#<cfelse>0.00</cfif>">
									</td>
								  </tr>
								  <tr>
									<td colspan="2">
										<table width="100%">
											<tr>
												<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Dia_Libre">D&iacute;a Libre:</cf_translate></td>
												<td nowrap><input name="RHCMdialibre" type="checkbox" id="RHCMdialibre" value="1" <cfif modo EQ 'CAMBIO' and rsMarca.RHCMdialibre EQ 1> checked</cfif>></td>
												<td align="right" class="fileLabel"><cfif modo EQ 'CAMBIO'>#LB_Inconsistencia#:<cfelse>&nbsp;</cfif></td>
												<!--- and rsMarca.RHCMinconsistencia EQ 1 --->
												<td nowrap valign="middle" style="color:##000099"><cfif modo EQ 'CAMBIO'><a href='javascript: verInconsistencias(<cfoutput>#Form.RHCMid#</cfoutput>);'>[ver]</a> </cfif></td>
												<td nowrap  valign="middle"><cfif modo EQ 'CAMBIO'><input name="RHCMinconsistencia" type="checkbox"  id="RHCMinconsistencia" value="1" <cfif modo EQ 'CAMBIO' and rsMarca.RHCMinconsistencia EQ 1> checked</cfif>><cfelse> </cfif></td>
												 
											</tr>
										</table>
									</td>
								  </tr>
								  <tr>
									<td align="right" valign="top" nowrap class="fileLabel"><cf_translate key="LB_Justificacion">Justificaci&oacute;n</cf_translate>:</td>
									<td  nowrap>
										<cfif modo EQ 'CAMBIO' and Len(Trim(rsMarca.RHCMjustificacion))>
											<textarea name="RHCMjustificacion" cols="45" rows="3" id="RHCMjustificacion">#rsMarca.RHCMjustificacion#</textarea>
										<cfelse>
											<textarea name="RHCMjustificacion" cols="45" rows="3" id="RHCMjustificacion"></textarea>
										</cfif>
									</td>
								  </tr>
								  <tr>
									<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Accion_a_Seguir">Accion a Seguir</cf_translate>:</td>
									<td  nowrap>
										<select name="RHASid">
											<option value=""><cf_translate key="LB_Ninguna">(Ninguna)</cf_translate></option>
											<cfloop query="rsAccionesSeguir">
												<option value="#RHASid#"<cfif modo EQ 'CAMBIO' and rsMarca.RHASid EQ rsAccionesSeguir.RHASid> selected</cfif>>#Descripcion#</option>
											</cfloop>
										</select>
									</td>
								  </tr>
								  <tr>
									<td colspan="2" valign="top" nowrap class="fileLabel">&nbsp;</td>
								  </tr>
								  <tr>
									<td colspan="2" align="center" valign="top" nowrap class="fileLabel">
									  <cfinclude template="/rh/portlets/pBotones.cfm">
									  <cfif modo EQ "CAMBIO">
										<cfset ts = "">
										<cfinvoke 
											component="sif.Componentes.DButils"
											method="toTimeStamp"
											returnvariable="ts">
										  <cfinvokeargument name="arTimeStamp" value="#rsMarca.ts_rversion#"/>
										</cfinvoke>
										<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">
									  </cfif>
									</td>
								  </tr>
								</table>
							</form>
						<cfelseif modo EQ "CAMBIO">
							<table width="100%" border="0" cellspacing="0" cellpadding="2" style="border: 1px solid black;">
							  <tr>
								<td class="tituloAlterno" colspan="4" align="center" style="border-bottom: 1px solid black;" nowrap><cf_translate key="LB_Datos_de_Marca">Datos de Marca</cf_translate></td>
							  </tr>
							  <tr>
								<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Fecha_de_Captura">Fecha de Captura:</cf_translate></td>
								<td nowrap>#LSDateFormat(rsMarca.RHCMfcapturada, 'dd/mm/yyyy')#</td>
								<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Fecha_de_Marca">Fecha de Marca:</cf_translate></td>
								<td nowrap><cfif Len(Trim(rsMarca.RHCMfregistro))>#LSDateFormat(rsMarca.RHCMfregistro, 'dd/mm/yyyy')#</cfif></td>
							  </tr>
							  <tr>
								<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Hora_Entrada">Hora Entrada:</cf_translate></td>
								<td nowrap>#LSTimeFormat(rsMarca.RHCMhoraentradac, 'hh:mm tt')#</td>
								<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Marca_Entrada">Marca Entrada:</cf_translate></td>
								<td nowrap><cfif Len(Trim(rsMarca.RHCMhoraentrada))>#LSTimeFormat(rsMarca.RHCMhoraentrada, 'hh:mm tt')#</cfif></td>
							  </tr>
							  <tr>
								<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Hora_Salida">Hora Salida:</cf_translate></td>
								<td nowrap>#LSTimeFormat(rsMarca.RHCMhorasalidac, 'hh:mm tt')#</td>
								<td class="fileLabel" align="right" nowrap><cf_translate key="L_Marca_Salida">Marca Salida</cf_translate>:</td>
								<td nowrap><cfif Len(Trim(rsMarca.RHCMhorasalida))>#LSTimeFormat(rsMarca.RHCMhorasalida, 'hh:mm tt')#</cfif></td>
							  </tr>
							  <tr>
								<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Jornada">Jornada:</cf_translate></td>
								<td colspan="3" nowrap>#rsMarca.RHJdescripcion#</td>
							  </tr>
							  <tr>
								<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Horas_Adicionales">Horas Adicionales:</cf_translate> </td>
								<td nowrap>#LSNumberFormat(rsMarca.RHCMhorasadicautor, '9.00')#</td>
								<td align="right" nowrap><span class="fileLabel">Horas a Rebajar:</span></td>
								<td nowrap>#LSNumberFormat(rsMarca.RHCMhorasrebajar, '9.00')#</td>
							  </tr>
							  <tr>
								<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Dia_Libre">D&iacute;a Libre:</cf_translate> </td>
								<td colspan="3" nowrap>
									<cfif rsMarca.RHCMdialibre EQ 1>
										<img src="/cfmx/rh/imagenes/checked.gif">
									<cfelse>
										<img src="/cfmx/rh/imagenes/unchecked.gif">
									</cfif>
								</td>
							  </tr>
							  <tr>
								<td align="right" valign="top" nowrap class="fileLabel"><cf_translate key="LB_Justificacion">Justificaci&oacute;n:</cf_translate></td>
								<td colspan="3" nowrap>
									<textarea name="RHCMjustificacion" cols="45" rows="5" id="RHCMjustificacion" style="border:none;" readonly>#rsMarca.RHCMjustificacion#</textarea>
								</td>
							  </tr>
							  <tr>
								<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Accion_a_Seguir">Accion a Seguir:</cf_translate></td>
								<td colspan="3" nowrap>
									<cfif Len(Trim(rsMarca.AccionSeguir))>
										#rsMarca.AccionSeguir#
									<cfelse>
										<cf_translate key="LB_Ninguna">(Ninguna)</cf_translate>
									</cfif>
								</td>
							  </tr>
							  <tr>
								<td colspan="4" valign="top" nowrap class="fileLabel">&nbsp;</td>
							  </tr>
							</table>
						</cfif>
					</td>
				  </tr>
				</table>
			</td>
		  </tr>
		</table>
	</cfoutput>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LaInconsistenciaSoloSePuedeEliminarSiTieneHorasAdicionalesAprobadasOunaJustificacionOaccionAseguirOsiEsUnDiaLibre"
	Default="La inconsistencia solo se puede eliminar si tiene horas adicionales aprobadas o una justificación o acción a seguir o si es un día libre"	
	returnvariable="MSG_NoSePuedeEliminarInconsistencia"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoPuedeMarcarComoInconsistenteEstaMarcaPorqueYaTieneIncidenciasAsociadas"
	Default="No puede marcar como inconsistente esta marca porque ya tiene incidencias asociadas"	
	returnvariable="MSG_NoPuedeMarcarInconsistencia"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoPuedeMarcarComoInconsistenteEstaMarcaPorqueYaTieneIncidenciasAsociadas"
	Default="Las horas adicionales autorizadas no puede ser menor a"	
	returnvariable="MSG_HorasAdicionales"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoPuedeMarcarComoInconsistenteEstaMarcaPorqueYaTieneIncidenciasAsociadas"
	Default="Las horas a rebajar no puede ser menor a"	
	returnvariable="MSG_HorasRebajar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha_de_Captura"
	Default="Fecha de Captura"	
	returnvariable="MSG_Fecha_de_Captura"/>
	

	
    <cfif rsPermisoGenMarca.recordCount GT 0>
	<script language="javascript" type="text/javascript">
		function validarInconsistencia(f) {
			<cfif modo EQ "CAMBIO" and rsMarca.RHCMinconsistencia EQ 1>
				if (!f.obj.RHCMinconsistencia.checked) {
					if (parseFloat(f.obj.RHCMhorasadicautor.value) > 0.00) {
						return true;
					}
					if (parseFloat(f.obj.RHCMhorasrebajar.value) > 0.00) {
						return true;
					}
					if (f.obj.RHCMjustificacion.value != "") {
						return true;
					}
					if (f.obj.RHCMdialibre.checked) {
						return true;
					}
					if (f.obj.RHASid.value != "") {
						return true;
					}					
					<cfoutput>alert('#MSG_NoSePuedeEliminarInconsistencia#');</cfoutput>
					return false;
				}
			<cfelseif modo EQ "CAMBIO" and rsMarca.RHCMinconsistencia EQ 0>
				<cfif rsDetalleMarcaPos.cant GT 0 or rsDetalleMarcaNeg.cant GT 0>
				if (f.obj.RHCMinconsistencia.checked) {
					<cfoutput>alert('#MSG_NoPuedeMarcarInconsistencia#');</cfoutput>
					return false;
				}
				</cfif>
				<!--- Chequear que no se quiten las horas autorizadas una vez quitada la inconsistencia --->
			</cfif>
			<cfif modo EQ "CAMBIO">
			var minValorPos = <cfoutput>#rsDetalleMarcaPos.total#</cfoutput>;
			var minValorNeg = <cfoutput>#rsDetalleMarcaNeg.total#</cfoutput>;
			if (parseFloat(qf(document.form1.RHCMhorasadicautor.value)) < minValorPos) {
				<cfoutput>alert("#MSG_HorasAdicionales#"+' ' + minValorPos);</cfoutput>
				return false;
			}
			if (parseFloat(qf(document.form1.RHCMhorasrebajar.value)) < minValorNeg) {
				<cfoutput>alert("#MSG_HorasRebajar#"+' ' +minValorNeg);</cfoutput>
				return false;
			}
			</cfif>
			return true;
		}
	
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
		
		objForm.RHCMfcapturada.required = true;
		<cfoutput>objForm.RHCMfcapturada.description = "#MSG_Fecha_de_Captura#";</cfoutput>
		
	</script>
	</cfif>
	
<cfelse>
	<div align="center"><strong><cf_translate key="LB_UstedNoEstaAutorizadoParaIngresarAEstaPantalla">Usted no est&aacute; autorizado para ingresar a esta pantalla</cf_translate></strong></div>
</cfif>
<!--- <cfoutput>#Form.RHCMid#</cfoutput> --->
<script>
function verInconsistencias(id) {

			var dir = '/cfmx/rh/marcas/operacion/DetalleInconsistenciasJsemanales.cfm?RHCMid='+ id;
			
			var width = 600;
			var height = 400;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			var nuevo = window.open(dir,'Inconsistencias','menu=no,scrollbars=no,top='+top+',left='+left+',width='+width+',height='+height);
			nuevo.focus();
	}
</script>