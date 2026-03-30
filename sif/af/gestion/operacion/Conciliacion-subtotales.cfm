<!---*******************************************
*******Sistema Financiero Integral**************
*******GestiÃ³n de Activos Fijos*****************
*******Conciliacion de Activos Fijos************
*******Fecha de CreaciÃ³n: Ene/2006**************
*******Desarrollado por: Dorian Abarca GÃ³mez****
********************************************--->
<cf_dbtemp name="CONCILIAR_V2" returnvariable="CONCILIAR" datasource="#session.dsn#">
	<cf_dbtempcol name="IDcontable" 	type="numeric"	mandatory="yes">
	<cf_dbtempcol name="Ecodigo"  		type="numeric"  mandatory="yes">
	<cf_dbtempcol name="GATperiodo"  	type="numeric"  mandatory="yes">
	<cf_dbtempcol name="GATmes"  		type="numeric"  mandatory="yes">
	<cf_dbtempcol name="Cconcepto"  	type="numeric"  mandatory="yes">
	<cf_dbtempcol name="Ocodigo"  		type="numeric"  mandatory="yes">
	<cf_dbtempcol name="Odescripcion"  	type="varchar(100)"  mandatory="yes">
	<cf_dbtempcol name="Edocumento"  	type="numeric"  mandatory="yes">
	<cf_dbtempcol name="CFcuenta"  		type="numeric"  mandatory="yes">
	<cf_dbtempcol name="CFformato"  	type="varchar(100)"  mandatory="yes">
	<cf_dbtempcol name="MontoGestion"  	type="money"  	mandatory="yes">
	<cf_dbtempcol name="MontoAsiento"  	type="money"  	mandatory="yes">
	<cf_dbtempcol name="Conciliado"  	type="numeric"  mandatory="yes">
	<cf_dbtempcol name="Diferencias"  	type="numeric"  mandatory="yes">
	<cf_dbtempcol name="TotalItemsConciliados" 	type="numeric"  mandatory="yes">
	<cf_dbtempcol name="TotalItems"  	type="numeric"  mandatory="yes">
	<cf_dbtempcol name="TotalItemsDif" 	type="numeric"  mandatory="yes">
	<cf_dbtempkey cols="IDcontable,Ocodigo,CFcuenta">
</cf_dbtemp>
<cfquery datasource="#Session.Dsn#">
	insert into #CONCILIAR#(IDcontable,
			Ecodigo,
			GATperiodo,
			GATmes,
			Cconcepto,
			Ocodigo,
			Odescripcion,
			Edocumento,
			CFcuenta,
			CFformato,
			MontoGestion,
			MontoAsiento,
			Conciliado,
			Diferencias,
			TotalItems,
			TotalItemsConciliados,
			TotalItemsDif)
	select 	a.IDcontable,
			a.Ecodigo,
			a.GATperiodo,
			a.GATmes,
			a.Cconcepto,
			a.Ocodigo,
			d.Odescripcion,
			a.Edocumento,
			a.CFcuenta,
			c.CFformato,
			coalesce(sum(a.GATmonto),0.00) as MontoGestion , 
			000000000.0000 as MontoAsiento,
			0 as Conciliado,
			0 as Diferencias,
			coalesce(count( 1 ),0) as TotalItems,
			coalesce( sum( case GATestado when 2 then 1 else 0 end ),0) as TotalItemsConciliados,
			coalesce( sum( case GATdiferencias when 1 then 1 else 0 end ),0) as TotalItemsDif
	from GATransacciones a
	inner join CFinanciera c
		on c.CFcuenta = a.CFcuenta
		and	c.Ecodigo = a.Ecodigo
	inner join Oficinas d
		on d.Ecodigo = a.Ecodigo
		and d.Ocodigo = a.Ocodigo
	where a.Ecodigo = #Session.Ecodigo#
	and a.GATperiodo = #Form.GATperiodo#
	and a.GATmes = #Form.GATmes#
	and a.Cconcepto = #Form.Cconcepto#
	and a.Edocumento = #Form.Edocumento#
	group by a.IDcontable,
			a.Ecodigo,
			a.GATperiodo,
			a.GATmes,
			a.Cconcepto,
			a.Ocodigo,
			d.Odescripcion,
			a.Edocumento,
			a.CFcuenta,
			c.CFformato
</cfquery>
<cfquery datasource="#Session.Dsn#">	
	update #CONCILIAR#
		set MontoAsiento = 
		(select coalesce(sum(b.Dlocal*(case b.Dmovimiento when 'D' then 1 else -1 end)),0.00)
		from HDContables b
		where  b.IDcontable = #CONCILIAR#.IDcontable
		and b.Ocodigo = #CONCILIAR#.Ocodigo
		and b.CFcuenta = #CONCILIAR#.CFcuenta
		)
</cfquery>
<cfquery datasource="#Session.Dsn#">
	update #CONCILIAR#
	set Conciliado = 
	case when TotalItems = TotalItemsConciliados then 1 else 0 end
</cfquery>
<cfquery datasource="#Session.Dsn#">	
	update #CONCILIAR#
	set Diferencias = 
	case when TotalItemsDif > 0 then 1 else 0 end	
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="lista_recordcount"
	columnas="GATperiodo, GATmes, Cconcepto, Edocumento, CFcuenta, CFformato, IDcontable, Ocodigo, Odescripcion, TotalItems, MontoGestion, MontoAsiento, case Conciliado when 1 then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''/>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''/>' end as Conciliado, case Diferencias when 1 then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''/>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''/>' end as Diferencias"
	tabla="#CONCILIAR# a"
	
	filtro=""
	
	cortes="Odescripcion"
	desplegar="CFformato, TotalItems, MontoAsiento, MontoGestion, Conciliado, Diferencias"
	etiquetas="Formato, Cantidad Items, Monto Asiento Contable, Monto Gestion, Conciliado, Inconsistente"
	formatos="S,I,M,M,S,S"
	align="left, right, right, right, center, center"
	
	irA="Conciliacion.cfm"
	showlink="true"
	showemptylistmsg="true"	
	
	keys="GATperiodo,GATmes,Cconcepto,Edocumento,Ocodigo,CFcuenta"
	
	pageIndex="2"
/>
