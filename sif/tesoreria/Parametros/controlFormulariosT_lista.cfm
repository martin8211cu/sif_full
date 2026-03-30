<cfquery datasource="#session.dsn#" name="lista">
	select 	
		tcb.CBid, 
		<cf_dbfunction name="concat" args="'EMPRESA: ' + ep.Edescripcion" delimiters="+"> as Edescripcion,
		<cf_dbfunction name="concat" args="'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;CUENTA PAGO: ' + mp.Miso4217 + ' - ' + bp.Bdescripcion  + ' - ' + cb.CBcodigo" delimiters="+"> as CBdescripcion,
		mp.Miso4217, 
		TESTMPdescripcion, 
		TESMPcodigo, 
		TESMPdescripcion
	from TEScuentasBancos tcb
		inner join TESmedioPago m
			inner join TEStipoMedioPago t
				 on t.TESTMPtipo = m.TESTMPtipo
				and t.TESTMPcontrolFormulario = 1
			 on m.TESid = tcb.TESid
			and m.CBid  = tcb.CBid
		inner join CuentasBancos cb
			inner join Empresas ep
				on ep.Ecodigo = cb.Ecodigo
			inner join Bancos bp
				 on bp.Bid = cb.Bid
			inner join Monedas mp
				 on mp.Ecodigo = cb.Ecodigo
				and mp.Mcodigo = cb.Mcodigo
			on cb.CBid = tcb.CBid
	where tcb.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
	  and tcb.TESCBactiva = 1
      and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	order by cb.Ecodigo, tcb.CBid
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	query="#lista#"
	cortes="Edescripcion, CBdescripcion"
	desplegar="TESMPcodigo,TESMPdescripcion"
	etiquetas="Codigo Medio, Medio de Pago"
	formatos="S,S"
	align="left,left"
	ajustar="S"
	ira="controlFormulariosT.cfm"
	keys="CBid,TESMPcodigo"
	showEmptyListMsg="yes"
	EmptyListMsg="--- No se existen Medios de Pago con Control de Formularios definidos ---"
	botones=""
/>		
