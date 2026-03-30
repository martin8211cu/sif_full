<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfif isdefined("form.CVid") and not isnumeric(form.CVid)>
	<cfthrow message="El valor de CVid: #form.CVid# no es numérico">
</cfif>
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
		(case a.CVtipo when '1' then 'Aprobación Presupuesto Ordinario' when '2' then 'Modificación Presupuesto Extraordinario' else '' end) 
		as Vdescripcion, a.CVdescripcion, 
		a.CVtipo, CVaprobada, CPPestado
	  from CVersion a
			inner join CPresupuestoPeriodo d
				 on d.Ecodigo 	= a.Ecodigo
				and d.CPPid 	= a.CPPid
	 where a.Ecodigo = #Session.Ecodigo#
	   and a.CVid = #form.CVid#
</cfquery>
<cfoutput>
	<tr>
    	<td width="1%" nowrap>
			<strong>Versión de Presupuesto&nbsp;:&nbsp;</strong>
		</td>
    	<td colspan="5">
			#qry_cvm.CVdescripcion# (#qry_cvm.Vdescripcion#)
			<input type="hidden" name="CVid" value="<cfif isdefined("form.CVid")>#form.CVid#</cfif>">
		</td>
	</tr>
	<tr>
    	<td>
			<strong>Per&iacute;odo Presupuestario&nbsp;:&nbsp;</strong>
		</td>
		<td nowrap>
			#qry_cvm.CPPdescripcion#
			<cfif isdefined("form.CPPid")>
			<input type="hidden" name="CPPid" id="CPPid" value="#form.CPPid#">
			</cfif>
		</td>
		<cfif pantalla NEQ 20>
		<td><strong>Centro Funcional:</strong></td>
		<td colspan="3">
			<cf_CPSegUsu_setCFid>
			<cf_CPSegUsu_cboCFid value="#form.CFid#" Formulacion="true" onChange="this.form.submit();">
		</td>
		</cfif>
	</tr>
</cfoutput>
