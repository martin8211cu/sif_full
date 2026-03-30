	<cf_templatecss>
	<link type="text/css" rel="stylesheet" href="../../tramites.css"> 

	<cfquery datasource="#session.tramites.dsn#" name="buscar">
		select p.id_persona, 
			   f.id_funcionario, 
			   f.id_inst, 
			   v.id_ventanilla, 
			   v.nombre_ventanilla,
			   s.id_sucursal,
			   s.nombre_sucursal
		from TPPersona p
		
		inner join TPFuncionario f
		on p.id_persona = f.id_persona

	    inner join TPRFuncionarioVentanilla rel
		on f.id_funcionario = rel.id_funcionario
				
		inner join TPVentanilla v
		on v.id_ventanilla = rel.id_ventanilla
		
		inner join TPSucursal s
		on s.id_sucursal = v.id_sucursal
		
		where p.identificacion_persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.datos_personales.id#">
		order by s.nombre_sucursal, v.nombre_ventanilla
	</cfquery>

<cfif buscar.recordcount gt 1 >
		<form name="form1" method="post" action="abrir-ventanilla-sql.cfm">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
				  <td colspan="3" bgcolor="#ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong><font size="2">Seleccionar Ventanilla</font></strong></td>
				</tr>

				<tr><td>&nbsp;</td></tr>

				<tr>
					<td width="1%" nowrap>Seleccione la ventanilla:&nbsp;</td>
					<td width="1%">
						<cfoutput>
						<select name="id_ventanilla" >
							<option value="" >- seleccionar -</option>
							<cfset c_sucursal = "">
							<cfloop query="buscar">
								<cfif (c_sucursal neq id_sucursal) or CurrentRow EQ 1>
									<cfif CurrentRow NEQ 1>
										</optgroup>
									</cfif>
									<cfset c_sucursal = id_sucursal>
									<optgroup label="#HTMLEditFormat(nombre_sucursal)#">
								</cfif>
								<option value="#id_ventanilla#" >#HTMLEditFormat(nombre_ventanilla)# </option>
							</cfloop>
						</select>
						</cfoutput>
					</td>
					<td><input type="submit" style="width:100px; " class="boton" name="Abrir" value="Abrir Ventanilla"> </td>
				</tr>

				<cfif isdefined("url.abierta") and isdefined("url.id_ventanilla") and len(trim(url.id_ventanilla))>
					<cfquery name="abierta" datasource="#session.tramites.dsn#">
						select nombre_ventanilla as nombre
						from TPVentanilla
						where id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_ventanilla#">
					</cfquery>
					<tr><td colspan="3"><em>La ventanilla <cfoutput>#abierta.nombre#</cfoutput> esta abierta por otro funcionario.</em></td>
					</tr>
				</cfif>

			</table>
		</form>
	<cfelseif buscar.recordcount eq 1 >
		<cfif isdefined("url.abierta") and isdefined("url.id_ventanilla") and len(trim(url.id_ventanilla))>
			<cfquery name="abierta" datasource="#session.tramites.dsn#">
				select nombre_ventanilla as nombre
				from TPVentanilla
				where id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_ventanilla#">
			</cfquery>
			  <table width="530" border="0" align="center" style="border:1px solid gray" bgcolor="#FAFAFA">
				<tr><td colspan="3" align="center">Usted ha sido asociado unicamente a la ventanilla <cfoutput>#abierta.nombre#</cfoutput>.</td></tr>
				<tr><td colspan="3" align="center">En este momento, esa ventanilla se encuentra abierta por otro funcionario.</td></tr>
				<cfoutput>
				<tr><td colspan="3" align="center"><a href="/cfmx/home/tramites/Operacion/portlet/abrir-ventanilla-sql.cfm?id_ventanilla=#buscar.id_ventanilla#">Intentar de Nuevo</a></td></tr>
				</cfoutput>
			  </table>
		<cfelse>
			<cflocation url="/cfmx/home/tramites/Operacion/portlet/abrir-ventanilla-sql.cfm?id_ventanilla=#buscar.id_ventanilla#" >
		</cfif>
	<cfelse>
	  <table width="530" border="0" align="center" style="border:1px solid gray" cellpadding="5" bgcolor="#FAFAFA">
		<TR>
		  <TD align="center">Usted no esta asociado a ninguna ventanilla.</TD>
		</TR>
	  </table>
	</cfif>