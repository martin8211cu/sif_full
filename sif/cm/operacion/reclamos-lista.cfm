<cf_templateheader title="Reclamos">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reclamos'>
		<cfinclude template="../../portlets/pNavegacionCM.cfm">
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfquery name="rsLista" datasource="#session.DSN#">
						select a.ERid, a.EDRid, a.EDRnumero, a.SNcodigo, c.SNnumero, c.SNnombre, a.EDRfecharec, a.ERobs, a.CMCid, d.CMCnombre
						from EReclamos a
						
						inner join SNegocios c
						on a.Ecodigo=c.Ecodigo
						   and a.SNcodigo=c.SNcodigo
						
						inner join CMCompradores d
						on a.CMCid=d.CMCid
						and a.Ecodigo=d.Ecodigo
						
						where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						<cfif isdefined("session.compras.comprador") and len(trim(session.compras.comprador))>
							and a.CMCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.compras.comprador#">
						</cfif>
					</cfquery>

					<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<!---<cfinvokeargument name="cortes" value="CMTSdescripcion"/>--->
						<cfinvokeargument name="desplegar" value="EDRnumero, SNnumero, SNnombre, EDRfecharec"/>
						<cfinvokeargument name="etiquetas" value="N&uacute;mero, N&uacute;mero proveedor, Nombre proveedor, Fecha del reclamo"/>
						<cfinvokeargument name="formatos" value="V, V, V, D"/>
						<cfinvokeargument name="align" value="left, left, left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="reclamos.cfm"/>
						<cfinvokeargument name="botones" value="Regresar"/>
						<!---<cfinvokeargument name="radios" value="S"/>--->
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" value="EDRid"/>
						<!---<cfinvokeargument name="navegacion" value="#navegacion#"/>--->
					</cfinvoke>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript1.2" type="text/javascript">
	var directa = new Object();

	function funcRegresar(){
		document.lista.action = '../MenuCM.cfm';
	}

/*
	function funcAplicar(){
		var continuar = false;
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				continuar = document.lista.chk.checked;
			}
			else {
				for (var k = 0; k < document.lista.chk.length; k++) {
					if (document.lista.chk[k].checked) {
						continuar = true;
						break;
					}
				}
			}
			if (!continuar) { alert('Debe seleccionar una solicitud de compra'); }
		}
		else {
			alert('No existen solicitudes de compra')
		}

		if ( continuar ){
			document.lista.submit();
		}	

		return continuar;
	}
*/	
</script>

