<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
		Paquetes 
      &nbsp;
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Paquetes'>
	
			<script language="JavaScript1.2" type="text/javascript">
				function regresar(){
					document.form1.action="ListaPrecios.cfm"
					document.form1.submit();
				}
			</script>
			
			<cfif not isdefined("form.LPlinea") or Len(Trim(form.LPlinea)) eq 0 >
				<cflocation url="listaLPrecios.cfm">
			</cfif>

			<cfquery  name="rsDescripcion" datasource="#session.DSN#">
				select DLdescripcion 
				from DListaPrecios
				where LPlinea=<cfqueryparam value="#form.LPlinea#" cfsqltype="cf_sql_numeric">
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
			  <tr><td><font size="2" ><b><cfoutput>Lista de Precios: #rsDescripcion.DLdescripcion#</cfoutput></b></font></td></tr>
			  <tr>
			  	<td valign="top" width="30%">
					<cfinvoke 
					 component="sif.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="Paquetes p, Articulos a, Conceptos c, DListaPrecios lp"/>
						<cfinvokeargument name="columnas" value="convert(varchar,lp.LPid) as LPid, convert(varchar,p.LPlinea) as LPlinea, convert(varchar,p.Pid) as Pid, case isnull(p.Aid,0) when 0 then c.Cdescripcion else a.Adescripcion end as Descripcion, case isnull(p.Aid,0) when 0 then 'Concepto' else 'Artículo' end as Tipo"/>
						<cfinvokeargument name="desplegar" value="Descripcion,	Tipo"/>
						<cfinvokeargument name="etiquetas" value="Descripción,	Tipo"/>
						<cfinvokeargument name="formatos" value="S,S"/>
						<cfinvokeargument name="filtro" value="p.Aid *= a.Aid and p.Cid *= c.Cid and p.LPlinea = lp.LPlinea and p.LPlinea= #Form.LPlinea#"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="Paquetes.cfm"/>
					</cfinvoke>
				</td>
				<td>
					<cfinclude template="formPaquetes.cfm">
				</td>
			  </tr>
			</table> 
            	
		            </cf_web_portlet>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>