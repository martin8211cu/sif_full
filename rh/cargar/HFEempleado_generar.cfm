
<cfquery datasource="#Gvar.Conexion#" name="consulta" >
	insert into FEmpleado (	DEid, 
							NTIcodigo, 
							FEidentificacion, 
							Pid, 
							FEnombre, 
							FEapellido1, 
							FEapellido2, 
							FEfnac, 
							FEdir, 
							FEsexo, 
							Usucodigo,
							Ulocalizacion)
								
	select	b.DEid as DEid,	<!----CDRHHDEidentificacion,---->			
			CDRHHNTIcodigo as NTIcodigo,
			CDRHHFEidentificacion as FEidentificacion,
			CDRHHPid as Pid,
			CDRHHFEnombre as FEnombre,
			CDRHHFEapellido1 as FEapellido1,
			CDRHHFEapellido2 as FEapellido2,
			CDRHHFEfnac as FEfnac,
			CDRHHFEdir as FEdir,
			CDRHHFEsexo as FEsexo,		
			#Session.Usucodigo# as Usucodigo,
			' ' as Ulocalizacion
	from #Gvar.table_name# a, DatosEmpleado b, RHParametros param		
	where ltrim(rtrim(a.CDRHHDEidentificacion)) = ltrim(rtrim(b.DEidentificacion))
		and param.Ecodigo = b.Ecodigo
		and param.Pcodigo = 30	
		and CDPcontrolv = 1
		and CDPcontrolg = 0
		and b.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<!---
<cfquery datasource="#Gvar.Conexion#" name="bbb" >

select	b.DEid as DEid,	<!----CDRHHDEidentificacion,---->			
			CDRHHNTIcodigo as NTIcodigo,
			CDRHHFEidentificacion as FEidentificacion,
			CDRHHPid as Pid,
			CDRHHFEnombre as FEnombre,
			CDRHHFEapellido1 as FEapellido1,
			CDRHHFEapellido2 as FEapellido2,
			CDRHHFEfnac as FEfnac,
			CDRHHFEdir as FEdir,
			CDRHHFEsexo as FEsexo,
			convert(bit,CDRHHAplicaCredFiscal) as FEdeducrenta,			
			c.CDid as FEidconcepto,	<!---CDRHHCDcodigo,--->
	--		CDRHHFechadesdeAplica as FEdeducdesde,
	--		CDRHHFechahastaAplica as FEdeduchasta,
			#Session.Usucodigo# as Usucodigo,
			' ' as Ulocalizacion
	from #Gvar.table_name# a, DatosEmpleado b, RHParametros param		
	where ltrim(rtrim(a.CDRHHDEidentificacion)) = ltrim(rtrim(b.DEidentificacion))
	--	and ltrim(rtrim(a.CDRHHCDcodigo)) = ltrim(rtrim(c.CDcodigo))
		and param.Ecodigo = b.Ecodigo
		and param.Pcodigo = 30
		and coalesce(param.Pvalor,'0') = c.IRcodigo 		
		and CDPcontrolv = 1
		and CDPcontrolg = 0
		and b.Ecodigo = #Gvar.Ecodigo#

</cfquery>

<cf_dump var="#bbb#"> --->