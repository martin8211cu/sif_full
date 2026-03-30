<cfset filtro = "b.Ecodigo = " & Session.Ecodigo & " and a.CIid = b.CIid and a.DEid = c.DEid and CItipo != 3" ><!------and CItipo != 3--->
<cfset filtro2 = "and b.Ecodigo = " & Session.Ecodigo >

<cfif isdefined("url.Usuario") and Len(Trim(url.Usuario)) NEQ 0 and url.Usuario NEQ "-1">
	<cfset filtro = filtro & " and a.Usucodigo = #url.Usuario#" >
	<cfset filtro2 = filtro2 & " and a.Usucodigo = #url.Usuario#" >
<cfelseif isdefined("url.Usuario") and Len(Trim(url.Usuario)) NEQ 0 and url.Usuario EQ "-1">
	<cfset filtro = "b.Ecodigo = " & #Session.Ecodigo# >
	<cfset filtro = filtro & " and a.CIid = b.CIid and a.DEid = c.DEid and CItipo != 3" ><!---and CItipo != 3--->	
<cfelse>	
	<cfset filtro =  filtro & " and a.Usucodigo = " & Session.Usucodigo & " and a.Ulocalizacion = '" & Session.Ulocalizacion & "'">
	<cfset filtro2 =  filtro2 & " and a.Usucodigo = " & Session.Usucodigo & " and a.Ulocalizacion = '" & Session.Ulocalizacion & "'">	
</cfif>
<cfif isdefined("url.DEid1") and len(trim(url.DEid1)) gt 0>
	<cfset filtro = filtro & " and a.DEid=" & url.DEid1>
	<cfset filtro2 = filtro2 & " and a.DEid=" & url.DEid1>
</cfif>
<cfif isdefined("url.CIid_f") and len(trim(url.CIid_f)) gt 0>
	<cfset filtro = filtro & " and a.CIid=" & url.CIid_f>
	<cfset filtro2 = filtro2 & " and a.CIid=" & url.CIid_f>
</cfif>

<cfif isdefined("url.Ffecha") and len(trim(url.Ffecha)) gt 0 >
	<cfset filtro = filtro & " and a.Ifecha =" & LSParseDateTime(url.Ffecha) >
	<cfset filtro2 = filtro2 & " and a.Ifecha =" & LSParseDateTime(url.Ffecha)>
</cfif>

<cfif isdefined("url.IfechaRebajo_f") and len(trim(url.IfechaRebajo_f)) gt 0 >
	<cfset filtro  = filtro & " and a.IfechaRebajo  =" & LSParseDateTime(url.IfechaRebajo_f) >
	<cfset filtro2 = filtro2 & " and a.IfechaRebajo  =" & LSParseDateTime(url.IfechaRebajo_f)>
</cfif>

<cfif isdefined("url.CFid_f") and len(trim(url.CFid_f)) gt 0>
	<cfset filtro = filtro & " and CFid=" & url.CFid_f>
	<cfset filtro2 = filtro2 & " and CFid=" & url.CFid_f>
</cfif>

<cfif isdefined("url.FIcpespecial_f") and len(trim(url.FIcpespecial_f)) and url.FIcpespecial_f EQ 1>
	<cfset filtro = filtro & " and a.Icpespecial=1">
	<cfset filtro2 = filtro2 & " and a.Icpespecial=1">
<cfelse>
	<cfset filtro = filtro & " and a.Icpespecial=0">
	<cfset filtro2 = filtro2 & " and a.Icpespecial=0">
</cfif>


<cfquery name="rsLista" datasource="#Session.DSN#">								
	select 	a.Iid, 
			b.CIid,
			c.DEid,
			b.CIdescripcion, 
			a.Ifecha, 
			case b.CItipo  	when 0 then { fn concat (<cf_dbfunction name="to_char" args="Ivalor">, ' hora(s)' ) }
							when 1 then { fn concat (<cf_dbfunction name="to_char" args="Ivalor">, ' día(s)' ) }
							else <cf_dbfunction name="to_char" args="Ivalor"> end as Ivalor,
			{fn concat({fn concat({fn concat({ fn concat( c.DEnombre, ' ') }, c.DEapellido1)}, ' ')}, c.DEapellido2) }  as NombreEmp,
			case when a.Icpespecial = 0 
				then '<img src="/cfmx/rh/imagenes/unchecked.gif">'
				else '<img src="/cfmx/rh/imagenes/checked.gif">' 
			end as Icpespecial
			<!---#vs_select#--->
		
	from  Incidencias a, CIncidentes b, DatosEmpleado c
	where #preservesinglequotes(filtro)#
		and not exists (select 1 
						from RCalculoNomina x, IncidenciasCalculo z
						where RCestado <> 0
						  and z.RCNid = x.RCNid
						  and z.Iid = a.Iid
						)
	UNION
	<!----Incidencias tipo calculo que se pueden mostrar por el bit CInomostrar en 0....---->	
	select 	a.Iid, 
			b.CIid,
			c.DEid,
			b.CIdescripcion, 
			a.Ifecha, 
			case b.CItipo  	when 0 then { fn concat (<cf_dbfunction name="to_char" args="Ivalor">, ' hora(s)' ) }
							when 1 then { fn concat (<cf_dbfunction name="to_char" args="Ivalor">, ' día(s)' ) }
							else <cf_dbfunction name="to_char" args="Ivalor"> end as Ivalor,
			{fn concat({fn concat({fn concat({ fn concat( c.DEnombre, ' ') }, c.DEapellido1)}, ' ')}, c.DEapellido2) }  as NombreEmp,
			case when a.Icpespecial = 0 
				then '<img src="/cfmx/rh/imagenes/unchecked.gif">'
				else '<img src="/cfmx/rh/imagenes/checked.gif">' 
			end as Icpespecial
			<!---#vs_select#--->
		
	from  Incidencias a, CIncidentes b, DatosEmpleado c
	where a.CIid = b.CIid 
		and a.DEid = c.DEid
		and b.CItipo = 3
		and coalesce(b.CInomostrar,0) = 0
		#preservesinglequotes(filtro2)#
		and not exists (select 1 
						from RCalculoNomina x, IncidenciasCalculo z
						where RCestado <> 0
						  and z.RCNid = x.RCNid
						  and z.Iid = a.Iid
						)				
	order by 5
	<!---order by a.Ifecha--->
</cfquery>	


<cfquery dbtype="query" name="rsRepetidos">
	select * from rsLista 
	where CIid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CIid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
	and Ifecha = <cfqueryparam cfsqltype="cf_sql_date" value="#form.Ifecha#">
</cfquery>


<cfif rsRepetidos.REcordcount gt 0>
	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_fecha"
	default="Fecha"
	returnvariable="vFecha"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Concepto_Incidente"
	default="Concepto Incidente"
	returnvariable="vConceptoI"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Empleado"
	default="Empleado"
	returnvariable="vEmpleado"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_CantidadMonto"
	default="Cantidad/Monto"
	returnvariable="vCantidadMonto"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Mensaje"
	default="El Concepto incidente que desea agregar, ya fue agregado para la misma fecha que indica, Esta seguro que desea Continuar?"
	returnvariable="v_Mensaje"/>	
		
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
		<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		<script language="JavaScript" type="text/JavaScript">
		<!--
		function MM_reloadPage(init) {  //reloads the window if Nav4 resized
		  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
			document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
		  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
		}
		MM_reloadPage(true);
		//-->
		</script>
	
	
	<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Incidencias"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>

	<cf_web_portlet_start titulo="#nombre_proceso#">
	<cfoutput>
	<form  name="formConfirmar" method="get" action="IncidenciasProceso-sql.cfm">
		<cfif isdefined("url.Ifecha")><input name="Ifecha" id="Ifecha" value="#url.Ifecha#" type="hidden"></cfif>
		<cfif isdefined("url.Ivalor")><input name="Ivalor" id="Ivalor" value="#url.Ivalor#" type="hidden"></cfif>
		<cfif isdefined("url.DEid")><input name="DEid" id="DEid" value="#url.DEid#" type="hidden"></cfif>
		<cfif isdefined("url.CIid")><input name="CIid" id="CIid" value="#url.CIid#" type="hidden"></cfif>
		<cfif isdefined("url.CFid")><input name="CFid" id="CFid" value="#url.CFid#" type="hidden"></cfif>
		<cfif isdefined("url.RHJid")><input name="RHJid" id="RHJid" value="#url.RHJid#" type="hidden"></cfif>
		<cfif isdefined("url.Icpespecial")><input name="Icpespecial" id="Icpespecial" value="#url.Icpespecial#" type="hidden"></cfif>
		<cfif isdefined("url.IfechaRebajo")><input name="IfechaRebajo" id="IfechaRebajo" value="#url.IfechaRebajo#" type="hidden"></cfif>
		<cfif isdefined("url.Iid")><input name="Iid" id="Iid" value="#url.Iid#" type="hidden"></cfif>
		<cfif isdefined("url.Usuario")><input name="Usuario" id="Usuario" value="#url.Usuario#" type="hidden"></cfif>
		<cfif isdefined("url.Pagina")><input name="Pagina" id="Pagina" value="#url.Pagina#" type="hidden"></cfif>	
		<cfif isdefined("url.cambio")><input name="Pagina" id="Pagina" value="#url.Pagina#" type="hidden"></cfif>
		<cfif isdefined("url.baja")><input name="baja" id="baja" value="#url.baja#" type="hidden"></cfif>
		<cfif isdefined("url.alta")><input name="alta" id="alta" value="#url.alta#" type="hidden"></cfif>
		<cfif isdefined("url.Nuevo")><input name="Nuevo" id="Nuevo" value="#url.Nuevo#" type="hidden"></cfif>
		<cfif isdefined("url.ts_rversion")><input name="ts_rversion" id="ts_rversion" value="#url.ts_rversion#" type="hidden"></cfif>
		
		<input name="confirmado" id="confirmado" value="0" type="hidden">
		
		<table width="95%" align="center" border="0" cellspacing="0" cellpadding="1">	
			<tr><td colspan="2">&nbsp;
				
			</td></tr>
			<tr><td colspan="2" style="color:FF0000; font-size:12px" align="center">
				<strong>#v_Mensaje#</strong>
			</td></tr>
			<tr><td colspan="2">
				<table width="95%" align="center" border="0" cellspacing="0" cellpadding="1">	
				<tr style="background-color:CCCCCC">
					<td><strong>#vFecha#</strong></td>
					<td><strong>#vConceptoI#</strong></td>
					<td><strong>#vEmpleado#</strong></td>
					<td><strong>#vCantidadMonto#</strong></td>
				</tr>
				<cfloop query="rsRepetidos">
					<tr>
					<td>#rsRepetidos.Ifecha#</td>
					<td>#rsRepetidos.CIdescripcion#</td>
					<td>#rsRepetidos.NombreEmp#</td>
					<td>#rsRepetidos.Ivalor#</td>
					</tr>
				</cfloop>
				</table>
			</td></tr>
			<tr><td align="right"><input name="BTNConfirmado" type="button" value="Confirmar" onClick="javascript: submitGo(1);"></td>
				<td align="left"><input name="BTNCancelar"   type="button" value="Cancelar" onClick="javascript: submitGo(0);"></td>
			</tr>
		</table>
	</form>
	</cfoutput>
	
	<cf_web_portlet_end>
	<cf_templatefooter>	
	
	<script language="javascript" type="text/javascript">
		function submitGo (tipo){
			if (tipo == 1){
				document.formConfirmar.confirmado.value=1;
				document.formConfirmar.action='IncidenciasProceso-sql.cfm';
				document.formConfirmar.submit();
			}
			else{
				document.formConfirmar.confirmado.value=0;
				document.formConfirmar.action='IncidenciasProceso.cfm';
				document.formConfirmar.submit();
			}
		}
	</script>
	
	<cfabort>
	
</cfif>