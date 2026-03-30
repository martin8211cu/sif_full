<cfif isdefined("url.Socio") and len(trim(#url.Socio#))>
<cfquery datasource="#session.dsn#" name="DatoSocio">
		select SNnumero,SNnombre
		from SNegocios
		where SNid  in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#url.Socio#">)
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
