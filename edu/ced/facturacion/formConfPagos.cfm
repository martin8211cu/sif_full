<cfif isdefined("form.nombre") and len(trim(form.nombre)) NEQ 0>
	<cfif isdefined("Url.nombre") and not isdefined("Form.nombre")>
		<cfparam name="Form.nombre" default="#Url.nombre#">
	</cfif>
	<cfif isdefined("Url.Pid") and not isdefined("Form.Pid")>
		<cfparam name="Form.Pid" default="#Url.Pid#">
	</cfif>
	<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
		<cfparam name="Form.persona" default="#Url.persona#">
	</cfif>
	<cfif isdefined("Url.EEcodigo") and not isdefined("Form.EEcodigo")>
		<cfparam name="Form.EEcodigo" default="#Url.EEcodigo#">
	</cfif>
	
	<!---  Para el check de Encargado  --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsEncar">
		Select convert(varchar,a.EEcodigo) as EEcodigo, a.autorizado, 
		convert(varchar,a.Usucodigo) as Usucodigo, convert(varchar,a.Ulocalizacion) as Ulocalizacion,
		a.CBctacliente, convert(varchar,b.Ecodigo) as Ecodigo
		from Encargado a, EncargadoEstudiante b
		where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		  and a.EEcodigo = b.EEcodigo
	</cfquery>
	<cfif rsEncar.RecordCount GT 0 and len(trim(rsEncar.Usucodigo)) GT 0>	
		<cfquery datasource="#Session.Edu.DSN#" name="rsUsuarioCuenta">
			select convert(varchar,Usucodigo) as Usucodigo, Ulocalizacion, Cmaestra
			from UsuarioCuenta
			where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncar.Usucodigo#">
		</cfquery>
		<cfquery datasource="#Session.Edu.DSN#" name="rsDepen">
			select *, substring((a.Papellido1 + ' ' + a.Papellido2 + ',' + a.Pnombre),1,60) as Nombre
			from   PersonaEducativo a, Alumnos c, EncargadoEstudiante b
			where b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and a.persona = c.persona 
			  and b.Ecodigo = c.Ecodigo
			  and b.EEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncar.EEcodigo#">
		</cfquery>
		<cfquery datasource="#Session.Edu.DSN#" name="rsEncargadoEstudiante">
		 	select * from EncargadoEstudiante
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		</cfquery>

	</cfif>

<form action="SQLConfPagos.cfm" method="post" id="formPagos" name="formPagos">
	<table width="100%" border="0">
      <cfif isdefined("form.nombre")>
			<tr> 
            	<td colspan="2" class="tituloMantenimiento" align="center"><font size="4"> 
    	        	<strong>Facturaci&oacute;n</strong> </font> <br> <font size="3"><strong><cfoutput>#form.nombre# - #form.Pid#</cfoutput> </strong> </font>
				</td>
			</tr>
		</cfif>
<!--- <cfif modo EQ "CAMBIO" and rsEncar.RecordCount GT 0 and len(trim(rsEncar.Usucodigo)) GT 0> --->
		<tr>
			<td width="59%">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr> 
            <td width="22%">&nbsp;</td>
            <td width="78%"> <input name="Usucodigo" id="Usucodigo" value="<cfif isdefined("form.persona") and #rsEncar.RecordCount# neq 0><cfoutput>#rsEncar.Usucodigo#</cfoutput></cfif>" type="hidden"> 
              <input name="Ulocalizacion" id="Ulocalizacion2" value="<cfif isdefined("form.persona") and  #rsEncar.RecordCount# neq 0><cfoutput>#rsEncar.Ulocalizacion#</cfoutput></cfif>" type="hidden"> 
            </td>
          </tr>
	
          <cfif isdefined("form.persona") and rsUsuarioCuenta.RecordCount GT 0 and len(trim(rsUsuarioCuenta.Cmaestra)) GT 0>
            <tr> 
                <td nowrap> 
                  <input type="radio" name="rbCta" value="0" checked>
                  Usar Cuenta Existente </td>
              <td><select name="CboCuentaEnc">
                  <cfoutput query="rsUsuarioCuenta"> 
                    <cfif #rsUsuarioCuenta.Cmaestra# EQ #rsEncar.EEcuenta#>
                      <option value="#rsUsuarioCuenta.Cmaestra#" selected>#rsUsuarioCuenta.Cmaestra#</option>
                      <cfelse>
                      <option value="#rsUsuarioCuenta.Cmaestra#">#rsUsuarioCuenta.Cmaestra#</option>
                    </cfif>
                  </cfoutput> </select></td>
            </tr>
          </cfif>
          <tr> 
              <td nowrap> 
                <input type="radio" name="rbCta" value="1" <cfif isdefined("form.persona") and  rsUsuarioCuenta.RecordCount EQ 0 >checked</cfif>>
                Crear Cuenta Nueva &nbsp;</td>
            <td>&nbsp;
				<input name="persona" type="hidden" value="<cfif isdefined("form.persona") and form.persona neq ""><cfoutput>#form.persona#</cfoutput></cfif>">
				<input name="EEcodigo" type="hidden" value="<cfif isdefined("form.EEcodigo") and form.EEcodigo neq ""><cfoutput>#form.EEcodigo#</cfoutput></cfif>">
			</td>
          </tr>
          <tr> 
              <td nowrap>N&uacute;mero de Cuenta Cliente</td>
            <td> <input name="CuentaCliente" type="text" id="CuentaCliente"  onFocus="this.select()" size="20" maxlength="17" value="<cfif isdefined("form.persona") ><cfoutput>#rsEncar.CBctacliente#</cfoutput></cfif>"> 
            </td>
          </tr>
		  
        </table>
			</td>
			
        <td width="41%" valign="top"> 
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top"> 
						
              <td height="21" colspan="3" align="center" nowrap ><strong>Lista 
                de Alumnos Dependientes</strong> </td>
					</tr>
					<cfoutput query="rsDepen"> 
						<cfif rsEncar.RecordCount GT 0>
							<cfquery dbtype="query" name="rsEncarCount">
								 Select Ecodigo from rsEncargadoEstudiante 
								 where EEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDepen.EEcodigo#">
								    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDepen.Ecodigo#">
								    and EEpago = 1
							</cfquery>
						</cfif>
						<tr> 
						  <td width="33%" height="19" align="right"> <input type="checkbox" name="PagaEncar" value="#rsDepen.Ecodigo#" <cfif  rsEncarCount.recordCount GT 0> checked</cfif>></td>
						  <td width="4%" align="right">&nbsp;</td>
						  <td width="63%">#rsDepen.Nombre#</td>
						</tr>
					</cfoutput> 
				</table>
			</td>
		</tr>
		<tr>
			<td  colspan="2" align="center"><input name="btnGenerar" type="submit" id="btnGenerar" value="Generar" >
			</td>
		</tr>
	</table>
	</form>
<cfelse>
	<table border="0" width="100%">
		<tr> 
			<td colspan="2" class="tituloMantenimiento" align="center">
				<font size="3"> 
					<strong>
						Por favor Seleccione un encargado de la lista.
					</strong>
				</font>
			</td>
		</tr>
	</table>
</cfif>