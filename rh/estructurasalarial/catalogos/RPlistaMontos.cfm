<!---------
	Creado por: Ana Villavicencio
		Fecha de modificación: 26 de mayo del 2005
		Motivo: frame para el nuevo reporte de Estados de cuentas masivo
	Modficado por: Gustavo Fonseca H.
		Fecha: 28-10-2005.
		Motivo: Se le agregó la clausula order by y se modificó el query para que utilizara la tabla TransaccionesBanco.
----------->

<cfif isdefined("url.RHTTid") and  not isdefined("form.RHTTid")>
	<cfset form.RHTTid = url.RHTTid>
</cfif>
<cfif isdefined("url.RHVTid") and  not isdefined("form.RHVTid")>
	<cfset form.RHVTid = url.RHVTid>
</cfif>

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!--- DATOS DE TABLA SALARIAL --->
<cfquery name="rsPadre" datasource="#Session.DSN#">
	select codigo = RHTTcodigo, descripcion = RHTTdescripcion
	from RHTTablaSalarial
	where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
</cfquery>

<cfquery name="rsReporte" datasource="#session.dsn#">

	select a.RHCPlinea, c.CSdescripcion, a.RHMCmontomax, a.RHMCmontomin, a.RHMCmonto, 
		   rtrim(t.RHCcodigo) as RHCcodigo, rtrim(u.RHMPPcodigo) as RHMPPcodigo,
		   rtrim(t.RHCcodigo) || ' - '||t.RHCdescripcion as Categoria,
		   rtrim(u.RHMPPcodigo) || ' - '||u.RHMPPdescripcion as Puesto,
		   RHVTfecharige, RHVTfechahasta
	from RHMontosCategoria a
		inner join RHVigenciasTabla b
			on b.RHVTid = a.RHVTid
			and b.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
		inner join ComponentesSalariales c
			on c.CSid = a.CSid
		left outer join RHCategoriasPuesto r
			on r.RHCPlinea = a.RHCPlinea
		left outer join RHTTablaSalarial s
			on s.RHTTid = r.RHTTid
		left outer join RHCategoria t
			on t.RHCid = r.RHCid
		left outer join RHMaestroPuestoP u
			on u.RHMPPid = r.RHMPPid
	where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
	order by t.RHCcodigo, u.RHMPPcodigo
</cfquery>

<cfif isdefined('rsReporte') and rsReporte.RecordCount GT 0> 
	<cfreport format="FLASHPAPER" template= "RPlistaMontos.cfr" query="rsReporte">
		<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
			<cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">
		</cfif>
		<cfif isdefined('rsPadre') and rsPadre.RecordCount GT 0>
			<cfreportparam name="CodPadre" value="#rsPadre.codigo#">
			<cfreportparam name="DescPadre" value="#rsPadre.descripcion#">
		</cfif>
	</cfreport>
<cfelse>
	<table align="center" cellpadding="0" cellspacing="0">
		<tr><td align="center">----- No hay datos relacionados -----</td></tr>
	</table>
</cfif>