<cfset modo = "ALTA">

<cfif isdefined("Url.paso") and Len(Trim(Url.paso))>
	<cfparam name="Form.paso" default="#Url.paso#">
<cfelse>
	<cfparam name="Form.paso" default="1">
</cfif>

<cfif isdefined("Url.RHAid") and Len(Trim(Url.RHAid))>
	<cfparam name="Form.RHAid" default="#Url.RHAid#">
</cfif>

<cfif isdefined("Form.RHAid") and Len(Trim(Form.RHAid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif Form.paso EQ 0>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Lista_de_Acciones"
		Default="Lista de Acciones"	
		returnvariable="LB_Lista_de_Acciones"/>
	<cfset titulo = "#LB_Lista_de_Acciones#">
<cfelseif Form.paso EQ 1>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Accion_de_Personal"
		Default="Acci&oacute;n de Personal"	
		returnvariable="LB_Accion_de_Personal"/>
	<cfset titulo = "#LB_Accion_de_Personal#">
<cfelseif Form.paso EQ 2>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Componentes_Salariales"
		Default="Componentes Salariales"	
		returnvariable="LB_Componentes_Salariales"/>
	<cfset titulo = "#LB_Componentes_Salariales#">
<cfelseif Form.paso EQ 3>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Trabajar_con_Periodos"
		Default="Trabajar con Per&iacute;odos"	
		returnvariable="LB_Trabajar_con_Periodos"/>
	<cfset titulo = "#LB_Trabajar_con_Periodos#">
<cfelseif Form.paso EQ 4>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Seleccionar_Empleados"
		Default="Seleccionar Empleados"	
		returnvariable="LB_Seleccionar_Empleados"/>
	<cfset titulo = "#LB_Seleccionar_Empleados#">
<cfelseif Form.paso EQ 5>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Aprobar_Accion"
		Default="Aprobar Acci&oacute;n"	
		returnvariable="LB_Aprobar_Accion"/>
	<cfset titulo = "#LB_Aprobar_Accion#">
<cfelseif Form.paso EQ 6>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Aplicar_Accion"
		Default="Aplicar Acci&oacute;n"	
		returnvariable="LB_Aplicar_Accion"/>
	<cfset titulo = "#LB_Aplicar_Accion#">
<cfelse>
	<cfset titulo = "">
</cfif>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsDatosAccion" datasource="#Session.DSN#">
		select a.RHAid, a.RHTAid, rtrim(a.RHAcodigo) as RHAcodigo, rtrim(a.RHAdescripcion) as RHAdescripcion, a.RHCPlinea, a.RHAfdesde, a.RHAfhasta, a.Ecodigo,
			   rtrim(a.Tcodigo) as Tcodigo, a.RVid, a.Ocodigo, a.Dcodigo, rtrim(a.RHPcodigo) as RHPcodigo, a.RHAporcsal, a.RHAporc, a.RHJid, 
			   a.RHAidliquida, a.RHAAnoreconocidos, a.RHAAperiodom, a.RHAAnumerop, a.BMUsucodigo, a.ts_rversion,
			   b.RHTid, b.RHTAcodigo, b.PCid, b.RHTAdescripcion, b.RHTAcomportamiento, b.RHTAaplicaauto, b.RHTAcempresa, 
			   b.RHTActiponomina, b.RHTAcregimenv, b.RHTAcoficina, b.RHTAcdepto, b.RHTAcplaza, b.RHTAcpuesto, 
			   b.RHTAccomp, b.RHTAcsalariofijo, b.RHTAccatpaso, b.RHTAcjornada, b.RHTAidliquida, b.RHTAevaluacion, 
			   b.RHTAnotaminima, b.RHTAperiodos, b.RHTAfutilizap, b.RHTArespetarLT, c.RHTpfijo,
			   s.RHTTid, rtrim(s.RHTTcodigo) as RHTTcodigo, s.RHTTdescripcion, 
			   t.RHCid, rtrim(t.RHCcodigo) as RHCcodigo, t.RHCdescripcion, 
			   u.RHMPPid, rtrim(u.RHMPPcodigo) as RHMPPcodigo, u.RHMPPdescripcion
		from RHAccionesMasiva a
			inner join RHTAccionMasiva b
				on b.RHTAid = a.RHTAid
			inner join RHTipoAccion c
				on c.RHTid = b.RHTid
			left outer join RHCategoriasPuesto r
				on r.RHCPlinea = a.RHCPlinea
			left outer join RHTTablaSalarial s
				on s.RHTTid = r.RHTTid
			left outer join RHCategoria t
				on t.RHCid = r.RHCid
			left outer join RHMaestroPuestoP u
				on u.RHMPPid = r.RHMPPid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
	</cfquery>
</cfif>

<style type="text/css">
	input.botonUp2 {font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray}
</style>

