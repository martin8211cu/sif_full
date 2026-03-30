<cfif isdefined("url.Bid") and len(trim(url.Bid)) and not isdefined("form.Bid")>
	<cfset form.Bid = url.Bid>
</cfif>

<table width="100%" align="center" cellpadding="0" cellspacing="0">
	<tr>
    	<td align="center">
			<cfinclude template="comisiones_banc-form.cfm">	
		</td>
  	</tr>
  	<tr>
    	<td><hr></td>
  	</tr>
	<tr>
		<td width="50%" valign="top">
			<cfif isdefined('url.Bid_F') and not isdefined('form.Bid_F')>
				<cfparam name="form.Bid_F" default="#url.Bid_F#">
			</cfif>
			<cfif isdefined('url.FAM18DES_F') and not isdefined('form.FAM18DES_F')>
				<cfparam name="form.FAM18DES_F" default="#url.FAM18DES_F#">
			</cfif>
	
			<cfset navegacion = "">
			<cfif isdefined("Form.Bid_F") and Len(Trim(Form.Bid_F)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Bid_F=" & Form.Bid_F>
			</cfif>				
			<cfif isdefined("Form.FAM18DES_F") and Len(Trim(Form.FAM18DES_F)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM18DES_F=" & Form.FAM18DES_F>
			</cfif>	
				
			<cfquery name="lista" datasource="#session.DSN#">
				Select a.FAM19LIN, a.Bid, a.FAM19INF, a.FAM19SUP, a. FAM19MON, a.FAM19PRI, b.FAM18DES
				<cfif isdefined("Form.Bid_F") and Len(Trim(Form.Bid_F)) NEQ 0>
					, '#Bid_F#' as Bid_F
				</cfif>	
				<cfif isdefined("Form.FAM18DES_F") and Len(Trim(Form.FAM18DES_F)) NEQ 0>
					, '#FAM18DES_F#' as FAM18DES_F
				</cfif>
					
				from FAM019 a
				
				inner join FAM018 b
				on b.Bid=a.Bid
				and b.Ecodigo=a.Ecodigo
				
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.Bid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Bid#">
				
				order by a.FAM19LIN, a.Bid
			</cfquery>
			<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
			 	returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#lista#"/>
				<cfinvokeargument name="etiquetas" value="Rango Inferior, Rango Superior"/>
				<cfinvokeargument name="desplegar" value="FAM19INF, FAM19SUP"/>
				<cfinvokeargument name="formatos" value="V,V"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="bancos.cfm"/>
				<cfinvokeargument name="keys" value="FAM19LIN, BID"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showemptylistmsg" value="true"/>
				<cfinvokeargument name="formname"  value="lista2"/>
			</cfinvoke>
		</td>
	</tr>		
</table>
