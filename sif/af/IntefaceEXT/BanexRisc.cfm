<cfsetting requesttimeout="36000">

<cf_dbtemp name="INT_RISK_BANEX" returnvariable="INT_RISK_BANEX" datasource="#session.dsn#">
	<cf_dbtempcol name="COD_COMPAN"    type="varchar(30)"   mandatory="yes">
	<cf_dbtempcol name="FEC_ASIENT"    type="varchar(30)"   mandatory="yes">
	<cf_dbtempcol name="CONSECUTIV"    type="numeric"  		mandatory="yes">
	<cf_dbtempcol name="CFUNCIONAL"    type="varchar(30)"	mandatory="yes">
	<cf_dbtempcol name="USUARIOCIF"    type="varchar(100)"	mandatory="yes">
	<cf_dbtempcol name="USUARIONOM"    type="varchar(100)"	mandatory="yes">
	<cf_dbtempcol name="CTAMAYOR"      type="varchar(100)"	mandatory="yes">
	<cf_dbtempcol name="CUENTA"    	   type="varchar(100)"	mandatory="yes">
	<cf_dbtempcol name="SUBCUENTA"     type="varchar(100)"	mandatory="yes">
	<cf_dbtempcol name="DESCRIPCI"     type="varchar(100)"	mandatory="yes">
	<cf_dbtempcol name="DETALLE"   	   type="varchar(100)"	mandatory="yes">
	<cf_dbtempcol name="DEBITOS"       type="money"    		mandatory="yes">
	<cf_dbtempcol name="CREDITOS"      type="money"			mandatory="yes">
	<cf_dbtempcol name="NETO"   	   type="money"    		mandatory="yes">
	<cf_dbtempcol name="CUENTAGASTO"   type="varchar(100)"	mandatory="no">
	<cf_dbtempcol name="FormatoCta"   type="varchar(100)"	mandatory="no">
	<cf_dbtempcol name="ACgastodep"   type="varchar(100)"	mandatory="no">	
</cf_dbtemp>

<cftransaction>
	<!--- query de exportación --->
	<cfquery name="Ins_ERR" datasource="#session.DSN#">
		INSERT #INT_RISK_BANEX#(COD_COMPAN, 
								FEC_ASIENT, 
								CONSECUTIV, 
								CFUNCIONAL, 
								USUARIOCIF, 
								USUARIONOM, 
								CTAMAYOR,
								CUENTA, 	
								SUBCUENTA,  
								DESCRIPCI,  
								DETALLE,    
								DEBITOS, 	
								CREDITOS, 	
								NETO,
								FormatoCta,
								ACgastodep)
		select
								e.Etelefono2 as COD_COMPAN,
								convert(varchar,t.TAfecha,103) as FEC_ASIENT,
								t.TAid as CONSECUTIV,

								{fn concat({fn SUBSTRING(cf.CFcodigo,1,2)},
								 	{fn concat(' ',{fn concat({fn SUBSTRING(cf.CFcodigo,3,2)} ,
										{fn concat(' ' ,{fn concat({fn SUBSTRING(cf.CFcodigo,5,2)} ,
											{fn concat(' ' ,{fn concat({fn SUBSTRING(cf.CFcodigo,7,2)} ,
												{fn concat(' ' ,{fn SUBSTRING(cf.CFcodigo,9,2)})})})})})})})})} as CFUNCIONAL,

								u.Usulogin as USUARIOCIF,
								{fn concat({fn concat({fn concat({fn concat(dp.Pnombre , ' ' )}, dp.Papellido1 )}, ' ' )}, dp.Papellido2 )}as USUARIONOM ,

								coalesce(adc.cocMayorRISK,'EQUIVALENCIA NO EXISTE PARA --> ' + '44' + cla.ACgastodep) as CTAMAYOR,
								coalesce(adc.cocCuentaRISK,'--') as CUENTA,
								coalesce(adc.cocSubCuentaRISK, '--') as SUBCUENTA,
								coalesce(adc.desCuenta,'--') as DESCRIPCI,
								coalesce(a.Adescripcion,'--') as DETALLE,

								coalesce(t.TAmontolocadq,0.00) + coalesce(t.TAmontolocmej,0.00) + coalesce(t.TAmontolocrev,0.00) as DEBITOS,
								0.00 as CREDITOS,
								coalesce(t.TAmontolocadq,0.00) + coalesce(t.TAmontolocmej,0.00) + coalesce(t.TAmontolocrev,0.00) as NETO,

								coalesce(cf.CFcuentaaf, cf.CFcuentac) as FormatoCta,
								cla.ACgastodep
		from TransaccionesActivos t
		inner join Empresas f
			on f.Ecodigo = t.Ecodigo
		inner join <cf_dbdatabase table="Empresa" datasource="#session.dsn#"> e
			on e.Ecodigo = f.EcodigoSDC
		inner join CFuncional cf
			on cf.CFid = t.CFid
		inner join Usuario u
			on u.Usucodigo = t.Usucodigo
		inner join DatosPersonales dp
			on dp.datos_personales = u.datos_personales
		inner join Activos a
			on a.Aid = t.Aid
		inner join AClasificacion cla
			on  cla.Ecodigo = a.Ecodigo
			and cla.ACcodigo = a.ACcodigo
			and cla.ACid = a.ACid
		/*
		left outer join ADC.ADC.adcCuentaCobisRisk adc
			on replace(cf.CFcuentac,'-', null) = adc.cocCuentaCobis
		*/

		left outer join ADC.ADC.adcCuentaCobisRisk adc
			on '44' + cla.ACgastodep = adc.cocCuentaCobis

		where t.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and t.TAperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EPERIODO#">
		and t.TAmes     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EMES#">
		and t.IDtrans   = 4

	</cfquery>
	
	<cfquery name="SELINT" datasource="#session.DSN#">
	Select CONSECUTIV, ACgastodep, FormatoCta
	from #INT_RISK_BANEX#
	</cfquery>
	
	<cfloop query="SELINT">
		
		<cfset Lvarcsc = SELINT.CONSECUTIV>
		
		<cfinvoke component="sif.Componentes.AF_ContabilizarDepreciacion" 
				  method="AplicarMascara" 
				  returnvariable="lVarCuentaDep">
			<cfinvokeargument name="cuenta" value="#SELINT.FormatoCta#"/>							
			<cfinvokeargument name="objgasto" value="#SELINT.ACgastodep#"/>
		</cfinvoke>	
		
		<cfif lVarCuentaDep eq ""><cfset lVarCuentaDep = ""></cfif>
		
		<cfquery name="Upd_CtaGasto" datasource="#session.DSN#">
			UPDATE #INT_RISK_BANEX#
			set CUENTAGASTO = <cfqueryparam value="#lVarCuentaDep#" cfsqltype="cf_sql_varchar">
			where CONSECUTIV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarcsc#">
		</cfquery>
	
	</cfloop>
	
	<cfquery name="ERR" datasource="#session.DSN#">
		SELECT 	COD_COMPAN, 
				FEC_ASIENT, 
				CONSECUTIV, 
				CFUNCIONAL, 
				USUARIOCIF, 
				USUARIONOM, 
				CTAMAYOR,				
				CUENTA,
				SUBCUENTA,  
				DESCRIPCI,  
				DETALLE,    
				DEBITOS, 	
				CREDITOS,
				NETO,
				CUENTAGASTO
		FROM #INT_RISK_BANEX# 
	</cfquery>

</cftransaction>