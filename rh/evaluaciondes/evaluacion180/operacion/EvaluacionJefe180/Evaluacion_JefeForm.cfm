<!--- Definición e inicialización de variables  --->
<cfset corteporpregunta = 4>

<cfif isdefined("url.REid") and not isdefined("form.REid")>
	<cfset form.REid = url.REid >
</cfif>
<cfif isdefined("url.paso") and not isdefined("form.paso")>
	<cfset 	form.paso = url.paso >
</cfif>

<cfif isdefined("url.CursorPreguntas") and not isdefined("form.CursorPreguntas")>
	<cfset 	form.CursorPreguntas = url.CursorPreguntas >
</cfif>

<cfif isdefined("url.personas") and not isdefined("form.personas")>
	<cfset form.personas = url.personas >
</cfif>
<cfif isdefined('url.RHPcodigo') and not isdefined('form.RHPcodigo')>
	<cfset form.RHPcodigo = url.RHPcodigo>
</cfif>

<cfif not isdefined("form.CursorPreguntas")>
	<cfset CursorPreguntas = 1>
<cfelse>
	<cfset CursorPreguntas = form.CursorPreguntas>
</cfif>
<cfif isdefined('form.CursorPreguntas') and form.CursorPreguntas EQ 0>
	<cfset CursorPreguntas = 1>
</cfif>
<cfif isdefined('form.RHPcodigo') and not isdefined('CursorPreguntas')>
	<cfset CursorPreguntas = 1>
</cfif>
<cfif isdefined("form.paso") and form.paso eq '2'>
	<cfset corteporpregunta = 1000>
</cfif>

<cftry>

<!--- CLASES DE PUESTOS --->
<cfquery name="rsTipoPuesto" datasource="#session.DSN#">
	select RHTPid,RHTPcodigo, RHTPdescripcion
	from RHTPuestos
	where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- EVALUACIÓN --->
<cfquery name="rsRel" datasource="#session.DSN#">
	select REdescripcion,REdesde,REhasta  
	from RHRegistroEvaluacion
	where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
</cfquery>
<!--- QUERY PARA LIGAR USUARIO CON EMPLEADO --->
<cfquery name="rsDEid" datasource="#session.DSN#">
	select llave as DEid
	from UsuarioReferencia
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	and STabla = 'DatosEmpleado'
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">	
</cfquery>

<!--- INFORMACION DEL EVALUADOR --->
<cfquery name="rsEvaluador" datasource="#session.DSN#">
	select 
	{fn concat({fn concat(rtrim(cf.CFcodigo) , ' - ' )},  cf.CFdescripcion )} as CFdescripcion,
	{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}  as nombre
	from LineaTiempo lt
	inner join RHPlazas pl
		on  lt .RHPid = pl.RHPid
	inner join  CFuncional cf
		on   cf.CFid  = pl.CFid 
	inner join  DatosEmpleado de
		on    lt .DEid  = de.DEid 
	where   <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
	and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#">	
</cfquery>

<!--- VERIFICACION PARA VER SI SE PUEDE APLICAR LA EVALUACION --->
<cf_dbfunction name="to_char" args="CDERespuestaj" returnvariable="Lvar_to_char_CDERespuestaj">
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select  distinct x.REid
	from RHRegistroEvaluadoresE v 
	inner join RHConceptosDelEvaluador x
		on   v.REid = x.REid
		and  v.REEid = x.REEid
	inner join RHIndicadoresRegistroE y
		on x.IREid = y.IREid
		and not (y.IREevaluasubjefe = 0 and
				 y.IREevaluajefe = 1)<!--- NO SE TOMA EN CUENTA LOS CONCEPTOS QUE SON SOLO PARA AUTOEVALUACION DEL JEFE --->
	inner join RHIndicadoresAEvaluar z
		on y.IAEid = z.IAEid
		and z.IAEtipoconc = 'T'
	inner join RHEmpleadoRegistroE z1
		on v.REid = z1.REid
		and v.DEid = z1.DEid
		and z1.EREnojefe = 0			
	where  x.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	and  #Lvar_to_char_CDERespuestaj#  is  null
	and v.REEevaluadorj = #rsDEid.DEid#
</cfquery>

<cfif isdefined('rsVerifica') and rsVerifica.RecordCount GT 0>
	<cfset vAplicar = 0>
<cfelse>
	<cfset vAplicar = 1>
</cfif>

<!---Este proceso es para pintar o no el paso 3 (Evaluación de Jefaturas) --->
<cfif not isdefined("form.listaempleadosjefe")>
	<!--- busca que empleados de los que se evaluan son jefes. --->
	<cfquery name="rsEmpleadosJefes" datasource="#session.DSN#">
		select distinct a.DEid  
		from RHRegistroEvaluadoresE  a
		inner join RHEmpleadoRegistroE b
			on a.REid = b.REid
			and a.DEid = b.DEid
			and b.EREnojefe = 0
			and b.EREjefeEvaluador = 1
		inner join RHConceptosDelEvaluador c
			on   a.REid = c.REid
			and  a.REEid = c.REEid
		inner join RHIndicadoresRegistroE d
			on   c.IREid  = d.IREid 
			and d.IREevaluasubjefe = 1	
		where a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
		and  a.REEevaluadorj = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#">	
	</cfquery>
	<cfset listaempleadosjefe = "">
	<cfloop query="rsEmpleadosJefes">
		<cfset listaempleadosjefe = listaempleadosjefe & rsEmpleadosJefes.DEid & ','>
	</cfloop>
	<cfset listaempleadosjefe = listaempleadosjefe & '-1'>
<cfelse>
	<cfset listaempleadosjefe = form.listaempleadosjefe>
</cfif>



<cfif isdefined("form.paso") and form.paso eq '1'>
	<!---Evaluación de Conceptos --->
	<cfquery name="RSEvaluacionesDatos" datasource="#session.DSN#">
		select  d.IAEdescripcion,IAEpregunta,IAEtipoconc,c.TEcodigo,a.DEid, CDEid,CDERespuestaj,
			{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}  as nombre,  
			DEidentificacion, b.IREid,
			pp.RHPcodigo,pp.RHPdescpuesto
		from RHRegistroEvaluadoresE a 
		inner join RHConceptosDelEvaluador b
			on   a.REid = b.REid
			and  a.REEid = b.REEid
		inner join RHIndicadoresRegistroE c
			on   b.IREid  = c.IREid 
			and c.IREevaluajefe = 0
			and c.IREevaluasubjefe = 0
		inner join RHIndicadoresAEvaluar d
			on c.IAEid  = d.IAEid 
			and  d.IAEtipoconc = 'T'
		inner join DatosEmpleado de 
			on a.DEid =  de.DEid
		inner join RHEmpleadoRegistroE e
			on a.REid = e.REid
			and a.DEid = e.DEid
			and e.EREnojefe = 0
		inner join LineaTiempo lt
			on lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and lt.DEid = de.DEid
			and lt.LTid = (select max(lt3.LTid) from LineaTiempo lt3 where lt3.DEid = lt.DEid and lt3.LTdesde = (select max(lt4.LTdesde) from LineaTiempo lt4 where lt4.DEid = lt3.DEid))
		inner join RHPlazas p
			on p.Ecodigo = lt.Ecodigo
			and p.RHPid = lt.RHPid
		inner join RHPuestos pp
			on pp.RHPcodigo = p.RHPpuesto
			and pp.Ecodigo = p.Ecodigo
			<cfif isdefined('form.RHPcodigo') and LEN(TRIM(form.RHPcodigo))>
				and pp.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
			</cfif>
		where  a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
		and a.REEevaluadorj = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#">
		order by a.DEid, c.TEcodigo, IAEdescripcion	
	</cfquery>
<cfelseif isdefined("form.paso") and form.paso eq '2'>
	<!---Otras Evaluaciones (preguntas de tipo abiertas) --->
	<cfquery name="RSEvaluacionesDatos" datasource="#session.DSN#">
		select  d.IAEdescripcion,IAEpregunta,IAEtipoconc,c.TEcodigo,a.DEid, CDEid,CDERespuestaj,
		{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}  as nombre,  
		DEidentificacion, b.IREid,
		pp.RHPcodigo,pp.RHPdescpuesto
		from RHRegistroEvaluadoresE a 
		inner join RHConceptosDelEvaluador b
			on   a.REid = b.REid
			and  a.REEid = b.REEid
		inner join RHIndicadoresRegistroE c
			on   b.IREid  = c.IREid 
		inner join RHIndicadoresAEvaluar d
			on c.IAEid  = d.IAEid 
			and  d.IAEtipoconc != 'T'
		inner join DatosEmpleado de 
			on a.DEid =  de.DEid
		inner join RHEmpleadoRegistroE e
			on a.REid = e.REid
			and a.DEid = e.DEid
			and e.EREnojefe = 0	
		inner join LineaTiempo lt
			on lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and lt.DEid = de.DEid
			and lt.LTid = (select max(lt3.LTid) from LineaTiempo lt3 where lt3.DEid = lt.DEid and lt3.LTdesde = (select max(lt4.LTdesde) from LineaTiempo lt4 where lt4.DEid = lt3.DEid))
		inner join RHPlazas p
			on p.Ecodigo = lt.Ecodigo
			and p.RHPid = lt.RHPid
		inner join RHPuestos pp
			on pp.RHPcodigo = p.RHPpuesto
			and pp.Ecodigo = p.Ecodigo			
			<cfif isdefined('form.RHPcodigo') and LEN(TRIM(form.RHPcodigo))>
				and pp.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
			</cfif>
		where  a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
		and a.REEevaluadorj = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#">	
		order by a.DEid, c.TEcodigo
	</cfquery>
<cfelseif isdefined("form.paso") and form.paso eq '3'>
	<!--- Evaluación de Jefaturas --->
	<cfquery name="RSEvaluacionesDatos" datasource="#session.DSN#">
		select  d.IAEdescripcion,IAEpregunta,IAEtipoconc,c.TEcodigo,a.DEid, CDEid,CDERespuestaj,
		{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}  as nombre,  
		DEidentificacion, b.IREid,
		pp.RHPcodigo,pp.RHPdescpuesto
		from RHRegistroEvaluadoresE a 
		inner join RHConceptosDelEvaluador b
			on   a.REid = b.REid
			and  a.REEid = b.REEid
		inner join RHIndicadoresRegistroE c
			on   b.IREid  = c.IREid 
			and  c.IREevaluasubjefe = 1
		inner join RHIndicadoresAEvaluar d
			on 	 c.IAEid  = d.IAEid 
			and  d.IAEtipoconc = 'T'
		inner join DatosEmpleado de 
			on 	a.DEid =  de.DEid
		inner join RHEmpleadoRegistroE e
			on 	a.REid = e.REid
			and a.DEid = e.DEid
			and e.EREnojefe = 0	
		inner join LineaTiempo lt
			on lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and lt.DEid = de.DEid
			and lt.LTid = (select max(lt3.LTid) from LineaTiempo lt3 where lt3.DEid = lt.DEid and lt3.LTdesde = (select max(lt4.LTdesde) from LineaTiempo lt4 where lt4.DEid = lt3.DEid))
		inner join RHPlazas p
			on p.Ecodigo = lt.Ecodigo
			and p.RHPid = lt.RHPid
		inner join RHPuestos pp
			on pp.RHPcodigo = p.RHPpuesto
			and pp.Ecodigo = p.Ecodigo
			<cfif isdefined('form.RHPcodigo') and LEN(TRIM(form.RHPcodigo))>
				and pp.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
			</cfif>
		where  a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
		and a.REEevaluadorj = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDEid.DEid#">
		order by a.DEid, c.TEcodigo, IAEdescripcion		
	</cfquery>	
</cfif>

<!--- query para saber que preguntas se visualizaran por corte 
	 (siempre y cuando la cantidad de preguntas sea mayor al corte permitido) 
--->

<cfquery name="RSEvaluaciones1"  dbtype="query">
	select distinct IAEdescripcion,IAEpregunta,IAEtipoconc,IREid,TEcodigo
	from  RSEvaluacionesDatos
	order by TEcodigo
</cfquery>


<cfcatch>
	<cfset params = "">
	<cfset params = params & "paso=1">
	<cfset params = params & "&CursorPreguntas=1">
	<cfif isdefined("form.REid") and len(trim(form.REid)) GT 0>
		<cfset params = params & "&REid=" & form.REid>
	</cfif>
	<cfif isdefined("form.personas") and len(trim(form.personas)) GT 0>
		<cfset params = params & "&personas=" & form.personas>
	</cfif>
	<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo)) GT 0>
		<cfset params = params & "&RHPcodigo=" & form.RHPcodigo>
	</cfif>
	<cflocation url="Evaluacion_JefeForm.cfm?#params#">
</cfcatch>
</cftry>


<!--- viene del siguiente paso --->
<cfif cursorpreguntas eq 9999>
	<cfif (RSEvaluaciones1.recordcount - corteporpregunta) GT 0>
		<cfset cursorpreguntas = RSEvaluaciones1.recordcount - corteporpregunta + 1>
	</cfif>
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaSeguroADueDeseaAplicarLasEvaluacion"
	Default="¿Está seguro(a) que desea aplicar las evaluación?"
	returnvariable="MSG_EstaSeguroADueDeseaAplicarLasEvaluacion"/>
<html>
	<head><title></title>

	</head>
	<body>

		
	<cfoutput>
	<form action="Evaluacion_JefeForm.cfm" method="post" name="form1">
		<!--- ENCABEZADO DE LA EVALUACION --->
		<table width="980">
			<tr>
				<td  width="97%" align="center">
					<strong><cf_translate key="LB_EVALUACIONDEHABILIADES">EVALUACI&Oacute;N DE HABILIDADES</cf_translate></strong> 
				</td> 
				<td align="right">
					<a  href="javascript: informacion('<cfoutput>#trim(form.REid)#','#form.Personas#</cfoutput>');" ><img border="0" src="/cfmx/rh/imagenes/help_small.gif" ></a>
				</td>
			<tr>
			</tr>	
				<td align="center" colspan="2">
					<strong>
					#rsRel.REdescripcion#&nbsp;&nbsp;<cf_translate key="LB_Del">del</cf_translate>&nbsp;#lsdateformat(rsRel.REdesde,"DD/MM/YYYY")#&nbsp;&nbsp;<cf_translate key="LB_Al">al</cf_translate>&nbsp;#lsdateformat(rsRel.REhasta,"DD/MM/YYYY")#
					</strong>
				</td>
			</tr>
			<tr>	
				<td align="center" colspan="2">
					<strong><cf_translate key="LB_Evaluador">Evaluador</cf_translate>:</strong>&nbsp;&nbsp; #rsEvaluador.nombre# &nbsp;&nbsp; <strong><cf_translate key="LB_Fecha" XmlFile="/rh/generales.xml">Fecha</cf_translate>:</strong>&nbsp;&nbsp;#lsdateformat(now(),"DD/MM/YYYY")# &nbsp;&nbsp; <strong><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Fucional</cf_translate>:</strong> &nbsp;&nbsp; #rsEvaluador.CFdescripcion#	   
				</td>
			</tr>
			<tr>
			 <cfif isdefined("form.paso") and form.paso eq '1'>
				<td align="center" colspan="2">
					<strong><cf_translate key="LB_EvaluacionDeConceptos">Evaluaci&oacute;n de Conceptos</cf_translate></strong>
				</td>
			  	<cfelseif isdefined("form.paso") and form.paso eq '2'>
				<td align="center" colspan="2">
					<strong><cf_translate key="LB_OtrasEvaluaciones">Otras Evaluaciones</cf_translate></strong>
				</td>			  
				 <cfelseif isdefined("form.paso") and form.paso eq '3'>
				<td align="center" colspan="2">
					<strong><cf_translate key="LB_EvaluacionDeJefaturas">Evaluaci&oacute;n de Jefaturas</cf_translate></strong>
				</td>	
			  </cfif>
			 </tr> 
	</table>
	<link rel="stylesheet" href="locked-column.css" type="text/css">
	<input type="hidden" name="corteporpregunta" value="#corteporpregunta#">
	<input type="hidden" name="NoPreguntas" value="#RSEvaluaciones1.RecordCount#">
	<cfset lista ="">
	<cfset mostrando =0>
	<cfif RSEvaluaciones1.RecordCount gt  corteporpregunta>
		<cfif CursorPreguntas GTE 1>
			<cfset lvar_startRow = CursorPreguntas>
		<cfelse>
			<cfset lvar_startRow = 1>
		</cfif>
		<cfif (CursorPreguntas+corteporpregunta)-1 GTE 1>
			<cfset lvar_endRow = (CursorPreguntas+corteporpregunta)-1>
		<cfelse>
			<cfset lvar_endRow = 1>
		</cfif>
		<cfif RSEvaluaciones1.recordcount GTE 1>
			<cfloop query = "RSEvaluaciones1"  startRow = "#lvar_startRow#" endRow = "#lvar_endRow#"> 
				<cfset mostrando = mostrando +1>
				<cfset lista =lista & RSEvaluaciones1.IREid & ','>
				<cfset CursorPreguntas = CursorPreguntas + 1>
			</cfloop>
		</cfif>
		<cfset CursorPreguntas = CursorPreguntas - 1>
	<cfelse>
		<cfset CursorPreguntas = RSEvaluaciones1.RecordCount> 
	</cfif>
	<cfset lista =lista & '-1'>	
	<!--- BOTONES PARTE SUPERIOR  --->
	<table width="980">

			<tr>
				<td align="center">
				  <cfset Vbotones = "">
				  <cfset Nbotones = "">	
				  <cfif  form.paso eq '1'>
					  	<cfif  CursorPreguntas GT corteporpregunta>
							  <cfset Vbotones =  "Inicio,Anterior,Guardar,Siguiente">
							  <cfset Nbotones =  "btnInicio2,btnAnterior2,btnAceptar2,btnSiguiente2">
						<cfelse>
							  <cfset Vbotones =  "Inicio,Guardar,Siguiente">
							  <cfset Nbotones =  "btnInicio2,btnAceptar2,btnSiguiente2">
						</cfif>
				   <cfelseif form.paso eq '2'>
				   		 <cfif  trim(listaempleadosjefe) eq '-1'>
					   		 <cfif isdefined('vAplicar') and vAplicar>
							     <cfset Vbotones =  "Inicio,Anterior,Guardar,Aplicar" >
						         <cfset Nbotones =  "btnInicio2,btnAnterior2,btnAceptar2,btnAplicar2">
						     <cfelse>
						     	<cfset Vbotones =  "Inicio,Anterior,Guardar" >
						     	<cfset Nbotones =  "btnInicio2,btnAnterior2,btnAceptar2">
					         </cfif>
						 <cfelse>
							 <cfset Vbotones =  "Inicio,Anterior,Guardar,Siguiente">
					         <cfset Nbotones =  "btnInicio2,btnAnterior2,btnAceptar2,btnSiguiente2">
						 </cfif>
				  <cfelseif form.paso eq '3'>
				 		<cfif  CursorPreguntas GTE corteporpregunta>
							  <cfset Vbotones =  "Inicio,Anterior,Guardar,Siguiente">
							  <cfset Nbotones =  "btnInicio,btnAnterior2,btnAceptar2,btnSiguiente2">
						<cfelse>
							<cfif isdefined('vAplicar') and vAplicar>
							 	<cfset Vbotones =  "Inicio,Anterior,Guardar,Aplicar" >
							 	<cfset Nbotones =  "btnInicio2,btnAnterior2,btnAceptar2,btnAplicar2">
							<cfelse>
								<cfset Vbotones =  "Inicio,Anterior,Guardar" >
							 	<cfset Nbotones =  "btnInicio2,btnAnterior2,btnAceptar2">
							</cfif>
						</cfif>

			  	  </cfif>
				   <cf_botones values="#Vbotones#" names="#Nbotones#" tabindex="1">
				   <input type="hidden" name="botonSelx" id="botonSelx" value="">
				</td>
			</tr>
		</table>	
		<input type="hidden" name="CursorPreguntas" value="#CursorPreguntas#">	
		<input type="hidden" name="mostrando" value="#mostrando#">

		<!--- QUERY PARA PINTAR LAS PREGUNTAS   --->
		<cfquery name="RSEvaluaciones2"  dbtype="query">
			select distinct IAEdescripcion,IAEpregunta,IAEtipoconc from  RSEvaluaciones1
			<cfif RSEvaluaciones1.RecordCount gt  corteporpregunta>
				where IREid in (#lista#)
			</cfif>
			order by TEcodigo
		</cfquery>
		
		<!--- QUERY PARA PINTAR LOS EMPLEADOS A EVALUAR Y SUS RESPUESTAS  --->
		<cfquery name="RSEvaluaciones"  dbtype="query">
			select * from  RSEvaluacionesDatos
			<cfif RSEvaluaciones1.RecordCount gt  corteporpregunta>
				where IREid in (#lista#)
			</cfif>
		</cfquery>
		<!--- CALCULA LA CANTIDAD DE PIXELES A COLOCAR SEGUN LA CANTIDAD DE EMPLEADOS  --->
		<cfset tamano =  (#form.personas#* 24) + 60>
		<!--- AREA DE LA PREGUNTAS  (AQUI SE PINTAN LOS EVALUADORES Y LA PREGUNTAR A REALIZAR)  --->
		
		<div id="tbl-container"  style="height:#tamano#px;">
			<table id="tbl">
				<thead>	
					<tr>
						<th width="120"><cf_translate key="LB_Identificacion" XmlFile="/rh/generales.xml">Identificaci&oacute;n</cf_translate></th>
						<th width="180"><cf_translate key="LB_Nombre"XmlFile="/rh/generales.xml">Nombre</cf_translate></th>
						<cfloop query="RSEvaluaciones2">
							<cfif RSEvaluaciones.IAEtipoconc eq 'T'>
									<th width="160">
									<cfif isdefined("RSEvaluaciones2.IAEpregunta") and len(trim(RSEvaluaciones2.IAEpregunta)) gt 0>
										#RSEvaluaciones2.IAEpregunta#
									<cfelse>
										#RSEvaluaciones2.IAEdescripcion#
									</cfif>
									</th>
							<cfelse>
									<th width="343">
									<cfif isdefined("RSEvaluaciones2.IAEpregunta") and len(trim(RSEvaluaciones2.IAEpregunta)) gt 0>
										#RSEvaluaciones2.IAEpregunta#
									<cfelse>
										#RSEvaluaciones2.IAEdescripcion#
									</cfif>
									</th>
							</cfif>
						</cfloop>
					</tr>	
				<thead>
				<tbody>
					<cfset primerREG = true>
					<cfset empleado = "">
					<cfloop query="RSEvaluaciones">	
						<cfset respuesta = RSEvaluaciones.CDERespuestaj>
						<cfif empleado neq  RSEvaluaciones.DEid>
								<cfif primerREG eq false>
								</tr>
								<cfset contadorcol = 1>
							</cfif> 
							<tr>
							<td >#RSEvaluaciones.DEidentificacion#</td>
							<td id="tdtitulo">#RSEvaluaciones.nombre#</td>
						</cfif>
							<td>
								<cfif RSEvaluaciones.IAEtipoconc eq 'T'>
									<cfquery name="rsTablas" datasource="#session.DSN#">
										select  TEVvalor,TEVnombre  from TablaEvaluacionValor where TEcodigo = #RSEvaluaciones.TEcodigo#
									</cfquery>
									<select   tabindex="1"   style = "z-index: 70;"  
										name="RES_#RSEvaluaciones.CDEid#" 
										id="TD_#RSEvaluaciones.currentRow#">
										<option value="">-seleccionar-</option>
										<cfloop query="rsTablas">
											<option value="#rsTablas.TEVvalor#" <cfif trim(rsTablas.TEVvalor) eq trim(respuesta)> selected </cfif>>#rsTablas.TEVnombre#</option>
										</cfloop>
									</select> 
								<cfelse>
										<textarea name="RES_#RSEvaluaciones.CDEid#" 
										 tabindex="1 "
										id="RES_#RSEvaluaciones.CDEid#" rows="2" cols="45">#respuesta#</textarea>
								</cfif>
							</td>
						<cfset empleado = RSEvaluaciones.DEid>
					</cfloop>
				</tbody>
			</table>
		</div> 
		<!-- end tbl-container -->
		<!--- BOTONES PARTE INFERIOR  --->
		<table width="980">
			<tr >
				<td align="center">
					<cfset Vbotones = "">
					<cfset Nbotones = "">	
					<cfif  form.paso eq '1'>
						<cfif  CursorPreguntas GT corteporpregunta>
					  		<cfset Vbotones =  "Inicio,Anterior,Guardar,Siguiente">
					  		<cfset Nbotones =  "btnInicio,btnAnterior,btnAceptar,btnSiguiente">
						<cfelse>
							<cfset Vbotones =  "Inicio,Guardar,Siguiente">
						  	<cfset Nbotones =  "btnInicio,btnAceptar,btnSiguiente">
						</cfif>					  
					<cfelseif form.paso eq '2'>
						<cfif  trim(listaempleadosjefe) eq '-1'>
					  		<cfif isdefined('vAplicar') and vAplicar>
						   		<cfset Vbotones =  "Inicio,Anterior,Guardar,Aplicar" >
						       	<cfset Nbotones =  "btnInicio,btnAnterior,btnAceptar,btnAplicar">
							<cfelse>
								<cfset Vbotones =  "Inicio,Anterior,Guardar" >
						    	<cfset Nbotones =  "btnInicio,btnAnterior,btnAceptar">
							</cfif>
						<cfelse>
							<cfset Vbotones =  "Inicio,Anterior,Guardar,Siguiente">
							<cfset Nbotones =  "btnInicio,btnAnterior,btnAceptar,btnSiguiente">
						</cfif>
					<cfelseif form.paso eq '3'>
						<cfif  CursorPreguntas GTE corteporpregunta>
							  <cfset Vbotones =  "Inicio,Anterior,Guardar,Siguiente">
							  <cfset Nbotones =  "btnInicio,btnAnterior,btnAceptar,btnSiguiente">
						<cfelse>
							<cfif isdefined('vAplicar') and vAplicar>
								 <cfset Vbotones =  "Inicio,Anterior,Guardar,Aplicar" >
								 <cfset Nbotones =  "btnInicio,btnAnterior,btnAceptar,btnAplicar">
							 <cfelse>
								 <cfset Vbotones =  "Inicio,Anterior,Guardar" >
								 <cfset Nbotones =  "btnInicio,btnAnterior,btnAceptar">
							 </cfif>
						</cfif>
					</cfif>
					<cf_botones values="#Vbotones#" names="#Nbotones#" tabindex="1"> 
				</td>
			</tr>
		</table>
		<input type="hidden" name="REid" value="#form.REid#">
		<input type="hidden" name="paso" value="#form.paso#">
		<input type="hidden" name="personas" value="#form.personas#">
		<cfif isdefined('form.RHPcodigo')>
		<input name="RHPcodigo" type="hidden" value="#form.RHPcodigo#" tabindex="-1">
			<cfif isdefined('rsEvaluaciones')>
			<input type="hidden" name="cantidad" value="#RSEvaluaciones.RecordCount#">
			</cfif>
			<cfif isdefined("listaempleadosjefe") and len(trim(listaempleadosjefe)) >
				<input type="hidden" name="listaempleadosjefe" value="#listaempleadosjefe#">
			</cfif>
		</cfif>
		</cfoutput>	
		</form>
	</body>
</html>
<cfoutput>
<script type="text/javascript">
	
	<!--- Funcion  bloquear las 2 primeras columnas de la tabla  --->
	function lockCol(tblID) {
	
		var table1 = document.getElementById(tblID);
		var cTR = table1.getElementsByTagName('TR');  //collection of rows
	
		if (table1.rows[0].cells[0].className == '') {
			for (i = 0; i < cTR.length; i++)
				{
				var tr = cTR.item(i);
				tr.cells[0].className = 'locked'
				tr.cells[1].className = 'locked'
				}
			}
			else {
			for (i = 0; i < cTR.length; i++)
				{
				var tr = cTR.item(i);
				tr.cells[0].className = ''
				}
			}
	}
	
	<!--- Funcion para el boton de inicio --->
	function funcbtnInicio(){
		var PARAM  = "&REid="+ #form.REid#+"&personas="+#form.personas#;

		<cfif isdefined('form.RHPcodigo') and LEN(TRIM(form.RHPcodigo))>
			PARAM = PARAM + "&RHPcodigo=#form.RHPcodigo#";
		</cfif>

		location.href = "Evaluacion_instrucciones.cfm?" + PARAM;
		return false;
	}
	<!--- Funcion  para el boton aceptar de la parte superior  --->
	function funcbtnAceptar(){
		document.form1.action = "Evaluacion_JefeFormSQL.cfm";
		document.form1.submit();
		//return false;
		
	}
	<!--- Funcion  para el boton aceptar de la parte inferior  --->
	function funcbtnAceptar2(){
		funcbtnAceptar();
		
	}
	<!--- Funcion  para el boton Aplicar de la parte superior  --->
	function funcbtnAplicar(){
		if(confirm('#MSG_EstaSeguroADueDeseaAplicarLasEvaluacion#')){
			document.form1.action = "Evaluacion_JefeFormSQL.cfm";
			document.form1.submit();
		}
		else{
			return false;
		}
	}
	<!--- Funcion  para el boton aceptar de la parte inferior  --->
	function funcbtnAplicar2(){
		funcbtnAplicar();
	}


	<!--- Funcion  para el boton siguente de la parte superior  --->

	function funcbtnSiguiente(){
		
		paso = parseInt(#form.paso#);
		<cfif isdefined('form.RHPcodigo') and LEN(TRIM(form.RHPcodigo))>
			puesto = '#form.RHPcodigo#';
		</cfif>
		NoPreguntas = parseInt(#RSEvaluaciones1.RecordCount#);
		CursorPreguntas = parseInt(#CursorPreguntas#);
		corteporpregunta = parseInt(#corteporpregunta#);
		document.form1.btnSiguiente.disabled=true;
		document.form1.btnSiguiente2.disabled=true;
		if(CursorPreguntas >= NoPreguntas){
			paso = paso + 1;
			document.form1.CursorPreguntas.value = 1;
		}
		else{
			CursorPreguntas = CursorPreguntas + 1;
			document.form1.CursorPreguntas.value = CursorPreguntas;
		}
		document.form1.paso.value = paso;
		<cfif isdefined('form.RHPcodigo') and LEN(TRIM(form.RHPcodigo))>
			document.form1.RHPcodigo.value = puesto;
		</cfif>
		document.form1.action = "Evaluacion_JefeFormSQL.cfm";
		document.form1.botonSelx.value="btnSiguiente";
		document.form1.submit();
	}
	
	<!--- Funcion  para el boton atras de la parte superior  --->

	
	function funcbtnAnterior(){
		
		paso = parseInt(#form.paso#);
		NoPreguntas = parseInt(#RSEvaluaciones1.RecordCount#);
		CursorPreguntas = parseInt(#CursorPreguntas#);
		corteporpregunta = parseInt(#corteporpregunta#);
		mostrando = parseInt(#mostrando#);

		document.form1.btnAnterior.disabled= true;
		document.form1.btnAnterior2.disabled= true;
		if (((CursorPreguntas - (corteporpregunta+mostrando)) + 1)>0) {
			CursorPreguntas = (CursorPreguntas - (corteporpregunta+mostrando)) + 1;
			if (CursorPreguntas <= 0){
				CursorPreguntas = 1;
			}
			document.form1.CursorPreguntas.value = CursorPreguntas;
		}
		else{
			paso = paso - 1;
			document.form1.CursorPreguntas.value = 9999;
		}
		document.form1.paso.value = paso;
		document.form1.action = "Evaluacion_JefeFormSQL.cfm";
		document.form1.botonSelx.value="btnAnterior";
		document.form1.submit();
	}
	
	<!--- Funcion  para el boton siguiente de la parte inferior  --->
	
	function funcbtnSiguiente2(){
		return funcbtnSiguiente();
	}
	
	<!--- Funcion  para el boton atras de la parte inferior  --->
	
	function funcbtnAnterior2(){
		return funcbtnAnterior();
	}	
	
	function funcbtnInicio2(){
		funcbtnInicio();
		return false;
	}
	
	function informacion(llave,personas){
		var PARAM  = "Evaluacion_instrucciones.cfm?ventana=1&REid="+ llave + "&personas="+personas;
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
	}
	lockCol('tbl');
</script>
</cfoutput>
