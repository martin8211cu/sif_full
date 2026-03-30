<cfset LvarODID="#url.ODID#">

<!--- Campos del origen de datos Base  --->
<cfquery name="rsColumnOD" datasource="#session.DSN#">
	select 	ODId,ODCodigo,ODDescripcion,ODSQL,Ecodigo,COId
	FROM 	RT_OrigenDato
	where 	ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarODID#">
</cfquery>


<!--- Obtener origen de datos --->
<cfquery name="rsODFO" datasource="#session.DSN#">
	select 	ODId,ODCodigo,ODDescripcion
	FROM 	RT_OrigenDato
	where 	ODId <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarODID#">
</cfquery>

<div class="row">
	<form name="FormNewRe" id="FormNewRe" action="" method="POST">
	<div class="row">
		<div class="col-md-6">
			<h5>Origen Datos Local </h5>
		</div>
		<div class="col-md-6">
			<h5>Origen Datos Foreaneos </h5>
		</div>
	</div>

	<div class="row">
		<div class="col-md-6">
			<input name="NomOD" id="NomOD" value="<cfoutput> #rsColumnOD.ODCodigo#</cfoutput>" text="text" disabled>
		</div>
		<div class="col-md-6">
			<select name="ODFO" id="ODFO" onchange="ODColumnAjax()">
				<option value="">-Seleccione origen de datos</option>
				<cfoutput query="rsODFO">
					 <option value="#rsODFO.ODId#">#rsODFO.ODCodigo#</option>
				</cfoutput>
			 </select>
		</div>
	</div><br>
	<!--- Se muestra los campos a relacionar --->
	<div class="row" id="ResultODFOAjax">


	</div><br>
	<div class="row">
		<input type="button" tabindex="0" onclick="FunInsertRe()" value="Guardar"
		class="btnGuardar" name="btnGuardar" style="display: block;  margin-left: auto;  margin-right: auto;">
	</div>
	<!--- Datos Auxiliares --->
	<input name="IDODLocal" id="IDODLocal" value="<cfoutput>#LvarODID#</cfoutput>" type="hidden">
	<span id="result"></span>
	<span id="inputHiden"></span>
	</form>
<div>
<script>
	//Selecciona las columna de OD
	function ODColumnAjax(){
		var micapa = document.getElementById('inputHiden');
		micapa.innerHTML= '<input type="Hidden" value="1" name="ODAjax"/>';
	  	$.ajax({
		   	type: 'POST',
			url:'/cfmx/commons/GeneraReportes/Componentes/ODAjax.cfc?method=SelectColumns',
			data: $("#FormNewRe").serialize(),
			success: function(results) {
				 $("#ResultODFOAjax").html(results);
			},
		    error: function() {

		    }
		});
	}
	//<!--- Insertar relaiones de OD --->
	function FunInsertRe(){
		var micapa = document.getElementById('inputHiden');
		micapa.innerHTML= '<input type="Hidden" value="1" name="InsertODAjax"/>';
	  	$.ajax({
		   	type: 'POST',
			url:'/cfmx/commons/GeneraReportes/Componentes/ODAjax.cfc?method=InsertColumns',
			data: $("#FormNewRe").serialize(),
			beforeSend: function() {
				var ODLocal= $("#ODLocal").val();
				var ODFOColumns= $("#ODFOColumns").val();
				if(ODLocal == null || ODFOColumns == null ){
					return false;
				}
    		},
			success: function(results) {
				$("#result").html(results);
				//<!--- Refresca la lista de columnas de OD --->
				 ODColumnAjax();
				 //<!--- Refresca la lista de relaciones --->
				 funcNuevoRe();
			},
		    error: function() {

		    }
		});
	}

</script>
