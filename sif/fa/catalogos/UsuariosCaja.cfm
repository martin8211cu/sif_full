<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Usuarios por Caja 
      &nbsp;
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Usuarios por Caja'>
	 

			<script language="JavaScript1.2" type="text/javascript">
				function regresar(){
					document.form1.action="Cajas.cfm"
					document.form1.submit();
				}
			</script>
			
			<cfif not isdefined("form.FCid") or Len(Trim(form.FCid)) eq 0 >
				<cflocation url="Cajas.cfm">
			</cfif>

			<cfquery  name="rsDescripcion" datasource="#session.DSN#">
				select FCcodigo 
				from FCajas
				where FCid=<cfqueryparam value="#form.FCid#" cfsqltype="cf_sql_numeric">
				  and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
			</cfquery>
		  
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td colspan="2">
					<cfoutput>
					<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##DFDFDF">
					  <tr align="left"> 
						<td><a href="/cfmx/sif/">SIF</a></td>
						<td>|</td>
						<td nowrap><a href="/cfmx/sif/fa/MenuFA.cfm">
						#Translate('ModuloFA','Facturaci&oacute;n','/sif/Utiles/Generales.xml')#
						</a></td>
						<td>|</td>
						<td width="100%"><a href="javascript:regresar();">
							#Translate('Regresar','Regresar','/sif/Utiles/Generales.xml')#	
						</a></td>
					  </tr>
					</table>
					</cfoutput>
				</td>
              </tr>
			  <tr><td><font size="2" ><b><cfoutput>Caja: #rsDescripcion.FCcodigo#</cfoutput></b></font></td></tr>
			  <tr>
			  	<td valign="top" width="30%">
					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="UsuariosCaja a, FCajas b"/>
						<cfinvokeargument name="columnas" value="b.FCcodigo, convert(varchar,a.FCid) FCid, convert(varchar,a.EUcodigo) EUcodigo, convert(varchar,a.Usucodigo) Usucodigo, a.Ulocalizacion, a.Usulogin"/>
						<cfinvokeargument name="desplegar" value="Usulogin"/>
						<cfinvokeargument name="etiquetas" value="Usuario"/>
						<cfinvokeargument name="formatos" value="S"/>
						<cfinvokeargument name="filtro" value="a.FCid = b.FCid and b.Ecodigo = #Session.Ecodigo# and a.FCid = #Form.FCid#"/>
						<cfinvokeargument name="align" value="left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="UsuariosCaja.cfm"/>
					</cfinvoke>
				</td>
				<td><cfinclude template="formUsuariosCaja.cfm"></td>
			  </tr>
			</table>
				
		            </cf_web_portlet>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>