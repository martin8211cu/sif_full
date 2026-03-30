<cfquery name="rsFuturos" datasource="sifinterfaces">
	select distinct
		a.broker_name, a.port_num, a.cobertura_VR_FE + 
					case when venta_realizada = 1 then '-VR' else '-VNR' end as cobertura_VR_FE
		,a.port_short_name, a.mtm_pl, a.currency_code,
		case when exists (select 1 from futurosabiertosPMI b 
							where a.Documento = b.Documento and a.sessionid = b.sessionid and b.mensajeerror is not null)
			then 'No genera, hay l&iacute;neas con error' else 'S&iacute;' end
			 as pasa_o_no_pasa
	from futurosabiertosPMI a
		where a.sessionid = #session.monitoreo.sessionid#
<!---		  and a.mensajeerror is null  ::: omito esta condicion ya que tiene una columna que indica si pasa o no pasa --->
	order by broker_name, port_num
</cfquery>
