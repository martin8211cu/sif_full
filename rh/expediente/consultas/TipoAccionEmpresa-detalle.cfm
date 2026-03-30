<!--- Navegacion de la lista --->
<!--- Datos de la Empresa --->

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfoutput>
	<script language="javascript1.2" type="text/javascript">	
	function Invocar(Empleado, linea) {		
		document.location.href='/cfmx/rh/expediente/consultas/TipoAccionEmpresa-detalleAccion.cfm?DLlinea=' + linea + '&DEid=' + Empleado;
	}
	</script>
</cfoutput>


<cfif isdefined("url.RHTcomportam") and not isdefined("form.RHTcomportam")>
	<cfset form.RHTcomportam = Url.RHTcomportam>
</cfif>
<cfif isdefined("url.fechaI") and not isdefined("form.fechaI")>
	<cfset form.fechaI = Url.fechaI>
</cfif>
<cfif isdefined("url.fechaF") and not isdefined("form.fechaF")>
	<cfset form.fechaF = Url.fechaF>
</cfif>
<cfif isdefined ('url.CaridList') and not isdefined("form.CaridList")>
	<cfset form.CaridList = Url.CaridList>
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_rs" default="1">
	
<cfquery name="rs" datasource="#session.DSN#">
	select a.DEid,a.DLlinea,de.DEidentificacion, 
		{fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(', ',de.DEnombre)})})})} as Empleado,
		substring({fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(', ',de.DEnombre)})})})},1,30) as nombrecorto,
		b.RHTcodigo,  b.RHTdesc,
		{fn concat(e.Tcodigo,{fn concat(' - ',e.Tdescripcion)})} as Nomina,
		case 
			when b.RHTcomportam = 1 then '<cf_translate key="LB_Nombramiento">Nombramiento</cf_translate>' 
			when b.RHTcomportam = 2 then '<cf_translate key="LB_Cese">Cese</cf_translate>'  
			when b.RHTcomportam = 3 then '<cf_translate key="LB_Vacaciones">Vacaciones</cf_translate>'  
			when b.RHTcomportam = 4 then '<cf_translate key="LB_Permiso">Permiso</cf_translate>'  
			when b.RHTcomportam = 5 then '<cf_translate key="LB_Incapacidad">Incapacidad</cf_translate>'  
			when b.RHTcomportam = 6 then '<cf_translate key="LB_Cambio">Cambio</cf_translate>'  
			when b.RHTcomportam = 7 then '<cf_translate key="LB_Anulacion">Anulaci&oacute;n</cf_translate>'  
			when b.RHTcomportam = 8 then '<cf_translate key="LB_Aumento">Aumento</cf_translate>'  
			when b.RHTcomportam = 9 then '<cf_translate key="LB_CambioDeEmpresa">Cambio de Empresa</cf_translate>'  
		end as Comportamiento,
		{fn concat(coalesce(ltrim(rtrim(c.RHPcodigoext)),ltrim(rtrim(c.RHPcodigo))),{fn concat(' - ',c.RHPdescpuesto)})} as Puesto,
		{fn concat(d.RHPcodigo,{fn concat(' - ',d.RHPdescripcion)})} as Plaza,		
		a.DLfvigencia as Fdesde,
		a.DLffin as Fhasta,
		a.DLfechaaplic as Faplica,
		a.DLobs as Observaciones,
		substring(a.DLobs,1,30) as Obsv
	from DatosEmpleado de, DLaboralesEmpleado a, RHTipoAccion b, RHPuestos c, RHPlazas d, TiposNomina e
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  <cfif #Form.RHTcomportam# NEQ 0>
		and b.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTcomportam#">
	  </cfif>
	  and a.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaI)#"> 
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaF)#">
	  <cfif isdefined ("form.CaridList")>
			and b.RHTid in( #form.CaridList#)
		</cfif>	
	  and a.DEid = de.DEid
	  and a.RHTid = b.RHTid
	  and a.Ecodigo = b.Ecodigo
	  and a.Ecodigo = c.Ecodigo
	  and a.RHPcodigo = c.RHPcodigo
	  and a.RHPid = d.RHPid
	  and a.Tcodigo = e.Tcodigo
	  and a.Ecodigo = e.Ecodigo
	order by de.DEidentificacion, Empleado, a.DLfvigencia, b.RHTcodigo, b.RHTcomportam
</cfquery>
<!---<cf_dump var="#rs#">--->

<cfif isdefined("url.imprimir")>
	<cfsavecontent variable="encabezado1">
		<cfoutput>
			<tr>
				<td colspan="8">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td>
							<cfinvoke key="LB_TiposDeAccionPorEmpresa" default="Tipos de Acci&oacute;n por Empresa" returnvariable="LB_TiposDeAccionPorEmpresa" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_Desde" default="Desde" returnvariable="LB_Desde" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_Hasta" default="Hasta" returnvariable="LB_Hasta" component="sif.Componentes.Translate"  method="Translate"/>
							<cf_EncReporte
								Titulo="#LB_TiposDeAccionPorEmpresa#"
								Color="##E3EDEF"
								filtro1="#LB_Desde#: #Url.fechaI#  #LB_Hasta#:#Url.fechaF#"	
							>	
						</td></tr>
					</table>
				</td>
			</tr>
		
		</cfoutput>
	</cfsavecontent>
	
	
	<cfsavecontent variable="encabezado2">
		<cfoutput>
			<tr><td width="6%" nowrap class="tituloListas"><cf_translate key="LB_Comportamiento">Comportamiento</cf_translate>:</td>
			<td><cfif #RHTcomportam# NEQ 0>#rs.Comportamiento#<cfelse><cf_translate key="LB_Todos">Todos</cf_translate></cfif></td></tr>
			<tr class="tituloListas">
				<td><cf_translate key="LB_Identificacion">Identificación</cf_translate></td>	
				<td><cf_translate key="LB_Empleado">Empleado</cf_translate></td>
				<td><cf_translate key="LB_Codigo">Código</cf_translate></td>
				<td><cf_translate key="LB_Accion">Acción</cf_translate></td>
				<td><cf_translate key="LB_FechaRige">Fecha Rige</cf_translate></td>																
				<td><cf_translate key="LB_FechaVence">Fecha Vence</cf_translate></td>								
				<td><cf_translate key="LB_FechaAplica">Fecha Aplica</cf_translate></td>	
			</tr>
		</cfoutput>
	</cfsavecontent>
</cfif>
	
	

	<cfif isdefined("url.imprimir")>
		<cfset MaxRows_rs = 100000>
	<cfelse>
		<cfset MaxRows_rs = 20>		
	</cfif>
	<cfset StartRow_rs    = Min( (PageNum_rs-1) * MaxRows_rs + 1, Max(rs.RecordCount, 1) )>
	<cfset StartRow_lista = StartRow_rs + (1-PageNum_rs) >
	<cfif StartRow_lista lte 1>
		<cfset StartRow_lista = 1>
	</cfif>
	
	<cfset EndRow_rs=Min(StartRow_rs+MaxRows_rs-1,rs.RecordCount)>
	<cfset TotalPages_rs=Ceiling(rs.RecordCount/MaxRows_rs)>

	<cfset QueryString_rs=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>

	<cfif Find("sel=1", QueryString_rs, 1 ) eq 0 >
		<cfset QueryString_rs = QueryString_rs & "&RHTcomportam=#form.RHTcomportam#&sel=1">
	</cfif>
	
	<cfif isdefined("form.regresar") and len(trim(form.regresar)) and Find("Regresar", QueryString_rs, 1 ) eq 0 >
		<cfset QueryString_rs = QueryString_rs & "&Regresar=#form.Regresar#" & "&o=#form.o#" >
	</cfif>
	<cfif isdefined("form.fechaI") and len(trim(form.fechaI)) and Find("fechaI", QueryString_rs, 1 ) eq 0 >
		<cfset QueryString_rs = QueryString_rs & "&fechaI=#form.fechaI#">
	</cfif>
	<cfif isdefined("form.fechaF") and len(trim(form.fechaF)) and Find("fechaF", QueryString_rs, 1 ) eq 0 >
		<cfset QueryString_rs = QueryString_rs & "&fechaF=#form.fechaF#">
	</cfif>

	<cfset tempPos=ListContainsNoCase(QueryString_rs,"PageNum_rs=","&")>
	<cfif tempPos NEQ 0>
		<cfset QueryString_rs=ListDeleteAt(QueryString_rs,tempPos,"&")>
	</cfif>
	<!--- fin --->
<cfif (rs.RecordCount GT 0)>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr > 
			<td> 
				<cfif isDefined("Form.RHTcomportam") and len(trim(Form.RHTcomportam)) gt 0>
					<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr bgcolor="#EEEEEE" style="padding: 3px;">
							<cfif not isdefined("url.imprimir")>
								
							<tr>
								<td colspan="8">
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr><td>
											<cfinvoke key="LB_TiposDeAccionPorEmpresa" default="Tipos de Acci&oacute;n por Empresa" returnvariable="LB_TiposDeAccionPorEmpresa" component="sif.Componentes.Translate"  method="Translate"/>
											<cfinvoke key="LB_Desde" default="Desde" returnvariable="LB_Desde" component="sif.Componentes.Translate"  method="Translate"/>
											<cfinvoke key="LB_Hasta" default="Hasta" returnvariable="LB_Hasta" component="sif.Componentes.Translate"  method="Translate"/>
											<cf_EncReporte
												Titulo="#LB_TiposDeAccionPorEmpresa#"
												Color="##E3EDEF"
												filtro1="#LB_Desde#: #Form.fechaI#  #LB_Hasta#:#Form.fechaF#"	
											>
										</td></tr>
									</table>
								</td>
							</tr>
						
							<tr class="tituloListas">
								<cfoutput>
									<td width="6%" nowrap><cf_translate key="LB_Comportamiento">Comportamiento</cf_translate>:</td>
									<td width="94%" nowrap>
										<input name="Comportamiento" id="Comportamiento" type="text" size="70" 
											   tabindex="-1" style="text-align: left" 
											   value="<cfif #RHTcomportam# NEQ 0>#rs.Comportamiento#<cfelse><cf_translate key='LB_Todos'>Todos</cf_translate></cfif>" 
											   class="cajasinbordeb" readonly="true">
									</td>
								</cfoutput>
							</tr>
						</cfif>
					<tr>
						<td colspan="2" align="center">
							<table width="100%" cellpadding="3" cellspacing="0">
								<cfif not isdefined("url.imprimir")>
									<tr class="tituloListas">
										<td><cf_translate key="LB_Identificacion">Identificación</cf_translate></td>	
										<td><cf_translate key="LB_Empleado">Empleado</cf_translate></td>
										<td><cf_translate key="LB_Codigo">Código</cf_translate></td>
										<td><cf_translate key="LB_Accion">Acción</cf_translate></td>
										<td><cf_translate key="LB_FechaRige">Fecha Rige</cf_translate></td>																
										<td><cf_translate key="LB_FechaVence">Fecha Vence</cf_translate></td>								
										<td><cf_translate key="LB_FechaAplica">Fecha Aplica</cf_translate></td>																	
									</tr>
								</cfif>
								<!--- Query para manejar resultados--->
								<cfset rsResultado = QueryNew("DEidentificacion,Empleado,RHTCodigo,RHTdesc,Fdesde,Fhasta,Faplica")>
								<cfset arreglo     = ArrayNew(1)>
								<cfset index = 0 >
								<cfset NumEmpleado = 0>
								
								<cfoutput query="rs" startrow="#StartRow_lista#" maxrows="#MaxRows_rs#">
									<cfif isdefined("url.imprimir")>
										<cfif currentRow mod 35 EQ 1>
											<cfif currentRow NEQ 1>
												<tr class="pageEnd"><td colspan="7">&nbsp;</td></tr>
											</cfif>
											#encabezado1#
											#encabezado2#
										</cfif>	
									</cfif>
									<cfset index = index + 1 >
									<tr class="<cfif rs.DEidentificacion NEQ NumEmpleado>listaNon<cfelse>listaPar</cfif>" 
										onClick="javascript:Invocar('#rs.DEid#','#rs.DLlinea#', '#rs.Faplica#', 
												'#rs.Fdesde#', '#rs.Fhasta#');" 
										style="cursor: pointer;">
										<cfif rs.DEidentificacion NEQ NumEmpleado>
											<td nowrap >												
													#rs.DEidentificacion#
											</td>
											<td nowrap >												
												#rs.nombrecorto#
											</td>
										<cfelse>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</cfif>
										<td nowrap >											
											#rs.RHTCodigo#
										</td>
										<td nowrap >											
											#rs.RHTdesc#
										</td>
										<td nowrap >											
											#LSDateFormat(rs.Fdesde,"dd/mm/yyyy")#
										</td>
										<td nowrap >											
											#LSDateFormat(rs.Fhasta,"dd/mm/yyyy")#
										</td>
										<td nowrap >											
											#LSDateFormat(rs.Faplica,"dd/mm/yyyy")#
										</td>
									</tr> 
									<cfset arreglo[index] = ArrayNew(1) >
									<cfset arreglo[index][1] = rs.DEidentificacion >
									<cfset arreglo[index][2] = rs.Empleado >
									<cfset arreglo[index][3] = rs.RHTCodigo >
									<cfset arreglo[index][4] = rs.RHTdesc >
									<cfset arreglo[index][5] = rs.Fdesde >
									<cfset arreglo[index][6] = rs.Fhasta >
									<cfset arreglo[index][7] = rs.Faplica >
									<cfset NumEmpleado = rs.DEidentificacion >
								</cfoutput>
								<cfloop from="#ArrayLen(arreglo)#" to="1" index="i" step="-1">
									<cfset fila = QueryAddRow(rsResultado, 1)>
									<cfset tmp  = QuerySetCell(rsResultado, "DEidentificacion",arreglo[i][1]) >
									<cfset tmp  = QuerySetCell(rsResultado, "Empleado",arreglo[i][2]) >
									<cfset tmp  = QuerySetCell(rsResultado, "RHTCodigo",arreglo[i][3]) >
									<cfset tmp  = QuerySetCell(rsResultado, "RHTdesc",arreglo[i][4] )>
									<cfset tmp  = QuerySetCell(rsResultado, "Fdesde", arreglo[i][5]) >
									<cfset tmp  = QuerySetCell(rsResultado, "Fhasta", arreglo[i][6]) >
									<cfset tmp  = QuerySetCell(rsResultado, "Faplica", arreglo[i][7]) >
								</cfloop>
								<cfif not isdefined("url.imprimir")>
									<cfoutput>
										<tr>
											<td align="center" colspan="6">
												<table width="50%" align="center">
													<tr>
														<td align="center">
															<cfif PageNum_rs GT 1>
																<a href="#CurrentPage#?PageNum_rs=1#QueryString_rs#">
																	<img src="/cfmx/rh/imagenes/First.gif" border=0>
																</a>
															</cfif>
															<cfif PageNum_rs GT 1>
																<a href="#CurrentPage#?
																		PageNum_rs=#Max(DecrementValue(PageNum_rs),1)##QueryString_rs#">
																	<img src="/cfmx/rh/imagenes/Previous.gif" border=0>
																</a>
															</cfif>
															<cfif PageNum_rs LT TotalPages_rs>
																<a href="#CurrentPage#?
																	PageNum_rs=#Min(IncrementValue(PageNum_rs),TotalPages_rs)
																	##QueryString_rs#">
																	<img src="/cfmx/rh/imagenes/Next.gif" border=0>
																</a>
															</cfif>
															<cfif PageNum_rs LT TotalPages_rs>
																<a href="#CurrentPage#?PageNum_rs=#TotalPages_rs##QueryString_rs#">
																	<img src="/cfmx/rh/imagenes/Last.gif" border=0>
																</a>
															</cfif>
														</td>
													</tr>
												</table>	
											</td>	
										</tr>
									</cfoutput>
								</cfif>
							</table>
						</td>
					</tr>
			<cfif isdefined("url.Imprimir") and url.Imprimir>
				<tr > 
					<td colspan="6" align="center">
						<strong>
							------------------------------
							<cf_translate key="LB_FinDelReporte">Fin del Reporte</cf_translate>
							--------------------------------------
						</strong>	&nbsp;
					</td>
				</tr>  
			</cfif> 
			</table>
		<cfelse>
			<p class="tituloAlterno"><cf_translate key="LB_DebeSeleccionarUnTipoDeAccion">Debe Seleccionar un Tipo de Acci&oacute;n</cf_translate>.</p>
		</cfif>
	  </td>
	</tr>
</table>
<cfelse>
	<p class="tituloAlterno">--- <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate>. ---</p>
</cfif>	