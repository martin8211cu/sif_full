
<!--- Cuando es un cambio de empresa se realizan las consultas de los catalogos en la nueva empresa --->
<cfif rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1>
	<cfset vn_Ecodigo = rsAccion.EcodigoRef>
	<cfquery name="rsTiposNomina2" datasource="#Session.DSN#">
		select rtrim(Tcodigo) as Tcodigo, Tdescripcion
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAccion.EcodigoRef#">
		order by Tdescripcion
	</cfquery>
	
	<cfquery name="rsRegimenVacaciones2" datasource="#Session.DSN#">
		select RVid, Descripcion
		from RegimenVacaciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.EcodigoRef#">
		order by Descripcion
	</cfquery>
	
	<cfquery name="rsOficinas2" datasource="#Session.DSN#">
		select Ocodigo, Odescripcion 
		from Oficinas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.EcodigoRef#">
		order by Odescripcion
	</cfquery>
	
	<cfquery name="rsDeptos2" datasource="#Session.DSN#">
		select Dcodigo, Ddescripcion 
		from Departamentos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.EcodigoRef#">
		order by Ddescripcion
	</cfquery>
	
	<cfquery name="rsJornadas2" datasource="#Session.DSN#">
		select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion
		from RHJornadas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.EcodigoRef#">
		order by Descripcion
	</cfquery>

<cfelse>
	<cfset vn_Ecodigo = Session.Ecodigo>
	<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
		select rtrim(Tcodigo) as Tcodigo, Tdescripcion
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by Tdescripcion
	</cfquery>
	
	<cfquery name="rsRegimenVacaciones" datasource="#Session.DSN#">
		select RVid, Descripcion
		from RegimenVacaciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by Descripcion
	</cfquery>
	
	<cfquery name="rsOficinas" datasource="#Session.DSN#">
		select Ocodigo, Odescripcion 
		from Oficinas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by Odescripcion
	</cfquery>
	
	<cfquery name="rsDeptos" datasource="#Session.DSN#">
		select Dcodigo, Ddescripcion 
		from Departamentos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by Ddescripcion
	</cfquery>
	
	<cfquery name="rsJornadas" datasource="#Session.DSN#">
		select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion 
		from RHJornadas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by Descripcion
	</cfquery>

</cfif>

<!----================ TRADUCCION ===================----->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_plazas_presupuestarias"
	Default="Lista de plazas presupuestarias"	
	returnvariable="LB_Lista_de_plazas_presupuestarias"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_puestos"
	Default="Lista de puestos"	
	returnvariable="LB_Lista_de_puestos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Debe_seleccionar_la_plaza"
	Default="Debe seleccionar la plaza"	
	returnvariable="MSG_Debe_seleccionar_la_plaza"/>	

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
		<tr>
			<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="LB_Situacion_Propuesta">Situaci&oacute;n Propuesta</cf_translate></div></td>
	  	</tr>
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Plaza">Plaza</cf_translate></td>
			<td height="25" nowrap>
				<input type="hidden" name="RHPid" value="<cfif rsAccion.RHPid NEQ "">#rsAccion.RHPid#</cfif>">			
				<input type="hidden" name="RHPPid" value="<cfif isdefined("rsAccion") and len(trim(rsAccion.RHPPid))>#rsAccion.RHPPid#</cfif>">
				<input type="text" name="RHPPcodigo" id="RHPPcodigo" tabindex="1"
					value="<cfif isdefined("rsAccion") and len(trim(rsAccion.RHPPcodigo))>#rsAccion.RHPPcodigo#</cfif>" 
					onfocus="this.select()"
					size="10" 
					maxlength="10"
					<cfif rsAccion.RHTcplaza EQ 0 or not Lvar_Modifica>
						readonly=""
						style="border:0"
					</cfif>
					<cfif rsAccion.RHTcplaza EQ 1 and Lvar_Modifica>
						onblur="javascript: FuncTraePlaza(this.value); "
					</cfif>>
				<input type="text" name="RHPPdescripcion" id="RHPPdescripcion" tabindex="-1" disabled
					value="<cfif isdefined("rsAccion") and len(trim(rsAccion.RHPPdescripcion))>#rsAccion.RHPPdescripcion#</cfif>" 
					onfocus="this.select()"
					size="30" 
					<cfif rsAccion.RHTcplaza EQ 0 or not Lvar_Modifica>
					style="border:0"
					</cfif>				
					maxlength="80">
				<cfif rsAccion.RHTcplaza EQ 1 and Lvar_Modifica>
					<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_plazas_presupuestarias#" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisPlaza();'></a>					
				</cfif>	
			</td>
		</tr>
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Oficina">Oficina</cf_translate></td>
			<td height="25" nowrap>												
				<input type="text" name="Odescripcion" readonly="" value="<cfif isdefined("rsAccion") and len(trim(rsAccion.Odescripcion))>#rsAccion.Odescripcion#</cfif>" style="border:0;" size="30">			
				<input size="0" type="hidden" name="Ocodigo" value="<cfif isdefined("rsAccion") and len(trim(rsAccion.Ocodigo))>#rsAccion.Ocodigo#</cfif>">
			</td>
		</tr>
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Departamento">Departamento</cf_translate></td>
			<td height="25" nowrap>						
				<input type="text" name="Ddescripcion"  readonly="" value="<cfif isdefined("rsAccion") and len(trim(rsAccion.Ddescripcion))>#rsAccion.Ddescripcion#</cfif>" style="border:0;" size="30">			
				<input size="0" type="hidden" name="Dcodigo" value="<cfif isdefined("rsAccion") and len(trim(rsAccion.Dcodigo))>#rsAccion.Dcodigo#</cfif>">
			</td>
		</tr>
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Centro_Funcional">Centro Funcional</cf_translate></td>
			<td>
				<input  size="40" type="text" style="border:0" name="CFuncional" readonly="" value="<cfif isdefined("rsAccion") and len(trim(rsAccion.Ctrofuncional))>#rsAccion.Ctrofuncional#</cfif>">			
			</td>
		</tr>
		<cfif usaEstructuraSalarial EQ 1>
			<tr>
				<td colspan="2">
					<cfset emp = Session.Ecodigo>
					<!--- En caso de Cambio de Empresa --->
					<cfif rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1>
						<cfset emp = rsAccion.EcodigoRef>
					</cfif>
					<cfif Len(Trim(rsAccion.RHCPlinea))>			 
						<cf_rhcategoriapuesto form="form1" query="#rsAccion#" 
							tablaReadonly="#rsAccion.RHTccatpaso EQ 0 OR not Lvar_Modifica#" 
							categoriaReadonly="#rsAccion.RHTccatpaso EQ 0 OR not Lvar_Modifica#"
							puestoReadonly="#rsAccion.RHTccatpaso EQ 0 OR not Lvar_Modifica#" incluyeTabla="false" Ecodigo="#emp#">
					<cfelse>
						<cfif LEN(TRIM(rsAccion.RHPid)) GT 0>
							<cfquery name="rsBusqueda" datasource="#session.dsn#">
								select m.RHTTid,m.RHCid,m.RHMPPid,t.RHTTcodigo, 
								t.RHTTdescripcion,mp.RHMPPcodigo,mp.RHMPPdescripcion,c.RHCcodigo,c.RHCdescripcion 
								 from RHPlazas p
									inner join RHMovPlaza m
										inner join RHMaestroPuestoP mp
										on m.RHMPPid=mp.RHMPPid
										inner join RHCategoria c
										on c.RHCid=m.RHCid
									on m.RHPPid=p.RHPPid
									inner join RHTTablaSalarial t
									on t.RHTTid=m.RHTTid
								where p.RHPid=#rsAccion.RHPid#
								and p.Ecodigo=#session.Ecodigo#								
							</cfquery>
						</cfif>
						<cfif isdefined('rsBusqueda') and rsBusqueda.recordcount gt 0>
							<cf_rhcategoriapuesto query="#rsBusqueda#" form="form1"  tablaReadonly="false" categoriaReadonly="false" puestoReadonly="false" incluyeTabla="false" Ecodigo="#emp#">
						<cfelse>
							<cf_rhcategoriapuesto form="form1"  tablaReadonly="#rsAccion.RHTccatpaso EQ 0 OR not Lvar_Modifica#" categoriaReadonly="#rsAccion.RHTccatpaso EQ 0 OR not Lvar_Modifica#" puestoReadonly="#rsAccion.RHTccatpaso EQ 0 OR not Lvar_Modifica#" incluyeTabla="false" Ecodigo="#emp#">
						</cfif>
					</cfif>
				</td>
			</tr>
		</cfif>
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_PuestoRH">Puesto RH</cf_translate></td>
			<td height="25" nowrap>			
				<input type="hidden" name="RHPcodigo" id="RHPcodigo" tabindex="-1"
					value="<cfif isdefined("rsAccion") and len(trim(rsAccion.RHPcodigo))>#rsAccion.RHPcodigo#</cfif>" 
					size="0">
				<input type="text" name="RHPcodigoext" id="RHPcodigoext" tabindex="1" 
					value="<cfif isdefined("rsAccion") and len(trim(rsAccion.RHPcodigoext))>#rsAccion.RHPcodigoext#</cfif>" 
					onfocus="this.select()" 			
					size="10" 
					maxlength="10"					
					<cfif rsAccion.RHTcpuesto EQ 0 or not Lvar_Modifica>
					readonly=""
					style="border:0"
					</cfif>
					<cfif rsAccion.RHTcpuesto EQ 1 and Lvar_Modifica>
					onblur="javascript: FuncTraePlaza(document.form1.RHPPcodigo.value); "
					</cfif>
					onblur="javascript:FuncTraePuesto(document.form1.RHPcodigoext.value); ">
				<input type="text" name="RHPdescpuesto" id="RHPdescpuesto" tabindex="-1" disabled
					value="<cfif isdefined("rsAccion") and len(trim(rsAccion.RHPdescpuesto))>#rsAccion.RHPdescpuesto#</cfif>" 
					onfocus="this.select()"
					<cfif rsAccion.RHTcpuesto EQ 0 or not Lvar_Modifica>
					style="border:0"
					</cfif>
					size="30" 
					maxlength="80">
				<cfif rsAccion.RHTcpuesto EQ 1 and Lvar_Modifica>
					<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_puestos#" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisPuesto();'></a>					
				</cfif>
			</td>
		</tr>	 
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Porcetaje_de_Plaza">Porcentaje de Ocupaci&oacute;n</cf_translate></td>
			<td height="25" nowrap>
				<cfif RHTporcPlazaCHK eq 1>
					<input 
						name="LTporcplaza" 
						type="text" 
						size="8" 
						maxlength="6"  
						onFocus="this.value=qf(this); this.select();" 
						onBlur="javascript: fm(this,2);"  
						onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
						style="text-align: right;" 
						value="<cfif rsAccion.RHAporc NEQ "">#LSCurrencyFormat(rsAccion.RHAporc,'none')#<cfelse>#LSCurrencyFormat(rsTipoAccionComp.RHTporc,'none')#</cfif>"> %
				<cfelse>
					<input 
						name="LTporcplaza" 
						type="hidden" 
						value="<cfif rsAccion.RHAporc NEQ "">#rsAccion.RHAporc#"</cfif>>
						<cfif rsAccion.RHAporc NEQ "">
							#LSCurrencyFormat(rsAccion.RHAporc,'none')#
						</cfif> %				
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Porcentaje_de_Salario_Fijo">Porcentaje de Salario Fijo</cf_translate></td>
			<td height="25" nowrap>
				<cfif RHTcsalariofijo eq 1>
					<input 
						name="LTporcsal" 
						type="text" 
						size="8" 
						maxlength="6"  
						onFocus="this.value=qf(this); this.select();" 
						onBlur="javascript: fm(this,2);"  
						onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
						style="text-align: right;" 
						value="<cfif len(trim(rsAccion.RHAporcsal)) and  rsAccion.RHAporcsal NEQ -1 >#LSCurrencyFormat(rsAccion.RHAporcsal,'none')#<cfelse>#LSCurrencyFormat(RHTporcsal,'none')#</cfif>"> %
				<cfelse>
					<input 
						name="LTporcsal" 
						type="hidden" 
						value="<cfif rsAccion.RHAporcsal GT 0>#rsAccion.RHAporcsal#<cfelse>#RHTporcsal#</cfif>">
						<cfif rsAccion.RHAporcsal GT 0>
							#LSCurrencyFormat(rsAccion.RHAporcsal,'none')#
						<cfelse>
							#LSCurrencyFormat(RHTporcsal,'none')#
						</cfif> %				
				</cfif>

			</td>
		</tr>
		
		<input type="hidden" name="RHJid" value="#rsEstadoActual.RHJid#"> <!---Jornada--->
		<cfset Lvar_Tcodigo = rsEstadoActual.Tcodigo>
		<input type="hidden" name="Tcodigoant" value="#rsEstadoActual.Tcodigo#"><!---Tipo nomina actual en caso de que se consulte en algun lugar--->
		<input name="Tcodigo" id="Tcodigo" value="#rsEstadoActual.Tcodigo#" type="hidden"><!---Tipo de Nomina--->
		<input type="hidden" name="RVid" value="#rsEstadoActual.RVid#"><!---Regimen de vacaciones--->
		
	  
	 <cfif rsAccion.RHTcomportam EQ 3>
	 	<!--- Se asume que cuando el tipo de accion es Vacacion no se modifica la jornada --->
		<input type="hidden" name="vacadias" value="#get_vacaciones_disf(rsAccion.RHAlinea, rsEstadoActual.RHJid)#">
		<input name="RHAvdisf" type="hidden" value="#rsEstadoActual.RHJid#"><!---Vacaciones Disfrutadas--->
		<input type="hidden" name="RVid" value="#rsEstadoActual.RVid#">
		<input name="RHAvcomp" type="hidden" value="#LSCurrencyFormat(rsEstadoActual.RHAvcomp,'none')#"><!---Vacaciones Compensadas--->
	 </cfif>
		
		<!--- Desarrollo DHC - Baroda --->
		<!--- Si la accion es de incapacidad y la empresa proceso dias de enfermedad (p. 960 = 1), se pinta esa seccion de codigo 
			  al cual debe capturar el numero de dias de enfermedad a rebajar al empleado	
		--->
		
		<cfif rsAccion.RHTcomportam EQ 5>
			<cfquery name="rs_p960" datasource="#session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Pcodigo = 960
			</cfquery>

			<cfif trim(rs_p960.Pvalor) eq 1>
				<cfquery name="rs_saldodiasenf" datasource="#session.DSN#">
					select DEid, sum(DVEenfermedad) as dias
					from DVacacionesEmpleado
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DEid#">
					group by DEid				
				</cfquery>
				<cfset valueRHAdiasenfermedad = 0.00 >
				<!---<cfset valueRHAdiasenfermedad = abs(datediff('d', rsAccion.DLfvigencia, rsAccion.DLffin)) +1 >--->
				<cfif isdefined("rsAccion.RHAdiasenfermedad") and len(trim(rsAccion.RHAdiasenfermedad))>
					<cfset valueRHAdiasenfermedad = LSNumberFormat(rsAccion.RHAdiasenfermedad, '.00') >
				</cfif>
				
				<tr>
					<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Dias_de_Enfermedad">D&iacute;as de Enfermedad</cf_translate></td>
					<td height="25" nowrap><input name="RHAdiasenfermedad" type="text" size="8" maxlength="7" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="#LSNumberFormat(valueRHAdiasenfermedad, '.00')#"></td>
				</tr>	
			</cfif>
		</cfif>	  
		
	</table>
</cfoutput>
<!---============== Deshabilitar: tabla, puesto y categoria si el salario de la plaza presupuestaria es negociado ==============----->
<cfif (usaEstructuraSalarial EQ 1) and (len(trim(rsAccion.RHMPnegociado)) and rsAccion.RHMPnegociado EQ 'N')>
	<cfif len(trim(rsAccion.RHTTid)) and len(trim(rsAccion.RHMPPid)) and len(trim(rsAccion.RHCid)) and rsAccion.RHTccatpaso EQ 1 AND (len(trim(rsAccion.IDInterfaz)) EQ 0)>
		<script type="text/javascript" language="javascript1.2">
			var conlispuesto = document.getElementById("imgRHMPPcodigo");			
			var conliscategoria = document.getElementById("imgRHCcodigo");
			conlispuesto.style.display = 'none';		
			conliscategoria.style.display = 'none';	
			document.form1.RHTTid.disabled = true;
			document.form1.RHMPPcodigo.disabled = true;
			document.form1.RHCcodigo.disabled = true;
		</script>
	</cfif>
</cfif>

<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>
<script type="text/javascript" language="javascript1.2">
	var popUpWin5=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height)
	{
		if(popUpWin5)
		{
			if(!popUpWin5.closed) popUpWin5.close();
		}
		popUpWin5 = open(URLStr, 'popUpWin5', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	function doConlisPlaza() {
		<cfoutput>
			var params = '?form=form1&empresa=#vn_Ecodigo#';
			<cfif isdefined("rsAccion") and len(trim(rsAccion.DEid))>	
				params = params + '&DEid=#rsAccion.DEid#';
			</cfif>
			<cfif isdefined("rsAccion") and len(trim(rsAccion.DLfvigencia))>			
				params = params + '&fechaAcc=#LSDateFormat(rsAccion.DLfvigencia,"dd/mm/yyyy")#';			
			</cfif>
			<cfif isdefined("rsAccion") and len(trim(rsAccion.DLffin))>			
				params = params + '&fechafinAcc=#LSDateFormat(rsAccion.DLffin,"dd/mm/yyyy")#';			
			</cfif>
			<cfif isdefined("rsAccion") and len(trim(rsAccion.RHTnoveriplaza))>	
				params = params + '&vfyplz=#rsAccion.RHTnoveriplaza#';
			</cfif>
			<cfif isdefined("usaEstructuraSalarial") and usaEstructuraSalarial EQ 1>
				params = params + '&usaEstructuraSalarial=1';
			</cfif>
			<cfif isdefined("rsAccion.RHTccatpaso") and rsAccion.RHTccatpaso EQ 1  AND (len(trim(rsAccion.IDInterfaz)) EQ 0)>
				params = params + "&PuedeModificar=1";
			</cfif>
		</cfoutput>
		popUpWindow("/cfmx/rh/nomina/operacion/ConlisPlaza_acciones.cfm"+params,10,30,990,600);
	}	
	function FuncTraePlaza(vs_codigo){
		<cfoutput>
			var params = '&form=form1&empresa=#vn_Ecodigo#';
			<cfif isdefined("rsAccion") and len(trim(rsAccion.DEid))>	
				params = params + '&DEid=#rsAccion.DEid#';
			</cfif>
			<cfif isdefined("rsAccion") and len(trim(rsAccion.DLfvigencia))>			
				params = params + '&fechaAcc=#LSDateFormat(rsAccion.DLfvigencia,"dd/mm/yyyy")#';			
			</cfif>
			<cfif isdefined("rsAccion") and len(trim(rsAccion.DLffin))>			
				params = params + '&fechafinAcc=#LSDateFormat(rsAccion.DLffin,"dd/mm/yyyy")#';			
			</cfif>
			<cfif isdefined("rsAccion") and len(trim(rsAccion.RHTnoveriplaza))>	
				params = params + '&vfyplz=#rsAccion.RHTnoveriplaza#';
			</cfif>
			<cfif isdefined("usaEstructuraSalarial") and usaEstructuraSalarial EQ 1>
				params = params + '&usaEstructuraSalarial=1';
			</cfif>
			<cfif isdefined("rsAccion.RHTccatpaso") and rsAccion.RHTccatpaso EQ 1  AND (len(trim(rsAccion.IDInterfaz)) EQ 0)>
				params = params + "&PuedeModificar=1";
			</cfif>
		</cfoutput>
		if (vs_codigo!="") {
			var fr = document.getElementById("fr");
			fr.src = "/cfmx/rh/nomina/operacion/rhtraeplaza_accion.cfm?codigo="+vs_codigo+params;
		} else {
			document.form1.RHPPid.value = '';
			document.form1.RHPPcodigo.value = '';
			document.form1.RHPPdescripcion.value = '';
			if (document.form1.RHPPid.value == ''){
				document.form1.RHPcodigo.value = '';
				document.form1.RHPcodigoext.value = '';
				document.form1.RHPdescpuesto.value = '';
			}
		}
	}

	function doConlisPuesto() {		
		if (document.form1.RHPPid.value == ''){
			<cfoutput>alert("#MSG_Debe_seleccionar_la_plaza#")</cfoutput>;
		}
		else{
			<cfoutput>
				var params = '?form=form1&empresa=#vn_Ecodigo#';
			</cfoutput>		
			<cfif isdefined("usaEstructuraSalarial") and usaEstructuraSalarial EQ 1 and rsAccion.RHTccatpaso EQ 1  AND (len(trim(rsAccion.IDInterfaz)) EQ 0)>
				params = params + "&RHMPPid="+document.form1.RHMPPid.value;
			</cfif>
			
			popUpWindow("/cfmx/rh/nomina/operacion/ConlisPuestos_acciones.cfm"+params,200,150,600,400);
		}
	}
	function FuncTraePuesto(vs_codigo){
		if (document.form1.RHPPid.value == ''){
			<cfoutput>alert("#MSG_Debe_seleccionar_la_plaza#")</cfoutput>;
				document.form1.RHPcodigo.value = '';
				document.form1.RHPcodigoext.value = '';
				document.form1.RHPdescpuesto.value = '';
		}
		else{			
			
			<cfoutput>
				var params = '&form=form1&empresa=#vn_Ecodigo#';	
			</cfoutput>
			<cfif isdefined("usaEstructuraSalarial") and usaEstructuraSalarial EQ 1 and rsAccion.RHTccatpaso EQ 1  AND (len(trim(rsAccion.IDInterfaz)) EQ 0)>
				params = params + "&RHMPPid="+document.form1.RHMPPid.value;
			</cfif>
			if (vs_codigo!="") {
				var fr = document.getElementById("fr");
				fr.src = "/cfmx/rh/nomina/operacion/rhtraepuesto_accion.cfm?codigo="+vs_codigo+params;
			} else {
				document.form1.RHPcodigo.value = '';
				document.form1.RHPcodigoext.value = '';
				document.form1.RHPdescpuesto.value = '';
			}
		}	
	}
</script>