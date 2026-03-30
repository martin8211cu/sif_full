<cfset LB_title="Desactualizar Masivo">
<title><cfoutput>#LB_title#</cfoutput></title>
<cf_templatecss>
<cf_web_portlet_start titulo="#LB_title#">
  <cfif isdefined("btnDesactualizar")>
	<!--------MESE---------->
	<cfquery name="rsMeses" datasource="#session.dsn#">
			select VSvalor as value, VSdesc as description
			from VSidioma vs
				inner join Idiomas id
				on id.Iid = vs.Iid
				and id.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Idioma#">
				AND  VSvalor  =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.GATmes#">
			where VSgrupo = 1
			order by 1
		</cfquery>
	<!-------CONCEPTOS-------->
	  <cfquery name="rsConceptos" datasource="#session.dsn#">
			select Cconcepto as value, Cdescripcion as description, 0 as orden
			from ConceptoContableE
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			AND Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">
			order by 3,2
	  </cfquery>
	<!------DATOS FILTRO--->
	  <cfquery name="rsDataFiltro" datasource="#session.dsn#">
		select ID 
		from GATransacciones
		where Ecodigo=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and GATperiodo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATPeriodo#">
		and GATmes=	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATmes#">
		and Cconcepto=	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">
		and Edocumento=	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Documento#">
	  </cfquery>
	  <!------DATOS COMPLETOS(GATestado = 1)CONCILIADOS(GATestado= 2)--->
	   <cfquery name="rsDataCon" datasource="#session.dsn#">
		select ID
		from GATransacciones
		where Ecodigo=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and GATperiodo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATPeriodo#">
		and GATmes=	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATmes#">
		and Cconcepto=	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">
		and Edocumento=	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Documento#">
		and GATestado  in (1,2)
	  </cfquery>
	  <!------DATOS ACTUALIZADOS--->
	   <cfquery name="rsDataActualizados" datasource="#session.dsn#">
		select * 
		from GATransacciones
		where Ecodigo=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and GATperiodo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATPeriodo#">
		and GATmes=	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATmes#">
		and Cconcepto=	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">
		and Edocumento=	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Documento#">
		and GATestado in (1,2)
		and OcodigoAnt is not null
	  </cfquery>
<cfoutput>
	 <form action="Desactualizar.cfm" method="post" name="form1">
		<table width="100%" border="0">		
			<tr>
				<td colspan="2" align="center"><strong>Resultado del proceso de Desactualizar en forma masiva</strong></td>
			</tr>
			<tr>
				<td width="10%"><strong>Periodo:&nbsp;&nbsp;</strong></td>
				<td width="90%">#Form.GATperiodo#</td>
			</tr>
			<tr>
				<td><strong>Mes:&nbsp;&nbsp;</strong></td>
				<td>#rsMeses.description#</td>
			</tr>
			<tr>
				<td><strong>Concepto:&nbsp;&nbsp;</strong></td>
				<td>#rsConceptos.description#</td>
			</tr>
			<tr>
				<td><strong>Documento:&nbsp;&nbsp;</strong></td>
				<td>#form.Documento#</td>
			</tr>	
			<tr>
				<td colspan="2"><hr></td>
			</tr>
		<cfif rsDataFiltro.recordcount LT 1>
			<tr>
				<td colspan="2"  align="center"><font color="##FF0000">No hay información que cumpla con estos filtros</font></td>
			</tr>	
		<cfelseif rsDataCon.recordcount LT 1>
			<tr>
				<td colspan="2"  align="center"><font color="##FF0000">Los Transacciones encontradas, aun no se encuentran Conciliadas o Completas</font></td>
			</tr>	
		<cfelseif rsDataActualizados.recordcount LT 1>
			<tr>
			
				<td colspan="2"  align="center"><font color="##FF0000">Los Transacciones encontradas, no fueron Actualizada o tenia la misma oficina</font></td>
			</tr>	
		<cfelse>
							<!----*******************PROCESO DE DESACTUALIZACION*******************--->
<!---Se reversa la Oficina tanto a las conciliadas, como a las completas--->				
				<cfquery  datasource="#session.dsn#">
					Update GATransacciones
					set Ocodigo= OcodigoAnt,
					OcodigoAnt = null
					where Ecodigo=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and GATperiodo=	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATPeriodo#">
					and GATmes=	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATmes#">
					and Cconcepto=	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">
					and Edocumento=	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Documento#">
					and GATestado in (1,2)
					and OcodigoAnt is not null
				</cfquery>
<!---Unicamente cambia el estado a las conciliadas, las completas quedan igual--->
				<cfquery  datasource="#session.dsn#">
					Update GATransacciones
					set GATestado= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					where Ecodigo=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and GATperiodo=	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATPeriodo#">
					and GATmes=	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATmes#">
					and Cconcepto=  <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">
					and Edocumento=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Documento#">
					and GATestado= <cfqueryparam cfsqltype="cf_sql_integer" value="2"> 
				</cfquery>
				 <tr><td colspan="2" >					
					<font color="black">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#rsDataActualizados.recordcount# Desactualizadas.
					</font>
				 </td></tr> 
				<tr><td>
					<font color="navy">
						El Asiento ha sido Desconciliado!
					</font>
				</td></tr>
			
		</cfif>
			<tr>
			<td colspan="2" align="right">
				<input name="btnRegresarDOWN" type="submit" value="Regresar" tabindex="2">
				<input name="btnCerrarDOWN" type="button" value="Cerrar" onClick="javascript:cerrar();" tabindex="2">	
			</td>
			</tr>
	</table>
</form>
</cfoutput>
<cfelse>
<cfoutput>
	<form action="Desactualizar.cfm" method="post" name="form1">
		<cfif isdefined("form.GATPeriodo") and len(trim(form.GATPeriodo))> 
			<input name="GATPeriodo" value="#form.GATPeriodo#" type="hidden">
		</cfif>				
		<cfif isdefined("form.GATMes") and len(trim(form.GATMes))>
			<input name="GATMes" value="#form.GATMes#" type="hidden">
		</cfif>	
		<cfif isdefined("form.Cconcepto") and len(trim(form.Cconcepto))>
			<input name="Cconcepto" value="#form.Cconcepto#" type="hidden">
		</cfif>
		<cfif isdefined("form.Documento") and len(trim(form.Documento))>		
			<input name="Documento" value="#form.Documento#" type="hidden">
		</cfif>
	</form>

<html><head></head><body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body></html>
</cfoutput>
</cfif>
	<script language="javascript" type="text/javascript">
		function cerrar(){window.close();window.opener.location.reload();}	
	</script>
<cf_web_portlet_end>
