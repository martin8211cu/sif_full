<cfif isdefined("LvarPorCFuncional")>
	<cfset LvarTipoDocumento = 5>
	<cfset LvarSufijoForm = "CF">
   	<cfif #LvarFiltroPorUsuario#>
		<cfset LvarSufijoForm = "CFusuario">
    </cfif>
	<cf_SP_lista tipo="5" FiltarxUsuario="#LvarFiltroPorUsuario#" irA="solicitudesManual#LvarSufijoForm#.cfm">
<cfelse>
	<cfset LvarTipoDocumento = 0>
	<cfset LvarSufijoForm = "">
	<cf_SP_lista tipo="0" irA="solicitudesManual.cfm">
</cfif>

<cfinvoke key="BTN_Nuevo" default="Nuevo"	returnvariable="BTN_Nuevo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="/sif/generales.xml"/>

<cfif NOT isdefined("form.chkCancelados")>
	<table width="100%">
		<tr>		  
			<td align="center">		
				<form name="formRedirec" method="post" action="<cfoutput>solicitudesManual#LvarSufijoForm#.cfm</cfoutput>" style="margin: '0' ">
				  <input name="btnNuevo" type="submit" value="<cfoutput>#BTN_Nuevo#</cfoutput>" tabindex="2">
				</form>  
			</td>
		</tr>		  
	</table>
</cfif>

