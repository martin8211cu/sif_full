<cfinclude template="anexo-rango-cel.cfm">

<cfif rsLinea.AnexoCon GTE 20 and rsLinea.ANHid eq "">
	<cfquery name="rsFmt" datasource="#Session.DSN#">
		select Pvalor 
		from Parametros 
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = 10
	</cfquery>
	<cfparam name="url.AnexoId" >
	<cfparam name="url.AnexoCelId" >
	<cfquery name="rsAnexo" datasource="#Session.DSN#">
		select AnexoDes, <cf_dbfunction name="to_date00" args="AnexoFec"> as AnexoFec, AnexoUsu 
		from Anexo
		where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	</cfquery>
	
	<cfquery name="rsRangos" datasource="#Session.DSN#">
		select AnexoRan 
		from AnexoCel 
		where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoCelId#">
	</cfquery>
	
	<cfif isdefined('url.Ppagina')>
		<cfset clm_pag = #url.Ppagina#>
	<cfelse>
		<cfset clm_pag = 1>
	</cfif>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr class="tituloAlterno"> 
		<td width="57%"><div align="left"><font size="2">Cuentas Financieras para el Cálculo de la Celda <cfoutput>#rsRangos.AnexoRan#</cfoutput></font></div></td>  
		<td width="43%"><div align="left"><font size="2">Máscaras de Cuenta Financiera</font></div></td>    
	  </tr>
	  <tr> 
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr> 
		<td>
			<cfinclude template="anexo-cuenta-form.cfm">
			<br>
		</td>  
		<td valign="top">
		
			<cfset fltr = ",1 as nav">
			<cfif isdefined("url.F_Hoja") and len(trim(url.F_Hoja)) gt 0>
				<cfset fltr = fltr & ",'#url.F_Hoja#' as F_Hoja">
			</cfif>
			<cfif isdefined("url.F_columna") and url.F_columna gt 0>
				<cfset fltr = fltr & ",#url.F_columna# as F_columna">
			</cfif>
			<cfif isdefined("url.F_fila") and url.F_fila gt 0>
				<cfset fltr = fltr & ",#url.F_fila# as F_fila">
			</cfif>
			<cfif isdefined("url.F_Rango") and len(trim(url.F_Rango)) gt 0>
				<cfset fltr = fltr & ",'#url.F_Rango#' as F_Rango">
			</cfif>				
			<cfif isdefined("url.F_Estado") and url.F_Estado gt 0>
				<cfset fltr = fltr & ",#url.F_Estado# as F_Estado">
			</cfif>	
			<cfif isdefined("url.F_Cuentas") and url.F_Cuentas gt 0>
				<cfset fltr = fltr & ",#url.F_Cuentas# as F_Cuentas">
			</cfif>	 
			<cf_dbfunction name="to_char" args="b.AnexoId" 			returnvariable="AnexoId" >	
			<cf_dbfunction name="to_char" args="a.AnexoCelDid" 		returnvariable="AnexoCelDid" >
			<cf_dbfunction name="to_char" args="a.AnexoCelId" 		returnvariable="AnexoCelId" >
			<cf_dbfunction name="length"  args="a.AnexoCelFmt" 		returnvariable="AnexoCelFmt" >	
			<cf_dbfunction name="sPart"	  args="a.AnexoCelFmt;1;#AnexoCelFmt#-1" delimiters=";" returnvariable="AnexoCelFmt">		
		<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="AnexoCelD a, AnexoCel b"/>
			<cfinvokeargument name="columnas" value="#AnexoId# as AnexoId, #AnexoCelDid# as AnexoCelDid, #AnexoCelId# as AnexoCelId, a.AnexoCelFmt, a.AnexoCelFmt as Cformato, a.AnexoCelMov, 2 as tab, 1 as cta, case when AnexoSigno = -1 then '-' else '+' end as ElSigno, #clm_pag# as Ppagina #fltr#"/>
			<cfinvokeargument name="desplegar" value="AnexoCelFmt, AnexoCelMov, ElSigno"/>
			<cfinvokeargument name="etiquetas" value="Formato, Movs, Signo"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="a.AnexoCelId = #url.AnexoCelid#
											   and a.AnexoCelId = b.AnexoCelId"/>
			<cfinvokeargument name="align" value="left, center, center"/>
			<cfinvokeargument name="ajustar" value="S,N,N"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="anexo.cfm"/>
			<cfinvokeargument name="maxrows" value="0"/>
			<cfinvokeargument name="form_method" value="get"/>
		  </cfinvoke> 
		  </td>
	
	  </tr>
	  <tr>
		<td valign="top">&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr> 
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	</table>
</cfif>
