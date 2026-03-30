
<cfset t = createObject("component","sif.Componentes.Translate")>   
<!--- Etiquetas de traducción --->
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')/>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')/>
<cfset LB_Desde = t.translate('LB_Desde','Desde','/rh/generales.xml')/>
<cfset LB_Hasta = t.translate('LB_Hasta','Hasta','/rh/generales.xml')/>
<cfset LB_Moneda = t.translate('LB_Moneda','Moneda','/rh/generales.xml')/>
<cfset LB_Tipo = t.translate('LB_Tipo','Tipo','/rh/generales.xml')/>
<cfset LB_Detallado = t.translate('LB_Detallado','Detallado','/rh/generales.xml')/>
<cfset LB_Resumido = t.translate('LB_Resumido','Resumido','/rh/generales.xml')/>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_ExportarExcel = t.translate('LB_ExportarExcel','Exportar a Excel')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')> 
<cfset LB_Empleados = t.translate('LB_Empleados','Empleados')>

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

<!--- obtiene meses para el idioma --->
<cfquery datasource="sifcontrol" name="rsMeses">
	select VSdesc, ltrim(rtrim(VSvalor)) as VSvalor
	from VSidioma 
	where VSgrupo = 1 and Iid = (select Iid from Idiomas where Icodigo = '#session.Idioma#')
	order by <cf_dbfunction name="to_number" args="VSvalor">
</cfquery>


<div class="well">
	<form class="bs-example form-horizontal" action="CostoPorFuncionario-sql.cfm" method="post" name="form1" style="margin:0">
		<cfoutput>
			<div class="form-group">
				<label class="col-sm-2 col-lg-offset-2 control-label">#LB_Desde#:</label>
				<div class="col-sm-2">
			        <select class="form-control" name="mesDesde">
			         	<cfloop query="rsMeses">
			         		<option value="#Vsvalor#">#VSdesc#</option>	
			         	</cfloop>
			        </select>
		        </div>
		        <div class="col-sm-2">
			        <select class="form-control" name="periodoDesde">
			         	<cfloop from="#year(now())#" to="#year(now())-15#" step="-1" index="i">
			         		<option value="#i#">#i#</option>	
			         	</cfloop>
			        </select>
		        </div>
			</div>	

			<div class="form-group">
				<label class="col-sm-2 col-lg-offset-2 control-label">#LB_Hasta#:</label>
				<div class="col-sm-2">
			        <select class="form-control" name="mesHasta">
			         	<cfloop query="rsMeses">
			         		<option value="#Vsvalor#">#VSdesc#</option>	
			         	</cfloop>
			        </select>
		        </div>
		        <div class="col-sm-2">
			        <select class="form-control" name="periodoHasta">
			         	<cfloop from="#year(now())#" to="#year(now())-15#" step="-1" index="i">
			         		<option value="#i#">#i#</option>	
			         	</cfloop>
			        </select>
		        </div>
			</div>	

			<div class="form-group">
				<label class="col-sm-2 col-lg-offset-2 control-label">#LB_Tipo#:</label>
				<div class="col-sm-2">
			        <select class="form-control" name="tipo">
			     		<option value="1">#LB_Detallado#</option>	
			     		<option value="2">#LB_Resumido#</option>
			        </select>
		        </div>
			</div>	

			<div class="form-group">
				<label class="col-sm-2 col-lg-offset-2 control-label">#LB_Moneda#:</label>
				<div class="col-sm-2">
			     	<select class="form-control" name="moneda">
			     		<option value="CRC">Colón</option>	
			     		<option value="USD">US Dollar</option>	
			     	</select>
		        </div>
			</div>	

		    <!--- Valida si esta habilitado las consultas corporativas --->
	        <cfif lvPmtConsCorp eq 1>
	            <!--- Arbol con la lista de empresas para consulta coorporativa --->
			    <div class="form-group">
			    	<label class="col-sm-2 col-lg-offset-2 control-label"></label>
			    	<div class="col-md-6">
			    		<cf_rharbolempresas>
			    	</div>	
			    </div>	
			</cfif>
            
            <cfif lvPmtConsCorp eq 1>  
                <div class="form-group" id="divEmpleados2">
                  <label for="DEidentificacion" class="col-sm-4 control-label">#LB_Empleados#</label>
                  <div class="col-sm-3">
                    <cf_rhempleado form="form1" agregarEnLista="true" corporativo="1">
                  </div>
                </div>
            <cfelse>
            	<div class="form-group" id="divEmpleados">
                  <label for="DEidentificacion" class="col-sm-4 control-label">#LB_Empleados#</label>
                  <div class="col-sm-3">
                    <cf_rhempleado form="form1" agregarEnLista="true">
                  </div>
                </div>  
            </cfif>

			<!--- Botones de acciones del reporte --->
			<div class="form-group">
				<div class="col-sm-7 col-sm-offset-4">
					<input type="submit" name="Consultar" class="btnConsultar" value="#LB_Consultar#">
					<input type="submit" name="Exportar" class="btnExportar" value="#LB_ExportarExcel#">
					<input type="reset" name="Limpiar" class="btnLimpiar" value="#LB_Limpiar#" onclick="fnLimpiar()">
				</div>	
			</div>	
		</cfoutput>	
	</form>
</div>

<script type="text/javascript">
	$(document).ready(function(){
		fnLimpiar();
	});

	// Funcion para inicializar(reset) los elementos del form
	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
		$('.listTree').listTree('deselectAll');
		$(".divArbol").hide();
	}
</script>