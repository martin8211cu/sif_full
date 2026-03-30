<!---  <cfdump var="#form#">--->
<cf_templateheader title="Interfaz Documentos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Interfaz Documentos'>
			<cfinclude template="../../sif/portlets/pNavegacion.cfm">
			<br><table width="99%" align="center" border="0" cellpadding="0" cellspacing="0"><tr><td>
			<cfset filtro = "">
			<cfinclude template="interfazSoin10-filtro.cfm">
			
			
			<cf_dbfunction name="to_char" args="ID" returnvariable="Lvar_to_char_ID">
			<cfquery name="rsQuery" datasource="sifinterfaces">
				select ID,
					case Modulo when 'CC' then 'Cuentas Por Cobrar' when 'CP' then 'Cuentas Por Pagar' end as ModuloL,
					CodigoTransacion,
					Documento,
					CodigoMoneda,
					FechaDocumento,
					montofact = ( select sum (PrecioTotal) from  ID10 where   IE10.ID =  ID10.ID),
					{fn concat('<a href="javascript: verinfo(',{fn concat(#Lvar_to_char_ID#,',0);"><img src=''/cfmx/sif/imagenes/Template.gif'' border=''0''></a>')})} as imagen,
					case StatusProceso 
							when 1 then '&nbsp;' 
							when 11 then  
							{fn concat('<a href="javascript: verError(',{fn concat(#Lvar_to_char_ID#,',0);"><img src=''/cfmx/sif/imagenes/deletestop.gif'' border=''0''></a>')})} 
							end as estado
							
				from IE10 
				where EcodigoSDC  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#">
				and StatusProceso in (1,11)  
				and exists (select 1 from ID10 where   IE10.ID =  ID10.ID)	
				<cfif isdefined("form.Modulo") and len(form.Modulo)>
					and Modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Modulo#">
				</cfif>
				<cfif isdefined("form.CodigoMoneda") and len(form.CodigoMoneda)>
					and upper(CodigoMoneda) like '%#UCase(Form.CodigoMoneda)#%' 
				</cfif>
				<cfif isdefined("form.Documento") and len(form.Documento)>
					and upper(Documento) like '%#UCase(Form.Documento)#%' 
				</cfif>
				order by Modulo,FechaDocumento			
			</cfquery>
			
			
			

			<form action="interfazSoin10-lista.cfm" method="post" name="lista" style="margin:0">
				<table width="1%" border="0">
					<tr>
						<td nowrap colspan="2">
						Los documentos que tengan este icono <img src="/cfmx/sif/imagenes/deletestop.gif" border="0"> es porque tiene algún error
						</td>
					</tr>
				</table>
				<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
					<cfinvokeargument name="query" 		value="#rsquery#"/>
					<cfinvokeargument name="desplegar" 	value="ID,CodigoTransacion,Documento,CodigoMoneda,FechaDocumento,montofact,imagen,estado"/>
					<cfinvokeargument name="etiquetas" 	value="ID,Transacción,Documento,Moneda,Fecha,Monto,&nbsp;,&nbsp;"/>
					<cfinvokeargument name="formatos" 	value="S,V,V,V,D,M,V,V"/>
					<cfinvokeargument name="align" 		value="left,left, left,left,left,right,right,right"/>
					<cfinvokeargument name="ajustar" 	value="N"/>
					<cfinvokeargument name="Cortes" 	value="ModuloL">
					<cfinvokeargument name="irA" 		value="interfazSoin10-lista.cfm"/>
					<cfinvokeargument name="keys" 		value="ID"/>
					<cfinvokeargument name="botones" 	value="PreCargar,Verificar,Aplicar"/>
					<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
					<cfinvokeargument name="showLink"  			value="false" >
					<cfinvokeargument name="formname" 			value="lista"/>
					<cfinvokeargument name="incluyeform" 		value="false"/>
				</cfinvoke>
			</form>
			<script language="JavaScript1.2" type="text/javascript">
				function funcVerificar() {
						var PARAM  = "ConsultaDocumentos.cfm?ID=-1";
						open(PARAM,'ConsultaDocumentos','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
						return false;
				}
				
				function funcAplicar() {
						document.lista.action = "interfazSoin10-sql.cfm";
						document.lista.submit();
				}
				
				function funcPreCargar() {
					document.lista.action = "interfazSoin10-sql.cfm";
					document.lista.submit();
				}

				function verinfo(llave){
					var PARAM  = "ConsultaDocumentos.cfm?ID="+ llave
					open(PARAM,'ConsultaDocumentos','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
				}
				
				function verError(llave){
					var PARAM  = "ConsultaError.cfm?ID="+ llave
					open(PARAM,'ConsultaDocumentos','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
				}
			</script>
			<br></td></tr></table>
		<cf_web_portlet_end>
	<cf_templatefooter>
