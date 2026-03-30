<cfset CodInst = 0>
<cfset Separador = 0>

<!--- Obtiene los datos de la tabla de Parmetros segn el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor
			from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cfset PvalorInst = ObtenerDato(3001)>
<cfset PvalorSep  = ObtenerDato(3000)>

<!--- Variables para saber si hay que hacer un insert o un update en el .sql de cada uno de estos registros ---->
<cfif PvalorInst.Recordcount GT 0 ><cfset CodInst   = 1 ></cfif>
<cfif PvalorSep.Recordcount  GT 0 ><cfset Separador = 1 ></cfif>

<cfset varExiste = false>

<form action="ConfiguracionDatosArchivo_SQL.cfm" method="post" name="form1">
	<table width="85%" border="0" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td>&nbsp;</td>
			<td align="right" nowrap>C&oacute;digo de la Instituci&oacute;n:&nbsp;</td>
			<td>
				<input type="text" name="valor3" size="20" maxlength="50" value="<cfoutput>#PvalorInst.Pvalor#</cfoutput>" >
			</td>
			<td align="center" rowspan="2" valign="top">
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td>
							<p align="justify">Indica el <strong>C&oacute;digo de la Instituci&oacute;n </strong>.</p>
						</td>
					</tr>
				</table>	
			</td>
			<td>&nbsp;</td>
		</tr>
			<td>&nbsp;</td>
		<tr>
			<td>&nbsp;</td>
			<td align="right" nowrap>Separador:&nbsp;</td>
			<td>
				<input type="text" name="valor2" size="5" maxlength="50" value="<cfoutput>#PvalorSep.Pvalor#</cfoutput>" >
			</td>
			<td align="center" rowspan="2" valign="top">
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td>
							<p align="justify">Indica el <strong>El separador a utilizar en la máscara</strong>.</p>
						</td>
					</tr>
				</table>	
			</td>
			<td>&nbsp;</td>
		</tr>	
		<tr><td colspan=5><hr size=0></td></tr>
		<tr> 
			<td colspan="4" align="center">
				<input type="submit" name="<cfif varExiste EQ false>Aceptar<cfelse>Modificar</cfif>" value="Aceptar">
			</td>
		</tr>
	</table>
			<input type="hidden" name="Separador" value="<cfoutput>#Separador#</cfoutput>">
			<input type="hidden" name="CodInst" value="<cfoutput>#CodInst#</cfoutput>">
</form>
