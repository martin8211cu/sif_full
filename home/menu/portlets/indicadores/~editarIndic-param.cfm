<cf_template>
<cf_templatearea name="title">Inicio</cf_templatearea>
<cf_templatearea name="body">

	<cfquery name="rsIndiParam" datasource="asp">
		Select i.indicador,etiqueta, ip.parametro,valor,obligatorio
		from Indicador i
			inner join IndicadorParam ip
				on ip.indicador=i.indicador
			left outer join IndicadorArgumento ia
				on i.indicador=ia.indicador
					and ip.parametro=ia.parametro
					and ia.Usucodigo=27
		where i.indicador=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.indicador#">
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
		<input type="hidden" name="indicador" value="#form.indicador#">
		<input type="hidden" name="accion" value="insertParam">		
		<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="22%">&nbsp;</td>
			<td width="66%">&nbsp;</td>
			<td width="12%">&nbsp;</td>
		  </tr>	
		  <tr>
			<td colspan="3" class="tituloProceso"><strong>Indicador</strong></td>
		  </tr>	  
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>	
		  <tr bgcolor="#CCCCCC">
			<td><strong>Parametro</strong></td>
			<td><strong>Valor</strong></td>
			<td>&nbsp;</td>
		  </tr>
		  <cfif isdefined('rsIndiParam') and rsIndiParam.recordCount GT 0>
				<cfoutput query="rsIndiParam">
				  <cfset LvarListaNon = (CurrentRow MOD 2)>			
				  <tr class=<cfif LvarListaNon>'listaNon'<cfelse>'listaPar'</cfif>>
					<td>#rsIndiParam.etiqueta#</td>
					<td>
						<input type="text" name="valor" value="">
					</td>
					<td align="center">&nbsp;</td>
				  </tr>
				</cfoutput>
		  </cfif>
		  <tr>
			<td colspan="3" align="center">
				<input type="submit" name="btnAgregar" value="Agregar">
			</td>
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
</script>