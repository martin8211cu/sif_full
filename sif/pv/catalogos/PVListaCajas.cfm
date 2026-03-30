<cfif isdefined("Url.FP_FAM01CODD") and not isdefined("Form.FP_FAM01CODD")>
	<cfparam name="Form.FP_FAM01CODD" default="#Url.FP_FAM01CODD#">
</cfif>

<cfif isdefined("Url.FP_FAM01DES") and not isdefined("Form.FP_FAM01DES")>
	<cfparam name="Form.FP_FAM01DES" default="#Url.FP_FAM01DES#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.FP_FAM01CODD") and Len(Trim(Form.FP_FAM01CODD)) NEQ 0>
	<cfset filtro = filtro & " and upper(FAM01CODD) like '%" & #UCase(Form.FP_FAM01CODD)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM01CODD=" & Form.FP_FAM01CODD>
</cfif>
<cfif isdefined("Form.FP_FAM01DES") and Len(Trim(Form.FP_FAM01DES)) NEQ 0>
 	<cfset filtro = filtro & " and upper(FAM01DES) like '%" & #UCase(Form.FP_FAM01DES)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM01DES=" & Form.FP_FAM01DES>
</cfif>

<cfoutput>
<form name="filtroUsuarios" method="post">
	<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="FP_FAM01CODD" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.FP_FAM01CODD")>#Form.FP_FAM01CODD#</cfif>">
		</td>
	</tr>
	<tr>		
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="FP_FAM01DES" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.FP_FAM01DES")>#Form.FP_FAM01DES#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<!--- Despliega la informacion de las cajas --->
<cfquery name="rsCajas" datasource="#session.dsn#">
Select Ecodigo, FAM01COD, FAM01CODD, FAM01DES, FAM01TIP
from FAM001
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> #Preservesinglequotes(filtro)#
Order by FAM01CODD
</cfquery>

<cfset despl = "FAM01CODD, FAM01DES, FAM01TIP">
<cfset alg = "left,left,left">
<cfset etq = "C&oacute;digo,Descripci&oacute;n,Tipo">
<cfset frm = "V, V, V">

<cfinvoke 
component="sif.Componentes.pListas"
method="pListaQuery"
returnvariable="pListaRet">
<cfinvokeargument name="query" value="#rsCajas#"/>
<cfinvokeargument name="desplegar" value="#despl#"/>
<cfinvokeargument name="etiquetas" value="#etq#"/>
<cfinvokeargument name="formatos" value="#frm#"/>
<cfinvokeargument name="align" value="#alg#"/>
<cfinvokeargument name="ajustar" value="S"/>
<cfinvokeargument name="irA" value="PVUsariosporCaja.cfm"/>
<cfinvokeargument name="showEmptyListMsg" value="true"/>
<cfinvokeargument name="navegacion" value="#navegacion#"/>
<cfinvokeargument name="keys" value="FAM01CODD, FAM01DES, FAM01TIP"/>
<cfinvokeargument name="maxrows" value="15"/>
</cfinvoke>	 