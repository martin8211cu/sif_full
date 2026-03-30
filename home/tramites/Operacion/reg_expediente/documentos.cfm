<cfquery name="documentos" datasource="#session.tramites.dsn#">
	select  t.id_tipo,
			r.id_registro,
		   	d.BMfechamod as fecha, 
			r.BMfechamod as fechaReg, 
		   	d.nombre_documento,
		   	tc.nombre_campo,
		   	c.valor,
			(p.nombre || ' ' || p.apellido1 || ' ' || p.apellido2) as nombreFunc,
			nombre_ventanilla
	from DDRegistro r	
		inner join DDCampo c
		on c.id_registro=r.id_registro
		
		inner join DDTipo t
		on t.id_tipo=r.id_tipo
		
		inner join DDTipoCampo tc
		on tc.id_tipo=t.id_tipo
		and tc.id_campo=c.id_campo
		
		inner join TPDocumento d
		on d.id_tipo=t.id_tipo
		and d.es_tipoident = <cfqueryparam cfsqltype="cf_sql_bit" value="#modo_ident#">
		
		left outer join TPFuncionario f
			on f.id_funcionario=r.id_funcionario

		inner join TPPersona p
			on p.id_persona=f.id_persona

		left outer join TPVentanilla v
			on v.id_ventanilla=r.id_ventanilla		
	
	where (r.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_persona#">
		or r.id_registro in (
			select x.id_registro
			from DDCampo x
			where x.valor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.identificacion_persona#">
		)
	)
		<cfif isdefined('form.btnFiltrarDocs') and isdefined('form.id_tipo_F') and form.id_tipo_F NEQ '-1'>
			and t.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipo_F#">
		</cfif>
		<cfif isdefined('form.btnFiltrarDocs') and isdefined('form.BMfechamod_F') and form.BMfechamod_F NEQ ''>
			and r.BMfechamod >= <cfqueryparam cfsqltype="cf_sql_timestamp" 	 value="#LSParseDateTime(form.BMfechamod_F)#">
		</cfif>		
	order by id_tipo, fecha
</cfquery>

<cfif isdefined('documentos') and documentos.recordCount GT 0>
	<cfquery name="rsDocs" dbtype="query">
		Select distinct nombre_documento
			, id_tipo
			, fecha
		from documentos
		order by fecha
	</cfquery>
</cfif>
<style type="text/css">
<!--
.style1 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  	<tr>
		<td colspan="5">
			<table width="100%" cellpadding="2" cellspacing="0">
 				<tr>
					<td colspan="4" style="border-top: 1px solid black; " align="center">* Haga clic en una línea para ver el detalle del documento</td>				
				</tr>
 				<cfset band = true>
				
 				<cfif isdefined('documentos') and documentos.recordcount gt 0>
					<cfoutput query="documentos" group="id_tipo">
						<tr bgcolor="##666666">
							<td valign="top" colspan="4"><span class="style1">#documentos.nombre_documento#</span></td>						
						</tr>
						<tr bgcolor="##DADAB6">
							<td width="2%" valign="top">&nbsp;</td>						
							<td width="36%" valign="top"><strong>Registro</strong></td>
							<td width="26%" valign="top"><strong>Funcionario que Registr&oacute;</strong></td>
							<td width="36%" valign="top"><strong>Ventanilla</strong></td>
						</tr>						
						<cfoutput group="id_registro">
							<tr style="cursor:pointer" onClick="javascript: detDoc(#documentos.id_tipo#,#documentos.id_registro#);"

								<cfif band>
									bgcolor="##EEEEEE"
									<cfset band = false>
								<cfelse>
									<cfset band = true>
								</cfif>						 
							 >
								<td width="2%" valign="top">&nbsp;</td>						
								<td width="36%" valign="top">&nbsp;&nbsp;&nbsp;#LSDateFormat(documentos.fechaReg, 'dd/mm/yyyy')#</td>
								<td width="26%" valign="top" nowrap>&nbsp;&nbsp;&nbsp;#documentos.nombreFunc#</td>
								<td width="36%" valign="top">&nbsp;&nbsp;&nbsp;#documentos.nombre_ventanilla#</td>
							</tr>
						</cfoutput>					
					</cfoutput>
				<cfelse>
					<tr><td colspan="4">No existen documentos en el expediente de la persona</td></tr>
					<tr>
					  <td colspan="4">&nbsp;</td>
				  </tr>
				</cfif> 			

			</table>
		</td>
	</tr>	
</table>

<script language="javascript" type="text/javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function detDoc(tipo,reg){
		var param = "&tipo="+tipo
					+"&regis="+reg
					+"&nombTipoIdentif=<cfoutput>#tipoidentificacion.nombre_tipoident#</cfoutput>"
					+"&identif_per=<cfoutput>#form.identificacion_persona#</cfoutput>"
					+"&id_tipoident=<cfoutput>#form.id_tipoident#</cfoutput>";
		
		popUpWindow("detDocum.cfm?persona=<cfoutput>#data.id_persona#</cfoutput>"+param,300,300,600,350);
	}
</script>