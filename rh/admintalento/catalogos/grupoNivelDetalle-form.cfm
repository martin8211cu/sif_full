	<!----
	<cfquery name="rs_sumapeso" datasource="#session.DSN#">
		select coalesce(sum(RHDGNpeso), 0) as peso
		from RHDGrupoNivel
		where RHGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGNid#">
	</cfquery>
	---->
	<table width="95%" align="center" cellpadding="2" style="border:1px #CCCCCC solid;">
		<tr><td colspan="2" align="center" class="tituloListas">
		
	    <cf_translate key="LB_Detalle_de_Grupo_de_Nivel" >Detalle de Grupo de Nivel</cf_translate></td></tr>
	
	<cfset dmodo = 'ALTA'>
	<cfif isdefined("url.RHDGNid") and len(trim(RHDGNid))>
		<cfset form.RHDGNid = url.RHDGNid >
	</cfif>
	<cfif isdefined("form.RHDGNid") and len(trim(form.RHDGNid))>
		<cfset dmodo = 'CAMBIO'>
		<cfquery name="rs_detalle" datasource="#session.DSN#">
			select a.RHDGNid, a.RHDGNcodigo, a.RHDGNdescripcion, a.RHDGNpeso
			from RHDGrupoNivel a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a.RHDGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDGNid#">
			order by a.RHDGNpeso 
		</cfquery>

	</cfif>

	<cfoutput>
	<form name="form2" method="post" action="grupoNivelDetalle-sql.cfm" style="margin:0;" ><!-----onsubmit="javascript: return validar_peso();"---->
	<tr><td>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td>#LB_codigo#:</td>
			<td><input type="text" tabindex="4" name="RHDGNcodigo" value="<cfif dmodo neq 'ALTA'>#trim(rs_detalle.RHDGNcodigo)#</cfif>" size="12" maxlength="10" onclick="javascript: this.select();" /></td>
		</tr>
		<tr>
			<td>#LB_descripcion#:</td>
			<td><input type="text" tabindex="5" name="RHDGNdescripcion" value="<cfif dmodo neq 'ALTA'>#trim(rs_detalle.RHDGNdescripcion)#</cfif>" size="50" maxlength="60" onclick="javascript: this.select();" /></td>
		</tr>
		
		<tr>
			<td>#LB_Peso#:</td>
			<td>
				<cfset valor = '' >
				<cfif dmodo neq 'ALTA'>
					<cfset valor = LSNumberFormat(rs_detalle.RHDGNpeso, ',9.00') >
				</cfif>
				
				<cf_inputNumber name="RHDGNpeso" value="#valor#" size="6" enteros="3" decimales="2" tabindex="6" >
			</td>
		</tr>
		<tr><td colspan="2"><cf_botones sufijo="Det" modo="#dmodo#" tabindex="7"></td></tr>		
	</table>
	</td></tr>
	
	<cfquery name="rs_listadetalle" datasource="#session.DSN#">
		select a.RHDGNid, a.RHDGNcodigo, a.RHDGNdescripcion, a.RHDGNpeso
		from RHDGrupoNivel a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.RHGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGNid#">
		order by a.RHDGNpeso desc
	</cfquery>
	<tr><td>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr class="tituloListas">
			<td>#LB_Codigo#</td>
			<td>#LB_Descripcion#</td>
			<td align="right">#LB_Peso#</td>
		</tr>
		<cfloop query="rs_listadetalle">
			<tr style="cursor:pointer;" class="<cfif rs_listadetalle.currentrow mod 2 >listaPar<cfelse>listaNon</cfif>" onClick="javascript: document.form2.action=''; document.form2.RHDGNid.value ='#rs_listadetalle.RHDGNid#'; document.form2.submit(); "  onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif rs_listadetalle.currentrow mod 2 >listaPar<cfelse>listaNon</cfif>';" >
				<td>#rs_listadetalle.RHDGNcodigo#</td>
				<td>#rs_listadetalle.RHDGNdescripcion#</td>
				<td align="right">#LSNumberFormat(rs_listadetalle.RHDGNpeso, ',9.00')#</td>
			</tr>
		</cfloop>
		<cfif rs_listadetalle.recordcount eq 0 >
			<tr><td colspan="3" align="center">-<cf_translate key="MSG_NoSeEncontraronRegistros" xmlFile="/rh/generales.xml">No se encontraron registros</cf_translate>-</td></tr>
		</cfif>
	</table>	
	</td></tr>
	
		<input type="hidden" name="RHGNid" value="#rs_data.RHGNid#" />
		<input type="hidden" name="RHDGNid" value="<cfif dmodo neq 'ALTA'>#rs_detalle.RHDGNid#</cfif>" />
	</cfoutput>
	</form>

	<cf_qforms form="form2" objForm="objForm2" >
	<cfoutput>
	<script>
		objForm2.RHDGNcodigo.required = true;
		objForm2.RHDGNcodigo.description = '#LB_codigo#';
		objForm2.RHDGNdescripcion.required = true;
		objForm2.RHDGNdescripcion.description = '#LB_descripcion#';
		objForm2.RHDGNpeso.required = true;
		objForm2.RHDGNpeso.description = '#LB_Peso#';

		function funcBajaDet(){
			if ( confirm('#MSJ_Eliminar#') ){
				objForm2.RHDGNcodigo.required = false;
				objForm2.RHDGNdescripcion.required = false;
				objForm2.RHDGNpeso.required = false;
				return true;
			}
			return false;			
		}				
	</script>
	</cfoutput>	
	</table>
	<!----
	function validar_peso(){
			var peso_bd = parseFloat('#rs_sumapeso.peso#.');
			if ( document.form2.RHDGNpeso.value != '') {
				var peso_dg = parseFloat(document.form2.RHDGNpeso.value);
			}else{
				var peso_dg = 0;
			}	

			if ( peso_bd + peso_dg > 100.0 ){
				alert('#MSJ_Suma#');
				return false;
			}
			return true;
		}
	------>	