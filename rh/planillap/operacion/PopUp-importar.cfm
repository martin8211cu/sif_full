<!---- /////////////////////// PROCESO DE IMPORTACION /////////////////// ----->
<cfif isdefined("form.btn_importar")>		
	<cftransaction>		
		<!---Actualizar el campo de calculado para indicar que se han echo cambios luego de calcular el escenario--->
		<cfquery name="updateEstadoEscenario" datasource="#session.DSN#">
			update RHEscenarios
				set RHEcalculado = 0
			where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		</cfquery>
		<!---Obtener la moneda de la empresa---->
		<cfquery name="rsMoneda" datasource="#session.DSN#">
			select Mcodigo
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<!----<cfif isdefined("form.RHVTid") and len(trim(form.RHVTid))>----->
		<cfif isdefined("form.opt_importacion") and len(trim(form.opt_importacion)) and form.opt_importacion EQ 'T'>
			<!----Validar que hayan datos en el encabezado---->
			<cfquery name="ValidaEncab" datasource="#session.DSN#">
				select 1 from RHVigenciasTabla 
				where  Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
			</cfquery>
			<cfquery name="ValidaDet" datasource="#session.DSN#">
				select 1 
				from RHVigenciasTabla a
					left outer join RHMontosCategoria b
						on a.RHVTid = b.RHVTid
					left outer join RHCategoriasPuesto c
						on b.RHCid = c.RHCid
				where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
			</cfquery>			
		<!----<cfelse>---->
		<cfelseif isdefined("form.opt_importacion") and len(trim(form.opt_importacion)) and form.opt_importacion EQ 'E'>
			<cfquery name="ValidaEncab" datasource="#session.DSN#">
				select 1 from RHETablasEscenario a
				where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid1#">
			</cfquery>
			<cfquery name="ValidaDet" datasource="#session.DSN#">
				select 1 
				from RHDTablasEscenario a
				where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid1#">
			</cfquery>
		</cfif>		
		<cfif ValidaEncab.RecordCount NEQ 0 and ValidaDet.RecordCount NEQ 0>
			<!---Validar que no exista ya una tabla que contenga las fechas digitadas---->
			<cfquery name="validaFechas" datasource="#session.DSN#">
				select count(1) as Tablas
				from RHETablasEscenario a
				where a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
					and a.RHETEfdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhasta)#">
					and a.RHETEfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">
					
					<cfif isdefined("form.RHVTid") and len(trim(form.RHVTid)) >
						<cfif isdefined("form.opt_importacion") and len(trim(form.opt_importacion)) and form.opt_importacion EQ 'T'>
							and RHTTid = ( select RHTTid 
										   from RHVigenciasTabla 
										   where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#"> )
						<cfelseif isdefined("form.opt_importacion") and len(trim(form.opt_importacion)) and form.opt_importacion EQ 'E'>
							and RHTTid = ( 	select RHTTid 
											from RHETablasEscenario 
											where RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#"> )
						</cfif>	   
					</cfif>								
			</cfquery>

			<cfif validaFechas.Tablas EQ 0>				
				<!----Inserta en el encabezado (RHETablasEscenario)------>								
				<cfquery name="insertaEncabezado" datasource="#session.DSN#">				
					insert into RHETablasEscenario(RHEid, 
													RHTTid, 
													Ecodigo, 
													RHETEdescripcion, 
													RHETEesctabla, 
													RHETEescenarioori, 
													RHETEtablavig, 
													RHETEvariacion, 
													RHETEfdesde, 
													RHETEfhasta, 
													RHETEcriterio, 
													BMfecha, 
													BMUsucodigo)
						<cfif isdefined("form.opt_importacion") and len(trim(form.opt_importacion)) and form.opt_importacion EQ 'T'>
							select	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,							
									a.RHTTid,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									a.RHVTdescripcion,	
									'T',
									null,
									a.RHTTid,
									<cfqueryparam cfsqltype="cf_sql_float" value="#form.variacion#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">,	
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhasta)#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#form.redondeo#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">				
							from RHVigenciasTabla a
							where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
						<!----<cfelseif isdefined("form.RHEid1") and len(trim(form.RHEid1))>---->
						<cfelseif isdefined("form.opt_importacion") and len(trim(form.opt_importacion)) and form.opt_importacion EQ 'E'>
							select	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,
									c.RHTTid,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									c.RHETEdescripcion,	
									'E',
									c.RHEid,
									null,
									<cfqueryparam cfsqltype="cf_sql_float" value="#form.variacion#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">,	
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhasta)#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#form.redondeo#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">										
							from RHETablasEscenario c
							where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">							
								and c.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid1#">
								and c.RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
						</cfif>	
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insertaEncabezado">
				
				<cfif insertaEncabezado.RecordCount NEQ 0>
					<!------Inserta en el detalle (RHDTablasEscenario)------>
					<cfquery name="rsDetalle" datasource="#session.DSN#">
						insert into RHDTablasEscenario(Ecodigo, 
														RHETEid, 
														RHEid, 
														RHTTid, 
														RHMPPid, 
														RHCid, 
														CSid,
														RHDTEmonto, 
														Mcodigo, 
														RHDTEfdesde, 
														RHDTEfhasta, 
														BMfecha, 
														BMUsucodigo)
						<cfif isdefined("form.opt_importacion") and len(trim(form.opt_importacion)) and form.opt_importacion EQ 'T'>
							select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertaEncabezado.Identity#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,	
									c.RHTTid,
									c.RHMPPid,
									c.RHCid,
									(select CSid
									from ComponentesSalariales
									where Ecodigo = a.Ecodigo
									  and CSsalariobase = 1),
									<cfif isdefined("form.redondeo") and len(trim(form.redondeo)) and form.redondeo EQ 1>
										round((((coalesce(<cfqueryparam cfsqltype="cf_sql_float" value="#form.variacion#">,0) * b.RHMCmonto/100)+ b.RHMCmonto)/#form.UnidadRedondeo#)* #form.UnidadRedondeo#,0) as Redondeo,
									<cfelseif isdefined("form.redondeo") and len(trim(form.redondeo)) and form.redondeo EQ 2>
										ceiling(((((coalesce(<cfqueryparam cfsqltype="cf_sql_float" value="#form.variacion#">,0) * b.RHMCmonto)/100) + b.RHMCmonto)/#form.UnidadRedondeo#) * #form.UnidadRedondeo#) as Arriba,
									<cfelseif isdefined("form.redondeo") and len(trim(form.redondeo)) and form.redondeo EQ 3>
										floor(((((coalesce(<cfqueryparam cfsqltype="cf_sql_float" value="#form.variacion#">,0) * b.RHMCmonto)/100)+ b.RHMCmonto)/#form.UnidadRedondeo#)* #form.UnidadRedondeo#) as Abajo,
									</cfif>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.Mcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhasta)#">,							
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							from RHVigenciasTabla a
								inner join RHMontosCategoria b
									on a.RHVTid = b.RHVTid
								inner join RHCategoriasPuesto c
									on b.RHCid = c.RHCid 
									and a.RHTTid = c.RHTTid
							where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
						<cfelseif isdefined("form.opt_importacion") and len(trim(form.opt_importacion)) and form.opt_importacion EQ 'E'>
							select	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertaEncabezado.Identity#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,	
									a.RHTTid,
									a.RHMPPid,
									a.RHCid,
									a.CSid,
									<cfif isdefined("form.redondeo") and len(trim(form.redondeo)) and form.redondeo EQ 1>
										round((((<cfqueryparam cfsqltype="cf_sql_float" value="#form.variacion#"> * a.RHDTEmonto/100)+ a.RHDTEmonto)/#form.UnidadRedondeo#)* #form.UnidadRedondeo#,0) as Redondeo,
									<cfelseif isdefined("form.redondeo") and len(trim(form.redondeo)) and form.redondeo EQ 2>
										ceiling(((((<cfqueryparam cfsqltype="cf_sql_float" value="#form.variacion#"> * a.RHDTECmonto)/100) + a.RHDTEmonto)/#form.UnidadRedondeo#) * #form.UnidadRedondeo#) as Arriba,
									<cfelseif isdefined("form.redondeo") and len(trim(form.redondeo)) and form.redondeo EQ 3>
										floor(((((<cfqueryparam cfsqltype="cf_sql_float" value="#form.variacion#"> * a.RHDTEmonto)/100)+ a.RHDTEmonto)/#form.UnidadRedondeo#)* #form.UnidadRedondeo#) as Abajo,
									</cfif>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.Mcodigo#">,							
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fhasta)#">,							
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">				
							from RHDTablasEscenario a
							where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid1#">
								and a.RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
						</cfif>		
					</cfquery><!---<cf_dump var="#insertaEncabezado#">--->
				</cfif>
			<cfelse>			
				<script type="text/javascript" language="javascript1.2">
					alert("Ya existe una tabla salarial para ese rango de fechas");
				</script>
			</cfif>			
		</cfif><!---- Fin de validacion de fechas digitadas ----->				
	</cftransaction>
	<script type="text/javascript" language="javascript1.2">
		window.opener.document.location.href = "TS-Tabla.cfm?RHEid="+<cfoutput>#form.RHEid#</cfoutput>;
		window.close();
	</script>
</cfif>
<cf_templatecss>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>	
<script type="text/javascript" language="javascript1.2">
	var popUpWin2 = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin2){
			if(!popUpWin2.closed) popUpWin2.close();
		}
		popUpWin2 = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function funcMuestra(prv_opcion){

		if (prv_opcion == 'E'){
			var Escenario   = document.getElementById("Escenario");
			var Tabla   = document.getElementById("Tabla");
			
			var Complemento1   = document.getElementById("Complemento1");
			var Complemento2   = document.getElementById("Complemento2");
			var Complemento3   = document.getElementById("Complemento3");
			var Complemento4   = document.getElementById("Complemento4");
			var Complemento5   = document.getElementById("Complemento5");
			var Complemento6   = document.getElementById("Complemento6");
			
			var Archivo   = document.getElementById("Archivo");
			Tabla.style.display = '';
			Escenario.style.display = '';
			
			Complemento1.style.display = '';
			Complemento2.style.display = '';
			Complemento3.style.display = '';
			Complemento4.style.display = '';
			Complemento5.style.display = '';
			Complemento6.style.display = '';
			
			Archivo.style.display = 'none';
			document.form1.RHVTid.options.length = 0;			
			document.form1.RHVTid.value = '';
		}
		else{
			if(prv_opcion == 'T'){
				llenarTabla();

				var Escenario   = document.getElementById("Escenario");
				var Tabla   = document.getElementById("Tabla");
				var Archivo   = document.getElementById("Archivo");
				
				var Complemento1   = document.getElementById("Complemento1");
				var Complemento2   = document.getElementById("Complemento2");
				var Complemento3   = document.getElementById("Complemento3");
				var Complemento4   = document.getElementById("Complemento4");
				var Complemento5   = document.getElementById("Complemento5");
				var Complemento6   = document.getElementById("Complemento6");
			
				Tabla.style.display = '';
			
				Complemento1.style.display = '';
				Complemento2.style.display = '';
				Complemento3.style.display = '';
				Complemento4.style.display = '';
				Complemento5.style.display = '';
				Complemento6.style.display = '';
			
				Escenario.style.display = 'none';
				Archivo.style.display = 'none';	
				document.form1.RHEid1.value = '';
				document.form1.RHEdescripcion.value = '';					
				document.form1.RHEid1.value = '';
				document.form1.RHEdescripcion.value = '';
			}
			else{
				var Escenario   = document.getElementById("Escenario");
				var Tabla   = document.getElementById("Tabla");
				var Archivo   = document.getElementById("Archivo");
				
				var Complemento1   = document.getElementById("Complemento1");
				var Complemento2   = document.getElementById("Complemento2");
				var Complemento3   = document.getElementById("Complemento3");
				var Complemento4   = document.getElementById("Complemento4");
				var Complemento5   = document.getElementById("Complemento5");
				var Complemento6   = document.getElementById("Complemento6");
			
				Tabla.style.display = 'none';	
				Escenario.style.display = 'none';
			
				Complemento1.style.display = 'none';
				Complemento2.style.display = 'none';
				Complemento3.style.display = 'none';
				Complemento4.style.display = 'none';
				Complemento5.style.display = 'none';
				Complemento6.style.display = 'none';
			

				Archivo.style.display = '';
			}
		}	
	}
	
	function funcValidaciones(){
		var fechadesde = document.form1.fdesde.value.split('/'); 		//Fecha desde seleccionada
		var fechahasta = document.form1.fhasta.value.split('/');		//Fecha hasta seleccionada
		var RHEfdesde  =  document.form1.RHEfdesde.value.split('/');	//Fecha desde escenario
		var RHEfhasta  =  document.form1.RHEfhasta.value.split('/');	//Fecha hasta escenarios
		/*funValidaVariacion(document.form1.variacion.value)*/
		if (parseFloat(document.form1.variacion.value) > 100 || parseFloat(document.form1.variacion.value) < 0){
			alert("El porcentaje de variación debe estar entre 0% y 100%");
			document.form1.variacion.value = '0.00';
			return false;
		}
		if ((fechadesde[2]+fechadesde[1]+fechadesde[0] < RHEfdesde[2]+RHEfdesde[1]+RHEfdesde[0]) || (fechahasta[2]+fechahasta[1]+fechahasta[0] > RHEfhasta[2]+RHEfhasta[1]+RHEfhasta[0])){
			alert("El rango de fechas está fuera del rango de fechas del Escenario");
			return false;
		}
		if (document.form1.opt_importacion[1].checked){	//Importar tabla
			if (document.form1.RHEid1.value == '' || document.form1.RHVTid.value == ''){
				alert("Debe seleccionar el escenario y la tabla");
				return false;
			}
		}
		else{											//Importar Escenario
			if (document.form1.RHVTid.value == ''){
				alert("Debe seleccionar la tabla");
				return false;
			}
		}		
		return true;				
	}
	function funcCargaCombo(){
		document.getElementById("Busqueda").src="BuscaTablasEscenario.cfm?RHEid="+document.form1.RHEid1.value+'&RHEfhasta='+document.form1.RHEfhasta.value+'&RHEfdesde='+document.form1.RHEfdesde.value;
	}
	
	function doConlisEscenarios(){
		popUpWindow("../operacion/ConlisEscenarios.cfm?formulario=form1&idx=1",10,35,1000,600);
	}
	
</script>
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<!-----//////////////////////////////////////////////////////////////////////////////////
		Tablas Vigentes (Combo) Contenidas dentro del rango de fechas del escenario
		cuando se selecciona la opcion TABLAS 
/////////////////////////////////////////////////////////////////////////////////////////----->
<!---
<cfquery name="rsTablasVigentes" datasource="#session.DSN#">
	select 	a.RHVTid,
			a.RHVTcodigo,
			a.RHVTdescripcion,
			a.RHVTfecharige,
			a.RHVTfechahasta,
			b.RHTTcodigo,
			b.RHTTdescripcion
	from RHVigenciasTabla a
		inner join RHTTablaSalarial b
			on a.RHTTid = b.RHTTid 
			and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHVTestado = 'A'
		<!---
		and a.RHVTfecharige <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.RHEfhasta)#">
		and a.RHVTfechahasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.RHEfdesde)#">		
		--->
		<!----and exists(select 1 
						from RHETablasEscenario z
						where z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and z.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">
							and a.RHVTfecharige <= z.RHETEfhasta
							and a.RHVTfechahasta >= z.RHETEfdesde
						)								
		and a.RHTTid not in (select RHETEtablavig
							from RHETablasEscenario
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">)----->		
</cfquery>
--->
<cfquery name="rsTablasVigentes" datasource="#session.DSN#">
	select 	a.RHTTid,
			a.RHVTid,
			a.RHVTcodigo,
			a.RHVTdescripcion,
			a.RHVTfecharige,
			a.RHVTfechahasta,
			b.RHTTcodigo,
			b.RHTTdescripcion
	from RHVigenciasTabla a
		inner join RHTTablaSalarial b
			on a.RHTTid = b.RHTTid 
			and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHVTestado = 'A'
   	order by a.RHVTfecharige desc

<!--- 2010-12-14 ljimenez se abre la opcion de seleccionar cualquier tabla siempre y cuando este aplicada
	solicitud de requeriemiento Ana Villa y Roy Tenorio --->
<!--- and a.RHVTfecharige = (select max(RHVTfecharige)
						  from RHVigenciasTabla
						  where RHTTid=a.RHTTid 
				  		    and RHVTestado = 'A'
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )

		and a.RHTTid not in (select RHETEtablavig
							from RHETablasEscenario
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">) 
                            --->
                        
</cfquery>

<cfoutput>
<form name="form1" action="" method="post" onsubmit="javascrip: return funcValidaciones();">
	<input type="hidden" name="RHEfdesde" value="#url.RHEfdesde#">	<!----Fecha desde del escenario----->
	<input type="hidden" name="RHEfhasta" value="#url.RHEfhasta#">	<!----Fecha hasta del escenario----->
	<input type="hidden" name="RHEid" value="#url.RHEid#">			<!----LLave del escenario (RHEid)----->
	<table width="100%" cellpadding="0" cellspacing="0" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="3" align="center"><strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Importaci&oacute;n de Tablas Salariales</strong></td></tr>
		<tr><td colspan="3" align="center">
			<table width="95%" align="center"><tr><td>
			<hr>
			</td></tr></table>
		</td></tr>
		<tr><td>&nbsp;</td></tr>		
		<tr>
			<td>&nbsp;</td>
			<td width="97%" colspan=""><strong style="color:##003366;font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px">Opciones de Importaci&oacute;n:</strong></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="3%">&nbsp;</td>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0"><tr>
				  <td width="3%">&nbsp;</td>
				  <td width="97%"><input type="radio" name="opt_importacion" value="T" onClick="javascript: funcMuestra('T');"  checked><label><strong>Importar una Tabla</strong></label></td>
				</tr></table>
			</td>
		</tr>
		<tr>
			<td width="3%">&nbsp;</td>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0"><tr>
					<td width="3%">&nbsp;</td>
					<td><input type="radio" name="opt_importacion" value="E" onClick="javascript: funcMuestra('E');"><label><strong>Importar Tabla de un Escenario</strong></label></td>	  
				</tr></table>
			</td>
		</tr>	
		<tr>
			<td width="3%">&nbsp;</td>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0"><tr>
					<td width="3%">&nbsp;</td>
					<td><input type="radio" name="opt_importacion" value="A" onClick="javascript: funcMuestra('A');"><label><strong>Importar Tabla de Archivo Plano</strong></label></td>	  
				</tr></table>
			</td>
		</tr>	
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr  class="ListaCorte">
			<td width="3%">&nbsp;</td>
			<td><strong style="color:##003366;font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px">Parámetros:</strong></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="left">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="left">
					<tr id="Escenario" style="display:none;">
						<td>&nbsp;</td>
						<td align="right" nowrap="nowrap" height="25" width="30%"><strong>Escenario:&nbsp;</strong></td>
						<td>
							<input name="RHEid1" type="hidden" value="<cfif isDefined("form.RHEid")>#form.RHEid#</cfif>">
						  	<input name="RHEdescripcion1" type="text" value="<cfif isDefined("form.fCMTSdescripcion")>#form.fCMTSdescripcion#</cfif>" size="40" readonly>
						  	<a href="##" tabindex="-1"> <img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Escenarios" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisEscenarios();"> </a> 
							<!----<cf_conlis 
								campos="RHEid1,RHEdescripcion"
								asignar="RHEid1,RHEdescripcion"
								size="0,30"
								desplegables="N,S"
								modificables="N,N"						
								title="Lista de Escenarios"
								tabla="RHEscenarios "
								columnas="	RHEid as RHEid1,
											RHEdescripcion,
											RHEfdesde,
											RHEfhasta,
											case RHEestado 	when 'A' then 'Aprobado'
					  										when 'R' then 'Rechazado'
											else 'En proceso' end as RHEestado"
								filtro="Ecodigo = #Session.Ecodigo#										
										Order by RHEdescripcion"
								filtrar_por="RHEdescripcion,RHEfdesde,RHEfhasta,case RHEestado 	when 'A' then 'Aprobado'
					  										when 'R' then 'Rechazado'
											else 'En proceso' end"
								desplegar="RHEdescripcion,RHEfdesde,RHEfhasta,RHEestado"
								etiquetas="Descripci&oacute;n, Fecha desde, Fecha Hasta, Estado"
								formatos="S,D,D,S"
								align="left,left,left,left"								
								asignarFormatos="S,S"
								form="form1"
								width = "900"
								showEmptyListMsg="true"
								EmptyListMsg=" --- No se encontraron registros --- "
								funcion="funcCargaCombo()"
							/>--->						
					  </td>
					</tr>					
					<tr id="Tabla" style="display:;">
						<td width="3%">&nbsp;</td>
						<td align="right" height="25" nowrap="nowrap" width="30%"><strong>Tabla:&nbsp;</strong></td>
						<td>
							<select name="RHVTid" id="RHVTid">
								<cfloop query="rsTablasVigentes">
									<option value="#rsTablasVigentes.RHVTid#">#HTMLEditFormat(rsTablasVigentes.RHVTcodigo)# - #HTMLEditFormat(rsTablasVigentes.RHTTdescripcion)# - #HTMLEditFormat(rsTablasVigentes.RHVTdescripcion)#</option>
								</cfloop>
							</select>						
						</td>
					</tr>

					<tr id="Complemento1" style="display:;">
						<td width="3%">&nbsp;</td>
						<td align="right" nowrap="nowrap"><strong>% Variaci&oacute;n:&nbsp;</strong></td>
						<td>
							<input type="text" name="variacion" value="0.00"  size="15" maxlength="30" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
						</td>
					</tr>
					
					<tr id="Complemento2" style="display:;">
						<td width="3%">&nbsp;</td>
						<td align="right" nowrap="nowrap"><strong>Unidad de redondeo:&nbsp;</strong></td>
						<td>
							<input type="text" name="UnidadRedondeo" value="0.01"  size="15" maxlength="30" style="text-align: right;" onBlur="javascript:fm(this,2); funcValidaRedondeo(this.value); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
						</td>
					</tr>
					
					<tr id="Complemento3" style="display:;">
						<td width="3%">&nbsp;</td>
						<td align="right" nowrap="nowrap"><strong>Criterio de redondeo:&nbsp;</strong></td>
						<td>
							<select name="redondeo" id="redondeo">
								<option value="1">Mas cercano</option>
								<option value="2">Hacia arriba</option>
								<option value="3">Hacia abajo</option>
							</select>
						</td>
					</tr>	
									
					<tr  id="Complemento4" style="display:;">
						<td width="3%">&nbsp;</td>
						<td align="right" nowrap="nowrap"><strong>Fecha desde:&nbsp;</strong></td>
						<td>
							<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fdesde">
						</td>
					</tr>
					
					<tr id="Complemento5" style="display:;">						
						<td width="3%">&nbsp;</td>
						<td align="right" nowrap="nowrap"><strong>Fecha hasta:&nbsp;</strong></td>
						<td>
							<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fhasta" >
						</td>
					</tr>
					
					<tr id="Complemento6" style="display:;">						
						<td colspan="3" align="center"><br>
							<input type="submit" name="btn_importar" value="Importar">
							<input type="button" name="btn_cerrar" value="Cerrar" onclick="javascript: window.close();">
						</td>
					</tr>

					<tr id="Archivo" style="display:none;">
						<td colspan="3" align="center">
						<cfset session.RHEid = url.RHEid>
						<table width="80%">
							<tr>
								<td align="right" valign="top" width="70%" >
									<cf_sifFormatoArchivoImpr EIcodigo = 'RHPPTE'>
								</td>
								<td align="left" style="padding-left: 15px"valign="top" width="25%">
									<cf_sifimportar EIcodigo="RHPPTE" mode="in"/>
								</td>
								<td align="left" style="padding-left: 15px " valign="top" width="5%">
									<input type="button" name="btn_cerrar" value="Cerrar" onclick="javascript: window.opener.location.reload(); window.close();">
								</td>
							</tr>
						</table>
						</td>
					</tr>
			  </table>
			</td>
		</tr>
	</table>
	<iframe id="Busqueda" name="Busqueda" width="0" height="0"></iframe>	
</form>
</cfoutput>
<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.fhasta.description="Fecha Hasta";				
	objForm.fdesde.description="Fecha Desde";	
	objForm.redondeo.description="Redondeo";	
	objForm.variacion.description="Porcentaje de Variación";

	objForm.fhasta.required = true;
	objForm.fdesde.required = true;
	objForm.redondeo.required = true;
	objForm.variacion.required = true;	
	
	function funValidaVariacion(prn_valor){
		if (parseFloat(prn_valor) > 100 || parseFloat(prn_valor) == 0){
			alert("El porcentaje de variación debe estar entre 1% y 100%");
			document.form1.variacion.value = 0;
			return false;
		}
	}
	function funcValidaRedondeo(prn_redondeo){
		if (parseFloat(prn_redondeo) <= 0){
			alert("La unidad de redondeo debe ser mayor a 0.00");
			document.form1.UnidadRedondeo.value = parseFloat('0.01');
		}
	}
	
	function llenarTabla(){
		window.document.form1.RHVTid.options.length = 0;
		 var i = 0;
		<cfoutput query="rsTablasVigentes">
			window.parent.document.form1.RHVTid.options.length++;
			window.parent.document.form1.RHVTid.options[i].text = '#JSStringFormat(rsTablasVigentes.RHVTdescripcion)#';
			window.parent.document.form1.RHVTid.options[i].value = '#rsTablasVigentes.RHVTid#';
			i++;
		 </cfoutput>
	}
	
</script>
