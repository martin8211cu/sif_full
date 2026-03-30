<cfset debug = false>

<!--- EJB --->
<cfset EjbUser = 'guest'>
<cfset EjbPass = 'guest'>
<cfset EjbJndi = 'SdcSeguridad/Afiliacion'>

<cfscript>
	function getAfiliacionEJB ( )
	{
		var home = 0;
		var prop = 0;

		if (IsDefined ("__AfiliacionStub")) {
			return __AfiliacionStub;
		}

		// initial context
		prop = CreateObject("java", "java.util.Properties" );
		initContext = CreateObject("java", "javax.naming.InitialContext" );
		// especificar propiedades, esto se requiere para objetos remotos
		prop.init();
		prop.put(initContext.SECURITY_PRINCIPAL, EjbUser);
		prop.put(initContext.SECURITY_CREDENTIALS, EjbPass);
		initContext.init(prop);
		
		// ejb lookup
		home = initContext.lookup(EjbJndi);
		
		// global var, reuse
		__AfiliacionStub = home.create();
		return __AfiliacionStub;
	}
</cfscript>

<form action="recibo_ok.cfm" method="post" name="f">
<cfif debug>
    <table border="0" align="center" width="75%" cellpadding="2" cellspacing="0">
        <tr>
            <td class="listaCorte">Procesando registros...</td>
        </tr>
</cfif>
        <cfset tablerownum = 0>
        <cfloop from="0" to="15" index="n">
            <cfset contrato="contrato_" & n>
            <cfset email="email_" & n>
            <cfset login="login_" & n>
            <cfset status="status_" & n>
            <cfif isdefined('form.' & contrato) and isdefined('form.' & email) and len(trim(evaluate('form.' & contrato))) and len(trim(evaluate('form.' & email)))>
                <cfset tablerownum = tablerownum + 1 >
					<!-- falta: validar autorizacion sobre los datos
					SOY PSO
					|| SOY AGENTE DEL USUARIO Y EL ROL ES PERSONAL
					|| SOY ADMIN DE LA CTA EMP Y EL ROL ES EMPRESARIAL
					--->
                <cfquery name="data" datasource="SDC">
					select u.Papellido1
                    	+ ' ' + u.Papellido2 + ', ' + u.Pnombre as nombre,
						up.id as contrato, u.Usulogin as login, u.Usucodigo, u.Ulocalizacion
                    from UsuarioPermiso up, Usuario u
					where up.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate('form.' & contrato)#">
                      and u.Usucodigo = up.Usucodigo 
					  and u.Ulocalizacion = up.Ulocalizacion
                      and up.activo = 1 
					  and u.activo = 1 
					  and u.Usutemporal = 1

                    update UsuarioPermiso
					set fecha_recibido = getdate() ,
					    num_recibido = num_recibido + 1 ,
						fecha_enviada = getdate() , 
						num_enviada = num_enviada + 1 , 
						BMUsucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                    	BMUlocalizacion =  <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
						BMUsulogin =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
						BMfechamod = getdate()
                    from UsuarioPermiso up, Usuario u
					where up.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate('form.' & contrato)#">
                      and u.Usucodigo = up.Usucodigo 
					  and u.Ulocalizacion = up.Ulocalizacion
                      and up.activo = 1 
					  and u.activo = 1 
					  and u.Usutemporal = 1
					  
					insert UsuarioBitacora (Usucodigo, Ulocalizacion, UBtipo, UBumod,
					UBfmod, UBdata)
					select up.Usucodigo, up.Ulocalizacion, 'contratoAdhesion',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
						getdate(), 'recibido'
                    from UsuarioPermiso up, Usuario u
					where up.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate('form.' & contrato)#">
                      and u.Usucodigo = up.Usucodigo 
					  and u.Ulocalizacion = up.Ulocalizacion
                      and up.activo = 1 
					  and u.activo = 1 
					  and u.Usutemporal = 1
				</cfquery>
                <cfset rowstyle="listaNon">
                <cfif tablerownum Mod 2 eq 0>
	                <cfset rowstyle="listaPar">
                </cfif>
                <cfif data.Recordcount eq 0>
					<cfif debug>
						<tr class="<cfoutput>#rowstyle#</cfoutput>">
							<td><em>
								<cfoutput>#contratonum#</cfoutput>
								Este contrato no existe o no est&aacute; bajo su
								responsabilidad</em></td>
						</tr>
					</cfif>
                <cfelse>
					<cfif debug>
						<tr class="<cfoutput>#rowstyle#</cfoutput>">
							<td>
					</cfif>
							<cfoutput>
                            <input type="hidden" name="#contrato#" value="#evaluate('form.'&contrato)#">
                            <input type="hidden" name="#email#"    value="#evaluate('form.'&email)#">
                            <input type="hidden" name="#login#"    value="#evaluate('form.'&login)#">
							</cfoutput>
							<cfif debug>
                            	Procesando
	                            <cfoutput> email:#evaluate('form.'&email)# login:#evaluate('form.'&login)#</cfoutput>
							</cfif>
                            <cfif len(trim(evaluate('form.'&login))) eq 0>
								<cfif debug>
                                	usuario nuevo...
								</cfif>
                                <cfif len(trim(evaluate('form.'&email))) gt 0>
									<cfif debug>
	                                	actualizando email...
									</cfif>
                                    <cfquery name="upddata" datasource="SDC">
										update Usuario
										set Pemail1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.' & email)#">,
											Pemail1validado = 1
										from UsuarioPermiso up, Usuario u
										where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate('form.' & contrato)#">
										  and up.activo = 1
										  and u.Usucodigo = up.Usucodigo
                                          and u.Ulocalizacion = up.Ulocalizacion
										  and u.Usutemporal = 1
										  and u.activo = 1
										update UsuarioEmpresarial
										set Pemail1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.' & email)#">
										from UsuarioPermiso up, UsuarioEmpresarial u
										where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate('form.' & contrato)#">
										  and up.activo = 1
										  and u.Usucodigo = up.Usucodigo
                                          and u.Ulocalizacion = up.Ulocalizacion
										  and u.activo = 1
                                    </cfquery>
									<!--
										actualizar email en el sistema ORIGEN ??? solo aplica para educacion*..PersonaEducativo
										que realmente esta en otro cache / base de datos, y que es variable segun el centro
										educativo.  En un futuro no muy lejano, esperamos que esta informacion este consolidada
										en la base de datos del sdc
									-->
                                </cfif>
                                <cfif debug>
									prepararUsuarioTemporal...
								</cfif>
								<cfset resultado = ''>
								<cfif debug>
									<cfoutput>EJB: #getAfiliacionEJB()# </cfoutput>
									<cfdump var="#data#">
								</cfif>
								<!---<cftry>--->
									<cfscript>
										getAfiliacionEJB().prepararUsuarioTemporal(data.Usucodigo,data.Ulocalizacion,true);
									</cfscript>									
								<!---<cfcatch>
										<cfinclude template="../../../errorPages/BDerror.cfm">
										<cfabort>
									</cfcatch>
								</cftry>--->
							<cfelse>
								<cfif debug>
                                	unificar usuarios...
								</cfif>
								<cfquery name="existente" datasource="SDC">
									select Usucodigo, Ulocalizacion
									from Usuario
									where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.' & login)#">
									  and Usutemporal = 0
									  and activo = 1
								</cfquery>
								<cfif existente.Recordcount eq 0>
									<cfset resultado="El login " & evaluate('form.'&login) & " no existe o no esta activo">
								<cfelse>
									<cfinclude template="recibo_unificar.cfm">
									<cfset resultado = ''>
									<!---<cftry>--->
										<cfscript>
											getAfiliacionEJB().inhabilitarUsuario(data.login,true);
										</cfscript>
										<!---<cfcatch> 
											<cfinclude template="../../../errorPages/BDerror.cfm">
											<cfabort>
										</cfcatch>
									</cftry>--->
								</cfif>
                                <cfif debug>
									resultado:
									<cfoutput>#resultado#</cfoutput>
								</cfif>
                            </cfif>
							<cfif len(trim(resultado)) eq 0>
								<cfset resultado = 'ok'>
							</cfif>
							<cfoutput>
	                            <input type="hidden" name="#status#"   value="#resultado#">
							</cfoutput>
					<cfif debug>
							</td>
						</tr>
					</cfif>
                </cfif>
            </cfif>
        </cfloop>
		<cfif debug>
			<tr>
				<td colspan="5">Proceso terminado. Para ver el resultado,
					haga clic en este bot&oacute;n</td>
			</tr>
			<tr>
				<td colspan="5" align="center"><input type="submit" value="Ver resultados">
				</td>
			</tr>
		</table>
	</cfif>
</form>
<cfif not debug>
	<script type="text/javascript">
	<!--
		document.f.submit();
	//-->
	</script>
</cfif>