<cfprocessingdirective pageEncoding="utf-8">
<!--- <cfdump var=##> --->
<!--- VARIABLES --->
<cfparam name="varODID" default="-1">
<cfset varErrorQ = false>

<cfquery name="rsOdata" datasource="#session.DSN#">
	select 	ODId,ODCodigo,ODDescripcion,ODSQL,Ecodigo,COId
	FROM 	RT_OrigenDato
	where 	ODId =#varODID#
</cfquery>

<!--- CATEGORIA --->
<cfquery name="rsCatData" datasource="#session.DSN#">
	select 	COId, COCodigo, CODescripcion
	FROM 	RT_OrigenCategoria
</cfquery>

<cfif rsOData.recordcount GT 0>
	<cfset listQuery = valueList(rsOdata.ODId)>
<cfelse>
	<cfset listQuery = "">
</cfif>
<!--- Validamos codigo de OD --->
<cfquery  name="rsVaOD" datasource="#session.DSN#">
	 SELECT ODCodigo
  		FROM RT_OrigenDato
		where ODCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.EcodigoSDC#">
</cfquery>

<cfoutput>
<form method="post" action="OrigenDatos-sql.cfm" name="ODform" id="ODform">
	<input type="hidden" name="varProc" value="#varProc#">
	<input type="hidden" name="ODId" value="#rsOdata.ODId#">
	<input type="hidden" name="Ecodigo" value="#session.Ecodigo#">
	<div class="container" style="width: 400px;">
		<p>
			<label for="ODCodigo">#LB_Codigo#:&nbsp;</label>
			<input align="left" type="text" id="ODCodigo" name="ODCodigo" value="#rsOdata.ODCodigo#"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<span>
				<input type="checkbox" id="Exclusivo" name="Exclusivo" <cfif rsOdata.Ecodigo NEQ '' AND rsOdata.Ecodigo GT 0>checked</cfif>>
				<label for="Exclusivo" style="float:none; width:50px; font-style:normal;">#LB_Exclusivo#</label>
			</span>
		</p>
		<p>
			<label for="ODDesc" style="font-style:normal;">#LB_Desc#:&nbsp;</label>
			<input type="text" id="ODDesc" name="ODDesc" size="45" value="#rsOdata.ODDescripcion#">
		</p>
		<p>
			<label for="Consulta" style="font-style:normal;">#LB_Consulta#:&nbsp;</label>
			<textarea id="Consulta" name="Consulta" cols="43" rows="4" style="border:1px solid ##c0c0c0;">#rsOdata.ODSQL#</textarea>
		</p>
		<p>
			<label for="COId" style="font-style:normal;">#LB_Catego#:&nbsp;</label>
			<Select id="COId" name="COId">
				<cfloop query="rsCatData">
					<option value="#COId#" <cfif '#COId#' eq '#rsOdata.COId#'>selected="selected"</cfif>>#CODescripcion#</option>
				</cfloop>
			</Select>
		</p>
		<cfif listfind('EOD,NOD',varProc)>
			<p>
				<input type="submit" Value="Guardar" name="Guardar"  style="display: block;  margin-left: auto;  margin-right: auto;">
				<input type="hidden" name="modo" value="#modo#">
				<input type="hidden" name="Guardar" value="Guardar" id="Guardar">
			</p>
		</cfif>
		<p style="padding-left:140px;">
			<div id="container" style="padding-left:70px;">
			<cftry><!---	RegGex que evaluan las varaibles del tipo Date, Int y String 	--->
				<cfset queryString = #REreplace(PreserveSingleQuotes(rsOdata.ODSQL),'(<\?[^,<]*\:date\?\>)',"01/01/1900", "all")#>
				<cfset queryString = #REreplace(PreserveSingleQuotes(queryString),'(<\?[^,<]*\:numeric\?\>)',"0", "all")#>
				<cfset queryString = #REreplace(PreserveSingleQuotes(queryString),'(<\?[^,<]*\:string\?\>)',"0", "all")#>
				<cftransaction>
					<cfquery name="rsColumns" datasource="#session.DSN#">
						#PreserveSingleQuotes(queryString)#
					</cfquery>
					<cftransaction action="rollback" />
				</cftransaction>
				<cfset varErrorQ = false>
				<cfset varList = arraytolist(rsColumns.getMetaData().getColumnLabels())>
				<cfcatch>
					<cfset varErrorQ = true>
					<cfset errDet = #cfcatch.detail#>
				</cfcatch>
			</cftry>
				<div class="panel-group" id="collapse" style="max-width:250px;">
					<div class="panel panel-default">
						<div class="panel-heading">
							<p class="panel-title">
								<a id="collapsableTxt" data-toggle="collapse" data-parent="##collapse" href="##collapseOne">
									<span style="display:inline-block;"><i id="img" class="fa fa-plus"></i> #LB_TituloCol#</span>
								</a>
							</p>
						</div>

						<div id="collapseOne" class="panel-collapse collapse">
							<div id="divResult" class="panel-body">
								<cfif varErrorQ>
									<cfif modo NEQ 'ALTA'>
										<p style="color:red; font-weight:strong;">#MSG_Falla# #errDet#</p>
									</cfif>
								<cfelse>
									<cfloop list="#varList#" index="i">
										<ul>
											<li>#i#</li>
										</ul>
									</cfloop>
								</cfif>
							</div>
						</div>
					</div>
				</div>
			</div>
		</p>
	</div>
</form>

</cfoutput>

<cfif modo NEQ 'ALTA'>
	<!--- Seccion de Variables y relaciones --->
	<cfset ODId="#varODID#">

	<!--- Variable Auxiliares--->
	<cfset LvarAux = 1>

		<div>
			<form name="FormVariablesSql" id="FormVariablesSql" action="" method="POST">
				<!--- Campo oculto para enviar el ODId(ID de origen de datos)--->
				<input name="ODId" id="ODId" type="hidden" value="<cfoutput>#ODId#</cfoutput>">
				<input name="varEdit" id="varEdit" type="hidden" value="<cfoutput>#varEdit#</cfoutput>">
				<div class="row">
					<div class="col-md-12">
						<div>
						 <!-- Nav tabs -->
						 <ul class="nav nav-tabs" role="tablist">
	   						<li role="presentation" class="active">
								<a href="#home" aria-controls="home" role="tab" data-toggle="tab">Relaciones</a>
							</li>
	   						<li role="presentation">
								<a href="#profile" aria-controls="profile" role="tab" data-toggle="tab">Variables</a>
							</li>
						</ul>
						<!-- Tab panes -->
						<div class="tab-content">
							<div role="tabpanel" class="tab-pane active" id="home">
								 	<!--- Muestra las relaciones por Ajax --->
									<div id="OdReAjax">
									</div>
								</div>
						    <div role="tabpanel" class="tab-pane" id="profile">
						  <!---  <div class="alert alert-success" role="alert" id="divmensaje" style="display:none">
								<span id="mensaje"></span>
							</div> --->
							    <div class="well">
							   		<div id="VarAjax"><!--- Se muestra las variables por Ajax --->

									</div>
								</div><!--- Fin well --->
							</div>
						  </div>
						</div>
					</div>
			</form>


		</div>
		<!--- Ventana modal nueva relacion --->
		<div id="popupViewNew" style="display: none;"> <!---popUp Editar--->

		</div>
</cfif>

<script type="text/javascript">

	<cfif !varEdit>
		$('input').prop("readonly",true);
		$('textarea').prop("readonly",true);
		$('input[type=checkbox]').prop("disabled",true);
	</cfif>

	//<!--- Muestra listado de Relaciones --->
	function funcNuevoRe(){
	  	$.ajax({
		   	type: 'POST',
			url:'/cfmx/commons/GeneraReportes/Componentes/ODAjax.cfc?method=ODRe',
			data: $("#FormVariablesSql").serialize(),
			success: function(results) {
				$("#OdReAjax").html(results);
				//ODColumnAjax();
			},
		    error: function() {

		    }
		});
	}
	//Funcion para mostrar variables
	function funcVariables(){
	  	$.ajax({
		   	type: 'POST',
			url:'/cfmx/commons/GeneraReportes/Componentes/ODAjax.cfc?method=GetVariablesOD',
			data: $("#FormVariablesSql").serialize(),
			success: function(results) {
				$("#VarAjax").html(results);
				//ODColumnAjax();
			},
		    error: function() {

		    }
		});
	}

	<!--- Muestra listado de relaciones al cargar la pagina --->
	window.onload = funcNuevoRe();
	window.onload = funcVariables();

// TOGGLE MINUS PLUS
	$("#collapsableTxt").click(function(){
		$("#img").removeClass("fa fa-plus");
		$("#img").toggleClass("fa fa-minus")
		$("#img").addClass("fa fa-plus");
	});

// COLUMNAS
	var frm = $('#ODform');
	frm.submit(function (ev) {
		var LvarODCodigo = document.ODform.ODCodigo.value;
		var LvarODDesc = document.ODform.ODDesc.value;
		var LvarConsulta = document.ODform.Consulta.value;
		$.ajax({
			type: frm.attr('method'),
			url: frm.attr('action'),
			beforeSend: function(){
				if(LvarODCodigo == "" || LvarODDesc == "" || LvarConsulta == "" ){
					return false;
				}else{
					return true;
				}
			},
			success: function(results) {
				location.reload();
				//$("#result").html(results);
			},
			data: frm.serialize()}).done(function(result) {
				$("#divResult").hide();
				$("#divResult").html(result);
				$("#divResult").show(1000);
		}).fail(function() {
		 	alert('1.-Los campos no pueden estar vacios \n\n 2.-<cfoutput>#MSG_Falla#</cfoutput>');
		});
		 ev.preventDefault();
	});



	//Actualizar variables
	function FunUpdateVar(){
	  	$.ajax({
		   	type: 'POST',
			url:'/cfmx/commons/GeneraReportes/Componentes/ODAjax.cfc?method=EditVariables',
			data: $("#FormVariablesSql").serialize(),
			success: function(results) {
				funcVariables();
			},
		    error: function() {

		    }
		});
	}

	//<!--- Mostrar input --->
	function ShowInput(valor){
		document.getElementById('ValorForm'+valor).style.display = 'block';
		document.getElementById('titleValor').style.display = 'block';

		var posicion = document.getElementById('Formula'+valor).options.selectedIndex; //posicion
		<!--- alert(document.getElementById('ValorForm'+valor).options[posicion].text); //valor --->
		console.log(posicion);
		if(posicion == 2){
			document.getElementById('ValorForm'+valor).style.display = 'none';
		}
	}

	//<!--- Eliminar Relaciones origen --->
	function DeleteRe(RODId){
		var LvarConfirm = confirm("Desea eliminar la relacion?");
		if(LvarConfirm){
			var url = "/cfmx/commons/GeneraReportes/Componentes/ODAjax.cfc?method=DeleteRe&RODId="+RODId;
		    $.ajax({
				type: "GET",
				url: url,
				success: function(result){
			       // $("#AjaxM").html(result);
			       funcNuevoRe();
			    }
			});
		}
	}

	//Ventana modal
	function FunviewNewRel(){
		var ODId = '<cfoutput>#ODId#</cfoutput>';
		var url = "OrigenDatos_Variables.cfm?varProc=VOD&ODID="+ODId;
	    $.ajax({
			type: "GET",
			url: url,
			success: function(result){
		        $("#popupViewNew").html(result);
		    }
		});
		$("#popupViewNew").dialog({
	        width: 670,
	        modal:true,
	        title:"<cfoutput>#LB_TMRelacion#</cfoutput>",
	        resizable: "false",
	        position:['middle',70]
	    });
	}

</script>