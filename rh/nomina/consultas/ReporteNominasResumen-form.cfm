
<style type="text/css">
	.form-group { margin-bottom: 8px; }
	.divArbol, .detailTNom { display:none; } 
    .divArbol .listTree { width: 80% } 
    .periodo { margin-top: 15px; }
	.nomAplic, .periodo, .tpCalendarPG, .tpNomina, .lbCoorp, .radios { margin-bottom: 5px; }
	.periodo .lbPeriodo, .tpCalendarPG .lbTCP, .tpNomina .lbTpNom { margin-left: 15px; }
	.periodo .dtPeriodo { margin-left: 100px; }
	.periodo .dtPeriodo select { margin-right: 50px; }
	.tpCalendarPG .tiposCP { margin-left: 120px; }
	.tpCalendarPG .tiposCP label { margin-right: 30px; }
	.tpNomina div { float: left; }
	.tpNomina .conlist { margin-left: 8px; margin-right: 6px; }
	.detailTNom .listTNom { margin-top: 10px; }
	.encabezado, .detListTNom { width: 70%; }
	.encabezado div { background-color: #B0C8D3; padding-top: 6px; height: 28px; margin-bottom: 0; }
	.detListTNom .row, .detListTNom .row div { height: 34px; margin-bottom: 0; padding-top: 4px; }
	.detListTNom .row { padding-top: 2px; width: 100%; }
	.detListTNom .row:nth-child(2n) div { background-color: #ffffff; }
	.detListTNom .btn { margin-left: 20px; }
	.radios label { margin-right: 15px; }
    .btns { margin-bottom: 15px; }
</style>


<cfset t = createObject("component", "sif.Componentes.Translate")>
<!--- Etiquetas de traduccion --->
<cfset LB_NominasAplicadas = t.translate('LB_NominasAplicadas','Nóminas Aplicadas','/rh/generales.xml')>
<cfset LB_Periodo = t.translate('LB_Periodo','Periodo','/rh/generales.xml')>  
<cfset LB_Ano = t.translate('LB_Ano','Año','/rh/generales.xml')> 
<cfset LB_Mes = t.translate('LB_Mes','Mes','/rh/generales.xml')> 
<cfset LB_TipoCalendarioPago = t.translate('LB_TipoCalendarioPago','Tipo Calendario de Pago','/rh/generales.xml')>
<cfset LB_Normal = t.translate('LB_Normal','Normal','/rh/generales.xml')> 
<cfset LB_Especial = t.translate('LB_Especial','Especial','/rh/generales.xml')> 
<cfset LB_Anticipo = t.translate('LB_Anticipo','Anticipo','/rh/generales.xml')>
<cfset LB_Liquidacion = t.translate('LB_Liquidacion','Liquidación','/rh/generales.xml')>  
<cfset LB_TipoNomina = t.translate('LB_TipoNomina','Tipo de Nómina','/rh/generales.xml')> 
<cfset LB_ListaDeTiposNomina = t.translate('LB_ListaDeTiposNomina','Lista de Tipos de Nómina','/rh/generales.xml')>
<cfset LB_Tipo = t.translate('LB_Tipo','Tipo','/rh/generales.xml')> 
<cfset LB_Nomina = t.translate('LB_Nomina','Nómina','/rh/generales.xml')> 
<cfset LB_Codigo  = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Descripcion  = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset LB_TodasOpciones = t.translate('LB_TodasOpciones','Todas las opciones','/rh/generales.xml')> 
<cfset LB_Ingresos = t.translate('LB_Ingresos','Ingresos','/rh/generales.xml')> 
<cfset LB_Prestaciones = t.translate('LB_Prestaciones','Prestaciones','/rh/generales.xml')> 
<cfset LB_Deducciones = t.translate('LB_Deducciones','Deducciones','/rh/generales.xml')>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_ExportarExcel = t.translate('LB_ExportarExcel','Exportar a Excel')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')>
<cfset LB_Eliminar = t.translate('LB_Eliminar','Eliminar','/rh/generales.xml')>
<cfset LB_NoSeEncontraronRegistros  = t.translate('LB_NoSeEncontraronRegistros','No se Encontraron Registros','/rh/generales.xml')>
<cfset MSG_AddTipoNomina = t.translate('MSG_AddTipoNomina','Agrega el tipo de nómina seleccionada')>
<cfset MSG_ConsultarIPD = t.translate('MSG_ConsultarIPD','Consulta el resumen de ingresos, prestaciones y deducciones')>
<cfset MSG_ExportarIPD = t.translate('MSG_ExportarIPD','Exportar la información del resumen de ingresos, prestaciones y deducciones')>
<cfset MSG_Limpiar = t.translate('MSG_Limpiar','Limpia el formulario')>
<cfset MSG_TipoNomina = t.translate('MSG_TipoNomina','Debe seleccionar un tipo de nómina para agregar a la consulta')>
<cfset MSG_Nota = t.translate('MSG_Nota','Nota')>
<cfset MSG_Requeridos = t.translate('MSG_Requeridos','Para realizar la consulta se debe seleccionar los siguientes valores')>

<cfset anoActual = year(now())>
<cfset mesActual = month(now())> 

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


<cfif isdefined("form.sPeriodo") and len(trim(form.sPeriodo))>
    <cfset lvarPeriodo = form.sPeriodo >
<cfelseif isdefined("url.sPeriodo") and len(trim(url.sPeriodo))>
    <cfset lvarPeriodo = url.sPeriodo >    
<cfelseif isdefined("url.sPeriodo") or isdefined("form.sPeriodo")>
    <cfset lvarPeriodo = '' >     
<cfelse>
    <cfset lvarPeriodo = anoActual >    
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


<cfset rsMes = getMeses() > <!--- Obtiene los meses a utilizar --->

<cfoutput>
	<body>
		<form name="form1" action="ReporteNominasResumen-sql.cfm" method="post">
			<!--- Check nominas aplicadas --->
			<div class="form-group">
				<div class="col-sm-12 nomAplic">
					<label>	
						<input type="checkbox" name="chk_NominaAplicada" id="chk_NominaAplicada"> <strong>#LB_NominasAplicadas#</strong>
					</label>
				</div>
			</div>	

			<!--- Valida si esta habilitado las consultas corporativas --->
		    <cfif lvPmtConsCorp eq 1>
		        <!--- Check de consulta coorporativa --->
		        <div class="form-group lbCoorp">
		            <div class="col-sm-12" style="margin-left: -15px;">
		                <cf_rharbolempresas>
		            </div>  
		        </div>
		    <cfelse>
		    	<input type="hidden" name="jtreeListaItem" id="jtreeListaItem" value="#session.Ecodigo#">    
		    </cfif>    

			<!--- Seleccion del periodo(año/mes) --->
			<div class="form-group"> 	
				<div class="col-sm-12 periodo">
					<div class="lbPeriodo">
						<label><strong>#LB_Periodo#</strong></label>
					</div>
					<div class="dtPeriodo">	
						<label for="mes"><strong>#LB_Ano#</strong></label>
						<select name="sPeriodo">
	                        <cfloop query="#rsListYears#">
	                            <option value="#years#"<cfif isdefined("lvarPeriodo") and len(trim(lvarPeriodo))>
	                            		<cfif rsListYears.years eq lvarPeriodo> selected </cfif>
	                            	</cfif>>#years#
	                            </option>
	                        </cfloop>
						</select>
						<label for="mes"><strong>#LB_Mes#</strong></label>
						<select name="sMes">
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

	        <!--- Seleccion del Tipo de Calendario de Pago --->
	        <div class="form-group">
	        	<div class="col-sm-12 tpCalendarPG">
	        		<div class="lbTCP">
	        			<label><strong>#LB_TipoCalendarioPago#</strong></label>
					</div>
					<div class="tiposCP">
						<input type="checkbox" name="chkNormal" id="chkNormal" value="0">
			        	<label>#LB_Normal#</label>

			        	<input type="checkbox" name="chkEspecial" id="chkEspecial" value="1">
			        	<label>#LB_Especial#</label>

			        	<input type="checkbox" name="chkAnticipo" id="chkAnticipo" value="2">
			        	<label>#LB_Anticipo#</label>

			        	<input type="checkbox" name="chkLiquidacion" id="chkLiquidacion" value="5">
			        	<label>#LB_Liquidacion#</label>
			        </div>	
                    <!---<div class="tiposCP">
						<input type="checkbox" name="chkNormal" id="chkNormal" value="0">
			        	<label>#LB_Normal#</label>

			        	<input type="checkbox" name="chkEspecial" id="chkEspecial" value="1">
			        	<label>#LB_Especial#</label>

			        	<input type="checkbox" name="chkAnticipo" id="chkAnticipo" value="2">
			        	<label>#LB_Anticipo#</label>

			        	<input type="checkbox" name="chkLiquidacion" id="chkLiquidacion" value="5">
			        	<label>#LB_Liquidacion#</label>
			        </div>--->
	        	</div>
	        </div>	

	        <!--- Seleccion del Tipo de Nomina --->
	        <div class="form-group">	
	        	<div class="col-sm-12 tpNomina">
		        	<div class="lbTpNom">
						<label><strong>#LB_TipoNomina#:</strong></label>
					</div>
					<div class="conlist">	
						<cf_translatedata name="get" tabla="TiposNomina" col="Tdescripcion" returnvariable="LvarTdescripcion">
						<cf_conlis
					        campos="Tcodigo, Tdescripcion"
					        asignar="Tcodigo, Tdescripcion"
					        size="0,35"
					        desplegables="S,S"
					        modificables="S,N"						
					        title="#LB_ListaDeTiposNomina#"
					        tabla="TiposNomina"
					        columnas="distinct Tcodigo, #LvarTdescripcion# as Tdescripcion"
					        filtro="Ecodigo in ($jtreeListaItem,numeric$) order by #LvarTdescripcion#"
					        filtrar_por="Tcodigo, Tdescripcion"
					        desplegar="Tcodigo, Tdescripcion"
					        etiquetas="#LB_Codigo#, #LB_Descripcion#"
					        formatos="S,S"
					        align="left,left"								
					        asignarFormatos="S,S"
					        form="form1"
					        top="50"
					        left="200"
					        showEmptyListMsg="true"
					        EmptyListMsg=" --- #LB_NoSeEncontraronRegistros# --- "
					        tabindex="9"
					        pageindex="9"
					    />
					</div>	
					<div class="btnAddTpNom">
						<input type="button" class="btnNormal" value="+" onClick="fnAddSelect()">
					</div>
				</div>	
	        </div>	

	         <!--- Detalle de los tipos de nomina seleccionados --->
	        <div class="form-group detailTNom">
	        	<div class="col-sm-10 col-sm-offset-2 listTNom">
		        	<div class="row encabezado">
		        		<div class="col-sm-3"><label><strong>#LB_Tipo#</strong></label></div>
			            <div class="col-sm-9"><label><strong>#LB_Nomina#</strong></label></div>
		        	</div>	
					<div class="detListTNom">
					</div>	
				</div>
			</div>	

	        <!--- Filtro de consulta x ingresos, prestaciones y deducciones --->
	        <div class="form-group">
	        	<div class="col-sm-12 col-sm-offset-2 radios">
		        	<input type="radio" name="radRep" value="1" checked="checked">
		        	<label>#LB_TodasOpciones#</label>
					
					<input type="radio" value="2" name="radRep" tabindex="1"> 
					<label>#LB_Ingresos#</label>

					<input type="radio" value="3" name="radRep" tabindex="1"> 
					<label>#LB_Prestaciones#</label>

					<input type="radio" value="4" name="radRep"  tabindex="1"> 
					<label>#LB_Deducciones#</label>
				</div>	
	        </div>	

			<!--- Botones de acciones del reporte --->
			<div class="form-group"> 
		        <div class="col-sm-12 col-sm-offset-3 btns">
					<input type="submit" name="Consultar" class="btnConsultar" value="#LB_Consultar#" onClick="return fnValSubmit();">
					<input type="submit" name="Exportar" class="btnExportar" value="#LB_ExportarExcel#" onClick="return fnValSubmit();">
					<input type="reset" name="Limpiar" class="btnLimpiar" value="#LB_Limpiar#" onClick="fnLimpiar()">
		        </div>
	        </div>   
		</form>
	</body>
</cfoutput>


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

	// Funcion que valida si los elementos requeridos han sido suministrados por el usuario para realizar submit del form
	function fnValSubmit(){
		var result = true;
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> <cfoutput>#MSG_Requeridos#</cfoutput>:<br/><br/>';

		if($('select[name=sPeriodo]').val() == '' || $('select[name=sMes]').val() == ''){ 
			mensaje += '-> <cfoutput>#LB_Periodo#</cfoutput><br/>';
			result = false;
		}

		if(!$('#chkNormal').prop("checked") && !$('#chkEspecial').prop("checked") && !$('#chkAnticipo').prop("checked") && 
			!$('#chkLiquidacion').prop("checked")){
			mensaje += '-> <cfoutput>#LB_TipoCalendarioPago#</cfoutput><br/>';
			result = false;
		}	

		if(!$('.detailTNom').is(':visible')) {
			mensaje += '-> <cfoutput>#LB_TipoNomina#</cfoutput>';
			result = false;
		}

		if(!result)
			alert(mensaje);
			
		return result;
	}

	function fnAddSelect(){
		result = fnValidarElement("Tcodigo",'<cfoutput>#MSG_TipoNomina#</cfoutput>');

		if(result)
			fnAddElement();
	}

	function fnValidarElement(e,showMsg){
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> ';
		var result = true;

		if (document.getElementById(e).value == ''){
			mensaje += showMsg;
			result = false;
			alert(mensaje);
		}
		return result;
	}

	function fnAddElement(){
		var elementHTML = "", vCodigo = "", vDescripcion = "", vID = "", vClass = "", vCodListName = "", vDetListName = "";

		vCodigo = $('#Tcodigo').val().trim(); 
		vDescripcion = $('#Tdescripcion').val().trim(); 
		vID = vCodigo;
		vClass = 'tnom'+vID;
		vCodListName = 'ListaTipoNomina';
		vDetListName = 'detListTNom';	

		if($('.'+vClass).length == 0){	
			elementHTML = '<div class="row '+vClass+'"><div class="col-xs-3">'+vCodigo+'</div><div class="col-xs-8">'+vDescripcion+'</div><div class="col-xs-1"><a style="cursor: pointer" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="'+vCodListName+'" value="'+vID+'"/></div>';

			$('.'+vDetListName).append(elementHTML);

	 		if(!$('.'+vDetListName).parent().parent().is(':visible'))
				$('.'+vDetListName).parent().parent().show();

			$('#Tcodigo, #Tdescripcion').val(''); 
		}	
	}

	function fnDelElement(e){
		var detList = $(e).parent().parent().parent();

		$(e).parent().parent().remove();
		
		if(!$(detList).children().length > 0)
			$(detList).parent().parent().hide();
	}

	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
		$(".detListTNom").empty();
		$(".detailTNom, .divArbol").hide();
		$('.listTree').listTree('deselectAll');
		$('#jtreeListaItem').val(<cfoutput>#session.Ecodigo#</cfoutput>);
	}
</script>