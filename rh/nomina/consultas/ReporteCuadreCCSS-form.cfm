<style type="text/css">
	.form-group { margin-bottom: 8px; }
	.periodo { margin-top: 10px; }
	.periodo .dtPeriodo div, .GCargas label, .GCargas select { float: left; }
	.periodo .dtPeriodo .year select { width: 90px; }
	.periodo .dtPeriodo .mes select { width: 135px; }
	.periodo .dtPeriodo .year label { margin-left: 25px; }
	.periodo .dtPeriodo .mes label { margin-left: 45px; }
	.periodo .dtPeriodo div select { margin-right: 35px; }
	.GCargas label { padding-left: 43px; }
	.GCargas select { margin-left: 7px;  margin-right: 7px; width: 280px; }
	.detailCargas { display:none; margin-bottom: 20px; }
	.encabezado, .detListCargas { margin-left: -2px; width: 87%; }
	.encabezado div { background-color: #B0C8D3; padding-top: 4px; height: 28px; margin-bottom: 0; }
	.encabezado label { margin-left: -13px; }
	.detListCargas .row, .detListCargas .row div { height: 35px; margin-bottom: 0; }
	.detListCargas .encGC { padding-top: 2px; margin-left: -1px; width: 100%; }
	.detListCargas .encGC div { background-color: #ffffff; }
	.detListCargas .encGC .lbCod label { margin-left: -9px; }
	.detListCargas .encGC .btn { margin-left: 20px; }
    .detListCargas div { padding-top: 3px; padding-bottom: 3px; }
	.divArbol .listTree { margin-left: 56px;  width: 70% } 
	.btns { margin-bottom: 10px; }
</style>

<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->
<cfset LB_Periodo = t.translate('LB_Periodo','Periodo','/rh/generales.xml')>  
<cfset LB_Ano = t.translate('LB_Ano','Año','/rh/generales.xml')> 
<cfset LB_Mes = t.translate('LB_Mes','Mes','/rh/generales.xml')> 
<cfset LB_EsCorporativo = t.translate('LB_EsCorporativo','Es Corporativo','/rh/generales.xml')>
<cfset LB_GrupoCarga = t.translate('LB_GrupoCarga','Grupo de Carga','/rh/generales.xml')>
<cfset LB_SeleccioneGrupoCarga = t.translate('LB_SeleccioneGrupoCarga','Seleccione Grupo de Carga','/rh/generales.xml')>
<cfset LB_Codigo  = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Descripcion  = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset LB_Grupo = t.translate('LB_Grupo','Grupo','/rh/generales.xml')>
<cfset LB_Cargas = t.translate('LB_Cargas','Cargas','/rh/generales.xml')>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_ExportarExcel = t.translate('LB_ExportarExcel','Exportar a Excel','/rh/generales.xml')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')> 
<cfset LB_Eliminar = t.translate('LB_Eliminar','Eliminar','/rh/generales.xml')>

<cfset MSG_AddGrupoCargas = t.translate('MSG_AddGrupoCargas','Agrega el grupo de cargas seleccionado')>
<cfset MSG_ConsultarGC = t.translate('MSG_ConsultarGC','Consulta la información de Cuadre CCSS')>
<cfset MSG_ExportarGC = t.translate('MSG_ExportarGC','Exportar la información de Cuadre CCSS')>
<cfset MSG_Limpiar = t.translate('MSG_Limpiar','Limpia el formulario','/rh/generales.xml')>
<cfset MSG_GrupoCargas = t.translate('MSG_GrupoCargas','Debe seleccionar un grupo de cargas para agregar a la consulta')>
<cfset MSG_Nota = t.translate('MSG_Nota','Nota','/rh/generales.xml')>
<cfset MSG_Requeridos = t.translate('MSG_Requeridos','Para realizar la consulta se debe seleccionar los siguientes valores','/rh/generales.xml')>


<cfset anoActual = year(now())>
<cfset mesActual = month(now())> 


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


<cfquery name="rsListYears" datasource="#session.DSN#">
    select distinct CPperiodo as years
    from CalendarioPagos
    where CPperiodo <= #anoActual#
    union 
        select #anoActual# as years from dual   
</cfquery> 

<cfquery name="rsListYears" dbtype="query">
    select * from rsListYears order by years asc
</cfquery> 

<!--- Obtiene los grupos de cargas --->
<cf_translatedata name="get" tabla="ECargas" col="ECdescripcion" returnvariable="LvarECdescripcion">
<cfquery name="rsListGC" datasource="#session.DSN#">
	select ec.ECcodigo, #LvarECdescripcion# as ECdescripcion
	from ECargas ec 
	where ec.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by ec.ECcodigo
</cfquery>


<cfif isdefined("form.sYear") and len(trim(form.sYear))>
    <cfset lvarYear = form.sYear >
<cfelseif isdefined("url.sYear") and len(trim(url.sYear))>
    <cfset lvarYear = url.sYear >    
<cfelseif isdefined("url.sYear") or isdefined("form.sYear")>
    <cfset lvarYear = '' >     
<cfelse>
    <cfset lvarYear = anoActual >    
</cfif>

<cfif isdefined("form.sMes") and len(trim(form.sMes))>
    <cfset lvarMes = form.sMes >
<cfelseif isdefined("url.sMes") and len(trim(url.sMes))>
    <cfset lvarMes = url.sMes >    
<cfelseif isdefined("url.sMes") or isdefined("form.sMes")>
    <cfset lvarMes = '' >     
<cfelse>
    <cfset lvarMes = mesActual >    
</cfif>

<cfif isdefined("form.ECcodigo") and len(trim(form.ECcodigo))>
    <cfset lvarECcodigo = form.ECcodigo >
<cfelseif isdefined("url.ECcodigo") and len(trim(url.ECcodigo))>
    <cfset lvarECcodigo = url.ECcodigo >  
<cfelse>
	<cfset lvarECcodigo = '' >     
</cfif>      

<cfset rsMes = getMeses() > <!--- Obtiene los meses a utilizar --->


<div>
	<fieldset>
		<form name="form1" class="bs-example form-horizontal" action="ReporteCuadreCCSS-sql.cfm" method="post">
			<cfoutput>
				<!--- Seleccion del periodo(año/mes) --->
				<div class="form-group"> 	
					<div class="col-sm-9 col-sm-offset-3 periodo">
						<div class="dtPeriodo">	
							<div class="year">
								<label for="mes"><strong>#LB_Ano#</strong></label>
								<select name="sYear" class="form-control">
			                        <cfloop query="#rsListYears#">
			                            <option value="#years#"<cfif isdefined("lvarYear") and len(trim(lvarYear))>
			                            		<cfif rsListYears.years eq lvarYear> selected </cfif>
			                            	</cfif>>#years#
			                            </option>
			                        </cfloop>
								</select>
							</div>	
							<div class="mes">
								<label for="mes"><strong>#LB_Mes#</strong></label>
								<select name="sMes" class="form-control">
									<cfloop query="rsMes">
							            <option value="#codMes#"<cfif isdefined("lvarMes") and len(trim(lvarMes))>
							            		<cfif rsMes.codMes eq lvarMes> selected </cfif>
							            	</cfif>>#mes#
							        	</option>
							        </cfloop>	
								</select>		
							</div>
						</div>		
					</div>		
		        </div>

		        <cfif lvPmtConsCorp eq 1>
			        <!--- Check de consulta coorporativa --->
			        <div class="form-group" style="margin-left: -33px;">
			        	<div class="col-sm-11 col-sm-offset-1">
			            	<cf_rharbolempresas>
			            </div>	
			        </div>
			    </cfif>     

		        <!--- Seleccion del Grupo de Cargas --->
		        <div class="form-group">	
		        	<div class="col-sm-11 col-sm-offset-1 GCargas">
			        	<label><strong>#LB_GrupoCarga#:</strong></label>
						<select name="sGC" id="sGC" class="form-control">
							<option value="">#LB_SeleccioneGrupoCarga#</option>
							<cfloop query="rsListGC">
					            <option value="#ECcodigo#"<cfif isdefined("lvarECcodigo") and len(trim(lvarECcodigo))>
					            		<cfif rsListGC.ECcodigo eq lvarECcodigo> selected </cfif>
					            	</cfif>>#ECdescripcion#
					        	</option>
					        </cfloop>	
						</select>
						<input type="button" class="btnNormal" value="+" onclick="fnAddSelect()">
					</div>	
		        </div>	

		        <!--- Detalle de las cargas seleccionadas --->
		        <div class="form-group">
			        <div class="col-sm-12 col-sm-offset-2 detailCargas">
			        	<div class="row encabezado">
			        		<div class="col-xs-3"><label><strong>#LB_Grupo#</strong></label></div>
				            <div class="col-xs-6"><label><strong>#LB_Cargas#</strong></label></div>
			        	</div>	
						<div class="detListCargas">
						</div>	
					</div>
				</div>	

				<!--- Botones de acciones del reporte --->
				<div class="form-group"> 
			        <div class="col-sm-12 col-sm-offset-3 btns">
			        	<input type="submit" name="Consultar" class="btnConsultar" value="#LB_Consultar#" onclick="return fnValSubmit();">
			        	<input type="submit" name="Exportar" class="btnExportar" value="#LB_ExportarExcel#" onclick="return fnValSubmit();">
						<input type="reset" name="Limpiar" class="btnLimpiar" value="#LB_Limpiar#" onclick="fnLimpiar()">
			        </div>
		        </div>
			</cfoutput> 
		    <input type="hidden" name="mesPer" class="mesPer" value="" /> 
		</form>
	</fieldset>
</div>


<cffunction name="getMeses" access="public" output="false" returntype="query">
	<cfquery name="rs" datasource="sifControl">
		select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as codMes, b.VSdesc as mes
		from Idiomas a
		inner join VSidioma b 
		on a.Iid = b.Iid
		where a.Icodigo = '#Session.Idioma#'
		and b.VSgrupo = 1
		order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
	</cfquery>
	<cfreturn rs>
</cffunction>


<script type="text/javascript">
	$(document).ready(function(){
		fnLimpiar();
	});

	$(document).on('click','.listTree input[type=checkbox]', function(e) {
		fnCargarListGC();
	});	

	$('#esCorporativo').click(function(){
		if(!$(this).prop('checked')){
			$('#jtreeListaItem').val(<cfoutput>#session.Ecodigo#</cfoutput>);
			fnCargarListGC();
		}
	});

	// Funcion que valida si los elementos requeridos han sido suministrados por el usuario para realizar submit del form
	function fnValSubmit(){
		var result = true;
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> <cfoutput>#MSG_Requeridos#</cfoutput>:<br/><br/>';

		if($('select[name=sYear]').val() == '' || $('select[name=sYear]').val() == null || $('select[name=sMes]').val() == '' 
			|| $('select[name=sMes]').val() == null){ 
			mensaje += '-> <cfoutput>#LB_Periodo#</cfoutput><br/>';
			result = false;   
		}

		if(!$('.detailCargas').is(':visible')) {
			mensaje += '-> <cfoutput>#LB_GrupoCarga#</cfoutput>';
			result = false;
		}

		if(!result)
			alert(mensaje);
		else
			$('.mesPer').val($('select[name=sMes] :selected').text()); 
			
		return result;
	}

	function fnAddSelect(){
		result = fnValidarElement('sGC','<cfoutput>#MSG_GrupoCargas#</cfoutput>');

		if(result)
			fnAddElement('sGC');
	}

	function fnValidarElement(e,showMsg){
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> ';
		var result = true;

		if($('#'+e).val().trim() == ''){
			result = false;
			mensaje += showMsg;
			alert(mensaje);
		}
		return result;
	}

	function fnCargarListGC(){
		var elementHTML = "", vECcodigo = -1, vECdescripcion = "", vCodConc = "", vCoorporativo = false, vjtreeListaItem = "";

		$('#sGC option').remove();
		elementHTML = '<option value=""><cfoutput>#LB_SeleccioneGrupoCarga#</cfoutput></option>';
		$('#sGC').append(elementHTML);

		if($('#esCorporativo').length != 0)
			vCoorporativo = $('#esCorporativo').prop('checked');
		else
			vCoorporativo = false; 

		vjtreeListaItem = $('#jtreeListaItem').val();

		$.ajax({
		        url: "ReporteCuadreCCSS-lista.cfm",
		        type: "post",
		        dataType: "json",
		        async : false,
		        data: { GetListGC:true, esCorporativo:vCoorporativo, jtreeListaItem:vjtreeListaItem },  
		        success: function(data) {
			        $.each(data.DATA, function(key, val){
						vECcodigo = "";
						vECdescripcion = "";
						$.each(val, function(key, val){
							if(key == 0)
								vECcodigo = val;
							else if(key == 1)
								vECdescripcion = val;
					 	});
					 	if(vECcodigo != -1){ 
					 		if(vCoorporativo)
					 			vCodConc = vECcodigo +' - ';
					 		else 
					 			vCodConc = '';

					 		elementHTML = '<option value="'+vECcodigo+'">'+vCodConc+vECdescripcion+'</option>';
							$('#sGC').append(elementHTML);
					 	}
					}); 	
		       }
		    });
	}	

	function fnAddElement(e){
		var elementHTML = "", vECcodigo = "", vECdescripcion = "", vDCcodigo = -1, vDCdescripcion = "", vClass ="", vCoorporativo = "", vjtreeListaItem = "";

		vECcodigo = $('#'+e).val(); 
		vECdescripcion = $('#'+e+' :selected').text();
		vClass = 'gc_'+vECcodigo;

		if($('#esCorporativo').length != 0)
			vCoorporativo = $('#esCorporativo').prop('checked');
		else
			vCoorporativo = false;

		vjtreeListaItem = $('#jtreeListaItem').val();

		if($('.'+vClass).length == 0){

			elementHTML = '<div class="row encGC '+vClass+'"><div class="col-xs-3">'+vECdescripcion+'</div><div class="col-xs-1 lbCod"><label><strong><cfoutput>#LB_Codigo#</cfoutput></strong></label></div><div class="col-xs-4"><label><strong><cfoutput>#LB_Descripcion#</cfoutput></strong></label></div><div class="col-xs-1"><a style="padding:0" class="btn" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this)"><i class="fa fa-times fa-sm"></i></a></div></div>';

			$('.detListCargas').append(elementHTML);
		
			$.ajax({
		        url: "ReporteCuadreCCSS-lista.cfm",
		        type: "post",
		        dataType: "json",
		        async : false,
		        data: { GetListCargas:true, ECcodigo:vECcodigo, esCorporativo:vCoorporativo, jtreeListaItem:vjtreeListaItem },  
		        success: function(data) {
			        $.each(data.DATA, function(key, val){
						vDCcodigo = "";
						vDCdescripcion = "";
						$.each(val, function(key, val){
							if(key == 0)
								vDCcodigo = val;
							else if(key == 1)
								vDCdescripcion = val;
					 	});
					 	if(vDCcodigo != -1){ 
					 		elementHTML = '<div class="row '+vClass+'" id="'+vDCcodigo+'"><div class="col-xs-3"></div><div class="col-xs-1">'+vDCcodigo+'</div><div class="col-xs-4">'+vDCdescripcion+'</div><div class="col-xs-1"><a style="padding:0" class="btn" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="TcodigoListCg" value="'+vDCcodigo+'"/></div>';
					 		$('.detListCargas').append(elementHTML);

					 		if(!$('.detailCargas').is(':visible'))
								$('.detailCargas').delay(200).fadeIn(800);
					 	}
					}); 	
		       }
		    });
		}
	}	

	function fnDelElement(e){
		vGC = $(e).parent().parent().attr('class').split(' ')[1]; //obtiene clase del grupo carga asociado
		
		if(vGC == 'encGC'){
			vGC = $(e).parent().parent().attr('class').split(' ')[2]; //obtiene clase del grupo carga asociado
			$('.detailCargas .'+vGC).remove();
		}	

		$(e).parent().parent().remove();

		if($('.detailCargas .'+vGC).length == 1)
			$('.detailCargas .'+vGC).remove(); 

		if(!$('.detailCargas .detListCargas div').length)
			$('.detailCargas').hide(); 
	}

	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
		$(".detListCargas").empty();
		$('.listTree').listTree('deselectAll');
		$(".detailCargas, .divArbol").hide();
		$('#jtreeListaItem').val(<cfoutput>#session.Ecodigo#</cfoutput>);
		fnCargarListGC();
	}
</script>