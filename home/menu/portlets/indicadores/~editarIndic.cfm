<cf_template>
<cf_templatearea name="title">Seleccionar Indicadores</cf_templatearea>
<cf_templatearea name="body">

	<cfquery name="rsIndi" datasource="asp">
		Select iu.indicador, nombre_indicador, iu.posicion
		from IndicadorUsuario iu
			inner join Indicador i
				on i.indicador=iu.indicador
		where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>			
	
	<cfif isdefined('rsIndi') and rsIndi.recordCount EQ 0>
		<cfquery name="rsIndi" datasource="asp">
			insert IndicadorUsuario (Usucodigo, indicador, posicion, BMfecha, BMUsucodigo)
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					, indicador
					, posicion
					, BMfecha
					, BMUsucodigo
			from Indicador
			where es_default=1
		</cfquery>

		<cfquery name="rsIndi" datasource="asp">
			Select iu.indicador, nombre_indicador, iu.posicion
			from IndicadorUsuario iu
				inner join Indicador i
					on i.indicador=iu.indicador
			where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		</cfquery>		
	</cfif>
	
	<cfquery name="rsIndicadores" datasource="asp">
		Select indicador,nombre_indicador,posicion,i.BMfecha,i.SScodigo,i.SMcodigo,SSdescripcion,SMdescripcion
		from Indicador i
			inner join SSistemas s
				on s.SScodigo=i.SScodigo
			inner join SModulos m
				on m.SScodigo=s.SScodigo
					and m.SMcodigo=i.SMcodigo
		where indicador not in (
				Select distinct indicador
				from IndicadorUsuario
				where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
		order by SScodigo,SMcodigo,posicion
	</cfquery> 

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="1%" valign="top">
		<cf_web_portlet titulo="Agenda" skin="portlet" width="164">
			<form action="../agenda/agenda.cfm" name="calform">
			<cf_calendario form="calform" includeForm="no" name="fecha" fontSize="10" onChange="document.getElementById('pendientes').src='/cfmx/home/menu/portlets/agenda/lista_hoy-form.cfm?fecha='+escape(dmy)">
			</form>
		</cf_web_portlet>
		<br>
		<cf_web_portlet titulo="Pendientes para hoy" skin="portlet" width="164">
			<cfinclude template="../agenda/lista-hoy.cfm">
		</cf_web_portlet>	
	</td>
    <td width="99%" valign="top">
	<form name="form1" method="post" action="editarIndic-sql.cfm">
		<input type="hidden" name="codIndic" value="*">
		<input type="hidden" name="accion" value="*">		
		<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="22%">&nbsp;</td>
			<td width="66%">&nbsp;</td>
			<td width="12%">&nbsp;</td>
		  </tr>	
		  <tr>
			<td colspan="3" class="tituloProceso"><strong>Indicadores Seleccionados </strong></td>
		  </tr>	  
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>	

		  <tr>
			<td colspan="3">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<input type="text" align="left" readonly="true" name="posicion" value="" class="cajasinbordeb">
						</td>
						<td>
							<input type="hidden" name="indicador" value="">
							<select name="CBindicador" onChange="javascript: cambioIndicador(this.value);">
								<cfif isdefined('rsIndicadores') and rsIndicadores.recordCount GT 0>
									<cfoutput query="rsIndicadores" group="SMcodigo">
										<optgroup label="#trim(SSdescripcion)# / #trim(SMdescripcion)#">
											<cfoutput>
												<option value="#trim(indicador)#~#posicion#">#nombre_indicador#</option>
											</cfoutput>
										</optgroup>
									</cfoutput>
								</cfif>
							</select>
						</td>
						<td align="center">
							<input type="button" name="btnAgregar" value="Agregar" onClick="javascript: agregar();">
						</td>

					</tr>
				</table>
			</td>
		  </tr>

		  <tr bgcolor="#CCCCCC">
			<td><strong>Posici&oacute;n</strong></td>
			<td><strong>Indicador</strong></td>
			<td>&nbsp;</td>
		  </tr>
			<cfoutput query="rsIndi">
			  <cfset LvarListaNon = (CurrentRow MOD 2)>			
			  <tr class=<cfif LvarListaNon>'listaNon'<cfelse>'listaPar'</cfif>>
				<td>#rsIndi.posicion#</td>
				<td>#rsIndi.nombre_indicador#</td>
				<td align="center">
					<a href="javascript:eliminar('#rsIndi.indicador#')">
						<img border="0" src="../../../imagenes/Borrar01_S.gif" alt="Eliminar Indicador">
					</a>			
				</td>
			  </tr>
			</cfoutput>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>		  
		</table>
	</form>	
	</td>
  </tr>
</table>


</cf_templatearea>
</cf_template>

<script language="javascript" type="text/javascript">
	function eliminar(cod){
		if ( confirm('Desea eliminar el indicador ?') ) {
			document.form1.accion.value = 'delete';
			document.form1.codIndic.value = cod;
			document.form1.submit();
		}
	}
	
	function agregar(){
		if(document.form1.indicador.value != ''){
			document.form1.accion.value = 'insert';		
			document.form1.submit();
		}else{
			alert('Error, el campo Tipos de Solicitud es requerido')
		}
	}	
	
	function cambioIndicador(par){
		if(par != ''){
			var p = par.split("~");
				document.form1.indicador.value = p[0];
				document.form1.posicion.value = p[1];		
		}else{
			document.form1.indicador.value = '';
			document.form1.posicion.value = '';
		}
	}
	cambioIndicador(document.form1.CBindicador.value);
</script>