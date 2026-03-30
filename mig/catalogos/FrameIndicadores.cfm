<cfoutput>
<cfquery datasource="#session.DSN#" name="rsMetricas">
	select distinct c.MIGMid,c.MIGMnombre,a.MIGMtipodetalle
	from MIGFiltrosindicadores a  
		inner join MIGMetricas c
		on c.MIGMid = a.MIGMid
		and c.Ecodigo = a.Ecodigo
		
	where a.MIGMidindicador = #url.MIGMID#
	and a.Ecodigo = #session.Ecodigo#
</cfquery>

	<cfloop query="rsMetricas">
		<cfset MIGMid_actual = rsMetricas.MIGMid>
		<cfset MIGMnombre_actual = rsMetricas.MIGMnombre>
		<cfset tipodetalle = rsMetricas.MIGMtipodetalle>
		
			<cfif tipodetalle is 'D'>
				<cfquery datasource="#session.DSN#" name="rsDatosSelect">
					select a.MIGMdetalleid as id, b.DeptoCodigo as codigo,b.Ddescripcion as descripcion,c.MIGMnombre
					from MIGFiltrosindicadores a  
						
						inner join Departamentos b
						on b.Dcodigo = a.MIGMdetalleid
						and a.Ecodigo = b.Ecodigo
						
						inner join MIGMetricas c
						on c.MIGMid = a.MIGMid
						and c.Ecodigo = a.Ecodigo
						
					where MIGMidindicador = #url.MIGMID#
					and a.MIGMid = #MIGMid_actual#
					and a.Ecodigo = #session.Ecodigo#
				</cfquery>
				
			<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
			
			<cfelseif tipodetalle is 'C'>
				<cfquery datasource="#session.DSN#" name="rsDatosSelect">
					select a.MIGMdetalleid as id, b.MIGCuecodigo as codigo,b.MIGCuedescripcion as descripcion,c.MIGMnombre
					from MIGFiltrosindicadores a  
						inner join MIGCuentas b
						on b.MIGCueid = a.MIGMdetalleid
						and a.Ecodigo = b.Ecodigo
						
						inner join MIGMetricas c
						on c.MIGMid = a.MIGMid
						and c.Ecodigo = a.Ecodigo
						
					where a.MIGMidindicador = #url.MIGMID#
					and a.MIGMid = #MIGMid_actual#
					and a.Ecodigo = #session.Ecodigo#
				</cfquery>
				<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
			<cfelseif tipodetalle is 'P'>
				<cfquery datasource="#session.DSN#" name="rsDatosSelect">
					select a.MIGMdetalleid as id, b.MIGProcodigo as codigo,b.MIGPronombre as descripcion,c.MIGMnombre
					from MIGFiltrosindicadores a  
						inner join MIGProductos b
						on b.MIGProid = a.MIGMdetalleid
						and a.Ecodigo = b.Ecodigo
					
					inner join MIGMetricas c
						on c.MIGMid = a.MIGMid
						and c.Ecodigo = a.Ecodigo
						
					where MIGMidindicador = #url.MIGMID#
					and a.MIGMid = #MIGMid_actual#
					and a.Ecodigo = #session.Ecodigo#
				</cfquery>
				<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
			</cfif>

		<table align="center" border="0">
		
		<tr>
			<td valign="top" width="150">
				#MIGMnombre_actual#
			</td>
			<td valign="top" width="100">
				<cfif tipodetalle EQ 'D'>DEPARTAMENTO</cfif>
				<cfif tipodetalle EQ 'C'>CUENTA</cfif>
				<cfif tipodetalle EQ 'P'>PRODUCTO</cfif>
			</td>
			<td>
				<table align="left" border="0" width="100%">
					<cfloop query="rsDatosSelect">
						<tr><td width="200">#rsDatosSelect.codigo#-#rsDatosSelect.descripcion#</td>
						<td><img src="../imagenes/Borrar01_S.gif" onclick="javascript: BorrarDetalle(#url.MIGMID#,#rsDatosSelect.id#,#MIGMid_actual#)"/></td>
						</tr>
					</cfloop>
				</table>
			</td>
		</tr>
		</table>
	</cfloop>	
<script>
	function BorrarDetalle(MIGMIDpadre,detalleId,MIGMidhijo){
		if(confirm('Esta seguro que desea borrar el detalle?')){
			document.getElementById('BajaFiltrosIndicadores').value = true;
 			document.getElementById('MIGMdetalleid').value = detalleId;
			document.getElementById('MIGMidPadre').value = MIGMIDpadre;
			document.getElementById('MIGMidHijo').value = MIGMidhijo;
			document.FORMFILTROS.submit();

		}
	}
</script>
</cfoutput>