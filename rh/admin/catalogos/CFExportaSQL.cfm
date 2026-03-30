<cfquery name="rsSQL" datasource="#session.dsn#">
	select	cf.CFpath
	  from CFuncional cf
	   where cf.CFid	=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#">
</cfquery>	

<cfquery name="err" datasource="#session.dsn#">
	select
			cf.CFcodigo as COD_CF,
			cf.CFdescripcion as DESCRIPCION,
			d.Deptocodigo as COD_DEPTO,
			cr.CFcodigo as COD_CRESPONASABLE,
			co.CMCcodigo as COD_COMPRADOR,
			cf.CFcuentac as C_GASTO,
			cf.CFcuentainventario as C_INVENTARIO,
			cf.CFcuentainversion as C_INVERSION,
			cf.CFcuentaaf as C_ACTIVO,
			cf.CFcuentaingreso as C_INGRESO,
			cf.CFcuentagastoretaf as C_OTROSINGRESOS,
			cf.CFcuentaingresoretaf as C_OTROSGASTOS,
			usu.Usulogin as USU_RESP,
			o.Oficodigo as COD_OFICINA
	  from CFuncional cf
	  		inner join Oficinas o
				on o.Ecodigo=cf.Ecodigo
				and o.Ocodigo=cf.Ocodigo
			inner join Departamentos d
				on d.Ecodigo=cf.Ecodigo
				and d.Dcodigo=cf.Dcodigo
			left join CMCompradores co
				on co.CMCid=cf.CFcomprador
				and co.Ecodigo=cf.Ecodigo
			left join CFuncional cr
				on cr.CFid=cf.CFidresp
				and cr.Ecodigo=cf.Ecodigo
			left join Usuario usu
				on usu.Usucodigo=cf.CFuresponsable
	   where cf.Ecodigo	= #session.Ecodigo#
	     and cf.CFpath like '#trim(rsSQL.CFpath)#%'
</cfquery>