<cfinclude template="Reporte.cfm">
<cfif isdefined("form.PROGRAMADO") and len(trim(form.PROGRAMADO)) and form.PROGRAMADO eq "S">
	<cfset fnProgramaReporte()>
	<cflocation url="SaldoCuentaContArch.cfm">
</cfif>

<cfsetting requesttimeout="2700">
<html><head><title>Procesando reporte...</title></head>
<body>
<p><center><img src="/cfmx/sif/imagenes/esperese.gif" alt="Un momento por favor.... trabajando en el reporte" width="320" height="90" border="0"></center></p>
<cfflush interval="128">

<!--- Verifica que el usuario no esté procesando ningún otro reporte o que esté abierto--->
<cfset LvarFecha = now()>

<!--- Restar 30 minutos a la fecha --->
<cfset LvarFecha = dateadd("n",-30,now())>
<cfquery name="rsVerifica" datasource="#session.dsn#">
	select FechaEjec as Fecha
	from tbl_reportescf
	where Usuario    = #Session.Usucodigo#
	  and FechaEjec >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha#">
	  and FechaFin is null
</cfquery>

<cfif isdefined ("rsVerifica") and rsVerifica.recordCount GT 1 >
	<form name="form1" id="form1" method="post" action="SaldoCuentaCont.cfm">
		<table align="center" cellpadding="0" cellspacing="0" border="0">
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr align="center">
				<td>El usuario solicito un reporte en: <cfoutput> #rsVerifica.Fecha# </cfoutput> que no ha sido generado a este momento.</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr align="center">
				<td>Por favor espere a que el reporte solicitado sea concluido....</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr align="center">
				<td><input type="submit" name="retornar" value="Regresar"></td>
			</tr>
		</table>
	</form>
	</body>
	</html>
	<cfabort>
</cfif>

<cfset fnPreparaParametros()>
<cfset fnCreaTablasTemporales()>
<cfset LvarCantidadCuentas = fnInsertaCuentas()>

<p align="center">El Reporte Gener&oacute; <cfoutput>#rsCantidad.Cantidad# </cfoutput> Cuentas de Detalle.</p>
<p align="center">Procesando y dando formato a la salida del Informe....</p>.
<p align="center"><strong>Por Favor, NO lo Ejecute nuevamente hasta que termine el proceso actual.</strong></p>

<cfset fnActualizaDatos()>
<p align="center">&nbsp;</p>
<p align="center">Insertando las Cuentas padre indicadas en los parametros.  Espere por favor....</p>

<cfset fnInsertaPadres()>
<p align="center">&nbsp;</p>
<p align="center">Datos Actualizados.  Dando formato al Reporte.  Espere por favor....</p>

<cfset LvarSoloMes = false>
<cfset LvarMesInicial = form.MESINICIAL>
<cfset LvarMesFinal   = form.MESFINAL>
<cfset LvarPeriodo    = form.PERIODOS>

<cfif LvarMesInicial EQ LvarMesFinal>
	<cfset LvarSoloMes = true>
</cfif>

<cfset tempfile_xls = "#GetTempDirectory()##Namefile#.xls">
<cfset fnProcesaReporte()>

<cfset session.tempfile_xls = tempfile_xls>
<script type="text/javascript">location.href='Reporteimpreso.cfm';</script>
<p align="center"><a href="Reporteimpreso.cfm">Reporte generado, haga clic para verlo</a></p>
</body>
</html>

<cffunction name="fnProcesaReporte" access="private" output="no">
	<cffile action="write" file="#tempfile_xls#" output="" nameconflict="overwrite">
	
	<cfquery name="rsCuentasContables" datasource="#session.dsn#">
		select 
			a.Ccuenta, 
			a.Ecodigo, 
			c.Cformato, 
			<cf_dbfunction name="sPart"	args="c.Cdescripcion,1, 40"> as Cdescripcion, 
			a.nivel, 
			a.saldoini, 
			a.debitos, 
			a.creditos, 
			a.saldofin,
			a.Cdetalle
		from #reporte# a
			inner join CContables c
				on c.Ccuenta = a.Ccuenta
		<cfif isdefined("form.ID_NoIncluir")>
			where a.debitos <> 0.00 or a.creditos <> 0.00
		<cfelse>
			where a.saldoini <> 0.00 or a.debitos <> 0.00 or a.creditos <> 0.00
		</cfif>
		order by c.Cformato
	</cfquery>
	<cfset fnPintaReporte()>

	<!--- Verifica que el reporte quede generado correctamente --->
	<cfquery datasource="#Session.DSN#">
		update tbl_reportescf
		set FechaFin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		where IDReporte = #idReporte#
	</cfquery>
</cffunction>

<cffunction name="fnProgramaReporte" access="private" output="no" returntype="any">
	<!--- ------------------------------------------------ --->
	<!--- Programacion de los reportes                     --->
	<!--- en este caso se hace un insert a la tabla        --->
	<!--- de trabajo en la cual se guarda los parametros   --->
	<!--- del reporte y la hora en que sera ejecutado      --->
	<!--- luego un proceso demonio se encargara de ejecutar--->
	<!--- cada uno de los reportes                         --->
	<!--- ------------------------------------------------ --->

	<cfset fnObtieneCuentaidList()>

	<cfset Hora =trim(form.HORA)>
	<cfif trim(form.PMAM) eq "PM" and form.HORA LT 12 >
		<cfset Hora =trim(form.HORA) + 12>
	</cfif>

	<cfset LvarFechaHora = createdate(year(now()),month(now()), day(now()))>
	<cfset LvarFechaHora = dateadd('h', form.hora, LvarFechaHora)>
	<cfset LvarFechaHora = dateadd('n', form.minutos, LvarFechaHora)>
	
	<cfquery datasource="#session.dsn#"  name="sql" >
		INSERT into tbl_archivoscf (
			Usuario,
			Status,
			BorrarArch,
			Ecodigo,
			TpoRep,
			FechaSolic,
			HoraEjecuta,    
			MinEjecuta,      
			ListaCuenta,     
			Periodo,         
			MesIni,          
			MesFin,         
			Mcodigo,       
			Ofi_Emp,       
			TpoImpresion,
			BMUsucodigo
		)
		VALUES (
			#Session.Usucodigo#,
			'P',
			'S',
			#session.Ecodigo#,
			#form.ID_REPORTE#,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaHora#">,
			<cfqueryparam  cfsqltype="cf_sql_integer"  value="#Hora#">,
			<cfqueryparam cfsqltype="cf_sql_integer"  value="#trim(form.MINUTOS)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(CuentaidList)#">,
			<cfqueryparam cfsqltype="cf_sql_integer"   value="#form.Periodos#">,
			<cfqueryparam cfsqltype="cf_sql_integer"   value="#form.MesInicial#">,
			<cfqueryparam cfsqltype="cf_sql_integer"   value="#form.MesFinal#">,
			<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined("form.UBICACION") and len(trim(form.UBICACION))>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ubicacion#">,
			<cfelse>
				null,
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_integer"   value="#form.TipoFormato#">,
			#Session.Usucodigo#
		)
	</cfquery>
</cffunction>

<cffunction name="fnObtieneCuentaidList" access="private" output="no" returntype="any">
	<cfswitch expression="#form.ID_REPORTE#">
		<cfcase value="1">
			<cfset CuentaidList =  form.CtaFinal & '|' &form.nivelDet  & '|' & form.nivelTot >
		</cfcase>
		<cfcase value="2">
			<cfset CuentaidList = form.cuentaidlist>
	
			<cfset ArregloCuentas = ListToArray(CuentaidList,',')>
			<cfset Lstcuenta1 = ArregloCuentas[1]>
			<cfset Lstcuenta2 = ArregloCuentas[2]>
			
			<cfset Arrcuenta1 = ListToArray(Lstcuenta1,"|")>
			<cfset Arrcuenta2 = ListToArray(Lstcuenta2,"|")>
	
			<cfset Arrcuenta1[2] = form.nivelDet>
			<cfset Arrcuenta2[2] = form.nivelDet>
	
			<cfset Arrcuenta1[3] = form.nivelTot>
			<cfset Arrcuenta2[3] = form.nivelTot>
	
			<cfset CuentaidList = trim(Arrcuenta1[1]) & "|" & trim(Arrcuenta1[2]) & "|" & trim(Arrcuenta1[3]) & "," & trim(Arrcuenta2[1]) & "|" & trim(Arrcuenta2[2]) & "|" & trim(Arrcuenta2[3])>
	
		</cfcase>
		<cfcase value="3">
	
			<cfset CuentaidList = form.CuentaidList>
			<cfset Lstfinal = "">
			<cfset ArregloCuentas = ListToArray(CuentaidList,',')>
			<cfset fin = ArrayLen(ArregloCuentas)>	
	
			<cfloop from="1" to="#fin#" step="1" index="ind">
	
				<cfset Lstcuenta1 = ArregloCuentas[ind]>			
				<cfset Arrcuenta1 = ListToArray(Lstcuenta1,"|")>
	
				<cfset Arrcuenta1[2] = form.nivelDet>
				<cfset Arrcuenta1[3] = form.nivelTot>
	
				<cfset hilera =  trim(Arrcuenta1[1]) & "|" & trim(Arrcuenta1[2]) & "|" & trim(Arrcuenta1[3])>
				<cfif Lstfinal eq "">
					<cfset Lstfinal = hilera>
				<cfelse>
					<cfset Lstfinal = Lstfinal & "," & hilera>
				</cfif>
	
			</cfloop>
			<cfset CuentaidList = Lstfinal>
		</cfcase>
	</cfswitch>

	<cfset ListaAsientos="">
	<cfif isdefined("AsieContidList") and len(trim(AsieContidList)) gt 0>
		<cfloop list="#AsieContidList#" index="indast" delimiters=",">
			<cfset LstAst=ListToArray(indast,'|')>
			<cfset Vast = LstAst[1]>
			<cfif ListaAsientos eq "">
				<cfset ListaAsientos = Trim(Vast)>
			<cfelse>
				<cfset ListaAsientos = ListaAsientos & "," & Trim(Vast)>
			</cfif>
		</cfloop>
	</cfif>

</cffunction>

<cffunction name="fnPreparaParametros" access="private" output="no" returntype="any">
	<!--- ------------------------------------------------ --->
	<!--- Preparación de los parámetros                     --->
	<!--- ------------------------------------------------ --->
	<cfset fnObtieneCuentaidList()>

	<!--- ------------------------------------------------ --->
	<!--- Insert de los parámetros                          --->
	<!--- ------------------------------------------------ --->
	<cftransaction>
		<cfquery datasource="#session.dsn#" name="inserta">
			INSERT into tbl_reportescf (
				Usuario,
				Ecodigo,
				TpoRep,
				FechaEjec,
				ListaCuenta,
				Asientos,
				Periodo,
				MesIni,
				MesFin,
				Ofi_Emp,
				TpoImpresion,
				BMUsucodigo
			)
			VALUES (
				#Session.Usucodigo#,
				#session.Ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_REPORTE#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam  cfsqltype="cf_sql_varchar"  value="#trim(CuentaidList)#">,
				<cfif len(trim(ListaAsientos)) GT 0>
					<cfqueryparam  cfsqltype="cf_sql_varchar"  value="#trim(ListaAsientos)#">,
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer"   value="#form.Periodos#">,
				<cfqueryparam cfsqltype="cf_sql_integer"   value="#form.MesInicial#">,
				<cfqueryparam cfsqltype="cf_sql_integer"   value="#form.MesFinal#">,
				<cfif isdefined("form.UBICACION") and len(trim(form.UBICACION))>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ubicacion#">,
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer"   value="#form.TipoFormato#">,
				#Session.Usucodigo#
			)
			<cf_dbidentity1 datasource="#Session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#Session.DSN#" name="inserta">
	</cftransaction>
	<cfset idReporte = inserta.identity>

	<!--- 
			Validación de los paramtros enviados en el form
			DEFINICION  DE VARIABLE ID_REPORTE:
				1 - SALDOS PARA 1 CUENTA 
				2 - SALDOS PARA RANGO
				3 - SALDOS PARA LISTA DE CUENTAS
	--->
	
	<!--- ------------------------------------------------ --->
	<!---Manejo de las empresas y oficinas                 --->
	<!--- ------------------------------------------------ --->
	<cfset LvarNombreEmpresa = "">
	<cfset Oficina  = true>
	<cfset Empresa  = false>
	<cfset POficinas = "">
	<cfset ListaOficinas  = "">
	<cfset ListaEmpresas  = session.Ecodigo>
	<cfset PEmpresas      = session.Enombre>

	<cfset mySLinicial = "SLinicial">
	<cfset mySOinicial = "SOinicial">
	<cfif isdefined("form.ubicacion") and len(trim(form.ubicacion))>
		<cfset LarrUbicacion = ListToarray(form.ubicacion)>
			<cfif 	len(trim(LarrUbicacion[1])) and LarrUbicacion[1] eq 'ge'>   <!--- GRUPO DE EMPRESAS --->
				<cfset mySLinicial = "SLinicialGE">
				<cfset mySOinicial = "SOinicialGE">
				<cfset Oficina  = false>
				<cfset POficinas = "Todas">
				<cfset Empresa   = true>
				<cfquery name="rsGE" datasource="#session.DSN#">
					select gd.Ecodigo, em.Enombre
					from AnexoGEmpresa ge
						join AnexoGEmpresaDet gd
							on ge.GEid = gd.GEid
						join Empresa em
							on em.Ecodigo = gd.Ecodigo	
					where ge.CEcodigo = #session.CEcodigo# 
					  and ge.GEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LarrUbicacion[2]#">
					order by ge.GEnombre
				 </cfquery>
				 <cfif rsGE.recordcount gt 0>
					<cfset ListaEmpresas ="">
					<cfset PEmpresas ="">
					<cfloop query="rsGE" >
						<cfset ListaEmpresas  = ListaEmpresas & rsGE.Ecodigo>
						<cfset PEmpresas  = PEmpresas & rsGE.Enombre>
						<cfif rsGE.currentRow neq rsGE.recordcount>
							<cfset ListaEmpresas = ListaEmpresas & ",">
							<cfset PEmpresas = PEmpresas & ", ">
						</cfif>	
					</cfloop>
				 </cfif>
		 		<cfquery name="rsNombreEmpresa" datasource="#Session.DSN#">
					select ge.GEnombre as Edescripcion
					from AnexoGEmpresa ge
					where ge.CEcodigo = #session.CEcodigo# 
					  and ge.GEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LarrUbicacion[2]#">
				</cfquery>

			<cfelseif    len(trim(LarrUbicacion[1])) and LarrUbicacion[1] eq 'go'>   <!--- GRUPO DE OFICINAS --->
				<cfset Empresa  = false>
				<cfset Oficina  = true>
				<cfquery name="rsGO" datasource="#session.DSN#">
					select gd.Ocodigo ,Oficodigo 
					from AnexoGOficina ge
						join AnexoGOficinaDet  gd
							on ge.GOid= gd.GOid
						join Oficinas ofi
							on gd.Ocodigo= ofi.Ocodigo	
							and gd.Ecodigo= ofi.Ecodigo
					where ge.GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LarrUbicacion[2]#">
				</cfquery>	
				<cfif rsGO.recordcount gt 0>
					<cfloop query="rsGO" >
						<cfset ListaOficinas  = ListaOficinas & rsGO.Ocodigo>
						<cfset POficinas      = POficinas & rsGO.Oficodigo>
						<cfif rsGO.currentRow neq rsGO.recordcount>
							<cfset ListaOficinas = ListaOficinas & ",">
							<cfset POficinas     = POficinas & ", ">
						</cfif>	
					</cfloop>
				 </cfif>					
				<cfquery name="rsNombreEmpresa" datasource="#Session.DSN#">
					select Edescripcion
					from Empresas
					where Ecodigo =  #Session.Ecodigo# 
				</cfquery>
			<cfelseif   len(trim(LarrUbicacion[1])) and LarrUbicacion[1] eq 'of'>  <!--- UNA OFICINAS --->
				<cfset Empresa  = false>
				<cfset Oficina  = true>
				<cfset ListaOficinas  = LarrUbicacion[2]>
				<cfquery name="rsGO" datasource="#session.DSN#">
					select Oficodigo  from Oficinas 
					where Ecodigo =  #session.Ecodigo#
					and  Ocodigo = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#LarrUbicacion[2]#">
				</cfquery>
				<cfset POficinas      = POficinas & rsGO.Oficodigo>
				<cfquery name="rsNombreEmpresa" datasource="#Session.DSN#">
					select Edescripcion
					from Empresas
					where Ecodigo =  #Session.Ecodigo# 
				</cfquery>
			</cfif>
	<cfelse>
		<cfquery name="rsNombreEmpresa" datasource="#Session.DSN#">
			select Edescripcion
			from Empresas
			where Ecodigo = #Session.Ecodigo#
		</cfquery>
	
		<cfset POficinas = "Todas">
		<cfset Oficina  = false>
		<cfset Empresa  = false>
	</cfif>

	<cfif rsNombreEmpresa.recordcount GT 0>
		<cfset LvarNombreEmpresa = rsNombreEmpresa.Edescripcion>
	</cfif>

	<!--- Nombre del Archivo          --->
	<cfswitch expression="#form.ID_REPORTE#">
		<cfcase value="1">
			<cfset Namefile =  session.usuario&"_REPUNACUENTA" >
		</cfcase>
		<cfcase value="2">
			<cfset Namefile =  session.usuario&"_REPRANGOCUENTA" >
		</cfcase>
		<cfcase value="3">
			<cfset Namefile =  session.usuario&"_REPLISTACUENTA" >
		</cfcase>
	</cfswitch>	

	<cfset TituloReporte = "Reporte de Saldos por Cuenta">
	<cfswitch expression="#Id_Reporte#">
		<cfcase value="1"> 
			<cfset TituloReporte = "Reporte de Saldos por Cuenta">
		</cfcase>
		<cfcase value="2"> 
			<cfset TituloReporte = "Reporte de Saldos por Rango de Cuentas">
		</cfcase>
		<cfcase value="3"> 
			<cfset TituloReporte = "Reporte de Saldos por Lista de Cuentas">
		</cfcase>
	</cfswitch>	

	<!--- DEFINICION DE LOS MESES     --->
	<cfif isdefined("form.MesInicial") and len(trim(form.MesInicial))>
		<cfif form.MesInicial EQ 1>
			<cfset MesInicial = "Enero">
		</cfif>
		<cfif form.MesInicial EQ 2 >
			<cfset MesInicial = "Febrero">
		</cfif>
		<cfif form.MesInicial EQ 3 >
			<cfset MesInicial = "Marzo">
		</cfif>
		<cfif form.MesInicial EQ 4 >
			<cfset MesInicial = "Abril">
		</cfif>
		<cfif form.MesInicial EQ 5 >
			<cfset MesInicial = "Mayo">
		</cfif>
			<cfif form.MesInicial EQ 6 >
		<cfset MesInicial = "Junio">
		</cfif>
		<cfif form.MesInicial EQ 7 >
			<cfset MesInicial = "Julio">
		</cfif>
		<cfif form.MesInicial EQ 8 >
			<cfset MesInicial = "Agosto">
		</cfif>
		<cfif form.MesInicial EQ 9 >
			<cfset MesInicial = "Septiembre">
		</cfif>
		<cfif form.MesInicial EQ 10 >
			<cfset MesInicial = "Octubre">
		</cfif>
		<cfif form.MesInicial EQ 11 >
			<cfset MesInicial = "Noviembre">
		</cfif>
		<cfif form.MesInicial EQ 12 >
			<cfset MesInicial = "Diciembre">
		</cfif>
	</cfif>
	<cfif isdefined("form.MesFinal") and len(trim(form.MesFinal))>
		<cfif form.MesFinal EQ 1>
			<cfset MesFinal = "Enero">
		</cfif>
		<cfif form.MesFinal EQ 2>
			<cfset MesFinal = "Febrero">
		</cfif>
		<cfif form.MesFinal EQ 3>
			<cfset MesFinal = "Marzo">
		</cfif>
		<cfif form.MesFinal EQ 4>
			<cfset MesFinal = "Abril">
		</cfif>
		<cfif form.MesFinal EQ 5>
			<cfset MesFinal = "Mayo">
		</cfif>
		<cfif form.MesFinal EQ 6>
			<cfset MesFinal = "Junio">
		</cfif>
		<cfif form.MesFinal EQ 7>
			<cfset MesFinal = "Julio">
		</cfif>
		<cfif form.MesFinal EQ 8>
			<cfset MesFinal = "Agosto">
		</cfif>
		<cfif form.MesInicial EQ 9>
			<cfset MesFinal = "Septiembre">
		</cfif>
		<cfif form.MesFinal EQ 10>
			<cfset MesFinal = "Octubre">
		</cfif>
		<cfif form.MesInicial EQ 11>
			<cfset MesFinal = "Noviembre">
		</cfif>
		<cfif form.MesFinal EQ 12>
			<cfset MesFinal = "Diciembre">
		</cfif>
	</cfif>

	<cfset TituloCalcDesc = "Todas las Oficinas">
	<cfif isdefined("form.ubicacion") and len(trim(form.ubicacion))>
		<cfset LarrUbicacion = ListToarray(form.ubicacion)>
		<cfif 	len(trim(LarrUbicacion[1])) and LarrUbicacion[1] eq 'ge'>   <!--- GRUPO DE EMPRESAS --->
			<cfquery name="rsTituloDescripcion" datasource="#Session.DSN#">
				select ge.GEnombre as Descripcion
				from AnexoGEmpresa ge
				where ge.CEcodigo = #session.CEcodigo# 
				  and ge.GEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LarrUbicacion[2]#">
			</cfquery>
		<cfelseif    len(trim(LarrUbicacion[1])) and LarrUbicacion[1] eq 'go'>   <!--- GRUPO DE OFICINAS --->
			<cfquery name="rsTituloDescripcion" datasource="#Session.DSN#">
				select GOnombre as Descripcion
				from AnexoGOficina ge
				where ge.GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LarrUbicacion[2]#">
			</cfquery>
		<cfelseif   len(trim(LarrUbicacion[1])) and LarrUbicacion[1] eq 'of'>  <!--- UNA OFICINAS --->
			<cfquery name="rsTituloDescripcion" datasource="#session.DSN#">
				select ltrim(rtrim(Oficodigo)) + ' - ' + ltrim(rtrim(Odescripcion)) as Descripcion
				from Oficinas 
				where Ecodigo =  #session.Ecodigo#
				and  Ocodigo = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#LarrUbicacion[2]#">
			</cfquery>
		</cfif>
		<cfset TituloCalcDesc = rsTituloDescripcion.Descripcion>	
	</cfif>
</cffunction>

<cffunction name="fnCreaTablasTemporales" access="private" output="no" hint="Crea las tablas temporales para el procesamiento de la informacion">
	<cf_dbtemp name="ReporteConta" returnvariable="reporte">
		<cf_dbtempcol name="Ecodigo"  		type="integer">
		<cf_dbtempcol name="Ccuenta"  		type="numeric">
		<cf_dbtempcol name="nivel"    		type="integer">
		<cf_dbtempcol name="saldoini" 		type="money">
		<cf_dbtempcol name="debitos"  		type="money">
		<cf_dbtempcol name="creditos" 		type="money">
		<cf_dbtempcol name="saldofin" 		type="money">
		<cf_dbtempcol name="NivDet" 		type="integer">
		<cf_dbtempcol name="Speriodo"  		type="integer" mandatory="no">
		<cf_dbtempcol name="Smes1"     		type="integer" mandatory="no">
		<cf_dbtempcol name="Smes2"     		type="integer" mandatory="no">
		<cf_dbtempcol name="Cdetalle"  		type="integer" mandatory="no">
	</cf_dbtemp>

	<cf_dbtemp name="CtasNiv" returnvariable="cubo">
		<cf_dbtempcol name="Ccuentaniv"  	type="numeric">
		<cf_dbtempcol name="Ccuenta"     	type="numeric"  mandatory="yes">
		<cf_dbtempcol name="Speriodo"  		type="integer">
		<cf_dbtempcol name="Smes1"  		type="integer">
		<cf_dbtempcol name="Smes2"  		type="integer">
		
		<cf_dbtempkey cols="Ccuentaniv, Ccuenta">
		<cf_dbtempindex cols="Ccuentaniv">
	</cf_dbtemp>

	<cf_dbtemp name="CtasNiv2" returnvariable="cubo2">
		<cf_dbtempcol name="Ccuentaniv"  	type="numeric">
		<cf_dbtempcol name="Ccuenta"     	type="numeric"  mandatory="yes">
		<cf_dbtempcol name="Speriodo"  		type="integer">
		<cf_dbtempcol name="Smes1"  		type="integer">
		<cf_dbtempcol name="Smes2"  		type="integer">
		<cf_dbtempkey cols="Ccuenta">
		<cf_dbtempindex cols="Ccuentaniv">
	</cf_dbtemp>
</cffunction>

<cffunction name="fnInsertaCuentas" access="private" output="no" hint="Llena la tabla temporal con las cuentas que se seleccionaron" returntype="numeric">
	<cfswitch expression="#form.ID_REPORTE#">
		<cfcase value="1">  <!--- 1 - SALDOS PARA 1 CUENTA           --->
			<cfset Pcuentas = trim(form.CTAFINAL)>
			<cfquery name="rsNivelesCuenta" datasource="#session.dsn#">
				select max(PCNid)  as NivelMascara
				from CtasMayor m
					inner join PCNivelMascara nm
					on nm.PCEMid = m.PCEMid
				where Ecodigo = #session.Ecodigo#
				  and Cmayor =  <cfqueryparam value="#trim(form.Cmayor)#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfif isdefined("rsNivelesCuenta") and len(trim(rsNivelesCuenta.NivelMascara)) GT 0 and rsNivelesCuenta.NivelMascara GT 0>
				<cfset LvarNivelDetalleCuenta = rsNivelesCuenta.NivelMascara>
			<cfelse>
				<cfset LvarNivelDetalleCuenta = 0>
			</cfif>
			<cfquery datasource="#session.dsn#">
				insert into #reporte# (
					Ecodigo,
					Ccuenta, 
					nivel,
					saldoini, debitos, creditos, saldofin, 
					Speriodo, 
					Smes1, 
					Smes2,
					Cdetalle, NivDet)
				select
					c.Ecodigo,
					c.Ccuenta, 
					<cfif LvarNivelDetalleCuenta GT 0>#LvarNivelDetalleCuenta#<cfelse>cu.PCDCniv</cfif>, 
					0.00, 0.00, 0.00, 0.00,
					<cf_jdbcquery_param value="#form.PERIODOS#" 	cfsqltype="cf_sql_integer">,
					<cf_jdbcquery_param value="#form.MESINICIAL#" 	cfsqltype="cf_sql_integer">,
					<cf_jdbcquery_param value="#form.MESFINAL#" 	cfsqltype="cf_sql_integer">,
					1, <cf_jdbcquery_param value="#form.NIVELDET#"  cfsqltype="cf_sql_integer">
				from CContables c
					<cfif LvarNivelDetalleCuenta EQ 0>
					inner join PCDCatalogoCuenta cu
						 on cu.Ccuenta    = c.Ccuenta
						and cu.Ccuentaniv = c.Ccuenta
					</cfif>
				where 
					<cfif Empresa eq true>
						c.Ecodigo in (#ListaEmpresas#)
					<cfelse>
						c.Ecodigo = #session.Ecodigo# 
					</cfif>
					and  c.Cmayor =      	<cfqueryparam value="#trim(form.Cmayor)#"	 cfsqltype="cf_sql_char">
					and  c.Cformato like 	<cfqueryparam value="#trim(form.CTAFINAL)#%" cfsqltype="cf_sql_varchar">
					and  c.Cmovimiento <> 'N'
			</cfquery>
		</cfcase>
		<cfcase value="2"><!---2 - SALDOS PARA RANGO            --->

			<cfset LarrCuentas  = ListToarray(cuentaidlist)>
			<cfset FormatoDesde = listtoarray(LarrCuentas[1],"|")>	
			<cfset FormatoDesde = FormatoDesde[1]>
			<cfset FormatoHasta = listtoarray(LarrCuentas[2],"|")>	
			<cfset FormatoHasta = FormatoHasta[1]>
			<cfset Pcuentas     = trim(LarrCuentas[1]) & "<br>" & trim(LarrCuentas[2])>
			<cfset cuentadesde  = Mid(trim(LarrCuentas[1]),1,4)> 
			<cfset cuentahasta  = Mid(trim(LarrCuentas[2]),1,4)>
			
			<cfquery datasource="#session.dsn#">
				insert into #reporte# (
					Ecodigo,
					Ccuenta, 
					nivel,
					saldoini, debitos, creditos, saldofin, 
					Speriodo, 
					Smes1, 
					Smes2,
					Cdetalle, NivDet)
				select
					c.Ecodigo,
					c.Ccuenta, 
					cu.PCDCniv, 
					0.00, 0.00, 0.00, 0.00,
					<cf_jdbcquery_param value="#form.PERIODOS#" 	cfsqltype="cf_sql_integer">,
					<cf_jdbcquery_param value="#form.MESINICIAL#" 	cfsqltype="cf_sql_integer">,
					<cf_jdbcquery_param value="#form.MESFINAL#"     cfsqltype="cf_sql_integer">,
					1, <cf_jdbcquery_param value="#form.NIVELDET#"  cfsqltype="cf_sql_integer"> 
				from CContables c
					inner join PCDCatalogoCuenta cu
						 on cu.Ccuenta    = c.Ccuenta
						and cu.Ccuentaniv = c.Ccuenta
				where 
					<cfif Empresa eq true>
						c.Ecodigo in (#ListaEmpresas#)
					<cfelse>
						c.Ecodigo =   #session.Ecodigo#  
					</cfif>
				  and  c.Cmayor     >=	<cfqueryparam value="#cuentadesde#" cfsqltype="cf_sql_char">
				  and  c.Cmayor     <=	<cfqueryparam value="#cuentahasta#" cfsqltype="cf_sql_char">
				  and  c.Cformato   >=	<cfqueryparam value="#trim(FormatoDesde)#" cfsqltype="cf_sql_varchar">
				  and  c.Cformato   <=  <cfqueryparam value="#trim(FormatoHasta)#" cfsqltype="cf_sql_varchar">
				  and  c.Cmovimiento <> 'N'
			</cfquery>
		</cfcase>
		<cfcase value="3"><!---3 - SALDOS PARA LISTA DE CUENTAS --->
			<cfset cuentalista = CuentaidList>
			<cfset LarrCuentas = ListToarray(cuentalista)>	
			<cfset Pcuentas = "">
			<cfloop index="i"  from="1" to="#ArrayLen(LarrCuentas)#">
				<cfset arreglo = listtoarray(LarrCuentas[i],"|")>	
				<cfset cuenta = "#arreglo[1]#">
				<cfset Pcuentas = Pcuentas & trim(arreglo[1]) & "<br>" >
				<cfset cMayor = mid(cuenta,1,4)>
				<cfset NIVELDET = "#arreglo[2]#">
				<cfset NIVELTOT = "#arreglo[3]#">

				<cfquery name="rsNivelesCuenta" datasource="#session.dsn#">
					select max(PCNid)  as NivelMascara
					from CtasMayor m
						inner join PCNivelMascara nm
						on nm.PCEMid = m.PCEMid
					where Ecodigo = #session.Ecodigo#
					  and Cmayor =  <cfqueryparam value="#cMayor#" cfsqltype="cf_sql_char">
				</cfquery>
				<cfif isdefined("rsNivelesCuenta") and len(trim(rsNivelesCuenta.NivelMascara)) GT 0 and rsNivelesCuenta.NivelMascara GT 0>
					<cfset LvarNivelDetalleCuenta = rsNivelesCuenta.NivelMascara>
				<cfelse>
					<cfset LvarNivelDetalleCuenta = 0>
				</cfif>


				<cfquery datasource="#session.dsn#">
					insert into #reporte# (
						Ecodigo,
						Ccuenta, 
						nivel,
						saldoini, debitos, creditos, saldofin, 
						Speriodo, 
						Smes1, 
						Smes2,
						Cdetalle, NivDet)
					select
						c.Ecodigo,
						c.Ccuenta, 
						<cfif LvarNivelDetalleCuenta GT 0>#LvarNivelDetalleCuenta#<cfelse>cu.PCDCniv</cfif>, 
						0.00, 0.00, 0.00, 0.00,
						<cf_jdbcquery_param value="#form.PERIODOS#" 	cfsqltype="cf_sql_integer">,
						<cf_jdbcquery_param value="#form.MESINICIAL#" 	cfsqltype="cf_sql_integer">,
						<cf_jdbcquery_param value="#form.MESFINAL#" 	cfsqltype="cf_sql_integer">,
						1, <cf_jdbcquery_param value="#form.NIVELDET#"  cfsqltype="cf_sql_integer"> 
					from CContables c
						<cfif LvarNivelDetalleCuenta EQ 0>
							inner join PCDCatalogoCuenta cu
								 on cu.Ccuenta    = c.Ccuenta
								and cu.Ccuentaniv = c.Ccuenta
						</cfif>
					where 
						<cfif Empresa eq true>
							c.Ecodigo in (#ListaEmpresas#)
						<cfelse>
							c.Ecodigo =  #session.Ecodigo# 
						</cfif>
						and  c.Cmayor =      	<cfqueryparam value="#trim(cMayor)#"  cfsqltype="cf_sql_char">
						and  c.Cformato like 	<cfqueryparam value="#trim(cuenta)#%" cfsqltype="cf_sql_varchar">
						and  c.Cmovimiento <> 'N'
						and not exists(
								select 1
								from #reporte# r2
								where r2.Ccuenta = c.Ccuenta
							)
				</cfquery>
			</cfloop>
		</cfcase>
	</cfswitch>
	<cfquery name="rsCantidad" datasource="#session.dsn#">
		select count(1) as Cantidad
		from #reporte#
	</cfquery>
	<cfreturn rsCantidad.Cantidad>
</cffunction>

<cffunction name="fnActualizaDatos" access="private" output="no" hint="Actualiza los datos de la tabla temporal">
	<!--- Actualizar los Saldos Iniciales de las Cuentas Seleccionadas --->
	<cfquery datasource="#session.dsn#">
		update #reporte#
		set saldoini = coalesce((
				select 
				<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
					sum(s.#mySOinicial#) 
				<cfelse>
					sum(s.#mySLinicial#)
				</cfif>
				from SaldosContables s
				where s.Ccuenta  = #reporte#.Ccuenta
				  and s.Speriodo = #reporte#.Speriodo
				  and s.Smes     = #reporte#.Smes1
				<cfif Oficina eq true>
					and s.Ocodigo in (#ListaOficinas#)
				</cfif>
				<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
					and s.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
				</cfif>
				) , 0.00)
	</cfquery>

	<cfif len(trim(ListaAsientos)) GT 0>
		<cfquery datasource="#session.dsn#">
			update #reporte#
			set debitos = coalesce((
					select 
					<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
						sum(m.Doriginal) 
					<cfelse>
						sum(m.Dlocal)
					</cfif>
					from HDContables m <!--- <cf_dbforceindex name="HDContables_Index1"> --->
 						inner join HEContables me
						on me.IDcontable = m.IDcontable
					where m.Ccuenta     =  #reporte#.Ccuenta
					  and m.Eperiodo    =  #reporte#.Speriodo
					  and m.Emes        >= #reporte#.Smes1
					  and m.Emes        <= #reporte#.Smes2
					  and m.Dmovimiento = 'D'
					<cfif not isdefined("chkAstCierre")> 
					  	and me.ECtipo     <> 1
					</cfif>
					<cfif Oficina eq true>
						and m.Ocodigo in (#ListaOficinas#)
					</cfif>	
					<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
						and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
					</cfif>
					  and m.Cconcepto in (#ListaAsientos#)
					) , 0.00)
		</cfquery>
		<!--- Actualizar los Creditos de las Cuentas --->
		<cfquery datasource="#session.dsn#">
			update #reporte#
			set creditos = coalesce((
					select 
					<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
						sum(m.Doriginal) 
					<cfelse>
						sum(m.Dlocal)
					</cfif>
					from HDContables m <!--- <cf_dbforceindex name="HDContables_Index1"> --->
						inner join HEContables me
						on me.IDcontable = m.IDcontable
					where m.Ccuenta     =  #reporte#.Ccuenta
					  and m.Eperiodo    =  #reporte#.Speriodo
					  and m.Emes        >= #reporte#.Smes1
					  and m.Emes        <= #reporte#.Smes2
					  and m.Dmovimiento = 'C'
					<cfif not isdefined("chkAstCierre")> 
						  and me.ECtipo <>  1
					</cfif>	
					<cfif Oficina eq true>
						and m.Ocodigo in (#ListaOficinas#)
					</cfif>	
					<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
						and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
					</cfif>
					  and m.Cconcepto in (#ListaAsientos#)
					) , 0.00)
		</cfquery>
	<cfelse>
		<!--- Actualizar los Debitos de las Cuentas --->
		<cfquery datasource="#session.dsn#">
			update #reporte#
			set debitos = coalesce((
					select 
					<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
						sum(s.DOdebitos) 
					<cfelse>
						sum(s.DLdebitos)
					</cfif>
					from SaldosContables s
					where s.Ccuenta  =  #reporte#.Ccuenta
					  and s.Speriodo =  #reporte#.Speriodo
					  and s.Smes     >= #reporte#.Smes1
					  and s.Smes     <= #reporte#.Smes2
					<cfif Oficina eq true>
						and s.Ocodigo in (#ListaOficinas#)
					</cfif>	
					<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
						and s.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
					</cfif>
					) , 0.00)
		</cfquery>
        
		<!--- Actualizar los Debitos de las Cuentas para asientos de cierre--->
		<cfif isdefined("chkAstCierre")>
        	<cfquery name="rsAsientosCierre" datasource="#session.dsn#">
            	select distinct IDcontable 
                from HEContables
                where ECtipo     = 1
                and Ecodigo = #session.Ecodigo#
                and Eperiodo = <cf_jdbcquery_param value="#form.PERIODOS#" 	cfsqltype="cf_sql_integer">
                and Emes >= <cf_jdbcquery_param value="#form.MESINICIAL#" 	cfsqltype="cf_sql_integer">
				and Emes <= <cf_jdbcquery_param value="#form.MESFINAL#"     cfsqltype="cf_sql_integer">
            </cfquery>
			<cfset ListaAsientosCierre = valuelist(rsAsientosCierre.IDcontable, ',')>
        	<cfquery name="rsMesFiscal" datasource="#session.dsn#">
            	select Pvalor as UltMesFiscal 
                from Parametros
                where Ecodigo = #session.Ecodigo#
                and Pcodigo = 45
            </cfquery>
			<cfset LvarUltMesFiscal = rsMesFiscal.UltMesFiscal>            
			<cfquery datasource="#session.dsn#">
				update #reporte#
				set debitos = debitos + coalesce((
												select 
												<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
													sum(m.Doriginal) 
												<cfelse>
													sum(m.Dlocal)
												</cfif>
												from HDContables m <!--- <cf_dbforceindex name="HDContables_Index1"> --->
												where m.Ccuenta     =  #reporte#.Ccuenta
												  and m.Eperiodo    =  #reporte#.Speriodo
												  and m.Emes        =  #LvarUltMesFiscal#
												  and m.Eperiodo    = #form.PERIODOS#
												  and m.Ecodigo 	= #session.Ecodigo#
												  and m.Dmovimiento = 'D'
                                                  and <CF_whereInList column="m.IDcontable" valueList="#ListaAsientosCierre#">
												<cfif Oficina eq true>
													and m.Ocodigo in (#ListaOficinas#)
												</cfif>	
												<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
													and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
												</cfif>
												) , 0.00)
			</cfquery>

		</cfif>

		<!--- Actualizar los Creditos de las Cuentas --->
		<cfquery datasource="#session.dsn#">
			update #reporte#
			set creditos = coalesce((
					select 
					<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
						sum(s.COcreditos) 																							
					<cfelse>
						sum(s.CLcreditos)								
					</cfif>
					from SaldosContables s
					where s.Ccuenta  =  #reporte#.Ccuenta
					  and s.Speriodo =  #reporte#.Speriodo
					  and s.Smes     >= #reporte#.Smes1
					  and s.Smes     <= #reporte#.Smes2
					<cfif Oficina eq true>
						and s.Ocodigo in (#ListaOficinas#)
					</cfif>	
					<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
						and s.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
					</cfif>
					) , 0.00)
		</cfquery>
		
		<!--- Actualizar los Creditos de las Cuentas para asientos de cierre--->
		<cfif isdefined("chkAstCierre")>
			<cfquery datasource="#session.dsn#">
				update #reporte#
				set creditos = creditos + coalesce((
												select 
												<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
													sum(m.Doriginal) 
												<cfelse>
													sum(m.Dlocal)
												</cfif>
												from HDContables m <!--- <cf_dbforceindex name="HDContables_Index1"> --->
												where m.Ccuenta     =  #reporte#.Ccuenta
												  and m.Eperiodo    =  #reporte#.Speriodo
												  and m.Emes        =  #LvarUltMesFiscal#
												  and m.Eperiodo    = #form.PERIODOS#
												  and m.Ecodigo 	= #session.Ecodigo#
                                                  and <CF_whereInList column="m.IDcontable" valueList="#ListaAsientosCierre#">
												  and m.Dmovimiento = 'C'
												<cfif Oficina eq true>
													and m.Ocodigo in (#ListaOficinas#)
												</cfif>	
												<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
													and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
												</cfif>
												) , 0.00)
			</cfquery>				
		</cfif>		
		
	</cfif>
	<cfquery datasource="#Session.DSN#">
		update #reporte#
		set saldofin = saldoini + debitos - creditos
	</cfquery>
</cffunction>

<cffunction name="fnInsertaPadres" access="private" output="no" hint="Inserta las Cuentas Padre para el informe">
	<cfif form.TipoFormato NEQ 4>
		<!---   Generar el cubo en la tabla temporal. No se requiere si el reporte es resumido porque no se usa la tabla de cubo --->
		<cfquery datasource="#Session.DSN#">
			insert into #cubo# (Ccuenta, Ccuentaniv, Speriodo, Smes1, Smes2)
			select r.Ccuenta, cu.Ccuentaniv, r.Speriodo, r.Smes1, r.Smes2
			from #reporte# r
				inner join PCDCatalogoCuenta cu
				on  cu.Ccuenta = r.Ccuenta
				and cu.PCDCniv = r.NivDet 
		</cfquery>
	</cfif>
	
	<!---  Insertar las cuentas padre de las cuentas resultantes del proceso anterior --->
	<cfquery datasource="#Session.DSN#">
		insert into #reporte# (
			Ecodigo,
			Ccuenta, 
			nivel,
			saldoini, debitos, creditos, saldofin, 
			Speriodo, 
			Smes1, 
			Smes2,
			Cdetalle)
		select 
			r.Ecodigo,
			cu.Ccuentaniv, cu.PCDCniv,
			sum(r.saldoini), sum(r.debitos), sum(r.creditos), sum(r.saldofin),
			<cf_jdbcquery_param value="#form.PERIODOS#" 	cfsqltype="cf_sql_integer">,
			<cf_jdbcquery_param value="#form.MESINICIAL#" 	cfsqltype="cf_sql_integer">,
			<cf_jdbcquery_param value="#form.MESFINAL#"     cfsqltype="cf_sql_integer"> ,
			0
		from #reporte# r
			inner join PCDCatalogoCuenta cu
				 on cu.Ccuenta = r.Ccuenta
				<cfif form.NIVELTOT LTE form.NIVELDET>	
					and cu.PCDCniv in (#form.NIVELTOT#, #form.NIVELDET#)
				<cfelse>
					and cu.PCDCniv = #form.NIVELTOT#
				</cfif>
		where cu.Ccuentaniv <> r.Ccuenta
		group by r.Ecodigo, cu.Ccuentaniv, cu.PCDCniv
	</cfquery>
	
	<!---  Insertar la cuenta de mayor --->
	<cfif form.NIVELTOT neq 0>
		<cfquery datasource="#Session.DSN#">
			insert into #reporte# (
				Ecodigo,
				Ccuenta, 
				nivel,
				saldoini, debitos, creditos, saldofin, 
				Speriodo, 
				Smes1, 
				Smes2,
				Cdetalle)
			select 
				r.Ecodigo,
				cu.Ccuentaniv, cu.PCDCniv,
				sum(r.saldoini), sum(r.debitos), sum(r.creditos), sum(r.saldofin),
				<cf_jdbcquery_param value="#form.PERIODOS#"    cfsqltype="cf_sql_integer">,
				<cf_jdbcquery_param value="#form.MESINICIAL#"  cfsqltype="cf_sql_integer">,
				<cf_jdbcquery_param value="#form.MESFINAL#"    cfsqltype="cf_sql_integer"> ,
				0
			from #reporte# r
				inner join PCDCatalogoCuenta cu
					 on cu.Ccuenta = r.Ccuenta
					and cu.PCDCniv = 0
					and cu.Ccuentaniv <> r.Ccuenta
			group by r.Ecodigo, cu.Ccuentaniv, cu.PCDCniv
		</cfquery>
	</cfif>

	<!--- Borrar los registros que son mayores que el nivel de detalle seleccinado, Cuando el reporte no es por Asiento o Consecutivo --->
	<cfif form.NIVELDET GT form.NIVELTOT>
		<cfquery datasource="#Session.DSN#">
			delete from #reporte#
			where nivel > #form.NIVELDET#
		</cfquery>
	<cfelse>
		<cfquery datasource="#Session.DSN#">
			delete from #reporte#
			where nivel > #form.NIVELTOT#
		</cfquery>
	</cfif>
</cffunction>
