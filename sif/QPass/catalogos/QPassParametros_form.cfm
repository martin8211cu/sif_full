<cfset LNegra = 0>
<cfset LBlanca = 0>
<cfset LvarPostpago = 0>

 <!--- Obtiene los datos de la tabla de Parmetros segn el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
		from QPParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cfset PvalorVN = ObtenerDato(20)>
<cfset PvalorVBlanca = ObtenerDato(10)>
<cfset PvalorPostpago = ObtenerDato(25)>

<!--- Variables para saber si hay que hacer un insert o un update en el .sql de cada uno de estos registros ---->
<cfif PvalorVN.Recordcount GT 0 ><cfset LNegra = 1 ></cfif>
<cfif PvalorVBlanca.Recordcount GT 0 ><cfset LBlanca = 1 ></cfif>
<cfif PvalorPostpago.Recordcount GT 0 ><cfset LvarPostpago = 1 ></cfif>

<cfset varExiste = false>
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select Mcodigo, Mnombre from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<form action="QPassParametros_SQL.cfm" method="post" name="form1">
	<table width="85%" border="0" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td>&nbsp;</td>
			<td align="right" nowrap>Valor Lista Blanca Prepago:&nbsp;</td>
			<td><cf_inputNumber name="valor3" value="#PvalorVBlanca.Pvalor#" enteros="4" decimales="0"></td>
			<td align="center" rowspan="1" valign="top">
				<table width="97%" class="ayuda" align="center">
					<tr>
						<td>
							<p align="justify">Indica el <strong>Saldo M&iacute;nimo </strong>  para permanecer en Lista Blanca.</p>
						</td>
					</tr>
				</table>	
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right" nowrap>Valor Lista Negra Prepago:&nbsp;</td>
			<td><cf_inputNumber name="valor2" value="#PvalorVN.Pvalor#" enteros="4" decimales="0"></td>
			<td align="center" rowspan="1" valign="top">
            	<table width="97%" class="ayuda" align="center">
                      <tr>
                        <td><p align="justify">Indica el <strong>Saldo M&iacute;nimo</strong> para permanecer en Lista negra.</p></td>
                      </tr>
                  </table>
            </td>
			<td>&nbsp;</td>
		</tr>	
        <tr>
			<td>&nbsp;</td>
			<td align="right" nowrap>Parametros listas postago:&nbsp;</td>
			<td><cf_inputNumber name="Postpago" value="#PvalorPostpago.Pvalor#" enteros="4" decimales="0" negativos="true"></td>
			<td align="center" rowspan="1" valign="top">
            	<table width="97%" class="ayuda" align="center">
					<tr>
						<td>
							<p align="justify"><strong>Saldo Quick Pass mínimo</strong> para no entrar en lista negra.</p>
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
    <input type="hidden" name="LBlanca" value="<cfoutput>#LBlanca#</cfoutput>">
    <input type="hidden" name="LNegra" value="<cfoutput>#LNegra#</cfoutput>">
    <input type="hidden" name="LPostpago" value="<cfoutput>#LvarPostpago#</cfoutput>">
</form>
