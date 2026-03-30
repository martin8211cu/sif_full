<cfparam name="URL.DVTcodigo"  default="">
<form name="form1" action="DatosVariablesConfig-sql.cfm" method="post">
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
		<cfif isdefined('url.DVTcodigo') and len(trim(url.DVTcodigo)) GT 0>
			<tr>
				<td><input name="TipoConfig" type="radio" value="DatoVariable" <cfif URL.TipoConfig EQ 'DatoVariable'> checked="true" </cfif> onclick="Reload(this);"/>
					<strong>Configurar Datos Variables</strong></td>
				<td><input name="TipoConfig" type="radio" value="Evento" <cfif URL.TipoConfig EQ 'Evento'> checked="true" </cfif> onclick="Reload(this);"/>
					<strong>Configurar Eventos</strong></td>
			</tr>
		</cfif>
			<tr>
				<td colspan="2">
				<cfif not isdefined('url.DVTcodigo') or len(trim(url.DVTcodigo)) EQ 0>
					<strong>Selecciones el tipo de Tipificación que desea Configurar</strong>
				<cfelse>
					<cfif ListFind('AF,AF_CATEGOR,AF_CLASIFI', url.DVTcodigo)>
						<cfinclude template="DatosVariablesConfig-AF.cfm">
					<cfelse>
						<cfif URL.TipoConfig EQ 'DatoVariable'>
							Tipificación no Implementada
						<cfelse>
							Tipificación no Implementada
						</cfif>
						
					</cfif>
				</cfif>
			</td>
		</tr>
	</table>
<script language="javascript1.2" type="text/javascript">
	function Reload(TipoConfig)
	{
		location.href='DatosVariablesConfig.cfm?TipoConfig='+TipoConfig.value+'&DVTcodigo=<cfoutput>#url.DVTcodigo#</cfoutput>';
	}
</script>
</form>