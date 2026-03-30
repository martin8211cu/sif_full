
	<cf_templateheader title="Contabilidad General - Consulta de Gastos">
	
		<cfquery name="periodo_actual" datasource="#session.DSN#">
			select p.Pvalor
			from Parametros p
			where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and p.Pcodigo = 30
		</cfquery>	

		<cfquery name="mes_actual" datasource="#session.DSN#">
			select p.Pvalor
			from Parametros p
			where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and p.Pcodigo = 40
		</cfquery>
		 <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="Consulta de Gastos">
			<cfinclude template="../../portlets/pNavegacion.cfm">
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="50%" valign="top">
						<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
						  <tr>
							<td>&nbsp;</td>
						  </tr>
						  <tr>
							<td>
								<cf_web_portlet_start border="true" titulo="Consulta de Gastos" skin="info1">
									<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
									  <tr>
										<td>
											<div align="justify" style="font-size:12px;">
												<br />
												El reporte muestra un listado con la informaci&oacute;n correspondiente a los 
                                                provedores de acuerdo a su condici&oacute;n de Nacionales o Internacionales y 
                                                a si est&aacute;n Activos o Inactivos, seg&uacute;n lo solicite el usuario.
												<br />
												<br />
											</div>
										</td>
									  </tr>
									</table>
								<cf_web_portlet_end>
							</td>
						  </tr>
						</table>
					</td>
					<td width="50%" valign="top">
						
						<form name="form1" action="socioNegocioRep.cfm" method="post" style="margin:0;" onSubmit="return validar();">
						<table border="0" align="center" cellpadding="3" cellspacing="0">
                         	<tr>
                            	<td>&nbsp;</td>
								<td>&nbsp;</td>
                            <tr>
							<tr><td colspan="2" align="center"><strong>Clasificaci&oacute;n General:</strong></td></tr>
                            <tr>
                            	<td colspan="2">
                                <input type="hidden" name="txtsne" id="txtsne" value="" />
                                <cfquery datasource="#session.DSN#" name="snE">
                                    select  SNCEid, CEcodigo, Ecodigo, SNCEcodigo, SNCEdescripcion, SNCEcorporativo
                                    from SNClasificacionE 
                                    where CEcodigo = #session.CEcodigo#
                                        and ( Ecodigo is null or Ecodigo = #session.Ecodigo# )
                                        and PCCEactivo = 1
                                         order by Ecodigo ,SNCEcorporativo desc,SNCEdescripcion   
                                </cfquery>
                                <strong><select name="snE" onchange="javascript: cambiarsnD()" style="max-width:100%;width:100%;">
								  <!--- <option value="">-seleccionar-</option> --->
								  <option value="all" >Todos</option>
                                  <optgroup label="Clasificaciones Corporativas ">
                                  <cfset ctmp=0>
                                  
                                  <cfloop query="snE">
                                  	<cfif snE.SNCEcorporativo EQ 0 and ctmp EQ 0 and snE.Ecodigo EQ #session.Ecodigo#>
                                    	<cfset ctmp=1>
                                        </optgroup>
                                        <optgroup label="Clasificaciones Locales">
                                    </cfif>
                                  		<option value="<cfoutput>#snE.SNCEid#</cfoutput>" alt="<cfoutput>#snE.SNCEdescripcion#</cfoutput>" title="<cfoutput>#snE.SNCEdescripcion#</cfoutput>"><cfoutput>#snE.SNCEdescripcion#</cfoutput></option>
                                  </cfloop>
								  </optgroup>								 
								</select></strong></td>
                           </tr>
                           <tr>
								<td colspan="2"><strong><select name="snD" style="max-width:100%;width:100%;" onchange="javascript:cargartxtclasif()">
								  <!--- <option value="">-seleccionar-</option> --->
								  <option value="all" >Todos</option>							 
								</select></strong>
                                <input type="hidden" name="txtsnd" id="txtsnd" value="" />
                                </td>
                            <tr>
                            <tr>
                            	<td>&nbsp;</td>
								<td>&nbsp;</td>
                            <tr>
                            <tr><td><strong>Tipo:</strong></td><td><strong><select name="snTipo">
								  <!--- <option value="">-seleccionar-</option> --->
								  <option value="all" >Todos</option>
								  <option value="N" >Nacional</option>
								  <option value="E" >Internacional</option>								 
								</select></strong></td>
                            <tr>
                            	<td>&nbsp;</td>
								<td>&nbsp;</td>
                            <tr>
                            	<td><strong>Estado:</strong></td><td><strong><select name="snEstado">
								  <!--- <option value="">-seleccionar-</option> --->
								  <option value="all" >Todos</option>
								  <option value="0" >Activo</option>
								  <option value="1" >Inactivo</option>								 
								</select></strong></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<tr><td colspan="2" align="center"><input type="submit" value="Consultar" name="Consultar"></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
						</table> 
						</form>
                        						
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>

		<script language="javascript1.2" type="text/javascript">
			function validar(){
				var mensaje = '';
				if ( document.form1.CFid.value == '' ){
					mensaje += ' - El campo Centro Funcional es requerido.\n';
				}
				if ( document.form1.mes.value == '' ){
					mensaje += ' - El campo Mes es requerido.\n';
				}

				if ( mensaje != '' ){
					alert('Se presentaron los siguientes errores:\n' + mensaje)
					return false;
				}
				sinbotones();
				return true;
			}
			<!---funciones para cargar el 2do combo de clasificacion general --->
				function cambiarsnD()
				{
					//tomo el valor del select
					var sneid;
					sneid = document.form1.snE[document.form1.snE.selectedIndex].value;
					//
					if (sneid !="all") {
					   //Se cargan las opciones del combo
					   //selecciono el array de acuerdo al sneid
					   sndlist=eval("snd_" + sneid);
					   sndlistval=eval("snd_val" + sneid);
					   //calculo el numero de elementos
					   num_sndlist = sndlist.length;
					   //
					   document.form1.snD.length = num_sndlist;
					   //
					   for(i=0;i<num_sndlist;i++){
						  document.form1.snD.options[i].value=sndlistval[i];
						  document.form1.snD.options[i].text=sndlist[i];
						  document.form1.snD.options[i].alt=sndlist[i];
						  document.form1.snD.options[i].title=sndlist[i];
					   }
					}else{
					   
					   document.form1.snD.length = 1
					  
					   document.form1.snD.options[0].value = "all"
					   document.form1.snD.options[0].text = "Todos"
					}
					//seleccionar como seleccionada la opción primera
					document.form1.snD.options[0].selected = true 
					cargartxtclasif();
				}
				function cargartxtclasif()
				{
					//cambiar valores de los input con el texto del filtro
					document.form1.txtsnd.value=document.form1.snD[document.form1.snD.selectedIndex].text;
					document.form1.txtsne.value=document.form1.snE[document.form1.snE.selectedIndex].text;
				}
				<!--- cargar los datos para el 2do select --->
				<cfquery datasource="#session.DSN#" name="snD">
					select  SNCEid, SNCDid, SNCDvalor, SNCDdescripcion
					from SNClasificacionD 
					order by SNCEid desc  
				</cfquery>
				
				<cfset tmpidold=0>
				<cfset tmpidac="">
				<cfset acumulador="">
								
				<cfloop query="snD"><cfset tmpidac=snD.SNCEid><cfif tmpidac NEQ tmpidold><cfoutput>
				var snd_#snD.SNCEid# = [];
				var snd_val#snD.SNCEid# = [];
				snd_val#snD.SNCEid#.push('all');
				snd_#snD.SNCEid#.push('Todos');</cfoutput></cfif><cfoutput>
				snd_#snD.SNCEid#.push('#snD.SNCDdescripcion#');
				snd_val#snD.SNCEid#.push('#snD.SNCDid#');</cfoutput><cfset tmpidold=tmpidac></cfloop>
				
				cambiarsnD();
		</script>


	<cf_templatefooter>
