<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensaje" 	default="Escoja la opción Open o Abrir en la pantalla de Download o Descargar Archivo SoinAnexosOPs.xls" returnvariable="LB_Mensaje" xmlfile="calcular-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensaje1" 	default="cuando termine el Proceso de Actualización del" returnvariable="LB_Mensaje1" xmlfile="calcular-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensaje2" 	default="Anexo Calculado" 
returnvariable="LB_Mensaje2" xmlfile="calcular-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Presione" 	default="Presione" 
returnvariable="LB_Presione" xmlfile="calcular-sql.xml"/>
<cfset msg = "">
<cfset rc = 0>
<cfset ACid = "">
<cfset form.ACactualizarEn = "E">
<cfparam name="form.chkND" default="0">
<cfif isdefined("form.ACidBorrar") and form.ACidBorrar NEQ "">
	<!--- desprogramar un calculo --->
	<cfquery datasource="#session.DSN#" name="buscarAnexoCalculo">
		select AnexoId from AnexoCalculo 
		where ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACidBorrar#">
	</cfquery>
	<cfif Len(buscarAnexoCalculo.AnexoId)>
		<cfquery datasource="#session.DSN#">
			delete from AnexoCalculoRango
			where ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACidBorrar#">
		</cfquery>
		<cfquery datasource="#session.DSN#">
			delete from AnexoCalculo
			where ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACidBorrar#">
		</cfquery>
	</cfif>
<cfelseif isdefined("form.Calcular")>

	<cfif form.ANubicaTipo EQ "GOD">
		<cfset LvarGrupoOrigenes = true>

		<cfset LvarANubicaID = form.ANubicaGODid>
		<cfset myGODid	 	 = form.ANubicaGODid>
	<cfelse>
		<cfset LvarGrupoOrigenes = false>

		<cfset myEcodigo = form.ANubicaEcodigo>
		<cfset myOcodigo = -1>
		<cfset myGOid    = -1>
		<cfset myGEid    = -1>
		<cfif form.ANubicaTipo EQ "GE">
			<cfset LvarANubicaID = form.ANubicaGEid>
			<cfset myGEid		 = form.ANubicaGEid>
			<cfset myEcodigo 	 = -1>
		<cfelseif form.ANubicaTipo EQ "GO">
			<cfset LvarANubicaID = form.ANubicaGOid>
			<cfset myGOid		 = form.ANubicaGOid>
		<cfelseif form.ANubicaTipo EQ "E">
			<cfset LvarANubicaID = form.ANubicaEcodigo>
		<cfelseif form.ANubicaTipo EQ "O">
			<cfset LvarANubicaID = form.ANubicaOcodigo>
			<cfset myOcodigo	 = form.ANubicaOcodigo>
		</cfif>
	</cfif>
	<cfquery name="rsCalcular_SQL_CFM_Anexo" datasource="#session.DSN#">
		select 	  a.AnexoId
				, a.AnexoDes
				, <cf_dbfunction name="length" args="i.AnexoXLS"> as len_XLS
				, AnexoOcultaFilas
				, AnexoOcultaColumnas
				,case when exists (
					select 1
					  from AnexoPermisoDef pd
					 where (pd.GAid = a.GAid or pd.AnexoId = a.AnexoId)
					   and pd.Usucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					   and pd.APdist 	= 1
				) then 1 else 0 end
				as Distribuir
		<cfif LvarGrupoOrigenes>
				,
				case 
					when god.GEid is null then god.EcodigoCal else -1 
				end 						as EcodigoCal, 
				coalesce(god.GEid, -1) 		as GEid, 
				coalesce(god.Ocodigo,-1) 	as Ocodigo, 
				coalesce(god.GOid,-1) 		as GOid
		  from Anexo a
			inner join AnexoGOrigenDatosDet god
			   on god.GODid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#myGODid#">
		<cfelse>
		  from Anexo a
		</cfif>
			left join Anexoim i
				on i.AnexoId = a.AnexoId
		<cfif trim(form.AnexoId) NEQ "">
		 where a.AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
		<cfelse>
			inner join AnexoGrupoCubo cubo
			   on cubo.GAhijo 	= a.GAid
			  and cubo.GApadre 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAid#">
			  and exists (
					select 1
					  from AnexoPermisoDef pd, AnexoEm ae
					 where (pd.GAid = a.GAid or pd.AnexoId = a.AnexoId)
					   and pd.Usucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					   and pd.APcalc 	= 1
					   and ae.AnexoId 	= a.AnexoId
					   and ae.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				)
		 where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		</cfif>
		  <!--- 
		  26 Sep 2005
		  Este filtro no debe ser descomentado ya que el calculo de anexos es compartido
		  entre todas las empresas. 
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		   --->
	</cfquery>

	<cfif form.opcion eq 'P'>
		<cfset fecha = listtoarray(form.fecha,'/')>
		<cfset hora = listtoarray(form.hora,':') >
		<cfset ACfechaCalculo = CreateDateTime(fecha[3],fecha[2], fecha[1], hora[1], hora[2], 0)>
	<cfelse>
		<cfset ACfechaCalculo = Now()>
	</cfif>

	<cfparam name="form.ACdistribucion" default="N">

	<cfset LvarANdetalle = "">
	<cfset LvarIDS = arrayNew(1)>
	<cfloop query="rsCalcular_SQL_CFM_Anexo">
		<cfif LvarGrupoOrigenes>
			<cfset myEcodigo = rsCalcular_SQL_CFM_Anexo.EcodigoCal>
			<cfset myGEid    = rsCalcular_SQL_CFM_Anexo.GEid>
			<cfset myGOid    = rsCalcular_SQL_CFM_Anexo.GOid>
			<cfset myOcodigo = rsCalcular_SQL_CFM_Anexo.Ocodigo>
		</cfif>
		<cfif form.ACdistribucion EQ "S" AND rsCalcular_SQL_CFM_Anexo.AnexoId EQ "1">
			<cfset LvarACdistribucion = "S">
		<cfelse>
			<cfset LvarACdistribucion = "N">
		</cfif>
		<cfset LvarACid = "">

		<cfparam name="form.ACmLocal" default="0">
		<cfif form.Mcodigo EQ -1>
			<cfset form.ACmLocal = 1>
		</cfif>

		<cfinvoke component="sif.an.operacion.calculo.calculo" 
				method="programarEjecucion"

				returnvariable="LvarACid"

				AnexoId = "#rsCalcular_SQL_CFM_Anexo.AnexoId#"
				ACano = "#form.ACano#"
				ACmes = "#form.ACmes#"
				Mcodigo = "#form.Mcodigo#"
				ACmLocal = "#form.ACmLocal#"
				Ecodigo = "#myEcodigo#"
				Ocodigo = "#myOcodigo#"
				GEid = "#myGEid#"
				GOid = "#myGOid#"
				ACunidad = "#form.ACunidad#"
				ACfechaCalculo = "#ACfechaCalculo#"
				ACactualizarEn="#form.ACactualizarEn#" 
				ACdistribucion="#LvarACdistribucion#"
		/>
		<cfif form.opcion EQ 'E'>
			<cfinvoke component="sif.an.operacion.calculo.calculo" 
					method="calcularAnexo"
					datasource="#session.dsn#" 
					ACid="#LvarACid#"
					ACactualizarEn="#form.ACactualizarEn#" 
			/>
			<cfinclude template="../../../Utiles/sifConcat.cfm">
			<cfquery name="rsAC" datasource="#session.DSN#">
				select 	ac.ACstatus,
						ac.ACano, ac.ACmes,	ac.ACunidad, ACfechaCalculo,
						case when ac.Mcodigo = -1 
							then '(LOCAL)' 
							else m.Mnombre 
						end as Moneda,
						case 
							when ac.GEid    != -1 then 'Grupo Empresas: ' #_Cat# ge.GEnombre
							when ac.GOid    != -1 then 'Grupo Oficinas: ' #_Cat# go.GOnombre
							when ac.Ocodigo != -1 then 'Oficina: ' #_Cat# o.Odescripcion
							else 'Empresa: ' #_Cat# e.Edescripcion
						end as Origen
				  from AnexoCalculo ac
					 left join Monedas m
					   on m.Mcodigo = ac.Mcodigo
					 left join AnexoGEmpresa ge
					   on ge.GEid = ac.GEid
					 left join AnexoGOficina go
					   on go.GOid = ac.GOid
					 left join Oficinas o
					   on o.Ocodigo = ac.Ocodigo
					  and o.Ecodigo = ac.Ecodigo
					 left join Empresas e
					   on e.Ecodigo = ac.Ecodigo
				 where ac.ACid = #LvarACid#
			</cfquery>

			<cfif rsAC.ACstatus NEQ "F">
				<cf_errorCode	code = "50153" msg = "El Anexo no se pudo calcular">
			</cfif>
			<cfif rsCalcular_SQL_CFM_Anexo.len_XLS EQ 0>
				<cfset LvarGenerarXLS = "S">
			<cfelse>
				<cfset LvarGenerarXLS = "N">
			</cfif>
			<cfif rsCalcular_SQL_CFM_Anexo.AnexoOcultaFilas EQ "1">
				<cfset LvarOcultaFilas = "S">
			<cfelse>
				<cfset LvarOcultaFilas = "N">
			</cfif>
			<cfif rsCalcular_SQL_CFM_Anexo.AnexoOcultaColumnas EQ "1">
				<cfset LvarOcultaColumnas = "S">
			<cfelse>
				<cfset LvarOcultaColumnas = "N">
			</cfif>

			<cfset LvarCrLn = chr(13) & chr(10)>
			<cfset LvarANdetalle	= LvarANdetalle &
				'	<Row>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#LvarACid#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsCalcular_SQL_CFM_Anexo.currentRow#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#LvarGenerarXLS#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsCalcular_SQL_CFM_Anexo.AnexoDes#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#LvarOcultaFilas#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#LvarOcultaColumnas#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsAC.ACano#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsAC.ACmes#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsAC.Origen#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsAC.ACunidad#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsAC.Moneda#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsAC.ACfechaCalculo#</Data></Cell>' & LvarCrLn &
				'	</Row>' & LvarCrLn
			>
			<cfset LvarIDS[rsCalcular_SQL_CFM_Anexo.currentRow] = LvarACid>
		</cfif>
	</cfloop>
	<cfset msg = form.opcion>
	<cfset rc = rsCalcular_SQL_CFM_Anexo.RecordCount>
	<cfif form.opcion EQ 'E' AND form.ACactualizarEn EQ 'E'>
		<cfset session.anexos.LvarANdetalle = LvarANdetalle>
		<cfset session.anexos.LvarIDS = LvarIDS>
		<cfoutput>
			<cfset LvarObj = createObject("component","sif.an.WS.anexosWS")>
			<cfset LvarWSkey = LvarObj.fnInicializarSeguridad("CALCULAR")>

			<table cellpadding="0" cellspacing="0" height="100%" align="center" style="text-align:center; vertical-align:middle">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td width="700" height="50" style="border-top:1px solid ##000000;border-right:1px solid ##000000;border-left:1px solid ##000000; font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">
					<table>
						<tr>
							<td style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">&nbsp;
								
							</td>
						</tr>
						<tr>
							<td style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">
								1. #LB_Mensaje#
							</td>
						</tr>
						<tr>
							<td style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">
								2. #LB_Presione# <font style="background-color:##CBCBCB">&nbsp;OK&nbsp;</font> #LB_Mensaje1# <strong>#LB_Mensaje2# </strong>
							</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td width="700" height="50" style="border-bottom:1px solid ##000000;border-right:1px solid ##000000;border-left:1px solid ##000000;">
						<input 	value="&nbsp;&nbsp;OK&nbsp;&nbsp;" 
								type="button" 
								onClick="
									<!---
									location.href='index.cfm?GAid=#URLEncodedFormat(form.GAid)#&msg=#msg#&rc=#rc#&AnexoId=#URLEncodedFormat(form.AnexoId)#&ACid=#LvarACid#&ACano=#form.ACano#&ACmes=#form.ACmes#&chkND=#URLEncodedFormat(form.chkND)#&ubicacion=#URLEncodedFormat(form.ubicacion)#';
									--->
									location.href='index.cfm?GAid=#URLEncodedFormat(form.GAid)#&msg=#msg#&rc=#rc#&AnexoId=#URLEncodedFormat(form.AnexoId)#&ACid=#LvarACid#&ACano=#form.ACano#&ACmes=#form.ACmes#&chkND=#URLEncodedFormat(form.chkND)#&ANubicaTipo=#URLEncodedFormat(form.ANubicaTipo)#&ANubicaID=#URLEncodedFormat(LvarANubicaID)#';
										"
						>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			<iframe id="ifrSoinAnexosOPs" 
					src="/cfmx/sif/an/WS/SoinAnexosOPs.cfm?ACid=#LvarACid#&XLOP=CALCULAR&WSkey=#LvarWSkey#"
					width="0"
					height="0"
			></iframe>
		</cfoutput>
		<cfabort>
	</cfif>
<cfelseif isdefined("form.btnRefrescarExcel")>
	<cfif not isdefined("form.chkACidF")><br />
		<script>
			alert("No indicó cuales Anexos refrescar");
			<cfoutput>
			location.href="index.cfm?GAid=#URLEncodedFormat(form.GAid)#&msg=#msg#&rc=#rc#&AnexoId=#URLEncodedFormat(form.AnexoId)#&ACid=#ACid#&ACano=#form.ACano#&ACmes=#form.ACmes#&chkND=#URLEncodedFormat(form.chkND)#";
			</cfoutput>
		</script>
		<cfabort>
	</cfif>
	<cfset LvarACidsWhere = fnPKinChks (form.chkACidF, "ac.ACid")>
    <cfinclude template="../../../Utiles/sifConcat.cfm">
	<cfquery name="rsCalcular_SQL_CFM_Anexo" datasource="#session.DSN#">
		select 	a.AnexoId, ac.ACid,
				a.AnexoDes, 
				<cf_dbfunction name="length" args="i.AnexoXLS"> as len_XLS,
				a.AnexoOcultaFilas, a.AnexoOcultaColumnas,

				ac.ACstatus,
				ac.ACano, ac.ACmes,	ac.ACunidad, ACfechaCalculo,
				case when ac.Mcodigo = -1 
					then '(LOCAL)' 
					else m.Mnombre 
				end as Moneda,
				case 
					when ac.GEid    != -1 then 'Grupo Empresas: ' #_Cat# ge.GEnombre
					when ac.GOid    != -1 then 'Grupo Oficinas: ' #_Cat# go.GOnombre
					when ac.Ocodigo != -1 then 'Oficina: ' #_Cat# o.Odescripcion
					else 'Empresa: ' #_Cat# e.Edescripcion
				end as Origen
		from Anexo a
			inner join AnexoCalculo ac
				 left join Monedas m
				   on m.Mcodigo = ac.Mcodigo
				 left join AnexoGEmpresa ge
				   on ge.GEid = ac.GEid
				 left join AnexoGOficina go
				   on go.GOid = ac.GOid
				 left join Oficinas o
				   on o.Ocodigo = ac.Ocodigo
				  and o.Ecodigo = ac.Ecodigo
				 left join Empresas e
				   on e.Ecodigo = ac.Ecodigo
			   on ac.AnexoId  = a.AnexoId
			  and ac.ACstatus = 'F'
			 left join Anexoim i
			   on i.AnexoId = a.AnexoId
		where #LvarACidsWhere#
	</cfquery>
	<cfset LvarACid = rsCalcular_SQL_CFM_Anexo.ACid>
	<cfset LvarAnexoId = rsCalcular_SQL_CFM_Anexo.AnexoId>
	<cfset LvarANdetalle = "">
	<cfset LvarIDS = arrayNew(1)>
	<cfloop query="rsCalcular_SQL_CFM_Anexo">
		<cfif rsCalcular_SQL_CFM_Anexo.len_XLS EQ 0>
			<cfset LvarGenerarXLS = "S">
		<cfelse>
			<cfset LvarGenerarXLS = "N">
		</cfif>
		<cfif rsCalcular_SQL_CFM_Anexo.AnexoOcultaFilas EQ "1">
			<cfset LvarOcultaFilas = "S">
		<cfelse>
			<cfset LvarOcultaFilas = "N">
		</cfif>
		<cfif rsCalcular_SQL_CFM_Anexo.AnexoOcultaColumnas EQ "1">
			<cfset LvarOcultaColumnas = "S">
		<cfelse>
			<cfset LvarOcultaColumnas = "N">
		</cfif>

		<cfset LvarCrLn = chr(13) & chr(10)>
		<cfset LvarANdetalle = LvarANdetalle &
				'	<Row>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsCalcular_SQL_CFM_Anexo.ACid#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsCalcular_SQL_CFM_Anexo.currentRow#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#LvarGenerarXLS#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsCalcular_SQL_CFM_Anexo.AnexoDes#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#LvarOcultaFilas#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#LvarOcultaColumnas#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsCalcular_SQL_CFM_Anexo.ACano#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsCalcular_SQL_CFM_Anexo.ACmes#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsCalcular_SQL_CFM_Anexo.Origen#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsCalcular_SQL_CFM_Anexo.ACunidad#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsCalcular_SQL_CFM_Anexo.Moneda#</Data></Cell>' & LvarCrLn &
				'		<Cell><Data ss:Type="String">#rsCalcular_SQL_CFM_Anexo.ACfechaCalculo#</Data></Cell>' & LvarCrLn &
				'	</Row>' & LvarCrLn
		>
		<cfset LvarIDS[rsCalcular_SQL_CFM_Anexo.currentRow] = ACid>
	</cfloop>
	<cfset msg = form.opcion>
	<cfset rc = rsCalcular_SQL_CFM_Anexo.RecordCount>

	<cfset session.anexos.LvarANdetalle = LvarANdetalle>
	<cfset session.anexos.LvarIDS = LvarIDS>
	<cfoutput>
		<cfset LvarObj = createObject("component","sif.an.WS.anexosWS")>
		<cfset LvarWSkey = LvarObj.fnInicializarSeguridad("CALCULAR")>
	
		<table cellpadding="0" cellspacing="0" height="100%" align="center" style="text-align:center; vertical-align:middle">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td width="700" height="50" style="border-top:1px solid ##000000;border-right:1px solid ##000000;border-left:1px solid ##000000; font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">
				<table>
					<tr>
						<td style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">&nbsp;
							
						</td>
					</tr>
					<tr>
						<td style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">
							1. #LB_Mensaje#
						</td>
					</tr>
					<tr>
						<td style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">
							2. #LB_Presione# <font style="background-color:##CBCBCB">&nbsp;OK&nbsp;</font> #LB_Mensaje1# <strong>#LB_Mensaje2#</strong>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td width="700" height="50" style="border-bottom:1px solid ##000000;border-right:1px solid ##000000;border-left:1px solid ##000000;">
					<input value="&nbsp;&nbsp;OK&nbsp;&nbsp;" type="button" onClick="location.href='index.cfm?GAid=#URLEncodedFormat(form.GAid)#&msg=#msg#&rc=#rc#&AnexoId=#URLEncodedFormat(LvarAnexoId)#&ACid=#LvarACid#&ACano=#form.ACano#&ACmes=#form.ACmes#&chkND=#URLEncodedFormat(form.chkND)#';">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		<iframe id="ifrSoinAnexosOPs" 
				src="/cfmx/sif/an/WS/SoinAnexosOPs.cfm?ACid=#ACid#&XLOP=CALCULAR&WSkey=#LvarWSkey#"
				width="0"
				height="0"
		></iframe>
	</cfoutput>
	<cfabort>
<cfelseif isdefined("form.btnDistribuirMail")>
	<cfif not isdefined("form.chkACidD#form.tipoDistribucion#")><br />
		<script>
			alert("No indicó cuales Anexos distribuir");
			<cfoutput>
			location.href="index.cfm?GAid=#URLEncodedFormat(form.GAid)#&msg=#msg#&rc=#rc#&AnexoId=#URLEncodedFormat(form.AnexoId)#&ACid=#ACid#&ACano=#form.ACano#&ACmes=#form.ACmes#&chkND=#URLEncodedFormat(form.chkND)#";
			</cfoutput>
		</script>
		<cfabort>
	</cfif>
	<cfset LvarACidsWhere = fnPKinChks (form["chkACidD#form.tipoDistribucion#"], "c.ACid")>
	<cfquery name="rsAC" datasource="#session.DSN#">
		select c.AnexoId, c.ACid
		  from AnexoCalculo c
		 where #LvarACidsWhere#
		   and c.ACstatus = 'T'
	</cfquery>
	<cfloop query="rsAC">
		<cfinvoke component="sif.an.operacion.calculo.calculo" 
				method="distribuir"
		
				returnvariable="LvarEnviados"
		
				DataSource	= "#session.DSN#"
				AnexoId		= "#rsAC.AnexoId#"
				ACid		= "#rsAC.ACid#"
		/>
	</cfloop>
</cfif>

<cfoutput>
<cflocation url="index.cfm?GAid=#URLEncodedFormat(form.GAid)#&msg=#msg#&rc=#rc#&AnexoId=#URLEncodedFormat(form.AnexoId)#&ACid=#ACid#&ACano=#form.ACano#&ACmes=#form.ACmes#&ACen=#form.ACactualizarEn#&chkND=#URLEncodedFormat(form.chkND)#">
</cfoutput>

<cffunction name="fnPKinChks" output="false" returntype="string">
	<cfargument name="chkList"	required="yes" type="string">
	<cfargument name="PKname"	required="yes" type="string">

	<cfset LvarACids = listToArray(chkList)>
	<cfset LvarACidWhere = createObject("java","java.lang.StringBuffer")>
	<cfloop index="LvarIdx" from="1" to="#ArrayLen(LvarACids)#">
		<cfif LvarIdx EQ 1>
			<cfset LvarACidWhere.append(" (#PKname# in (")>
		<cfelseif (LvarIdx mod 10) EQ 1>
			<cfset LvarACidWhere.append(") or #PKname# in (")>
		<cfelse>
			<cfset LvarACidWhere.append(",")>
		</cfif>
		<cfset LvarACidWhere.append("#LvarACids[LvarIdx]#")>
	</cfloop>
	<cfset LvarACidWhere.append("))")>
	<cfreturn LvarACidWhere.toString()>
</cffunction>


