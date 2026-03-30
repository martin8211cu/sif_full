<cfif isdefined("url.FAM09MAQ") and len(trim(url.FAM09MAQ)) and not isdefined("form.FAM09MAQ")>
	<cfset form.FAM09MAQ = url.FAM09MAQ>
</cfif>

<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="50%" valign="top">
			<!---PINTA LA LISTA IMPRESORAS --->
			<cfquery name="lista" datasource="#session.DSN#">
						select  a.FAM09MAQ,a.FAX01ORIGEN, b.FAM09DES, a.FAM12COD, c.FAM12CODD, c.FAM12DES, a.CCTcodigo, d.CCTdescripcion
						from FAM014 as a
						
						inner join FAM009 as b 
						on b.FAM09MAQ = a.FAM09MAQ 
						and b.Ecodigo = a.Ecodigo
						
						inner join FAM012 as c
						on c.FAM12COD = a.FAM12COD
						and c.Ecodigo = a.Ecodigo
												
						inner join CCTransacciones as d
						on d.CCTcodigo = a.CCTcodigo
						and d.Ecodigo = a.Ecodigo						
												
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and a.FAM09MAQ = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAM09MAQ#">
						order by a.FAM12COD, a.CCTcodigo
			</cfquery>
			<cfset navegacion = "&FAM09MAQ=#form.FAM09MAQ#">
			<cfinvoke
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#lista#"/>
						<cfinvokeargument name="etiquetas" value="C&oacute;digo, Impresora,Origen,Codigo, Transacci&oacute;n"/>
						<cfinvokeargument name="desplegar" value="FAM12CODD ,FAM12DES,FAX01ORIGEN,CCTcodigo, CCTdescripcion"/>
						<cfinvokeargument name="formatos" value=" V, V, V,V,V"/>
						<cfinvokeargument name="align" value=" left, left, center,left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="cajasProceso.cfm?Paso=2"/>
						<cfinvokeargument name="keys" value="FAM09MAQ, CCTcodigo,FAX01ORIGEN,FAM12COD"/>
						<cfinvokeargument name="showemptylistmsg" value="true"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
			   </cfinvoke>
	 </td>
	<td width="50%" valign="top"><cfinclude template="cajasProceso_Paso2-form.cfm"></td>
</tr>		
</table>