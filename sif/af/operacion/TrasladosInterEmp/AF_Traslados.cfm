<cfif isdefined("url.AFMovsID") and not isdefined("form.AFMovsID")>
	<cfset form.AFMovsID = url.AFMovsID >
</cfif>
<cfif isdefined("url.AFMovsIDlinea") and not isdefined("form.AFMovsIDlinea")>
	<cfset form.AFMovsIDlinea = url.AFMovsIDlinea >
</cfif>

<cfquery name="rsEmpresaCMB" datasource="asp">
	select Ereferencia as Ecodigo , Enombre 
		from Empresa where CEcodigo = #session.CEcodigo# 
		and Ereferencia is not null 
		and Ereferencia != #session.Ecodigo#
</cfquery>

<cfif isdefined("form.AFMovsID") and len(trim(form.AFMovsID))>
	<cfset  modo = 'CAMBIO'>
	<cfquery name="rsEmcabezado" datasource="#session.dsn#">
		select * from AFMovsEmpresasE
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  AFMovsID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
	</cfquery>
	<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
		<cfquery name="rsEcodigo" datasource="#session.DSN#">
			select a.Ecodigo_O
			from AFMovsEmpresasD a
			where a.AFMovsID  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
			and a.AFMovsIDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsIDlinea#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<!--- Periodo--->
		<cfquery name="rsPeriodo" datasource="#session.DSN#">
			select p1.Pvalor as value from Parametros p1 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEcodigo.Ecodigo_O#"> 
			and Pcodigo = 50
		</cfquery>
		<!--- Mes --->
		<cfquery name="rsMes" datasource="#session.DSN#">
			select p1.Pvalor as value from Parametros p1 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEcodigo.Ecodigo_O#"> 
			and Pcodigo = 60
		</cfquery>		

		<cfquery name="rsLineas" datasource="#session.dsn#">
			select b.Enombre,
			a.AFRmotivo as AFRmotivoORI,AFRdescripcion as AFRdescripcionORI,
			c.Aplaca,c.Adescripcion,
			d.ACcodigo as ACcodigoORI,f.ACcodigodesc as CATORI,f.ACdescripcion as CATdescripcionORI,
			d.ACid as ACidORI,g.ACcodigodesc as CLASSORI,g.ACcodigodesc as  CLASSdescripcionORI,
			d.Ocodigo as OcodigoORI,Oficodigo as OficodigoORI,Odescripcion as OdescripcionORI,
			d.CFid as CFidORI,i.CFcodigo as CFcodigoORI,i.CFdescripcion as CFdescripcionORI,
			j.Dcodigo as DcodigoORI,Deptocodigo as DeptocodigoORI,Ddescripcion as DdescripcionORI,
			k.AFCcodigo as AFCcodigoORI,AFCcodigoclas as AFCcodigoclasORI,AFCdescripcion as AFCdescripcionORI,
			a.ACcodigo as ACcodigoDES,l.ACcodigodesc as CATDES,l.ACdescripcion as CATdescripcionDES,
			a.ACid as ACidDES,m.ACcodigodesc as CLASSDES,m.ACdescripcion as CLASSdescripcionDES,
			a.CFid as CFidDES,n.CFcodigo as CFcodigoDES,n.CFdescripcion as CFdescripcionDES
			from AFMovsEmpresasD a
			inner join Empresa b
				on 	a.Ecodigo_O = b.Ereferencia
				and CEcodigo = #session.CEcodigo#
			inner join Activos c
				on a.Aid = c.Aid
				and a.Ecodigo_O = c.Ecodigo
			inner join AFSaldos d
				on a.Aid = d.Aid
				and a.Ecodigo_O = d.Ecodigo
				and d.AFSperiodo =  #rsPeriodo.value#	
				and d.AFSmes     =  #rsMes.value#
			inner join AFRetiroCuentas e
				on a.AFRmotivo = e.AFRmotivo
				and a.Ecodigo_O = e.Ecodigo
			inner join ACategoria f
				on  d.ACcodigo = f.ACcodigo
				and d.Ecodigo = f.Ecodigo
			inner join AClasificacion g
				on  d.ACcodigo = g.ACcodigo
				and d.ACid = g.ACid
				and d.Ecodigo = g.Ecodigo
			inner join Oficinas h
				on  d.Ocodigo = h.Ocodigo
				and d.Ecodigo = h.Ecodigo
			inner join CFuncional i
				on  d.CFid  = i.CFid 
				and d.Ecodigo = i.Ecodigo
			inner join Departamentos j
				on i.Ecodigo = j.Ecodigo
				and  i.Dcodigo  = j.Dcodigo
			inner join AFClasificaciones k
				on  d.AFCcodigo  = k.AFCcodigo 
				and d.Ecodigo = k.Ecodigo
			inner join ACategoria l
				on  a.ACcodigo = l.ACcodigo
				and a.Ecodigo = l.Ecodigo
			inner join AClasificacion m
				on  a.ACcodigo = m.ACcodigo
				and a.ACid = m.ACid
				and a.Ecodigo = m.Ecodigo
			inner join CFuncional n
				on  a.CFid  = n.CFid 
				and a.Ecodigo = n.Ecodigo
			where a.AFMovsID  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
			and a.AFMovsIDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsIDlinea#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>	
	
<cfelse>
	<cfset  modo = 'ALTA'>
</cfif>

<cf_templateheader title="Activos Fijos ">
		<cf_templatecss>
		<cfinclude template="/sif/Utiles/params.cfm">
		<cf_web_portlet_start border="true" titulo="Traslados de Activos entre Empresas" skin="#Session.Preferences.Skin#">
			<form action="AF_TrasladosSQL.cfm"  method="post" name="form1" id="form1">
				
				<cfoutput>
				<cfif  modo EQ 'ALTA'>
					<table width="100%" border="0">
						<tr>
							<td width="20%"><strong>Fecha :</strong></td>
							<td width="80%"><cf_sifcalendario name="AFMovsFecha" value="#LSDateformat(Now(),'dd/mm/yyyy')#"  tabindex="1"></td>
						</tr>
						<tr>
							<td><strong>Descripci&oacute;n :</strong></td>
							<td>
								<input tabindex="2" name="AFMovsDescripcion" type="text" size="80" maxlength="80"/>
							</td>
						</tr>	
						<tr>
							<td><strong>Motivo del Traslado :</strong></td>
							<td>
								<textarea tabindex="3" name="AFMovsExplicacion" cols="80" rows="4"></textarea>
							</td>
						</tr>		
						<tr>
							<td colspan="2"><cf_botones modo="#MODO#" tabindex="4"></td>
						</tr>			
					</table>	
				<cfelse>
					<table width="100%" border="0">
						<!--- ************************************ --->
						<!--- *** Area del encabezado         **** --->
						<!--- ************************************ --->
						<tr>
							<td>
							<a href="javascript: verEncabezado('Ecabezado');" ><img  id="img_Ecabezado" src="../../../imagenes/derecha.gif"  width="10" height="10" border="0" >
								Ver encabezado	</a> 
							</td>
						</tr>
						<tr id="TR_Ecabezado"  style="display: none;">
							<td>
								<table width="100%" border="0">
									<tr>
										<td width="20%"><strong>Fecha :</strong></td>
										<td width="80%"><cf_sifcalendario name="AFMovsFecha" value="#LSDateformat(rsEmcabezado.AFMovsFecha,'dd/mm/yyyy')#"  tabindex="1"></td>
									</tr>
									<tr>
										<td><strong>Descripci&oacute;n :</strong></td>
										<td>
											<input 
												tabindex="2" 
												name="AFMovsDescripcion" 
												type="text" 
												size="80" 
												maxlength="80"
												value="<cfif isdefined("rsEmcabezado.AFMovsDescripcion") and len(trim(rsEmcabezado.AFMovsDescripcion))>#rsEmcabezado.AFMovsDescripcion#</cfif>"/>
										</td>
									</tr>	
									<tr>
										<td><strong>Motivo del Traslado :</strong></td>
										<td>
											<textarea 
												tabindex="3" 
												name="AFMovsExplicacion" 
												cols="80" 
												rows="4"><cfif isdefined("rsEmcabezado.AFMovsExplicacion") and len(trim(rsEmcabezado.AFMovsExplicacion))>#rsEmcabezado.AFMovsExplicacion#</cfif></textarea>
										</td>
									</tr>	
									<tr >
										<td colspan="2"><cf_botones values="Modificar" names="Modificar" tabindex="4"></td>
									</tr>	
										
								</table>	
							</td>
						</tr>
						<tr>
							<td>
								<table width="100%" border="0">
									<tr>
										<td width="50%" valign="top">
											<!--- ************************************ --->
											<!--- *** Datos Origen                **** --->
											<!--- ************************************ --->
											<cfset LvarTitulo = "">
											<cfif isdefined("form.AFmovsIdLinea") and len(trim(form.AFmovsIdLinea))>
												<cfset LvarTitulo =  "Datos Origen">
											<cfelse>
												<cfset LvarTitulo =  "Filtro Datos Origen">
											</cfif>
											<fieldset><legend><cfoutput>#LvarTitulo#</cfoutput></legend>
											<table width="100%" border="0">
												<tr>
													<td width="30%"><strong>Empresa Origen :</strong></td>
													<td width="70%">
														<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
															#rsLineas.Enombre#
															<input name="EcodigoOrigen" type="hidden" value="#rsEcodigo.Ecodigo_O#">
														<cfelse>
															<select name="EcodigoOrigen" tabindex="5">
																<cfloop query="rsEmpresaCMB">
																	<option value="#Ecodigo#" >#Enombre#</option>
																</cfloop>
															</select>
														</cfif>
														
													</td>
												</tr>
												<tr>
													<td><strong>Raz&oacute;n de retiro :</strong></td>
													<td>
														<cfset ArrayMotivoO=ArrayNew(1)>
														<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
															<cfset ArrayAppend(ArrayMotivoO,rsLineas.AFRmotivoORI)>
															<cfset ArrayAppend(ArrayMotivoO,rsLineas.AFRdescripcionORI)>
														</cfif> 
														<cf_conlis
															Campos="AFRmotivoORI,AFRdescripcionORI"
															Desplegables="N,S"
															Modificables="N,N"
															Size="0,43"
															tabindex="1"
															ValuesArray="#ArrayMotivoO#" 
															Title="Lista de motivos de retiro"
															Tabla="AFRetiroCuentas "
															Columnas="AFRmotivo as AFRmotivoORI,AFRdescripcion as AFRdescripcionORI"
															Filtro=" Ecodigo = $EcodigoOrigen,numeric$  and AFResventa <> 'S'"
															Desplegar="AFRdescripcionORI"
															Etiquetas="Descripci&oacute;n"
															filtrar_por="AFRdescripcion"
															Formatos="S"
															Align="left"
															form="form1"
															Asignar="AFRmotivoORI,AFRdescripcionORI"
															Asignarformatos="S,S"/>
													</td>
												</tr>	
												<tr>
													<td><strong>Activo fijo :</strong></td>
													<td>
														<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
															[#trim(rsLineas.Aplaca)#]&nbsp;&nbsp;#rsLineas.Adescripcion#
														<cfelse>
															<cf_conlis 
																campos="AplacaO,AdescripcionO"
																size="10,30"
																desplegables="S,S"
																modificables="S,N"
																title="Lista de Activos"
																tabla="Activos"
																columnas="Aplaca as AplacaO,Adescripcion as AdescripcionO"
																filtro="Ecodigo = $EcodigoOrigen,numeric$ and Astatus = 0 Order by Aplaca"									
																filtrar_por="Aplaca,Adescripcion"
																desplegar="AplacaO,AdescripcionO"
																etiquetas="Placa,Descripci&oacute;n"
																formatos="S,S"
																align="left,left"
																asignar="AplacaO,AdescripcionO"
																asignarFormatos="S,S"
																form="form1"
																showEmptyListMsg="true"
																tabindex="1"
																EmptyListMsg=" --- No se encontraron registros --- "/>
														</cfif>
													</td>
												</tr>
												<tr>
													<td><strong>Categor&iacute;a :</strong></td>
													<td>
														<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
															[#trim(rsLineas.CATORI)#]&nbsp;&nbsp;#rsLineas.CATdescripcionORI#
														<cfelse>
															<cf_conlis
																Campos="ACcodigoORI,CATORI,CATdescripcionORI"
																Desplegables="N,S,S"
																Modificables="N,S,N"
																Size="0,10,30"
																tabindex="1"
																Title="Lista de Categor&iacute;as"
																Tabla="ACategoria "
																Columnas="ACcodigo as ACcodigoORI,ACcodigodesc as CATORI,ACdescripcion as CATdescripcionORI"
																Filtro=" Ecodigo = $EcodigoOrigen,numeric$"
																Desplegar="CATORI,CATdescripcionORI"
																Etiquetas="C&oacute;digo,Descripci&oacute;n"
																filtrar_por="ACcodigodesc,ACdescripcion"
																Formatos="S,S"
																Align="left,left"
																form="form1"
																Asignar="ACcodigoORI,CATORI,CATdescripcionORI"
																Asignarformatos="S,S,S"/>
														</cfif>		
													</td>
												</tr>
												<tr>
													<td><strong>Clase :</strong></td>
													<td>
														<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
															[#trim(rsLineas.CLASSORI)#]&nbsp;&nbsp;#rsLineas.CLASSdescripcionORI#
														<cfelse>
															<cf_conlis 
																Campos="ACidORI,CLASSORI,CLASSdescripcionORI"
																Desplegables="N,S,S"
																Modificables="N,S,N"
																Size="0,10,30"
																tabindex="1"
																Title="Lista de Clases"
																Tabla="AClasificacion "
																Columnas="ACid as ACidORI,ACcodigodesc as CLASSORI,ACdescripcion as CLASSdescripcionORI"
																Filtro=" Ecodigo = $EcodigoOrigen,numeric$ and ACcodigo = $ACcodigoORI,numeric$"
																Desplegar="CLASSORI,CLASSdescripcionORI"
																Etiquetas="C&oacute;digo,Descripci&oacute;n"
																filtrar_por="ACcodigodesc,ACdescripcion"
																Formatos="S,S"
																Align="left,left"
																form="form1"
																Asignar="ACidORI,CLASSORI,CLASSdescripcionORI"
																Asignarformatos="S,S,S"/>
														<cfset ArrayClasO=ArrayNew(1)>
														
														</cfif>	
													</td>
												</tr>
												<tr>
													<td><strong>Oficina :</strong></td>
													<td>
														<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
															[#trim(rsLineas.OficodigoORI)#]&nbsp;&nbsp;#rsLineas.OdescripcionORI#
														<cfelse>
															<cf_conlis 
																Campos="OcodigoORI,OficodigoORI,OdescripcionORI"
																Desplegables="N,S,S"
																Modificables="N,S,N"
																Size="0,10,30"
																tabindex="1"

																Title="Lista de Oficinas"
																Tabla="Oficinas "
																Columnas="Ocodigo as OcodigoORI,Oficodigo as OficodigoORI,Odescripcion as OdescripcionORI"
																Filtro=" Ecodigo = $EcodigoOrigen,numeric$ "
																Desplegar="OficodigoORI,OdescripcionORI"
																Etiquetas="C&oacute;digo,Descripci&oacute;n"
																filtrar_por="Ocodigo,Odescripcion"
																Formatos="S,S"
																Align="left,left"
																form="form1"
																Asignar="OcodigoORI,OficodigoORI,OdescripcionORI"
																Asignarformatos="S,S,S"/>
														</cfif>	
													</td>
												</tr>
												<tr>
													<td><strong>Departamento :</strong></td>
													<td>
														<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
															[#trim(rsLineas.DeptocodigoORI)#]&nbsp;&nbsp;#rsLineas.DdescripcionORI#
														<cfelse>
															<cf_conlis 
																Campos="DcodigoORI,DeptocodigoORI,DdescripcionORI"
																Desplegables="N,S,S"
																Modificables="N,S,N"
																Size="0,10,30"
																tabindex="1"
																Title="Lista de Departamentos"
																Tabla="Departamentos "
																Columnas="Dcodigo as DcodigoORI,Deptocodigo as DeptocodigoORI,Ddescripcion as DdescripcionORI"
																Filtro=" Ecodigo = $EcodigoOrigen,numeric$ "
																Desplegar="DeptocodigoORI,DdescripcionORI"
																Etiquetas="C&oacute;digo,Descripci&oacute;n"
																filtrar_por="Deptocodigo,Ddescripcion"
																Formatos="S,S"
																Align="left,left"
																form="form1"
																Asignar="DcodigoORI,DeptocodigoORI,DdescripcionORI"
																Asignarformatos="S,S,S"/>
														</cfif>	
														
														
													</td>
												</tr>
												<tr>
													<td><strong>Centro Funcional :</strong></td>
													<td>
														<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
															[#trim(rsLineas.CFcodigoORI)#]&nbsp;&nbsp;#rsLineas.CFdescripcionORI#
														<cfelse>
															<cf_conlis 
																Campos="CFidORI,CFcodigoORI,CFdescripcionORI"
																Desplegables="N,S,S"
																Modificables="N,S,N"
																Size="0,10,30"
																tabindex="1"
																Title="Lista de Centros Funcionales"
																Tabla="CFuncional "
																Columnas="CFid as CFidORI,CFcodigo as CFcodigoORI,CFdescripcion as CFdescripcionORI"
																Filtro=" Ecodigo = $EcodigoOrigen,numeric$"
																Desplegar="CFcodigoORI,CFdescripcionORI"
																Etiquetas="C&oacute;digo,Descripci&oacute;n"
																filtrar_por="CFcodigo,CFdescripcion"
																Formatos="S,S"
																Align="left,left"
																form="form1"
																Asignar="CFidORI,CFcodigoORI,CFdescripcionORI"
																Asignarformatos="S,S,S"/>
														</cfif>	
													</td>
												</tr>
												<tr>
													<td><strong>Tipo :</strong></td>
													<td>
														<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
															[#trim(rsLineas.AFCcodigoclasORI)#]&nbsp;&nbsp;#rsLineas.AFCdescripcionORI#
														<cfelse>
															<cf_conlis 
																Campos="AFCcodigoORI,AFCcodigoclasORI,AFCdescripcionORI"
																Desplegables="N,S,S"
																Modificables="N,S,N"
																Size="0,10,30"
																tabindex="1"
																Title="Lista de tipos"
																Tabla="AFClasificaciones "
																Columnas="AFCcodigo as AFCcodigoORI,AFCcodigoclas as AFCcodigoclasORI,AFCdescripcion as AFCdescripcionORI,AFCnivel as AFCnivelORI"
																Filtro=" Ecodigo = $EcodigoOrigen,numeric$"
																Desplegar="AFCcodigoclasORI,AFCdescripcionORI,AFCnivelORI"
																Etiquetas="C&oacute;digo,Descripci&oacute;n,Nivel"
																filtrar_por="AFCcodigoclas,AFCdescripcion,AFCnivel"
																Formatos="S,S,S"
																Align="left,left,left"
																form="form1"
																Asignar="AFCcodigoORI,AFCcodigoclasORI,AFCdescripcionORI"
																Asignarformatos="S,S,S"/>
														</cfif>			
													</td>
												</tr>
											</table>
											</fieldset>
										</td>
										<td width="50%" valign="top">
											<!--- ************************************ --->
											<!--- *** Datos Destino               **** --->
											<!--- ************************************ --->
											<fieldset><legend>Datos Destino</legend>
											<table width="100%" border="0">
												<tr>
													<td><strong>Categor&iacute;a :</strong></td>
													<td>
														<cfset ArrayCATD=ArrayNew(1)>
														<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
															<cfset ArrayAppend(ArrayCATD,rsLineas.ACcodigoDES)>
															<cfset ArrayAppend(ArrayCATD,rsLineas.CATDES)>
															<cfset ArrayAppend(ArrayCATD,rsLineas.CATdescripcionDES)>
														</cfif>
														<cf_conlis
															Campos="ACcodigoDES,CATDES,CATdescripcionDES"
															Desplegables="N,S,S"
															Modificables="N,S,N"
															Size="0,10,30"
															tabindex="1"
															ValuesArray="#ArrayCATD#" 
															Title="Lista de Categor&iacute;as"
															Tabla="ACategoria"
															Columnas="ACcodigo as ACcodigoDES,ACcodigodesc as CATDES,ACdescripcion as CATdescripcionDES"
															Filtro=" Ecodigo = #Session.Ecodigo#"
															Desplegar="CATDES,CATdescripcionDES"
															Etiquetas="C&oacute;digo,Descripci&oacute;n"
															filtrar_por="ACcodigodesc,ACdescripcion"
															Formatos="S,S"
															Align="left,left"
															form="form1"
															Asignar="ACcodigoDES,CATDES,CATdescripcionDES"
															Asignarformatos="S,S,S"/>
													</td>
												</tr>
												<tr>
													<td><strong>Clase :</strong></td>
													<td>
														<cfset ArrayClasD=ArrayNew(1)>
														<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
															<cfset ArrayAppend(ArrayClasD,rsLineas.ACidDES)>
															<cfset ArrayAppend(ArrayClasD,rsLineas.CLASSDES)>
															<cfset ArrayAppend(ArrayClasD,rsLineas.CLASSdescripcionDES)>
														</cfif>
														<cf_conlis
															Campos="ACidDES,CLASSDES,CLASSdescripcionDES"
															Desplegables="N,S,S"
															Modificables="N,S,N"
															Size="0,10,30"
															tabindex="1"
															ValuesArray="#ArrayClasD#" 
															Title="Lista de Clases"
															Tabla="AClasificacion "
															Columnas="ACid as ACidDES,ACcodigodesc as CLASSDES,ACdescripcion as CLASSdescripcionDES"
															Filtro=" Ecodigo = #Session.Ecodigo# and ACcodigo = $ACcodigoDES,numeric$"
															Desplegar="CLASSDES,CLASSdescripcionDES"
															Etiquetas="C&oacute;digo,Descripci&oacute;n"
															filtrar_por="ACcodigodesc,ACdescripcion"
															Formatos="S,S"
															Align="left,left"
															form="form1"
															Asignar="ACidDES,CLASSDES,CLASSdescripcionDES"
															Asignarformatos="S,S,S"/>
													</td>
												</tr>
												<tr>
													<td><strong>Centro Funcional :</strong></td>
													<td>
														<cfset ArrayCFD=ArrayNew(1)>
														<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
															<cfset ArrayAppend(ArrayCFD,rsLineas.CFidDES)>
															<cfset ArrayAppend(ArrayCFD,rsLineas.CFcodigoDES)>
															<cfset ArrayAppend(ArrayCFD,rsLineas.CFdescripcionDES)>
														</cfif> 
														<cf_conlis
															Campos="CFidDES,CFcodigoDES,CFdescripcionDES"
															Desplegables="N,S,S"
															Modificables="N,S,N"
															Size="0,10,30"
															tabindex="1"
															ValuesArray="#ArrayCFD#" 
															Title="Lista de Centros Funcionales"
															Tabla="CFuncional "
															Columnas="CFid as CFidDES,CFcodigo as CFcodigoDES,CFdescripcion as CFdescripcionDES"
															Filtro=" Ecodigo =  #Session.Ecodigo#"
															Desplegar="CFcodigoDES,CFdescripcionDES"
															Etiquetas="C&oacute;digo,Descripci&oacute;n"
															filtrar_por="CFcodigo,CFdescripcion"
															Formatos="S,S"
															Align="left,left"
															form="form1"
															Asignar="CFidDES,CFcodigoDES,CFdescripcionDES"
															Asignarformatos="S,S,S"/>
													</td>
												</tr>
											</table>											
											</fieldset>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
												<cf_botones values="Modificar línea,Nueva (s) línea (s),Aplicar,Eliminar Grupo,Imprimir,Ir a Lista" names="ModifLineas,Nueva,Aplicar,EliminarDoc,Imprimir,IrALista" tabindex="4">
											<cfelse>
												<cf_botones values="Agregar líneas,Aplicar,Eliminar Grupo,Imprimir,Ir a Lista" names="Agregarlineas,Aplicar,EliminarDoc,Imprimir,IrALista" tabindex="4">
											</cfif>
										</td>
									</tr>
									<input name="AFMovsID" type="hidden" value="#form.AFMovsID#">
									<input name="DELLINEA" type="hidden" value="">
									<input name="AFMovsIDlinea" type="hidden" value="<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>#form.AFMovsIDlinea#</cfif>">
								</table>
								
							</td>
						</tr>
						<input name="DatosOrigen" type="hidden" value="">
						
						<tr>
							<td align="center">
							 <cf_web_portlet_start border="true" titulo="Activos para trasladar" skin="#Session.Preferences.Skin#">
							 <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
								<cfquery name="rsLista" datasource="#session.dsn#">
									select 	AFMovsID,
										AFMovsIDlinea,
										a.Ecodigo_O,
										Enombre as Empresa,
										a.Aplaca,
										Adescripcion ,
										'<a href=javascript:eliminarlinea('#_Cat# <cf_dbfunction name="to_char" args="a.AFMovsIDlinea" >#_Cat#');><img src=/cfmx/sif/imagenes/delete.small.png border=0></a>' as linkDel
										from AFMovsEmpresasD a 
										inner join Empresa b 
											on a.Ecodigo_O = b.Ereferencia 
											and CEcodigo = #session.CEcodigo#  
										inner join Activos c 
											on a.Ecodigo_O = c.Ecodigo 
											and a.Aid = c.Aid
											<cfif isdefined("form.filtro_Adescripcion") and len(trim(form.filtro_Adescripcion))>
												and ltrim(rtrim(upper(c.Adescripcion))) like '%#trim(ucase(form.filtro_Adescripcion))#%'
											</cfif>
										where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and a.AFMovsID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
										<cfif isdefined("form.filtro_Ecodigo") and len(trim(form.filtro_Ecodigo)) and form.filtro_Ecodigo neq '-1'>
											and a.Ecodigo_O = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.filtro_Ecodigo#">
										</cfif>
										<cfif isdefined("form.filtro_Aplaca") and len(trim(form.filtro_Aplaca))>
											and ltrim(rtrim(upper(a.Aplaca))) like '%#trim(ucase(form.filtro_Aplaca))#%'
										</cfif>
									order by a.AFMovsIDlinea 
								</cfquery>	
								
								
								<cfset navegacion = "&AFMovsID=#form.AFMovsID#">
								<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
									<cfset navegacion = "&AFMovsID=#form.AFMovsID#&AFMovsIDlinea=#form.AFMovsIDlinea#">
								</cfif>
								
								
								<table width="100%" border="0">
									<tr>
										<td class="tituloListas" align="left" valign="bottom" width="20%">Empresa Origen</td>
										<td width="20%" align="left" valign="bottom" class="tituloListas">Placa</td>
										<td width="50%" align="left" valign="bottom" class="tituloListas">Descripción Activo</td>
										<td width="10%" align="left" valign="bottom" class="tituloListas">&nbsp;</td>
									</tr>
									<tr>
										<td class="tituloListas" align="left" valign="bottom">
										<cfquery name="rsEmpresaCMB" datasource="#Session.Dsn#">
											select Ereferencia as value , Enombre  as description , 0
												from Empresa where CEcodigo = #session.CEcodigo# 
												and Ereferencia is not null 
												and Ereferencia != #session.Ecodigo#
											union select -1 as value, '--Todos--' as description, -1 from dual
											order by 3
										</cfquery>										
										<select name="filtro_Ecodigo" tabindex="5">
											<cfloop query="rsEmpresaCMB">
												<option value="#rsEmpresaCMB.value#" <cfif isdefined("form.filtro_Ecodigo") and len(trim(form.filtro_Ecodigo)) and form.filtro_Ecodigo eq rsEmpresaCMB.value> selected</cfif> >#rsEmpresaCMB.description#</option>
											</cfloop>
										</select>
										
										</td>
										<td class="tituloListas" align="left" valign="bottom">
										<input 	
											type="text" 
											size="20" 
											maxlength="20" 
											style="width:100%" 
											onfocus="this.select()" 
											name="filtro_Aplaca" value="<cfif isdefined("form.filtro_Aplaca") and len(trim(form.filtro_Aplaca))>#form.filtro_Aplaca#</cfif>">
										</td>
										<td class="tituloListas" align="left" valign="bottom">
										<input 	
											type="text" 
											size="60" 
											maxlength="60" 
											style="width:100%" 
											onfocus="this.select()" 
											name="filtro_Adescripcion" value="<cfif isdefined("form.filtro_Adescripcion") and len(trim(form.filtro_Adescripcion))>#form.filtro_Adescripcion#</cfif>">
										
										</td>
										<td align="left" valign="bottom" class="tituloListas">
											<cf_botones values="Filtrar" names="Filtrar" tabindex="4">
										</td>
									</tr> 
									</form>
									<tr>
										<td  colspan="4">
											<cfinvoke 
												component="sif.Componentes.pListas"
												method="pListaQuery"
												returnvariable="pListaRet">
												<cfinvokeargument name="query"     			value="#rsLista#"/>
												<cfinvokeargument name="desplegar" 			value="Empresa,Aplaca,Adescripcion,linkDel"/>
												<cfinvokeargument name="etiquetas" 			value="Empresa Origen,Placa,Descripción Activo,&nbsp;"/>
												<cfinvokeargument name="formatos" 			value="S,S,S,U"/>
												<cfinvokeargument name="align" 				value="left,left,left,left"/>
												<cfinvokeargument name="ajustar"			value="N"/>
												<cfinvokeargument name="checkboxes" 		value="N"/>
												<cfinvokeargument name="irA" 				value="AF_Traslados.cfm"/>
												<cfinvokeargument name="keys" 				value="AFMovsID,AFMovsIDlinea"/>
												<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
												<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
											</cfinvoke>
										</td>
									</tr>									
								</table>								
							 <cf_web_portlet_end>
							</td>
						</tr>
					</table>
					
				</cfif>
			</cfoutput>	
			<cf_qforms>
			<script language="javascript1.2" type="text/javascript">
				<cfif  modo EQ 'ALTA'>
					objForm.AFMovsFecha.description="Fecha";
					objForm.AFMovsDescripcion.description="descripción";
				<cfelse>
					objForm.AFRmotivoORI.description="Razón de retiro";
					objForm.ACcodigoDES.description="Categoría Destino";
					objForm.ACidDES.description="Clase Destino";
					objForm.CFidDES.description="Centro funcional Destino";
					objForm.DatosOrigen.description="Alguno de los campos Origen";
					objForm.AFMovsID.description="Lote";
					<cfif isdefined("form.AFMovsIDlinea")>
						objForm.AFMovsIDlinea.description="linea";
					</cfif>
					
				</cfif>
				function habilitarValidacion(){
					<cfif  modo EQ 'ALTA'>
						objForm.AFMovsFecha.required=true;
						objForm.AFMovsDescripcion.required=true;
					<cfelse>
						objForm.AFRmotivoORI.required=true;
						objForm.ACcodigoDES.required=true;
						objForm.ACidDES.required=true;
						objForm.CFidDES.required=true;
						objForm.DatosOrigen.required=true;
						objForm.AFMovsID.required=true;
						<cfif isdefined("form.AFMovsIDlinea")>
							objForm.AFMovsIDlinea.required=true;
						</cfif>
					</cfif>
				}
				
				function deshabilitarValidacion(){
					<cfif  modo EQ 'ALTA'>
						objForm.AFMovsFecha.required=false;
						objForm.AFMovsDescripcion.required=false;
					<cfelse>
						objForm.AFRmotivoORI.required=false;
						objForm.ACcodigoDES.required=false;
						objForm.ACidDES.required=false;
						objForm.CFidDES.required=false;
						objForm.DatosOrigen.required=false;
						objForm.AFMovsID.required=false;
						<cfif isdefined("form.AFMovsIDlinea")>
							objForm.AFMovsIDlinea.required=false;
						</cfif>
					</cfif>
				}
				function funcEliminarDoc(){
					if ( confirm('¿Desea eliminar el grupo de traslado?') ){
						deshabilitarValidacion(); 
						return true; 
						}
						else{ 
						return false;
					}
				} 
				
				function funcAplicar(){
					deshabilitarValidacion();
				} 
												
				function funcAgregarlineas(){
					habilitarValidacion();
					<cfif not isdefined("form.AFMovsIDlinea")>
						if(document.form1.AplacaO.value != "" 
							|| document.form1.ACcodigoORI.value != "" 
							|| document.form1.ACidORI.value != ""
							|| document.form1.OcodigoORI.value != ""
							|| document.form1.DcodigoORI.value != ""
							|| document.form1.CFidORI.value != ""
							|| document.form1.AFCcodigoORI.value != ""){
							objForm.DatosOrigen.required=false;
						}
					</cfif>
				} 
				function funcModifLineas(){
					habilitarValidacion();
					objForm.DatosOrigen.required=false;
				}
				
				function funcImprimir(){
					deshabilitarValidacion();
					var PARAM  = "AF_TrasladosREP.cfm?AFMovsID=<cfoutput>#form.AFMovsID#</cfoutput>" 
					open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=860,height=520')
					return false;
				} 
				
				function funcIrALista(){
					deshabilitarValidacion();
				} 

				function verEncabezado(idx) {
					var tr = document.getElementById("TR_"+idx);
					var img = document.getElementById("img_"+idx);
					img.src = ((tr.style.display == "none") ? "../../../imagenes/abajo.gif" : "../../../imagenes/derecha.gif");
					tr.style.display = ((tr.style.display == "none") ? "" : "none");
				}
				
				function funcIrALista() {
					document.form1.AFMovsID.value="";
					document.form1.action = "AF_ListaTraslados.cfm";
					document.form1.submit();
				}	
				function funcFiltrar() {
					document.form1.action = "AF_Traslados.cfm";
					document.form1.submit();
				}

				function eliminarlinea(llave) {
					if (confirm('Esta seguro que desea eliminar la línea')) {
						document.form1.AFMovsIDlinea.value = llave;
						document.form1.DELLINEA.value = 'LINEA';
						document.form1.submit();
					}
				}

			</script>
		<cf_web_portlet_end>
	<cf_templatefooter>


