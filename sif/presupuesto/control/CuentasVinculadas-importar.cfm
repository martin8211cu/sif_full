<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfquery name="rsPerPres" datasource="#Session.DSN#">
	Select 	CPPid,
			'Presupuesto ' #_Cat#
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#_Cat# ' de ' #_Cat# 
				case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
				#_Cat# ' a ' #_Cat# 
				case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as DescripcionPer	
	from CPresupuestoPeriodo
	where Ecodigo = #Session.Ecodigo#
		and CPPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
</cfquery>

<BR>
Importación de Cuentas Vinculadas para el Período de Presupuesto:
<BR>
<BR>
<cfoutput><strong>#rsPerPres.DescripcionPer#</strong></cfoutput>
<BR>
<BR>
<BR>

<cfset session.CPPid = form.CPPid>
<cf_sifimportar eicodigo="CP_VINCULADA" mode="in" width="100%" height="400">

