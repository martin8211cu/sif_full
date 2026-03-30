<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />
<cfset LvarEcodigo = #datosXML.row.Ecodigo.xmltext#>

<cfif  len(trim(#LvarEcodigo#)) eq 0 >
	<cfthrow message="El Código de la empresa es requerido ">
</cfif>

 <cfquery name="consulta" datasource="#session.DSN#">
	 select e.RHPcodigo, e.RHPdescripcion, e.Ecodigo,
	 		d.RHCcodigo,d.RHCdescripcion
    from RHPlazas e
        inner join RHPuestos a
            on e.RHPpuesto = a.RHPcodigo
            and e.Ecodigo = a.Ecodigo
        inner join RHMaestroPuestoP b
            on b.RHMPPid = a.RHMPPid
            and b.Ecodigo = a.Ecodigo
        inner join RHCategoriasPuesto c
            on c.RHMPPid = b.RHMPPid
            and c.Ecodigo = b.Ecodigo
        inner join RHCategoria d
            on d.RHCid = c.RHCid
            and d.Ecodigo = c.Ecodigo  
                  
	where e.Ecodigo = #LvarEcodigo#
</cfquery> 
<cfset LvarSalida = "<resulset>">
<cfset count= 0>
<cfif consulta.recordCount gt 0 >
	<cfloop query="consulta">
	
		<cfset count= count + 1>
		<cfset LvarSalida &= "
				<row>
					<Ecodigo>#Ecodigo#</Ecodigo>
					<RHPcodigo>#RHPcodigo#</RHPcodigo>
					<RHPdescripcion>#RHPdescripcion#</RHPdescripcion>		
					<RHCcodigo>#RHCcodigo#</RHCcodigo>       
					<RHCdescripcion>#RHCdescripcion#</RHCdescripcion>
				</row>  ">	
				
	</cfloop>
<cfset LvarSalida &= 
"</resulset>" >
<cfset GvarXML_OE = LvarSalida>
</cfif>


