<!--- VARIABLES --->
<cfset varCodigo 	= ''>
<cfset varDesc  	= ''>
<cfset Ecodigo		= 0>
<cfset varSMcodigo 	= ''>
<cfset varPublico   = 0>

<!--- OBTIENE MODULOS --->
<cfquery name="rsModuloes" datasource="asp">
	SELECT 	e.SMcodigo, SMdescripcion, e.SMcodigo
	FROM 	ModulosCuentaE e
		INNER JOIN SModulos m on e.SScodigo = m.SScodigo and e.SMcodigo = m.SMcodigo
	WHERE 	CEcodigo = #session.CEcodigo#
	AND 	e.SScodigo = '#session.monitoreo.SScodigo#' order by (SMdescripcion)
</cfquery>

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		SELECT 	RPCodigo, Ecodigo, RPDescripcion, SScodigo, SMcodigo, RPPublico
		FROM 	RT_Reporte
		WHERE 	RPTId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RPTId#">
	</cfquery>
	<cfset varCodigo 	= rsReporte.RPCodigo>
	<cfset varDesc  	= rsReporte.RPDescripcion>
	<cfset Ecodigo		= rsReporte.Ecodigo>
	<cfset varSMcodigo 	= rsReporte.SMcodigo>
	<cfset varPublico      = rsReporte.RPPublico>
</cfif>
<cfoutput>
<form name="frGREP" id="frGREP" method="Post" action="GestionReportes-sql.cfm">
	<input type="hidden" name="modo" id="modo" value="#modo#">
	<input type="hidden" name="RPTId" id="RPTId" value="#form.RPTId#">
	<div id="forma" class="row">
		<div class="col-sm-3">
			<label for="RPCodigo">#LB_Codigo#:&nbsp;</label>
			<label for="RPDescripcion">#LB_Desc#:&nbsp;</label>
			<label for="SMcodigo" style="font-style:normal;">#LB_Modulo#:&nbsp;</label>
		</div>
		<div class="col-sm-9 text-left">
			<input type="text" name="RPCodigo" id="RPCodigo" size="40" value="#varCodigo#">
			<span style="padding-left:20px;">
				<input type="checkbox" id="Exclusivo" name="Exclusivo" <cfif Ecodigo GT 0>checked</cfif>>
				<label for="Exclusivo" style="float:none; width:50px; font-style:normal;">#LB_Exclusivo#</label>
			</span>
			<input type="text" name="RPDescripcion" id="RPDescripcion" size="40" value="#varDesc#">
			<span style="padding-left:20px;">
				<input type="checkbox" id="Publico" name="Publico" <cfif varPublico GT 0>checked</cfif>>
				<label for="Publico" style="float:none; width:50px; font-style:normal;">#LB_Publico#</label>
			</span>
			<div style="padding-top:2px;">
			<Select id="SMcodigo" name="SMcodigo" style="width:258px">
				<option value="">#LB_Ninguno#</option>
				<cfloop query="rsModuloes">
					<option value="#SMcodigo#" <cfif varSMcodigo EQ #SMcodigo#>Selected</cfif>>#SMdescripcion#</option>
				</cfloop>
			</Select>
			</div>
		</div>
	<div class="col-sm-12 text-center" style="margin-top:10px;">
		<button type="button" name="Guardar" class="btn btn-default btn-sm" onclick="fnSend()">#LB_Guardar#</button>
	</div>
	</div>
</form>
<!--- test --->
<div id="test"></div>
</cfoutput>
<!--- TABS --->
<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#OriDat"><cfoutput>#LB_OriDat#</cfoutput></a></li>
  <li><a data-toggle="tab" href="#Cols"><cfoutput>#LB_Columnas#</cfoutput></a></li>
</ul>
<!--- CONTENT --->

<div class="tab-content">
  <div id="OriDat" class="tab-pane fade in active">
	<!--- Se muestra origen de datos por Ajax --->
    <div id="GetODAjax">

	</div>
  </div>
  <div id="Cols" class="tab-pane fade">
  	<cfinvoke component="commons.GeneraReportes.Componentes.ReporteCOlumna"
		method="getColumnas"
		rtpid="#form.RPTId#"
		returnvariable="strHTML"
	/>
	<cfoutput>#strHTML#</cfoutput>
  </div>
</div>

<!--- Ventana modal --->
<div id="popupViewNew" style="display: none;">

</div>

<script type="text/javascript">
// VARIABLES GLOBALES
var sqlUrl = 'GestionReportes-sql.cfm';
var data = '';
</script>
<script type="text/javascript">
// AJAX
function fnAjax(tipo, datos){
	  	$.ajax({
		   	type: tipo,
			url: sqlUrl,
			data: datos,
		})
		.done(function(result){fnCallBack(1,result)})
		.fail(function(result){fnCallBack(2,result)});
	}
// CALLBACK
function fnCallBack(status,result){
	// 1 = success, 0 = fail, 3= Campos vacios
	if (status == 1){
		$("#modo").val("CAMBIO");
		$("#test").hide();
		$("#test").html(result);
		$("#test").show(1000);
		//console.log(result);
		location.reload();
	}else if(status == 0){
		alert('fail');
	}
}
// ENVIO DE DATOS
function fnSend(){
	var LvarRPCodigo = document.frGREP.RPCodigo.value;
	var LvarRPDescripcion = document.frGREP.RPDescripcion.value;
	var LvarSMcodigo = document.frGREP.SMcodigo.value;

	var frm = $('#frGREP');
	data = frm.serialize();

	if(LvarRPCodigo == "" || LvarRPDescripcion == "" || LvarSMcodigo == "" ){
		alert("Los datos no pueden estar vacios");
	}else{
		fnAjax("post", data);
	}
}
</script>