<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Consulta de Jerarqu&iacute;a de Centros Funcionales"
VSgrupo="103"
returnvariable="LB_nav__SPdescripcion"/>
			
<cfif isdefined("url.mostrar_subordinados")>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Jerarquia"
		Default="Consulta de Estructura Organizacional: empleados por Centro Funcional"	
		xmlfile="/rh/nomina/consultas/jerarquia_cf-filtro.xml"
		returnvariable="vTitulo"/>	
<cfelse>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Estructura_Organizacional"
		Default="Consulta de Estructura Organizacional"	
		xmlfile="/rh/nomina/consultas/jerarquia_cf-filtro.xml"
		returnvariable="vTitulo"/>	
</cfif>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Oficina"
	Default="Oficina"	
	xmlfile="/rh/generales.xml"
	returnvariable="vOficina"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Dept"
	Default="Dept."	
	xmlfile="/rh/generales.xml"
	returnvariable="vDept"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Responsable"
	Default="Resp."	
	xmlfile="/rh/nomina/consultas/jerarquia_cf-filtro.xml"
	returnvariable="vresp"/>	

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start border="true" titulo="#vTitulo#" skin="#Session.Preferences.Skin#">
	 <cf_htmlreportsheaders
				title="#vTitulo#" 
				download="false"
				filename="ConsultaEstructuraOrg#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
				ira="jerarquia_cf-filtro.cfm"
	>

	<style type="text/css">
		div#nifty{	width: 15em;
					padding: 15px  0;
					margin:0 auto;
					text-align:left;
					background: #9CC0FF url(gradient.png) repeat-x 0 -5px }
	</style>

	<!--- Nifty Corners: incluir css y js --->
	<link rel="stylesheet" type="text/css" href="/cfmx/commons/js/niftyCorners.css">
	<script type="text/javascript" src="/cfmx/commons/js/nifty.js"></script>

		<cfquery name="data_padre" datasource="#session.DSN#">
			select CFid, ts_rversion
			from CFuncional
			where CFnivel = 0
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfparam name="url.CFidresp" default="#data_padre.CFid#">
		<cfif not len(trim(url.CFidresp)) >
			<cfset url.CFidresp = data_padre.CFid >
		</cfif>

		<!---<cfparam name="url.mostrar_desc_cf" 	 		 default="false">--->
		<cfset parametros = ''>
		<cfif isdefined("url.mostrar_desc_cf")><cfset parametros = parametros & '&mostrar_desc_cf=true'></cfif>
		<cfif isdefined("url.mostrar_responsable")><cfset parametros = parametros & '&mostrar_responsable=true'></cfif>
		<cfif isdefined("url.mostrar_foto_resp")><cfset parametros = parametros & '&mostrar_foto_resp=true'></cfif>
		<cfif isdefined("url.mostrar_oficina")><cfset parametros = parametros & '&mostrar_oficina=true'></cfif>
		<cfif isdefined("url.mostrar_departamento")><cfset parametros = parametros & '&mostrar_departamento=true'></cfif>				

		<cfif isdefined("url.mostrar_subordinados")>
			<cfset parametros = parametros & '&mostrar_subordinados=true'>
			<cfset url.mostrar_subordinados_control = true >
		<cfelse>
			<cfset url.mostrar_subordinados_control = false >
		</cfif>

		<cfparam name="url.mostrar_dependientes" 		 default="false"> <!--- control: muestra todos los centros funcionales o muiestra solo los que tienen dependencias --->		
		<!---<cfset parametros = "&mostrar_desc_cf=#url.mostrar_desc_cf#&mostrar_responsable=#url.mostrar_responsable#&mostrar_foto_resp=#url.mostrar_foto_resp#&mostrar_dependientes=#url.mostrar_dependientes#" >--->

		<!--- query inicial --->
		<cfif not isdefined("url.mostrar_subordinados") >
			<cfquery name="data" datasource="#session.DSN#" >
				select 	a.CFid,
						a.CFcodigo, 
						a.CFdescripcion, 
						a.CFpath, 
						a.CFnivel, 
						a.CFidresp, 
						a.CFcuentac,
						a.CFuresponsable,
						( select count(1) 
						  from CFuncional
						  where CFidresp =  a.CFid ) as dependientes,
						( select lt.DEid
						  from RHPlazas p, LineaTiempo lt
						  where p.RHPid= a.RHPid
							and lt.RHPid=p.RHPid
							and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta ) as responsable,
						0 as plaza_responsable,

						(	select count(1)
							from LineaTiempo lt, RHPlazas p, CFuncional cf
							
							where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta
							  and p.RHPid=lt.RHPid
							  and  cf.CFid=p.CFid
							  and cf.CFid = a.CFid ) as subordinados,
						o.Oficodigo,
						o.Odescripcion,	
						d.Deptocodigo,
						d.Ddescripcion	
				from CFuncional a
				
				inner join Oficinas o
				on o.Ecodigo = a.Ecodigo
				and o.Ocodigo = a.Ocodigo

				inner join Departamentos d
				on d.Ecodigo = a.Ecodigo
				and d.Dcodigo = a.Dcodigo
				
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ( a.CFidresp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFidresp#"> or a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFidresp#"> )
	
				<!---
				<cfif not url.mostrar_dependientes >
					having 	( select count(1) 
							  from CFuncional 
							  where CFidresp =  a.CFid ) > 0
				</cfif>		  
				--->
				order by a.CFpath 
			</cfquery>
		<cfelse>
			<cf_dbtemp name="RHCFJerarquia" returnvariable="RHCFJerarquia">
				<cf_dbtempcol name="CFid" 				type="numeric" 		 mandatory="no">
				<cf_dbtempcol name="CFcodigo" 			type="varchar(10)"	 mandatory="no"> 
				<cf_dbtempcol name="CFdescripcion" 		type="varchar(60)"	 mandatory="no">  
				<cf_dbtempcol name="CFpath" 			type="varchar(255)"	 mandatory="no">  
				<cf_dbtempcol name="CFnivel" 			type="integer"	 	 mandatory="no">  
				<cf_dbtempcol name="CFidresp" 			type="numeric" 		 mandatory="no"> 
				<cf_dbtempcol name="CFuresponsable"		type="numeric" 		 mandatory="no"> 
				<cf_dbtempcol name="dependientes"		type="integer" 		 mandatory="no"> 
				<cf_dbtempcol name="responsable"		type="numeric" 		 mandatory="no"> 
				<cf_dbtempcol name="plaza_responsable"	type="numeric" 		 mandatory="no"> 
				<cf_dbtempcol name="DEidentificacion"	type="varchar(60)"	 mandatory="no"> 
				<cf_dbtempcol name="nombre"				type="varchar(255)"	 mandatory="no"> 
				<cf_dbtempcol name="subordinados"		type="integer"	 	 mandatory="no"> 
				<cf_dbtempcol name="Oficodigo" 			type="varchar(10)"	 mandatory="no"> 
				<cf_dbtempcol name="Odescripcion" 		type="varchar(60)"	 mandatory="no">  
				<cf_dbtempcol name="Deptocodigo"		type="varchar(10)"	 mandatory="no"> 
				<cf_dbtempcol name="Ddescripcion" 		type="varchar(60)"	 mandatory="no">
				<cf_dbtempcol name="CFcuentac" 		    type="varchar(60)"	 mandatory="no">  
			</cf_dbtemp>
		
			<cfquery datasource="#session.DSN#" >
				insert into #RHCFJerarquia#(CFid, CFcodigo, CFdescripcion, CFpath, CFnivel, CFidresp, CFuresponsable, dependientes, DEidentificacion, responsable, 
				nombre, plaza_responsable, subordinados, Oficodigo, Odescripcion, Deptocodigo, Ddescripcion,CFcuentac) 
				select 	p.CFid,
						cf.CFcodigo,
						cf.CFdescripcion,
						cf.CFpath,
						cf.CFnivel,
						cf.CFidresp,
						cf.CFuresponsable,
						0 as dependientes,
						de.DEidentificacion,
						lt.DEid,
						<cf_dbfunction name="concat" args="de.DEapellido1, ' ', de.DEapellido2 ,' ',de.DEnombre" > as nombre,
						(case when cf.RHPid = p.RHPid then cf.RHPid else 0 end ) as plaza_responsable,
						0,
						o.Oficodigo,
						o.Odescripcion,	
						d.Deptocodigo,
						d.Ddescripcion,
						cf.CFcuentac
				from LineaTiempo lt
				
				inner join RHPlazas p
				on p.RHPid=lt.RHPid
				
				inner join CFuncional cf
				on (cf.CFid=p.CFid or cf.RHPid=p.RHPid)
				and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFidresp#">
				
				inner join Oficinas o
				on o.Ecodigo = cf.Ecodigo
				and o.Ocodigo = cf.Ocodigo

				inner join Departamentos d
				on d.Ecodigo = cf.Ecodigo
				and d.Dcodigo = cf.Dcodigo
				
				inner join DatosEmpleado de
				on lt.DEid=de.DEid
				
				where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta
			</cfquery>
			
			<cfquery name="rs_responsable" datasource="#session.DSN#">
				select max(plaza_responsable) as plaza_responsable
				from #RHCFJerarquia#
			</cfquery>
			<cfif rs_responsable.recordcount gt 0 and rs_responsable.plaza_responsable lte 0>
				<cfquery datasource="#session.DSN#">
					insert into #RHCFJerarquia#(CFid, CFcodigo, CFdescripcion, CFpath, CFnivel, CFidresp, CFuresponsable, dependientes, DEidentificacion, nombre, plaza_responsable, Oficodigo, Odescripcion, Deptocodigo, Ddescripcion) 
					select CFid, CFcodigo, CFdescripcion, CFpath, CFnivel, CFidresp, CFuresponsable, dependientes, DEidentificacion, nombre, 1, Oficodigo, Odescripcion, Deptocodigo, Ddescripcion
					from #RHCFJerarquia#
					where DEidentificacion = (select min(DEidentificacion) from #RHCFJerarquia#)
				</cfquery>
			</cfif>
			<cfquery name="data" datasource="#session.DSN#" >
				select CFid, CFcodigo,CFcuentac, CFdescripcion, CFpath, CFnivel, CFidresp, CFuresponsable, dependientes, responsable, plaza_responsable, DEidentificacion, nombre, subordinados, Oficodigo, Odescripcion, Deptocodigo, Ddescripcion	
				from #RHCFJerarquia#
				order by plaza_responsable desc, DEidentificacion
			</cfquery>
		</cfif>
		
		<cfset cuantos_registros = data.recordcount - 1 >
		<cfset cuantas_filas = ceiling(cuantos_registros/4) >
		<cfset centros_por_fila = arraynew(1) >
		<cfset contador = cuantos_registros >
		<cfset fila_actual = 1 >
		
		<cfloop from="1" to="#cuantas_filas#" index="i">
			<cfif contador gt 4 >
				<cfset centros_por_fila[i] = 4 >
			<cfelse>
				<cfset centros_por_fila[i] = contador >
			</cfif>
			<cfset contador = contador - 4 >
		</cfloop>
		
		<cfset contador = 0 > <!--- igual a cero para no contar el primer registro --->
		<cfset fila_actual = 0 > <!--- fila donde estoy --->
		<cfset fila_anterior = 0 > <!--- control de cierre de fila  --->
		<cfset hay_fila_abierta = false > <!--- control de cierre de fila  --->
		
		<br />
		<div align="center">
			<table border="0" width="790" cellspacing="0" cellpadding="0">
				<cfoutput query="data" >
				
					<style type="text/css">
						div##nifty#data.currentrow#{	width: 15em;
														padding: 15px  0;
														margin:0 auto;
														text-align:left;
														background: ##9CC0FF url(gradient.png) repeat-x 0 -5px }
					</style>
				
				
				
					<!--- raiz --->
					<cfif data.currentrow eq 1 or mostrar_subordinados_control >
						<cfset mostrar_subordinados_control = false >
						<tr>
							<td width='12%' style='line-height: 10px'></td>
							<td width='12%' style='line-height: 10px'></td>
							<td width='12%' style='line-height: 10px'></td>
							<td width='12%' colspan='2' style='line-height: 10px' valign='top'>
								<div align="center" id="nifty">
									&nbsp;
									<center>
									<!---<table id="tabla_#data.currentrow#" width="180" height="40" style="background-color: ##E3EDEF; border: 3px outset; border-top-color:##0033FF; border-left-color:##0033FF; border-bottom-color:##0033FF; border-right-color:##0033FF " cellspacing="0" cellpadding="2">--->
									<!---<table id="tabla_#data.currentrow#" width="180" height="40" style="background-color: ##BBD8FF; " cellspacing="0" cellpadding="2">--->
										<cfif data.CFnivel gt 0 >
											<!---<tr>--->
												<cfif data.dependientes gt 0 or isdefined("url.mostrar_subordinados") >
													<cfset _parametros = parametros >
													<cfif isdefined("url.mostrar_subordinados")>
														<cfset index = findnocase('&mostrar_subordinados', parametros, 1) >
														<cfif index gt 0 ><cfset _parametros = mid(parametros, 1, index-1 ) ></cfif>
													</cfif>
													<!---<td align="center" height="9px">---><a href="jerarquia_cf.cfm?CFidresp=#data.CFidresp##_parametros#"><img border="0" src="/cfmx/rh/imagenes/arriba.gif"></a><!---</td>--->
												</cfif>
											<!---</tr>--->
										</cfif>	

										<!---<tr>
											<td width="100%" align="center" style="padding-bottom:0;">--->
												<font color="##303F6E" style="font-size:12px;"><strong>#data.CFcodigo#</strong></font>
											<!---</td>
										</tr>--->
										<cfif isdefined("url.mostrar_desc_cf")>
											<!---<tr><td align="center" style="padding-top:0;" >---><br /><font color="##303F6E" style="font-size:10px;" ><label title="#data.CFdescripcion#" style=" font-style:normal; font-weight:normal; font-size:10px;">#data.CFdescripcion#</label></font><!---</td></tr>--->
										</cfif>
	
										<cfif data.CFnivel gt 0 >
											<cfset id_responsable = data.responsable >
											<cfif len(trim(data.responsable)) eq 0>
												<cfset id_responsable = 0 >
											</cfif>

											<cfif isdefined("url.mostrar_oficina") >
												<!---<tr>
													<td width="100%" align="left" colspan="2" style="padding-bottom:0px;" >--->
														<br /><div><label title="#data.Oficodigo# - #data.Odescripcion#" style="font-style:normal; font-weight:normal;"><font color="##303F6E" style="font-size:9px;">#vOficina#:&nbsp;#data.Oficodigo# - </font><font color="##303F6E"><label title="#data.Oficodigo# - #data.Odescripcion#" style="font-size:9px; text-transform:capitalize; font-style:normal; font-weight:normal; color:"##303F6E"; ">#lcase(data.Odescripcion)#</label></font></label></div>
													<!---</td>
												</tr>--->
											</cfif>
											
											<cfif isdefined("url.mostrar_departamento") >
												<!---<tr>
													<td width="100%" align="left" colspan="2" style="padding-bottom:0px;" >--->
														<br /><label title="#data.Deptocodigo# - #data.Ddescripcion#" style="font-style:normal; font-weight:normal;"><font color="##303F6E" style="font-size:9px;" >#vDept#:&nbsp;#data.Deptocodigo# - </font><font color="##303F6E" style="font-size:9px; text-transform:capitalize " >#lcase(data.Ddescripcion)#</font></label>
													<!---</td>
												</tr>--->
											</cfif>
											
											<!---***Verifica si tiene que mostrar la cuenta contable del centro funcional para los padres***--->
											<cfquery name="rsVerif" datasource="#session.dsn#">
												select Pvalor from RHParametros where Pcodigo=2105
											</cfquery>
											<cfif rsVerif.Pvalor gt 0>
												<!---<tr>
												<td>--->
													<br /><label title="#data.CFcuentac#" style="font-style:normal; font-weight:normal;"><font color="##303F6E" style="font-size:9px;" >CC:</font><font color="##303F6E" style="font-size:9px; text-transform:capitalize " >
													<cfif len(trim(data.CFcuentac)) gt 20>#mid(lcase(data.CFcuentac),1,20)#...
													<cfelseif len(trim(data.CFcuentac)) lte 20 and len(trim(data.CFcuentac)) gt 0>#lcase(data.CFcuentac)#
													<cfelseif len(trim(data.CFcuentac)) eq 0>N/A</cfif></font></label>
												<!---</td>
												</tr>--->
												</cfif>
											<cfquery name="rs_foto" datasource="#session.DSN#">
												select DEnombre, DEapellido1, DEapellido2, foto 
												from DatosEmpleado de
												left join RHImagenEmpleado ie
												on ie.DEid=de.DEid
												where de.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#id_responsable#">
											</cfquery>
												<cfif isdefined("url.mostrar_responsable") or isdefined("url.mostrar_subordinados") >
														<br /><!---<tr><td align="left" style="padding-bottom:0px;">---><label title="#rs_foto.DEapellido1# #rs_foto.DEapellido2# #rs_foto.DEnombre#" style="font-style:normal; font-weight:normal;"><font color="##303F6E" style="font-size:9px;">#vResp#: </font><cfif rs_foto.recordcount gt 0 ><font color="##303F6E" style="font-size:9px; text-transform:capitalize">#lcase(rs_foto.DEapellido1)# #lcase(rs_foto.DEapellido2)# #lcase(rs_foto.DEnombre)#</font><cfelse><font color="##303F6E" style="font-size:9px; text-transform:capitalize">N/A</font></cfif></label><!---</td></tr>--->
												</cfif>

											<cfif isdefined("url.mostrar_foto_resp") and isdefined("rs_foto")>
												<br />
												<!---<tr>
													<td align="center">--->
														<cfif Len(rs_foto.foto) GT 1>
															<cfinvoke 
															 component="sif.Componentes.DButils"
															 method="toTimeStamp"
															 returnvariable="tsurl">
																<cfinvokeargument name="arTimeStamp" value="#data_padre.ts_rversion#"/>
															</cfinvoke>
															<img src="foto_responsable.cfm?s=#URLEncodedFormat(data.responsable)#&amp;ts=#tsurl#" border="0" width="55" height="73"><br>
														<cfelse>
															<img src="/cfmx/rh/imagenes/UserIcon.png" border="0" width="55" height="73"><br>
														</cfif>
													<!---</td>
												</tr>--->
												<!---<tr><td>&nbsp;</td></tr>--->
											</cfif>
										</cfif>
										
									<!---</table>--->
									</center>
									&nbsp;
								</div>
							</td>
							<td width='12%' style='line-height: 10px'></td>
							<td width='12%' style='line-height: 10px'></td>
							<td width='12%' style='line-height: 10px'></td>
						</tr>
					</cfif>
					
					<cfset fila_actual = ceiling(contador/4) >
					<cfif fila_actual neq fila_anterior>
						<tr>
							<!--- este va siempre es la salida de la cajita padre --->
							<td width='12%' style='line-height: 10px'>&nbsp;</td>
							<td width='12%' style='line-height: 10px'>&nbsp;</td>
							<td width='12%' style='line-height: 10px'>&nbsp;</td>
							<td width='12%' style='line-height: 10px; border-right: 1px solid rgb(48, 63,110)'>&nbsp;</td>
							<td width='12%' style='line-height: 10px; border-left: 1px solid rgb(48, 63,110)'>&nbsp;</td>
							<td width='12%' style='line-height: 10px'>&nbsp;</td>
							<td width='12%' style='line-height: 10px'>&nbsp;</td>
							<td width='12%' style='line-height: 10px'>&nbsp;</td>
						</tr>
						<tr>
							<!--- inicio --->
							<cfloop from="1" to="#4-centros_por_fila[fila_actual]#" index="i">
								<td width='12%' style='line-height: 10px; '>&nbsp;</td>				
							</cfloop>

									<cfif centros_por_fila[fila_actual] eq 1 >
										<td width='12%' style='line-height: 10px; border-right: 1px solid rgb(48, 63,110)'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-left: 1px solid rgb(48, 63,110)'>&nbsp;</td>
									</cfif>
		
									<cfif centros_por_fila[fila_actual] eq 2 >
										<td width='12%' style='line-height: 10px; border-right: 1px solid rgb(48, 63,110)'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-left: 1px solid rgb(48, 63,110); border-top: 2px solid rgb(48, 63,110)'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-right: 1px solid rgb(48, 63,110); border-top: 2px solid rgb(48, 63,110)'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-left: 1px solid rgb(48, 63,110)'>&nbsp;</td>
									</cfif>
		
									<cfif centros_por_fila[fila_actual] eq 3 >
										<td width='12%' style='line-height: 10px; border-right: 1px solid rgb(48, 63,110)'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-left: 1px solid rgb(48, 63,110); border-top: 2px solid rgb(48, 63,110)'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-right: 1px solid rgb(48, 63,110); border-top: 2px solid rgb(48, 63,110)'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-left: 1px solid rgb(48, 63,110); border-top: 2px solid rgb(48, 63,110)'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-right: 1px solid rgb(48, 63,110); border-top: 2px solid rgb(48, 63,110)'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-left: 1px solid rgb(48, 63,110)'>&nbsp;</td>
									</cfif>
									<cfif centros_por_fila[fila_actual] eq 4 >
										<td width='12%' style='line-height: 10px; border-right: 1px solid rgb(48, 63,110)'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-left: 1px solid rgb(48, 63,110); border-top: 2px solid rgb(48, 63,110)'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-right: 1px solid rgb(48, 63,110); border-top: 2px solid rgb(48, 63,110)'>&nbsp;</td>
											<td width='12%' style='line-height: 10px; border-left: 1px solid rgb(48, 63,110); border-top: 2px solid rgb(48, 63,110); <cfif arraylen(centros_por_fila) gt fila_actual>border-right: 1px solid rgb(48, 63,110)</cfif>'>&nbsp;</td>
											<td width='12%' style='line-height: 10px; border-right: 1px solid rgb(48, 63,110); border-top: 2px solid rgb(48, 63,110); <cfif arraylen(centros_por_fila) gt fila_actual>border-left: 1px solid rgb(48, 63,110)</cfif>'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-left: 1px solid rgb(48, 63,110); border-top: 2px solid rgb(48, 63,110)'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-right: 1px solid rgb(48, 63,110); border-top: 2px solid rgb(48, 63,110)'>&nbsp;</td>
										<td width='12%' style='line-height: 10px; border-left: 1px solid rgb(48, 63,110)'>&nbsp;</td>
									</cfif>

							<!--- fin --->
							<cfloop from="1" to="#4-centros_por_fila[fila_actual]#" index="i">
								<td width='12%' style='line-height: 10px; '>&nbsp;</td>				
							</cfloop>
						</tr>
						<!--- cierra las filas abiertas si las hay --->
						<cfif hay_fila_abierta >
							</tr>
						</cfif>
						<tr>
						<cfset hay_fila_abierta = true >
						<cfset ya_pinto = false >
					</cfif>
					<cfif data.currentrow gt 1 >
						<cfif not ya_pinto >
							<!--- inicio --->
							<cfloop from="1" to="#4-centros_por_fila[fila_actual]#" index="i">
								<td width='12%' style='line-height: 10px; '>&nbsp;</td>				
							</cfloop>
							<cfset ya_pinto = true >
						</cfif>
						<td width='12%' colspan='2' 
							<cfif centros_por_fila[fila_actual] eq 4 and arraylen(centros_por_fila) gt fila_actual >
								<cfif (data.currentrow-1) mod 4 eq 2 >
									style='line-height: 10px; border-right: 1px solid rgb(48, 63,110)'
								<cfelseif (data.currentrow-1) mod 4 eq 3 >
									style='line-height: 10px; border-left: 1px solid rgb(48, 63,110)'
								</cfif>
							</cfif>
							valign='top'>
							<div align="center" id="nifty#data.currentrow#">
							<center>
								<!---<table id="tabla_#data.currentrow#" border="0" width="175" cellpadding="2" height="30" style="background-color: ##E3EDEF; border: 3px outset; border-top-color:##0033FF; border-left-color:##0033FF; border-bottom-color:##0033FF; border-right-color:##0033FF " cellspacing="0" >--->
								<!---<table id="tabla_#data.currentrow#" border="0" width="175" cellpadding="2" height="30" style="background-color: ##BBD8FF;" cellspacing="0" >--->
								<table cellpadding="2" border="0" width="100%" >
									<tr>
										<td width="100%" align="center" colspan="2" style="padding-bottom:0;">
											<font color="##303F6E" style="font-size:12px;"  ><strong><cfif isdefined("url.mostrar_subordinados")>#data.DEidentificacion#<cfelse>#data.CFcodigo#</cfif></strong></font>
										</td>
									</tr>

									<cfif isdefined("url.mostrar_subordinados")>
										<tr><td colspan="2" align="center" style="padding-bottom:0;"><font color="##303F6E" style="font-size:9px; text-transform:capitalize;">#lcase(data.nombre)#</font></td></tr>
									<cfelse>
										<cfif isdefined("url.mostrar_desc_cf")>
											<tr><td colspan="2" align="center" style="padding-top:0;" ><label title="#data.CFdescripcion#" style="font-style:normal; font-weight:normal;"><font color="##303F6E" style="font-size:10px; text-transform:capitalize;" ><cfif len(trim(data.CFdescripcion)) gt 20>#mid(lcase(data.CFdescripcion),1,20)#...<cfelse>#lcase(data.CFdescripcion)#</cfif></font></label></td></tr>
										</cfif>
									</cfif>

									<cfif not isdefined("url.mostrar_subordinados") and isdefined("url.mostrar_oficina") >
										<tr>
											<td width="100%" align="left" colspan="2" style="padding-bottom:0px;" >
												<label title="#trim(data.Oficodigo)#-#data.Odescripcion#" style="font-style:normal; font-weight:normal;"><font color="##303F6E" style="font-size:9px;">#vOficina#:&nbsp;#trim(data.Oficodigo)# - </font><font color="##303F6E" style="font-size:9px; text-transform:capitalize;"><cfif len(trim(data.Odescripcion)) gt 13 >#mid(lcase(data.Odescripcion), 1, 13)#...<cfelse>#lcase(data.Odescripcion)#</cfif></font></label>
											</td>
										</tr>
									</cfif>
									<cfif not isdefined("url.mostrar_subordinados") and isdefined("url.mostrar_departamento") >
										<tr>
											<td width="100%" align="left" colspan="2" style="padding-bottom:0px;" >
												<label title="#trim(data.Deptocodigo)#-#data.Ddescripcion#" style="font-style:normal; font-weight:normal;"><font color="##303F6E" style="font-size:9px;" >#vDept#:&nbsp;#data.Deptocodigo# - </font><font color="##303F6E" style="font-size:9px; text-transform:capitalize;"><cfif len(trim(data.Ddescripcion)) gt 13 >#mid(lcase(data.Ddescripcion), 1, 13)#...<cfelse>#lcase(data.Ddescripcion)#</cfif></font></label>
											</td>
										</tr>
									</cfif>

									<cfset id_responsable = data.responsable >
									<cfif len(trim(data.responsable)) eq 0>
										<cfset id_responsable = 0 >
									</cfif>
									<cfquery name="rs_foto" datasource="#session.DSN#">
										select DEnombre, DEapellido1, DEapellido2, foto 
										from DatosEmpleado de
										left join RHImagenEmpleado ie
										on ie.DEid=de.DEid
										where de.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#id_responsable#">
									</cfquery>
									
									<cfif isdefined("url.mostrar_responsable") and isdefined("rs_foto") and not isdefined("url.mostrar_subordinados")>
										<!---<cfif rs_foto.recordcount gt 0 >--->
											<cfset vNombre = trim(lcase(rs_foto.DEapellido1)) & ' '&trim(lcase(rs_foto.DEapellido2)) & ' '& trim(lcase(rs_foto.DEnombre)) >
											<tr>
												<td width="100%" align="left" colspan="2" style="padding-bottom:0px;" >
													<label title="#trim(rs_foto.DEapellido1) & ' '&trim(rs_foto.DEapellido2) & ' '& trim(rs_foto.DEnombre)#" style="font-style:normal; font-weight:normal;"><font color="##303F6E"style="font-size:9px;">#vResp#: </font><font color="##303F6E" style="font-size:9px; text-transform:capitalize;"><cfif len(trim(vNombre)) gt 0><cfif len(trim(vNombre)) gt 20>#mid(vNombre, 1, 20)#...<cfelse>#vNombre#</cfif><cfelse><font color="##303F6E" style="font-size:9px; text-transform:capitalize;">N/A</font></cfif></font></label>
												</td>
											</tr>
										<!---</cfif>--->
									</cfif>
									<!---***Verifica si tiene que mostrar la cuenta contable del centro funcional para los hijos***--->
									<cfquery name="rsVerif" datasource="#session.dsn#">
										select Pvalor from RHParametros where Pcodigo=2105
									</cfquery>
									<cfif rsVerif.Pvalor gt 0>
										<tr>
											<td>
												<br /><label title="#data.CFcuentac#" style="font-style:normal; font-weight:normal;"><font color="##303F6E" style="font-size:9px;" >Cta:</font><font color="##303F6E" style="font-size:9px; text-transform:capitalize " >
												<cfif len(trim(data.CFcuentac)) gt 20>#mid(lcase(data.CFcuentac),1,20)#...
												<cfelseif len(trim(data.CFcuentac)) lte 20 and len(trim(data.CFcuentac)) gt 0>#lcase(data.CFcuentac)#
												<cfelseif len(trim(data.CFcuentac)) eq 0>N/A</cfif></font></label>
											</td>
										</tr>
									</cfif>
									<cfif isdefined("url.mostrar_foto_resp") and isdefined("rs_foto") >
										<br />
										<tr>
											<td align="center" colspan="2">
												<cfif Len(rs_foto.foto) GT 1>
													<cfinvoke 
													 component="sif.Componentes.DButils"
													 method="toTimeStamp"
													 returnvariable="tsurl">
														<cfinvokeargument name="arTimeStamp" value="#data_padre.ts_rversion#"/>
													</cfinvoke>
													<img src="foto_responsable.cfm?s=#URLEncodedFormat(data.responsable)#&amp;ts=#tsurl#" border="0" width="55" height="73"><br>
												<cfelse>
													<img src="/cfmx/rh/imagenes/UserIcon.png" border="0" width="55" height="73"><br>
												</cfif>
											</td>
										</tr>
									</cfif>
									<cfif not isdefined("url.mostrar_subordinados") >
										<tr>
											<td>
												<table width="60%" border="0" cellpadding="4" cellspacing="0" align="center">
													<tr>
														<cfif data.dependientes gt 0>
															<td align="center" width="50%" height="9px" ><a href="jerarquia_cf.cfm?CFidresp=#data.CFid##parametros#"><img title="Consultar Centros Funcionales subordinados a este centro funcional" border="0" src="/cfmx/rh/imagenes/abajo.gif"></a></td>
														<cfelse>
															<!--- se pone la imagen para hacer las cajitas de igual tamaño --->		
															<td width="50%" align="center" height="9px"><img border="0" src="/cfmx/rh/imagenes/abajo_gray.gif"></td>
														</cfif>
														<cfif data.subordinados gt 0>
															<td width="50%" align="center" height="9px" ><a href="jerarquia_cf.cfm?CFidresp=#data.CFid#&mostrar_subordinados=true#parametros#"><img title="Consultar empleados subordinados a este centro funcional" border="0" src="/cfmx/rh/imagenes/users.gif" width="20" height="15"></a></td>
														<cfelse>
															<td width="50%" align="center" height="9px" ><img border="0" src="/cfmx/rh/imagenes/users-gray.gif" width="20" height="15"></td>
														</cfif>														
													</tr>
												</table>
											</td>
										</tr>
									</cfif>
									
									</table>	
								<!---</table>--->
								
							</center>
							</div>
						</td>
					</cfif>
					
					<!--- si llegamos al ultimo registro cerramos la fila --->
					<cfif data.currentrow eq cuantos_registros+1 and hay_fila_abierta >
						</tr>	
					</cfif> 
					<cfset contador = contador + 1 >
					<cfset fila_anterior = fila_actual >
					<script type="text/javascript">
						if(NiftyCheck())
						{
							Rounded("div##nifty#data.currentrow#",	"all",		"##FFF","transparent","smooth");
						}
					</script>
				</cfoutput>
			</Table>
		</div>
		<br />
		
	<script type="text/javascript">
		if(NiftyCheck())
		{
			Rounded("div#nifty",	"all",		"#FFF","transparent","smooth");
		}
	</script>
		
	<cf_web_portlet_end>
<cf_templatefooter>