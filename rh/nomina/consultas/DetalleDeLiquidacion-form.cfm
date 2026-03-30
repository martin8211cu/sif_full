
<cfset t = createObject("component","sif.Componentes.Translate")>
<cfset fdesde = t.translate('LB_FechaDesde','Fecha desde','/rh/generales.xml')>
<cfset fhasta = t.translate('LB_FechaHasta','Fecha hasta','/rh/generales.xml')>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>

<!--- Consulta si empresa(session) tiene habilitada la opcion de permitir consultas corporativas --->
<cfquery name="rsPmtConsCorp" datasource="#Session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> and Pcodigo = 2715
</cfquery>

<cfif rsPmtConsCorp.recordCount gt 0 and rsPmtConsCorp.Pvalor eq '1'>
	<cfset lvPmtConsCorp = 1 >
<cfelse>
	<cfset lvPmtConsCorp = 0 >	
</cfif>


<cfoutput>
	<div class="well">
		<form name="form1" id="form1" action="DetalleDeLiquidacion-sql.cfm" method="post" class="bs-example form-horizontal">
		    <fieldset> 
		        <div class="form-group">
				  	<label class="col-lg-3 col-lg-offset-1 control-label"><strong>#fdesde#</strong>:</label>
					<div class="col-lg-6"> 
						<cf_sifcalendario name="fechadesde" value="#now()#">
					</div>	 
				</div>

		        <div class="form-group">
					<label class="col-lg-3 col-lg-offset-1 control-label"><strong>#fhasta#</strong>:</label>
					<div class="col-lg-6"> 
						<cf_sifcalendario name="fechahasta" value="#now()#">
					</div>	 
				</div>

				<!--- Valida si esta habilitado las consultas corporativas --->
	            <cfif lvPmtConsCorp eq 1>
	                <!--- Arbol con la lista de empresas para consulta coorporativa --->
					<div class="form-group">
						<div class="col-xs-9 col-lg-offset-1">
							<cf_rharbolempresas>
						</div>
					</div>
				</cfif> 
					
				<div class="form-group">
					<div class="col-xs-12 text-center">
						<input type="submit" name="btnConsultar" class="btnConsultar" value="#LB_Consultar#">
					</div>
				</div>
			</fieldset>
		</form>
	</div>
</cfoutput>

<cf_qforms form="form1">
<script type="text/javascript">
	$(document).ready(function(){
		$('form[name=form1]')[0].reset();
	});

	objForm.fechadesde.required = true;
	objForm.fechahasta.required = true;
	objForm.fechadesde.description = '<cfoutput>#fdesde#</cfoutput>';
	objForm.fechahasta.description = '<cfoutput>#fhasta#</cfoutput>';
</script>