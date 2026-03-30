<cfinclude template="../../Utiles/sifConcat.cfm">

<cfif isdefined("url.FAM09MAQ") and len(trim(url.FAM09MAQ)) and not isdefined("form.FAM09MAQ")>
	<cfset form.FAM09MAQ = url.FAM09MAQ>
</cfif>
<cfif isdefined("url.FAM01COD") and len(trim(url.FAM01COD)) and not isdefined("form.FAM01COD")>
	<cfset form.FAM01COD = url.FAM01COD>
</cfif>

<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="50%" valign="top">
			<!---PINTA LA LISTA IMPRESORAS --->
			<cfquery name="lista" datasource="#session.DSN#">
				select Ocodigo, FAM01COD, FAM01CODD, FAM09MAQ, 
					case when datalength(FAM01DES) > 14 then  substring(FAM01DES, 1, 15) #_Cat# '...' else FAM01DES end as FAM01DES, FAM01RES, FAM01TIP, FAM01COB,FAM01STS,FAM01STP,CFcuenta, I02MOD, CCTcodigoAP,
					CCTcodigoDE, CCTcodigoFC, CCTcodigoCR, CCTcodigoRC, CCTcodigoRC, FAM01NPR, FAM01NPA,
					Aid
				from FAM001
				where Ecodigo = #session.Ecodigo#
				 and FAM09MAQ = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAM09MAQ#">
					order by FAM01CODD, FAM01DES
			</cfquery>

			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
					<cfinvokeargument name="query" 				value="#lista#"/>
					<cfinvokeargument name="desplegar" 			value=" FAM01CODD,FAM01DES "/>
					<cfinvokeargument name="etiquetas" 			value=" C&oacute;digo, Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" 			value="V, V"/>
					<cfinvokeargument name="align" 				value="left, left"/>
					<cfinvokeargument name="ajustar" 			value="N"/>
					<cfinvokeargument name="irA" 				value="cajasProceso.cfm?Paso=3"/>
					<cfinvokeargument name="keys" 				value="FAM01COD"/>
					<cfinvokeargument name="PageIndex" 			value="1"/>					
					<cfinvokeargument name="showemptylistmsg" 	value="true"/>
					<cfinvokeargument name="navegacion" 		value="&FAM09MAQ=#form.FAM09MAQ#"/>
			   </cfinvoke>
		</td>
		<td width="50%" valign="top">
				<cfinclude template="cajasProceso_Paso3-form.cfm">
		</td>
	</tr>		
</table>