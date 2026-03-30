 <cfquery name="ERR" datasource="#session.dsn#">
	select 	 coalesce(a.DRNnombre,'') + '' + coalesce(a.DRNapellido1,'') + '' + coalesce(a.DRNapellido2,'') as Nombre,
			 substring(a.CBcc,1,3) as T_Cuenta,
			 coalesce(a.CBcc,'-1') as N_Cuenta,
			 1 as Subcuenta,
			 1 as T_Saldo,
			 a.DRNliquido as Monto,
			 b.ERNdescripcion as Detalle,
			 a.DRIdentificacion as Ref_1,
			 coalesce(a.DRNnombre,'') + '' + coalesce(a.DRNapellido1,'') + '' + coalesce(a.DRNapellido2,'') as Ref_2,
			 0 as Cod_Contable
	from DRNomina a
		inner join ERNomina b
		on a.ERNid = b.ERNid
		inner join DatosEmpleado de
			on a.DEid = de.DEid
	where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
	and	(a.DRNestado=2 or de.Bid is null) <!--- Marcados como para Pagar --->
</cfquery>

<cfif ERR.Recordcount EQ 0>
		<cfquery name="ERR" datasource="#session.dsn#">
			select 	 coalesce(a.HDRNnombre,'') + '' + coalesce(a.HDRNapellido1,'') + '' + coalesce(a.HDRNapellido2,'') as Nombre,
					 substring(a.CBcc,1,3) as T_Cuenta,
					 coalesce(a.CBcc,'-1') as N_Cuenta,
					 1 as Subcuenta,
					 1 as T_Saldo,
					 a.HDRNliquido as Monto,
					 b.HERNdescripcion as Detalle,
					 a.HDRIdentificacion as Ref_1,
					 coalesce(a.HDRNnombre,'') + '' + coalesce(a.HDRNapellido1,'') + '' + coalesce(a.HDRNapellido2,'') as Ref_2,
					 0 as Cod_Contable
			from HDRNomina a
				inner join HERNomina b
				on a.ERNid = b.ERNid
				inner join DatosEmpleado de
				on a.DEid = de.DEid
			where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
			and	(a.HDRNestado=2 or de.Bid is null) <!--- Marcados como para Pagar --->
		</cfquery>
</cfif>
