<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
	
<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />
<cfset IDfuncionario = #datosXML.row.IDfuncionario.xmltext#>

<cfif  len(trim(#IDfuncionario#)) eq 0 or trim(#IDfuncionario#) EQ -1 >
	<cfthrow message="El ID del funcionario que corresponde a la cédula es requerido">
</cfif>	
	
	
<cfquery name="consulta" datasource="#session.DSN#">			
 select DEidentificacion,
 		a.Tcodigo,
		RVcodigo,
		Deptocodigo,
		Oficodigo, 		
		a.RHPcodigo,
		RHJcodigo
		
	from LineaTiempo a
	inner join DatosEmpleado b
		on b.DEid = a.DEid
		and b.Ecodigo = a.Ecodigo
		
	inner join RegimenVacaciones c
		on c.Ecodigo = a.Ecodigo
		and c.RVid = a.RVid
		
	inner join RHPlazas d
		on d.Ecodigo = a.Ecodigo
		and d.RHPid = a.RHPid
		
	inner join Oficinas e
		on e.Ecodigo = d.Ecodigo
		and e.Ocodigo = d.Ocodigo
		
	inner join Departamentos f
		on f.Ecodigo = a.Ecodigo
		and f.Dcodigo = d.Dcodigo
		
	inner join RHJornadas jor
		on jor.Ecodigo = a.Ecodigo
		and jor.RHJid = a.RHJid 	
		
	where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
	  and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#IDfuncionario#">
	  and getdate() between LTdesde and LThasta
</cfquery>	
		
<cfset GvarXML_OE = 
"<resultset>
    <row>
      	<DEidentificacion>#consulta.DEidentificacion#</DEidentificacion>	
		<Tcodigo>#consulta.Tcodigo#</Tcodigo>
		<RVcodigo>#consulta.RVcodigo#</RVcodigo>
		<Deptocodigo>#consulta.Deptocodigo#</Deptocodigo>
		<Oficodigo>#consulta.Oficodigo#</Oficodigo>
		<RHPcodigo>#consulta.RHPcodigo#</RHPcodigo>
		<RHJcodigo>#consulta.RHJcodigo#</RHJcodigo>
    </row>
</resultset>
">
<!---<cfset GvarXML_OE = "#consulta.DEnombre#,#consulta.DEapellido1#">--->


