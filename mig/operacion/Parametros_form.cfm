<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="fnLeeParametro" returntype="string">
	<cfargument name="Pcodigo"		type="numeric"	required="true">	
	<cfargument name="Pdescripcion"	type="string"	required="true">	
	<cfargument name="Pdefault"		type="string"	required="false">	
	<cfset var rsSQL = "">
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select Pvalor
		  from Parametros
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		   and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfif rsSQL.Pvalor NEQ "">
		<cfreturn rsSQL.Pvalor>
	<cfelseif isdefined("Arguments.Pdefault")>
		<cfreturn Arguments.Pdefault>
	<cfelse>
		<cf_errorCode	code = "50436"
						msg  = "No se ha definido el Parámetro @errorDat_1@ - @errorDat_2@"
						errorDat_1="#Pcodigo#"
						errorDat_2="#Pdescripcion#"
		>
	</cfif>
</cffunction>

<cfoutput>
<form action="Parametros_sql.cfm" method="post" name="form1">
<p></p>
	<table width="85%" border="0" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<!---PARAMETRO PARA ANTICIPOS DE EMPLEADO--->
			<cfset LvarDSN	= fnLeeParametro(2000,"DSN destino para Cargar Datos al Modelo Multidimensional","")>
			
			<td nowrap width="50%">
				DSN destino para Cargar Datos al Modelo Multidimensional:
			</td>
			<td nowrap width="50%">
				<select name="P2000">
				<option value="" selected>(DSN de la Empresa conectada)</option>
				<cfloop collection="#application.dsinfo#" item="db">
					<option value="#application.dsinfo[db].name#" <cfif application.dsinfo[db].name EQ LvarDSN> selected</cfif>>#application.dsinfo[db].name#</option>
				</cfloop>
				</select>
			</td>
		
		</tr>
		<tr>
		  <td nowrap>&nbsp;</td>
		  <td nowrap>&nbsp;</td>
	  </tr>
		<tr>
		  <td colspan="2" nowrap>
			  <div align="center">
				<input type="submit" name="btnAceptar" value="Aceptar" />
			  </div>
		  </td>
	  </tr>
	</table>

</form>
</cfoutput>



