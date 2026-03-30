<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfquery name="qry_cvm" datasource="#session.dsn#">
	select
		case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
			#_Cat# ' de ' #_Cat# 
			case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
			#_Cat# ' a ' #_Cat# 
			case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
		as CPPdescripcion,
		(case a.CVtipo when '1' then 'Formulación de Aprobación Presupuesto Ordinario' when '2' then 'Formulación de Modificación Presupuesto Extraordinario' else '' end) 
		as Vdescripcion, a.CVdescripcion, 
		a.CVtipo, CVaprobada, CPPestado
	  from CVersion a
			inner join CPresupuestoPeriodo d
				 on d.Ecodigo 	= a.Ecodigo
				and d.CPPid 	= a.CPPid
	 where a.Ecodigo = #Session.Ecodigo#
	   and a.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
</cfquery>
<cfif isdefined("form.CVPcuenta") and len(form.CVPcuenta)>
	<cfquery name="qry_cvp" datasource="#session.dsn#">
		select a.CVPcuenta, a.CPformato, a.CPdescripcion
		from CVPresupuesto a
		where a.Ecodigo = #session.ecodigo#
			and a.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
			and a.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
	</cfquery>
</cfif>
<cfoutput>
<table border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td><strong>Versión de Presupuesto&nbsp;:&nbsp;</strong></td>
    <td>#qry_cvm.Vdescripcion# - #qry_cvm.CVdescripcion# </td>
  </tr>
  <tr>
    <td><strong>Per&iacute;odo de Presupuesto&nbsp;:&nbsp;</strong></td>
    <td>#qry_cvm.CPPdescripcion#</td>
  </tr>
</cfoutput>
<cfif isdefined("qry_cvp")>
  <tr>
    <td><strong>Cuenta Presupuesto&nbsp;:&nbsp;</strong></td>
    <td>
		<select name="CVPcuenta" onChange="form.submit();">
		<cfoutput query="qry_cvp">
			<option value="#qry_cvp.CVPcuenta#" <cfif isdefined("form.CVPcuenta") AND form.CVPcuenta EQ qry_cvp.CVPcuenta>selected</cfif>>#qry_cvp.CPformato# #qry_cvp.CPdescripcion#</option>
		</cfoutput>
		</select>
	</td>
  </tr>
</cfif>
</table>
