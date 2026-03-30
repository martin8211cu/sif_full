<cfif isdefined("url.FAX04CVD") and len(trim(url.FAX04CVD)) and not isdefined("form.FAX04CVD")>
	<cfset form.FAX04CVD = url.FAX04CVD>
</cfif>

<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
    	<td align="center">
			<cfinclude template="comisionesvend-form.cfm">	
		</td>
  	</tr>
	<tr>
		<td width="50%" valign="top">
			<cfif isdefined('url.FAM21CED_F') and not isdefined('form.FAM21CED_F')>
				<cfparam name="form.FAM21CED_F" default="#url.FAM21CED_F#">
			</cfif>
			<cfif isdefined('url.FAM21NOM_F') and not isdefined('form.FAM21NOM_F')>
				<cfparam name="form.FAM21NOM_F" default="#url.FAM21NOM_F#">
			</cfif>
	
			<cfset navegacion = "">
			
			<cfif isdefined("Form.FAM21CED_F") and Len(Trim(Form.FAM21CED_F)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM21CED_F=" & Form.FAM21CED_F>
			</cfif>				
			<cfif isdefined("Form.FAM21NOM_F") and Len(Trim(Form.FAM21NOM_F)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM21NOM_F=" & Form.FAM21NOM_F>
			</cfif>	
				
			<cfquery name="lista" datasource="#session.DSN#">
				Select A.FAX04CVD, A.FAM22RVI,A.FAM22RVS,A.FAM22PCO,A.FAM22MON, B.FAM21NOM
				<cfif isdefined("Form.FAM21CED_F") and Len(Trim(Form.FAM21CED_F)) NEQ 0>
					, '#FAM21CED_F#' as FAM21CED_F
				</cfif>	
				<cfif isdefined("Form.FAM21NOM_F") and Len(Trim(Form.FAM21NOM_F)) NEQ 0>
					, '#FAM21NOM_F#' as FAM21NOM_F
				</cfif>
				
				from FAM022 A
				
				inner join FAM021 B
				on B.FAX04CVD=A.FAX04CVD
				and B.Ecodigo=A.Ecodigo
				
				where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and A.FAX04CVD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAX04CVD#">
				
				order by A.FAX04CVD, A.FAM22RVI
			</cfquery>
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#lista#"/>
				<cfinvokeargument name="desplegar" value=" FAM22RVI,FAM22RVS,FAM22PCO,FAM22MON"/>
				<cfinvokeargument name="etiquetas" value=" Rango Venta Inferior, Rango Venta Superior, (%)Comisi&oacute;n, Monto Tracto"/>
				<cfinvokeargument name="formatos" value="V, V, V, V"/>
				<cfinvokeargument name="align" value="left, left, left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="vendedores.cfm"/>
				<cfinvokeargument name="keys" value="FAX04CVD, FAM22RVI"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showemptylistmsg" value="true"/>
				<cfinvokeargument name="formname"  value="lista2"/>
			</cfinvoke>
		</td>
	</tr>		
</table>
	