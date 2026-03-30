<cfparam name="LvarPagina" default="AbrirCaja.cfm">
<cfparam name="LvarSQLPagina" default="SQLAbrirCaja.cfm">

<cfif len(trim(session.EcodigoSDC)) gt 0 >
 <cfset EUcodigoUsuario = Session.Usucodigo>

	<!--- Si no está definida la sesión debe liberar la caja que el usuario tiene abierta --->
	<!---<cfif not isDefined("Session.Caja")>
		<cfquery name="delCajaActiva" datasource="#Session.DSN#">
		    delete FCajasActivas where EUcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EUcodigoUsuario#">
		</cfquery>
	</cfif>--->

  <!--- Descripcion: Si existe un usuario que ya ha utilizado la caja, nadie mas la podr[a utilizar hasta que se haga el cierre de la caja, en ese momento la caja se liberar[a. En ese momento otro usuario podra tomar la caja y liberarla hasta que haga el cierre de caja --->

    <cfif isDefined('url.CJC') and url.CJC EQ 2><!--- Supervisor --->
          <!--- Cajas asignadas al usuario --->
            <cfquery name="rsCajasUsuario" datasource="#Session.DSN#">
                select <cf_dbfunction name="to_char"	args="b.FCid"> as FCid, b.FCcodigo, b.FCdesc
                from  FCajas b
                where  b.Ecodigo = #Session.Ecodigo#
            </cfquery>

    <cfelse>
			<!--- Cajas asignadas al usuario --->
            <cfquery name="rsCajasUsuario" datasource="#Session.DSN#">
                select <cf_dbfunction name="to_char"	args="a.FCid"> as FCid, b.FCcodigo, b.FCdesc,
								isnull(b.MontoFondeo,0.00) MontoFondeo, b.FCestado
                from UsuariosCaja a, FCajas b
                where a.EUcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EUcodigoUsuario#">
                  and b.Ecodigo = #Session.Ecodigo#
                   and b.FCestado = 0
                  and a.FCid = b.FCid
                union all
              select <cf_dbfunction name="to_char"	args="a.FCid"> as FCid, b.FCcodigo, b.FCdesc,
								isnull(b.MontoFondeo,0.00) MontoFondeo, b.FCestado
                from FCajasActivas a, FCajas b
                where a.EUcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EUcodigoUsuario#">
                  and b.Ecodigo = #Session.Ecodigo#
                   and b.FCestado = 1
                  and a.FCid = b.FCid
            </cfquery>

      </cfif>

	<!--- Cajas Activas --->
	<cfquery name="rsCajasActivas" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_char"	args="FCid"> as FCid, <cf_dbfunction name="to_char"	args="EUcodigo"> as EUcodigo, FCAfecha
		from FCajasActivas
	</cfquery>

    <!--- Saca el cierre pendiente para esta caja --->
    <cfquery name="rsCierre" datasource="#session.DSN#">
        select <cf_dbfunction name="to_char"	args="FCid"> as FCid, convert(varchar, max(FACid)) as FACid
        from FACierres
        where FACestado='P'
        group by FCid
    </cfquery>

</cfif>
  <cfset caja = -1>
  <cfset EUcodigoUsuario = Session.Usucodigo>
<!--- Guarda la caja que está en la sesión --->
<cfif isDefined("Session.Caja") and Len(Trim(Session.Caja)) GT 0>
	<cfset caja = Session.Caja>
    <cfset EUcodigoUsuario = Session.Usucodigo>
</cfif>
<cf_templateheader title="Facturaci&oacute;n">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
        <cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="Abrir Caja">
		  <script language="JavaScript1.2" type="text/javascript">

			function Activa() {
				var f = document.form1;
				var valor = 0;
				var salir = false;

				<cfif len(trim(session.EcodigoSDC)) gt 0 >
					<cfloop query="rsCajasActivas">

						if (!salir && f.FCid.value == "<cfoutput>#rsCajasActivas.FCid#</cfoutput>") {
							if ("<cfoutput>#trim(EUcodigoUsuario)#</cfoutput>" != "<cfoutput>#trim(rsCajasActivas.EUcodigo)#</cfoutput>"){
								salir = true;
								valor = 2;
							}

						}
					 </cfloop>
				</cfif>

				 return valor;
			}

			function PenCierre() {
				var f = document.form1;
				var valor = 0;
				var salir = false;

				<cfif len(trim(session.EcodigoSDC)) gt 0 >
					<cfloop query="rsCierre">
						if (!salir && f.FCid.value == "<cfoutput>#rsCierre.FCid#</cfoutput>") {
							salir = true;
							valor = 1;
						}
					 </cfloop>
				</cfif>

				 return valor;
			}

			function valida() {
				<cfif rsCajasUsuario.Recordcount GT 0>
				if (PenCierre() == 1) {
					alert('Esta caja no puede ser abierta debido a que tiene pendiente un cierre');
					return false;
				}
				if (Activa() == 0) {
					return confirm('La caja no está abierta. Desea abrirla?');
				}
				else {
					if (Activa() == 1) {
						alert('La caja ya está abierta por él mismo');
						return false;
					}
					else {
						if (Activa() == 2) {
							alert('La caja ya está abierta por otro usuario');
							return false;
						}
					}
				}
				<cfelse>
					alert('No hay cajas activas para este usuario.\n Debe definirlas en el catálogo de cajas.');
				</cfif>
				return false;
			}

		  </script>

		  <form name="form1" method="post" action="<cfoutput>#LvarSQLPagina#</cfoutput>">
		      <table width="50%" border="0" cellspacing="0" cellpadding="0" align="center">
                <cfoutput>
                 <cfif isDefined('url.CJC') and url.CJC EQ 2><!--- Supervisor --->
                  <tr>
                      <td colspan="3" align="center">
                         <strong> Opcion de supervisor:</strong> Seleccione la caja para revision.
                      </td>
                  </tr>
                  <tr>
                     <td colspan="3">
                      &nbsp;
                     </td>
                  </tr>
                  </cfif>
                  <tr>
                    <td width="47%"><div align="right"><font size="2"><strong>Usuario:</strong></font></div></td>
                    <td width="3%">&nbsp;</td>
                    <td width="50%"><strong><font color="##000099" size="2">#Session.Usuario#</font></strong>
                    <input type="hidden" name="EUcodigoUsuario" value="#Session.Usucodigo#" />
					<cfif IsDefined('url.CC') and url.CC eq 1>
						<input type="hidden" name="CC" value="#url.CC#" />
					</cfif>
                    <cfif IsDefined('url.lq') and url.lq eq 1>
						<input type="hidden" name="lq" value="#url.lq#" />
					</cfif>
					<cfif isDefined('url.nc') and url.nc EQ 1>
						<input type="hidden" name="nc" value="#url.nc#" />
					</cfif>
                   <cfif isDefined('url.CJC') and url.CJC EQ 1>
						<input type="hidden" name="CJC" value="#url.CJC#" />
					</cfif>
                    <cfif isDefined('url.CJC') and url.CJC EQ 2><!--- Supervisor --->
						<input type="hidden" name="CJC" value="#url.CJC#" />
					</cfif>
                    <cfif isDefined('url.IR') and url.IR EQ 1>
						<input type="hidden" name="IR" value="#url.IR#" />
					</cfif>
					</td>
                  </tr>
                  <tr>
                    <td><div align="right"><font size="2"><strong>Caja:</strong></font></div></td>
                    <td>&nbsp;</td>
                    <td><font size="2"><strong>
                      <select name="FCid" required="" onChange="cambiaCaja(this.value)">
												<option value="" > -- Seleccione una caja --</option>
                        <cfloop query="rsCajasUsuario">
                          <option value="#FCid#">#trim(FCcodigo)#, #FCdesc#</option>
                        </cfloop>
                      </select>
                      </strong></font></td>
                  </tr>
									<tr>
                    <td><div align="right"><font size="2"><strong>Monto de fondeo:</strong></font></div></td>
                    <td>&nbsp;</td>
                    <td><font size="2"><strong>
                      <input id="AumentoFondo" readonly="true" type="text" value="0.00" name="AumentoFondo" required="" onkeypress="return soloNumeros(event);" >
                      </strong></font></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td colspan="3"><div align="center">
                      <cfif isDefined('url.CJC') and url.CJC EQ 2><!--- Supervisor --->
                        <input name="btnAceptar" type="submit" value="Abrir" >
                      <cfelse>
                        <input name="btnAceptar" type="submit" value="Abrir" onClick="javascript: return valida();">
                      </cfif>
						<input name="EUcodigo" type="hidden" value="#Session.Usucodigo#">
                      </div></td>
                  </tr>
                </cfoutput>
              </table>
		  </form>
			<script type="text/javascript">
				function soloNumeros(e) {
							var keynum = window.event ? window.event.keyCode : e.which;
							if ((keynum == 8) || (keynum == 46))
							return true;
							
							return /\d/.test(String.fromCharCode(keynum));
				}

				function cambiaCaja(value){
					<cfoutput>
					$('##AumentoFondo').val(0.00);
					$('##AumentoFondo').prop('readonly', false);
						<cfloop query="rsCajasUsuario">
								if( #rsCajasUsuario.FCid# == value){
									$('##AumentoFondo').val(#numberformat(rsCajasUsuario.MontoFOndeo,'9.99')#);
									if( #rsCajasUsuario.FCestado# != 0){
										$('##AumentoFondo').prop('readonly', true);
									}
								}
						</cfloop>
					</cfoutput>
				}
			</script>
	<cf_web_portlet_end>
<cf_templatefooter>