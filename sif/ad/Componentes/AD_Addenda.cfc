<!---Componente Padre Addendas --->
<!---Autor: JARR --->
<!---6/MAYO/2019 --->
<!--- Las funciones de este componente se implementaran 
para crear los nodos de las addendas por socio de negocio--->
<cfcomponent>
	<cfset This.DSN     = ''>
	<cfset This.Ecodigo = ''> 
	<!--- FUNCION PARA INICIALIZAR LA FUNCION --->
	<cffunction name="init" access="public" output="no" returntype="AD_Addenda" hint="constructor">  
		<cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
		<cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >
 
		<cfset This.DSN 	= arguments.DSN>
		<cfset This.Ecodigo = arguments.Ecodigo>

		<cfreturn this>
	</cffunction>
	 <!--- FUNCION PARA OBTENER LOS VALORES FIJOS DEL DETALLE DE LA ADDENDA --->
	<cffunction name="get_AddaValue" returntype="string" >
		<cfargument name="ADDid" type="string" required="true">
		<cfargument name="Codigo" type="string"  required="true">
			<!--- Revisamos los valores de la Addenda de caracter Fijo --->
			<cfquery name="rsDataADD" datasource="#session.dsn#">
					select AD.VALOR
						from AddendasDetalle AD
					where AD.ADDid=#arguments.ADDid#
					and AD.CODIGO='#arguments.Codigo#'
					and AD.TIPO ='FIJO'
			</cfquery> 
		
		<cfif rsDataADD.recordcount gt 0 and  rsDataADD.VALOR NEQ '' >
			<cfreturn #rsDataADD.VALOR#>
		<cfelse>
			<cfthrow message="Error al escribir el Obtener datos de Addenda... Verifique la existencia de [#arguments.Codigo#]">
			<cfreturn false>
		</cfif>
	</cffunction>
	<cffunction name="get_NumPro" returntype="struct" >
		<cfargument name="SNnombre" type="string" required="true">
		<cfargument name="SNidentificacion" type="string"  required="true">
		<cfset resultado = structnew() >
			<!--- Revisamos los valores de la Addenda de caracter Fijo 
					substring(SNidentificacion2,(CHARINDEX( '-', SNidentificacion2, 1)+1),50) as tipoPro,
				substring(SNidentificacion2,1,(CHARINDEX( '-', SNidentificacion2, 1)-1)) as numPro
		--->
			<cfquery name="rsNumPro" datasource="#Session.DSN#">
				select 
				SNidentificacion2 as tipoPro,
				'C' as numPro
				 from SNegocios 
				 where SNnombre like '%'+rtrim(ltrim('#arguments.SNnombre#'))+'%' 
				 AND SNidentificacion = rtrim(ltrim('#arguments.SNidentificacion#'))
			</cfquery>
		<cfif rsNumPro.recordcount gt 0 and  rsNumPro.tipoPro NEQ '' and rsNumPro.numPro NEQ '' >
			<cfset resultado.tipoPro = rsNumPro.tipoPro>
			<cfset resultado.numPro = rsNumPro.numPro>
			<cfreturn resultado>
		<cfelse>
			<cfthrow message="Error al escribir el Obtener datos Socio de Negocio... Verifique la existencia de [#arguments.SNnombre#]">
			<cfreturn false>
		</cfif>
	</cffunction>
</cfcomponent>