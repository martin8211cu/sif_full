<cffunction name="get_CualMes" access="public" returntype="string">
	<cfargument name="valor" type="numeric" required="true" default="<!--- Nombre del mes --->">
		<cfswitch expression="#valor#">
			<cfcase value="1">  <cfset CualMes = 'Enero'>      </cfcase>
			<cfcase value="2">  <cfset CualMes = 'Febrero'>    </cfcase>
			<cfcase value="3">  <cfset CualMes = 'Marzo'>      </cfcase>
			<cfcase value="4">  <cfset CualMes = 'Abril'>      </cfcase>
			<cfcase value="5">  <cfset CualMes = 'Mayo'>       </cfcase>
			<cfcase value="6">  <cfset CualMes = 'Junio'>      </cfcase>												
			<cfcase value="7">  <cfset CualMes = 'Julio'>      </cfcase>
			<cfcase value="8">  <cfset CualMes = 'Agosto'>     </cfcase>
			<cfcase value="9">  <cfset CualMes = 'Setiembre'>  </cfcase>
			<cfcase value="10"> <cfset CualMes = 'Octubre'>    </cfcase>
			<cfcase value="11"> <cfset CualMes = 'Noviembre'>  </cfcase>
			<cfcase value="12"> <cfset CualMes = 'Diciembre'>  </cfcase>
			<cfdefaultcase> <cfset CualMes = 'Enero'> </cfdefaultcase>
		</cfswitch>
	<cfreturn #CualMes#>
</cffunction>

<cfset NombMes = '#get_CualMes(url.mes)#'>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
		Acodigo, 
		Adescripcion,  
		Mnombre, 
		coalesce(a.CTDcosto,0) as CTDcosto,
		coalesce(a.CTDprecio,0) as CTDprecio
	from CostoProduccionSTD a
	inner join Articulos b
		on a.Aid = b.Aid 
		and a.Ecodigo = b.Ecodigo
	inner join Monedas m
		on a.Mcodigo = m.Mcodigo
		and a.Ecodigo = b.Ecodigo
	where a.Ecodigo =  #Session.Ecodigo# 
	and CTDperiodo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
	and CTDmes  = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
	order by Mnombre,Acodigo
</cfquery>

<cfif rsReporte.recordcount GT 10000>
		<br><br>
	    <div align="center"><strong>Se genero un reporte más grande de lo permitido.  Se abortó el proceso</strong></div>	
		<cfabort>
<cfelseif rsReporte.recordcount EQ 0>
		<br><br>
		<div align="center"><strong>El reporte no genero Resultados.  Se abortó el proceso</strong></div>
		<cfabort>
</cfif>

<!--- Define cual reporte va a llamar --->
	<cfset archivo = "Precios.cfr">

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion 
	from Empresas
 	where Ecodigo =  #Session.Ecodigo# 
</cfquery>

<!--- INVOCA EL REPORTE --->
<cfreport format="#url.formato#" template= "#archivo#" query="rsReporte">
	<cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">
	<cfreportparam name="periodo"      value="#url.periodo#">
	<cfreportparam name="mes"          value="#NombMes#">
</cfreport>