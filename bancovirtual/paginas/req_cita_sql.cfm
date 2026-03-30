<cfset anno 	= Year(form.fecha)>
<cfset mes 		= Month(form.fecha)>
<cfset dia 		= Day(form.fecha)>
<cfset hora 	= form.hora>
<cfset minutos 	= form.minutos>
<cfset segundos = form.segundos>

<cfset fecha = CreateDateTime(anno,mes,dia,hora,minutos,segundos)>
<cfquery datasource="tramites_cr" name="contador">
	select  coalesce(count(numero_cupo),0) + 1 num_cupo from TPCita 	
	where  fecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
	and    id_agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agenda#">

</cfquery>

<cfquery datasource="tramites_cr" name="tipo">
	select  id_tipoident from TPPersona 	
	where  id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
</cfquery>

  <cftransaction>
	<cfquery datasource="tramites_cr" name="RSinsert">
		insert  into TPCita (
			fecha, 
			id_persona,
			id_agenda, 
			id_requisito, 
			numero_cupo,
			asistencia, 
			ausencia,  
			BMUsucodigo,
			BMfechamod
		)
		values(  
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agenda#">,
			<cfif isdefined("form.id_requisito") and len(trim(form.id_requisito))>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
			<cfelse>
				null
			</cfif>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#contador.num_cupo#">,
			0,
			0,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		)	
		<cf_dbidentity1 datasource="tramites_cr">
	</cfquery>
	<cf_dbidentity2 datasource="tramites_cr" name="RSinsert">
	<cfset form.id_cita = RSinsert.identity >
</cftransaction>	

<cfif isdefined("form.id_tramite") and len(trim(form.id_tramite))>
	<cf_dbtimestamp datasource="tramites_cr"
		table="TPInstanciaRequisito"
		redirect="req_pago.cfm"
		timestamp="#form.ts_rversion#"
		field1="id_instancia" 
		field2="id_requisito" 
		type1="numeric" 
		type2="numeric" 
		value1="#form.id_instancia#"
		value2="#form.id_requisito#">
	
	<cfquery datasource="tramites_cr" name="update">
		update TPInstanciaRequisito set
		id_cita         = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_cita#">,
		fecha_registro  = 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		BMfechamod    	= 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		BMUsucodigo   	= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where id_instancia  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
		and id_requisito =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
	</cfquery>	
</cfif> 

<script language="javascript" type="text/javascript">
	<cfoutput>
	window.opener.document.form#form.id_requisito#.submit();
	</cfoutput>
	window.close();		
</script>	

	