<!-----Interfaz 404 - Consulta de NAPs a partir de un rango de cuentas ------>

<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- <cfif listLen(GvarXML_IE) NEQ 4>
	<cfthrow message="Se requieren 4 parámetros de entrada: Período Contable a Afectar, Mes Contable a Afectar, Formato Inicial y Formato Final.">
</cfif>

<cfset LvarPeriodo    = listGetAt(GvarXML_IE,1)>
<cfset LvarMes        = listGetAt(GvarXML_IE,2)>
<cfset CPformatoIni   = listGetAt(GvarXML_IE,3)>
<cfset CPformatoFin   = listGetAt(GvarXML_IE,4)> --->

<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />
 
<cfset LvarPeriodo			= #datosXML.row.Eperiodo.xmltext#>
<cfset LvarMes			= #datosXML.row.Emes.xmltext#>
<cfset CPformatoIni   		= #datosXML.row.CPformatoIni.xmltext#>
<cfset CPformatoFin				= #datosXML.row.CPformatoFin.xmltext#>


<cfif LvarPeriodo EQ -1>
	<cfthrow message="Falta el periodo contable">
</cfif>

<cfif LvarMes EQ -1>
	<cfthrow message="Falta el mes contable">
</cfif>
<cfif CPformatoIni EQ -1>
	<cfset CPformatoIni = "">
</cfif>
<cfif CPformatoFin EQ -1>
	<cfset CPformatoFin = chr(127)>
</cfif>

<cfquery name="rsSQL" datasource="#session.dsn#">
	select distinct cp.CPcuenta
	  from CPresupuesto cp
	  	inner join CFinanciera cf
			on cf.CPcuenta = cp.CPcuenta
	 where cp.Ecodigo = #session.Ecodigo#
	   and cp.CPformato >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#CPformatoIni#">
	   and cp.CPformato <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#CPformatoFin##chr(127)#">
	   and cp.CPmovimiento = 'S'
</cfquery>

	<cfif rsSQL.recordCount EQ 0>
		<cfthrow message="No se encontraron cuentas asociadas">
	</cfif>
<cfset LvarXML = "<resultset>"> 
    <cfloop query="rsSQL">
		<cfquery name="rsSQL2" datasource="#session.dsn#">
			  select  distinct
			       napD.CPNAPnum		
			  from 
				CPNAPdetalle napD					
			 where napD.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.CPcuenta#">	
			   and napD.Ecodigo = #session.Ecodigo# 		  
		</cfquery>
		<cfloop query="rsSQL2">
	       <cfif len(trim(rsSQL2.CPNAPnum)) gt 0>
					<cfquery name="rsSQL3" datasource="#session.dsn#">
					select  
							coalesce(nap.CPNAPmoduloOri,'---') as CPNAPmoduloOri,
							coalesce(nap.CPNAPnum, 0 ) as CPNAPnum,
							coalesce(nap.CPNAPdocumentoOri, '****' ) as CPNAPdocumentoOri,
							coalesce(nap.CPNAPreferenciaOri,'////' ) as CPNAPreferenciaOri
						from CPNAP nap
						   where nap.CPNAPnum =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL2.CPNAPnum#"> 
						   and nap.Ecodigo = #session.Ecodigo#
					</cfquery>		
		
				    <cfif rsSQL3.recordCount GT 0>
					<cfset LvarXML &="
							 <row>					
								<ModuloOrigen>#rsSQL3.CPNAPmoduloOri#</ModuloOrigen>
								<NAPnum>#rsSQL3.CPNAPnum#</NAPnum>
								<DocumentoOri>#rsSQL3.CPNAPdocumentoOri#</DocumentoOri>
								<NAPreferencia>#rsSQL3.CPNAPreferenciaOri#</NAPreferencia>					
							 </row><br />">
					 </cfif>	
			</cfif>	
		</cfloop>		 	 
    </cfloop>
<cfset LvarXML &= "</resultset>">
<cfset GvarXML_OE = LvarXML>
