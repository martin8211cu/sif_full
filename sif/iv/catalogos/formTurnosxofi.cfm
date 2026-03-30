<cfif isdefined("form.Ocodigo") and form.Ocodigo NEQ ''>
	<cfquery name="rsOficodigo"	 datasource="#session.DSN#">
		select Oficodigo,Odescripcion
		from Oficinas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
	</cfquery>	
</cfif>
	
<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td></tr>
	<form name="form1" action="SQLTurnosxofi.cfm" method="post" onSubmit="return funcValidar()">
		<cfoutput>	
			<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
			<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
			<input type="hidden" name="filtro_Ocodigo" value="<cfif isdefined('form.filtro_Ocodigo') and form.filtro_Ocodigo NEQ ''>#form.filtro_Ocodigo#</cfif>">			
			<input type="hidden" name="filtro_Odescripcion" value="<cfif isdefined('form.filtro_Odescripcion') and form.filtro_Odescripcion NEQ ''>#form.filtro_Odescripcion#</cfif>">			
		</cfoutput>
		<tr>
			<td>
				<label for="Oficina"><strong>Oficina:</strong></label>			
				<cfif isdefined("form.Ocodigo") and form.Ocodigo NEQ '' and isdefined('rsOficodigo')>		
					<cfoutput><label for="Oficinas"><strong>#rsOficodigo.Oficodigo#</strong></label></cfoutput>		
				</cfif>	
			</td>
		</tr>	
		<tr>
			<td>				
				<label for="Oficina"><strong>Descripción:</strong></label>
				<cfif isdefined("form.Ocodigo") and form.Ocodigo NEQ '' and isdefined('rsOficodigo')>	
					<cfoutput><label for="Oficinas"><strong>#rsOficodigo.Odescripcion#</strong></label></cfoutput>
				</cfif>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>		
			<td nowrap>			
				<label for="Turno"><strong>Turno:</strong></label>	 		  	
				<input type="hidden" name="Ocodigo" value="<cfif isdefined("form.Ocodigo")><cfoutput>#form.Ocodigo#</cfoutput></cfif>">
				<input name="Codigo_turno" 
					type="text" 
					value="<cfif isDefined("form.Codigo_turno")><cfoutput>#form.Codigo_turno#</cfoutput></cfif>"  
					id="Codigo_turno" 
					size="5" 
					maxlength="5" 
					tabindex="-1" 
					onkeyup="javascript:conlis_keyup_Turno(event);"
					onBlur="javascript:traerTurnos(this.value,1);">
					
				<input name="Tdescripcion" type="text" value="<cfif isDefined("form.Tdescripcion")><cfoutput>#form.Tdescripcion#</cfoutput></cfif>"  id="Tdescripcion" size="40" maxlength="80" tabindex="-1" onBlur="javascript:traerTurnos(this.value,1);" readonly enabled>
				<input name="Turno_id" type="hidden" id="Turno_id" value="<cfif isDefined("form.Turno_id")><cfoutput>#form.Turno_id#</cfoutput></cfif>" size="40">					
				<a href="##" tabindex="-1"> <img src="../../imagenes/Description.gif" alt="Lista de tipos de solicitud" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisTurnos();"> </a>
				&nbsp;<input type="submit" name="btnAgregar" value="Agregar">				 
			</td>	
		</tr>
	</form>
		
	<tr><td>&nbsp;</td></tr>
	<tr>	 				
		<td width="49%" valign="top">														
			<cfoutput>		
				<form style="margin:0" action="SQLTurnosxofi.cfm" method="post" name="lista2" id="lista2" >
					<input type="hidden" name="Turno_id" value="">
					<input type="hidden" name="Ocodigo" value="">
					<input type="hidden" name="SQL" value="">
					<input type="hidden" name="Odescripcion" value="<cfif isdefined("form.Odescripcion")>#form.Odescripcion#</cfif>">								
					<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
					<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
					<input type="hidden" name="filtro_Ocodigo" value="<cfif isdefined('form.filtro_Ocodigo') and form.filtro_Ocodigo NEQ ''>#form.filtro_Ocodigo#</cfif>">			
					<input type="hidden" name="filtro_Odescripcion" value="<cfif isdefined('form.filtro_Odescripcion') and form.filtro_Odescripcion NEQ ''>#form.filtro_Odescripcion#</cfif>">			

					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td class="tituloListas" align="left"><strong>Codigo</strong></td>
							<td class="tituloListas" align="left"><strong>Descripcion</strong></td>
							<td class="tituloListas" align="left"><strong>Activo</strong></td>
							<td class="tituloListas" align="left"><strong></strong></td>
						</tr>
						<cfif isdefined("form.Ocodigo") and form.Ocodigo NEQ ''>
							<cfquery name="rsLista" datasource="#session.DSN#">							
								select 	a.Testado,
										a.Ocodigo,
										a.Turno_id,
										b.Codigo_turno, 
										b.Tdescripcion 						
								from Turnoxofi a
									inner join Turnos b
										on a.Turno_id =  b.Turno_id
										and a.Ecodigo = b.Ecodigo
									inner join Oficinas c
										on a.Ocodigo = c.Ocodigo
										and a.Ecodigo = c.Ecodigo
								where a.Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
									and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
							</cfquery>
											
							<cfif rsLista.RecordCount EQ 0>
								<tr><td colspan="4" align="center"><strong>--- No se encontraron Registros ---</strong></td></tr>
							<cfelse>
								<cfloop query="rsLista">
									<tr class="<cfif rsLista.currentRow mod 2>listaNon<cfelse>listaPar</cfif>" 
										<cfif rsLista.currentRow mod 2>onmouseover="this.className='listaNonSel';"<cfelse>onmouseover="this.className='listaParSel';"</cfif>
										<cfif rsLista.currentRow mod 2>onmouseout="this.className='listaNon';"<cfelse>onmouseout="this.className='listaPar';"</cfif> >				
										<td>#rsLista.Codigo_turno#</td>
										<td>#rsLista.Tdescripcion#</td>				
										<td style="cursor:hand;" ><input type="checkbox" name="Testado_#rsLista.Turno_id#_#rsLista.Ocodigo#" value="#rsLista.Turno_id#" onClick="javascript: funcEstado(#rsLista.Turno_id#,#rsLista.Ocodigo#,2);" <cfif rsLista.Testado EQ 1>checked</cfif>></td>
										<td><img border="0" onClick="javascript: funcEliminar(#rsLista.Turno_id#,#rsLista.Ocodigo#,1);"  src="/cfmx/sif/imagenes/Borrar01_S.gif"></td>
									</tr>			
								</cfloop>
							</cfif>
						</cfif>
					</table>
				</form>
			</cfoutput>				
		</td>	
			<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>	

			<script type="text/javascript" language="javascript1.2">
				var popUpWin = 0;
				function popUpWindow(URLStr, left, top, width, height){
					if(popUpWin){
						if(!popUpWin.closed) popUpWin.close();
					}
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
				
				function funcEliminar(Turno,Oficina,Opcion){			
					if(confirm('Desea eliminar el turno ?')){
						document.lista2.Turno_id.value = Turno;		
						document.lista2.Ocodigo.value = Oficina;
						document.lista2.SQL.value = "Eliminar";		
						document.lista2.submit();
					}else{
						return false;
					}
				}				
				
				function doConlisTurnos() {
					popUpWindow("ConlisTurnos.cfm?formulario=form1",250,150,550,400);
				}
				
				function traerTurnos(value){				 
				  if (value!=''){	   
				   document.getElementById("fr").src = 'traerTurnos.cfm?formulario=form1&Codigo_turno='+value;
				  }
				  else{
				   document.form1.Turno_id.value = '';
				   document.form1.Tdescripcion.value = '';
				   document.form1.Codigo_turno.value = '';
				  }
				 }	
				
				function funcEstado(Turno,Oficina){				
					document.lista2.Turno_id.value = Turno		
					document.lista2.Ocodigo.value = Oficina		
					document.lista2.SQL.value = "Cambio"		
					document.lista2.submit()
				}
				
				function funcValidar(){										
					if(document.form1.Codigo_turno.value == ''){
						alert('Debe seleccionar el turno a asignar');	
						return false;					
					}
					if (document.form1.Ocodigo.value == ''){
						alert('Debe seleccionar una oficina para asignar el turno');	
						return false;
					}									
				}
				
				function conlis_keyup_Turno(e){
					var keycode = e.keyCode ? e.keyCode : e.which;
					if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
						doConlisTurnos();
					}				
				}
				
				document.form1.Codigo_turno.focus();				
			</script>
		</td>		
	</tr>
</table>
