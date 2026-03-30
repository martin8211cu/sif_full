<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- <cfif listLen(GvarXML_IE) neq 3>
	<cfthrow message="Los Datos de entrada son periodo">
</cfif>
<cfset LvarEperiodo   		= listGetAt(GvarXML_IE,1)>
<cfset LvarEmes				= listGetAt(GvarXML_IE,2)>
<cfset LvarCconcepto		= listGetAt(GvarXML_IE,3)> --->

<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />

<cfset LvarEperiodo	 = #datosXML.row.LvarEperiodo.xmltext#>
<cfset LvarEmes		 = #datosXML.row.LvarEmes.xmltext#>
<cfset LvarCconcepto = #datosXML.row.LvarCconcepto.xmltext#> 


<cfquery name="rsSQL" datasource="#session.dsn#">
	Select e.Cconcepto 
	  from ConceptoContableE  e
	  inner join  ConceptoContableN n
	  on e.Cconcepto=n.Cconcepto      
	 where e.Ecodigo	= #session.Ecodigo#
	 	and Eperiodo=#LvarEperiodo#
	 <cfif #LvarCconcepto# neq -1>
	  	and e.Cconcepto   = #LvarCconcepto#
	  </cfif>
	   <cfif #LvarEmes# neq -1>
	  	and Emes   = #LvarEmes#
	  </cfif>
</cfquery>

<cfif rsSQL.recordcount EQ 0>
	<cfthrow message="No existen conceptos contables de la Empresa para el periodo: #LvarEperiodo#, mes: #LvarEmes# y concepto: #LvarCconcepto#">
</cfif>

<cfquery name="rsSQL" datasource="#session.dsn#">
	Select 
	  	Eperiodo,    
		Emes, 
		e.Cconcepto,       		
		Cdescripcion, 
		Edocumento  
	from ConceptoContableE  e
	  inner join  ConceptoContableN n
	  on e.Cconcepto=n.Cconcepto      
	 where e.Ecodigo	= #session.Ecodigo#
	  and Eperiodo=#LvarEperiodo#
	 <cfif #LvarCconcepto# neq -1>
	  	and e.Cconcepto   = #LvarCconcepto#
	  </cfif>
	  <cfif #LvarEmes# neq -1>
	  	and Emes   = #LvarEmes#
	  </cfif>
</cfquery>

<cfset LvarTabla = "<recordset>">

	<cfloop query="rsSQL">
		<cfset LvarTabla &= " 
		<row>
			<Empresa>#session.Ecodigo#</Empresa>
			<Periodo>#rsSQL.Eperiodo#</Periodo>
			<Mes>#rsSQL.Emes#</Mes>
			<Concepto>#rsSQL.Cconcepto#</Concepto>
			<Descripcion>#rsSQL.Cdescripcion#</Descripcion>
			<Documento>#rsSQL.Edocumento#</Documento>  
		</row>">
	</cfloop>
<cfset LvarTabla &= "<recordset>">

<cfset GvarXML_OE = LvarTabla>

