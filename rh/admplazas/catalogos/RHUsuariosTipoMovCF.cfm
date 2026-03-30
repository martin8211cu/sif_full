
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="45%">
		<cfset navegacion = "&tab=2">
		<cfif isdefined("Form.RHTMid") and Len(Trim(Form.RHTMid)) NEQ 0>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHTMid=" & Form.RHTMid>
		</cfif>	
		<cfinvoke 
			component="rh.Componentes.pListas" 
			method="pListaRH"
			returnvariable="rsLista"
			columnas="RHUTMlinea
					, RHTMid
					, utm.Usucodigo
					, Pid
					, (dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' '  #LvarCNCT#  dp.Papellido2) as Nombre
					, 2 as tab"
			etiquetas="Identificaci&oacute;n,Usuario"
			tabla="RHUsuariosTipoMovCF utm
					inner join Usuario u
						on u.Usucodigo=utm.Usucodigo
							and u.Uestado = 1 
							and u.Utemporal = 0
					inner join DatosPersonales dp
						on dp.datos_personales =u.datos_personales"
			filtro="Ecodigo=#Session.Ecodigo# and utm.RHTMid=#form.RHTMid# order by Nombre"
			mostrar_filtro="true"
			filtrar_automatico="true"
			desplegar="Pid,Nombre"
			filtrar_por="Pid,dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' '  #LvarCNCT#  dp.Papellido2"
			align="left,left"
			formatos="S,S"
			keys="RHUTMlinea"
			navegacion="#navegacion#"
			formName="listaUtipoMov"
			ira="RHtabsTipoMov.cfm"
		/>			
	
	</td>
	<td width="10%">&nbsp;</td>	
    <td width="45%"><cfinclude template="RHUsuariosTipoMovCF-form.cfm"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  <td>&nbsp;</td>
  </tr>
</table>

<script language="javascript" type="text/javascript">
	function funcFiltrar(){
		document.listaUtipoMov.RHTMID.value = "<cfoutput>#form.RHTMid#</cfoutput>";
		document.listaUtipoMov.TAB.value = "2";		
		return true;
	}
</script>
