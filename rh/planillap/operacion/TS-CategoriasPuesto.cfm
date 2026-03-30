<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cf_templatecss>

<cfparam name="url.RHEid" default="0">
<cfparam name="url.RHETEid" default="0">

<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>
	<cfset url.RHEid = form.RHEid>
</cfif>
<cfif isdefined("form.RHETEid") and len(trim(form.RHETEid))>
	<cfset url.RHETEid = form.RHETEid>
</cfif>

<!--- CONSULTAS --->
<cfif isdefined('form.Guardar')>
	<cftransaction>
		<cfloop list="#form.RHDTEid#" index="i">				
			<cfquery datasource="#session.DSN#">
				update RHDTablasEscenario 
					set RHDTEmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['RHDTEmonto_#i#'],',','','all')#">
					<cfif isdefined("form.fdesde_#i#") and len(trim(form['fdesde_#i#']))>
						, RHDTEfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form['fdesde_#i#'])#">
					</cfif>
					<cfif isdefined("form.fhasta_#i#") and len(trim(form['fhasta_#i#']))>
						, RHDTEfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form['fhasta_#i#'])#">
					</cfif>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHDTEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">						
			</cfquery>
		</cfloop>
	</cftransaction>		
</cfif>

<cfif (isdefined("url.RHETEid") and len(trim(url.RHETEid))) and (isdefined("url.RHEid") and len(trim(url.RHEid)))>
	<!----Datos de la tabla salarial---->
	<cfquery name="rsTabla" datasource="#session.DSN#">
		select RHETEdescripcion from RHETablasEscenario
		where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHETEID#">
			and RHEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">
	</cfquery>
	<!----Fechas del escenario--->
	<cfquery name="rsEscenario" datasource="#session.DSN#">	
		select RHEfdesde, RHEfhasta from RHEscenarios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">
	</cfquery>
	<!----Categorias de la tabla salarial seleccionada---->
	<cfquery name="rsCategoriasPuestos" datasource="#session.DSN#">
		select 	distinct a.RHCid, a.RHMPPid,
			<cf_dbfunction name="concat" args="ltrim(rtrim(b.RHCcodigo)),'-',ltrim(rtrim(b.RHCdescripcion))"> as Categoria,
			<cf_dbfunction name="concat" args="c.RHMPPcodigo ,'-',c.RHMPPdescripcion"> as Puesto,
			RHDTEmonto,RHDTEfdesde,RHDTEfhasta,RHDTEid
		from RHDTablasEscenario a
			inner join RHCategoria b
				on a.RHCid = b.RHCid
				and a.Ecodigo = b.Ecodigo
			inner join RHMaestroPuestoP c
				on a.RHMPPid = c.RHMPPid
				and a.Ecodigo = c.Ecodigo		
		where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHETEID#">
			and a.RHEid  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">
			<cfif isdefined("form.RHCcodigo") and len(trim(form.RHCcodigo))>
				and b.RHCcodigo like '%#form.RHCcodigo#%'
			</cfif>
			<cfif isdefined("form.RHCdescripcion") and len(trim(form.RHCdescripcion))>
				and upper(b.RHCdescripcion) like upper('%#form.RHCdescripcion#%')
			</cfif>			
		order by a.RHCid
	</cfquery>
	<cfset vn_llaves = ValueList(rsCategoriasPuestos.RHDTEid)>
</cfif>

<form name="form2" action="" method="post">
	<cfoutput>
	<input type="hidden" name="RHEid" value="<cfif isdefined("url.RHEid") and len(trim(url.RHEid))>#url.RHEid#</cfif>">
	<input type="hidden" name="RHETEid" value="<cfif isdefined("url.RHETEid") and len(trim(url.RHETEid))>#url.RHETEid#</cfif>">	
	<input type="hidden" name="RHEfdesde" value="<cfif isdefined("rsEscenario") and rsEscenario.RecordCount NEQ 0>#DateFormat(rsEscenario.RHEfdesde,'dd/mm/yyyy')#</cfif>">
	<input type="hidden" name="RHEfhasta" value="<cfif isdefined("rsEscenario") and rsEscenario.RecordCount NEQ 0>#DateFormat(rsEscenario.RHEfhasta,'dd/mm/yyyy')#</cfif>">
	 <input type="hidden" name="vn_llaves" value="<cfif isdefined("vn_llaves")>#vn_llaves#</cfif>"> 
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">  
	  <tr class="tituloListas">
		<td >
			<strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">
				Tabla Salarial:&nbsp;<cfif isdefined("url.RHETEID") and rsTabla.RecordCount NEQ 0>#rsTabla.RHETEdescripcion#</cfif>
			</strong>
		</td>
		<td align="right">
			<cf_botones names="Exportar,Guardar,Anterior" values="Exportar,Modificar,Anterior">
		</td>
	  </tr>  
	</cfoutput>	
	  <tr>
		<td valign="top" colspan="2">
			<fieldset><legend align="center" style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Detalle de Categor&iacute;as/Puesto</legend>
			<table width="100%" cellpadding="0" cellspacing="0" >
				<cfoutput>
				<tr class="tituloListas">
					<td width="6%" align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
					<td width="19%"><input type="text" name="RHCcodigo" value="<cfif isdefined("form.RHCcodigo") and len(trim(form.RHCcodigo))>#form.RHCcodigo#</cfif>"></td>
					<td width="9%" align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
				  	<td width="22%"><input type="text" name="RHCdescripcion" value="<cfif isdefined("form.RHCdescripcion") and len(trim(form.RHCdescripcion))>#form.RHCdescripcion#</cfif>"></td>
					<td width="20%">
						<cf_botones names="Filtrar" values="Filtrar">
			  	  	</td>					
				</tr>				
				</cfoutput>	
				<tr class="tituloListas"><td colspan="7">&nbsp;</td></tr>
				<tr>
					<td colspan="7">
						<table width="100%" cellpadding="1" cellspacing="0">																					
							<cfset vs_corte = ''>
							<cfif isdefined("rsCategoriasPuestos") and rsCategoriasPuestos.RecordCount NEQ 0>
								<cfoutput query="rsCategoriasPuestos" group="RHCid">
									<tr>
										<td width="4%" class="titulocorte">&nbsp;</td>	
										<td colspan="2" class="titulocorte">
											<strong>
												Categoría:&nbsp;&nbsp;#rsCategoriasPuestos.Categoria#
											</strong>
										</td>
									</tr>
									<tr class="titulocorte">
											<td colspan="2">&nbsp;</td>	
											<td><strong><cf_translate key="LB_Puesto">Puesto</cf_translate></strong></td>
											<td><strong><cf_translate key="LB_FechaDesde">Fecha Desde</cf_translate></strong></td>
											<td><strong><cf_translate key="LB_FechaHasta">Fecha Hasta</cf_translate></strong></td>
											<td align="right"><strong><cf_translate key="LB_SalarioBase">Salario Base</cf_translate></strong></td>
										</tr>
									<cfoutput>
									<!--- onclick="javascript: window.parent.funcMuestraComponentes('#url.RHEid#','#url.RHETEid#','#rsCategorias.RHCid#','#rsPuestos.RHMPPid#');" style="cursor:pointer;" --->
									<tr class="<cfif rsCategoriasPuestos.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
										<td width="4%">&nbsp;</td><td width="4%">&nbsp;</td>
										<td>#rsCategoriasPuestos.Puesto#</td>
										<td width="10%">
											<cf_sifcalendario conexion="#session.DSN#" form="form2" name="fdesde_#rsCategoriasPuestos.RHDTEid#" value="#LSDateFormat(rsCategoriasPuestos.RHDTEfdesde,'dd/mm/yyyy')#">							</td>
										<td width="10%">
											<cf_sifcalendario conexion="#session.DSN#" form="form2" name="fhasta_#rsCategoriasPuestos.RHDTEid#" value="#LSDateFormat(rsCategoriasPuestos.RHDTEfhasta,'dd/mm/yyyy')#">							</td>
										<td align="right" width="20%">					
											<cf_inputNumber name="RHDTEmonto_#rsCategoriasPuestos.RHDTEid#" value="#rsCategoriasPuestos.RHDTEmonto#" decimales="2" modificable="true" tabindex="3" style="background-color: transparent;">
										</td>									
									</tr>
									<input type="hidden" name="RHDTEid" value="#rsCategoriasPuestos.RHDTEid#">
									</cfoutput>
								</cfoutput>
							<cfelse>						
								<tr><td colspan="4" align="center"><strong>------  No hay categor&iacute;as/puesto asignadas al escenario ------</strong></td></tr>									
							</cfif>						
						</table>
					</td>
				</tr>
			   <tr><td colspan="4">&nbsp;</td></tr>	  
			</table>
			</fieldset>	
		</td>
		</tr>
	</TABLE>
</form>
<script type="text/javascript" language="javascript1.2">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function funcComponentesMasivos(){
		/*Valores de prs_origen = 	tablas (TAB:tablas salariales)
									sitactual (TAB:Situacion actual)
									psolicitadas(TAB:Plazas Solicitadas)*/
		var params ="?RHEid="+document.form2.RHEid.value+'&prs_origen=tablas&RHETEid='+document.form2.RHETEid.value;
		popUpWindow("/cfmx/rh/planillap/operacion/PopUp-ComponentesMasivo.cfm"+params,200,180,650,400);				
	}
	
	function funcExportar(){
		var params ="?RHEid="+document.form2.RHEid.value+"&RHETEid="+document.form2.RHETEid.value;
		popUpWindow("/cfmx/rh/planillap/operacion/PopUpExportar-Tabla.cfm"+params,160,260,700,300);		
	}
	function funcAnterior(){
		window.parent.funcRegresaTabla('#url.RHEid#');
	}
	
	function funcGuardar(){
		var prn_valores = document.form2.vn_llaves.value.split(','); 	
		var vb_regreso  = true;
		//Validar todos los campos tipo fecha
		for (i=0;i<=prn_valores.length-1;i++){
			if(!funcValidaFechas(document.form2['fdesde_'+prn_valores[i]],document.form2['fhasta_'+prn_valores[i]])){
				vb_regreso = false;
			}
		}
		if (vb_regreso==false){
			return false;
		}
		else{
			return true;
		}		
	}
	
	function funcValidaFechas(pro_fechadesde, pro_fechahasta){		
		var fechadesde = pro_fechadesde.value.split('/'); 					//Fecha desde seleccionada
		var fechahasta = pro_fechahasta.value.split('/');					//Fecha hasta seleccionada
		var RHEfdesde  = document.form2.RHEfdesde.value.split('/');			//Fecha desde escenario
		var RHEfhasta  = document.form2.RHEfhasta.value.split('/');			//Fecha hasta escenarios
		if (fechadesde[2]+fechadesde[1]+fechadesde[0] > fechahasta[2]+fechahasta[1]+fechahasta[0]){
			alert("La fecha desde no puede ser mayor que la fecha hasta");
			return false;
		}	
		if ((fechadesde[2]+fechadesde[1]+fechadesde[0] < RHEfdesde[2]+RHEfdesde[1]+RHEfdesde[0]) || (fechahasta[2]+fechahasta[1]+fechahasta[0] > RHEfhasta[2]+RHEfhasta[1]+RHEfhasta[0])){
			alert("El rango de fechas está fuera del rango de fechas del Escenario");			
			return false;
		}	
		else{
			return true;
		}			
	}	
</script>
