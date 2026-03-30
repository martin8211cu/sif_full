<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfset urlParam="">
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_dbfunction name="now" returnvariable="hoy">
<!--- Variables que vienen el url --->
<cfif isdefined("url.DEid") and not isDefined("form.DEid") and not isDefined("form.DEid_sql")>
	<cfset form.DEid_sql = url.DEid>
</cfif>
<cfif isdefined("url.DEidentificacion") and not isDefined("form.DEidentificacion") and not isDefined("form.DEidentificacion_sql")>
	<cfset form.DEidentificacion_sql = url.DEidentificacion>
</cfif>
<cfif isdefined("url.DEnombrecompleto") and not isDefined("form.DEnombrecompleto") and not isDefined("form.DEnombrecompleto_sql")>
	<cfset form.DEnombrecompleto_sql = url.DEnombrecompleto>
</cfif>
<cfif isdefined("url.CRTDidFT") and not isDefined("form.CRTDidFT") and not isDefined("form.CRTDidFT_sql")>
	<cfset form.CRTDidFT_sql = url.CRTDidFT>
</cfif>
<cfif isdefined("url.CRCCidFT") and not isDefined("form.CRCCidFT") and not isDefined("form.CRCCidFT_sql")>
	<cfset form.CRCCidFT_sql = url.CRCCidFT>
</cfif>
<cfif isdefined("form.CFid") and not isDefined("form.CFid") and not isDefined("form.CFid_sql")>
	<cfset form.CFid_sql = url.CFid>
</cfif>
<cfif isdefined("form.CFcodigo") and not isDefined("form.CFcodigo") and not isDefined("form.CFcodigo_sql")>
	<cfset form.CFcodigo_sql = url.CFcodigo>
</cfif>
<cfif isdefined("form.CFdescripcion") and not isDefined("form.CFdescripcion") and not isDefined("form.CFdescripcion_sql")>
	<cfset form.CFdescripcion_sql = url.CFdescripcion>
</cfif>
<cfif isdefined("form.AplacaINI") and not isDefined("form.AplacaINI") and not isDefined("form.AplacaINI_sql")>
	<cfset form.AplacaINI_sql = url.AplacaINI>
</cfif>
<cfif isdefined("form.AdescripcionINI") and not isDefined("form.AdescripcionINI") and not isDefined("form.AdescripcionINI_sql")>
	<cfset form.AdescripcionINI_sql = url.AdescripcionINI>
</cfif>
<cfif isdefined("form.AdescripcionFIN") and not isDefined("form.AdescripcionFIN") and not isDefined("form.AdescripcionFIN_sql")>
	<cfset form.AdescripcionFIN_sql = url.AdescripcionFIN>
</cfif>

<!--- Variables que vienen el form --->
<cfif isdefined("form.CRTDidFT_sql") and not isDefined("form.CRTDidFT")>
	<cfset form.CRTDidFT = form.CRTDidFT_sql>
</cfif>
<cfif isdefined("form.CRCCidFT_sql") and not isDefined("form.CRCCidFT")>
	<cfset form.CRCCidFT = form.CRCCidFT_sql>
</cfif>
<cfif isdefined("form.DEid_sql") and not isDefined("form.DEid")>
	<cfset form.DEid = form.DEid_sql>
</cfif>
<cfif isdefined("form.DEidentificacion_sql") and not isDefined("form.DEidentificacion")>
	<cfset form.DEidentificacion = form.DEidentificacion_sql>
</cfif>
<cfif isdefined("form.DEnombrecompleto_sql") and not isDefined("form.DEnombrecompleto")>
	<cfset form.DEnombrecompleto = form.DEnombrecompleto_sql>
</cfif>
<cfif isdefined("form.CFid_sql") and not isDefined("form.CFid")>
	<cfset form.CFid = form.CFid_sql>
</cfif>
<cfif isdefined("form.CFcodigo_sql") and not isDefined("form.CFcodigo")>
	<cfset form.CFcodigo = form.CFcodigo_sql>
</cfif>
<cfif isdefined("form.CFdescripcion_sql") and not isDefined("form.CFdescripcion")>
	<cfset form.CFdescripcion = form.CFdescripcion_sql>
</cfif>
<cfif isdefined("form.AplacaINI_sql") and not isDefined("form.AplacaINI")>
	<cfset form.AplacaINI = form.AplacaINI_sql>
</cfif>
<cfif isdefined("form.AdescripcionINI_sql") and not isDefined("form.AdescripcionINI")>
	<cfset form.AdescripcionINI = form.AdescripcionINI_sql>
</cfif>
<cfif isdefined("form.AdescripcionFIN_sql") and not isDefined("form.AdescripcionFIN")>
	<cfset form.AdescripcionFIN = form.AdescripcionFIN_sql>
</cfif>

<cfquery datasource="#session.dsn#" name="RSCentros">
	Select  a.CRCCid, a.CRCCcodigo,a.CRCCdescripcion
		from CRCentroCustodia a
		  inner join CRCCUsuarios b
			on a.CRCCid  = b.CRCCid 
		   and Usucodigo = #session.Usucodigo# 
	where Ecodigo = #session.Ecodigo# 
	order by a.CRCCcodigo
</cfquery>
<cfif RSCentros.recordcount eq 0>
	<cf_errorCode	code = "50127" msg = "Usted no tiene asociado ningún Centro de Custodia, no puede utilizar este proceso, Proceso Cancelado!">
</cfif>

<cfquery datasource="#session.dsn#" name="RSRetiros">
	select AFRmotivo,AFRdescripcion 
	 from AFRetiroCuentas
	where Ecodigo = #session.Ecodigo#
	  and AFResventa <> 'S'
	order by AFRmotivo
</cfquery>

<cfquery datasource="#session.dsn#" name="RSTipos">
	Select CRTDid,CRTDcodigo,CRTDdescripcion 
		from CRTipoDocumento 
		where Ecodigo  = #session.Ecodigo#
</cfquery>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<form action="retiros-sql.cfm"  method="post"  name="form1" style="margin:0;">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>
			<cf_web_portlet_start titulo="Filtros para realizar el retiro">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<!--- ************************************************************* --->
					<tr>
						<td class="fileLabel" align="left" nowrap>Centro de Custodia:</td>
						<td>
							<cfif RSCentros.recordcount gt 0>
								<cfif RSCentros.recordcount eq 1>
									<input name="CRCCidFT" value="#RSCentros.CRCCid#" type="hidden">
									#RSCentros.CRCCcodigo#-#RSCentros.CRCCdescripcion#
								<cfelse>
									<select name="CRCCidFT" tabindex="1">
									<cfloop query="RSCentros">
										<option value="#RSCentros.CRCCid#"  
										<cfif isdefined("form.CRCCidFT") and len(trim(form.CRCCidFT)) and form.CRCCidFT eq RSCentros.CRCCid> 
										selected="selected"</cfif>>
										#RSCentros.CRCCcodigo#-#RSCentros.CRCCdescripcion#</option>
									</cfloop>
									</select>
								</cfif>
							<cfelse>
								<input name="CRCCidFT"  value="-1" type="hidden">
							</cfif>					
						</td>
						<td class="fileLabel" align="left" nowrap>Tipo de Documento:</td>
						<td>
							<select name="CRTDidFT" tabindex="1">
								<option value="-1">-- Todos --</option>
								<cfloop query="RSTipos">
									<option value="#RSTipos.CRTDid#" 
									<cfif isdefined("form.CRTDidFT") and len(trim(form.CRTDidFT)) and form.CRTDidFT eq RSTipos.CRTDid> 
										selected="selected"</cfif>>
									#RSTipos.CRTDcodigo#-#RSTipos.CRTDdescripcion#</option>
								</cfloop>
							</select>					
						</td>
					</tr>	
					<!--- ************************************************************* --->			
					<tr>
						<td  class="fileLabel" align="left" nowrap>Empleado:</td>
						<td >
							<cfset ArrayEmp=ArrayNew(1)>
							<cfif isdefined("form.DEid") and len(trim(form.DEid))> 
								<cfset ArrayAppend(ArrayEmp,form.DEid)>
								<cfset ArrayAppend(ArrayEmp,form.DEidentificacion)>
								<cfset ArrayAppend(ArrayEmp,form.DEnombrecompleto)>
							</cfif>
							<cf_dbfunction name="concat" args="A.DEapellido1 ,' ',A.DEapellido2 ,' ' ,A.DEnombre" returnvariable="DEnombrecompleto">
							<cf_conlis
								Campos="DEid,DEidentificacion,DEnombrecompleto"
								ValuesArray="#ArrayEmp#"
								tabindex="1"
								Desplegables="N,S,S"
								Modificables="N,S,N"
								Size="0,15,35"
								Title="Lista de Empleados"
								Tabla="DatosEmpleado A 
									   inner join  AFResponsables B
										on A.DEid = B.DEid
										and A.Ecodigo = B.Ecodigo 
										and B.CRCCid = $CRCCidFT,numeric$
										and #hoy# between B.AFRfini and B.AFRffin"
								Columnas="distinct A.DEid ,A.DEidentificacion,#PreserveSingleQuotes(DEnombrecompleto)# as DEnombrecompleto"
								Filtro="A.Ecodigo = #Session.Ecodigo# order by DEidentificacion,DEnombrecompleto"
								Desplegar="DEidentificacion,DEnombrecompleto"
								Etiquetas="Identificaci&oacute;n,Nombre"
								filtrar_por="A.DEidentificacion,#PreserveSingleQuotes(DEnombrecompleto)#"
								Formatos="S,S"
								Align="left,left"
								Asignar="DEid,DEidentificacion,DEnombrecompleto"
								Asignarformatos="I,S,S"/>							
						</td>
						<td class="fileLabel" align="left" nowrap>Centro Funcional:</td>
						<td>
							<cfset ArrayCF=ArrayNew(1)>
							<cfif isdefined("form.CFid") and len(trim(form.CFid))> 
								<cfset ArrayAppend(ArrayCF,form.CFid)>
								<cfset ArrayAppend(ArrayCF,form.CFcodigo)>
								<cfset ArrayAppend(ArrayCF,form.CFdescripcion)>
							</cfif>
							<cf_conlis
								Campos="CFid,CFcodigo,CFdescripcion"
								Desplegables="N,S,S"
								Modificables="N,S,N"
								Size="0,10,40"
								tabindex="1"
								ValuesArray="#ArrayCF#" 
								Title="Lista de Centros Funcionales"
								Tabla="CRCCCFuncionales a
								inner join CFuncional b
								on a.CFid = b.CFid
								and b.Ecodigo = #Session.Ecodigo#
								inner join CRCentroCustodia c
								on a.CRCCid = c.CRCCid 
								and c.CRCCid = $CRCCidFT,numeric$"
								Columnas="b.CFid,b.CFcodigo,b.CFdescripcion"
								Filtro=""
								Desplegar="CFcodigo,CFdescripcion"
								Etiquetas="C&oacute;digo,Descripci&oacute;n"
								filtrar_por="b.CFcodigo,b.CFdescripcion"
								Formatos="S,S"
								Align="left,left"
								form="form1"
								Asignar="CFid,CFcodigo,CFdescripcion"
								Asignarformatos="S,S,S"/>					
						</td>
						
					</tr>
					<!--- ************************************************************* --->
					<tr>
						<td class="fileLabel" align="left" nowrap>Placa:</td>
						<td >
							<cfset ArrayPlacaI=ArrayNew(1)>
							<cfif isdefined("form.AplacaINI") and len(trim(form.AplacaINI))> 
								<cfset ArrayAppend(ArrayPlacaI,form.AplacaINI)>
								<cfset ArrayAppend(ArrayPlacaI,form.AdescripcionINI)>
							</cfif>							
								<cf_conlis
									tabindex="1"
									aluesArray="#ArrayPlacaI#"
									form="form1"
									Campos="AplacaINI,AdescripcionINI"
									Desplegables="S,S"
									Modificables="S,N"
									Size="15,35"
									Title="Placas"
									Tabla="Activos A
											inner join AFResponsables  B
												on A.Ecodigo = B.Ecodigo
												and A.Aid = B.Aid
												and B.CRCCid = $CRCCidFT,numeric$
												and #hoy# between B.AFRfini and B.AFRffin"
									Columnas="Aplaca as AplacaINI,Adescripcion as AdescripcionINI"
									Filtro="A.Ecodigo = #Session.Ecodigo# and A.Astatus = 0 order by Aplaca "
									Desplegar="AplacaINI,AdescripcionINI"
									Etiquetas="Placa,Descripci&oacute;n"
									filtrar_por="Aplaca,Adescripcion"
									Formatos="S,S"
									Align="left,left"
									Asignar="AplacaINI,AdescripcionINI"
									Asignarformatos="S,S,S,S"
									MaxRowsQuery="200"/>
								
						</td>
					</tr>	
					<tr>			
						<td nowrap="nowrap" align="center" colspan="4">&nbsp;</td>
					</tr>					
					<tr>			
						<td nowrap="nowrap" align="center" colspan="4">
							<input type="submit" name="Agregar" 
							class="btnGuardar" value="Agregar" 
							onclick="javascript: return funcAgregar();" 
							tabindex="1">
					
							<input type="submit" name="Importar" 
							 class="btnNormal" value="Importar" 
							tabindex="1">
							
							<input type="reset" 
							name="Limpiar" class="btnLimpiar" 
							value="Limpiar" 
							onclick="javascript: if (window.funcLimpiar) return funcLimpiar();" 
							tabindex="1">
						</td>
					</tr>	
					<tr>			
						<td nowrap="nowrap" align="center" colspan="4">&nbsp;</td>
					</tr>								
				</table>
			
			<cf_web_portlet_end>
			<cf_dbfunction name="concat" args="rtrim(e.CRTDcodigo) ,' - ' ,rtrim(e.CRTDdescripcion)" returnvariable="_CRTipoDocumento" >
			<cf_dbfunction name="concat" args="rtrim(f.CFcodigo) ,' - ' ,rtrim(f.CFdescripcion)" returnvariable="_CFuncional" >
			<cf_dbfunction name="concat" args="d.DEidentificacion ,'-' ,DEapellido1 ,' ' , DEapellido2 ,' ' , DEnombre" returnvariable="_DEidentificacion" >
			<cf_dbfunction name="concat" args="'<a href=''javascript:PopUperr(""PR"",1,""'+rtrim(ltrim(c.Aplaca))+'"");''><img border=''0'' src=''/cfmx/sif/imagenes/stop.gif''></a>'"  returnvariable="Imagen1" delimiters= "+" >
			<cf_dbfunction name="concat" args="'<a href=''javascript:PopUperr(""PR"",2,""'+rtrim(ltrim(c.Aplaca))+'"");''><img border=''0'' src=''/cfmx/sif/imagenes/stop2.gif''></a>'" returnvariable="Imagen2" delimiters= "+" >
			<cf_dbfunction name="concat" args="'<a href=''javascript:PopUperr(""PR"",3,""'+rtrim(ltrim(c.Aplaca))+'"");''><img border=''0'' src=''/cfmx/sif/imagenes/stop3.gif''></a>'" returnvariable="Imagen3" delimiters= "+" >
			<cf_dbfunction name="OP_concat" returnvariable="_Cat">
			<cfset navegacion =  "&Filtrar=Filtrar">
			<cfset columnas = "DISTINCT a.AFRid,
								e.CRTDid,
								#PreserveSingleQuotes(_CRTipoDocumento)# as CRTipoDocumento,
								c.Aplaca,
								c.Adescripcion,
								a.AFRfini,
								rtrim(f.CFcodigo) as CFcodigo,
								#PreserveSingleQuotes(_CFuncional)# as CFuncional,
								d.DEidentificacion,
							  	#PreserveSingleQuotes(_DEidentificacion)# as DEidentificacionCompleta,
							  	g.CRCCid,
								g.CRCCcodigo Origen, Usulogin,
								
					/***Imagen Mejora Pendiente de aplicar*/
								case when exists (	select 1 
													from CRDocumentoResponsabilidad  x
													where x.CRCCid = a.CRCCid
													and x.CRDRplaca= c.Aplaca
													) then #PreserveSingleQuotes(Imagen1)#
									end
									#_Cat# 
									
					/***Imagen Traslado Pendiente de aplicar*/							
									case 
										when exists (	
											select 1 
											from AFTResponsables y
											where y.CRCCid = a.CRCCid
											and y.AFRid= a.AFRid 
										) then #PreserveSingleQuotes(Imagen2)#
									end
									#_Cat#
									
					/***Imagen Retiro Pendiente de aplicar*/
									case when exists (	
											select 1 
											from CRCRetiros z
											where z.Ecodigo     =  Re.Ecodigo
											  and z.Aid	        =  Re.Aid
											  and z.BMUsucodigo != Re.BMUsucodigo
										 ) then  #PreserveSingleQuotes(Imagen3)#
									end
										as estados,
										
					/****Columan Inactiva Mejora Pendiente de aplicar*/
									case 
										when exists (	
											select 1 
											from CRDocumentoResponsabilidad  x
											where x.CRCCid = a.CRCCid
											and x.CRDRplaca= c.Aplaca
										) then a.AFRid
										
					/****Columna inactiva Traslado Pendiente de aplicar*/	
									else 
										case 
											when exists (	
												select 1 
												from AFTResponsables y
												where y.CRCCid = a.CRCCid
												and y.AFRid= a.AFRid 
											) then a.AFRid
										end
									end
										as inactivecol" >
				
				<!--- FROM USADO EN LA LISTA --->
				<cfset tablalst = "
						CRCRetiros Re
						inner join AFResponsables a
							 on a.Ecodigo = Re.Ecodigo
						    and a.Aid = Re.Aid
						inner join Activos c
							on a.Aid	= c.Aid
							and a.Ecodigo = c.Ecodigo
						inner join DatosEmpleado  d
							on a.DEid 	= d.DEid 
							and a.Ecodigo = d.Ecodigo
						left outer join CRTipoDocumento e
							on  a.Ecodigo = e.Ecodigo
							and a.CRTDid =e.CRTDid
						left outer join CFuncional f
							on  a.Ecodigo = f.Ecodigo
							and a.CFid =f.CFid
						left outer join CRCentroCustodia g
							on  a.Ecodigo = g.Ecodigo
							and a.CRCCid  = g.CRCCid 
						left join Usuario usu
							on Re.BMUsucodigo = usu.Usucodigo " >
							
				<cfquery name="rsExistenErrores" datasource="#Session.Dsn#">
					Select 	case when exists (	select 1 
												from CRDocumentoResponsabilidad  x
												where x.CRCCid = a.CRCCid
													and x.CRDRplaca= c.Aplaca ) then 1 else 0				   
							end as Error1,
							case when exists (	select 1 
												from AFTResponsables y
												where y.CRCCid = a.CRCCid
													and y.AFRid= a.AFRid ) then 1 else 0
							end as Error2,
							case when exists (	select 1 
												from CRCRetiros z
												where z.Ecodigo =  Re.Ecodigo
													and z.Aid = Re.Aid
													and z.BMUsucodigo != Re.BMUsucodigo ) then 1 else 0
							end as Error3
				
					from CRCRetiros Re
						inner join AFResponsables a
							on a.Ecodigo = Re.Ecodigo
							and a.Aid = Re.Aid
						inner join Activos c
							on a.Aid = c.Aid
							and a.Ecodigo = c.Ecodigo
						inner join DatosEmpleado  d
							on a.DEid = d.DEid 
							and a.Ecodigo = d.Ecodigo
						left outer join CRTipoDocumento e
							on a.Ecodigo = e.Ecodigo
							and a.CRTDid = e.CRTDid
						left outer join CFuncional f
							on a.Ecodigo = f.Ecodigo
							and a.CFid =f.CFid
						left outer join CRCentroCustodia g
							on a.Ecodigo = g.Ecodigo
							and a.CRCCid = g.CRCCid	
				
					where a.Ecodigo = #Session.Ecodigo#
						and #hoy# between a.AFRfini and a.AFRffin
						and Re.BMUsucodigo =  #session.Usucodigo# 	
				</cfquery>			
				
				<cfset filtro = " a.Ecodigo = #Session.Ecodigo# "> 
				<cfset filtro = filtro &  "  and #hoy# between a.AFRfini and a.AFRffin ">
				<cfset filtro = filtro &  "  and Re.BMUsucodigo = #session.Usucodigo# ">
				<cfset filtro = filtro &  " order by a.AFRfini">

				<cf_web_portlet_start titulo="Lista de Documentos para realizar retiro">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>			
							<td width="10%" align="left" nowrap class="fileLabel">Motivo de retiro:</td>
							<td width="90%" nowrap="nowrap">
								<select name="AFRmotivo" tabindex="1">
								<option value="">-Seleccione un Motivo-</option>
								<cfloop query="RSRetiros">
									<option value="#RSRetiros.AFRmotivo#"  
									<cfif isdefined("form.AFRmotivo") and len(trim(form.AFRmotivo)) and form.AFRmotivo eq RSRetiros.AFRmotivo> 
									selected="selected"</cfif>>
									#RSRetiros.AFRmotivo#-#RSRetiros.AFRdescripcion#</option>
								</cfloop>
								</select>
								&nbsp;&nbsp;&nbsp;
								Justificación:
								<input type="text" name="RSJustificacion" style="width:20%" maxlength="50">
						  </td>
						</tr>					
						<tr>
							<td colspan="2">
								<!--- Consulta de Tipo Documento para el combo del filtro de la lista --->
								<cfquery name="rsCRTipoDocumento" datasource="#Session.Dsn#">
									select 	b.CRTDid as value, 
											<cf_dbfunction name="concat" args="rtrim(b.CRTDcodigo),' - ' ,rtrim(b.CRTDdescripcion) "> as description, 
											0, 
											b.CRTDcodigo
									 from CRTipoDocumento b
									where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
									union 
									select 	-1 as value, '--Todos--' as description, -1,' ' 
									 from dual
									order by 3,4
								</cfquery>
								<!--- Consulta de Centro Funcional para el combo del filtro de la lista --->
								<cfquery name="rsCFuncional" datasource="#Session.DSn#">
									select 	distinct cf.CFid as value, 
											rtrim(cf.CFcodigo) as description,
											0, 
											cf.CFcodigo
									from CRCRetiros aftr
										inner join AFResponsables afr 
											on afr.AFRid = aftr.AFRid
										inner join CFuncional cf 
											on cf.CFid = afr.CFid
									where aftr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
									union 
									select 	-1 as value,'--Todos--' as description,-1,' ' 
									 from dual
									order by 3,4								
								</cfquery>
								<!--- Consulta del Origen para el combo del filtro de la lista --->
								<cfquery datasource="#session.dsn#" name="rsOrigen">
									Select  a.CRCCid as value, 
											a.CRCCcodigo as description
									from  CRCentroCustodia a
										inner join CRCCUsuarios b
											on a.CRCCid  = b.CRCCid 
											and  Usucodigo =  #session.Usucodigo# 
									where Ecodigo =  #session.Ecodigo# 
									order by a.CRCCcodigo
								</cfquery>
								
								<!--- Lista de Placas o Activos Retirados --->
								<cfinvoke 
									component="sif.Componentes.pListas"
									method="pLista"
									returnvariable="Lvar_Lista"
									tabla="#tablalst#"
									columnas="#columnas#"
									desplegar="CRTipoDocumento,Aplaca,Adescripcion,AFRfini,CFcodigo,DEidentificacionCompleta,Usulogin,Origen,estados"
									etiquetas="Tipo de Documento, Placa, Descripci&oacute;n, Fecha, Centro Funcional, Identificaci&oacute;n,Usuario,CC Origen,&nbsp;"
									formatos="S,S,S,D,S,S,S,U,U"
									filtro="#filtro#"
									incluyeform="false"
									align="left,left,left,left,left,left,left,left,left"
									checkboxes="S"
									keys="AFRid"
									maxrows="25"
									showlink="false"
									rscrtipodocumento="#rsCRTipoDocumento#"
									rscfcodigo="#rsCFuncional#"			
									rsOrigen="#rsOrigen#"													
									filtrar_automatico="true"
									filtrar_por="e.CRTDid,c.Aplaca,c.Adescripcion,a.AFRfini,f.CFid,d.DEidentificacion,usu.Usulogin,g.CRCCid,''"
									mostrar_filtro="true"
									ira="retiros-sql.cfm"
									showemptylistmsg="true"
									formname="form1"
									inactivecol="inactivecol"
									ajustar="N"
									navegacion="#navegacion#"
								/>
							</td>
						</tr>
					</table>
			<!----
			Verificacion si todo lo que se hiba a agregar se agrego, o se dejo algun activo fuera por estar siendo 
			manipulado desde Activos Fijos
			--->
			<cfif isdefined("form.Agregar_sql")>
				<cfset tabla = "
				AFResponsables a
				inner join Activos c
				   on a.Aid	 = c.Aid
				   and a.Ecodigo = c.Ecodigo
				inner join DatosEmpleado  d
				  on a.DEid 	= d.DEid 
				  and a.Ecodigo = d.Ecodigo
				inner join ADTProceso h 
				  on h.Aid = c.Aid
				left outer join CRTipoDocumento e
				  on  a.Ecodigo = e.Ecodigo
				  and a.CRTDid =e.CRTDid
				left outer join CFuncional f
				  on  a.Ecodigo = f.Ecodigo
				  and a.CFid =f.CFid
				left outer join CRCentroCustodia g
				  on  a.Ecodigo = g.Ecodigo
				  and a.CRCCid  = g.CRCCid
				">													
				<cfset filtro = " a.Ecodigo = #Session.Ecodigo# "> 
				<cfset urlParam="">
				<cfif isdefined("form.AplacaINI") and len(trim(form.AplacaINI))>
				    <cfset filtro = filtro &  " and c.Aplaca = '#form.AplacaINI#'">
				     <cfset urlParam =urlParam & "&AplacaINI='#form.AplacaINI#'">   
				</cfif>
				<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				    <cfset filtro = filtro &  " and a.DEid = #form.DEid#">
				    <cfset urlParam =urlParam & "&DEid=#form.DEid#">   
				</cfif>	
				<cfif isdefined("form.CFid") and len(trim(form.CFid))>
				   <cfset filtro = filtro &  " and a.CFid = #form.CFid#">
				   <cfset urlParam =urlParam & "&CFid=#form.CFid#">   
				</cfif>
				<cfif isdefined("form.CRTDidFT") and len(trim(form.CRTDidFT)) and trim(form.CRTDidFT) NEQ "-1" >
				   <cfset filtro = filtro &  " and a.CRTDid = #form.CRTDidFT#">	
				   <cfset urlParam =urlParam & "&CRTDidFT=#form.CRTDidFT#">   
				</cfif>
				<cfif isdefined("form.CRCCidFT") and len(trim(form.CRCCidFT))>
				   <cfset filtro = filtro &  " and a.CRCCid = #form.CRCCidFT#">
				   <cfset urlParam =urlParam & "&CRCCidFT=#form.CRCCidFT#">   
				</cfif>						
				<cfset filtro = filtro &  "  and #hoy# between a.AFRfini and a.AFRffin ">
				<cfset filtro = filtro &  "  and not exists (Select 1 
														from CRCRetiros Ret 
							 							where Ret.Ecodigo = c.Ecodigo 
							  							and Ret.Aid = c.Aid 
							  							and Ret.BMUsucodigo = #Session.Usucodigo#)">

				<cfset filtro = filtro &  " order by CRCCcodigo,DEidentificacion,Aplaca">
				<cfset sqlerror = "select c.Aplaca from #tabla# where #filtro#">
				<cfquery name="rsActivoNoAgregados" datasource="#Session.Dsn#">
				  #preservesinglequotes(sqlerror)#
				</cfquery>
		          </cfif>	

					<cfif rsExistenErrores.recordcount gt 0 or isdefined('form.Agregar_sql')>
					
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td colspan="2">&nbsp;</td></tr>					
					<tr>
						<td align="right">
							<cfif rsExistenErrores.Error1 eq 1>
								<a href="##" onclick="javascript:return funcEliminarError(1);"><img border='0' src="/cfmx/sif/imagenes/deletestop4.gif"></a>&nbsp;
							</cfif>
							<cfif rsExistenErrores.Error2 eq 1>
								<a href="##" onclick="javascript:return funcEliminarError(2);"><img border='0' src="/cfmx/sif/imagenes/deletestop2.gif"></a>&nbsp;
							</cfif>
							<cfif rsExistenErrores.Error3 eq 1>
								<a href="##" onclick="javascript:return funcEliminarError(3);"><img border='0' src="/cfmx/sif/imagenes/deletestop3.gif"></a>
							</cfif>
							
						</td>
						<td width="6%">&nbsp;</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					</table>
					
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
						<tr>
							<td>
								<cfif rsExistenErrores.Error1 eq 1>
								<img src="/cfmx/sif/imagenes/stop.gif">&nbsp; Error! El registro se encuentra en una mejora. No se puede procesar Registro!<br />
								</cfif>
								<cfif rsExistenErrores.Error2 eq 1>
								<img src="/cfmx/sif/imagenes/stop2.gif">&nbsp; Error! El registro tiene traslados pendientes.  No se puede procesar Registro!<br />
								</cfif>
								<cfif rsExistenErrores.Error3 eq 1>
								<img src="/cfmx/sif/imagenes/stop3.gif">&nbsp; Error! El registro se encuentra en una transacción de retiro de otro usuario.  No se puede procesar Registro!<br />								
								</cfif>
								<cfif isdefined('form.Agregar_sql')>
								 <cfif rsActivoNoAgregados.recordcount gt 0>
								  <a href="##" onClick="javascript:PopUpAdv();"> 
								     <img border=''0'' src="/cfmx/sif/imagenes/stop4.gif">&nbsp;Advertencia! Algunos Activos cumplen con los filtros seleccionados, pero no fueron agregados ya que están siendo procesados desde Activos Fijos!<br />								
								   </a>
								 </cfif>
								</cfif>
							</td>
						</tr>
					</table>
					</cfif>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td  align="center">
								<input type="submit" name="Retirar" 
								class="btnNormal" value="Retirar" 
								onclick="javascript: if (window.funcRetirar) return funcRetirar();" 
								tabindex="1">
								<input type="submit" name="RetirarT" 
								class="btnNormal" value="Retirar Todo" 
								onclick="javascript: if (window.funcRetirar) return funcRetirarT();" 
								tabindex="1">								
								<input type="submit" name="Eliminar" 
								class="btnEliminar" value="Eliminar" 
								onclick="javascript: if (window.funcRetirar) return funcbtnEliminarMasivo();" 
								tabindex="1">								
								<input type="submit" name="EliminarT" 
								class="btnEliminar" value="Eliminar Todo" 
								onclick="javascript: if (window.funcbtnEliminarByUsucodigo) return funcbtnEliminarByUsucodigo();" 
								tabindex="1">								
								
							</td>
	
						</tr>
					</table>	

					<cfif isdefined("form.AplacaINI") and len(trim(form.AplacaINI))> 
						<input name="AplacaINI_psql" value="#form.AplacaINI#" type="hidden">
						<input name="AdescripcionINI_psql" value="#form.AdescripcionINI#" type="hidden">
					</cfif>				
					<cfif isdefined("form.DEid") and len(trim(form.DEid))>
						<input name="DEid_psql" value="#form.DEid#" type="hidden">
						<input name="DEidentificacion_psql" value="#form.DEidentificacion#" type="hidden">
						<input name="DEnombrecompleto_psql" value="#form.DEnombrecompleto#" type="hidden">
					</cfif>	
					<cfif isdefined("form.CFid") and len(trim(form.CFid))>
						<input name="CFid_psql" value="#form.CFid#" type="hidden">
						<input name="CFcodigo_psql" value="#form.CFcodigo#" type="hidden">
						<input name="CFdescripcion_psql" value="#form.CFdescripcion#" type="hidden">
					</cfif>
				<cf_web_portlet_end>
			<!---</cfif>--->
		</cfoutput>	
		</form>
		<cf_web_portlet_end>
	<cf_templatefooter>

<cf_qforms form = "form1" objForm = "objForm1">
<script type="text/javascript">
	objForm1.CRCCidFT.required = true;
	objForm1.CRCCidFT.description="Centro de Custodia";		

	function algunoMarcado(){
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
	
	function funcRetirar() {
		if(document.form1.AFRmotivo.value == ""){
			alert("Debe Indicar el motivo del retiro");
			document.form1.AFRmotivo.focus();
			return false;
		}
		if(document.form1.RSJustificacion.value == ""){
			alert("Debe Indicar una justificación para poder realizar el retiro");
			document.form1.RSJustificacion.focus();
			return false;
		}		
		
		if (algunoMarcado()) {
			if(confirm('Esta seguro que desea retirar los documentos seleccionados ?')) {
				return true;
			}
		} else {
			alert("Debe seleccionar los elementos de la lista que desea retirar!");
		}
		return false;
	}
	
	function funcRetirarT() {

		if(document.form1.AFRmotivo.value == "")
		{
			alert("Debe Indicar el motivo del retiro");
			document.form1.AFRmotivo.focus();
			return false;
		}
		if(document.form1.RSJustificacion.value == "")
		{
			alert("Debe Indicar una justificación para poder realizar el retiro");
			document.form1.RSJustificacion.focus();
			return false;
		}		
		
		if(confirm('Esta seguro que desea retirar los documentos seleccionados ?')) 
		{
			return true;
		}		
		return false;
	}	
	
	function funcbtnEliminarMasivo(){
		if (algunoMarcado()){
			if (confirm("Desea eliminar los elementos seleccionados?")){
				return true;
			}
		} else {
			alert("Debe seleccionar los elementos de la lista que desea eliminar!");
		}
		return false;
	}	
	
	function funcbtnEliminarByUsucodigo(){
		if (confirm("Está seguro que desea eliminar todos los elementos?")){
			return true;
		}
		return false;
	}	
	
	function funcLimpiar(){
		document.form1.DEid.value = "";
		document.form1.DEidentificacion.value = "";
		document.form1.DEnombrecompleto.value = "";
		document.form1.CFid.value = "";
		document.form1.CFcodigo.value = "";
		document.form1.CFdescripcion.value = "";
		document.form1.AplacaINI.value = "";
		document.form1.AdescripcionINI.value = "";	
		return false;
	}	
	
	function PopUperr(Pantorigen,Numerr,Placa){
		var PARAM  = "Usrerrors.cfm?err="+Numerr+"&Pantorigen="+Pantorigen+"&Placa="+Placa;
		open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=no,width=350,height=300')
	}
	function PopUpAdv(){
	
		var PARAM  = "UsrAdvert.cfm?adv=1<cfoutput>#urlParam#</cfoutput>";
		open(PARAM,'','left=300,top=150,scrollbars=yes,resizable=no,width=550,height=300')
	}	
	//-->
</script>

<cfif RSCentros.recordcount gt 0>
	<cfif RSCentros.recordcount neq 1>
		<script language="javascript">
			document.form1.CRCCidFT.focus();
		</script>
	</cfif>
</cfif>

<script language="javascript">
	function funcImportar() 
	{	
		document.form1.action = "../../importar/CTR_importaRetiro.cfm";	
	}
	function funcAgregar() {
		if (document.form1.DEid.value.length == 0 && document.form1.CFid.value.length == 0 && document.form1.AplacaINI.value.length == 0) {
			alert('Debe de digitar por lo menos un criterio para el filtro.');
			return false;
		}
	}
	
	function funcEliminarError(errornum,aftrid){
		switch (errornum) {	
			case 1:
				errormsg = "que se encuentran en una mejora"
				break;
			case 2:
				errormsg = "que tienen traslados pendientes"
				break;
			case 3:
				errormsg = "que se encuentran en una transacción de retiro de otro usuario"
				break;
		}
		if (confirm("Desea eliminar todos los retiros "+errormsg+"?")) {
			if (!aftrid) aftrid = 0;
			document.location.href="retiros-sql.cfm?EliminarError=true&errornum="+errornum+"&aftrid="+aftrid;
			return false;
		}
		return false;
	}	
</script>


