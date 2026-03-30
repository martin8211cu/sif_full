<cfset minisifdb = Application.dsinfo[session.dsn].schema>


<cfsetting requesttimeout="3600"> 
<cfparam name="url.formato" default="HTML">


<cfif not IsDefined("url.Regresa")>
	<cfset url.Regresa="Reversion.cfm">
</cfif>


<cfquery name="rsEmpresa" datasource="#Session.DSN#">
	select Edescripcion
	from Empresas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

	  <cfquery name="rsLista" datasource="sifinterfaces">
                    select distinct e.NRC_Id, NRC_NumNomina, convert(date,NRC_FechaNomina,103) as NRC_FechaNomina, NRC_Grupo, round(MontoComprometido,2) as 	Comprometido, round(MontoEjecutar,2) as Ejecutar
					from NRCE_Nomina e 
					inner join NRCD_Nomina d on e.NRC_Id = d.NRC_Id
					where d.NRCD_Periodo =#url.Periodo#
					and d.NRCD_Mes  =#url.Mes#
                    <cfif len(trim("#url.NumNomina#")) GT 0 >
					and upper(NRC_NumNomina)  like '%#Ucase(listgetat(url.NumNomina,1))#%'
                    </cfif>
				<!---	group by e.NRC_Id, NRC_NumNomina, NRC_FechaNomina, NRC_Grupo--->
				</cfquery>
                

                
<cfif isdefined("rsLista") and rsLista.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif rsLista.recordcount EQ 0>
	<cfthrow message="No existen registros que mostrar">
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Errores de Compromiso" 
			filename="ErroresDeCompromiso.xls" 
            param = "&Periodo=#url.Periodo#&Mes=#url.Mes#&NumNomina=#url.NumNomina#"
			ira="interfaz925PMI-ConsultaNRCs.cfm?Periodo=#url.Periodo#&Mes=#url.Mes#&NumNomina=#url.NumNomina#">

		<cf_templatecss>
		<cfflush interval="512">
		<cfoutput>

				<table width="100%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
					<tr>
						<td colspan="12">&nbsp;</td>
						<td align="right"><strong>#DateFormat(now(),"DD/MM/YYYY")#</strong></td>
					</tr>					
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>"#rsEmpresa.Edescripcion#"</strong>	
						</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>Errores de Compromiso.</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="100%">
					<tr>
						<td nowrap align="rigth"><strong>Número Nómina</strong></td>
						<td nowrap align="rigth"><strong>Fecha Nómina</strong></td>
						<td nowrap align="rigth"><strong>Grupo Presupuesto</strong></td>
						<td nowrap align="rigth"><strong>Monto Comprometido</strong></td>
						<td nowrap align="rigth"><strong>Monto Ejecutar</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsLista">
						<tr>
							<td nowrap>#rsLista.NRC_NumNomina#</td>
							<td nowrap>#rsLista.NRC_FechaNomina#</td>
							<td nowrap>#rsLista.NRC_Grupo#</td>
							<td nowrap>#rsLista.Comprometido#</td>
							<td nowrap>#rsLista.Ejecutar#</td>
						</tr>
					</cfloop>
					</table>
		</cfoutput>
</cfif>


