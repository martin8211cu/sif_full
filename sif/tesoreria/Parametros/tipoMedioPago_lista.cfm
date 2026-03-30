<cf_navegacion name="CBid">
<cf_navegacion name="TESMPcodigo">

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery datasource="#session.dsn#" name="lista">
	select 	cb.Ecodigo, tcb.CBid, 
			'EMPRESA DE PAGO: ' #_Cat# ep.Edescripcion as Edescripcion, 
			mp.Miso4217, 
			'<nobr>&nbsp;&nbsp;CUENTA: ' #_Cat# mp.Miso4217 #_Cat# ' - ' #_Cat# bp.Bdescripcion  #_Cat# ' - ' #_Cat# cb.CBcodigo #_Cat# '</nobr>' as CBdescripcion,
			TESTMPdescripcion, 
			case m.TESTMPtipo
				when 1 then 'CHK'
				when 2 then 'TRI'
				when 3 then 'TRE'
				when 4 then 'TRM'
				when 5 then 'TCE'
				else '???'
			end as TIPO,
			TESMPcodigo, 
			TESMPdescripcion
	from TEScuentasBancos tcb
		inner join TESmedioPago m
			inner join TEStipoMedioPago t
				on t.TESTMPtipo = m.TESTMPtipo
			 on m.TESid = tcb.TESid
			and m.CBid  = tcb.CBid
		inner join CuentasBancos cb
			inner join TESempresas te
				on te.Ecodigo = cb.Ecodigo
			inner join Empresas ep
				on ep.Ecodigo = cb.Ecodigo
			inner join Bancos bp
				 on bp.Bid = cb.Bid
			inner join Monedas mp
				 on mp.Ecodigo = cb.Ecodigo
				and mp.Mcodigo = cb.Mcodigo
			on cb.CBid = tcb.CBid
	where tcb.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
    	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	
		and tcb.TESCBactiva = 1
	order by cb.Ecodigo, tcb.CBid
</cfquery>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#lista#"
		cortes="Edescripcion, CBdescripcion"
		desplegar="TESMPcodigo,TIPO,TESMPdescripcion"
		etiquetas="Codigo Medio, Tipo, Medio de Pago"
		formatos="S,S,S"
		align="left,cneter,left"
		ajustar="N"
		ira="tipoMedioPago.cfm"
		keys="CBid,TESMPcodigo"
		showEmptyListMsg="yes"
		EmptyListMsg="--- No se existen Medios de Pago definidos ---"
		botones="Nuevo"
	/>		
