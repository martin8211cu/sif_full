<cfif isdefined("url.fFormato") and not isdefined("form.fFormato")>
	<cfset form.fFormato = url.fFormato>
</cfif>
<cfif isdefined("url.fCuenta") and not isdefined("form.fCuenta")>
	<cfset form.fCuenta = url.fCuenta >
</cfif>

<cfoutput>
<form style="margin:0; " action="ccuentas.cfm" name="filtro" method="post">
	<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr>
			<td>Cuenta:&nbsp;</td>
			<td><input type="text" name="fCuenta" size="60" maxlength="80" value="<cfif isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>#form.fCuenta#</cfif>"></td>
			<td>Formato:&nbsp;</td>
			<td><input type="text" name="fFormato" size="60" maxlength="80" value="<cfif isdefined("form.fFormato") and len(trim(form.fFormato)) gt 0>#form.fFormato#</cfif>"></td>
			<td>
				<input type="submit" name="Filtrar" value="Filtrar">
				<input type="hidden" name="WTCid" value="#form.WTCid#">
			</td>
		</tr>
	</table>
</form>

<cfset filtro = ''>
<cfset navegacion = ''>
<cfset filtro = " WTCid=#form.WTCid# " >
<cfset navegacion = "&WTCid=#form.WTCid#">
<cfset aditionalCols = "">

<cfif isdefined("form.fFormato") and len(trim(form.fFormato)) gt 0>
	<cfset filtro = filtro & " and upper(Cformato) like '%#Ucase(form.fFormato)#%' " >
	<cfset navegacion = navegacion & "&fFormato=#form.fFormato#">
	<cfset aditionalCols = aditionalCols & ", '#form.fFormato#' as fFormato">
</cfif>


<cfif isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>
	<cfset filtro = filtro & " and upper(Cdescripcion) like '%#Ucase(form.fCuenta)#%' " >
	<cfset navegacion = navegacion & "&fCuenta=#form.fCuenta#">
	<cfset aditionalCols = aditionalCols & ", '#form.fCuenta#' as fCuenta">
</cfif>

<cfset filtro = filtro & " order by Cformato " >
</cfoutput>

<cfinvoke component="rh.Componentes.pListas" method="pListaRH"
 returnvariable="pLista">
	<cfinvokeargument name="tabla" value="WEContable"/>
	<cfinvokeargument name="columnas" value="WTCid, WECid, Cdescripcion, Cformato #aditionalCols#"/>
	<cfinvokeargument name="desplegar" value="Cdescripcion,Cformato"/>
	<cfinvokeargument name="etiquetas" value="Cuenta,Formato"/>
	<cfinvokeargument name="formatos" value="V,V"/>
	<cfinvokeargument name="filtro" value="#filtro#"/>
	<cfinvokeargument name="align" value="left,left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="Conexion" value="#session.DSN#"/>	
	<cfinvokeargument name="irA" value="ccuentas.cfm"/>
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>	
	<cfinvokeargument name="MaxRows" value="100"/>
	<cfinvokeargument name="Conexion" value="asp"/>
	<cfinvokeargument name="keys" value="WECid"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="debug" value="N"/>
</cfinvoke>	