<cf_templateheader title="Punto de Venta - Cierre de Supervisor">
	<cf_templatecss>
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Cierre de Cajas del Supervisor">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr align="center">
				<td  valign="top">
					<!--- Reporte --->
					<cfif isdefined("Form.FAM01COD") and len(trim(form.FAM01COD))>

						<cfif not isdefined("form.FechaCierre")>
							<cfset form.FechaCierre = LsDateFormat(now(), 'DD/MM/YYYY')>
						</cfif>
						<cf_rhimprime datos="/sif/pv/operacion/cierresup-form.cfm" paramsuri="&FAM01COD=#form.FAM01COD#&FechaCierre=#form.FechaCierre#">
						<cfinclude template="cierresup-form.cfm">
						<br />
						<br />
						<br />
						<br />
						<cfoutput>
						<form name="form2" action="cierresup-sql.cfm" method="post">							
							<input type="hidden" name="FAM01COD" value="#form.FAM01COD#">
							<input type="hidden" name="FechaCierre" value="#form.FechaCierre#">
							<cf_botones form="form2" values="Regresar,Aceptar Datos Cierre,Imprimir Cierre" names="Regresar,Aplicar,ImprimirRep">
						</form>
						</cfoutput>
						<script language="javascript" type="text/javascript">
							function funcImprimirRep() {
								document.form2.Aplicar.disabled=false;
								var s = '/cfmx/sif/Utiles/genImpr.cfm?archivo=/sif/pv/operacion/cierresup-form.cfm&imprimir=true';
								<cfoutput>
								s = s + '&FAM01COD=#form.FAM01COD#&FechaCierre=' + document.form1.FechaCierre.value + '&MODO=CAMBIO&ECODIGO=#Session.Ecodigo#';
								</cfoutput>
								printURL(s,'html');
								return false;
							}
							
							function funcAplicar() {
								document.form2.FechaCierre.value = document.form1.FechaCierre.value;
							}
						
							function funcRegresar(){
								document.form2.FAM01COD.value = "";
								document.form2.action = "cierresup.cfm";
							}
						</script>
					<cfelse>
			
					<!--- Lista --->
						<table width="100%" align="center" cellpadding="0" cellspacing="0"> 
				
							<tr align="center">
								<td  width="70%"valign="top">
								<table width="100%"valign="top"cellpadding="0" cellspacing="0"> 
									<tr align="center">
										<td width="100%"valign="top"><cfinclude template="cierresup-filtro.cfm"></td>
									</tr>
									<tr align="center">
									<td  width="100%"valign="top">

									<cfoutput>
										<cfquery name="rsCajas" datasource="#session.dsn#">
											select rtrim(FAM01COD) as FAM01COD, FAM01CODD, FAM01DES
											from FAM001 
											where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												<cfif isdefined("form.FAMcodigo") and len(trim(form.FAMcodigo)) gt 0>
													and ltrim(rtrim(upper(FAM01CODD))) like '%#trim(ucase(form.FAMcodigo))#%'</cfif>
												<cfif isdefined("form.FAMdescripcion") and len(trim(form.FAMdescripcion)) gt 0>
													and ltrim(rtrim(upper(FAM01DES))) like '%#trim(ucase(form.FAMdescripcion))#%'</cfif> 
									</cfquery>
										<cfinvoke 
										 component="sif.Componentes.pListas"
										 method="pListaQuery"
										 returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#rsCajas#"/>
										<cfinvokeargument name="desplegar" value=" FAM01CODD,FAM01DES"/>
										<cfinvokeargument name="etiquetas" value=" C&oacute;digo, Descripci&oacute;n"/>
										<cfinvokeargument name="formatos" value="V, V"/>
										<cfinvokeargument name="align" value="left, left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="irA" value="cierresup.cfm"/>
										<cfinvokeargument name="keys" value="FAM01COD"/>
										<cfinvokeargument name="showemptylistmsg" value="true"/>
										<cfinvokeargument name="maxrows" value="15"/>
										<cfinvokeargument name="navegacion" value="#nav#"/>
										</cfinvoke>
									</cfoutput>		
								</td></tr></table></td>
								<td  width="30%"valign="top" rowspan="2">
									<cf_web_portlet_start border="true" titulo="Cierre de cajas" skin="info1">
										&nbsp;<li>Seleccione una caja para realizar el cierre <strong></strong></li>
									<cf_web_portlet_end>
								</td>								
							</tr>						
					</cfif>
				</td>
			</tr>		
		</table>
		<script language="javascript1.2">			
			<cfif isdefined("Form.FAM01COD") and len(trim(form.FAM01COD))>
				document.form2.Aplicar.disabled=true;
			</cfif>
		</script>
		<cf_web_portlet_end>
<cf_templatefooter>
