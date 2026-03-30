<cfquery name="rs_usuarios" datasource="asp">
	select Usucodigo
	from Usuario u
	inner join DatosPersonales dp
	on dp.datos_personales=u.datos_personales
	where u.datos_personales in ( select datos_personales from ReqInfo )
</cfquery>
<cfset usuarios = valuelist(rs_usuarios.Usucodigo) >

<cfsavecontent variable="nohaydatos">
<table align="center" width="99%" cellpadding="2" cellspacing="0">
	<tr class="tituloListas" style="padding:3px; ">
		<td width="1%"></td>
		<td style="padding:3px; "><strong>Empresa</strong></td>
		<td style="padding:3px; "><strong>Solicitado por</strong></td>
	</tr>
	<tr>
		<td colspan="3" align="center"><strong>--- No se encontraron datos ---</strong></td>
	</tr>
</table>	
</cfsavecontent>


<table align="center" width="99%" cellpadding="2" cellspacing="0">
	<tr><td align="center"><strong><font size="2">Eliminaci&oacute;n de datos de Demos</font></strong></td></tr>
</table>

<cfif len(trim(usuarios))>
	<cfquery name="data" datasource="asp">
		select distinct
			e.Ecodigo,
			e.CEcodigo,
			e.Enombre, upper(e.Enombre) as Enombre_upper,
			e.Ereferencia,
			c.Ccache as cache,
			dp.Pnombre, dp.Papellido1, dp.Papellido2
			,up.Usucodigo
		from vUsuarioProcesos up, Empresa e, Caches c, Usuario u, DatosPersonales dp
		where up.Usucodigo in (#usuarios#)
		  and up.Ecodigo = e.Ecodigo
		  and c.Cid = e.Cid
		  and upper(e.Enombre) like '%DEMO%'
		  and e.Ereferencia <> 28
		  and u.Usucodigo=up.Usucodigo	
		  and dp.datos_personales=u.datos_personales
		order by upper( e.Enombre )
	</cfquery>

	<cfset hayDatos = false >
	<cfset entro = false >
	<cfif data.recordcount gt 0 >
		<cfset entro = true >
		<form name="form1" action="eliminar-demos-sql.cfm" method="post" onSubmit="return validar(this);" style="margin:0; ">
		<table align="center" width="99%" cellpadding="2" cellspacing="0">
			<tr class="tituloListas" style="padding:3px; ">
				<td width="1%"></td>
				<td style="padding:3px; "><strong>Empresa</strong></td>
				<td style="padding:3px; "><strong>Solicitado por</strong></td>
			</tr>

			<cfoutput query="data" >
				<cfquery name="existe" datasource="#data.cache#">
					select 1 from Empresas where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#data.Ereferencia#">
				</cfquery>
				<cfif existe.recordcount gt 0 >
					<cfset hayDatos = true >
					<tr class="<cfif data.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" onmouseover="this.className='listaParSel';" onmouseout="<cfif data.currentrow mod 2>this.className='listaPar';<cfelse>this.className='listaNon';</cfif>"  >
						<td><input type="checkbox" name="chk" value="#data.Ereferencia#|#data.Ecodigo#|#data.cache#|#data.CEcodigo#|#data.Usucodigo#"></td>
						<td>#data.Enombre# (#data.Ereferencia# - #data.cache#)</td>
						<td>#data.Pnombre# #data.Papellido1# #data.Papellido2#</td>
					</tr>
				</cfif>
			</cfoutput>
			
			<tr><td></td></tr>
			<cfif not hayDatos >
				<tr>
					<td colspan="3" align="center"><strong>--- No se encontraron datos ---</strong></td>
				</tr>
			<cfelse>
				<tr><td colspan="5" align="center">
					<input type="submit" name="autorizar" value="Eliminar">
				</td></tr>
			</cfif>
			<tr><td></td></tr>
		</table>
		</form>
		<script language="javascript1.2" type="text/javascript">
			function validar(f){
				var continuar = false;
		
				if (f.chk) {
					if (f.chk.value) {
						continuar = f.chk.checked;
						solID = f.chk.value;
					}
					else {
						for (var k = 0; k < f.chk.length; k++) {
							if (f.chk[k].checked) {
								continuar = true;
								break;
							}
						}
					}
					if (!continuar) { alert('Se presentaron los siguientes errores: \n  - Debe seleccionar al menos un registro.'); }
				}
				else {
					alert('No existen registros para procesar')
				}
		
				return continuar;
			}
		</script>
	<cfelse>
		<cfif (not haydatos) and (not entro) ><cfoutput>#nohaydatos#</cfoutput></cfif>

	</cfif>
<cfelse>
	<cfoutput>#nohaydatos#</cfoutput>
</cfif>