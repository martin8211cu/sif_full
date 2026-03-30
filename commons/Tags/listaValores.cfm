<cfparam name="Attributes.Codigo"      type="String"> <!--codigo del valor para filtrar en la tabla de valores detalles-->
<cfparam name="Attributes.name"        type="String"> <!--nombre del campo -->
<cfparam name="Attributes.valor"       type="String"  default="" > <!--valor actual -->
<cfparam name="Attributes.conexion"    type="String"  default="asp" > <!--valor actual ddel registro en base de datos-->
<cfparam name="Attributes.required"    type="String"  default="false" > <!--dice si es requerido el valor-->
<cfparam name="Attributes.blank"       type="String"  default="false" > <!--dice si incluye una opcion vacia-->
<cfparam name="Attributes.tabindex"    type="String"  default="0" > <!--dice si incluye una opcion vacia-->

	<cfquery name="rsVD" datasource="asp">
		SELECT vd.Codigo, vd.Descripcion
		FROM ValTab  v 
			INNER JOIN ValtabDetalle vd
			ON v.id = vd.ValTabid 
		WHERE v.Codigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Codigo#">
	</cfquery>

	<cfoutput> 
		<select id="#Attributes.name#" name="#Attributes.name#" <cfif Attributes.required eq "true"> required </cfif>  tabindex="#Attributes.tabindex#">
		<cfif Attributes.blank eq "true"> <option> </option> </cfif>
		<cfloop query ="rsVD"> 
			<option value="#rsVD.Codigo#" <cfif Attributes.valor eq rsVD.Codigo > selected </cfif>>#rsVD.Descripcion#</option>
		</cfloop> 
		</select> 
	</cfoutput>