
<!---
 El siguiente componente se utiliza para insertar la moneda especificada como 
como moneda local en el catalogo de empresas en el catalogo de monedas de RH
la manera de invocarlo es la siguente : 
<cfinvoke component="rh.Componentes.RH_CargaMonedaLoc" method="Ins_Moneda_Loc" 	
 Ecodigo ="#Session.Ecodigo#">
</cfinvoke>	
********************************************************************************
--->
<cfcomponent>
	<cffunction access="public" name="Ins_Moneda_Loc" >
		<cfargument name="Ecodigo" type="numeric" required="true" default="#session.Ecodigo#">
		<cfargument name="Conexion" type="string" required="true" default="#session.DSN#">
		
		<cfquery name="rsExiste" datasource="#Arguments.Conexion#">
			Select e.Mcodigo , COALESCE(m.Mcodigo,0) as existe  
			from Empresas e
			left outer  join RHMonedas m on
				m.Mcodigo     = e.Mcodigo
				and m.Ecodigo = e.Ecodigo
			where  e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">		
		</cfquery>
		<cfif rsExiste.recordcount gt 0 and rsExiste.existe eq 0>
			<cfquery name="rsInsert" datasource="#Arguments.Conexion#">
				insert into  RHMonedas (Ecodigo,Mcodigo,Eliminable,BMUsucodigo,fechaalta)
				values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExiste.Mcodigo#">,
				0,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)  
			</cfquery>
		</cfif>
	</cffunction>
</cfcomponent>
