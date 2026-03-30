<cf_templatecss>
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<!----////////////////////////////////DATOS DEL FRAME DE COMPONENTES/////////////////////////////////----->
<cfif (isdefined("url.RHPEid") and len(trim(url.RHPEid))) and (isdefined("url.RHEid") and len(trim(url.RHEid)))>
	<!---Datos de la Plaza---->
	<cfquery name="rsPlazaRH" datasource="#session.DSN#">
		select <cf_dbfunction name="concat" args="ltrim(rtrim(c.RHPcodigo)),' - ',ltrim(rtrim(c.RHPdescripcion))"> as PlazaRH,
				<cf_dbfunction name="concat" args="ltrim(rtrim(b.RHPPcodigo)),' - ',ltrim(rtrim(b.RHPPdescripcion))"> as PlazaP,
				d.RHLTPfdesde,
				case d.RHLTPfhasta  when '61000101' then 'Indefinido'
									else convert(varchar,d.RHLTPfhasta,103)
				end as RHLTPfhasta,
				a.RHPEfinicioplaza,
				case a.RHPEffinplaza  when '61000101' then 'Indefinido'
									else convert(varchar,a.RHPEffinplaza,103)
				end as RHPEffinplaza
				
		from RHPlazasEscenario a
			inner join RHPlazaPresupuestaria b
				on a.RHPPid = b.RHPPid
			inner join RHLineaTiempoPlaza d
				on b.RHPPid = d.RHPPid	
			inner join RHPlazas c
				on b.RHPPid = c.RHPPid
				and b.Ecodigo = c.Ecodigo
		where a.Ecodigo  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">
			and a.RHPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHPEid#">
	</cfquery>
	<!----Fechas del escenario--->
	<!----<cfquery name="rsEscenario" datasource="#session.DSN#">	
		select RHEfdesde, RHEfhasta from RHEscenarios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEid#">
	</cfquery>---->
	<cf_dbfunction name="to_char" args="a.RHCPid" returnvariable="Lvar_RHCPid">
	<cf_dbfunction name="concat" args="'<img border=''0'' onClick=''javascript: funcEliminar('	|#preservesinglequotes(Lvar_RHCPid)#|');'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>'" returnvariable="Lvar_img" delimiters="|">
	<cfquery name="rsComponentes" datasource="#session.DSN#">
		select 	a.RHPEid,
				a.RHCPid,
				a.Cantidad,
				a.Monto,
				ltrim(rtrim(b.CScodigo)) as Codigo,
				ltrim(rtrim(b.CSdescripcion)) as Descripcion,
				#preservesinglequotes(Lvar_img)# as eliminar				
		from RHComponentesPlaza a
			inner join ComponentesSalariales b
				on a.CSid = b.CSid 
				and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and a.RHPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHPEid#">
		order by b.Codigo, b.Descripcion
	</cfquery>
	<!----<cfset vn_llaves = ValueList(rsComponentes.RHDTEid)>--->
</cfif>
<form name="formComponentes" action="" method="post">
	<cfoutput>
		<input type="hidden" name="RHEid" 	value="<cfif isdefined("url.RHEid") and len(trim(url.RHEid))>#url.RHEid#</cfif>">
		<input type="hidden" name="RHPEid" value="<cfif isdefined("url.RHPEid") and len(trim(url.RHPEid))>#url.RHPEid#</cfif>">
		<input type="hidden" name="RHCPidEliminar" value="">
	</cfoutput>

	<table width="100%" cellpadding="1" cellspacing="0" border="0">
		<tr>
			<td width="19%" nowrap="nowrap" class="tituloListas">
				<strong style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Puesto Presupuestario:</strong>			
			</td>
			<td width="48%" class="tituloListas">
				<cfif isdefined("rsPlazaRH") and rsPlazaRH.RecordCount NEQ 0>
					<cfoutput>
						<strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">#rsPlazaRH.PlazaP#</strong>
					</cfoutput>
				</cfif>
		  </td>
			<td width="6%" class="tituloListas" nowrap="nowrap">
				<strong style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Presupuestada para:</strong>			
			</td>
			<td width="27%" class="tituloListas">
				<cfif isdefined("rsPlazaRH") and rsPlazaRH.RecordCount NEQ 0>
					<cfoutput>
						<strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">#LSDateFormat(rsPlazaRH.RHLTPfdesde,'dd/mm/yyyy')# al #rsPlazaRH.RHLTPfhasta#</strong>
					</cfoutput>
				</cfif>
		  </td>
		</tr>		
		<cfif isdefined("url.DEid") and len(trim(url.DEid))>
			<cfquery name="empl" datasource="#session.DSN#">
				select DEidentificacion ,DEnombre, DEapellido1, DEapellido2
				from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			</cfquery>
			<tr>
				<td width="19%" nowrap="nowrap" class="tituloListas" align="right">
					<strong style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Ocupada por:</strong>				
				</td>
				<td class="tituloListas" >
					<cfoutput>
						<strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">#empl.DEidentificacion# - #empl.DEnombre# #empl.DEapellido1# #empl.DEapellido2#</strong>
					</cfoutput>
				</td>
				<td class="tituloListas">
					<strong style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Fechas:</strong>
				</td>
				<td class="tituloListas" align="left">
					<cfif isdefined("rsPlazaRH") and rsPlazaRH.RecordCount NEQ 0>
						<cfoutput>
							<strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">#LSDateFormat(rsPlazaRH.RHPEfinicioplaza,'dd/mm/yyyy')# al #rsPlazaRH.RHPEffinplaza#</strong>
						</cfoutput>
					</cfif>
				</td>
		  </tr>
	  	</cfif>
		<tr align="right"><td class="tituloListas" colspan="4" align="right">
			<table width="100%" align="right" border="0">
				<tr><td width="1%">&nbsp;</td><td align="right">
					<cfoutput>
						<input type="button" name="btn_regresar" value="<< Anterior" onclick="javascript: window.parent.funcRegresaPlazas('#url.RHEid#');" />
					</cfoutput> 
				</td><td width="1%">&nbsp;</td></tr>
			</table>
		</td></tr>
		<tr>
			<td colspan="8">
				<fieldset><legend align="center" style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">Detalle de Componentes</legend>
				<table width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr class="titulocorte">
						<td width="18%"><strong>Código</strong></td>
						<td width="22%"><strong>Descripci&oacute;n</strong></td>
						<td width="19%"><strong>Cantidad</strong></td>
						<td width="24%" align="right"><strong>Monto</strong></td>
						<td width="17%" align="right">&nbsp;</td>
					</tr>
					<cfif isdefined("rsComponentes") and rsComponentes.RecordCount NEQ 0>
						<cfoutput query="rsComponentes">
							<tr class="<cfif rsComponentes.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
								<td width="18%">#rsComponentes.Codigo#</td>
								<td width="22%">#rsComponentes.Descripcion#</td>
								<td width="19%">#rsComponentes.Cantidad#</td>
								<td align="right" width="24%">#LSNumberFormat(rsComponentes.Monto,',9.00')#</td>							
								<td align="right" style="cursor:pointer;" width="17%"></td>
							</tr>
						</cfoutput>
					<cfelse>						
						<tr><td colspan="6" align="center"><strong>------  No hay componentes asignados a la plaza presupuestaria ------</strong></td></tr>									
					</cfif>	
				</table>
				</fieldset>
			</td>
		</tr>			
		<tr><td colspan="6">&nbsp;</td></tr>
	</table>
</form>	

<!----////////////////////////// INSERTAR NUEVO COMPONENTE, ELIMINAR UNO, O MODIFICAR////////////////////////////////////----->
<cfif isdefined("form.btn_nuevo") or isdefined("form.btn_modifica") or (isdefined("form.RHCPidEliminar") and len(trim(form.RHCPidEliminar)))>
	<!---Insertado de nuevo componente salarial---->
	<cfif isdefined("form.btn_nuevo") and isdefined("form.RHEid") and len(trim(form.RHEid)) and isdefined("form.RHPEid") and len(trim(form.RHPEid))>	
		<cftransaction>		
			<cfquery name="rsMoneda" datasource="#session.DSN#">
				select Mcodigo
				from Empresas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfquery name="Inserta" datasource="#session.DSN#">
				insert into RHComponentesPlaza (RHPEid, 
												CSid, 
												Ecodigo, 
												Cantidad, 
												Monto, 
												CFformato, 
												BMfecha, 
												BMUsucodigo
												)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPEid#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_float" value="#form.CantidadNuevo#">,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.MontoNuevo,',','','all')#">,
							 <cfif isdefined("form.CIcuentac") and len(trim(form.CIcuentac))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CIcuentac#"><cfelse>null</cfif>,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
							)
			</cfquery>	
		</cftransaction>	
	<!----Modificacion de montos------>
	<cfelseif isdefined("form.btn_modifica") and isdefined("form.RHCPid") and len(trim(form.RHCPid))>
		<cftransaction>
			<cfloop list="#form.RHCPid#" index="i">				
				<cfif isdefined("form.Monto_#i#") and len(trim(form['Monto_#i#']))>
					<cfquery datasource="#session.DSN#">
						update RHComponentesPlaza 
							set Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['Monto_#i#'],',','','all')#">						
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">						
					</cfquery>
				</cfif>
			</cfloop>
		</cftransaction>		
	<!----Borrado de componente---->
	<cfelseif isdefined("form.RHCPidEliminar") and len(trim(form.RHCPidEliminar))>
		<cftransaction>
			<cfquery name="Delete" datasource="#session.DSN#">
				delete from RHComponentesPlaza
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPidEliminar#">	
			</cfquery>
		</cftransaction>
	</cfif>	
	<script type="text/javascript" language="javascript1.2">
		document.formComponentes.submit();	
	</script>
</cfif>
