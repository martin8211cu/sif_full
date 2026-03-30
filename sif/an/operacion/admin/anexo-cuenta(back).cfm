<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td colspan="2">
		<cfinclude template="anexo-rango-cel.cfm">
	</td>
</tr>
<!--- En caso de aceptar cuentas --->
<cfif rsLinea.AnexoCon GTE 20>


	<cfif isdefined("url.pagina") and not isdefined("form.pagina")>
		<cfset form.pagina = url.pagina > 
	<cfelseif isdefined("url.paginaref") and not isdefined("form.pagina")>
		<cfset form.pagina = url.paginaref > 
	<cfelseif isdefined("form.paginaref") >
		<cfset form.pagina = form.paginaref > 
	<cfelse>
		<cfset form.pagina = 1 > 
	</cfif>
	
	<cfquery name="rsFmt" datasource="#Session.DSN#">
		select Pvalor 
		from Parametros 
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = 10
	</cfquery>
	<cfparam name="url.AnexoId" >
	<cfparam name="url.AnexoCelId" >
	<cfquery name="rsAnexo" datasource="#Session.DSN#">
		select AnexoDes, convert(varchar,AnexoFec,103) as AnexoFec, AnexoUsu 
		from Anexo
		where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	</cfquery>
	
	<cfquery name="rsRangos" datasource="#Session.DSN#">
		select AnexoRan 
		from AnexoCel 
		where AnexoCelId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoCelId#">
	</cfquery>

  <tr class="tituloAlterno"> 
    <td width="57%"><div align="left"><font size="2">Formato Completo de Cuentas Contables: <strong><cfoutput>#Trim(rsFmt.Pvalor)#</cfoutput></strong></font></div></td>
    <td width="43%"><div align="left"><font size="2">Cuentas Contables Rango:<strong>&nbsp;<cfoutput>#rsRangos.AnexoRan#</cfoutput></strong> </font></div></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
  	<td valign="top">
		<cfinclude template="anexo-cuenta-form.cfm">
	</td>
    <td valign="top"> 
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="AnexoCelD a, AnexoCel b"/>
			<cfinvokeargument name="columnas" value="convert(varchar,b.AnexoId) as AnexoId, convert(varchar,a.AnexoCelDid) as AnexoCelDid, convert(varchar,a.AnexoCelId) as AnexoCelId, case when a.AnexoCelMov ='N' then a.AnexoCelFmt else substring(a.AnexoCelFmt,1,datalength(a.AnexoCelFmt)-1) end as AnexoCelFmt, a.AnexoCelFmt as Cformato, a.AnexoCelMov, 2 as tab, 1 as cta, case when AnexoSigno = -1 then '-' else '+' end as ElSigno, #form.pagina# as paginaref"/>
			<cfinvokeargument name="desplegar" value="AnexoCelFmt, AnexoCelMov, ElSigno"/>
			<cfinvokeargument name="etiquetas" value="Formato, Movimientos, Signo"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="a.AnexoCelId = #url.AnexoCelid#
											and a.AnexoCelId = b.AnexoCelId"/>
			<cfinvokeargument name="align" value="left, left, left"/>
			<cfinvokeargument name="ajustar" value="S,N,N"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="irA" value="anexo.cfm"/>
			<cfinvokeargument name="maxrows" value="0"/>
			<cfinvokeargument name="form_method" value="get"/>
			<cfinvokeargument name="navegacion" value="&paginaref=#form.pagina#"/>
		  </cfinvoke> 
	</td>
  </tr>
</cfif>  
  <tr>
    <td valign="top">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>