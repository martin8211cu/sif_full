
<!--- leer configuracion --->
<cfset objParam = CreateObject("component", "commons.Widgets.Componentes.Parametros")>

<cfset lvarValor=objParam.ObtenerValor("#request.WidCodigo#","002")>
<cfset lvarMcodigo=objParam.ObtenerValor("#request.WidCodigo#","001")>
<cfset lvarColor=objParam.ObtenerValor("#request.WidCodigo#","003")>
<cfset lvarIcono=objParam.ObtenerValor("#request.WidCodigo#","004")>

<cfset lvarAccion = "Compra">
<cfif lvarValor eq "TCventa"><cfset lvarAccion = "Venta"></cfif>

<cfquery name="rsTC" datasource="#Session.DSN#">
	select	a.#lvarValor# Valor,
		ml.Mcodigo McodigoO, ml.Mnombre MnombreO, ml.Miso4217 Miso4217O,
		mc.Mcodigo, mc.Mnombre, mc.Miso4217,
		case
			when a.#lvarValor# > b.#lvarValor# then '+'
			else ''
		end + cast(a.#lvarValor# - b.#lvarValor# as varchar) as dif,
		case
			when a.#lvarValor# > b.#lvarValor# then 'success'
			when a.#lvarValor# < b.#lvarValor# then 'important'
			else 'equal'
		end as stat
	from(
		SELECT top 1 *
		FROM Htipocambio
			Where Ecodigo = #Session.Ecodigo#
				and Mcodigo = (select Mcodigo from Monedas Where Ecodigo = #Session.Ecodigo# and Miso4217 = '#lvarMcodigo#')
		order by Hfecha DESC
	) a
	inner join (
		SELECT top 1 *
		FROM (	select top 2 *
				from Htipocambio
				Where Ecodigo = #Session.Ecodigo#
					and Mcodigo = (select Mcodigo from Monedas Where Ecodigo = #Session.Ecodigo# and Miso4217 = '#lvarMcodigo#')
				order by Hfecha DESC
		) tmp
		order by Hfecha asc
	)b
		on a.Ecodigo = b.Ecodigo
		and a.Mcodigo = b.Mcodigo
	inner join(
		SELECT  e.Ecodigo, m.Mcodigo, m.Mnombre, m.Miso4217
		FROM Empresas e, Monedas m
		where e.Ecodigo = #Session.Ecodigo#
			and m.Mcodigo = e.Mcodigo
			and m.Ecodigo = e.Ecodigo
	) ml
		on a.Ecodigo = ml.Ecodigo
	inner join(
		SELECT  m.Mcodigo, m.Mnombre, m.Miso4217
		FROM Monedas m
		where m.Ecodigo = #Session.Ecodigo#
			and m.Miso4217 = '#lvarMcodigo#'
	) mc
		on a.Mcodigo = mc.Mcodigo
</cfquery>

<!--- <cfinvoke
	webservice="http://www.webservicex.net/CurrencyConvertor.asmx?wsdl"
	method="ConversionRate"
	returnvariable="aresult">
	<cfinvokeargument name="FromCurrency" value="YER"/>
	<cfinvokeargument name="ToCurrency" value="MXN"/>
</cfinvoke>  --->

<cf_infobox color="#lvarColor#" icon="#lvarIcono#" value="#rsTC.Valor#" content="#rsTC.Miso4217# - #rsTC.Miso4217O# (#lvarAccion#)" stat="#rsTC.dif#" stat_style="#rsTC.stat#"/>
