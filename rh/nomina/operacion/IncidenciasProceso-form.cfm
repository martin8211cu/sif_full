	<!---<cfdump var="#url#">	--->
	
	
	<!--- Averiguar rol. -1=Ninguno, 0=Usuario, 1=Jefe, 2=Administrador --->
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getRol" returnvariable="rol"/>
	
	<!---Validacion del rol--->
	<cfif listFindNoCase('0,1,2',rol,',') EQ 0>	
		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MS_NoAutorizado" default="No posee permisos para realizar esta accion. <br>Su usuario no esta registrado como Empleado, ni como Jefe, Autorizador &oacute; Usuario de alg&uacute;n Centro Funcional." xmlfile="/rh/generales.xml" returnvariable="MS_NoAutorizado"/>	
		<table border="0" cellpadding="0" cellspacing="0" width="90%" height="500" align="center"><tr><td>
		<center><cfoutput><strong>#MS_NoAutorizado#</strong></cfoutput></center>
		</td></tr></table>
		<cfabort>			
	</cfif>
	
	
	<!---Averiguar si se ingresa desde Autogestion o desde Nomina --->
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="validaLugarConsulta" returnvariable="Menu"/>
	
	<!--- Averigua si el usuario es empleado activo en al empresa actual--->
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getEmpleadoUsuario" returnvariable="rsDEidUser"/>
	
	<cfif rsDEidUser.RecordCount EQ 0><!---No es empleado--->
		<cfset UserDEid = 0>
	<cfelse>
		<cfset UserDEid = rsDEidUser.DEid>
	</cfif>
	
	<!---Si es jefe u autorizador averigua quienes son sus subalternos --->
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getSubalternos" returnvariable="rsSubalternos">
		<cfinvokeargument name="DEid" value="#UserDEid#"/>
	</cfinvoke>
	
	<!---Si es jefe averigua si es su propio jefe--->
	<cfif rol EQ 1>
		<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="EsSuJefe" returnvariable="EsSuJefe">
			<cfinvokeargument name="DEid" value="#UserDEid#"/>
		</cfinvoke>
	</cfif>
	
	<!---Averigua si el parametro 'Requiere aprobación incidencias' esta encendido --->
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="reqAprobacion">
		<cfinvokeargument name="Pcodigo" value="1010">
	</cfinvoke>
	
	<!---Averigua si el parametro 'Requiere aprobacion de Incidencias de tipo cálculo' esta encendido --->
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="reqAprobacionCalculo">
		<cfinvokeargument name="Pcodigo" value="1060"/>
	</cfinvoke>
	
	<!---Averigua si el parametro 'Requiere aprobacion de Incidencias por el Jefe del Centro Funcional' esta encendido --->
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="reqAprobacionJefe">
		<cfinvokeargument name="Pcodigo" value="2540"/>
	</cfinvoke>
	
	<!--- Es guatemala --->
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="getRT">
		<cfinvokeargument name="Pcodigo" value="30"/>
	</cfinvoke>
	
	<cfset aprobarIncidencias = false >
	<cfif reqAprobacion eq 1 >
		<cfset aprobarIncidencias = true >
	</cfif>
	
	<cfset aprobarIncidenciasCalc = false >
	<cfif reqAprobacionCalculo eq 1 >
		<cfset aprobarIncidenciasCalc = true >
	</cfif>	
	
	<cfset esGuatemala = false>
	<cfif getRT EQ 'IRCR2'>
		<cfset esGuatemala = true>
	</cfif>
	
	<!---**********************FILTROS PARA EL QUERY DE LA LISTA************************************************--->
	<cfif rol EQ 2>		<!---Ingresado desde nomina, cuando se ingresa desde nomina no importa si requiere aporbacion de incidencias u aprobacion por parte del jefe debido a que la incidencia se aprueba de forma automatica--->
		
		<cfset I_ingresadopor = '0,1,2'>					<!---Ingresa Administrador pero no deben visualizarse--->
		<cfset I_estado = 1>								<!---Aprobacion Directa del Administrador--->
		<cfset I_estadoAprobacion = 2>						<!---Aprobacion Directa del Jefe no importa si tiene o no--->
	
	<cfelse>												<!---Ingresado desde autogestion--->
		<cfif reqAprobacion EQ 1>
			<cfif reqAprobacionJefe EQ 1>
				
				<cfif rol EQ 1> 							<!---Jefe--->
					
															<!---Averigua si esta ingresando una incidencia para si mismo o para un subalterno--->
															<!---ASUNTO: averiguar si el jefe se puede aprobar sus propias incidencias (si esta dentro del centro funcional
															del que es autorizador o jefe) si es jefe o autorizador pero no posee su plaza dentro del centro funcional del que es 
															jefe u autorizador no puede auto aprobarse sus propias incidencias --->
					
					<cfset I_ingresadopor = 1>				<!---Ingresa Jefe--->
					<cfset I_estado = 0>					<!---Requiere aprobacion del Administrador--->
					<cfset I_estadoAprobacion = 0>			<!---Aprobacion Directa por ser Jefe, si es jefe e ingresa incidencia en 0 es su propia incidencia pero el no es us propio jefe, si ingresa incidencia en 2, propia o de un subalterno, mas las enviadas a aprobar no deben aparecer en esta pantalla. --->	
					
				<cfelseif rol EQ 0>	
					<cfset I_ingresadopor = 0>				<!---Ingresa Ususario--->
					<cfset I_estado = 0>					<!---Requiere aprobacion del Administrador--->
					<cfset I_estadoAprobacion = 0>			<!---Requiere aprobacion del Jefe--->	
				</cfif>
			
			<cfelse>
				<cfset I_ingresadopor = rol>						<!---Ingresa Jefe o Usuario--->
				<cfset I_estado = 0>								<!---Requiere aprobacion del Administrador--->
				<cfset I_estadoAprobacion = 2>						<!---Aprobacion Directa del Jefe no importa si tiene o no, por que no requiere aprobacion del jefe--->	
			</cfif>
		<cfelse>
				<cfset I_ingresadopor = rol>					<!---Ingresa Jefe o Usuario--->
				<cfset I_estado = 1>							<!---Aprobacion Directa por que no requiere aprobacion del administrador--->
				<cfset I_estadoAprobacion = 2>					<!---Aprobacion Directa del Jefe no importa si tiene o no, por que no requiere aprobacion del jefe al no requerir aprobacion del administrador--->
		</cfif>
	</cfif>
	
	<!--- Solo puede autoagregarse incidencias a si mismo --->
	<cfif rol EQ 0>
		<cfset url.DEid1 = UserDEid>
		<cfset url.DEid = UserDEid>
	</cfif>
	
	<!---<!---Filtro por estado de aprobacion--->
	<cfparam default="1" name="url.proceso_aprobacion"> --->
	
	<cfif isdefined("url.BTNEnviarAprobar") and reqAprobacion EQ 1 and isdefined("url.chk") and len(trim(url.chk))>
		<!--- Envio de aprobacion de incidencias --->
		<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="SolicitaAprobacion" returnvariable="vEnviado">
			<cfinvokeargument name="Iid" value="#url.chk#"/>
			<cfinvokeargument name="DEid" value="#UserDEid#"/>
		</cfinvoke>
		
	</cfif>
	
	<!---************************************************FIN************************************************--->
	
	
	<!---BOTON DE ENVIO DE APROBACION, si se encuentra en autogestion, si requiere aprobacion del jefe, y si es jefe que no sea su propio jefe--->
	<!---<cf_dump var="#rol# EQ 0 or (#rol# EQ 1 and not #EsSuJefe#)">--->
	<!---<cfset showBTNenvio = 0>
	<cfif Menu EQ 'AUTO'>
		<cfif reqAprobacionJefe EQ 1>
			<cfif rol EQ 0 or (rol EQ 1 and not EsSuJefe)>
				<cfset showBTNenvio = 1>
			</cfif>
		</cfif>
	</cfif>--->

	<cfif isdefined("url.Cambio")>  
		<cfset modo="CAMBIO">
	<cfelse>  
		<cfif not isdefined("url.modo")>    
			<cfset modo="ALTA">
		<cfelseif url.modo EQ "CAMBIO">
			<cfset modo="CAMBIO">
		<cfelse>
			<cfset modo="ALTA">
		</cfif>  
	</cfif>

<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select 	CIid, 
			{fn concat( { fn concat(rtrim(CIcodigo), ' - ') }, CIdescripcion) }  as Descripcion,
			CIcantmin, 
			CIcantmax, 
			CItipo
	from CIncidentes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and CItipo != 3 
	  and CIcarreracp = 0
	  
	 <cfif Menu EQ 'AUTO'>	<!---solo las visibles desde autogestion--->
	  	and CIautogestion = 1
	  </cfif>
	  
	order by Descripcion
</cfquery>

<cfset va_arrayvalues=ArrayNew(1)>

<!---activado en parametros generales--->
<cfquery name="rsCargarCF" datasource="#Session.DSN#">
	select Pvalor
		from RHParametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2105
</cfquery>

<!---<cfdump var="#modo NEQ 'ALTA'# AND #isdefined('Session.Ecodigo')# AND #isdefined('url.Iid')# AND #Len(Trim(url.Iid))# GT 0">--->
<cfif modo NEQ "ALTA" AND isdefined("Session.Ecodigo") AND isdefined("url.Iid") AND Len(Trim(url.Iid)) GT 0>	
	<cfquery name="rsIncidencia" datasource="#Session.DSN#">
		SELECT a.Iid, 
			   a.DEid, 
			   a.CIid, CIcodigo, CIdescripcion,
			   Ifecha as fecha, 
			   IfechaRebajo, 
			   a.Ivalor, 
			   a.Imonto,
			   a.Usucodigo, a.Ulocalizacion, 
				{fn concat({fn concat({fn concat({ fn concat( b.DEnombre, ' ') }, b.DEapellido1)}, ' ')}, b.DEapellido2) } as 	NombreEmp,
			   b.DEidentificacion,
			   b.DEtarjeta,
			   b.NTIcodigo,
			   a.CFid,
			   a.ts_rversion,
			   RHJid,
			   a.Icpespecial,
			   a.Iobservacion,
			   a.Iestadoaprobacion
		FROM CIncidentes c
			inner join  Incidencias a
				on a.CIid = c.CIid		
				inner join DatosEmpleado b
					on a.DEid = b.DEid
			
		WHERE c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Iid#">	
			
			<cfif rol EQ 1 and menu EQ 'AUTO'>	<!--- Solo los empleados subalternos--->
				and a.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#valueList(rsSubalternos.DEid)#">)
				or  a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#UserDEid#"> <!---Y el mismo--->
			</cfif>
			
			<cfif Menu EQ 'AUTO'>	<!---solo las visibles desde autogestion--->
				and c.CIautogestion = 1
		  	</cfif>
	</cfquery>
	
	<cfif isdefined("rsIncidencia.CIid")>
		<cfset ArrayAppend(va_arrayvalues, rsIncidencia.CIid)>
	</cfif>
	<cfif isdefined("rsIncidencia.CIcodigo")>
		<cfset ArrayAppend(va_arrayvalues, rsIncidencia.CIcodigo)>
	</cfif>
	<cfif isdefined("rsIncidencia.CIdescripcion")>
		<cfset ArrayAppend(va_arrayvalues, rsIncidencia.CIdescripcion)>
	</cfif>
	
	<cfif len(trim(rsIncidencia.CFid)) gt 0><cfset cfid = rsIncidencia.CFid ><cfelse><cfset cfid = -1 ></cfif>

	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFid, CFcodigo, CFdescripcion
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cfid#">
	</cfquery>
	
<cfelseif modo EQ "ALTA" AND isdefined("Session.Ecodigo") AND isdefined("url.DEid") AND Len(Trim(url.DEid)) NEQ 0>
	<cfquery name="rsEmpleadoDef" datasource="#Session.DSN#">
		select a.DEid, 
			   <cf_dbfunction name="concat" args="a.DEapellido1|' '|a.DEapellido2|', '|a.DEnombre" delimiters="|"> as 	NombreEmp,
		       a.DEidentificacion, 
			   a.NTIcodigo
		from DatosEmpleado a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfquery>
</cfif>

<!--- Usuarios que han insertado incidencias --->
<cfquery name="rsUsuariosRegistro" datasource="#Session.DSN#">
	select distinct coalesce(a.Usucodigo,-1) as Usucodigo
	from CIncidentes c
		inner join Incidencias a
			on c.CIid = a.CIid 	
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	
	 <cfif Menu EQ 'AUTO'>	<!---solo las visibles desde autogestion--->
		and c.CIautogestion = 1
	  </cfif>
</cfquery>

<cfquery name="rsUsuarios" datasource="asp">
	select 	u.Usucodigo as Codigo,
		  	{fn concat({fn concat({fn concat({ fn concat(d.Pnombre, ' ') }, d.Papellido1)}, ' ')}, d.Papellido2) } as Nombre
	from Usuario u	
		inner join DatosPersonales d
			on u.datos_personales = d.datos_personales
	<cfif rsUsuariosRegistro.recordCount GT 0>
		where u.Usucodigo in ( #ValueList(rsUsuariosRegistro.Usucodigo)# )
	<cfelse>
		where u.Usucodigo = 0
	</cfif>
</cfquery> 

<cfquery name="rsJornadas" datasource="#Session.DSN#">
	select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion
	from RHJornadas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfset navegacion = "" > 
<cfset filtro2 = ''>
<cfset va_arrayIncidencia=ArrayNew(1)>

<cfif isdefined("url.btnFiltrar") and not isdefined("form.btnFiltrar") and isdefined("url.pagenum_lista1") or isdefined("url.pagenum_lista2")>
	<cfset form.btnFiltrar=1>
</cfif>

<cfif isdefined("url.btnFiltrar")><cfset navegacion="&btnFiltrar=1"></cfif>

<cfset filtro = "b.Ecodigo = " & Session.Ecodigo >
<cfset filtro2 = "and b.Ecodigo = " & Session.Ecodigo >
<cfset filtro = filtro & " and a.CIid = b.CIid and a.DEid = c.DEid and CItipo <= 3" ><!------and CItipo != 3--->

<cfif isdefined("url.Usuario") and Len(Trim(url.Usuario)) NEQ 0 and url.Usuario NEQ "-1">
	<cfset form.usuario = url.usuario>
	<cfset filtro = filtro & " and a.Usucodigo = #url.Usuario#" >
	<cfset filtro2 = filtro2 & " and a.Usucodigo = #url.Usuario#" >
	<cfset navegacion = trim(navegacion) & "&Usuario=#url.Usuario#">	
<cfelseif isdefined("url.Usuario") and Len(Trim(url.Usuario)) NEQ 0 and url.Usuario EQ "-1">
	<cfset form.usuario = url.usuario>
	<cfset filtro = "b.Ecodigo = " & #Session.Ecodigo# >
	<cfset filtro = filtro & " and a.CIid = b.CIid and a.DEid = c.DEid and CItipo <= 3" ><!---and CItipo != 3--->
	<cfset navegacion = trim(navegacion) & "&Usuario=#url.Usuario#">	
<cfelse>	
	<cfset Form.Usuario = Session.Usucodigo>	
	<cfset filtro =  filtro & " and a.Usucodigo = " & Session.Usucodigo & " and a.Ulocalizacion = '" & Session.Ulocalizacion & "'">
	<cfset filtro2 =  filtro2 & " and a.Usucodigo = " & Session.Usucodigo & " and a.Ulocalizacion = '" & Session.Ulocalizacion & "'">
	<cfset navegacion = trim(navegacion) & "&Usuario=#form.Usuario#">	
</cfif>

<cfif isdefined("url.tab") and Len(Trim(url.tab))>
	<cfset form.tab = url.tab>
	<cfset navegacion = trim(navegacion) & "&tab=#url.tab#">	
</cfif>

<cfif isdefined("url.DEid1") and len(trim(url.DEid1)) gt 0 and not isdefined("form.DEid1") >
	<cfset form.DEid1=url.DEid1>
</cfif>

<cfif isdefined("url.DEid1") and len(trim(url.DEid1)) gt 0>
	<cfset navegacion = trim(navegacion) & "&DEid1=#url.DEid1#">
	<cfset filtro = filtro & " and a.DEid=" & url.DEid1>
	<cfset filtro2 = filtro2 & " and a.DEid=" & url.DEid1>
	
	<cfquery name="rsEmpleadoFiltro" datasource="#Session.DSN#">
		select a.DEid as DEid1, 
			   <cf_dbfunction name="concat" args="a.DEapellido1|' '|a.DEapellido2|', '|a.DEnombre" delimiters="|"> as 	NombreEmp1,
		       a.DEidentificacion as DEidentificacion1, 
			   a.NTIcodigo as NTIcodigo1
		from DatosEmpleado a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid1#">
	</cfquery>
	
</cfif>

<cfif isdefined("url.CIid_f") and len(trim(url.CIid_f)) gt 0 and not isdefined("form.CIid_f")>
	<cfset form.CIid_f=url.CIid_f>
</cfif>
<cfif isdefined("url.CIid_f") and len(trim(url.CIid_f)) gt 0>
	<cfset navegacion = trim(navegacion) & "&CIid_f=#url.CIid_f#">
	<cfset filtro = filtro & " and a.CIid=" & url.CIid_f>
	<cfset filtro2 = filtro2 & " and a.CIid=" & url.CIid_f>
	<cfquery name="rsCIid" datasource="#session.DSN#">
		select CIid, CIcodigo, CIdescripcion
		from CIncidentes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CIid_f#">
			<cfif Menu EQ 'AUTO'>	<!---solo las visibles desde autogestion--->
				and CIautogestion = 1
		  	</cfif>			
	</cfquery>
	<cfif isdefined("rsCIid.CIid")>
		<cfset ArrayAppend(va_arrayIncidencia, rsCIid.CIid)>
	</cfif>
	<cfif isdefined("rsCIid.CIcodigo")>
		<cfset ArrayAppend(va_arrayIncidencia, rsCIid.CIcodigo)>
	</cfif>
	<cfif isdefined("rsCIid.CIdescripcion")>
		<cfset ArrayAppend(va_arrayIncidencia, rsCIid.CIdescripcion)>
	</cfif>
</cfif>

<cfif isdefined("url.Ffecha") and len(trim(url.Ffecha)) gt 0 and not isdefined("url.Ffecha")>
	<cfset form.Ffecha=url.Ffecha>
</cfif>
<cfif isdefined("url.Ffecha") and len(trim(url.Ffecha)) gt 0 >
	<cfset navegacion = trim(navegacion) & "&Ffecha=#url.Ffecha#">	
	<cfset filtro = filtro & " and a.Ifecha =" & LSParseDateTime(url.Ffecha) >
	<cfset filtro2 = filtro2 & " and a.Ifecha =" & LSParseDateTime(url.Ffecha)>
</cfif>

<cfif isdefined("url.IfechaRebajo_f") and len(trim(url.IfechaRebajo_f)) gt 0 and not isdefined("form.IfechaRebajo_f")>
	<cfset form.IfechaRebajo_f=url.IfechaRebajo_f>
</cfif>
<cfif isdefined("url.IfechaRebajo_f") and len(trim(url.IfechaRebajo_f)) gt 0 >
	<cfset navegacion = trim(navegacion) & "&IfechaRebajo_f=#url.IfechaRebajo_f#">	
	<cfset filtro = filtro & " and a.IfechaRebajo  =" & LSParseDateTime(url.IfechaRebajo_f) >
	<cfset filtro2 = filtro2 & " and a.IfechaRebajo  =" & LSParseDateTime(url.IfechaRebajo_f)>
</cfif>

<cfif isdefined("url.CFid_f") and len(trim(url.CFid_f)) gt 0 and not isdefined("form.CFid_f")>
	<cfset form.CFid_f=url.CFid_f>
</cfif>
<cfif isdefined("url.CFid_f") and len(trim(url.CFid_f)) gt 0>
	<cfset navegacion = trim(navegacion) & "&CFid_f=#url.CFid_f#">
	<cfset filtro = filtro & " and CFid=" & url.CFid_f>
	<cfset filtro2 = filtro2 & " and CFid=" & url.CFid_f>
	<cfquery name="rsCfuncionalFiltro" datasource="#session.DSN#">
		select CFid as CFid_f, CFcodigo as CFcodigo_f, CFdescripcion as CFdescripcion_f
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid_f#">
	</cfquery>
</cfif>

<cfif isdefined("url.FIcpespecial_f") and len(trim(url.FIcpespecial_f)) and not isdefined("form.FIcpespecial_f")>
	<cfset form.FIcpespecial_f=url.FIcpespecial_f>
</cfif>
<cfif isdefined("url.FIcpespecial_f") and len(trim(url.FIcpespecial_f)) and url.FIcpespecial_f EQ 1>
	<cfset navegacion = trim(navegacion) & "&FIcpespecial_f=#url.FIcpespecial_f#">
	<cfset filtro = filtro & " and a.Icpespecial=1">
	<cfset filtro2 = filtro2 & " and a.Icpespecial=1">
<cfelse>
	<cfset filtro = filtro & " and a.Icpespecial=0">
	<cfset filtro2 = filtro2 & " and a.Icpespecial=0">
</cfif>

<!--- ============================================= --->
<!--- Traducciones --->
<!--- ============================================= --->
	<!--- Empleado --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Empleado"
		default="Empleado"
		xmlfile="/rh/generales.xml"
		returnvariable="vEmpleado"/>
	<!--- Concepto_Incidente --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="Concepto_Incidente"
		default="Concepto Incidente"
		xmlfile="/rh/generales.xml"
		returnvariable="vConcepto"/>		
	<!--- Fecha --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Fecha"
		default="Fecha"
		xmlfile="/rh/generales.xml"
		returnvariable="vFecha"/>		
	<!--- Boton Importar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Importar"
		default="Importar"
		xmlfile="/rh/generales.xml"
		returnvariable="vImportar"/>	
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_EnviarAprobar"
		default="Enviar Aprobar"
		xmlfile="/rh/generales.xml"
		returnvariable="vEnviarAprobar"/>
	<!----Boton Importar Calculo---->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_ImportarCalculo"
		default="Importar Cálculo"
		returnvariable="LB_ImportarCalculo"/>			
	<!--- Boton Filtrar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Filtrar"
		default="Filtrar"
		xmlfile="/rh/generales.xml"
		returnvariable="vFiltrar"/>		
	<!--- Cantidad/Monto --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Cantidad_Monto"
		default="Cantidad/Monto"
		returnvariable="vCantidadMonto"/>
	<!--- Cantidad horas --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Cantidad_Horas"
		default="Cantidad horas"
		returnvariable="vCantidadHoras"/>
	<!--- Cantidad dias --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Cantidad_Dias"
		default="Cantidad Dias"
		returnvariable="vCantidadDias"/>
	<!--- Monto --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Monto"
		default="Monto"
		xmlfile="/rh/generales.xml"
		returnvariable="vMonto"/>
	<!--- Valor --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Valor"
		default="Valor"
		xmlfile="/rh/generales.xml"		
		returnvariable="vValor"/>
	<!--- Monto Calculado --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_MontoCalculado"
		default="Monto Calculado*"
		xmlfile="/rh/generales.xml"		
		returnvariable="vMontoCalculado"/>	
	<!--- Validacion Cant.digitada fuera de rango --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_La_Cantidad_digitada_se_sale_del_rango_permitido"
		default="La Cantidad digitada se sale del rango permitido"
		returnvariable="vCantidadValidacion"/>
	<!--- No puede ser cero --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSG_No_puede_ser_cero"
		default="No puede ser cero"
		returnvariable="vNoCero"/>		
	<!--- Icpespecial --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_CP_Especiales"
		default="CP Especiales"
		returnvariable="vIcpespecial"/>
	<!---Lista conlis--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_ListaDeIncidencias"
		default="Lista de Incidencias"
		returnvariable="LB_ListaDeIncidencias"/>		
	<!---Etiqueta descripcion--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Descripcion"
		default="Descripci&oacute;n"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_Descripcion"/>
		
	<!---Etiqueta Observacion--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Observacion"
		default="Observaci&oacute;"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_Observacion"/>
	
	<!---Etiqueta Monto Calculado--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_NotaMontoCalculado"
		default=" Unicamente para  Incidencias tipo C&aacute;lculo. Representa el monto calculado de la incidencia"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_NotaMontoCalculado"/>
<!--- ============================================= --->
<!--- ============================================= --->

<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	var tipoConc= new Object();
	var rangoMin = new Object();
	var rangoMax = new Object();
	
	<cfloop query="rsConceptos">
		tipoConc['<cfoutput>#CIid#</cfoutput>'] = parseInt(<cfoutput>#CItipo#</cfoutput>);
		rangoMin['<cfoutput>#CIid#</cfoutput>'] = parseFloat(<cfoutput>#CIcantmin#</cfoutput>);
		rangoMax['<cfoutput>#CIid#</cfoutput>'] = parseFloat(<cfoutput>#CIcantmax#</cfoutput>);
	</cfloop>

	function validaForm(f) {
		f.obj.Ivalor.value = qf(f.obj.Ivalor.value);
		return true;
	}
	
	function changeValLabel() {
		var id = document.form1.CIid.value;
		var tipo = tipoConc[id];
		var a = document.getElementById("TDValorLabel");
		var t = null; 
		var t2 = null;
		switch (tipo) {
			<cfoutput>
			case 0: t = document.createTextNode("#vCantidadHoras#"); objForm.Ivalor.description = "#vCantidadHoras#"; break;
			case 1: t = document.createTextNode("#vCantidadDias#"); objForm.Ivalor.description = "#vCantidadDias#"; break;
			case 2: t = document.createTextNode("#vMonto#"); objForm.Ivalor.description = "#vMonto#"; break;
			default: t = document.createTextNode("#vValor#"); objForm.Ivalor.description = "#vValor#";
			</cfoutput>
		}
		if (a.hasChildNodes()) a.replaceChild(t,a.firstChild);
		else a.appendChild(t);
		// Habilitar/deshabilitar combo de jornadas
		var vs_trLabelJornada = document.getElementById("TRLabelJornada");
		var vs_trJornada = document.getElementById("TRJornada");
		if (tipo == 0 || tipo == 1){
			vs_trLabelJornada.style.display = '';
			vs_trJornada.style.display = '';
		}
		else{
			vs_trLabelJornada.style.display = 'none';
			vs_trJornada.style.display = 'none';		
		}
	}	
	//-->
</script>

<cfoutput>
<!---**********************************************************************************--->

<form  name="form1" method="get" action="IncidenciasProceso-sql.cfm" onSubmit="javascript: return validaForm(this);">
  <input type="hidden" name="Iingresadopor" value="#rol#" />
  <input type="hidden" name="Iestadoaprobacion" value="0" />
  <input type="hidden" name="usuCF" value="#session.Usucodigo#" />
  <input type="hidden" name="Ijustificacion" value="" />
  <input type="hidden" name="proc" value="<cfif menu EQ "AUTO">AUTO<cfelse>NOM</cfif>" />
  <cfparam name="url.tab" default="1">
  <input type="hidden" name="tab" value="#url.tab#" />
  	
	<cfif isdefined("url.PageNum1") and not isdefined("url.PageNum_Lista1")>
		<cfset url.PageNum_Lista1=url.PageNum1>
	</cfif>
	<cfif isdefined("url.PageNum_Lista1") and len(trim(url.PageNum_Lista1))>
  		<input name="PageNum_Lista1" type="hidden" value="#url.PageNum_Lista1#">
  	</cfif>
	
	<cfif isdefined("url.PageNum2") and not isdefined("url.PageNum_Lista2")>
		<cfset url.PageNum_Lista2=url.PageNum2>
	</cfif>
	<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
  		<input name="PageNum_Lista2" type="hidden" value="#url.PageNum_Lista2#">
  	</cfif>
	
  <table width="95%" align="center" border="0" cellspacing="0" cellpadding="1">
    <!---************************************* FILTROS ***************************************---->
    
	<cfif rsUsuarios.recordCount GT 0 >
      <tr>
        <td colspan="4"><table class="areaFiltro" width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="37%"><cfif session.menues.SMcodigo neq 'AUTO'>
                  <strong>
                    <cf_translate key="LB_Usuario" xmlfile="/rh/generales.xml">Usuario</cf_translate>
                    </strong><br />
                  <select name="Usuario" tabindex="1">
                    <!---onChange="javascript: this.form.submit();" --->
                    <option value="-1" <cfif isdefined("url.Usuario") and url.Usuario EQ "-1">selected</cfif>>(
                      <cf_translate key="LB_Todos" xmlfile="/rh/generales.xml">Todos</cf_translate>
                      )</option>
                    <cfloop query="rsUsuarios">
                      <option value="#rsUsuarios.Codigo#" <cfif form.Usuario EQ rsUsuarios.Codigo>selected</cfif>>#rsUsuarios.Nombre#</option>
                    </cfloop>
                  </select>
                  <cfelse>
                  <cfquery name="rs_usuario" datasource="#session.DSN#">
                    select Pnombre, Papellido1, Papellido2
                    from Usuario u, DatosPersonales dp
                    where u.Usucodigo =
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                    and dp.datos_personales=u.datos_personales
                    </cfquery>
                  <strong>
                    <cf_translate key="LB_Usuario" xmlfile="/rh/generales.xml">Usuario</cf_translate>
                    </strong><br />
                #rs_usuario.Papellido1# #rs_usuario.Papellido2# #rs_usuario.Pnombre#
                <input type="hidden" name="Usuario" value="#session.Usucodigo#" />
                </cfif>              </td>
              <td width="23%"><strong>
                <cf_translate key="LB_Fecha">Fecha</cf_translate>
                </strong>
                  <cfif isdefined("url.Ffecha") and len(trim(url.Ffecha))>
                    <cf_sifcalendario form="form1" name="Ffecha" value="#url.Ffecha#">
                    <cfelse>
                    <cf_sifcalendario form="form1" name="Ffecha" value="">
                  </cfif>              </td>
              <td width="40%"><strong>
                <cf_translate key="LB_Concepto_Incidente">Concepto Incidente</cf_translate>
                </strong>
                  <cfset DesdeAutogetion =''>
				  <cfif Menu EQ 'AUTO'>	<!---solo las visibles desde autogestion--->
					<cfset DesdeAutogetion ='and a.CIautogestion = 1'>
				  </cfif>
				  <cf_conlis title="#LB_ListaDeIncidencias#"
							campos = "CIid_f,CIcodigo_f,CIdescripcion_f" 
							desplegables = "N,S,S" 
							modificables = "N,S,N" 
							size = "0,10,20"
							asignar="CIid_f,CIcodigo_f,CIdescripcion_f"
							asignarformatos="I,S,S"
							tabla="	CIncidentes a"																	
							columnas="CIid as CIid_f,CIcodigo as CIcodigo_f, CIdescripcion as CIdescripcion_f, CInegativo as CInegativo_f"
							filtro="a.Ecodigo =#session.Ecodigo#
									and CIcarreracp = 0
									and coalesce(a.CInomostrar,0) = 0
									and CItipo <= 3
									#DesdeAutogetion#"
							desplegar="CIcodigo_f,CIdescripcion_f"
							etiquetas="	#vConcepto#, 
										#LB_Descripcion#"
							formatos="S,S"
							align="left,left"
							showEmptyListMsg="true"
							debug="false"
							form="form1"
							width="800"
							height="500"
							left="70"
							top="20"
							filtrar_por="CIcodigo,CIdescripcion"
							valuesarray="#va_arrayIncidencia#">              </td>
            </tr>
            <tr>
              <td>
			  	  <strong>#vEmpleado#</strong><br />
				  
				  
				  <cfif isdefined("rsEmpleadoFiltro") and rsEmpleadoFiltro.RecordCount NEQ 0> 	<!---Un empleado elegido--->
                    	<cfif menu EQ 'AUTO'>								<!---Si es Jefe y se encuentra en Autogestion trae solo los empledos subalternos--->
							<cfif rol EQ 1>
								<cf_rhempleado tabindex="1" size = "30" DEid="DEid" index="1" form="form1" query="#rsEmpleadoFiltro#" JefeDEid="#UserDEid#">
							<cfelse>
								<cf_rhempleado tabindex="1" size = "30" DEid="DEid" index="1" form="form1" query="#rsEmpleadoFiltro#" readOnly="true">
							</cfif>
						<cfelse>
							<cf_rhempleado tabindex="1" size = "30" DEid="DEid" index="1" form="form1" query="#rsEmpleadoFiltro#">
						</cfif>
                  <cfelse>																		<!---Todos los empleados activos--->
                    	<cfif menu EQ 'AUTO'>								<!---Si es Jefe y se encuentra en Autogestion trae solo los empledos subalternos--->
							<cf_rhempleado tabindex="1" size = "30" DEid="DEid" index="1" form="form1" JefeDEid="#UserDEid#">
						<cfelse>
							<cf_rhempleado tabindex="1" size = "30" DEid="DEid" index="1" form="form1">
						</cfif>
				  </cfif>
			 </td>
             
			  <td colspan="3" <cfif Menu EQ 'AUTO'>style="visibility:hidden"</cfif>><input type="checkbox" name="FIcpespecial_f" id="FIcpespecial_f" value="1" <cfif isdefined("url.FIcpespecial_f") and url.FIcpespecial_f EQ 1>checked</cfif> />
                  <cf_translate key="LB_Incluir_solo_en_Calendario_de_Pagos_especiales">Incluir solo en Calendario de Pagos especiales</cf_translate>              </td>
			</tr>
            <tr>
              <td><strong>
                <cf_translate key="LB_Centro_Funcional_de_Servicio">Centro Funcional de Servicio</cf_translate>
                </strong><br />
                
				<!---Muestra los centros funcionales que tienen la cuenta de gasto o de compras definido--->
				<cfif isdefined("rsCfuncionalFiltro") and rsCfuncionalFiltro.RecordCount NEQ 0>
                  <cf_rhcfuncional contables="1" tabindex="1" id="CFid_f" name="CFcodigo_f" desc="CFdescripcion_f" query="#rsCfuncionalFiltro#">
                <cfelse>
                  <cf_rhcfuncional contables="1" tabindex="1" id="CFid_f" name="CFcodigo_f" desc="CFdescripcion_f">
                </cfif>             
			  </td>
              
			  <td>
					<!---<cfif esGuatemala>
						<strong><cf_translate key="LB_FechaRebajo">Fecha Rebajo</cf_translate></strong><br />
						<cfif isdefined("url.IfechaRebajo_f") and len(trim(url.IfechaRebajo_f))>
						  <cf_sifcalendario form="form1" name="IfechaRebajo_f" value=#url.IfechaRebajo_f#>
						  <cfelse>
						  <cf_sifcalendario form="form1" name="IfechaRebajo_f">
						</cfif>
					<cfelse>
						&nbsp;     
					</cfif>  --->
					&nbsp;
			  </td>
              <td align="center"><input  type="submit" name="btnFiltrar2" value="#vFiltrar#" onClick="filtrar();" />              </td>
            </tr>
			
			<!---<cfif reqAprobacion and rol EQ 2>
			  <tr><td>
			  	<strong><cf_translate key="LB_Tipo">Tipo</cf_translate></strong>
			  </td></tr> 
			  <tr><td>
			  	<select name="proceso_aprobacion">
					<!---<option value="">--- Todos ---</option>--->
					<option value="1" <cfif isdefined("url.proceso_aprobacion") and url.proceso_aprobacion EQ 1> selected="selected"</cfif>>Sin Tr&aacute;mite de Aprobaci&oacute;n</option>
					<option value="2" <cfif isdefined("url.proceso_aprobacion") and url.proceso_aprobacion EQ 2> selected="selected"</cfif>>Con Tr&aacute;mite de Aprobaci&oacute;n</option>
				</select>
			  </td></tr>
			</cfif>--->
        </table></td>
      </tr>
    </cfif>
    <!---************************************* FIN DE FILTROS ***************************************---->
    <!---************************************* CAMPOS DEL MANTENIMIENTO ***************************************---->
    <tr>
      <td>&nbsp;</td>
    </tr>
    <!--- Línea No. 1 --->
   <!--- <cfif rol EQ 2 and reqAprobacion >
    <tr><td colspan="3" style="color:##0066FF; font-family:Arial, Helvetica, sans-serif; font-size:10px; font-weight:bold" align="center">Las incidencias que agregue desde esta pantalla, se van a auto-aprobar debido a que tiene rol de administrador.</td></tr>
	<tr><td colspan="3"><hr></td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	</cfif>--->
	<cfif rol EQ 1 and reqAprobacion>
		<cfif reqAprobacionJefe>
			<tr><td colspan="3" style="color:##0066FF; font-family:Arial, Helvetica, sans-serif; font-size:10px; font-weight:bold" align="center">Las incidencias que agregue desde esta pantalla, se van a auto-aprobar debido a que su usuario puede aprobar incidencias, solo las PROPIAS debe enviarlas a aprobar.</td></tr>
			<tr><td colspan="3"><hr></td></tr>
			<tr><td colspan="3">&nbsp;</td></tr>
		<cfelse>
			<tr><td colspan="3" style="color:##0066FF; font-family:Arial, Helvetica, sans-serif; font-size:10px; font-weight:bold" align="center">Las incidencias que agregue desde esta pantalla, se van a enviar a aprobar por parte del Administrador de la N&oacute;mina.</td></tr>
			<tr><td colspan="3"><hr></td></tr>
			<tr><td colspan="3">&nbsp;</td></tr>
		</cfif>
	</cfif>
	<tr>
      <!--- Empleado --->
      <td  colspan="2" class="fileLabel">#vEmpleado#</td>
      <!--- Concepto --->
      <td class="fileLabel" nowrap>#vConcepto#</td>
    </tr>
    <!--- Línea No. 2 --->
    <tr>
      <td  colspan="2">
	  	 
		  <cfif modo NEQ "ALTA">
          	<cf_rhempleado query="#rsIncidencia#" tabindex="1" size = "50" FuncJSalCerrar="CambiaCF();">
          <cfelseif isdefined("rsEmpleadoDef")>	
          		<cfif menu EQ 'AUTO'>
					<cfif rol EQ 0>	<!---No permite seleccionar empleado--->
						<cf_rhempleado query="#rsEmpleadoDef#" tabindex="1" size = "50" FuncJSalCerrar="CambiaCF();" readonly="True">
					<cfelse>		<!---Si es Jefe y se encuentra en Autogestion trae solo los empledos subalternos--->
						<cf_rhempleado query="#rsEmpleadoDef#" tabindex="1" size = "50" FuncJSalCerrar="CambiaCF();" JefeDEid="#UserDEid#">
					</cfif>
				<cfelse>
					<cf_rhempleado query="#rsEmpleadoDef#" tabindex="1" size = "50" FuncJSalCerrar="CambiaCF();">
				</cfif>
          <cfelse>
         	<cfif menu EQ 'AUTO'>
				<cfif rol EQ 0>	<!---No permite seleccionar empleado--->
					<cf_rhempleado tabindex="1" size = "30" DEid="DEid" form="form1" JefeDEid="#UserDEid#" readonly="True">
				<cfelse>		<!---Si es Jefe y se encuentra en Autogestion trae solo los empledos subalternos--->
					<cf_rhempleado tabindex="1" size = "30" DEid="DEid" form="form1" JefeDEid="#UserDEid#">
				</cfif>
			<cfelse>
				<cf_rhempleado tabindex="1" size = "50" FuncJSalCerrar="CambiaCF();">
          	</cfif>
		  </cfif>      
	  </td>
      <td>
        
		<cfset DesdeAutogetion =''>
		<cfif Menu EQ 'AUTO'>	<!---solo las visibles desde autogestion--->
			<cfset DesdeAutogetion ='and a.CIautogestion = 1'>
		</cfif>
		
		<cf_conlis title="#LB_ListaDeIncidencias#"
					campos = "CIid,CIcodigo,CIdescripcion" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,10,20"
					asignar="CIid,CIcodigo,CIdescripcion"
					asignarformatos="I,S,S"
					tabla="	CIncidentes a"																	
					columnas="CIid,CIcodigo,CIdescripcion"
					filtro="Ecodigo = #session.Ecodigo#
							and coalesce(a.CInomostrar,0) = 0
							and CIcarreracp = 0
							and CItipo < 3
							#DesdeAutogetion#"
					desplegar="CIcodigo,CIdescripcion"
					etiquetas="	#vConcepto#, 
								#LB_Descripcion#"
					formatos="S,S"
					align="left,left,left"
					showEmptyListMsg="true"
					debug="false"
					form="form1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="CIcodigo,CIdescripcion"
					valuesarray="#va_arrayvalues#"
					funcion="changeValLabel">  </td>
    </tr>
    <!--- Centro de Costos equivalente a Centro Funcional --->
    <cfquery name="centrocosto" datasource="#session.DSN#">
      select Pvalor
      from RHParametros
      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and Pcodigo = 520
    </cfquery>
    <!--- Línea No. 3 --->
    <tr>
      <!--- Centro funcional --->
      <td class="fileLabel" nowrap><cf_translate key="LB_Centro_Funcional_de_Servicio">Centro Funcional de Servicio</cf_translate></td>
      <!--- Concepto --->
      <td class="fileLabel">#vFecha#</td>
      <td nowrap>
		<table cellpadding="2" cellspacing="2" border="0" width="100%"><tr>
		  <!--- Valor --->
		  <td id="TDValorLabel" class="fileLabel" nowrap width="50%">&nbsp;</td>
		  <!--- Monto --->
			<cfif modo eq 'CAMBIO'>
			<cfif isdefined('url.Imonto') and isNumeric(url.Imonto)>
			<td id="TDMontoLabel" class="fileLabel" nowrap  width="50%">#vMonto#&nbsp;</td>
			</cfif>
			</cfif>
		</tr></table>
    </tr>
    <!--- Línea No. 4 --->
    <tr>
     
      <td>
	  	<!---Muestra los centros funcionales que tienen la cuenta de gasto o de compras definido--->
	  	
		<cfif modo neq 'ALTA' and rsCFuncional.RecordCount gt 0 >
		
			<!---Usuario... para que no pueda modificar su CF defecto en la incidencia--->
          	<cfif rol EQ 0 and menu EQ 'AUTO'>
				<cf_rhcfuncional query="#rsCFuncional#" tabindex="1" contables="1" id="CFid" readonly ='yes'>
			<cfelse>
				<cf_rhcfuncional query="#rsCFuncional#" tabindex="1" contables="1" id="CFid">
          	</cfif>
			
		<cfelse>
			<cfif rol EQ 0 and menu EQ 'AUTO'>
		  		
				<!--- En este caso en la alta se selecciona el centro funcional que tiene por defecto el usuario --->
				<cfquery name="rsCFUser" datasource="#session.DSN#">
					select  c.CFid, c.CFcodigo, c.CFdescripcion
					from LineaTiempo a
					inner join RHPlazas b
						on a.RHPid=b.RHPid
					inner join CFuncional c
						on c.CFid = coalesce( b.CFidconta, b.CFid)
					where <cf_dbfunction name="now"> between LTdesde and LThasta
					and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#UserDEid#">
				</cfquery>
				<cf_rhcfuncional query="#rsCFUser#"  tabindex="1" contables="1" id="CFid" readonly ='yes'>
			
			<cfelse>
				<cf_rhcfuncional tabindex="1" contables="1" id="CFid">
          	</cfif>
        </cfif>      </td>
      <!--- Fecha --->
      <td><cfif modo NEQ "ALTA">
          <cf_sifcalendario form="form1" name="Ifecha" value="#LSDateFormat(rsIncidencia.fecha,'dd/mm/yyyy')#" onChange="CambiaCF();">
          <cfelse>
          <cf_sifcalendario form="form1" name="Ifecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" onChange="CambiaCF();">
        </cfif>      </td>
      <!--- Valor --->
      <td nowrap>
		<table cellpadding="2" cellspacing="2" border="0" width="100%"><tr>
		  <td id="TDValor" nowrap  width="50%">
		  <input name="Ivalor" type="text" id="Ivalor" size="18" maxlength="15" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsIncidencia.Ivalor, 'none')#<cfelse>0.00</cfif>" tabindex="1" />      
		  </td>
		   <cfif modo eq 'CAMBIO'>
				<cfif isdefined('url.Imonto') and isNumeric(url.Imonto)>
			<td id="TDMonto" nowrap  width="50%">
				<input name="Imonto" type="text" id="Imonto" size="18" disabled="disabled"  maxlength="15" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsIncidencia.Imonto, 'none')#<cfelse>0.00</cfif>" tabindex="2">
			</td></cfif>
			</cfif>
		</tr></table>
      </td>
	</tr>
    <!--- Línea No. 5 --->
    <tr>
       
	  <td class="fileLabel" <cfif Menu EQ 'AUTO'>style="visibility:hidden"</cfif>><input type="checkbox" name="Icpespecial" id="Icpespecial" onClick="javascript:fechaRebajo(this);" value="" <cfif modo EQ "CAMBIO" and rsIncidencia.Icpespecial EQ 1>checked</cfif> />
          <cf_translate key="LB_Incluir_solo_en_Calendario_de_Pagos_especiales">Incluir solo en Calendario de Pagos especiales</cf_translate>      </td>
      <td>
	  	<table id="id_tableFechaRebajo" width="100%" align="center" border="0" cellspacing="0" cellpadding="1">
          <tr>
            <td class="fileLabel"><cf_translate key="LB_FechaRebajo">Fecha Rebajo</cf_translate></td>
          </tr>
          <tr>
            <td><cfif modo NEQ "ALTA">
                <cfset vFechaRebajo = '' >
                <cfif len(trim(rsIncidencia.IfechaRebajo))>
                  <cfset vFechaRebajo = LSDateFormat(rsIncidencia.IfechaRebajo,'dd/mm/yyyy') >
                </cfif>
                <cf_sifcalendario form="form1" name="IfechaRebajo" value="#vFechaRebajo#">
                <cfelse>
                <cf_sifcalendario form="form1" name="IfechaRebajo">
              </cfif>            </td>
          </tr>
      </table></td>
      <td><table width="100%" align="center" border="0" cellspacing="0" cellpadding="1">
          <tr id="TRLabelJornada" style="display:<cfif isdefined("rsIncidencia") and len(trim(rsIncidencia.RHJid))><cfelse>none</cfif>">
            <td class="fileLabel"><cf_translate key="LB_Jornada">Jornada</cf_translate></td>
          </tr>
          <tr id="TRJornada" style="display:<cfif isdefined("rsIncidencia") and len(trim(rsIncidencia.RHJid))><cfelse>none</cfif>">
            <td><select name="RHJid">
                <option value="">--- Seleccionar ---</option>
                <cfloop query="rsJornadas">
                  <option value="#RHJid#" <cfif modo EQ 'CAMBIO' and rsJornadas.RHJid EQ rsIncidencia.RHJid> selected</cfif>>#Descripcion#</option>
                </cfloop>
              </select>            </td>
          </tr>
      </table></td>
    </tr>
    <tr>
      <td colspan="4">&nbsp;</td>
    </tr>
    <!---linea 5 y 1/2--->
    <tr>
      <td colspan="4"><strong>#LB_Observacion#</strong></td>
    </tr>
    <tr>
      <td colspan="4">
		  <textarea name="Iobservacion" cols="100" rows="2"><cfif isdefined("rsIncidencia.Iobservacion") and len(trim(rsIncidencia.Iobservacion))>#rsIncidencia.Iobservacion#</cfif></textarea>		</td>
    </tr>
    <!--- Línea No. 6 --->
    <tr align="center">
      <td colspan="4">
		  <br />
          <cfif MODO EQ 'CAMBIO' AND  isdefined("rsIncidencia.Iestadoaprobacion") AND len(trim(rsIncidencia.Iestadoaprobacion))>
		  	<cfset Botones.excluir = "baja">
		  </cfif>
		  <cfset Botones.TabIndex = "1">
		  <cfinclude template="/rh/portlets/pBotones.cfm">
          
		  <input type="submit" name="btnImportar" value="#vImportar#" onClick="importar('n');" />
		  <cfif menu NEQ 'AUTO'>
		  <input type="submit" name="btnImportarCalculo" value="#LB_ImportarCalculo#" onClick="importar('c');" />
		  </cfif>
		  <input type="hidden" name="cualimportador" value="" />
          <br />      </td>
    </tr>
    <iframe  name="CentroFuncionalx" id="CentroFuncionalx" marginheight="0" marginwidth="0" frameborder="1" height="0" width="0" scrolling="auto"></iframe>
  </table>
  	
  	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsIncidencia.ts_rversion#" returnvariable="ts">
		</cfinvoke>
	</cfif>
	<cfif modo NEQ "ALTA">
		<input type="hidden" name="Iid" value="#rsIncidencia.Iid#">
	</cfif>
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
	
</form>
</cfoutput>

<cfif rol EQ 2>
	<cfinclude template="IncidenciasProceso-tabs.cfm">
	<div align="left"><cfoutput><b>#vMontoCalculado#</b>: #LB_NotaMontoCalculado#</cfoutput></div>
<cfelse>
	<cfinclude template="IncidenciasProceso-lista.cfm">	
</cfif>

<cfoutput>
<script language="JavaScript">

	// Valida el rango en caso de que el tipo de concepto de incidencia sea de días y horas
	function __isRangoCantidad() {
		if (document.form1.botonSel.value != 'btnFiltrar' && document.form1.botonSel.value != 'Baja'){
			if ((tipoConc[this.obj.form.CIid.value] == 0 || tipoConc[this.obj.form.CIid.value] == 1) && (parseFloat(qf(this.value)) < rangoMin[this.obj.form.CIid.value] || parseFloat(qf(this.value)) > rangoMax[this.obj.form.CIid.value])) {
				this.error = "#vCantidadValidacion#";
			}
		}	
	}

	function __isNotCero() {
		if (document.form1.botonSel.value != 'btnFiltrar'){
			if ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0)) {
				this.error = this.description + " #vNoCero#";
			}
		}
	}
	
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isRangoCantidad", __isRangoCantidad);
	_addValidator("isNotCero", __isNotCero);
	
	objForm.Ifecha.required = true;
	objForm.Ifecha.description = "#vFecha#";
	
	objForm.CIid.required = true;
	objForm.CIid.description = "#vConcepto#";
	
	objForm.DEidentificacion.required = true;
	objForm.DEidentificacion.description = "#vEmpleado#";
	
	objForm.Ivalor.required = true;
	objForm.Ivalor.description = "";
	objForm.Ivalor.validateNotCero();
	objForm.Ivalor.validateRangoCantidad();
	
	// Establecer la etiqueta inicial
	changeValLabel();
	
	// 
	function filtrar(){	
		
		if( document.getElementById("tab1c")!= null &&  document.getElementById("tab1c").style.display == 'none'){ 
			document.form1.tab.value = 2;
		}
		else{
			document.form1.tab.value = 1;		
		}
		document.form1.action = '';
		document.form1.botonSel.value = 'btnFiltrar';
		objForm.Ifecha.required = false;
		objForm.CIid.required = false;
		objForm.DEidentificacion.required = false;
		objForm.Ivalor.required = false;
	}
	
	function limpiar(){

		document.form1.DEid.value   	       	= '';
		document.form1.DEidentificacion.value  	= '';
		document.form1.NombreEmp.value   	   	= '';
		document.form1.CIid.value   	    	= '';
		document.form1.CIcodigo.value      		= ''; 
		document.form1.CIdescripcion.value	 	= ''; 
		document.form1.Ifecha.value 	   		= ''; 
		
		if(document.form1.CFid) {
			document.form1.CFid.value   	   		= ''; 
			document.form1.CFcodigo.value      		= ''; 
			document.form1.CFdescripcion.value 		= ''; 
		}
	}
	
	function importar(prn_importador) {
		//prn_importador: 'n' --> Importador "normal", 'c' -->Importador de calculadora...
		/*
		var top  = (screen.height - 600) / 2;
		var left = (screen.width - 850)  / 2;
		<cfif modo neq 'ALTA'>
			window.open('importarIncidencias.cfm', 'Importar','menu=no,scrollbars=yes,top='+top+',left='+left+',width=850,height=500');
		</cfif>			
		*/
		objForm._allowSubmitOnError = true;
		objForm._showAlerts = false;
		qFormAPI.errorColor = "##FFFFFF";
		if (prn_importador == 'c'){
			document.form1.cualimportador.value = 'c';
		}
		document.form1.action = 'importarIncidencias.cfm';
		document.form1.submit();
	}
		
	function fechaRebajo( obj ){
		document.getElementById("id_tableFechaRebajo").style.display = (obj.checked) ? '' : 'none';
	}
	
	// segun el check muestra o no la fecha de rtebajo
	fechaRebajo( document.form1.Icpespecial )

	function funcEnviarAprobar(){
		
		if (fnAlgunoMarcadolista(document.lista)){
			if(confirm('Esta accion, va a enviar una solicitud de aprobacion de la incidencia a su Jefe.\n Desea enviar a aprobar la(s) incidencia(s) seleccionada(s)?')){
				return (true);
			}else {
				return (false);
			}
		}else {
			alert('Debe seleccionar al menos una incidencia.');
			return (false);
		}
		
	}

	function fnAlgunoMarcadolista(formObj){
		if (formObj.chk) {
			if (formObj.chk.value) {
				return formObj.chk.checked;
			} else {
				for (var i=0; i<formObj.chk.length; i++) {
					if (formObj.chk[i].checked) { 
						return true;
					}
				}
			}
		}
		return false;
	}
	function funcEliminar(){
		<cfif rol EQ  2>
			var form_lista = document.lista1;
		<cfelse>
			var form_lista = document.lista;
		</cfif>
		if (!fnAlgunoMarcadolista(form_lista)){
			alert("¡Debe seleccionar al menos una Incidencia para eliminar!");
			return false;
		}else{
			if ( confirm("¿Desea eliminar las incidencias marcadas?") )	{
				form_lista.action = 'IncidenciasProceso-sql.cfm';
				return true;
			}
			return false;
		}		
	}
	
	function funcRechazar(){
		var form_lista = document.lista2;
		if (!fnAlgunoMarcadolista(form_lista)){
			alert("¡Debe seleccionar al menos una Incidencia para rechazar!");
			return false;
		}else{
			if ( confirm("¿Desea rechazar las incidencias marcadas?") )	{
				form_lista.action = 'IncidenciasProceso-sql.cfm';
				return true;
			}
			return false;
		}		
	}
	
	
	function CambiaCF(){
		<cfif trim(rsCargarCF.Pvalor) eq 1>
			var fecha=document.form1.Ifecha.value;
			var DEid = document.form1.DEid.value;
			document.getElementById('CentroFuncionalx').src = 'CambiaCentroFuncional.cfm?Fecha='+fecha+'&DEid='+DEid;
		</cfif>	
	}
	
	<cfif rol EQ 0 and menu EQ 'AUTO'><!---Usuario... para que se cargue su CF por defecto--->
		CambiaCF();
	</cfif>
</script>
</cfoutput>
