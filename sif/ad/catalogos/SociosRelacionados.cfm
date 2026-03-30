<cfif isdefined("url.Socio") and len(trim(#url.Socio#))>
<cfquery datasource="#session.dsn#" name="DatoSocio">
	select 1, 	<cf_dbfunction name="concat" args="'<strong>',SNnumero,'</strong>'"> as SNnumero,
				<cf_dbfunction name="concat" args="'<strong>',SNnombre,'</strong>'"> as SNnombre
	  from SNegocios
	 where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Socio#">
UNION
	select 2, SNnumero,SNnombre
	  from SNegocios
	 where SNidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Socio#">
	order by 1
</cfquery> 
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
				<cfinvokeargument name="query" 				value="#DatoSocio#"/>
				<cfinvokeargument name="desplegar" 			value="SNnumero,SNnombre"/>
				<cfinvokeargument name="etiquetas" 			value="Código,Socio"/>
				<cfinvokeargument name="formatos" 			value="S,S"/>
				<cfinvokeargument name="align" 				value="left,left"/>
				<cfinvokeargument name="ira" 				value=""/>
				</cfinvoke>	
</cfif>
<table align="center" border="0">
<tr>
 <td>
   <input type="button" value="Cerrar" onclick="window.close();"/> 
  </td>
</tr>
</table>
