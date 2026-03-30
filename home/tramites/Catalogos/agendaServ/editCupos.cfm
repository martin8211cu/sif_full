
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<cfif isdefined('form.id_agendaserv') and form.id_agendaserv NEQ ''>
				<cfquery name="rsLista" datasource="#session.tramites.dsn#">
					Select 
						a.id_agenda
						, ag.id_agendaserv
						, ag.id_sucursal
						, ('(' || rtrim(codigo_sucursal) || ') ' || nombre_sucursal) as sucursal
						, ag.id_tiposerv
						, ('(' || rtrim(codigo_tiposerv) || ') ' || nombre_tiposerv) as tipoServicio
						, ag.dia_semanal
						, a.hora_desde
						, a.hora_hasta
						, cupo1
						, cupo2
						, cupo3
						, cupo4
						, cupo5
						, cupo6
						, cupo7									
					from	TPAgendaServicio ag
						inner join TPSucursal s
							on s.id_sucursal=ag.id_sucursal
					
						inner join TPTipoServicio ts
							on ts.id_tiposerv=ag.id_tiposerv
								and ts.id_inst=s.id_inst
					
						inner join TPRecurso r
							on r.id_sucursal=s.id_sucursal
								and r.id_agendaserv=ag.id_agendaserv
					
						
						left outer join TPAgenda a
							on a.id_tiposerv=ts.id_tiposerv
								and a.id_sucursal=ag.id_sucursal
								and a.id_inst=ts.id_inst
								and a.id_recurso=r.id_recurso
								and a.id_inst=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
					
					where ag.id_sucursal=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_sucursal#">
						and ag.id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tiposerv#">
					order by id_agendaserv,id_agenda			
				</cfquery>										
				<cfif isdefined('rsLista') and rsLista.recordCount GT 0>
					<cfquery name="rsDescripciones" dbtype="query">
						select distinct sucursal,tipoServicio
						from rsLista
					</cfquery>
				</cfif>
			<cfoutput>	
			  <tr>
				<td class="tituloMantenimiento">
					<cfif isdefined('rsDescripciones') and rsDescripciones.recordCount GT 0>
						<font size="1">
							<strong>
								<cfif not isdefined('form.tabsuc')>
									Sucursal: #rsDescripciones.sucursal#<br>
								</cfif>
								Tipo de Servicio: #rsDescripciones.tipoServicio#
							</strong>
						</font>
					</cfif>
				</td>
			  </tr>
			  <form name="formEditCupos" method="post" action="agendaServ/editCupos-sql.cfm">
				<cfif isdefined('form.tabsuc')>
					<input type="hidden" name="tabsuc" value="#form.tabsuc#">
				</cfif>			
				<cfif isdefined('form.tabserv')>
					<input type="hidden" name="tabserv" value="#form.tabserv#">
				</cfif>							  
				  <input type="hidden" name="tab" value="#form.tab#">				
				  <input type="hidden" name="id_inst" value="#form.id_inst#">
				  <input type="hidden" name="id_sucursal" value="#form.id_sucursal#">
				  <input type="hidden" name="id_tiposerv" value="#form.id_tiposerv#">
				  <input type="hidden" name="id_agendaserv" value="#form.id_agendaserv#">							  
				  
				  <tr>
					<td>
					  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr class="areaFiltro">
						  <td colspan="2" align="center"><strong>Hora</strong></td>
						  <td align="center"><strong>Domingo</strong></td>
						  <td align="center"><strong>Lunes</strong></td>
						  <td align="center"><strong>Martes</strong></td>
						  <td align="center"><strong>Mi&eacute;rcoles</strong></td>
						  <td align="center"><strong>Jueves</strong></td>
						  <td align="center"><strong>Viernes</strong></td>
						  <td align="center"><strong>S&aacute;bado</strong></td>
						</tr>
						<tr>
						  <td align="center"><strong>Desde</strong></td>
						  <td align="center"><strong>Hasta</strong></td>
						  <td align="center"><font color="##003399">cupo</font></td>
						  <td align="center"><font color="##003399">cupo</font></td>
						  <td align="center"><font color="##003399">cupo</font></td>
						  <td align="center"><font color="##003399">cupo</font></td>
						  <td align="center"><font color="##003399">cupo</font></td>
						  <td align="center"><font color="##003399">cupo</font></td>
						  <td align="center"><font color="##003399">cupo</font></td>
						</tr>
						<cfif isdefined('rsLista') and rsLista.recordCount GT 0>
						  <cfloop query="rsLista">
							<input type="hidden" name="id_agenda" value="#id_agenda#">
							<cfset LvarListaNon = (CurrentRow MOD 2)>
							<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
							  <td align="center"> #TimeFormat(hora_desde, "hh:mm")# </td>
							  <td align="center"> #TimeFormat(hora_hasta, "hh:mm")# </td>
							  <cfset arrayDias = ListToArray(dia_semanal)>
							  <td align="center">
								<cfif arrayDias[1] EQ 1>	<!--- Domingo --->
								  <input type="text" name="cupo1" value="#cupo1#" size="4" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,-1);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" >
								<cfelse>
									&nbsp;
								</cfif>
							  </td>
							  <td align="center">
								<cfif arrayDias[2] EQ 1>	<!--- Lunes --->
								  <input type="text" name="cupo2" value="#cupo2#" size="4" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,-1);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" >
								<cfelse>
									&nbsp;
								</cfif>
							  </td>
							  <td align="center">
								<cfif arrayDias[3] EQ 1>	<!--- Martes --->
								  <input type="text" name="cupo3" value="#cupo3#" size="4" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,-1);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" >
								<cfelse>
									&nbsp;
								</cfif>
							  </td>
							  <td align="center">
								<cfif arrayDias[4] EQ 1>	<!--- Miercoles --->
								  <input type="text" name="cupo4" value="#cupo4#" size="4" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,-1);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" >
								<cfelse>
									&nbsp;
								</cfif>
							  </td>
							  <td align="center">
								<cfif arrayDias[5] EQ 1>	<!--- Jueves --->
								  <input type="text" name="cupo5" value="#cupo5#" size="4" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,-1);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" >
								<cfelse>
									&nbsp;
								</cfif>
							  </td>
							  <td align="center">
								<cfif arrayDias[6] EQ 1>	<!--- Viernes --->
								  <input type="text" name="cupo6" value="#cupo6#" size="4" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,-1);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" >
								<cfelse>
									&nbsp;
								</cfif>
							  </td>
							  <td align="center">
								<cfif arrayDias[7] EQ 1>	<!--- Sabado --->
								  <input type="text" name="cupo7" value="#cupo7#" size="4" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,-1);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" >
								<cfelse>
									&nbsp;
								</cfif>
							  </td>
							</tr>
						  </cfloop>
						</cfif>
					  </table>
					</td>
				  </tr>			
				  </cfoutput>		
				</cfif>					  
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align="center">
						<input name="btnRegresar" type="submit" id="btnRegresar" value="Regresar">
						<input name="btnCambio" type="submit" id="btnCambio" value="Actualizar">
						<input name="btnBaja" type="submit" onClick="javascript: return confirm('Desea eliminar esta agenda ?');" id="btnBaja" value="Eliminar">						
					</td>
				</tr>			
				<tr>
					<td>&nbsp;</td>
				</tr>									
			</form>  
