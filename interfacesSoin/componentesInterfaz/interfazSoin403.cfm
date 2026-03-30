<!-----Interfaz 403 -- Cuentas por centro funcional ------->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- <cfif listLen(GvarXML_IE) NEQ 3>
	<cfthrow message="Se requieren 3 parámetros de entrada: Código del Centro Funcional, Formato Inicial y Formato Final.">
</cfif>

<cfset CFcodigo	      = listGetAt(GvarXML_IE,1)>
<cfset CPformatoIni   = listGetAt(GvarXML_IE,2)>
<cfset CPformatoFin   = listGetAt(GvarXML_IE,3)> --->


<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />
 
<cfset CFcodigo			= #datosXML.row.CFcodigo.xmltext#>
<cfset CPformatoIni   		= #datosXML.row.CPformatoIni.xmltext#>
<cfset CPformatoFin				= #datosXML.row.CPformatoFin.xmltext#>


<cfif CFcodigo EQ -1>
	<cfthrow message="Falta Centro Funcional">
</cfif>
<cfif CPformatoIni EQ -1>
	<cfset CPformatoIni = "">
</cfif>
<cfif CPformatoFin EQ -1>
	<cfset CPformatoFin = chr(127)>
</cfif>

<cfquery name="rsCF" datasource="#session.dsn#">
	select 	CFid, CFcodigo, 	CFdescripcion,
			o.Ecodigo, o.Ocodigo, o.Oficodigo, o.Odescripcion,
			CFcuentac, 			CFcuentaaf,
			CFcuentainversion, 	CFcuentainventario,
			CFcuentaingreso, 	CFcuentagastoretaf,
			CFcuentaingresoretaf
	  from CFuncional cf
	  	inner join Oficinas o
			 on o.Ecodigo = cf.Ecodigo
			and o.Ocodigo = cf.Ocodigo
	 where CFcodigo = '#CFcodigo#'
	  and cf.Ecodigo = #session.Ecodigo#
</cfquery>
<cfif rsCF.CFid EQ "">
	<cfthrow message="Centro Funcional '#CFcodigo#' no existe">
</cfif>

<cfquery name="rsSQL" datasource="#session.dsn#">
	select CPformato, CPdescripcion
	  from CPresupuesto cp
	  	inner join CFinanciera cf
			on cf.CPcuenta = cp.CPcuenta
	 where cp.Ecodigo = #session.Ecodigo#
	   and cp.CPformato >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#CPformatoIni#">
	   and cp.CPformato <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#CPformatoFin##chr(127)#">
	   and cp.CPmovimiento = 'S'
	   and (
			    cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentac)#'
			 OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentaaf)#'
			 OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentainversion)#'
			 OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentainventario)#'
			 OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentaingreso)#'
			 OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentagastoretaf)#'
			 OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentaingresoretaf)#'
		)
</cfquery>

<cfif rsSQL.recordCount EQ 0>
	<cfthrow message="No se encontraron cuentas en el Centro Funcional '#CFcodigo#'">
</cfif>

<cfset LvarXML = "<resultset>">
<cfloop query="rsSQL">
	<cfset LvarXML &=
"    <row>
        <CFcodigo>#rsCF.CFcodigo#</CFcodigo>
        <CFdescripcion>#rsCF.CFdescripcion#</CFdescripcion>
        <Oficina>#rsCF.Oficodigo#</Oficina>
        <Ofidescripcion>#rsCF.Odescripcion#</Oficina>
        <CPformato>#rsSQL.CPformato#</CPformato>
        <CPdescripcion>#rsSQL.CPdescripcion#</CPdescripcion>
    </row><br>
">
</cfloop>

<cfset LvarXML &= "</resultset>">
<cfset GvarXML_OE = LvarXML>

<cffunction name="fnComodinToMascara" access="private" output="no">
	<cfargument name="Comodin" type="string" required="yes">

	<cfset var LvarComodines = "?,*,!">

	<cfset var LvarMascara = Arguments.Comodin>
	<cfloop index="LvarChar" list="#LvarComodines#">
		<cfset LvarMascara = replace(LvarMascara,mid(LvarChar,1,1),"_","ALL")>
	</cfloop>

	<cfreturn LvarMascara>
</cffunction>

