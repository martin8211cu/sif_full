<!---
<cfquery name="rsCorporativo" datasource="s d c ">
select 1
from UsuarioEmpresarial a, UsuarioEmpresa d, EmpresaID e, UsuarioPermiso b, Rol c, Empresa f, CuentaClienteEmpresarial g,
	 Empresa h, EmpresaID i
where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
  and a.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
  and a.Usucodigo = d.Usucodigo
  and a.Ulocalizacion = d.Ulocalizacion
  and a.cliente_empresarial = d.cliente_empresarial
  and a.activo = 1
  and d.activo = 1
  and d.Ecodigo = f.Ecodigo
  and d.cliente_empresarial = f.cliente_empresarial
  and f.activo = 1
  and e.Ecodigo = f.Ecodigo
  and e.sistema = 'rh'
  and e.consecutivo is not null
  and e.nombre_cache is not null
  and e.activo = 1
  and b.Usucodigo = d.Usucodigo
  and b.Ulocalizacion = d.Ulocalizacion
  and b.cliente_empresarial = d.cliente_empresarial
  and b.Ecodigo = d.Ecodigo
  and b.activo = 1
  and b.rol = c.rol
  and c.sistema = e.sistema
  and c.activo = 1
  and f.cliente_empresarial = g.cliente_empresarial
  and g.activo = 1
  and c.rol = 'rh.corp'
  and g.cache_empresarial = 1
  and g.cliente_empresarial = h.cliente_empresarial
  and h.Ecodigo = i.Ecodigo
  and h.activo = 1
  and i.sistema = e.sistema
  and i.consecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
  and i.activo = 1
</cfquery>
--->
