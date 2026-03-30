
<cfset def = QueryNew("dato")>
<cfparam name="Attributes.Conlis" 		default="true" 			type="boolean"> <!--- Indica si se va a permitir abrir un conlis de Tipos de Nomina --->
<cfparam name="Attributes.index" 		default="0" 			type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.form" 		default="form1" 		type="String"> 	<!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" 		default="#def#" 		type="query"> 	<!--- consulta por defecto --->
<cfparam name="Attributes.frame" 		default="FRTipoNomina" 	type="string"> 	<!--- Nombre del frame --->
<cfparam name="Attributes.size" 		default="200px" 		type="string"> <!--- Tamaño del Nombre del tipo de acción --->
<cfparam name="Attributes.hidectls" 	default="" 				type="string"> 	<!--- Controles que se van a ocultar despues de la ejecucion --->
<cfparam name="Attributes.autogestion" 	default="false" 		type="boolean"> <!--- Indica si se van a traer únicamente los tipos de Nomina de autogestion --->
<cfparam name="Attributes.combo" 		default="false" 		type="boolean"> <!--- Indica si se pinta un combo en lugar de los campos visibles, y todos los campos quedarían como hiddens --->
<cfparam name="Attributes.tabindex" 	default="1" 			type="string">
<cfparam name="Attributes.onChange" 	default="" 				type="string">	    <!--- Funcion a ser llamada desde el onChange--->
<cfparam name="Attributes.todas" 		default="True" 			type="boolean">	    <!--- si se desea mostrar la primera opcion en blanco--->

<cfparam name="Attributes.Ecodigo" 		default="0" type="numeric">	<!--- Ecodigo para Acciones de Cambio de Empresa --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<cfif Attributes.Ecodigo NEQ 0>
	<cfset vEcodigo  = #Attributes.Ecodigo#>
<cfelse>
	<cfset vEcodigo  = #session.Ecodigo#>
</cfif>


<!---query que trae la UNION entre los tipos de nomina que no tienen restrigcion, los que no necesitan permiso y los Une con los que el usuario posee permiso de ver--->
<cf_translatedata name="get" tabla="TiposNomina" col="a.Tdescripcion" returnvariable="LvarTdescripcion">
<cfquery name="rsTiposPerm" datasource="#session.DSN#">
	select  rtrim(a.Tcodigo) as Tcodigo, #LvarTdescripcion# as Tdescripcion
	from TiposNomina a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.Tcodigo not in (select x.Tcodigo from TiposNominaPermisos x where  x.Ecodigo= a.Ecodigo
		and x.Tcodigo=a.Tcodigo ) 
	UNION
	select  rtrim(a.Tcodigo) as Tcodigo, #LvarTdescripcion# as Tdescripcion
	from TiposNomina a
		inner join TiposNominaPermisos b
		on b.Ecodigo= a.Ecodigo
		and b.Tcodigo=a.Tcodigo 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 and b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>

<cfquery name="rsTiposPermitidos" dbtype="query">
	select  * from rsTiposPerm
	order by Tcodigo
</cfquery>

<cfoutput>
	<select tabindex="1" name="Tcodigo#index#" style="max-width:#Attributes.size#" id="Tcodigo#index#" <cfif len(trim(Attributes.onChange))>onChange="javascript: #Attributes.onChange#();"</cfif>>
		<cfif Attributes.todas>
			<option value="" <cfif not isdefined("Attributes.query.Tcodigo")>selected="selected"</cfif>>--<cf_translate key="LB_Seleccione" xmlFile="/rh/generales.xml">Seleccione</cf_translate>--</option>	
		</cfif>
		<cfloop query="rsTiposPermitidos">
		<option value="#rsTiposPermitidos.Tcodigo#" <cfif isdefined("Attributes.query.Tcodigo")and len(trim(Attributes.query.Tcodigo)) and trim(rsTiposPermitidos.Tcodigo) eq trim(Attributes.query.Tcodigo)>selected="selected"</cfif>>#rsTiposPermitidos.Tcodigo#-#rsTiposPermitidos.Tdescripcion#</option>
		</cfloop>
	</select>
</cfoutput>
