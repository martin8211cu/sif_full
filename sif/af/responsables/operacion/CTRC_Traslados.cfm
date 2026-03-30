<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfset urlParam="">
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_dbfunction name="now" returnvariable="hoy">
<!--- Query de Centro de Custodia --->
<cfquery name="RSCentros" datasource="#session.dsn#" >
	Select a.CRCCid, a.CRCCcodigo,a.CRCCdescripcion
	from CRCentroCustodia a
     inner join CRCCUsuarios b
	   on a.CRCCid  = b.CRCCid 
	  and Usucodigo = #session.Usucodigo# 
	where Ecodigo   = #session.Ecodigo# 
	order by a.CRCCcodigo
</cfquery>
<cfif RSCentros.recordcount eq 0>
	<cf_errorCode	code = "50127" msg = "Usted no tiene asociado ningún Centro de Custodia, no puede utilizar este proceso, Proceso Cancelado!">
</cfif>
<!--- Query de Tipo de Documentos --->
<cfquery name="RSTipos" datasource="#session.dsn#" >
	Select CRTDid,CRTDcodigo,CRTDdescripcion 
		from CRTipoDocumento 
		where Ecodigo  = #session.Ecodigo# 
</cfquery>

<cf_dbtemp name="AFctrcError01" returnvariable="Errores" datasource="#session.dsn#">
	<cf_dbtempcol name="error" 	type="money"  mandatory="no">
	<cf_dbtempcol name="error2" type="money"  mandatory="no">
	<cf_dbtempcol name="error3" type="money"  mandatory="no">
	<cf_dbtempcol name="error4" type="money"  mandatory="no">
</cf_dbtemp>

<cfquery name="rsReporte" datasource="#Session.Dsn#">
	insert into #Errores#(error, error2, error3, error4)
		select	coalesce ( 	case when exists ( select 1 from AFTResponsables aftr2 where aftr2.AFTRid <> aftr.AFTRid and aftr2.AFRid = aftr.AFRid ) 
							then 1 else 0 
						end 
					,0 ) as error,
			coalesce ( 	case aftr.AFTRestado when 50 
							then 1 else 0 
						end
					, 0 ) as error2,
			coalesce ( case when not exists ( select 1 
												from CRCCCFuncionales 
												where CRCCid = aftr.CRCCid 
												and CFid = afr.CFid ) 
											then 1 else 0 end
										 ,0) as error3, 
			coalesce ( 	case when exists (select 1 from CRAClasificacion where CRCCid = aftr.CRCCid) 
							then 
								case when not exists ( select 1 from CRAClasificacion where CRCCid = aftr.CRCCid and ACcodigo = act.ACcodigo and ACid = act.ACid ) 
									then 1 
									else 0 
								end
							else 0
						end
					+
						case when exists ( select 1 from CRAClasificacion where CRCCid <> aftr.CRCCid and ACcodigo = act.ACcodigo and ACid = act.ACid ) 
							then 1 else 0 
						end
					,0 ) as error4

	from AFTResponsables aftr
			inner join AFResponsables afr
				on afr.AFRid = aftr.AFRid
				and afr.Ecodigo = #Session.Ecodigo#
			inner join Activos act
				on act.Aid = afr.Aid
			inner join CFuncional cf
				on cf.CFid = afr.CFid
			inner join DatosEmpleado de
				on de.DEid = afr.DEid
			left outer join CRTipoDocumento crtd
				on crtd.CRTDid = afr.CRTDid
	where aftr.Usucodigo = #Session.Usucodigo# 
	  and aftr.AFTRtipo = 2 
	  and aftr.AFTRestado in ( 30, 50 )
</cfquery>

<!--- Query de Errores --->
<cfquery name="rsErrores" datasource="#Session.Dsn#" >
	select coalesce(sum(error),0) as error, 
		   coalesce(sum(error2),0) as error2, 
		   coalesce(sum(error3),0) as error3,
		   coalesce(sum(error4),0) as error4 
     from #Errores#
</cfquery>

<cfif isdefined("rsErrores") and len(trim(rsErrores.error)) or len(trim(rsErrores.error2)) or len(trim(rsErrores.error3)) or  len(trim(rsErrores.error4))>
	<cfset AplicarTodosValues = "">
	<cfset AplicarTodosNames = "">
<cfelse>
	<cfset AplicarTodosValues = ",Aplicar Todos">
	<cfset AplicarTodosNames = ",AplicarT">
</cfif>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>
				<cf_web_portlet_start titulo="Par&aacute;metros de la Transferencia">
					<form  action="CTRC_TrasladosSQL.cfm"  method="post" enctype="multipart/form-data" name="Filtros" style="margin:0;">
						<table width="95%" align="center" border="0" cellspacing="0" cellpadding="2">
							<tr>
								<td valign="top" nowrap="NOWRAP" class="tituloSub">
									<fieldset style="height:125">
										<legend>Filtro Origen</legend>
										<table width="100%" border="0" cellspacing="0" cellpadding="2">
											<!--- Línea No 1 --->
											<tr>
												<td class="fileLabel" align="left" nowrap>Centro de Custodia:</td>
												<td>
													<cfif RSCentros.recordcount gt 0>
														<cfif RSCentros.recordcount eq 1>
															<input name="CRCCid" value="#RSCentros.CRCCid#" type="hidden" tabindex="-1">
															#RSCentros.CRCCcodigo#-#RSCentros.CRCCdescripcion#
														<cfelse>
															<select name="CRCCid" tabindex="1">
															<cfloop query="RSCentros">
																<option value="#RSCentros.CRCCid#">#RSCentros.CRCCcodigo#-#RSCentros.CRCCdescripcion#</option>
															</cfloop>
															</select>
														</cfif>
													<cfelse>
														<input name="CRCCid"  value="" type="hidden" tabindex="-1">
													</cfif>					
												</td>
											</tr>
											<!--- Línea No 2 --->
											<tr>
												<td class="fileLabel" align="left" nowrap>Tipo de Documentos:</td>
												<td>
													<select name="CRTDid" tabindex="2">
														<option value="">** Todos **</option>
														<cfloop query="RSTipos">
															<option value="#RSTipos.CRTDid#" >#RSTipos.CRTDcodigo#-#RSTipos.CRTDdescripcion#</option>
														</cfloop>
													</select>					
												</td>
											</tr>	
											<!--- Línea No 3 --->
											<tr>
												<td  class="fileLabel" align="left" nowrap>Empleado:</td>
												<td >
												<cf_dbfunction name="concat" args="A.DEapellido1 ,' ',A.DEapellido2,' ',A.DEnombre " returnvariable="DEnombrecompleto" >
													<cf_conlis
														Campos="DEid,DEidentificacion,DEnombrecompleto"
														tabindex="3"
														Desplegables="N,S,S"
														Modificables="N,S,N"
														Size="0,15,35"
														Title="Lista de Empleados"
														Tabla="DatosEmpleado A 
															   inner join  AFResponsables B
																on A.DEid = B.DEid
																and A.Ecodigo = B.Ecodigo 
																and B.CRCCid = $CRCCid,numeric$
																and #hoy# between B.AFRfini and B.AFRffin"
														Columnas="distinct A.DEid ,A.DEidentificacion, #PreserveSingleQuotes(DEnombrecompleto)# as DEnombrecompleto"
														Filtro="A.Ecodigo = #Session.Ecodigo# order by DEidentificacion,DEnombrecompleto"
														Desplegar="DEidentificacion,DEnombrecompleto"
														Etiquetas="Identificaci&oacute;n,Nombre"
														filtrar_por="A.DEidentificacion, #PreserveSingleQuotes(DEnombrecompleto)# "
														Formatos="S,S"
														Align="left,left"
														form="Filtros"
														Asignar="DEid,DEidentificacion,DEnombrecompleto"
														Asignarformatos="I,S,S"/>	
												</td>
											</tr>
											<!--- Línea No 4 --->
											<tr>	
												<td class="fileLabel" align="left" nowrap>Centro Funcional :</td>
												<td>
													<cfset ArrayCF=ArrayNew(1)>
														<cf_conlis
															Campos="CFid,CFcodigo,CFdescripcion"
															tabindex="4"
															Desplegables="N,S,S"
															Modificables="N,S,N"
															Size="0,15,35"
															Title="Lista de Centros Funcionales"
															Tabla="CRCCCFuncionales a
																	inner join CFuncional b
																	on a.CFid = b.CFid
																	and b.Ecodigo = #Session.Ecodigo#
																	inner join CRCentroCustodia c
																	on a.CRCCid = c.CRCCid 
																	and c.CRCCid = $CRCCid,numeric$"
															Columnas="b.CFid,b.CFcodigo,b.CFdescripcion"
															Filtro="1=1 order by CFcodigo,CFdescripcion"
															Desplegar="CFcodigo,CFdescripcion"
															Etiquetas="C&oacute;digo,Descripci&oacute;n"
															filtrar_por="b.CFcodigo,b.CFdescripcion"
															Formatos="S,S"
															Align="left,left"
															form="Filtros"
															Asignar="CFid,CFcodigo,CFdescripcion"
															Asignarformatos="I,S,S"/>
												</td>
											</tr>
											<!--- Línea No 5 --->
											<tr>
												<td class="fileLabel" align="left" nowrap>Placa:</td>
												<td >
													<cfset ArrayPlacaI=ArrayNew(1)>
													<cf_conlis
														tabindex="5"
														aluesArray="#ArrayPlacaI#"
														Campos="AplacaINI,AdescripcionINI"
														Desplegables="S,S"
														Modificables="S,N"
														Size="15,35"
														Title="Placas"
														Tabla="Activos A
																inner join AFResponsables  B
																	on A.Ecodigo = B.Ecodigo
																	and A.Aid = B.Aid
																	and B.CRCCid = $CRCCid,numeric$
																	and #hoy# between B.AFRfini and B.AFRffin"
														Columnas="Aplaca as AplacaINI,Adescripcion as AdescripcionINI"
														Filtro="A.Ecodigo = #Session.Ecodigo# and A.Astatus = 0 order by Aplaca "
														Desplegar="AplacaINI,AdescripcionINI"
														Etiquetas="Placa,Descripci&oacute;n"
														filtrar_por="Aplaca,Adescripcion"
														Formatos="S,S"
														form="Filtros"
														Align="left,left"
														Asignar="AplacaINI,AdescripcionINI"
														Asignarformatos="S,S,S,S"
														MaxRowsQuery="200"/>
												</td>
											</tr>	
										</table>	
									</fieldset>
								</td>
								<td valign="top" nowrap="NOWRAP" class="tituloSub">&nbsp;</td>
								<td valign="top" nowrap="NOWRAP" class="tituloSub">
									<fieldset style="height:125">
										<legend>Datos Destino</legend>
										<table width="100%" border="0" cellspacing="0" cellpadding="2">	
											<tr>
												<td width="14%" align="left" nowrap class="fileLabel">Centro de Custodia:</td>
												<td width="86%" colspan="3"><cfset ArrayDestino=ArrayNew(1)>
													<cf_conlis
														Campos="DESTINO,DESTINOCOD,DESTINODESCRIP"
														tabindex="7"
														Desplegables="N,S,S"
														Modificables="N,S,N"
														Size="0,10,40"
														ValuesArray="#ArrayDestino#" 
														Title="Lista de Centros de Custodia"
														Tabla="CRCentroCustodia"
														Columnas="CRCCid as DESTINO,CRCCcodigo as DESTINOCOD,CRCCdescripcion as DESTINODESCRIP"
														Filtro="Ecodigo = #Session.Ecodigo# Order by CRCCcodigo"
														Desplegar="DESTINOCOD,DESTINODESCRIP"
														Etiquetas="C&oacute;digo,Descripci&oacute;n"
														filtrar_por="CRCCcodigo,CRCCdescripcion"
														Formatos="S,S"
														Align="left,left"
														form="Filtros"
														Asignar="DESTINO,DESTINOCOD,DESTINODESCRIP"
														Asignarformatos="S,S,S"/>	
											  	</td>
											</tr>
										</table>
									</fieldset>
								</td>
							</tr>
							<tr>			
								<td colspan="3">
									<cfset Lvar_boton='Importar'>
									<cf_botones values="Agregar" names="Agregar" tabindex="8" include="#Lvar_boton#">
								</td>
							</tr>			
						</table>
					</form>
				<cf_web_portlet_end>
				<cf_dbfunction name="to_char" args="a.AFTRid" returnvariable="AFTRid" >
<!---				<cf_dbfunction name="to_char" args="c.Aplaca" returnvariable="Aplaca" >
--->				<cf_dbfunction name="concat"  args="rtrim(e.CRTDcodigo) ,' - ',rtrim(e.CRTDdescripcion)" returnvariable="_CRTipoDocumento">
				<cf_dbfunction name="concat"  args="d.DEidentificacion ,'-',d.DEapellido1 ,' ' ,d.DEapellido2,' ' ,d.DEnombre" returnvariable="DEidentificacion">
				<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return PopUperr(""PCTRC"",1,""'?#PreserveSingleQuotes(AFTRid)# ?'"",""'?c.Aplaca?'"");''><img border=''0'' src=''/cfmx/sif/imagenes/stop.gif''></a>&nbsp;'" returnvariable="img1" delimiters="?">
				<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return funcEliminarError(2,'?#PreserveSingleQuotes(AFTRid)#?');''><img border=''0'' src=''/cfmx/sif/imagenes/stop2.gif''></a>&nbsp;' " returnvariable="img2" delimiters="?">
				<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return funcEliminarError(3,'?#PreserveSingleQuotes(AFTRid)#?');''><img border=''0'' src=''/cfmx/sif/imagenes/stop3.gif''></a>&nbsp;'"  returnvariable="img3" delimiters="?">
				<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return funcEliminarError(4,'?#PreserveSingleQuotes(AFTRid)#?');''><img border=''0'' src=''/cfmx/sif/imagenes/stop4.gif''></a>&nbsp;'"  returnvariable="img4" delimiters="?">
				<cf_dbfunction name="OP_concat" returnvariable="_Cat">
				<!--- Campos de las tablas --->
				<cfset columnas = "	a.AFTRid,
									a.AFRid,
									#PreserveSingleQuotes(_CRTipoDocumento)# as CRTipoDocumento,
									c.Aplaca,
									c.Adescripcion,
									b.AFRfini,
									rtrim(f.CFcodigo) as CFuncional,
									#PreserveSingleQuotes(DEidentificacion)# as DEidentificacion,
									g.CRCCcodigo Origen,h.CRCCcodigo as Destino,
							  		case 
										when exists ( select 1 from AFTResponsables aftr2 where aftr2.AFTRid <> a.AFTRid and aftr2.AFRid = a.AFRid ) 
										then #PreserveSingleQuotes(img1)# 
									end 
									#_Cat#
									case a.AFTRestado 
										when 50 
										then #PreserveSingleQuotes(img2)# 
									end 
									#_Cat#
									case 
										when not exists ( select 1 from CRCCCFuncionales where CRCCid = a.CRCCid and CFid = b.CFid ) 
										then #PreserveSingleQuotes(img3)# 
									end 
									#_Cat#
									case 
										when exists ( select 1 from CRAClasificacion where CRCCid = a.CRCCid ) 
										then 
											case 
												when not exists ( select 1 from CRAClasificacion where CRCCid = a.CRCCid and ACcodigo = c.ACcodigo and ACid = c.ACid ) 
												then  #PreserveSingleQuotes(img4)# 
											end
										when exists ( select 1 from CRAClasificacion where CRCCid <> a.CRCCid and ACcodigo = c.ACcodigo and ACid = c.ACid ) 
										then #PreserveSingleQuotes(img4)# 
									end	
							 		#_Cat# ' ' as error,
									case 
										when exists (select 1 from AFTResponsables aftr2 where aftr2.AFTRid <> a.AFTRid and aftr2.AFRid = a.AFRid ) 
										then a.AFTRid
										when not exists ( select 1 from CRCCCFuncionales where CRCCid = a.CRCCid and CFid = b.CFid ) then a.AFTRid
										when exists ( select 1 from CRAClasificacion where CRCCid = a.CRCCid ) 
										then 
											case 
												when not exists ( select 1 from CRAClasificacion where CRCCid = a.CRCCid and ACcodigo = c.ACcodigo and ACid = c.ACid ) 
												then a.AFTRid
											end
											when exists ( select 1 from CRAClasificacion where CRCCid <> a.CRCCid and ACcodigo = c.ACcodigo and ACid = c.ACid ) 
											then a.AFTRid
										else 0
									end as inactivecol" >
				
				<!--- Tablas --->				
				<cfset tabla = "
						AFTResponsables a
						inner join AFResponsables  b
							on a.AFRid	= b.AFRid
						inner join Activos c
							on b.Aid	= c.Aid
							and b.Ecodigo = c.Ecodigo
						inner join DatosEmpleado  d
							on b.DEid 	= d.DEid 
							and b.Ecodigo = d.Ecodigo
						left outer join CRTipoDocumento e
							on  b.Ecodigo = e.Ecodigo
							and b.CRTDid =e.CRTDid
						left outer join CFuncional f
							on  b.Ecodigo = f.Ecodigo
							and b.CFid =f.CFid
						left outer join CRCentroCustodia g
							on  b.Ecodigo = g.Ecodigo
							and b.CRCCid  = g.CRCCid	
						left outer join CRCentroCustodia h
							on  a.CRCCid  = h.CRCCid		
				">
				
				<!--- Condiciones del filtro --->
				<cfset filtro = " a.Usucodigo = #Session.Usucodigo# and AFTRestado in (30,50) and AFTRtipo = 2 ">
				
				<cf_web_portlet_start titulo="Lista de Documentos a Transferir">
			  		<form  action="CTRC_TrasladosSQL.cfm"  method="post" enctype="multipart/form-data" name="form1"  style="margin:0;">
			  			<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									<cfquery name="rsCRTipoDocumento" datasource="#Session.Dsn#">
										select b.CRTDid as value, <cf_dbfunction name="concat" args="rtrim(b.CRTDcodigo),' - ' , rtrim(b.CRTDdescripcion)"> as description, 0, b.CRTDcodigo
										from CRTipoDocumento b
										where b.Ecodigo =  #Session.Ecodigo# 
										union 
										select -1 as value, '--Todos--' as description, -1, ' ' from dual
										order by 3,4
									</cfquery>
									<cfquery name="rsCFuncional" datasource="#Session.DSn#">
										select distinct afr.CFid as value, rtrim(cf.CFcodigo) as description, 0, cf.CFcodigo
										from AFTResponsables aftr
											inner join AFResponsables afr
												on afr.AFRid = aftr.AFRid
												and afr.Ecodigo =  #Session.Ecodigo# 
											inner join CFuncional cf
												on cf.CFid = afr.CFid
										where aftr.Usucodigo =  #session.Usucodigo# 
											and aftr.AFTRestado in (30,50) and aftr.AFTRtipo = 2
										union 
										select -1 as value, '--Todos--' as description, -1, ' ' from dual
										order by 3,4
									</cfquery>						
                                    <cfinvoke component="sif.Componentes.PlistaControl" method="GetControl" returnvariable="ContList">
                                        <cfinvokeargument name="SScodigo" value="SIF">
                                        <cfinvokeargument name="SMcodigo" value="AF">
                                        <cfinvokeargument name="SPcodigo" value="CTRCTRASL">
                                        <cfinvokeargument name="default"  value="25">
                                    </cfinvoke>
									<cfinvoke 
										component="sif.Componentes.pListas"
										method="pLista"
										returnvariable="Lvar_Lista"
										tabla="#tabla#"
										columnas="#columnas#"
										desplegar="CRTipoDocumento,Aplaca,Adescripcion,AFRfini,CFuncional,DEidentificacion,Origen,Destino,error"
										etiquetas="Tipo de Documento, Placa, Descripci&oacute;n, Fecha, Centro Funcional, Identificaci&oacute;n,Origen,Destino,&nbsp;"
										formatos="S,S,S,D,S,S,U,U,U"
										filtro="#filtro#"
										incluyeform="false"
										align="left,left,left,left,left,left,left,left,right"
										checkboxes="S"
										keys="AFTRid"
										maxrows="#ContList.MaxRow#"
										showlink="false"
										rscrtipodocumento="#rsCRTipoDocumento#"
										rscfuncional="#rsCFuncional#"
										filtrar_automatico="true"
										filtrar_por="e.CRTDid, c.Aplaca, c.Adescripcion, b.AFRfini, f.CFid, d.DEidentificacion,Origen,Destino,''"
										mostrar_filtro="true"
										ira="CTRC_TrasladosSQL.cfm"
										showemptylistmsg="true"
										formname="form1"
										inactivecol="inactivecol"
										ajustar="N"
									/>
								</td>
							</tr>
						</table>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="33%" align="left">&nbsp;</td>
								<td width="33%" align="center">
									<cf_botones values="Eliminar,Eliminar Todos,Aplicar #AplicarTodosValues#" names="Eliminar,EliminarT,Aplicar #AplicarTodosNames#">
								</td>
								<td width="33%" align="right">
									<cfif rsErrores.error>
										<a href="##" onclick="javascript:return funcEliminarError(1);"><img border='0' src='/cfmx/sif/imagenes/deletestop.gif'></a>
									</cfif>
									<cfif rsErrores.error2>
										<a href="##" onclick="javascript:return funcEliminarError(2);"><img border='0' src='/cfmx/sif/imagenes/deletestop2.gif'></a>
									</cfif>
									<cfif rsErrores.error3>
										<a href="##" onclick="javascript:return funcEliminarError(3);"><img border='0' src='/cfmx/sif/imagenes/deletestop3.gif'></a>
									</cfif>
									<cfif rsErrores.error4>
										<a href="##" onclick="javascript:return funcEliminarError(4);"><img border='0' src='/cfmx/sif/imagenes/deletestop4.gif'></a>
									</cfif>
									&nbsp;
								</td>
							</tr>
						</table>	
			  		</form>
		<!----
		Verificacion si todo lo que se iba a agregar se agrego, o se dejo algun activo fuera por estar siendo manipulado desde Activos Fijos--->
		<cfif isdefined("URL.Agregar")>
			<cfquery name="rsActivoNoAgregados" datasource="#session.DSN#">
			Select count(1) as RSet
				from AFResponsables a
						inner join Activos b
							on a.Aid = b.Aid
								and a.Ecodigo = b.Ecodigo
				where CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CRCCid#">
					and a.Ecodigo = #session.Ecodigo# 
					and #hoy# between AFRfini and AFRffin 
				<cfif isdefined("URL.AplacaINI") and len(trim(URL.AplacaINI))> 
					and Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.AplacaINI#">
				</cfif>
				<cfif isdefined("URL.DEid") and len(trim(URL.DEid))>
					and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.DEid#">
				</cfif>
				<cfif isdefined("URL.CFid_filtro") and len(trim(URL.CFid_filtro))>
					and a.CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.CFid_filtro#">
				</cfif>
				<cfif isdefined("URL.CRTDid") and len(trim(URL.CRTDid))>
					and a.CRTDid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.CRTDid#">
				</cfif>	
				and AFRid not in (
					select AFRid 
					from AFTResponsables 
					where Usucodigo =  #session.Usucodigo# 
				and AFTRtipo = 2) 
					and exists (
					Select 1 
					from ADTProceso ADT 
					where ADT.Ecodigo = b.Ecodigo 
					and ADT.Aid = b.Aid)
			</cfquery>	
			
				<cfif isdefined("URL.AplacaINI") and len(trim(URL.AplacaINI))>
				     <cfset urlParam =urlParam & "&AplacaINI=#URL.AplacaINI#">   
				</cfif>
				<cfif isdefined("URL.DEid") and len(trim(URL.DEid))>
				    <cfset urlParam =urlParam & "&DEid_filtro=#URL.DEid#">   
				</cfif>	
				<cfif isdefined("URL.CFid") and len(trim(URL.CFid))>
				   <cfset urlParam =urlParam & "&CFid=#URL.CFid#">   
				</cfif>
				<cfif isdefined("URL.CRTDid") and len(trim(URL.CRTDid))>
				   <cfset urlParam =urlParam & "&CRCCidFT=#URL.CRTDid#">   
				</cfif>	
				<cfif isdefined("URL.CRCCid") and len(trim(URL.CRCCid))>
				   <cfset urlParam =urlParam & "&CRCCid=#URL.CRCCid#">   
				</cfif>	
		</cfif>
			  		<cfif rsErrores.error or rsErrores.error2 or rsErrores.error3 or rsErrores.error4 or isdefined("URL.Agregar")>
			  			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
							<tr>
								<td>
									<cfif rsErrores.error>
										<img src="/cfmx/sif/imagenes/stop.gif">&nbsp; Error! El registro se encuentra siendo transferido por otro usuario en este momento. No se puede procesar Registro!<br />
									</cfif>
									<cfif rsErrores.error2>
										<img src="/cfmx/sif/imagenes/stop2.gif">&nbsp; Error! El registro fu&eacute; rechazado por el Centro de Custodia Destino. El Registro puede ser reprocesado!<br />
									</cfif>
									<cfif rsErrores.error3>
										<img src="/cfmx/sif/imagenes/stop3.gif">&nbsp; Error! El Centro Funcional del Documento no se encuentra asociado al Centro Centro de Custodia Destino. No se puede procesar Registro!<br />
									</cfif>
									<cfif rsErrores.error4>
										<img src="/cfmx/sif/imagenes/stop4.gif">&nbsp; Error! La Categoría/Clase del Activo no permite trasladar el documento de responsabilidad  a un Centro de Custodia distinto.<br />
									</cfif>
									<cfif isdefined("URL.Agregar")>
									    <cfif rsActivoNoAgregados.RSet GT 0>
									      <a href="##" onClick="javascript:PopUpAdv();"> 
									         <img border=''0'' src="/cfmx/sif/imagenes/stop4.gif">&nbsp;Advertencia! Algunos Activos cumplen con los filtros seleccionados, pero no fueron agregados ya que están siendo procesados desde Activos Fijos!<br />								
									      </a>
									    </cfif>
									</cfif>
								</td>
							</tr>
			  			</table>
					</cfif>
				<cf_web_portlet_end>
			</cfoutput>	
		
		<cf_web_portlet_end>
	<cf_templatefooter>

<cfif isdefined("url.noinserta") and url.noinserta eq 1>
	<script>alert("No es posible agregar el vale porque no coinciden los filtros origen o el vale ya se encuentra agregado");</script>
</cfif>	

<cf_qforms form = "Filtros" objForm = "objForm1">
<cf_qforms form = "form1" objForm = "objForm2">

<script type="text/javascript">
	<!--//	
	function funcImportar(){
		objForm1.CRCCid.required = false;
		objForm1.DESTINO.required = false;
		objForm1.CFid.required = false;
		objForm1.DEid.required = false;
		return true;
	
	}
	document.Filtros.AplacaINI.focus();
	
	objForm1.CRCCid.required = true;
	objForm1.CRCCid.description="Centro de Custodia";			
	
	objForm1.DESTINO.required= true;
	objForm1.DESTINO.description="Centro de Custodia Destino";	

	_addValidator("isCentro", Centros_valida);
	objForm1.DESTINO.validateCentro();		

	function Centros_valida()
	{
		if (this.value == document.Filtros.CRCCid.value) {
			this.error = "El centro de custodia destino debe ser diferente al origen";
		}		
	}
	
	function funcAgregar() 
	{
		if(document.Filtros.DEid.value !='') {
			objForm1.CFid.required= false;
		}
		else {
			objForm1.CFid.required= true;
			objForm1.CFid.description="Centro Funcional";
		}
		if(document.Filtros.CFid.value !='') {
			objForm1.DEid.required= false;
		}	
		else {
			objForm1.DEid.required= true;
			objForm1.DEid.description="Empleado";		
		}
		if(document.Filtros.AplacaINI.value !='') {
			objForm1.DEid.required= false;
			objForm1.CFid.required= false;
		}

	}
	 
	function algunoMarcado()
	{
		var f = document.form1;
		if (f.chk) {
			if (f.chk.checked) {
				return true;
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) { 
						return true;
					}
				}
			}
		}
		return false;
	}
	
	function funcEliminar() 
	{
		if (algunoMarcado()) {
			if(confirm('Esta seguro que desea eliminar los registros seleccionados ?')) {
				return true;
			}
		} else {
			alert("Debe seleccionar los elementos de la lista que desea eliminar!");
		}
		return false;
	}
	
	function funcEliminarT()
	{
		if(confirm('Esta seguro que desea eliminar todos los registros ?')){
			return true;
		}
		else{
			return false;
		}
	}
		
	function funcAplicar()
	{
		if (algunoMarcado()) {
			if(confirm('Esta seguro que desea aplicar los registros seleccionados ?')) {
				return true;
			}
		} else {
			alert("Debe seleccionar los elementos de la lista que desea aplicar!");
		}
		return false;
	}
		
	function funcAplicarT()
	{
		if(confirm('Esta seguro que desea aplicar todos los registros ?')){
			return true;
		}
		else{
			return false;
		}
	}
	
	function funcEliminarError(errornum,aftrid)
	{
		switch (errornum) {
			case 1:
				errormsg = "que se encuentran siendo transferidos por otros usuarios"
				break;
			case 2:
				errormsg = "que se fueron rechazados por el centro de custodia destino"
				break;
			case 3:
				errormsg = "que el Centro Funcional del Documento no se encuentra asociado al Centro Centro de Custodia Destino"
				break;
			case 4:
				errormsg = "que la Categoría/Clase del Activo no permite trasladar el documento de responsabilidad a un Centro de Custodia distinto"
				break;
		}
		if (confirm("Desea eliminar todos los traslados "+errormsg+"?")) {
			if (!aftrid) aftrid = 0;
			document.location.href="CTRC_TrasladosSQL.cfm?EliminarError=true&errornum="+errornum+"&aftrid="+aftrid;
			document.form1.nosubmit = true;
			return false;
		}
		document.form1.nosubmit = true;
		return false;
	}
	
	function PopUperr(Pantorigen,Numerr,AFTRid,Placa)
	{
		var PARAM  = "Usrerrors.cfm?err="+Numerr+"&Pantorigen="+Pantorigen+"&AFTRid="+AFTRid+"&Placa="+Placa;
		open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=no,width=350,height=300');
	}
	function PopUpAdv()
	{
	
		var PARAM  = "UsrAdvert.cfm?adv=3<cfoutput>#urlParam#</cfoutput>";
		open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=no,width=550,height=300')
	}
</script>

<cfoutput>
	<cfif isDefined("Lvar_Lista") and len(trim(Lvar_Lista))>
		<script language="javascript1.2" type="text/javascript">	
			if (#Lvar_Lista# > 500) {
				alert('La consulta retorno mas de 500 registros. Favor detallar mas las condiciones del filtro para dar un mayor rendimiento.');
			}
		</script>
	</cfif>
</cfoutput>

