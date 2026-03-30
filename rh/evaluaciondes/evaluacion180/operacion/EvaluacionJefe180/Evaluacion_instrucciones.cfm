<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDePuestosActivos"
	Default="Lista de Puestos Activos"
	returnvariable="LB_ListaDePuestosActivos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<!--- Definición e inicialización de variables  --->
<cfif isdefined("url.REid") and not isdefined("form.REid")>
	<cfset form.REid = url.REid >
</cfif>
<cfif isdefined("url.personas") and not isdefined("form.personas")>
	<cfset form.personas = url.personas >
</cfif>
<cfif isdefined('url.RHPcodigo') and not isdefined('form.RHPcodigo')>
	<cfset form.RHPcodigo = url.RHPcodigo>
</cfif>
<!--- EVALUACIÓN --->
<cfquery name="rsRel" datasource="#session.DSN#">
	select REdescripcion,REdesde,REhasta,REindicaciones   
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

<html>
	<head>
		<title><cf_translate key="LB_InstruccionesDeLaEvaluacion">Instrucciones de la evaluación</cf_translate></title>
	</head>
	<body>
	<cfoutput>
	<cfif not isdefined("url.ventana")>
		<form action="Evaluacion_JefeForm.cfm" method="post" name="form1">
	</cfif>	
		<!--- ENCABEZADO DE LA EVALUACION 
		<cf_templatecss>--->
		<cfif not isdefined("url.ventana")>
		<table width="980" cellpadding="0" cellspacing="0">
			<tr><td colspan="3">&nbsp;</td></tr>

			<tr>
				<td width="780" align="right"><strong><cf_translate key="LB_Puesto">Puesto</cf_translate>:&nbsp;</strong></td>
				<td width="100" align="right" nowrap="true">
					<cfset valuesArray = ArrayNew(1)>
					<cfif isdefined('form.RHPcodigo') and RHPcodigo GT 0>
						<cfquery name="rsPuestoA" datasource="#session.DSN#">
							select coalesce(RHPcodigoext,RHPcodigo) as RHPcodigoext,RHPcodigo, RHPdescpuesto
							from RHPuestos
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
						</cfquery>
						<cfset ArrayAppend(valuesArray, rsPuestoA.RHPcodigoext)>
						<cfset ArrayAppend(valuesArray, rsPuestoA.RHPcodigo)>
						<cfset ArrayAppend(valuesArray, rsPuestoA.RHPdescpuesto)>
						
					</cfif>
					<cf_conlis title="#LB_ListaDePuestosActivos#"
						campos = "RHPcodigoext,RHPcodigo, RHPdescpuesto" 
						desplegables = "S,N,S" 
						modificables = "S,N,N"
						size = "15,0,25"
						valuesArray="#valuesArray#" 
						tabla="RHRegistroEvaluadoresE a
								inner join LineaTiempo lt 
									on lt.DEid = a.DEid	
									and lt.Ecodigo = a.Ecodigo
									and getDate() between lt.LTdesde and lt.LThasta
								inner join RHPlazas p 
									on p.Ecodigo = lt.Ecodigo 
									and p.RHPid = lt.RHPid 
								inner join RHPuestos pp 
									on pp.RHPcodigo = p.RHPpuesto 
									and pp.Ecodigo = p.Ecodigo"
						columnas="distinct pp.RHPcodigo,coalesce(pp.RHPcodigoext,pp.RHPcodigo) as RHPcodigoext,pp.RHPdescpuesto"
						filtro="lt.Ecodigo = #Session.Ecodigo# 
								and a.REid = #form.REid#
								and a.REEevaluadorj = #rsDEid.DEid#"
						desplegar="RHPcodigoext, RHPdescpuesto"
						etiquetas="#LB_Codigo#, #LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						asignar="RHPcodigoext,RHPcodigo, RHPdescpuesto"
						asignarformatos="S,S"
						filtrar_por="pp.RHPcodigoext,pp.RHPcodigo,pp.RHPdescpuesto"
						tabindex="1"
						alt="#LB_Codigo#,ID,#LB_Descripcion#">
				</td>
			</tr>
			<tr>
				<td width="580" align="right">&nbsp;</td>
				<td width="300" colspan="2"><strong><cf_translate key="LB_SeleccioneUnPuestoParaEvaluar">Seleccione un puesto para Evaluar</cf_translate></strong></td>
			</tr>
			<tr><td colspan="3">&nbsp;</td></tr>
		</table>		
			<table width="980">
				<tr >
					<td align="center">
					  <cfset Vbotones =  "Siguiente">
					  <cfset Nbotones =  "btnSiguiente">
					   <cf_botones values="#Vbotones#" names="#Nbotones#" tabindex="1"> 
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</cfif>	
		<table width="<cfif not isdefined("url.ventana")>980<cfelse>100%</cfif>">
			<tr>
				<td align="center">
					<strong><cf_translate key="LB_EVALUACIONDEHABILIDADES">EVALUACI&Oacute;N DE HABILIDADES</cf_translate></strong> 
				</td> 
			<tr>
			</tr>	
				<td align="center" >
					<strong>
					#rsRel.REdescripcion#&nbsp;&nbsp;<cf_translate key="LB_Del">del</cf_translate>&nbsp;#lsdateformat(rsRel.REdesde,"DD/MM/YYYY")#&nbsp;&nbsp;<cf_translate key="LB_Al">al</cf_translate>&nbsp;#lsdateformat(rsRel.REhasta,"DD/MM/YYYY")#
					</strong>
				</td>
			</tr>
			<tr>	
				<td height="26" align="center">
					<strong><cf_translate key="LB_Evaluador">Evaluador</cf_translate>:</strong>&nbsp;&nbsp; #rsEvaluador.nombre# &nbsp;&nbsp; <strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:</strong>&nbsp;&nbsp;#lsdateformat(now(),"DD/MM/YYYY")# &nbsp;&nbsp; <strong><cf_translate key="LB_CentroFuncional">Centro Fucional</cf_translate>:</strong> &nbsp;&nbsp; #rsEvaluador.CFdescripcion#	   
			  </td>
			</tr>
			<tr>
				<td align="center">
					<strong><cf_translate key="LB_InstruccionesDeLaEvaluacion">Instrucciones de la evaluaci&oacute;n</cf_translate></strong>
				</td>
 		    </tr> 
	</table>
	
	<!---
	<cfif not isdefined("url.ventana")>
		<cfset tamano =  (#form.personas#* 24) + 70>
		<div id="tbl-ayuda"  style="overflow: auto; width: 980px; height: #tamano#px;">
		<table width="980" >
	<cfelse>
		<div id="tbl-ayuda"  style="overflow: auto; width: 720px; height: 400px;">
	<table width="100%" >	
	</cfif>
			<tr>
				<td>
					#rsRel.REindicaciones#
				</td> 
			<tr>
		</table>
	</div>
	--->
	
	<cfif not isdefined("url.ventana")>
		<cfset tamano =  (form.personas* 24) + 275>
		<!---<div id="tbl-ayuda"  style="overflow: auto; width: 980px; height: #tamano#px;">--->
		<iframe frameborder="0" id="indicaciones" style="overflow:auto; margin:0; border:1px solid white;"  height="#tamano#" width="980" src="../indicaciones.cfm?REid=#form.REid#">
	<cfelse>
		<!---<div id="tbl-ayuda"  style="overflow: auto; width: 720px; height: 400px;">--->
		<iframe frameborder="0" id="indicaciones" style="overflow:auto; margin:0; border:1px solid white;"  height="400" width="720" src="../indicaciones.cfm?REid=#form.REid#">
	</cfif>
	</iframe>	
	<script>
		document.getElementById("indicaciones").src = '../indicaciones.cfm?REid=#form.REid#';
	</script>
	
	
	<cfif not isdefined("url.ventana")>
		<table width="980">
			<tr >
				<td align="center">
				  <cfset Vbotones =  "Siguiente">
				  <cfset Nbotones =  "btnSiguiente">
				   <cf_botones values="#Vbotones#" names="#Nbotones#" tabindex="2"> 
				</td>
			</tr>
		</table>
	</cfif>	
		<input type="hidden" name="REid" value="#form.REid#">
		<input type="hidden" name="paso" value="1">
		<input type="hidden" name="personas" value="#form.personas#">
		</form>

	</cfoutput>	
	
	</body>
</html>

