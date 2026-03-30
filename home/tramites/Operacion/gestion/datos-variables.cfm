<cfquery name="datorequisito" datasource="#session.tramites.dsn#" >
	select dr.id_dato, dr.id_requisito, dr.codigo_dato, dr.nombre_dato, dr.lista_valores, dr.tipo_dato, de.valor
	from TPDatoRequisito dr
	
	left outer join TPDatoExpediente de
	on dr.id_dato=de.id_dato
	
	where dr.id_requisito in ( select id_requisito 
							from TPRReqTramite 
							where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#"> )
</cfquery>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<form name="form3" action="/cfmx/home/tramites/Operacion/gestion/datos-variables-sql.cfm" style="margin:0;" method="post">
	<cfoutput>
	<input type="hidden" name="loc" value="gestion">
	<input type="hidden" name="id_tramite" value="#url.id_tramite#">
	<input type="hidden" name="id_persona" value="#data.id_persona#">
	</cfoutput>
	<cfset requisitos = '' >
	
	<table width="100%" cellpadding="2" cellspacing="0">
		<cfoutput query="datorequisito">
			<input type="hidden" name="id_dato" value="#datorequisito.id_dato#">
			<input type="hidden" name="id_requisito_#datorequisito.id_dato#" value="#datorequisito.id_requisito#">
			<cfif listfind(requisitos,  datorequisito.id_requisito) eq 0>
				<cfset requisitos = listappend(requisitos, datorequisito.id_requisito ) >
			</cfif>
			
			<input type="hidden" name="tipo_#datorequisito.id_dato#" value="#datorequisito.tipo_dato#">
			<tr>
				<td width="1%" nowrap><strong>#datorequisito.nombre_dato#</strong></td>
				<td>
					<!--- check --->
					<cfif datorequisito.tipo_dato eq 'B' >
						<input type="checkbox" name="dato_#datorequisito.id_dato#" <cfif len(trim(valor)) and valor eq 1 >checked</cfif> >
					<!--- string --->
					<cfelseif datorequisito.tipo_dato eq 'S' > 
						<cfif len(trim(datorequisito.lista_valores))>
							<select name="dato_#datorequisito.id_dato#">
								<option value="">-seleccionar-</option>
								<cfloop list="#datorequisito.lista_valores#" index="lvalor">
									<option value="#lvalor#" <cfif len(trim(valor)) and valor eq lvalor >selected</cfif> >#lvalor#</option>
								</cfloop>
							</select>
						<cfelse>
							<input type="text" name="dato_#datorequisito.id_dato#" value="#trim(datorequisito.valor)#" size="30" maxlength="100" onFocus="this.select();" >
						</cfif>
					<!--- float, numeric --->
					<cfelse>
						<cfif len(trim(datorequisito.lista_valores))>
							<select name="dato_#datorequisito.id_dato#">
								<option value="">-seleccionar-</option>
								<cfloop list="#datorequisito.lista_valores#" index="valor">
									<option value="#valor#" <cfif len(trim(valor)) and valor eq lvalor >selected</cfif>>#valor#</option>
								</cfloop>
							</select>
						<cfelse>
							<input type="text" name="dato_#datorequisito.id_dato#" value="#trim(datorequisito.valor)#" size="12" maxlength="12" style="text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
						</cfif>
					</cfif>
				</td>
			</tr>
		</cfoutput>
		<tr><td colspan="2"><input type="submit" name="Guardar" value="Guardar"></td></tr>
	</table>
	<input type="hidden" name="id_requisito" value="<cfoutput>#requisitos#</cfoutput>">
</form>