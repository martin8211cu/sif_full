<cfif isdefined("url.FAM09MAQ") and len(trim(url.FAM09MAQ)) and not isdefined("form.FAM09MAQ")>
	<cfset form.FAM09MAQ = url.FAM09MAQ>
</cfif>

<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="50%" valign="top">
			<!---PINTA LA LISTA --->
			<cfquery name="rsMaquinas" datasource="#session.DSN#">
				select FAM09MAQ, FAM09DES
				from FAM009
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				order by FAM09MAQ, FAM09DES
			</cfquery>
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsMaquinas#"/>
					<cfinvokeargument name="desplegar" value=" FAM09MAQ, FAM09DES"/>
					<cfinvokeargument name="etiquetas" value=" C&oacute;digo, Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" value="V, V"/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N, N"/>
					<cfinvokeargument name="irA" value="cajasProceso.cfm?Paso=1"/>
					<cfinvokeargument name="keys" value="FAM09MAQ"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
					
			</cfinvoke>
		</td>
		<td width="50%" valign="top"><cfinclude template="cajasProceso_Paso1-form.cfm"></td>
	</tr>		
</table>