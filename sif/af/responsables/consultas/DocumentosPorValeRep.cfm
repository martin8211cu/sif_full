<!--- <cfset registrosxcontext = 500> --->
<CFSET MAXROWSALLOWED = 10000>

<!--- Datos de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- Recorre los Hijos del Centro Funcional --->
<cfset lstHijos = "-1">
<cfif isDefined("form.IncluyeHijo") and len(trim(form.IncluyeHijo))>
	<cfif isDefined("form.CFidIni") and len(trim(form.CFidIni))>
		<!--- Obtiene la Ruta de Identificación del Nodo --->
		<cfquery name="rsCFPath" datasource="#session.DSN#">
			select CFpath as path
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidIni#">	  
		</cfquery>
		
		<!--- Obtiene todos los Nodos que pertenezcan a la ruta del Padre --->
		<cfif #rsCFPath.recordCount# gt 0>
			<cfquery name="rsCFHijos" datasource="#session.DSN#">
				select CFid
				from CFuncional
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and upper(CFpath) like '#rsCFPath.path#%'	  
				order by CFpath
			</cfquery>
			<cfset arrHijos = ArrayNew(1)>
			<cfloop query="rsCFHijos">
				<cfset temp = ArrayAppend(arrHijos,#rsCFHijos.CFid#)>
			</cfloop>
			<cfset lstHijos = ArrayToList(arrHijos)>						
		</cfif>
	</cfif>
</cfif>

<cfquery name="rsReporteCount1" datasource="#session.DSN#">
	select count(1) AS recordcountdb
	from AFResponsables B
		inner join Activos C 
			ON C.Ecodigo = B.Ecodigo 
			AND C.Aid = B.Aid
			<!--- Rango de Placas --->
			<cfif isdefined("form.APlacaIni") and len(trim(form.APlacaIni))>
				and C.Aplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.APlacaIni#">
			</cfif>
							
	where B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

	<!--- Vale --->
	<cfif isdefined("form.TipoVale") and len(trim(form.TipoVale))>
		<cfif TipoVale neq -1>
			and B.CRTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoVale#">
		</cfif>
	</cfif>	

	<!--- Recorre los Centros Funcionales Hijos del Seleccionado --->	
	<cfif isDefined("form.IncluyeHijo") and len(trim(form.IncluyeHijo))>
		and B.CFid in (#lstHijos#)
	<cfelse>
		<!--- Modo Normal por Rangos --->	
		<cfif isdefined("form.CFidIni") and len(trim(form.CFidIni))>
			and B.CFid >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidIni#">
		</cfif>
		<cfif isdefined("form.CFidFin") and len(trim(form.CFidFin))>
			and B.CFid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidFin#">
		</cfif>		
	</cfif>

	<!--- Estado --->
	<cfif isdefined("form.estado") and len(trim(form.estado))>
		<cfif (form.estado eq "A") or (form.estado eq "A,T")>
			and (<cf_dbfunction name="now"> >= B.AFRfini and <cf_dbfunction name="now"> <= B.AFRffin)
		<cfelseif form.estado eq "I">
			and <cf_dbfunction name="now"> > B.AFRffin		
		</cfif>
	</cfif>	
	and B.DEid is not null
	and B.CRCCid is not null
	and B.CFid is not null
	and C.ACcodigo is not null
	and C.ACid is not null 
</cfquery>

<cfif rsReporteCount1.recordcountdb gt MAXROWSALLOWED>
	<cf_errorCode	code = "50123"
					msg  = "El reporte no puede ser procesado. El reporte con los filtros definidos devuelve @errorDat_1@, mas de los @errorDat_2@ registros permitidos, Proceso Cancelado!"
					errorDat_1="#rsReporteCount1.recordcountdb#"
					errorDat_2="#MAXROWSALLOWED#"
	>
</cfif>

<cfquery name="rsReporteCount2" datasource="#session.DSN#">
	select count(1) as recordcountdb
	from CRDocumentoResponsabilidad B
	
	where B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

	<!--- Rango de Placas --->
	<cfif isdefined("form.APlacaIni") and len(trim(form.APlacaIni))>
		and B.CRDRplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.APlacaIni#">
	</cfif>

	<!--- Vale --->
	<cfif isdefined("form.TipoVale") and len(trim(form.TipoVale))>
		<cfif TipoVale neq -1>
			and B.CRTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoVale#">
		</cfif>
	</cfif>	
	
	<!--- Recorre los Centros Funcionales Hijos del Seleccionado --->	
	<cfif isDefined("form.IncluyeHijo") and len(trim(form.IncluyeHijo))>
		and B.CFid in (#lstHijos#)
	<cfelse>
		<!--- Modo Normal por Rangos --->	
		<cfif isdefined("form.CFidIni") and len(trim(form.CFidIni))>
			and B.CFid >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidIni#">
		</cfif>
		<cfif isdefined("form.CFidFin") and len(trim(form.CFidFin))>
			and B.CFid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidFin#">
		</cfif>		
	</cfif>	
	and B.DEid is not null
	and B.CRCCid is not null
	and B.CFid is not null
	and B.ACcodigo is not null
	and B.ACid is not null
</cfquery>

<cfif rsReporteCount1.recordcountdb + rsReporteCount2.recordcountdb gt MAXROWSALLOWED>
	<cf_errorCode	code = "50123"
					msg  = "El reporte no puede ser procesado. El reporte con los filtros definidos, devuelve @errorDat_1@, mas de los @errorDat_2@ registros permitidos, Proceso Cancelado!"
					errorDat_1="#rsReporteCount1.recordcountdb + rsReporteCount2.recordcountdb#"
					errorDat_2="#MAXROWSALLOWED#"
	>
</cfif> 


<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="#MAXROWSALLOWED#">
	<cf_dbrowcount1 rows="#MAXROWSALLOWED#">
	
		select
		E.CRCCdescripcion as CC,
		TD.CRTDdescripcion as TD,
		G.CFdescripcion as CF,
		C.Aplaca as placa,
		B.CRDRdescripcion as descPlaca,
		B.CRDRdescdetallada as descDetPlaca,
		D.DEidentificacion as cedula,
		<cf_dbfunction name="concat" args="D.DEnombre , ' ' ,D.DEapellido1 ,' ' ,D.DEapellido2"> as nombre,
		H.ACdescripcion AS Categoria,
		I.ACdescripcion as Clase,
		B.AFRfini as FI,
		E.CRCCid as CCid,
		TD.CRTDid as TDid,
		G.CFid as CFid,
		H.ACcodigodesc AS codCategoria,
		I.ACcodigodesc as CodClasificacion,
		case when (<cf_dbfunction name="now"> >= B.AFRfini and <cf_dbfunction name="now"> <= B.AFRffin) then 'Activo' else 'Inactivo' end as descEstado,
		case when (<cf_dbfunction name="now"> >= B.AFRfini and <cf_dbfunction name="now"> <= B.AFRffin) then 'A' else 'I' end as idEstado,		
		C.Aserie as Serie,
		(select max(HIS.CRBfecha) 
		 from CRBitacoraTran HIS 
		 where HIS.Ecodigo = C.Ecodigo 
		 	and HIS.CRBPlaca = C.Aplaca ) as UltimaMofic,
		B.CRTDid as CRTDid,
		B.BMUsucodigo,
		((select J.Usulogin from Usuario J where J.Usucodigo = B.BMUsucodigo)) as Usulogin
	from CFuncional G
		inner join AFResponsables B <cf_dbforceindex name="AFResponsables_03">

				inner join DatosEmpleado D
				on D.DEid 	= B.DEid

				inner join CRCentroCustodia E
				 on E.CRCCid = B.CRCCid
				and E.Ecodigo = B.Ecodigo  
				
				inner join CRTipoDocumento TD
				 on TD.CRTDid = B.CRTDid
				and TD.Ecodigo = B.Ecodigo  

				inner join Activos C
					inner join ACategoria H 
					on	H.Ecodigo  = C.Ecodigo
					and	H.ACcodigo = C.ACcodigo

					inner join AClasificacion I 
					on  I.Ecodigo  = C.Ecodigo
					and I.ACid     = C.ACid
					and	I.ACcodigo = C.ACcodigo

				on C.Aid = B.Aid
				<!--- Rango de Placas --->
				<cfif isdefined("form.APlacaIni") and len(trim(form.APlacaIni))>
					and C.Aplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.APlacaIni#">
				</cfif>

			 on B.CFid = G.CFid
			<!--- Estado --->
			<cfif isdefined("form.estado") and len(trim(form.estado))>
				<cfif (form.estado eq "A") or (form.estado eq "A,T")>
					and (<cf_dbfunction name="now"> >= B.AFRfini and <cf_dbfunction name="now"> <= B.AFRffin)
				<cfelseif form.estado eq "I">
					and <cf_dbfunction name="now"> > B.AFRffin
				</cfif>
			</cfif>	
			<!--- Vale --->
			<cfif isdefined("form.TipoVale") and len(trim(form.TipoVale))>
				<cfif TipoVale neq -1>
					and B.CRTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoVale#">
				</cfif>
			</cfif>	
	where G.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<!--- Recorre los Centros Funcionales Hijos del Seleccionado --->	
	<cfif isDefined("form.IncluyeHijo") and len(trim(form.IncluyeHijo))>
		and G.CFid in (#lstHijos#)
	<cfelse>
		<!--- Modo Normal por Rangos --->	
		<cfif isdefined("form.CFidIni") and len(trim(form.CFidIni))>
			and G.CFid >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidIni#">
		</cfif>
		<cfif isdefined("form.CFidFin") and len(trim(form.CFidFin))>
			and G.CFid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidFin#">
		</cfif>		
	</cfif>
	<cfif isdefined("form.descripcion") and len(trim(form.descripcion))>
		and upper (B.CRDRdescdetallada) like upper('%#form.descripcion#%')
	</cfif>

union all

	select
		E.CRCCdescripcion as CC,
		TD.CRTDdescripcion as TD,
		G.CFdescripcion as CF,
		B.CRDRplaca as placa,
		B.CRDRdescripcion as descPlaca,
		B.CRDRdescdetallada as descDetPlaca,
		D.DEidentificacion as cedula,
		<cf_dbfunction name="concat" args="D.DEnombre ,' ', D.DEapellido1 ,' ', D.DEapellido2">  as nombre,
		H.ACdescripcion AS Categoria,
		I.ACdescripcion as Clase,
		<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null"> as FI,
		E.CRCCid as CCid,
		TD.CRTDid as TDid,
		G.CFid as CFid,
		H.ACcodigodesc AS codCategoria,
		I.ACcodigodesc as CodClasificacion,
		'Tránsito' as descEstado,
		'T' as idEstado,
		B.CRDRserie as Serie,
		(select max(HIS.CRBfecha)
		 from CRBitacoraTran  HIS
		 where HIS.Ecodigo = B.Ecodigo
		 	and HIS.CRBPlaca = B.CRDRplaca ) as UltimaMofic,
		B.CRTDid as CRTDid,
		B.BMUsucodigo,
		((select J.Usulogin from Usuario J where J.Usucodigo = B.BMUsucodigo)) as Usulogin

	from CFuncional G
		inner join CRDocumentoResponsabilidad B

				inner join DatosEmpleado D
				on D.DEid 	= B.DEid

				inner join CRCentroCustodia E
				 on E.CRCCid = B.CRCCid
				and E.Ecodigo = B.Ecodigo  
				
				inner join CRTipoDocumento TD
				 on TD.CRTDid = B.CRTDid
				and TD.Ecodigo = B.Ecodigo
				
				inner join ACategoria H 
				on	H.Ecodigo  = B.Ecodigo
				and	H.ACcodigo = B.ACcodigo

				inner join AClasificacion I 
				on  I.Ecodigo  = B.Ecodigo
				and I.ACid     = B.ACid
				and	I.ACcodigo = B.ACcodigo

			 on B.CFid = G.CFid
			<!--- Rango de Placas --->
			<cfif isdefined("form.APlacaIni") and len(trim(form.APlacaIni))>
				and B.CRDRplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.APlacaIni#">
			</cfif>

			<!--- Vale --->
			<cfif isdefined("form.TipoVale") and len(trim(form.TipoVale))>
				<cfif TipoVale neq -1>
					and B.CRTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoVale#">
				</cfif>
			</cfif>	
	where G.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<!--- Recorre los Centros Funcionales Hijos del Seleccionado --->	
	<cfif isDefined("form.IncluyeHijo") and len(trim(form.IncluyeHijo))>
		and G.CFid in (#lstHijos#)
	<cfelse>
		<!--- Modo Normal por Rangos --->	
		<cfif isdefined("form.CFidIni") and len(trim(form.CFidIni))>
			and G.CFid >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidIni#">
		</cfif>
		<cfif isdefined("form.CFidFin") and len(trim(form.CFidFin))>
			and G.CFid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFidFin#">
		</cfif>		
	</cfif>
	<cfif isdefined("form.descripcion") and len(trim(form.descripcion))>
		and upper (B.CRDRdescdetallada) like upper('%#form.descripcion#%')
	</cfif>
	<cf_dbrowcount2_a rows="#MAXROWSALLOWED#">
	<!---order by cedula, CC, CRTDid, placa, CF--->
	order by CF, cedula, CC, TD, TDid, placa
	<cf_dbrowcount2_b rows="#MAXROWSALLOWED#">
</cfquery>

<!--- Filtros --->
<cfset placaInicial  = " No Definida">
<cfset cfInicial     = " No Definido">
<cfset cfFinal       = " No Definido">
<cfset dTipoVale     = " Todos">
<cfset dIncluyeHijos = " No">
<cfset estadoD       = " Todos">

<cfif isdefined("form.APlacaIni") and len(trim(form.APlacaIni))>
	<cfset placaInicial  = " " & form.APlacaIni & " (" & form.ADescripcionIni & ")">
</cfif>
<cfif isdefined("form.CFidIni") and len(trim(form.CFidIni))>
	<cfset cfInicial = " " & #form.CFcodigoIni# & " ( " & form.sCCIni & ")">
</cfif>
<cfif isdefined("form.CFidFin") and len(trim(form.CFidFin))>
	<cfset cfFinal = " " & #form.CFcodigoFin# & " ( " & form.sCCFin & ")">
</cfif>
<cfset dTipoVale = "Todos">
<cfif isdefined("form.TipoVale") and len(trim(form.TipoVale)) and TipoVale neq -1>
	<cfquery name="rsTipoDocumentodesc" datasource="#session.DSN#">
		select CRTDdescripcion
			from CRTipoDocumento
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CRTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TipoVale#">
	</cfquery>

	<cfif isdefined("rsTipoDocumentodesc") and rsTipoDocumentodesc.RecordCount GT 0>
		<cfset dTipoVale = rsTipoDocumentodesc.CRTDdescripcion>
	</cfif>
</cfif>	

<cfif isDefined("form.IncluyeHijo") and len(trim(form.IncluyeHijo))>
	<cfset dIncluyeHijos = " Si">
</cfif>
<cfif isdefined("form.estado") and len(trim(form.estado))>
	<cfif form.estado eq "A">
		<cfset estadoD = " Activos">
	<cfelseif form.estado eq "I">
		<cfset estadoD = " Inactivos">	
	<cfelseif form.estado eq "T">
		<cfset estadoD = " En Tr&aacute;nsito">		
	<cfelseif form.estado eq "A,T">
		<cfset estadoD = " Activos y En Tr&aacute;nsito">				
	</cfif>
</cfif>

<cf_htmlreportsheaders
	title="Documentos por Centro Funcional" 
	filename="DocumentosPorVale#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls" 
	ira="DocumentosPorVale.cfm">

<!--- Botones 
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
--->

<!--- Estilos --->
	<!--- Estilos --->
	<style>
		H1.Corte_Pagina {
			PAGE-BREAK-AFTER: always
		}
	</style>
	<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">

<!--- Llena el Encabezado --->
<cfset MaxLineasReporte = 60>
<cfsavecontent variable="encabezado">
	<cfoutput>
		<tr><td align="center" colspan="10"><cfinclude template="RetUsuario.cfm"></td></tr>
		<tr><td align="center" colspan="10"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
		<tr><td align="center" colspan="10"><font size="2"><strong>Documentos por Centro Funcional</strong></font></td></tr>
		<tr><td align="center" colspan="10"><strong>Centro Funcional Inicial: #cfInicial# / Centro Funcional Final: #cfFinal#</strong></td></tr>
		<tr><td align="center" colspan="10"><strong>Placa: #placaInicial#</strong></td></tr>
		<tr><td align="center" colspan="10"><strong>Tipo de Documento: #dTipoVale#</strong></td></tr>					
		<tr><td align="center" colspan="10"><strong>Incluir Hijos: #dIncluyeHijos#</strong></td></tr>							
		<tr><td align="center" colspan="10"><strong>Estado: #estadoD#</strong></td></tr>		
		<tr><td align="center" colspan="10"><hr></td></tr>
		<tr>
			<td align="left" bgcolor="##CCCCCC"><strong>Placa</strong></td>
			<cfif isdefined("chkverresumida")>
				<td align="left" bgcolor="##CCCCCC"><strong>Descripción</strong></td>			
			</cfif>
			<cfif isdefined("chkverdetalle")>
				<td align="left" bgcolor="##CCCCCC"><strong>Descripción Detallada</strong></td>			
			</cfif>
			<cfif isdefined("chkvercategoria")>
				<td align="left" bgcolor="##CCCCCC"><strong>Categor&iacute;a</strong></td>
			</cfif>
			<cfif isdefined("chkverclase")>
				<td align="left" bgcolor="##CCCCCC"><strong>Clase</strong></td>
			</cfif>
			<cfif isdefined("chkverserie")>
				<td align="left" bgcolor="##CCCCCC"><strong>Serie</strong></td>
			</cfif>						
			<cfif isdefined("chkveringreso")>
				<td align="left" bgcolor="##CCCCCC"><strong>Fecha Ingreso</strong></td>
			</cfif>			
			<cfif isdefined("chkverfultran")>
				<td align="left" bgcolor="##CCCCCC"><strong>Fecha Ult. Modificaci&oacute;n</strong></td>
			</cfif>			
			<cfif isdefined("chkverestado")>
				<td align="left" bgcolor="##CCCCCC"><strong>Estado</strong></td>			
			</cfif>
			<cfif isdefined("chkverusuario")>
				<td align="left" bgcolor="##CCCCCC"><strong>Usuario</strong></td>			
			</cfif>
			
		</tr>
	</cfoutput>
</cfsavecontent>

<!--- Llena el Detalle --->
	<cfif rsReporte.recordcount gt 0>
		<cfflush interval="512">
		<cfoutput>#encabezado#</cfoutput>
		<cfset paginaNueva = false>
		<cfset contador = 14>
		<cfset vCCid = -1>
		<cfset vTDid = -1>
		<cfset vCFid = -1>
		<cfset vcedula = -1>
		<cfoutput query="rsReporte">
					<cfset bEntra = false>
					<cfif #rsReporte.idEstado# eq 'A' and form.estado eq 'A'>
						<cfset bEntra = true>
					<cfelseif #rsReporte.idEstado# eq 'I' and form.estado eq 'I'>
						<cfset bEntra = true>
					<cfelseif #rsReporte.idEstado# eq 'T' and form.estado eq 'T'>
						<cfset bEntra = true>					
					<cfelseif (#rsReporte.idEstado# eq 'A' and form.estado eq 'A,T') or (#rsReporte.idEstado# eq 'T' and form.estado eq 'A,T')>
						<cfset bEntra = true>
					<cfelseif form.estado eq ''>
						<cfset bEntra = true>
					</cfif>
					
					<cfif bEntra>						
						<!--- Pinta el Encabezado --->
						<cfif contador gte MaxLineasReporte>
							<tr><td align="center" colspan="10"><H1 class=Corte_Pagina></H1></td></tr>
							#encabezado#
							<cfset paginaNueva = true>
							<cfset contador = 14>
						</cfif>
		
						<!--- Agrupamiento por Centro Funcional --->
						<cfif #trim(CFid)# neq #vCFid# or #paginaNueva#>
							<tr><td align="center" colspan="10"><hr></td></tr>							
							<tr>
								<td align="left" colspan="10" bgcolor="##CCCCCC"><font size="1"><strong>&nbsp;Centro Funcional: #trim(CF)#</strong></font></td>
							</tr>
							<tr><td align="center" colspan="10">&nbsp;</td></tr>
							<cfset vcedula = -1>
							<cfset contador = contador + 1>
						</cfif> 
						<cfset vCFid = #trim(CFid)#>		

						<!--- Agrupamiento por Cédula y Nombre --->
						<cfif #trim(cedula)# neq #vcedula# or #paginaNueva#>
							<tr>
								<td align="left" colspan="10" bgcolor="##CCCCCC"><font size="1"><strong>&nbsp;&nbsp;C&eacute;dula: #trim(cedula)# - #trim(nombre)#</strong></font></td>
							</tr>							
							<cfset vCCid = -1>
							<cfset vTDid = -1>
							<cfset contador = contador + 1>
						</cfif>
						
						<cfset vcedula = #trim(cedula)#>		
		
						<!--- Agrupamiento por Centro de Custodia --->
						<cfif #trim(CCid)# neq #vCCid# or #paginaNueva#>
							<!--- <tr><td align="center" colspan="10"><hr></td></tr> --->
							<tr>
								<td align="left" colspan="10" bgcolor="##CCCCCC"><font size="1"><strong>&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;Centro de Custodia: #trim(CC)#</strong></font></td>
							</tr>
							<!---
							<cfset vCFid = -1>
							<cfset vcedula = -1>--->
							<cfset vTDid = -1>
							<cfset contador = contador + 2>
						</cfif>
						<cfset vCCid = #trim(CCid)#>
						
						<!--- Agrupamiento por Tipo de Documento --->
						<cfif #trim(TDid)# neq #vTDid# or #paginaNueva#>							
							<tr>
								<td align="left" colspan="10" bgcolor="##CCCCCC"><font size="1"><strong>&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;Tipo de Documento: #trim(TD)#</strong></font></td>
							</tr>
							<cfset contador = contador + 2>
						</cfif>
						<cfset vTDid = #trim(TDid)#>						

						<tr>				
							<td nowrap align="left"><font size="1">&nbsp;&nbsp;&nbsp;#trim(placa)#</font></td>
							<cfif isdefined("chkverresumida")>
								<td nowrap align="left"><font size="1">#mid(trim(descPlaca),1,35)#</font></td>			
							</cfif>
							<cfif isdefined("chkverdetalle")>
								<td nowrap align="left"><font size="1">#mid(trim(descDetPlaca),1,50)#</font></td>			
							</cfif>
							<cfif isdefined("chkvercategoria")>
								<td nowrap align="left"><font size="1">#trim(codCategoria)# - #mid(trim(Categoria),1,25)#</font></td>
							</cfif>
							<cfif isdefined("chkverclase")>							
								<td nowrap align="left"><font size="1">#trim(codClasificacion)# - #mid(trim(Clase),1,25)#</font></td>
							</cfif>
							<cfif isdefined("chkverserie")>							
								<td nowrap align="left"><font size="1">#trim(Serie)#</font></td>
							</cfif>							
							<cfif isdefined("chkveringreso")>							
								<td nowrap align="left"><font size="1">#trim(LSDateFormat("#FI#","dd/mm/yyyy"))#</font></td>
							</cfif>
							<cfif isdefined("chkverfultran")>
								<td nowrap align="left"><font size="1">#trim(LSDateFormat("#UltimaMofic#","dd/mm/yyyy"))#</font></td>
							</cfif>
							<cfif isdefined("chkverestado")>
								<td nowrap align="left"><font size="1">#trim(descEstado)#</font></td>
							</cfif>
							<cfif isdefined("chkverusuario")>
								<td nowrap align="left"><font size="1">#trim(Usulogin)#</font></td>
							</cfif>
						</tr>
						<cfset contador = contador + 1>
						<cfset paginaNueva = false>
					</cfif>
		</cfoutput>
	<cfelse>
			<tr><td align="center" colspan="10"><hr></td></tr>
			<tr><td align="center" colspan="10">&nbsp;</td></tr>
			<tr><td align="center" colspan="10"><strong> --- La consulta no gener&oacute; ning&uacute;n resultado --- </strong></td></tr>
	</cfif>

<!--- Forma el Reporte  --->
<cfoutput>
		<tr><td align="center" colspan="10">&nbsp;</td></tr>
		<tr><td align="center" colspan="10"><hr></td></tr>
		<tr><td colspan="10" nowrap align="center"><strong> --- Fin de la Consulta --- </strong></td></tr>
	</table>
</cfoutput>

<!--- Valida y concatena los parametros --->   
<cfset params = "?1=1">
<cfif isdefined("form.chkverresumida")>
	<cfset params = params & "&chkverresumida=#form.chkverresumida#">
</cfif>
<cfif isdefined("form.chkverdetalle")>
	<cfset params = params & "&chkverdetalle=#form.chkverdetalle#">
</cfif>
<cfif isdefined("form.chkvercategoria")>
	<cfset params = params & "&chkvercategoria=#form.chkvercategoria#">
</cfif>
<cfif isdefined("form.chkverclase")>
	<cfset params = params & "&chkverclase=#form.chkverclase#">
</cfif>
<cfif isdefined("form.chkverserie")>
	<cfset params = params & "&chkverserie=#form.chkverserie#">
</cfif>
<cfif isdefined("form.chkveringreso")>
	<cfset params = params & "&chkveringreso=#form.chkveringreso#">
</cfif>
<cfif isdefined("form.chkverfultran")>
	<cfset params = params & "&chkverfultran=#form.chkverfultran#">
</cfif>
<cfif isdefined("form.chkverestado")>
	<cfset params = params & "&chkverestado=#form.chkverestado#">
</cfif>
<cfif isdefined("form.chkverusuario")>
	<cfset params = params & "&chkverusuario=#form.chkverusuario#">
</cfif>

<cfoutput>
<form name="form1" method="get" action="DocumentosPorVale.cfm#params#">
	<input type="hidden" name="reporte" value="ok">
	<cfif isdefined("form.chkverresumida")><input type="hidden" name="chkverresumida" value=""></cfif>
	<cfif isdefined("form.chkverdetalle")><input type="hidden" name="chkverdetalle" value=""></cfif>
	<cfif isdefined("form.chkvercategoria")><input type="hidden" name="chkvercategoria" value=""></cfif>
	<cfif isdefined("form.chkverclase")><input type="hidden" name="chkverclase" value=""></cfif>
	<cfif isdefined("form.chkverserie")><input type="hidden" name="chkverserie" value=""></cfif>
	<cfif isdefined("form.chkveringreso")><input type="hidden" name="chkveringreso" value=""></cfif>
	<cfif isdefined("form.chkverfultran")><input type="hidden" name="chkverfultran" value=""></cfif>
	<cfif isdefined("form.chkverestado")><input type="hidden" name="chkverestado" value=""></cfif>
	<cfif isdefined("form.chkverusuario")><input type="hidden" name="chkverusuario" value=""></cfif>
</form>
</cfoutput>


