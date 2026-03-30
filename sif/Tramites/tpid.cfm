<!--- Validar parametros --->
<cfif isdefined("url.TPID")>
	<cfset TPID=url.TPID>
<cfelseif isdefined("form.TPID")>
	<cfset TPID=form.TPID>
<cfelse>
	<cflocation url="error.cfm?msg=tpid-faltante">
</cfif>
<cfquery datasource="sdc" name="tramite">
select 
	convert (varchar, a.TPID) as TPID, a.Cedula, a.Avance, a.Pestado,
	a.Pnombre, a.Pexpedido, a.Pexpira,
	a.Accion,  convert (varchar, a.FechaInicio, 103) as FechaInicio, 
	convert (varchar, isnull (a.FechaFin, getdate()), 103) as FechaFin,
	a.Mcodigo, a.Importe,
	convert (varchar, a.TIcodigo) as TIcodigo,
	a.Iaba,  a.CBTcodigo,  rtrim(a.CBcodigo)  as CBcodigo,
	a.IabaD, a.CBTcodigoD, rtrim(a.CBcodigoD) as CBcodigoD, b.Miso4217,
	c.CBdescripcion, c.CBofxusuario,
	c.CBofxacctkey, d.AccionNombre, e.EstadoNombre, f.TIsrvrtid
from TramitePasaporte a, Moneda b, CtaBancaria c, TramitePasaporteAccion d, TramitePasaporteEstado e, Transferencia f
where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
  and a.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
  and a.TPID = <cfqueryparam cfsqltype="cf_sql_decimal" value="#TPID#">
  and b.Mcodigo =* a.Mcodigo
  and c.Iaba =* a.Iaba
  and c.CBcodigo =* a.CBcodigo
  and c.CBTcodigo =* a.CBTcodigo
  and d.Accion =* a.Accion
  and e.Pestado =* a.Pestado
  and f.TIcodigo =* a.TIcodigo
</cfquery>
<!--- <cfdump var="#mydata#"> --->
<cfif tramite.RecordCount EQ 0 >
	<cflocation url="/cfmx/sif/Tramites/error.cfm?msg=tpid-invalido&tpid=#TPID#">
</cfif>