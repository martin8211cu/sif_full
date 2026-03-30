<title>Detalle de saldos de cuentas por pagar</title>	
<!---Empresa--->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion 
	 from Empresas
 	where Ecodigo = #Session.Ecodigo#
</cfquery>
<!---Reporte de Documentos Pendiente CxP--->
<cf_dbfunction name="now" returnvariable="now">
<cf_dbfunction name="datediff" args="a.Dfechavenc, #now#" returnvariable="DiasVencimiento">
<cfquery name="rsReporte" datasource="#session.dsn#">
	select 
	'#rsEmpresa.Edescripcion#' as empresa,
		b.SNidentificacion, 
		b.SNnombre, 
		a.SNcodigo,
		m.Mnombre,
		a.Mcodigo,
		 IDdocumento, 
		c.CPTdescripcion, 
		a.Ddocumento , 
		a.Dfecha ,
		a.Dfechavenc,
		coalesce(EDsaldo,0) * case when c.CPTtipo = 'C' then 1 else -1 end  as EDsaldo, 
		coalesce(EDsaldo,0) * case when c.CPTtipo = 'C' then 1 else -1 end   * coalesce(Dtipocambio,1) as montolocal,
		Dtotal,
		case when #PreserveSingleQuotes(DiasVencimiento)# > 0
		then <cf_dbfunction name="to_char"	args="#PreserveSingleQuotes(DiasVencimiento)#" delimiters="|">
		else 'Sin vencer '  end  as diferencia
	from  EDocumentosCP a
		inner join SNegocios b
			on a.SNcodigo = b.SNcodigo 
	       and a.Ecodigo  = b.Ecodigo 
		inner join CPTransacciones c
		   on a.CPTcodigo = c.CPTcodigo 
	      and a.Ecodigo = c.Ecodigo 
		inner join Monedas m
		  on a.Mcodigo = m.Mcodigo 
	     and a.Ecodigo = m.Ecodigo
	where a.Ecodigo = #session.Ecodigo#
	  and a.EDsaldo > 0
	<cfif isdefined("url.SNcodigo")  and len(trim(url.SNcodigo)) and url.SNcodigo neq '-1'>
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#">
	</cfif>	
	<cfif isdefined("url.Ocodigo")  and len(trim(url.Ocodigo)) and url.Ocodigo neq '-1'>
		and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ocodigo#">
	</cfif>	

	<cfif url.inicio eq '-1'> <!--- sin  vencer --->
		and  #PreserveSingleQuotes(DiasVencimiento)# < 0
	<cfelseif url.inicio eq '0'> <!--- hoy --->
		and  #PreserveSingleQuotes(DiasVencimiento)# = 0
	<cfelseif url.inicio eq '-2'> <!--- mayores a 120 --->
		and  #PreserveSingleQuotes(DiasVencimiento)# > <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Fin#">
	<cfelseif url.inicio gte '1'>  <!--- mayores al ultimo vencimiento ---> 
		and #PreserveSingleQuotes(DiasVencimiento)# 
			between <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Inicio#">  and <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Fin#">
	</cfif>			
	Order by SNnombre,m.Mnombre
</cfquery>
<!---Impresion del reporte--->
<cfif isdefined("url.FORMATO") and url.FORMATO eq 1>
  <cfset TipoRep = 'flashpaper'>
</cfif>
<cfif isdefined("url.FORMATO") and url.FORMATO eq 2>
  <cfset TipoRep = 'PDF'>
</cfif>
<cfif isdefined("url.FORMATO") and url.FORMATO eq 3>
  <cfset TipoRep = 'Excel'>
</cfif>
<cfif rsReporte.recordcount>
	<cfreport format="#TipoRep#" template="AntigSaldosDetCxP-rep.cfr" query="rsReporte">
	</cfreport>
<cfelse>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<th scope="col"> *** No se encontraron datos para realizar el Gr&aacute;fico *** </th>
	  </tr>
	</table>
</cfif>