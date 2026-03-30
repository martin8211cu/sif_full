<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cfif listLen(GvarXML_IE) NEQ 2>
	<cfthrow message="Los Datos de entrada son SNcodigoExt,Miso4217">
</cfif>
<cfset LvarSNnumero	= listGetAt(GvarXML_IE,1)>
<cfset LvarMiso4217		= listGetAt(GvarXML_IE,2)>

<cfquery name="rsSQL" datasource="#session.dsn#">
	Select Mcodigo 
	  from Empresas
	 where Ecodigo	= #session.Ecodigo#
</cfquery>
<cfset LvarMcodigoLocal = rsSQL.Mcodigo>

<cfquery name="rsSQL" datasource="#session.dsn#">
	Select Mcodigo 
	  from Monedas 
	 where Ecodigo	= #session.Ecodigo#
	   and Miso4217	= '#LvarMiso4217#'
</cfquery>
<cfif rsSQL.recordcount EQ 0>
	<cfthrow message="Moneda '#LvarMiso4217#' no está definido en la Empresa">
</cfif>
<cfset LvarMcodigoConsulta = rsSQL.Mcodigo>

<cfif LvarMcodigoConsulta EQ LvarMcodigoLocal>
	<cfset LvarTC_MConsulta = 1>
<cfelse>
	<cfquery name="rsTC" datasource="#Session.DSN#">
		select tc.TCcompra
		  from Htipocambio tc
		 where tc.Mcodigo = #LvarMcodigoConsulta#
		   and tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		   and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
		   and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
	</cfquery>
	<cfif rsTC.recordcount EQ 0>
		<cfthrow message="Moneda '#LvarMiso4217#' no tiene definido su tipo de Cambio histórico en la Empresa">
	</cfif>
	<cfset LvarTC_MConsulta = rsTC.TCcompra>
</cfif>

<cfquery name="rsSQL" datasource="#session.dsn#">
	Select SNcodigo
	  from SNegocios
	 where Ecodigo		= #session.Ecodigo#
	   and SNnumero	= '#LvarSNnumero#'
</cfquery>
<cfif rsSQL.recordcount EQ 0>
	<cfthrow message="Socio de Negocios '#LvarSNnumero#' no está definido en la Empresa">
</cfif>
<cfset LvarSNcodigo=rsSQL.SNcodigo>

<!---Extraigo el saldo de  CXC del socio negocios --->					  
<cfquery name="rsSaldosSociosCxC" datasource="#session.dsn#">
	select 	coalesce(sum(round(
				case 
					when d.Mcodigo = #LvarMcodigoConsulta# 	then d.Dsaldo
					when d.Mcodigo = #LvarMcodigoLocal# 	then d.Dsaldo / #LvarTC_MConsulta#
					else d.Dsaldo * coalesce(d.Dtcultrev,d.Dtipocambio) / #LvarTC_MConsulta#
				end
			,2)), 0 ) as Saldo,
			coalesce(sum(round(
				case
					when d.Dvencimiento > <cf_dbfunction name="today" datasource="#session.dsn#"> then 0
					when d.Mcodigo = #LvarMcodigoConsulta# 	then d.Dsaldo
					when d.Mcodigo = #LvarMcodigoLocal# 	then d.Dsaldo / #LvarTC_MConsulta#
					else d.Dsaldo * coalesce(d.Dtcultrev,d.Dtipocambio) / #LvarTC_MConsulta#
				end
			,2)),0) as SaldoVencido,
                min(case when d.Dvencimiento <= <cf_dbfunction name="today" datasource="#session.dsn#"> then d.Dvencimiento end)  as FechaVencimiento
	  from Documentos d
	 inner join CCTransacciones t
		   on t.CCTcodigo	= d.CCTcodigo
		  and t.Ecodigo		= d.Ecodigo
	 where d.Ecodigo	= #session.Ecodigo#
	   and d.SNcodigo	= #LvarSNcodigo#
	   and t.CCTtipo= 'D'
	   and d.Dsaldo > 0
</cfquery>					  
<cfif rsSaldosSociosCxC.FechaVencimiento EQ "">
	<cfset LvarFechaVencimiento = " ">
<cfelse>
	<cfset LvarFechaVencimiento = DateFormat(rsSaldosSociosCxC.FechaVencimiento,"yyyy-mm-dd")>
</cfif>

<cfset GvarXML_OE = "<recordset>
    <row>
        <Moneda>#LvarMiso4217#</Moneda>
        <Saldo>#rsSaldosSociosCxC.Saldo#</Saldo>
        <SaldoVencido>#rsSaldosSociosCxC.SaldoVencido#</SaldoVencido>
        <VencimientoMasAntiguo>#LvarFechaVencimiento#</VencimientoMasAntiguo>
    </row>
<recordset>
">
<cfset GvarXML_OE = "#LvarMiso4217#,#rsSaldosSociosCxC.Saldo#,#rsSaldosSociosCxC.SaldoVencido#,#LvarFechaVencimiento#">
"MONEDA,Saldo,SaldoVencido,{FechaVencimientoMasVieja | NULL}"
