<!---                                                              
Interfaz que crea un xml con los datos del registro de evaluaciones
Creada para el ITCR                                                
                                                                --->

<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- <cfif listLen(GvarXML_IE) GT 5 and listLen(GvarXML_IE) LT 1>
	<cfthrow message="Los Datos de entrada son Ecodigo,Cédula,Nombre,Puesto,Centro Funcional">
</cfif>

<cfset Ecodigo          = listGetAt(GvarXML_IE,1) >
<cfset LvarCedula		= listGetAt(GvarXML_IE,2)>
<cfset LvarNombre		= listGetAt(GvarXML_IE,3)>
<cfset LvarCFuncional	= listGetAt(GvarXML_IE,4)> 
<cfset LvarPuesto		= listGetAt(GvarXML_IE,5)>
 --->
 
<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />
<cfset Ecodigo = #datosXML.row.Ecodigo.xmltext#>
<cfset Ano = #datosXML.row.Ano.xmltext#>
<cfset Fechaini = #datosXML.row.Fechaini.xmltext#>
<cfset Fechahasta = #datosXML.row.Fechahasta.xmltext#>

<!---<cfthrow message="1:#listGetAt(GvarXML_IE,1)#, 2:#listGetAt(GvarXML_IE,2)#, 3:#listGetAt(GvarXML_IE,3)#, 4:#listGetAt(GvarXML_IE,4)#, 5: #listGetAt(GvarXML_IE,5)#, largo : #listLen(listGetAt(GvarXML_IE,5))#, puesto: #(trim(LvarPuesto))#, largo del puesto : #len(trim(LvarPuesto))#">--->

 <cfquery name="consulta" datasource="#session.DSN#">
	select e.RHEEid,e.RHEEdescripcion as RHEEdescripcion,d.DEidentificacion,
	d.DEnombre+' '+	d.DEapellido1+' ' +d.DEapellido2 as nombre,
	case e.CFid 
	when coalesce(e.CFid,0) then cf.CFid
	else null
	end as CFid,
	case e.CFid 
	when coalesce(e.CFid,0) then cf.CFdescripcion
	else null
	end as CFdescripcion,RHEEfdesde,RHEEfhasta
	<cfif  LEN(TRIM(Fechaini)) and Fechaini NEQ -1>
		,<cfqueryparam cfsqltype="cf_sql_date" value="#Fechaini#"> as fechaIni
	</cfif>	
	<cfif  LEN(TRIM(Fechahasta)) and Fechahasta NEQ -1>
		,<cfqueryparam cfsqltype="cf_sql_date" value="#Fechahasta#">    as Fechahasta  
	</cfif>
	from RHListaEvalDes l
		inner join RHEEvaluacionDes e
			on l.RHEEid=e.RHEEid
	   left outer join CFuncional cf
		on cf.CFid=e.CFid
		inner join DatosEmpleado d
		on d.DEid=l.DEid
	where 1=1
	<cfif  LEN(TRIM(Ecodigo)) and Ecodigo NEQ 0>                       
    	and l.Ecodigo=#Ecodigo#
	</cfif>	
	<cfif  LEN(TRIM(Ano)) and Ano NEQ 0>                       
    	and <cf_dbfunction name="date_part"	args="YYYY,RHEEfdesde">= #Ano#
	</cfif>	
	<cfif  LEN(TRIM(Fechaini)) and Fechaini NEQ 0>
		and RHEEfdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fechaini#">
	</cfif>	
	<cfif  LEN(TRIM(Fechahasta)) and Fechahasta NEQ 0>
		and RHEEfhasta <=  <cfqueryparam cfsqltype="cf_sql_date" value="#Fechahasta#">            
	</cfif>
</cfquery> 


<cfif consulta.recordCount gt 0 >
	<cfset LvarSalida = "<resultset>">
		<cfloop query="consulta">
			<cfset LvarSalida &= "<row>	
									<IdRelacion>#RHEEid#</IdRelacion>
									<Descripcion>#RHEEdescripcion#</Descripcion>
									<CodigoCF>#CFid#</CodigoCF>
									<DescripcionCF>#CFdescripcion#</DescripcionCF>
									<Cedula>#DEidentificacion#</Cedula>
									<Nombre>#nombre#</Nombre>
									<FechaVigencia>#LSDateFormat(RHEEfdesde,'DD/MM/YYYY')#</FechaVigencia>
									<FechaEvaluar>#LSDateFormat(RHEEfhasta,'DD/MM/YYYY')#</FechaEvaluar>
									<fechaIni>#LSDateFormat(fechaIni,'DD/MM/YYYY')#</fechaIni>
									<Fechahasta>#LSDateFormat(Fechahasta,'DD/MM/YYYY')#</Fechahasta>					
								</row> ">
		</cfloop>
	<cfset LvarSalida &= 
	"</resultset>" >
	<cfset GvarXML_OE = LvarSalida>
</cfif>



